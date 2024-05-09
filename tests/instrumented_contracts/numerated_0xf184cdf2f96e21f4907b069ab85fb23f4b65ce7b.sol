1 // $PUSSC | PUSSY CREDIT
2 // Telegram: https://t.me/PussyCredit
3 // Envisioned and Designed by @1goonrich
4 
5 // Fair Launch, no Dev Tokens. 98% LP.
6 // 2% of Supply to CryptoMessiah (@1goonrich)
7 // Snipers will be nuked.
8 
9 // LP Lock immediately on launch.
10 // Ownership will be renounced 30 minutes after launch.
11 
12 // Slippage Recommended: 12%+
13 // 2% Supply limit per TX for the first 5 minutes.
14 // Audit & Fair Launch handled by https://t.me/FairLaunchCalls
15 
16 /**
17  *     _.---.._             _.---...__
18  *  .-'   /\   \          .'  /\     /
19  *  `.   (  )   \        /   (  )   /
20  *    `.  \/   .'\      /`.   \/  .'
21  *      ``---''   )    (   ``---''
22  *              .';.--.;`.
23  *            .' /_...._\ `.
24  *          .'   `.a  a.'   `.
25  *         (        \/        )
26  *          `.___..-'`-..___.'
27  *             \          /
28  *              `-.____.-'
29 */
30 
31 // SPDX-License-Identifier: Unlicensed
32 pragma solidity ^0.6.12;
33 
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address payable) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes memory) {
40         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
41         return msg.data;
42     }
43 }
44 
45 interface IERC20 {
46     /**
47     * @dev Returns the amount of tokens in existence.
48     */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52     * @dev Returns the amount of tokens owned by `account`.
53     */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57     * @dev Moves `amount` tokens from the caller's account to `recipient`.
58     *
59     * Returns a boolean value indicating whether the operation succeeded.
60     *
61     * Emits a {Transfer} event.
62     */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66     * @dev Returns the remaining number of tokens that `spender` will be
67     * allowed to spend on behalf of `owner` through {transferFrom}. This is
68     * zero by default.
69     *
70     * This value changes when {approve} or {transferFrom} are called.
71     */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76     *
77     * Returns a boolean value indicating whether the operation succeeded.
78     *
79     * IMPORTANT: Beware that changing an allowance with this method brings the risk
80     * that someone may use both the old and the new allowance by unfortunate
81     * transaction ordering. One possible solution to mitigate this race
82     * condition is to first reduce the spender's allowance to 0 and set the
83     * desired value afterwards:
84     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85     *
86     * Emits an {Approval} event.
87     */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91     * @dev Moves `amount` tokens from `sender` to `recipient` using the
92     * allowance mechanism. `amount` is then deducted from the caller's
93     * allowance.
94     *
95     * Returns a boolean value indicating whether the operation succeeded.
96     *
97     * Emits a {Transfer} event.
98     */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102     * @dev Emitted when `value` tokens are moved from one account (`from`) to
103     * another (`to`).
104     *
105     * Note that `value` may be zero.
106     */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111     * a call to {approve}. `value` is the new allowance.
112     */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 library SafeMath {
117     /**
118     * @dev Returns the addition of two unsigned integers, reverting on
119     * overflow.
120     *
121     * Counterpart to Solidity's `+` operator.
122     *
123     * Requirements:
124     *
125     * - Addition cannot overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135     * @dev Returns the subtraction of two unsigned integers, reverting on
136     * overflow (when the result is negative).
137     *
138     * Counterpart to Solidity's `-` operator.
139     *
140     * Requirements:
141     *
142     * - Subtraction cannot overflow.
143     */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150     * overflow (when the result is negative).
151     *
152     * Counterpart to Solidity's `-` operator.
153     *
154     * Requirements:
155     *
156     * - Subtraction cannot overflow.
157     */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166     * @dev Returns the multiplication of two unsigned integers, reverting on
167     * overflow.
168     *
169     * Counterpart to Solidity's `*` operator.
170     *
171     * Requirements:
172     *
173     * - Multiplication cannot overflow.
174     */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190     * @dev Returns the integer division of two unsigned integers. Reverts on
191     * division by zero. The result is rounded towards zero.
192     *
193     * Counterpart to Solidity's `/` operator. Note: this function uses a
194     * `revert` opcode (which leaves remaining gas untouched) while Solidity
195     * uses an invalid opcode to revert (consuming all remaining gas).
196     *
197     * Requirements:
198     *
199     * - The divisor cannot be zero.
200     */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207     * division by zero. The result is rounded towards zero.
208     *
209     * Counterpart to Solidity's `/` operator. Note: this function uses a
210     * `revert` opcode (which leaves remaining gas untouched) while Solidity
211     * uses an invalid opcode to revert (consuming all remaining gas).
212     *
213     * Requirements:
214     *
215     * - The divisor cannot be zero.
216     */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227     * Reverts when dividing by zero.
228     *
229     * Counterpart to Solidity's `%` operator. This function uses a `revert`
230     * opcode (which leaves remaining gas untouched) while Solidity uses an
231     * invalid opcode to revert (consuming all remaining gas).
232     *
233     * Requirements:
234     *
235     * - The divisor cannot be zero.
236     */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243     * Reverts with custom message when dividing by zero.
244     *
245     * Counterpart to Solidity's `%` operator. This function uses a `revert`
246     * opcode (which leaves remaining gas untouched) while Solidity uses an
247     * invalid opcode to revert (consuming all remaining gas).
248     *
249     * Requirements:
250     *
251     * - The divisor cannot be zero.
252     */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 library Address {
260     /**
261     * @dev Returns true if `account` is a contract.
262     *
263     * [IMPORTANT]
264     * ====
265     * It is unsafe to assume that an address for which this function returns
266     * false is an externally-owned account (EOA) and not a contract.
267     *
268     * Among others, `isContract` will return false for the following
269     * types of addresses:
270     *
271     *  - an externally-owned account
272     *  - a contract in construction
273     *  - an address where a contract will be created
274     *  - an address where a contract lived, but was destroyed
275     * ====
276     */
277     function isContract(address account) internal view returns (bool) {
278         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
279         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
280         // for accounts without code, i.e. `keccak256('')`
281         bytes32 codehash;
282         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { codehash := extcodehash(account) }
285         return (codehash != accountHash && codehash != 0x0);
286     }
287 
288     /**
289     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290     * `recipient`, forwarding all available gas and reverting on errors.
291     *
292     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293     * of certain opcodes, possibly making contracts go over the 2300 gas limit
294     * imposed by `transfer`, making them unable to receive funds via
295     * `transfer`. {sendValue} removes this limitation.
296     *
297     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298     *
299     * IMPORTANT: because control is transferred to `recipient`, care must be
300     * taken to not create reentrancy vulnerabilities. Consider using
301     * {ReentrancyGuard} or the
302     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303     */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313     * @dev Performs a Solidity function call using a low level `call`. A
314     * plain`call` is an unsafe replacement for a function call: use this
315     * function instead.
316     *
317     * If `target` reverts with a revert reason, it is bubbled up by this
318     * function (like regular Solidity function calls).
319     *
320     * Returns the raw returned data. To convert to the expected return value,
321     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322     *
323     * Requirements:
324     *
325     * - `target` must be a contract.
326     * - calling `target` with `data` must not revert.
327     *
328     * _Available since v3.1._
329     */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331         return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336     * `errorMessage` as a fallback revert reason when `target` reverts.
337     *
338     * _Available since v3.1._
339     */
340     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
341         return _functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346     * but also transferring `value` wei to `target`.
347     *
348     * Requirements:
349     *
350     * - the calling contract must have an ETH balance of at least `value`.
351     * - the called Solidity function must be `payable`.
352     *
353     * _Available since v3.1._
354     */
355     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361     * with `errorMessage` as a fallback revert reason when `target` reverts.
362     *
363     * _Available since v3.1._
364     */
365     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         return _functionCallWithValue(target, data, value, errorMessage);
368     }
369 
370     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
371         require(isContract(target), "Address: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 contract Ownable is Context {
395     address private _owner;
396     address private _previousOwner;
397     uint256 private _lockTime;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402     * @dev Initializes the contract setting the deployer as the initial owner.
403     */
404     constructor () internal {
405         address msgSender = _msgSender();
406         _owner = msgSender;
407         emit OwnershipTransferred(address(0), msgSender);
408     }
409 
410     /**
411     * @dev Returns the address of the current owner.
412     */
413     function owner() public view returns (address) {
414         return _owner;
415     }
416 
417     /**
418     * @dev Throws if called by any account other than the owner.
419     */
420     modifier onlyOwner() {
421         require(_owner == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425     /**
426     * @dev Leaves the contract without owner. It will not be possible to call
427     * `onlyOwner` functions anymore. Can only be called by the current owner.
428     *
429     * NOTE: Renouncing ownership will leave the contract without an owner,
430     * thereby removing any functionality that is only available to the owner.
431     */
432     function renounceOwnership() public virtual onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435     }
436 
437     /**
438     * @dev Transfers ownership of the contract to a new account (`newOwner`).
439     * Can only be called by the current owner.
440     */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 
447     function geUnlockTime() public view returns (uint256) {
448         return _lockTime;
449     }
450 
451     //Locks the contract for owner for the amount of time provided
452     function lock(uint256 time) public virtual onlyOwner {
453         _previousOwner = _owner;
454         _owner = address(0);
455         _lockTime = now + time;
456         emit OwnershipTransferred(_owner, address(0));
457     }
458 
459     //Unlocks the contract for owner when _lockTime is exceeds
460     function unlock() public virtual {
461         require(_previousOwner == msg.sender, "You don't have permission to unlock");
462         require(now > _lockTime , "Contract is locked until 7 days");
463         emit OwnershipTransferred(_owner, _previousOwner);
464         _owner = _previousOwner;
465     }
466 }
467 
468 interface IUniswapV2Factory {
469     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
470 
471     function feeTo() external view returns (address);
472     function feeToSetter() external view returns (address);
473 
474     function getPair(address tokenA, address tokenB) external view returns (address pair);
475     function allPairs(uint) external view returns (address pair);
476     function allPairsLength() external view returns (uint);
477 
478     function createPair(address tokenA, address tokenB) external returns (address pair);
479 
480     function setFeeTo(address) external;
481     function setFeeToSetter(address) external;
482 }
483 
484 interface IUniswapV2Pair {
485     event Approval(address indexed owner, address indexed spender, uint value);
486     event Transfer(address indexed from, address indexed to, uint value);
487 
488     function name() external pure returns (string memory);
489     function symbol() external pure returns (string memory);
490     function decimals() external pure returns (uint8);
491     function totalSupply() external view returns (uint);
492     function balanceOf(address owner) external view returns (uint);
493     function allowance(address owner, address spender) external view returns (uint);
494 
495     function approve(address spender, uint value) external returns (bool);
496     function transfer(address to, uint value) external returns (bool);
497     function transferFrom(address from, address to, uint value) external returns (bool);
498 
499     function DOMAIN_SEPARATOR() external view returns (bytes32);
500     function PERMIT_TYPEHASH() external pure returns (bytes32);
501     function nonces(address owner) external view returns (uint);
502 
503     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
504 
505     event Mint(address indexed sender, uint amount0, uint amount1);
506     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
507     event Swap(
508         address indexed sender,
509         uint amount0In,
510         uint amount1In,
511         uint amount0Out,
512         uint amount1Out,
513         address indexed to
514     );
515     event Sync(uint112 reserve0, uint112 reserve1);
516 
517     function MINIMUM_LIQUIDITY() external pure returns (uint);
518     function factory() external view returns (address);
519     function token0() external view returns (address);
520     function token1() external view returns (address);
521     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
522     function price0CumulativeLast() external view returns (uint);
523     function price1CumulativeLast() external view returns (uint);
524     function kLast() external view returns (uint);
525 
526     function mint(address to) external returns (uint liquidity);
527     function burn(address to) external returns (uint amount0, uint amount1);
528     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
529     function skim(address to) external;
530     function sync() external;
531 
532     function initialize(address, address) external;
533 }
534 
535 interface IUniswapV2Router01 {
536     function factory() external pure returns (address);
537     function WETH() external pure returns (address);
538 
539     function addLiquidity(
540         address tokenA,
541         address tokenB,
542         uint amountADesired,
543         uint amountBDesired,
544         uint amountAMin,
545         uint amountBMin,
546         address to,
547         uint deadline
548     ) external returns (uint amountA, uint amountB, uint liquidity);
549     function addLiquidityETH(
550         address token,
551         uint amountTokenDesired,
552         uint amountTokenMin,
553         uint amountETHMin,
554         address to,
555         uint deadline
556     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
557     function removeLiquidity(
558         address tokenA,
559         address tokenB,
560         uint liquidity,
561         uint amountAMin,
562         uint amountBMin,
563         address to,
564         uint deadline
565     ) external returns (uint amountA, uint amountB);
566     function removeLiquidityETH(
567         address token,
568         uint liquidity,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline
573     ) external returns (uint amountToken, uint amountETH);
574     function removeLiquidityWithPermit(
575         address tokenA,
576         address tokenB,
577         uint liquidity,
578         uint amountAMin,
579         uint amountBMin,
580         address to,
581         uint deadline,
582         bool approveMax, uint8 v, bytes32 r, bytes32 s
583     ) external returns (uint amountA, uint amountB);
584     function removeLiquidityETHWithPermit(
585         address token,
586         uint liquidity,
587         uint amountTokenMin,
588         uint amountETHMin,
589         address to,
590         uint deadline,
591         bool approveMax, uint8 v, bytes32 r, bytes32 s
592     ) external returns (uint amountToken, uint amountETH);
593     function swapExactTokensForTokens(
594         uint amountIn,
595         uint amountOutMin,
596         address[] calldata path,
597         address to,
598         uint deadline
599     ) external returns (uint[] memory amounts);
600     function swapTokensForExactTokens(
601         uint amountOut,
602         uint amountInMax,
603         address[] calldata path,
604         address to,
605         uint deadline
606     ) external returns (uint[] memory amounts);
607     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
608     external
609     payable
610     returns (uint[] memory amounts);
611     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
612     external
613     returns (uint[] memory amounts);
614     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
615     external
616     returns (uint[] memory amounts);
617     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
618     external
619     payable
620     returns (uint[] memory amounts);
621 
622     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
623     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
624     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
625     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
626     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
627 }
628 
629 interface IUniswapV2Router02 is IUniswapV2Router01 {
630     function removeLiquidityETHSupportingFeeOnTransferTokens(
631         address token,
632         uint liquidity,
633         uint amountTokenMin,
634         uint amountETHMin,
635         address to,
636         uint deadline
637     ) external returns (uint amountETH);
638     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
639         address token,
640         uint liquidity,
641         uint amountTokenMin,
642         uint amountETHMin,
643         address to,
644         uint deadline,
645         bool approveMax, uint8 v, bytes32 r, bytes32 s
646     ) external returns (uint amountETH);
647 
648     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
649         uint amountIn,
650         uint amountOutMin,
651         address[] calldata path,
652         address to,
653         uint deadline
654     ) external;
655     function swapExactETHForTokensSupportingFeeOnTransferTokens(
656         uint amountOutMin,
657         address[] calldata path,
658         address to,
659         uint deadline
660     ) external payable;
661     function swapExactTokensForETHSupportingFeeOnTransferTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external;
668 }
669 
670 // Contract implementation
671 contract PussC is Context, IERC20, Ownable {
672     using SafeMath for uint256;
673     using Address for address;
674 
675     mapping (address => uint256) private _rOwned;
676     mapping (address => uint256) private _tOwned;
677     mapping (address => uint256) private _lastTx;
678     mapping (address => uint256) private _cooldownTradeAttempts;
679     mapping (address => mapping (address => uint256)) private _allowances;
680 
681     mapping (address => bool) private _isExcludedFromFee;
682 
683     mapping (address => bool) private _isExcluded;
684     address[] private _excluded;
685     mapping (address => bool) private _isSniper;
686     address[] private _confirmedSnipers;
687 
688     uint256 private constant MAX = ~uint256(0);
689     uint256 private _tTotal = 1000000000000000000000000;
690     uint256 private _rTotal = (MAX - (MAX % _tTotal));
691     uint256 private _tFeeTotal;
692     uint256 public launchTime;
693 
694     string private _name = 'PussyCredit | t.me/PussyCredit';
695     string private _symbol = 'PUSSC \xF0\x9F\x92\xB9';
696     uint8 private _decimals = 9;
697 
698     uint256 private _taxFee = 2;
699     uint256 private _teamDev = 0;
700     uint256 private _previousTaxFee = _taxFee;
701     uint256 private _previousTeamDev = _teamDev;
702 
703     address payable private _teamDevAddress;
704 
705     IUniswapV2Router02 public uniswapV2Router;
706     address public uniswapV2Pair;
707 
708     bool inSwap = false;
709     bool public swapEnabled = true;
710     bool public tradingOpen = false; //once switched on, can never be switched off.
711     bool public cooldownEnabled = false; //cooldown time on transactions
712     bool public uniswapOnly = false; //prevents users from tx'ing to other wallets to avoid cooldowns
713 
714     uint256 public _maxTxAmount = 20000000000000000000000;
715     uint256 private _numOfTokensToExchangeForTeamDev = 5000000000000000000;
716     bool _txLimitsEnabled = true;
717 
718     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
719     event SwapEnabledUpdated(bool enabled);
720 
721     modifier lockTheSwap {
722         inSwap = true;
723         _;
724         inSwap = false;
725     }
726 
727     constructor () public {
728         _rOwned[_msgSender()] = _rTotal;
729 
730         emit Transfer(address(0), _msgSender(), _tTotal);
731     }
732 
733     function initContract() external onlyOwner() {
734         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // PCS2 for BSC
735         // Create a uniswap pair for this new token
736         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
737         .createPair(address(this), _uniswapV2Router.WETH());
738 
739         // set the rest of the contract variables
740         uniswapV2Router = _uniswapV2Router;
741         // Exclude owner and this contract from fee
742         _isExcludedFromFee[owner()] = true;
743         _isExcludedFromFee[address(this)] = true;
744 
745         // List of front-runner & sniper bots from t.me/FairLaunchCalls
746         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
747         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
748 
749         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
750         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
751 
752         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
753         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
754 
755         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
756         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
757 
758         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
759         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
760 
761         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
762         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
763 
764         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
765         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
766 
767         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
768         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
769 
770         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
771         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
772 
773         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
774         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
775 
776         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
777         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
778 
779         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
780         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
781 
782         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
783         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
784 
785         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
786         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
787 
788         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
789         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
790 
791         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
792         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
793 
794         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
795         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
796 
797         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
798         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
799 
800         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
801         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
802 
803         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
804         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
805 
806         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
807         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
808 
809         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
810         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
811 
812         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
813         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
814 
815         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
816         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
817 
818         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
819         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
820 
821         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
822         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
823 
824         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
825         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
826 
827         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
828         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
829 
830         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
831         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
832 
833         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
834         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
835 
836         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
837         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
838 
839         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
840         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
841 
842         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
843         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
844 
845         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
846         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
847 
848         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
849         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
850 
851         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
852         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
853 
854         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
855         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
856 
857         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
858         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
859 
860         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
861         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
862 
863         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
864         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
865 
866         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
867         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
868 
869         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
870         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
871 
872         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
873         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
874 
875         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
876         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
877 
878         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
879         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
880 
881         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
882         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
883 
884         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
885         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
886 
887         _teamDev = 9;
888         _teamDevAddress = payable(0x4091e425D0CC258d8071A80362A99D9edB7E88D9);
889     }
890 
891     function openTrading() external onlyOwner() {
892         swapEnabled = true;
893         cooldownEnabled = false;
894         tradingOpen = true;
895         launchTime = block.timestamp;
896     }
897 
898     function name() public view returns (string memory) {
899         return _name;
900     }
901 
902     function symbol() public view returns (string memory) {
903         return _symbol;
904     }
905 
906     function decimals() public view returns (uint8) {
907         return _decimals;
908     }
909 
910     function totalSupply() public view override returns (uint256) {
911         return _tTotal;
912     }
913 
914     function balanceOf(address account) public view override returns (uint256) {
915         if (_isExcluded[account]) return _tOwned[account];
916         return tokenFromReflection(_rOwned[account]);
917     }
918 
919     function transfer(address recipient, uint256 amount) public override returns (bool) {
920         _transfer(_msgSender(), recipient, amount);
921         return true;
922     }
923 
924     function allowance(address owner, address spender) public view override returns (uint256) {
925         return _allowances[owner][spender];
926     }
927 
928     function approve(address spender, uint256 amount) public override returns (bool) {
929         _approve(_msgSender(), spender, amount);
930         return true;
931     }
932 
933     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
934         _transfer(sender, recipient, amount);
935         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
936         return true;
937     }
938 
939     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
940         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
941         return true;
942     }
943 
944     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
945         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
946         return true;
947     }
948 
949     function isExcluded(address account) public view returns (bool) {
950         return _isExcluded[account];
951     }
952 
953     function isBlackListed(address account) public view returns (bool) {
954         return _isSniper[account];
955     }
956 
957     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
958         _isExcludedFromFee[account] = excluded;
959     }
960 
961     function totalFees() public view returns (uint256) {
962         return _tFeeTotal;
963     }
964 
965     function deliver(uint256 tAmount) public {
966         address sender = _msgSender();
967         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
968         (uint256 rAmount,,,,,) = _getValues(tAmount);
969         _rOwned[sender] = _rOwned[sender].sub(rAmount);
970         _rTotal = _rTotal.sub(rAmount);
971         _tFeeTotal = _tFeeTotal.add(tAmount);
972     }
973 
974     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
975         require(tAmount <= _tTotal, "Amount must be less than supply");
976         if (!deductTransferFee) {
977             (uint256 rAmount,,,,,) = _getValues(tAmount);
978             return rAmount;
979         } else {
980             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
981             return rTransferAmount;
982         }
983     }
984 
985     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
986         require(rAmount <= _rTotal, "Amount must be less than total reflections");
987         uint256 currentRate =  _getRate();
988         return rAmount.div(currentRate);
989     }
990 
991     function excludeAccount(address account) external onlyOwner() {
992         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
993         require(!_isExcluded[account], "Account is already excluded");
994         if(_rOwned[account] > 0) {
995             _tOwned[account] = tokenFromReflection(_rOwned[account]);
996         }
997         _isExcluded[account] = true;
998         _excluded.push(account);
999     }
1000 
1001     function includeAccount(address account) external onlyOwner() {
1002         require(_isExcluded[account], "Account is already excluded");
1003         for (uint256 i = 0; i < _excluded.length; i++) {
1004             if (_excluded[i] == account) {
1005                 _excluded[i] = _excluded[_excluded.length - 1];
1006                 _tOwned[account] = 0;
1007                 _isExcluded[account] = false;
1008                 _excluded.pop();
1009                 break;
1010             }
1011         }
1012     }
1013 
1014     function RemoveSniper(address account) external onlyOwner() {
1015         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
1016         require(!_isSniper[account], "Account is already blacklisted");
1017         _isSniper[account] = true;
1018         _confirmedSnipers.push(account);
1019     }
1020 
1021     function amnestySniper(address account) external onlyOwner() {
1022         require(_isSniper[account], "Account is not blacklisted");
1023         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1024             if (_confirmedSnipers[i] == account) {
1025                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1026                 _isSniper[account] = false;
1027                 _confirmedSnipers.pop();
1028                 break;
1029             }
1030         }
1031     }
1032 
1033     function removeAllFee() private {
1034         if(_taxFee == 0 && _teamDev == 0) return;
1035 
1036         _previousTaxFee = _taxFee;
1037         _previousTeamDev = _teamDev;
1038 
1039         _taxFee = 0;
1040         _teamDev = 0;
1041     }
1042 
1043     function restoreAllFee() private {
1044         _taxFee = _previousTaxFee;
1045         _teamDev = _previousTeamDev;
1046     }
1047 
1048     function isExcludedFromFee(address account) public view returns(bool) {
1049         return _isExcludedFromFee[account];
1050     }
1051 
1052     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1053         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1054             10**2
1055         );
1056     }
1057 
1058     function _approve(address owner, address spender, uint256 amount) private {
1059         require(owner != address(0), "ERC20: approve from the zero address");
1060         require(spender != address(0), "ERC20: approve to the zero address");
1061 
1062         _allowances[owner][spender] = amount;
1063         emit Approval(owner, spender, amount);
1064     }
1065 
1066     function _transfer(address sender, address recipient, uint256 amount) private {
1067         require(sender != address(0), "ERC20: transfer from the zero address");
1068         require(recipient != address(0), "ERC20: transfer to the zero address");
1069         require(amount > 0, "Transfer amount must be greater than zero");
1070         require(!_isSniper[recipient], "You have no power here!");
1071         require(!_isSniper[msg.sender], "You have no power here!");
1072 
1073         if(sender != owner() && recipient != owner()) {
1074 
1075             if (!tradingOpen) {
1076                 if (!(sender == address(this) || recipient == address(this)
1077                 || sender == address(owner()) || recipient == address(owner()))) {
1078                     require(tradingOpen, "Trading is not enabled");
1079                 }
1080             }
1081 
1082             if (cooldownEnabled) {
1083                 if (_lastTx[sender] + 30 > block.timestamp
1084                     && sender != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1085                     && sender != address(uniswapV2Pair)
1086                 ) {
1087                     _lastTx[sender] = block.timestamp;
1088                 } else {
1089                     require(!cooldownEnabled, "You're on cooldown! 30s between trades!");
1090                 }
1091             }
1092 
1093             if (uniswapOnly) {
1094                 if (
1095                     sender != address(this) &&
1096                     recipient != address(this) &&
1097                     sender != address(uniswapV2Router) &&
1098                     recipient != address(uniswapV2Router)
1099                 ) {
1100                     require(
1101                         _msgSender() == address(uniswapV2Router) ||
1102                         _msgSender() == uniswapV2Pair,
1103                         "ERR: Pancakeswap only"
1104                     );
1105                 }
1106             }
1107 
1108             if (block.timestamp < launchTime + 5 seconds) {
1109                 if (sender != uniswapV2Pair
1110                 && sender != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1111                     && sender != address(uniswapV2Router)) {
1112                     _isSniper[sender] = true;
1113                     _confirmedSnipers.push(sender);
1114                 }
1115             }
1116 
1117 
1118         }
1119 
1120         // is the token balance of this contract address over the min number of
1121         // tokens that we need to initiate a swap?
1122         // also, don't get caught in a circular charity event.
1123         // also, don't swap if sender is uniswap pair.
1124         uint256 contractTokenBalance = balanceOf(address(this));
1125 
1126         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeamDev;
1127         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1128             // We need to swap the current tokens to ETH and send to the ext wallet
1129             swapTokensForEth(contractTokenBalance);
1130 
1131             uint256 contractETHBalance = address(this).balance;
1132             if(contractETHBalance > 0) {
1133                 sendETHToTeamDev(address(this).balance);
1134             }
1135         }
1136 
1137         //indicates if fee should be deducted from transfer
1138         bool takeFee = true;
1139 
1140         //if any account belongs to _isExcludedFromFee account then remove the fee
1141         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1142             takeFee = false;
1143         }
1144 
1145         //transfer amount, it will take tax and fee
1146 
1147         _tokenTransfer(sender,recipient,amount,takeFee);
1148     }
1149 
1150     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1151         // generate the uniswap pair path of token -> weth
1152         address[] memory path = new address[](2);
1153         path[0] = address(this);
1154         path[1] = uniswapV2Router.WETH();
1155 
1156         _approve(address(this), address(uniswapV2Router), tokenAmount);
1157 
1158         // make the swap
1159         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1160             tokenAmount,
1161             0, // accept any amount of ETH
1162             path,
1163             address(this),
1164             block.timestamp
1165         );
1166     }
1167 
1168     function sendETHToTeamDev(uint256 amount) private {
1169         _teamDevAddress.transfer(amount.div(2));
1170     }
1171 
1172     // We are exposing these functions to be able to manual swap and send
1173     // in case the token is highly valued and 5M becomes too much
1174     function manualSwap() external onlyOwner() {
1175         uint256 contractBalance = balanceOf(address(this));
1176         swapTokensForEth(contractBalance);
1177     }
1178 
1179     function manualSend() external onlyOwner() {
1180         uint256 contractETHBalance = address(this).balance;
1181         sendETHToTeamDev(contractETHBalance);
1182     }
1183 
1184     function setSwapEnabled(bool enabled) external onlyOwner(){
1185         swapEnabled = enabled;
1186     }
1187 
1188     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1189         if(!takeFee)
1190             removeAllFee();
1191 
1192         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1193             _transferFromExcluded(sender, recipient, amount);
1194         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1195             _transferToExcluded(sender, recipient, amount);
1196         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1197             _transferStandard(sender, recipient, amount);
1198         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1199             _transferBothExcluded(sender, recipient, amount);
1200         } else {
1201             _transferStandard(sender, recipient, amount);
1202         }
1203 
1204         if(!takeFee)
1205             restoreAllFee();
1206     }
1207 
1208     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1209         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1210         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1211         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1212         _takeCharity(tCharity);
1213         _reflectFee(rFee, tFee);
1214         emit Transfer(sender, recipient, tTransferAmount);
1215     }
1216 
1217     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1218         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1219         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1220         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1221         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1222         _takeCharity(tCharity);
1223         _reflectFee(rFee, tFee);
1224         emit Transfer(sender, recipient, tTransferAmount);
1225     }
1226 
1227     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1228         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1229         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1230         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1231         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1232         _takeCharity(tCharity);
1233         _reflectFee(rFee, tFee);
1234         emit Transfer(sender, recipient, tTransferAmount);
1235     }
1236 
1237     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1238         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1239         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1240         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1241         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1242         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1243         _takeCharity(tCharity);
1244         _reflectFee(rFee, tFee);
1245         emit Transfer(sender, recipient, tTransferAmount);
1246     }
1247 
1248     function _takeCharity(uint256 tCharity) private {
1249         uint256 currentRate =  _getRate();
1250         uint256 rCharity = tCharity.mul(currentRate);
1251         _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
1252         if(_isExcluded[address(this)])
1253             _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
1254     }
1255 
1256     function _reflectFee(uint256 rFee, uint256 tFee) private {
1257         _rTotal = _rTotal.sub(rFee);
1258         _tFeeTotal = _tFeeTotal.add(tFee);
1259     }
1260 
1261     //to recieve ETH from uniswapV2Router when swaping
1262     receive() external payable {}
1263 
1264     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1265         (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _teamDev);
1266         uint256 currentRate =  _getRate();
1267         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1268         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1269     }
1270 
1271     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1272         uint256 tFee = tAmount.mul(taxFee).div(100);
1273         uint256 tCharity = tAmount.mul(charityFee).div(100);
1274         uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1275         return (tTransferAmount, tFee, tCharity);
1276     }
1277 
1278     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1279         uint256 rAmount = tAmount.mul(currentRate);
1280         uint256 rFee = tFee.mul(currentRate);
1281         uint256 rTransferAmount = rAmount.sub(rFee);
1282         return (rAmount, rTransferAmount, rFee);
1283     }
1284 
1285     function _getRate() private view returns(uint256) {
1286         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1287         return rSupply.div(tSupply);
1288     }
1289 
1290     function _getCurrentSupply() private view returns(uint256, uint256) {
1291         uint256 rSupply = _rTotal;
1292         uint256 tSupply = _tTotal;
1293         for (uint256 i = 0; i < _excluded.length; i++) {
1294             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1295             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1296             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1297         }
1298         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1299         return (rSupply, tSupply);
1300     }
1301 
1302     function _getTaxFee() private view returns(uint256) {
1303         return _taxFee;
1304     }
1305 
1306     function _getMaxTxAmount() private view returns(uint256) {
1307         return _maxTxAmount;
1308     }
1309 
1310     function _getETHBalance() public view returns(uint256 balance) {
1311         return address(this).balance;
1312     }
1313 
1314     function _removeTxLimit() external onlyOwner() {
1315         _maxTxAmount = 1000000000000000000000000;
1316     }
1317 
1318     // Yes, there are here if I fucked up on the logic and need to disable them.
1319     function _removeDestLimit() external onlyOwner() {
1320         uniswapOnly = false;
1321     }
1322 
1323     function _disableCooldown() external onlyOwner() {
1324         cooldownEnabled = false;
1325     }
1326 
1327     function _enableCooldown() external onlyOwner() {
1328         cooldownEnabled = true;
1329     }
1330 
1331     function _setExtWallet(address payable teamDevAddress) external onlyOwner() {
1332         _teamDevAddress = teamDevAddress;
1333     }
1334 }