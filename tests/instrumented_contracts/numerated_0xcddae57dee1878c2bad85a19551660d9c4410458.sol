1 // $BLINK is The First Girl Group Themed Meme Token
2 
3 // TG: https://t.me/blinkinu_official
4 // Twitter: https://twitter.com/BlinkInuCoin
5 // Website: https://blinkinu.com/
6 // Instagram: https://www.instagram.com/blinkinu_official
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.6.12;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address payable) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23     /**
24     * @dev Returns the amount of tokens in existence.
25     */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29     * @dev Returns the amount of tokens owned by `account`.
30     */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34     * @dev Moves `amount` tokens from the caller's account to `recipient`.
35     *
36     * Returns a boolean value indicating whether the operation succeeded.
37     *
38     * Emits a {Transfer} event.
39     */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43     * @dev Returns the remaining number of tokens that `spender` will be
44     * allowed to spend on behalf of `owner` through {transferFrom}. This is
45     * zero by default.
46     *
47     * This value changes when {approve} or {transferFrom} are called.
48     */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53     *
54     * Returns a boolean value indicating whether the operation succeeded.
55     *
56     * IMPORTANT: Beware that changing an allowance with this method brings the risk
57     * that someone may use both the old and the new allowance by unfortunate
58     * transaction ordering. One possible solution to mitigate this race
59     * condition is to first reduce the spender's allowance to 0 and set the
60     * desired value afterwards:
61     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62     *
63     * Emits an {Approval} event.
64     */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68     * @dev Moves `amount` tokens from `sender` to `recipient` using the
69     * allowance mechanism. `amount` is then deducted from the caller's
70     * allowance.
71     *
72     * Returns a boolean value indicating whether the operation succeeded.
73     *
74     * Emits a {Transfer} event.
75     */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79     * @dev Emitted when `value` tokens are moved from one account (`from`) to
80     * another (`to`).
81     *
82     * Note that `value` may be zero.
83     */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88     * a call to {approve}. `value` is the new allowance.
89     */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 library SafeMath {
94     /**
95     * @dev Returns the addition of two unsigned integers, reverting on
96     * overflow.
97     *
98     * Counterpart to Solidity's `+` operator.
99     *
100     * Requirements:
101     *
102     * - Addition cannot overflow.
103     */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112     * @dev Returns the subtraction of two unsigned integers, reverting on
113     * overflow (when the result is negative).
114     *
115     * Counterpart to Solidity's `-` operator.
116     *
117     * Requirements:
118     *
119     * - Subtraction cannot overflow.
120     */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127     * overflow (when the result is negative).
128     *
129     * Counterpart to Solidity's `-` operator.
130     *
131     * Requirements:
132     *
133     * - Subtraction cannot overflow.
134     */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143     * @dev Returns the multiplication of two unsigned integers, reverting on
144     * overflow.
145     *
146     * Counterpart to Solidity's `*` operator.
147     *
148     * Requirements:
149     *
150     * - Multiplication cannot overflow.
151     */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167     * @dev Returns the integer division of two unsigned integers. Reverts on
168     * division by zero. The result is rounded towards zero.
169     *
170     * Counterpart to Solidity's `/` operator. Note: this function uses a
171     * `revert` opcode (which leaves remaining gas untouched) while Solidity
172     * uses an invalid opcode to revert (consuming all remaining gas).
173     *
174     * Requirements:
175     *
176     * - The divisor cannot be zero.
177     */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184     * division by zero. The result is rounded towards zero.
185     *
186     * Counterpart to Solidity's `/` operator. Note: this function uses a
187     * `revert` opcode (which leaves remaining gas untouched) while Solidity
188     * uses an invalid opcode to revert (consuming all remaining gas).
189     *
190     * Requirements:
191     *
192     * - The divisor cannot be zero.
193     */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204     * Reverts when dividing by zero.
205     *
206     * Counterpart to Solidity's `%` operator. This function uses a `revert`
207     * opcode (which leaves remaining gas untouched) while Solidity uses an
208     * invalid opcode to revert (consuming all remaining gas).
209     *
210     * Requirements:
211     *
212     * - The divisor cannot be zero.
213     */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220     * Reverts with custom message when dividing by zero.
221     *
222     * Counterpart to Solidity's `%` operator. This function uses a `revert`
223     * opcode (which leaves remaining gas untouched) while Solidity uses an
224     * invalid opcode to revert (consuming all remaining gas).
225     *
226     * Requirements:
227     *
228     * - The divisor cannot be zero.
229     */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 library Address {
237     /**
238     * @dev Returns true if `account` is a contract.
239     *
240     * [IMPORTANT]
241     * ====
242     * It is unsafe to assume that an address for which this function returns
243     * false is an externally-owned account (EOA) and not a contract.
244     *
245     * Among others, `isContract` will return false for the following
246     * types of addresses:
247     *
248     *  - an externally-owned account
249     *  - a contract in construction
250     *  - an address where a contract will be created
251     *  - an address where a contract lived, but was destroyed
252     * ====
253     */
254     function isContract(address account) internal view returns (bool) {
255         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
256         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
257         // for accounts without code, i.e. `keccak256('')`
258         bytes32 codehash;
259         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
260         // solhint-disable-next-line no-inline-assembly
261         assembly { codehash := extcodehash(account) }
262         return (codehash != accountHash && codehash != 0x0);
263     }
264 
265     /**
266     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267     * `recipient`, forwarding all available gas and reverting on errors.
268     *
269     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270     * of certain opcodes, possibly making contracts go over the 2300 gas limit
271     * imposed by `transfer`, making them unable to receive funds via
272     * `transfer`. {sendValue} removes this limitation.
273     *
274     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275     *
276     * IMPORTANT: because control is transferred to `recipient`, care must be
277     * taken to not create reentrancy vulnerabilities. Consider using
278     * {ReentrancyGuard} or the
279     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280     */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
285         (bool success, ) = recipient.call{ value: amount }("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290     * @dev Performs a Solidity function call using a low level `call`. A
291     * plain`call` is an unsafe replacement for a function call: use this
292     * function instead.
293     *
294     * If `target` reverts with a revert reason, it is bubbled up by this
295     * function (like regular Solidity function calls).
296     *
297     * Returns the raw returned data. To convert to the expected return value,
298     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299     *
300     * Requirements:
301     *
302     * - `target` must be a contract.
303     * - calling `target` with `data` must not revert.
304     *
305     * _Available since v3.1._
306     */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308     return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313     * `errorMessage` as a fallback revert reason when `target` reverts.
314     *
315     * _Available since v3.1._
316     */
317     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
318         return _functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323     * but also transferring `value` wei to `target`.
324     *
325     * Requirements:
326     *
327     * - the calling contract must have an ETH balance of at least `value`.
328     * - the called Solidity function must be `payable`.
329     *
330     * _Available since v3.1._
331     */
332     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
334     }
335 
336     /**
337     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338     * with `errorMessage` as a fallback revert reason when `target` reverts.
339     *
340     * _Available since v3.1._
341     */
342     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         return _functionCallWithValue(target, data, value, errorMessage);
345     }
346 
347     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
348         require(isContract(target), "Address: call to non-contract");
349 
350         // solhint-disable-next-line avoid-low-level-calls
351         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
352         if (success) {
353             return returndata;
354         } else {
355             // Look for revert reason and bubble it up if present
356             if (returndata.length > 0) {
357                 // The easiest way to bubble the revert reason is using memory via assembly
358 
359                 // solhint-disable-next-line no-inline-assembly
360                 assembly {
361                     let returndata_size := mload(returndata)
362                     revert(add(32, returndata), returndata_size)
363                 }
364             } else {
365                 revert(errorMessage);
366             }
367         }
368     }
369 }
370 
371 contract Ownable is Context {
372     address private _owner;
373     address private _previousOwner;
374     uint256 private _lockTime;
375 
376     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
377 
378     /**
379     * @dev Initializes the contract setting the deployer as the initial owner.
380     */
381     constructor () internal {
382         address msgSender = _msgSender();
383         _owner = msgSender;
384         emit OwnershipTransferred(address(0), msgSender);
385     }
386 
387     /**
388     * @dev Returns the address of the current owner.
389     */
390     function owner() public view returns (address) {
391         return _owner;
392     }
393 
394     /**
395     * @dev Throws if called by any account other than the owner.
396     */
397     modifier onlyOwner() {
398         require(_owner == _msgSender(), "Ownable: caller is not the owner");
399         _;
400     }
401 
402     /**
403     * @dev Leaves the contract without owner. It will not be possible to call
404     * `onlyOwner` functions anymore. Can only be called by the current owner.
405     *
406     * NOTE: Renouncing ownership will leave the contract without an owner,
407     * thereby removing any functionality that is only available to the owner.
408     */
409     function renounceOwnership() public virtual onlyOwner {
410         emit OwnershipTransferred(_owner, address(0));
411         _owner = address(0);
412     }
413 
414     /**
415     * @dev Transfers ownership of the contract to a new account (`newOwner`).
416     * Can only be called by the current owner.
417     */
418     function transferOwnership(address newOwner) public virtual onlyOwner {
419         require(newOwner != address(0), "Ownable: new owner is the zero address");
420         emit OwnershipTransferred(_owner, newOwner);
421         _owner = newOwner;
422     }
423 
424     function geUnlockTime() public view returns (uint256) {
425         return _lockTime;
426     }
427 
428     //Locks the contract for owner for the amount of time provided
429     function lock(uint256 time) public virtual onlyOwner {
430         _previousOwner = _owner;
431         _owner = address(0);
432         _lockTime = now + time;
433         emit OwnershipTransferred(_owner, address(0));
434     }
435     
436     //Unlocks the contract for owner when _lockTime is exceeds
437     function unlock() public virtual {
438         require(_previousOwner == msg.sender, "You don't have permission to unlock");
439         require(now > _lockTime , "Contract is locked until 7 days");
440         emit OwnershipTransferred(_owner, _previousOwner);
441         _owner = _previousOwner;
442     }
443 }  
444 
445 interface IUniswapV2Factory {
446     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
447 
448     function feeTo() external view returns (address);
449     function feeToSetter() external view returns (address);
450 
451     function getPair(address tokenA, address tokenB) external view returns (address pair);
452     function allPairs(uint) external view returns (address pair);
453     function allPairsLength() external view returns (uint);
454 
455     function createPair(address tokenA, address tokenB) external returns (address pair);
456 
457     function setFeeTo(address) external;
458     function setFeeToSetter(address) external;
459 } 
460 
461 interface IUniswapV2Pair {
462     event Approval(address indexed owner, address indexed spender, uint value);
463     event Transfer(address indexed from, address indexed to, uint value);
464 
465     function name() external pure returns (string memory);
466     function symbol() external pure returns (string memory);
467     function decimals() external pure returns (uint8);
468     function totalSupply() external view returns (uint);
469     function balanceOf(address owner) external view returns (uint);
470     function allowance(address owner, address spender) external view returns (uint);
471 
472     function approve(address spender, uint value) external returns (bool);
473     function transfer(address to, uint value) external returns (bool);
474     function transferFrom(address from, address to, uint value) external returns (bool);
475 
476     function DOMAIN_SEPARATOR() external view returns (bytes32);
477     function PERMIT_TYPEHASH() external pure returns (bytes32);
478     function nonces(address owner) external view returns (uint);
479 
480     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
481 
482     event Mint(address indexed sender, uint amount0, uint amount1);
483     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
484     event Swap(
485         address indexed sender,
486         uint amount0In,
487         uint amount1In,
488         uint amount0Out,
489         uint amount1Out,
490         address indexed to
491     );
492     event Sync(uint112 reserve0, uint112 reserve1);
493 
494     function MINIMUM_LIQUIDITY() external pure returns (uint);
495     function factory() external view returns (address);
496     function token0() external view returns (address);
497     function token1() external view returns (address);
498     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
499     function price0CumulativeLast() external view returns (uint);
500     function price1CumulativeLast() external view returns (uint);
501     function kLast() external view returns (uint);
502 
503     function mint(address to) external returns (uint liquidity);
504     function burn(address to) external returns (uint amount0, uint amount1);
505     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
506     function skim(address to) external;
507     function sync() external;
508 
509     function initialize(address, address) external;
510 }
511 
512 interface IUniswapV2Router01 {
513     function factory() external pure returns (address);
514     function WETH() external pure returns (address);
515 
516     function addLiquidity(
517         address tokenA,
518         address tokenB,
519         uint amountADesired,
520         uint amountBDesired,
521         uint amountAMin,
522         uint amountBMin,
523         address to,
524         uint deadline
525     ) external returns (uint amountA, uint amountB, uint liquidity);
526     function addLiquidityETH(
527         address token,
528         uint amountTokenDesired,
529         uint amountTokenMin,
530         uint amountETHMin,
531         address to,
532         uint deadline
533     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
534     function removeLiquidity(
535         address tokenA,
536         address tokenB,
537         uint liquidity,
538         uint amountAMin,
539         uint amountBMin,
540         address to,
541         uint deadline
542     ) external returns (uint amountA, uint amountB);
543     function removeLiquidityETH(
544         address token,
545         uint liquidity,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline
550     ) external returns (uint amountToken, uint amountETH);
551     function removeLiquidityWithPermit(
552         address tokenA,
553         address tokenB,
554         uint liquidity,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline,
559         bool approveMax, uint8 v, bytes32 r, bytes32 s
560     ) external returns (uint amountA, uint amountB);
561     function removeLiquidityETHWithPermit(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline,
568         bool approveMax, uint8 v, bytes32 r, bytes32 s
569     ) external returns (uint amountToken, uint amountETH);
570     function swapExactTokensForTokens(
571         uint amountIn,
572         uint amountOutMin,
573         address[] calldata path,
574         address to,
575         uint deadline
576     ) external returns (uint[] memory amounts);
577     function swapTokensForExactTokens(
578         uint amountOut,
579         uint amountInMax,
580         address[] calldata path,
581         address to,
582         uint deadline
583     ) external returns (uint[] memory amounts);
584     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
585         external
586         payable
587         returns (uint[] memory amounts);
588     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
589         external
590         returns (uint[] memory amounts);
591     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
592         external
593         returns (uint[] memory amounts);
594     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
595         external
596         payable
597         returns (uint[] memory amounts);
598 
599     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
600     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
601     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
602     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
603     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
604 }
605 
606 interface IUniswapV2Router02 is IUniswapV2Router01 {
607     function removeLiquidityETHSupportingFeeOnTransferTokens(
608         address token,
609         uint liquidity,
610         uint amountTokenMin,
611         uint amountETHMin,
612         address to,
613         uint deadline
614     ) external returns (uint amountETH);
615     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
616         address token,
617         uint liquidity,
618         uint amountTokenMin,
619         uint amountETHMin,
620         address to,
621         uint deadline,
622         bool approveMax, uint8 v, bytes32 r, bytes32 s
623     ) external returns (uint amountETH);
624 
625     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
626         uint amountIn,
627         uint amountOutMin,
628         address[] calldata path,
629         address to,
630         uint deadline
631     ) external;
632     function swapExactETHForTokensSupportingFeeOnTransferTokens(
633         uint amountOutMin,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external payable;
638     function swapExactTokensForETHSupportingFeeOnTransferTokens(
639         uint amountIn,
640         uint amountOutMin,
641         address[] calldata path,
642         address to,
643         uint deadline
644     ) external;
645 }
646 
647 // Contract implementation
648 contract BlinkInu is Context, IERC20, Ownable {
649     using SafeMath for uint256;
650     using Address for address;
651 
652     mapping (address => uint256) private _rOwned;
653     mapping (address => uint256) private _tOwned;
654     mapping (address => mapping (address => uint256)) private _allowances;
655 
656     mapping (address => bool) private _isExcludedFromFee;
657 
658     mapping (address => bool) private _isExcluded;
659     address[] private _excluded;
660 
661     uint256 private constant MAX = ~uint256(0);
662     uint256 private _tTotal = 1000000000000 * 10**9;
663     uint256 private _rTotal = (MAX - (MAX % _tTotal));
664     uint256 private _tFeeTotal;
665 
666     string private _name = 'Blink Inu | t.me/blinkinu_official';
667     string private _symbol = 'BLINK';
668     uint8 private _decimals = 9;
669     
670     // Tax and team fees will start at 0 so we don't have a big impact when deploying to Uniswap
671     // Team wallet address is null but the method to set the address is exposed
672     uint256 private _taxFee = 5; 
673     uint256 private _teamFee = 8;
674     uint256 private _previousTaxFee = _taxFee;
675     uint256 private _previousTeamFee = _teamFee;
676 
677     address payable public _teamWalletAddress;
678     address payable public _marketingWalletAddress;
679     
680     IUniswapV2Router02 public immutable uniswapV2Router;
681     address public immutable uniswapV2Pair;
682 
683     bool inSwap = false;
684     bool public swapEnabled = true;
685 
686     uint256 private _maxTxAmount = 10000000000e9;
687     // We will set a minimum amount of tokens to be swaped => 5M
688     uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
689 
690     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
691     event SwapEnabledUpdated(bool enabled);
692 
693     modifier lockTheSwap {
694         inSwap = true;
695         _;
696         inSwap = false;
697     }
698 
699     constructor (address payable teamWalletAddress, address payable marketingWalletAddress) public {
700         _teamWalletAddress = teamWalletAddress;
701         _marketingWalletAddress = marketingWalletAddress;
702         _rOwned[_msgSender()] = _rTotal;
703 
704         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
705         // Create a uniswap pair for this new token
706         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
707             .createPair(address(this), _uniswapV2Router.WETH());
708 
709         // set the rest of the contract variables
710         uniswapV2Router = _uniswapV2Router;
711 
712         // Exclude owner and this contract from fee
713         _isExcludedFromFee[owner()] = true;
714         _isExcludedFromFee[address(this)] = true;
715 
716         emit Transfer(address(0), _msgSender(), _tTotal);
717     }
718 
719     function name() public view returns (string memory) {
720         return _name;
721     }
722 
723     function symbol() public view returns (string memory) {
724         return _symbol;
725     }
726 
727     function decimals() public view returns (uint8) {
728         return _decimals;
729     }
730 
731     function totalSupply() public view override returns (uint256) {
732         return _tTotal;
733     }
734 
735     function balanceOf(address account) public view override returns (uint256) {
736         if (_isExcluded[account]) return _tOwned[account];
737         return tokenFromReflection(_rOwned[account]);
738     }
739 
740     function transfer(address recipient, uint256 amount) public override returns (bool) {
741         _transfer(_msgSender(), recipient, amount);
742         return true;
743     }
744 
745     function allowance(address owner, address spender) public view override returns (uint256) {
746         return _allowances[owner][spender];
747     }
748 
749     function approve(address spender, uint256 amount) public override returns (bool) {
750         _approve(_msgSender(), spender, amount);
751         return true;
752     }
753 
754     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
755         _transfer(sender, recipient, amount);
756         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
757         return true;
758     }
759 
760     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
761         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
762         return true;
763     }
764 
765     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
766         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
767         return true;
768     }
769 
770     function isExcluded(address account) public view returns (bool) {
771         return _isExcluded[account];
772     }
773 
774     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
775         _isExcludedFromFee[account] = excluded;
776     }
777 
778     function totalFees() public view returns (uint256) {
779         return _tFeeTotal;
780     }
781 
782     function deliver(uint256 tAmount) public {
783         address sender = _msgSender();
784         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
785         (uint256 rAmount,,,,,) = _getValues(tAmount);
786         _rOwned[sender] = _rOwned[sender].sub(rAmount);
787         _rTotal = _rTotal.sub(rAmount);
788         _tFeeTotal = _tFeeTotal.add(tAmount);
789     }
790 
791     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
792         require(tAmount <= _tTotal, "Amount must be less than supply");
793         if (!deductTransferFee) {
794             (uint256 rAmount,,,,,) = _getValues(tAmount);
795             return rAmount;
796         } else {
797             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
798             return rTransferAmount;
799         }
800     }
801 
802     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
803         require(rAmount <= _rTotal, "Amount must be less than total reflections");
804         uint256 currentRate =  _getRate();
805         return rAmount.div(currentRate);
806     }
807 
808     function excludeAccount(address account) external onlyOwner() {
809         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
810         require(!_isExcluded[account], "Account is already excluded");
811         if(_rOwned[account] > 0) {
812             _tOwned[account] = tokenFromReflection(_rOwned[account]);
813         }
814         _isExcluded[account] = true;
815         _excluded.push(account);
816     }
817 
818     function includeAccount(address account) external onlyOwner() {
819         require(_isExcluded[account], "Account is already excluded");
820         for (uint256 i = 0; i < _excluded.length; i++) {
821             if (_excluded[i] == account) {
822                 _excluded[i] = _excluded[_excluded.length - 1];
823                 _tOwned[account] = 0;
824                 _isExcluded[account] = false;
825                 _excluded.pop();
826                 break;
827             }
828         }
829     }
830 
831     function removeAllFee() private {
832         if(_taxFee == 0 && _teamFee == 0) return;
833         
834         _previousTaxFee = _taxFee;
835         _previousTeamFee = _teamFee;
836         
837         _taxFee = 0;
838         _teamFee = 0;
839     }
840 
841     function restoreAllFee() private {
842         _taxFee = _previousTaxFee;
843         _teamFee = _previousTeamFee;
844     }
845 
846     function isExcludedFromFee(address account) public view returns(bool) {
847         return _isExcludedFromFee[account];
848     }
849 
850     function _approve(address owner, address spender, uint256 amount) private {
851         require(owner != address(0), "ERC20: approve from the zero address");
852         require(spender != address(0), "ERC20: approve to the zero address");
853 
854         _allowances[owner][spender] = amount;
855         emit Approval(owner, spender, amount);
856     }
857 
858     function _transfer(address sender, address recipient, uint256 amount) private {
859         require(sender != address(0), "ERC20: transfer from the zero address");
860         require(recipient != address(0), "ERC20: transfer to the zero address");
861         require(amount > 0, "Transfer amount must be greater than zero");
862         
863         if(sender != owner() && recipient != owner())
864             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
865 
866         // is the token balance of this contract address over the min number of
867         // tokens that we need to initiate a swap?
868         // also, don't get caught in a circular team event.
869         // also, don't swap if sender is uniswap pair.
870         uint256 contractTokenBalance = balanceOf(address(this));
871         
872         if(contractTokenBalance >= _maxTxAmount)
873         {
874             contractTokenBalance = _maxTxAmount;
875         }
876         
877         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
878         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
879             // We need to swap the current tokens to ETH and send to the team wallet
880             swapTokensForEth(contractTokenBalance);
881             
882             uint256 contractETHBalance = address(this).balance;
883             if(contractETHBalance > 0) {
884                 sendETHToTeam(address(this).balance);
885             }
886         }
887         
888         //indicates if fee should be deducted from transfer
889         bool takeFee = true;
890         
891         //if any account belongs to _isExcludedFromFee account then remove the fee
892         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
893             takeFee = false;
894         }
895         
896         //transfer amount, it will take tax and team fee
897         _tokenTransfer(sender,recipient,amount,takeFee);
898     }
899 
900     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
901         // generate the uniswap pair path of token -> weth
902         address[] memory path = new address[](2);
903         path[0] = address(this);
904         path[1] = uniswapV2Router.WETH();
905 
906         _approve(address(this), address(uniswapV2Router), tokenAmount);
907 
908         // make the swap
909         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
910             tokenAmount,
911             0, // accept any amount of ETH
912             path,
913             address(this),
914             block.timestamp
915         );
916     }
917     
918     function sendETHToTeam(uint256 amount) private {
919         _teamWalletAddress.transfer(amount.div(2));
920         _marketingWalletAddress.transfer(amount.div(2));
921     }
922     
923     // We are exposing these functions to be able to manual swap and send
924     // in case the token is highly valued and 5M becomes too much
925     function manualSwap() external onlyOwner() {
926         uint256 contractBalance = balanceOf(address(this));
927         swapTokensForEth(contractBalance);
928     }
929     
930     function manualSend() external onlyOwner() {
931         uint256 contractETHBalance = address(this).balance;
932         sendETHToTeam(contractETHBalance);
933     }
934 
935     function setSwapEnabled(bool enabled) external onlyOwner(){
936         swapEnabled = enabled;
937     }
938     
939     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
940         if(!takeFee)
941             removeAllFee();
942 
943         if (_isExcluded[sender] && !_isExcluded[recipient]) {
944             _transferFromExcluded(sender, recipient, amount);
945         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
946             _transferToExcluded(sender, recipient, amount);
947         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
948             _transferStandard(sender, recipient, amount);
949         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
950             _transferBothExcluded(sender, recipient, amount);
951         } else {
952             _transferStandard(sender, recipient, amount);
953         }
954 
955         if(!takeFee)
956             restoreAllFee();
957     }
958 
959     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
960         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
961         _rOwned[sender] = _rOwned[sender].sub(rAmount);
962         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
963         _takeTeam(tTeam); 
964         _reflectFee(rFee, tFee);
965         emit Transfer(sender, recipient, tTransferAmount);
966     }
967 
968     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
969         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
970         _rOwned[sender] = _rOwned[sender].sub(rAmount);
971         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
972         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
973         _takeTeam(tTeam);           
974         _reflectFee(rFee, tFee);
975         emit Transfer(sender, recipient, tTransferAmount);
976     }
977 
978     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
979         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
980         _tOwned[sender] = _tOwned[sender].sub(tAmount);
981         _rOwned[sender] = _rOwned[sender].sub(rAmount);
982         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
983         _takeTeam(tTeam);   
984         _reflectFee(rFee, tFee);
985         emit Transfer(sender, recipient, tTransferAmount);
986     }
987 
988     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
989         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
990         _tOwned[sender] = _tOwned[sender].sub(tAmount);
991         _rOwned[sender] = _rOwned[sender].sub(rAmount);
992         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
993         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
994         _takeTeam(tTeam);         
995         _reflectFee(rFee, tFee);
996         emit Transfer(sender, recipient, tTransferAmount);
997     }
998 
999     function _takeTeam(uint256 tTeam) private {
1000         uint256 currentRate =  _getRate();
1001         uint256 rTeam = tTeam.mul(currentRate);
1002         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1003         if(_isExcluded[address(this)])
1004             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1005     }
1006 
1007     function _reflectFee(uint256 rFee, uint256 tFee) private {
1008         _rTotal = _rTotal.sub(rFee);
1009         _tFeeTotal = _tFeeTotal.add(tFee);
1010     }
1011 
1012      //to recieve ETH from uniswapV2Router when swaping
1013     receive() external payable {}
1014 
1015     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1016         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1017         uint256 currentRate =  _getRate();
1018         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1019         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1020     }
1021 
1022     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1023         uint256 tFee = tAmount.mul(taxFee).div(100);
1024         uint256 tTeam = tAmount.mul(teamFee).div(100);
1025         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1026         return (tTransferAmount, tFee, tTeam);
1027     }
1028 
1029     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1030         uint256 rAmount = tAmount.mul(currentRate);
1031         uint256 rFee = tFee.mul(currentRate);
1032         uint256 rTransferAmount = rAmount.sub(rFee);
1033         return (rAmount, rTransferAmount, rFee);
1034     }
1035 
1036     function _getRate() private view returns(uint256) {
1037         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1038         return rSupply.div(tSupply);
1039     }
1040 
1041     function _getCurrentSupply() private view returns(uint256, uint256) {
1042         uint256 rSupply = _rTotal;
1043         uint256 tSupply = _tTotal;      
1044         for (uint256 i = 0; i < _excluded.length; i++) {
1045             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1046             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1047             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1048         }
1049         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1050         return (rSupply, tSupply);
1051     }
1052     
1053     function _getTaxFee() private view returns(uint256) {
1054         return _taxFee;
1055     }
1056 
1057     function _getMaxTxAmount() private view returns(uint256) {
1058         return _maxTxAmount;
1059     }
1060 
1061     function _getETHBalance() public view returns(uint256 balance) {
1062         return address(this).balance;
1063     }
1064     
1065     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1066         require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1067         _taxFee = taxFee;
1068     }
1069 
1070     function _setTeamFee(uint256 teamFee) external onlyOwner() {
1071         require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1072         _teamFee = teamFee;
1073     }
1074     
1075     function _setTeamWallet(address payable teamWalletAddress) external onlyOwner() {
1076         _teamWalletAddress = teamWalletAddress;
1077     }
1078     
1079     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1080         require(maxTxAmount >= 10000000000e9 , 'maxTxAmount should be greater than 10000000000e9');
1081         _maxTxAmount = maxTxAmount;
1082     }
1083 }