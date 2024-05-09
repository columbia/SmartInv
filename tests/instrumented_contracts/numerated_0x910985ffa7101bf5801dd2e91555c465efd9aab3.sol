1 /*                                 
2 
3     ChubbyInu is here, we want every dog
4     to be comfy and reach healthy chub levels
5     so they can be happy dogs!
6     3% redist
7     2% liq
8     2% charity
9    
10  */
11  
12 //SPDX-License-Identifier: GPL-3.0-or-later
13 pragma solidity ^0.6.12;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IERC20 {
27     /**
28     * @dev Returns the amount of tokens in existence.
29     */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33     * @dev Returns the amount of tokens owned by `account`.
34     */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38     * @dev Moves `amount` tokens from the caller's account to `recipient`.
39     *
40     * Returns a boolean value indicating whether the operation succeeded.
41     *
42     * Emits a {Transfer} event.
43     */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47     * @dev Returns the remaining number of tokens that `spender` will be
48     * allowed to spend on behalf of `owner` through {transferFrom}. This is
49     * zero by default.
50     *
51     * This value changes when {approve} or {transferFrom} are called.
52     */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57     *
58     * Returns a boolean value indicating whether the operation succeeded.
59     *
60     * IMPORTANT: Beware that changing an allowance with this method brings the risk
61     * that someone may use both the old and the new allowance by unfortunate
62     * transaction ordering. One possible solution to mitigate this race
63     * condition is to first reduce the spender's allowance to 0 and set the
64     * desired value afterwards:
65     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66     *
67     * Emits an {Approval} event.
68     */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72     * @dev Moves `amount` tokens from `sender` to `recipient` using the
73     * allowance mechanism. `amount` is then deducted from the caller's
74     * allowance.
75     *
76     * Returns a boolean value indicating whether the operation succeeded.
77     *
78     * Emits a {Transfer} event.
79     */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83     * @dev Emitted when `value` tokens are moved from one account (`from`) to
84     * another (`to`).
85     *
86     * Note that `value` may be zero.
87     */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92     * a call to {approve}. `value` is the new allowance.
93     */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 library SafeMath {
98     /**
99     * @dev Returns the addition of two unsigned integers, reverting on
100     * overflow.
101     *
102     * Counterpart to Solidity's `+` operator.
103     *
104     * Requirements:
105     *
106     * - Addition cannot overflow.
107     */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116     * @dev Returns the subtraction of two unsigned integers, reverting on
117     * overflow (when the result is negative).
118     *
119     * Counterpart to Solidity's `-` operator.
120     *
121     * Requirements:
122     *
123     * - Subtraction cannot overflow.
124     */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131     * overflow (when the result is negative).
132     *
133     * Counterpart to Solidity's `-` operator.
134     *
135     * Requirements:
136     *
137     * - Subtraction cannot overflow.
138     */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147     * @dev Returns the multiplication of two unsigned integers, reverting on
148     * overflow.
149     *
150     * Counterpart to Solidity's `*` operator.
151     *
152     * Requirements:
153     *
154     * - Multiplication cannot overflow.
155     */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171     * @dev Returns the integer division of two unsigned integers. Reverts on
172     * division by zero. The result is rounded towards zero.
173     *
174     * Counterpart to Solidity's `/` operator. Note: this function uses a
175     * `revert` opcode (which leaves remaining gas untouched) while Solidity
176     * uses an invalid opcode to revert (consuming all remaining gas).
177     *
178     * Requirements:
179     *
180     * - The divisor cannot be zero.
181     */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188     * division by zero. The result is rounded towards zero.
189     *
190     * Counterpart to Solidity's `/` operator. Note: this function uses a
191     * `revert` opcode (which leaves remaining gas untouched) while Solidity
192     * uses an invalid opcode to revert (consuming all remaining gas).
193     *
194     * Requirements:
195     *
196     * - The divisor cannot be zero.
197     */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208     * Reverts when dividing by zero.
209     *
210     * Counterpart to Solidity's `%` operator. This function uses a `revert`
211     * opcode (which leaves remaining gas untouched) while Solidity uses an
212     * invalid opcode to revert (consuming all remaining gas).
213     *
214     * Requirements:
215     *
216     * - The divisor cannot be zero.
217     */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224     * Reverts with custom message when dividing by zero.
225     *
226     * Counterpart to Solidity's `%` operator. This function uses a `revert`
227     * opcode (which leaves remaining gas untouched) while Solidity uses an
228     * invalid opcode to revert (consuming all remaining gas).
229     *
230     * Requirements:
231     *
232     * - The divisor cannot be zero.
233     */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 library Address {
241     /**
242     * @dev Returns true if `account` is a contract.
243     *
244     * [IMPORTANT]
245     * ====
246     * It is unsafe to assume that an address for which this function returns
247     * false is an externally-owned account (EOA) and not a contract.
248     *
249     * Among others, `isContract` will return false for the following
250     * types of addresses:
251     *
252     *  - an externally-owned account
253     *  - a contract in construction
254     *  - an address where a contract will be created
255     *  - an address where a contract lived, but was destroyed
256     * ====
257     */
258     function isContract(address account) internal view returns (bool) {
259         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
260         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
261         // for accounts without code, i.e. `keccak256('')`
262         bytes32 codehash;
263         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { codehash := extcodehash(account) }
266         return (codehash != accountHash && codehash != 0x0);
267     }
268 
269     /**
270     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271     * `recipient`, forwarding all available gas and reverting on errors.
272     *
273     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274     * of certain opcodes, possibly making contracts go over the 2300 gas limit
275     * imposed by `transfer`, making them unable to receive funds via
276     * `transfer`. {sendValue} removes this limitation.
277     *
278     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279     *
280     * IMPORTANT: because control is transferred to `recipient`, care must be
281     * taken to not create reentrancy vulnerabilities. Consider using
282     * {ReentrancyGuard} or the
283     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284     */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294     * @dev Performs a Solidity function call using a low level `call`. A
295     * plain`call` is an unsafe replacement for a function call: use this
296     * function instead.
297     *
298     * If `target` reverts with a revert reason, it is bubbled up by this
299     * function (like regular Solidity function calls).
300     *
301     * Returns the raw returned data. To convert to the expected return value,
302     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303     *
304     * Requirements:
305     *
306     * - `target` must be a contract.
307     * - calling `target` with `data` must not revert.
308     *
309     * _Available since v3.1._
310     */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317     * `errorMessage` as a fallback revert reason when `target` reverts.
318     *
319     * _Available since v3.1._
320     */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327     * but also transferring `value` wei to `target`.
328     *
329     * Requirements:
330     *
331     * - the calling contract must have an ETH balance of at least `value`.
332     * - the called Solidity function must be `payable`.
333     *
334     * _Available since v3.1._
335     */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342     * with `errorMessage` as a fallback revert reason when `target` reverts.
343     *
344     * _Available since v3.1._
345     */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 contract Ownable is Context {
376     address private _owner;
377     address private _previousOwner;
378     uint256 private _lockTime;
379 
380     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
381 
382     /**
383     * @dev Initializes the contract setting the deployer as the initial owner.
384     */
385     constructor () internal {
386         address msgSender = _msgSender();
387         _owner = msgSender;
388         emit OwnershipTransferred(address(0), msgSender);
389     }
390 
391     /**
392     * @dev Returns the address of the current owner.
393     */
394     function owner() public view returns (address) {
395         return _owner;
396     }
397 
398     /**
399     * @dev Throws if called by any account other than the owner.
400     */
401     modifier onlyOwner() {
402         require(_owner == _msgSender(), "Ownable: caller is not the owner");
403         _;
404     }
405 
406     /**
407     * @dev Leaves the contract without owner. It will not be possible to call
408     * `onlyOwner` functions anymore. Can only be called by the current owner.
409     *
410     * NOTE: Renouncing ownership will leave the contract without an owner,
411     * thereby removing any functionality that is only available to the owner.
412     */
413     function renounceOwnership() public virtual onlyOwner {
414         emit OwnershipTransferred(_owner, address(0));
415         _owner = address(0);
416     }
417 
418     /**
419     * @dev Transfers ownership of the contract to a new account (`newOwner`).
420     * Can only be called by the current owner.
421     */
422     function transferOwnership(address newOwner) public virtual onlyOwner {
423         require(newOwner != address(0), "Ownable: new owner is the zero address");
424         emit OwnershipTransferred(_owner, newOwner);
425         _owner = newOwner;
426     }
427 
428     function geUnlockTime() public view returns (uint256) {
429         return _lockTime;
430     }
431 
432     //Locks the contract for owner for the amount of time provided
433     function lock(uint256 time) public virtual onlyOwner {
434         _previousOwner = _owner;
435         _owner = address(0);
436         _lockTime = now + time;
437         emit OwnershipTransferred(_owner, address(0));
438     }
439 
440     //Unlocks the contract for owner when _lockTime is exceeds
441     function unlock() public virtual {
442         require(_previousOwner == msg.sender, "You don't have permission to unlock");
443         require(now > _lockTime , "Contract is locked until 7 days");
444         emit OwnershipTransferred(_owner, _previousOwner);
445         _owner = _previousOwner;
446     }
447 }
448 
449 interface IUniswapV2Factory {
450     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
451 
452     function feeTo() external view returns (address);
453     function feeToSetter() external view returns (address);
454 
455     function getPair(address tokenA, address tokenB) external view returns (address pair);
456     function allPairs(uint) external view returns (address pair);
457     function allPairsLength() external view returns (uint);
458 
459     function createPair(address tokenA, address tokenB) external returns (address pair);
460 
461     function setFeeTo(address) external;
462     function setFeeToSetter(address) external;
463 }
464 
465 interface IUniswapV2Pair {
466     event Approval(address indexed owner, address indexed spender, uint value);
467     event Transfer(address indexed from, address indexed to, uint value);
468 
469     function name() external pure returns (string memory);
470     function symbol() external pure returns (string memory);
471     function decimals() external pure returns (uint8);
472     function totalSupply() external view returns (uint);
473     function balanceOf(address owner) external view returns (uint);
474     function allowance(address owner, address spender) external view returns (uint);
475 
476     function approve(address spender, uint value) external returns (bool);
477     function transfer(address to, uint value) external returns (bool);
478     function transferFrom(address from, address to, uint value) external returns (bool);
479 
480     function DOMAIN_SEPARATOR() external view returns (bytes32);
481     function PERMIT_TYPEHASH() external pure returns (bytes32);
482     function nonces(address owner) external view returns (uint);
483 
484     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
485 
486     event Mint(address indexed sender, uint amount0, uint amount1);
487     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
488     event Swap(
489         address indexed sender,
490         uint amount0In,
491         uint amount1In,
492         uint amount0Out,
493         uint amount1Out,
494         address indexed to
495     );
496     event Sync(uint112 reserve0, uint112 reserve1);
497 
498     function MINIMUM_LIQUIDITY() external pure returns (uint);
499     function factory() external view returns (address);
500     function token0() external view returns (address);
501     function token1() external view returns (address);
502     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
503     function price0CumulativeLast() external view returns (uint);
504     function price1CumulativeLast() external view returns (uint);
505     function kLast() external view returns (uint);
506 
507     function mint(address to) external returns (uint liquidity);
508     function burn(address to) external returns (uint amount0, uint amount1);
509     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
510     function skim(address to) external;
511     function sync() external;
512 
513     function initialize(address, address) external;
514 }
515 
516 interface IUniswapV2Router01 {
517     function factory() external pure returns (address);
518     function WETH() external pure returns (address);
519 
520     function addLiquidity(
521         address tokenA,
522         address tokenB,
523         uint amountADesired,
524         uint amountBDesired,
525         uint amountAMin,
526         uint amountBMin,
527         address to,
528         uint deadline
529     ) external returns (uint amountA, uint amountB, uint liquidity);
530     function addLiquidityETH(
531         address token,
532         uint amountTokenDesired,
533         uint amountTokenMin,
534         uint amountETHMin,
535         address to,
536         uint deadline
537     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
538     function removeLiquidity(
539         address tokenA,
540         address tokenB,
541         uint liquidity,
542         uint amountAMin,
543         uint amountBMin,
544         address to,
545         uint deadline
546     ) external returns (uint amountA, uint amountB);
547     function removeLiquidityETH(
548         address token,
549         uint liquidity,
550         uint amountTokenMin,
551         uint amountETHMin,
552         address to,
553         uint deadline
554     ) external returns (uint amountToken, uint amountETH);
555     function removeLiquidityWithPermit(
556         address tokenA,
557         address tokenB,
558         uint liquidity,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline,
563         bool approveMax, uint8 v, bytes32 r, bytes32 s
564     ) external returns (uint amountA, uint amountB);
565     function removeLiquidityETHWithPermit(
566         address token,
567         uint liquidity,
568         uint amountTokenMin,
569         uint amountETHMin,
570         address to,
571         uint deadline,
572         bool approveMax, uint8 v, bytes32 r, bytes32 s
573     ) external returns (uint amountToken, uint amountETH);
574     function swapExactTokensForTokens(
575         uint amountIn,
576         uint amountOutMin,
577         address[] calldata path,
578         address to,
579         uint deadline
580     ) external returns (uint[] memory amounts);
581     function swapTokensForExactTokens(
582         uint amountOut,
583         uint amountInMax,
584         address[] calldata path,
585         address to,
586         uint deadline
587     ) external returns (uint[] memory amounts);
588     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
589     external
590     payable
591     returns (uint[] memory amounts);
592     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
593     external
594     returns (uint[] memory amounts);
595     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
596     external
597     returns (uint[] memory amounts);
598     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
599     external
600     payable
601     returns (uint[] memory amounts);
602 
603     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
604     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
605     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
606     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
607     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
608 }
609 
610 interface IUniswapV2Router02 is IUniswapV2Router01 {
611     function removeLiquidityETHSupportingFeeOnTransferTokens(
612         address token,
613         uint liquidity,
614         uint amountTokenMin,
615         uint amountETHMin,
616         address to,
617         uint deadline
618     ) external returns (uint amountETH);
619     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
620         address token,
621         uint liquidity,
622         uint amountTokenMin,
623         uint amountETHMin,
624         address to,
625         uint deadline,
626         bool approveMax, uint8 v, bytes32 r, bytes32 s
627     ) external returns (uint amountETH);
628 
629     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
630         uint amountIn,
631         uint amountOutMin,
632         address[] calldata path,
633         address to,
634         uint deadline
635     ) external;
636     function swapExactETHForTokensSupportingFeeOnTransferTokens(
637         uint amountOutMin,
638         address[] calldata path,
639         address to,
640         uint deadline
641     ) external payable;
642     function swapExactTokensForETHSupportingFeeOnTransferTokens(
643         uint amountIn,
644         uint amountOutMin,
645         address[] calldata path,
646         address to,
647         uint deadline
648     ) external;
649 }
650 
651 // Contract implementation
652 contract ChubbyInu is Context, IERC20, Ownable {
653     using SafeMath for uint256;
654     using Address for address;
655 
656     mapping (address => uint256) private _rOwned;
657     mapping (address => uint256) private _tOwned;
658     mapping (address => mapping (address => uint256)) private _allowances;
659 
660     mapping (address => bool) private _isExcludedFromFee;
661 
662     mapping (address => bool) private _isExcluded; // excluded from reward
663     address[] private _excluded;
664     mapping (address => bool) private _isBlackListedBot;
665     address[] private _blackListedBots;
666 
667     uint256 private constant MAX = ~uint256(0);
668 
669     uint256 private _tTotal = 100_000_000_000_000 * 10**9;
670     uint256 private _rTotal = (MAX - (MAX % _tTotal));
671     uint256 private _tFeeTotal;
672 
673 
674     string private _name = 'Chubby Inu';
675     string private _symbol = 'CHINU';
676     uint8 private _decimals = 9;
677 
678     uint256 private _taxFee = 4;
679     uint256 private _charityFee = 3; 
680     uint256 private _liquidityFee = 3; 
681 
682     uint256 private _previousTaxFee = _taxFee;
683     uint256 private _previousCharityFee = _charityFee;
684     uint256 private _previousLiquidityFee = _liquidityFee;
685 
686     address payable private _charityWalletAddress = payable(0x7067f9128c02428DfE4B0164990f670798Aa9bE7);
687 
688     IUniswapV2Router02 public immutable uniswapV2Router;
689     address public immutable uniswapV2Pair;
690 
691     bool inSwapAndLiquify = false;
692     bool public swapAndLiquifyEnabled = true;
693 
694     uint256 private _maxTxAmount = _tTotal;
695     uint256 private _numTokensSellToAddToLiquidity = 1000000000 * 10**9;
696 
697     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
698     event SwapAndLiquifyEnabledUpdated(bool enabled);
699     event SwapAndLiquify(
700         uint256 tokensSwapped,
701         uint256 ethReceived,
702         uint256 tokensIntoLiqudity
703     );
704 
705     modifier lockTheSwap {
706         inSwapAndLiquify = true;
707         _;
708         inSwapAndLiquify = false;
709     }
710 
711     constructor () public {
712         _rOwned[_msgSender()] = _rTotal;
713 
714         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
715         // Create a uniswap pair for this new token
716         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
717         .createPair(address(this), _uniswapV2Router.WETH());
718 
719         // set the rest of the contract variables
720         uniswapV2Router = _uniswapV2Router;
721 
722         // Exclude owner and this contract from fee
723         _isExcludedFromFee[owner()] = true;
724         _isExcludedFromFee[address(this)] = true;
725         _isExcludedFromFee[_charityWalletAddress] = true;
726 
727 
728             _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
729             _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)); 
730     
731             _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
732             _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
733     
734             _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
735             _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
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
746             _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
747             _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)); 
748                       
749             _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
750             _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
751 
752             _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
753             _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
754 
755             _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
756             _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
757 
758             _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
759             _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
760             
761             _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
762             _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
763 
764         emit Transfer(address(0), _msgSender(), _tTotal);
765     }
766 
767     function name() public view returns (string memory) {
768         return _name;
769     }
770 
771     function symbol() public view returns (string memory) {
772         return _symbol;
773     }
774 
775     function decimals() public view returns (uint8) {
776         return _decimals;
777     }
778 
779     function totalSupply() public view override returns (uint256) {
780         return _tTotal;
781     }
782 
783     function balanceOf(address account) public view override returns (uint256) {
784         if (_isExcluded[account]) return _tOwned[account];
785         return tokenFromReflection(_rOwned[account]);
786     }
787 
788     function transfer(address recipient, uint256 amount) public override returns (bool) {
789         _transfer(_msgSender(), recipient, amount);
790         return true;
791     }
792 
793     function allowance(address owner, address spender) public view override returns (uint256) {
794         return _allowances[owner][spender];
795     }
796 
797     function approve(address spender, uint256 amount) public override returns (bool) {
798         _approve(_msgSender(), spender, amount);
799         return true;
800     }
801 
802     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
803         _transfer(sender, recipient, amount);
804         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
805         return true;
806     }
807 
808     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
809         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
810         return true;
811     }
812 
813     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
814         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
815         return true;
816     }
817 
818     function isExcludedFromReward(address account) public view returns (bool) {
819         return _isExcluded[account];
820     }
821 
822     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
823         _isExcludedFromFee[account] = excluded;
824     }
825 
826     function totalFees() public view returns (uint256) {
827         return _tFeeTotal;
828     }
829 
830     function deliver(uint256 tAmount) public {
831         address sender = _msgSender();
832         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
833         (uint256 rAmount,,,,,) = _getValues(tAmount);
834         _rOwned[sender] = _rOwned[sender].sub(rAmount);
835         _rTotal = _rTotal.sub(rAmount);
836         _tFeeTotal = _tFeeTotal.add(tAmount);
837     }
838 
839     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
840         require(tAmount <= _tTotal, "Amount must be less than supply");
841         if (!deductTransferFee) {
842             (uint256 rAmount,,,,,) = _getValues(tAmount);
843             return rAmount;
844         } else {
845             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
846             return rTransferAmount;
847         }
848     }
849 
850     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
851         require(rAmount <= _rTotal, "Amount must be less than total reflections");
852         uint256 currentRate =  _getRate();
853         return rAmount.div(currentRate);
854     }
855 
856     function excludeFromReward(address account) external onlyOwner() {
857         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
858         require(!_isExcluded[account], "Account is already excluded");
859         if(_rOwned[account] > 0) {
860             _tOwned[account] = tokenFromReflection(_rOwned[account]);
861         }
862         _isExcluded[account] = true;
863         _excluded.push(account);
864     }
865 
866     function includeInReward(address account) external onlyOwner() {
867         require(_isExcluded[account], "Account is already excluded");
868         for (uint256 i = 0; i < _excluded.length; i++) {
869             if (_excluded[i] == account) {
870                 _excluded[i] = _excluded[_excluded.length - 1];
871                 _tOwned[account] = 0;
872                 _isExcluded[account] = false;
873                 _excluded.pop();
874                 break;
875             }
876         }
877     }
878 
879     function addBotToBlackList(address account) external onlyOwner() {
880         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
881         require(!_isBlackListedBot[account], "Account is already blacklisted");
882         _isBlackListedBot[account] = true;
883         _blackListedBots.push(account);
884     }
885 
886     function removeBotFromBlackList(address account) external onlyOwner() {
887         require(_isBlackListedBot[account], "Account is not blacklisted");
888         for (uint256 i = 0; i < _blackListedBots.length; i++) {
889             if (_blackListedBots[i] == account) {
890                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
891                 _isBlackListedBot[account] = false;
892                 _blackListedBots.pop();
893                 break;
894             }
895         }
896     }
897 
898     function removeAllFee() private {
899         if(_taxFee == 0 && _charityFee == 0 && _liquidityFee == 0) return;
900 
901         _previousTaxFee = _taxFee;
902         _previousCharityFee = _charityFee;
903         _previousLiquidityFee = _liquidityFee;
904 
905         _taxFee = 0;
906         _charityFee = 0;
907         _liquidityFee = 0;
908     }
909 
910     function restoreAllFee() private {
911         _taxFee = _previousTaxFee;
912         _charityFee = _previousCharityFee;
913         _liquidityFee = _previousLiquidityFee;
914     }
915 
916     function isExcludedFromFee(address account) public view returns(bool) {
917         return _isExcludedFromFee[account];
918     }
919 
920     function _approve(address owner, address spender, uint256 amount) private {
921         require(owner != address(0), "ERC20: approve from the zero address");
922         require(spender != address(0), "ERC20: approve to the zero address");
923 
924         _allowances[owner][spender] = amount;
925         emit Approval(owner, spender, amount);
926     }
927 
928     function _transfer(address sender, address recipient, uint256 amount) private {
929         require(sender != address(0), "ERC20: transfer from the zero address");
930         require(recipient != address(0), "ERC20: transfer to the zero address");
931         require(amount > 0, "Transfer amount must be greater than zero");
932         require(!_isBlackListedBot[recipient], "You have no power here!");
933         require(!_isBlackListedBot[msg.sender], "You have no power here!");
934 
935         if(sender != owner() && recipient != owner())
936             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
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
969         uint256 toCharity = contractTokenBalance.mul(_charityFee).div(_charityFee.add(_liquidityFee));
970         uint256 toLiquify = contractTokenBalance.sub(toCharity);
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
983         uint256 toSwapForEth = half.add(toCharity);
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
995         sendETHToCharity(fromSwap.sub(newBalance));
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
1031     function sendETHToCharity(uint256 amount) private {
1032         _charityWalletAddress.transfer(amount);
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
1044         sendETHToCharity(contractETHBalance);
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
1072         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharityLiquidity) = _getValues(tAmount);
1073         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1074         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1075         _takeCharityLiquidity(tCharityLiquidity);
1076         _reflectFee(rFee, tFee);
1077         emit Transfer(sender, recipient, tTransferAmount);
1078     }
1079 
1080     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1081         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharityLiquidity) = _getValues(tAmount);
1082         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1083         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1084         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1085         _takeCharityLiquidity(tCharityLiquidity);
1086         _reflectFee(rFee, tFee);
1087         emit Transfer(sender, recipient, tTransferAmount);
1088     }
1089 
1090     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1091         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharityLiquidity) = _getValues(tAmount);
1092         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1093         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1094         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1095         _takeCharityLiquidity(tCharityLiquidity);
1096         _reflectFee(rFee, tFee);
1097         emit Transfer(sender, recipient, tTransferAmount);
1098     }
1099 
1100     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1101         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharityLiquidity) = _getValues(tAmount);
1102         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1103         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1104         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1105         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1106         _takeCharityLiquidity(tCharityLiquidity);
1107         _reflectFee(rFee, tFee);
1108         emit Transfer(sender, recipient, tTransferAmount);
1109     }
1110 
1111     function _takeCharityLiquidity(uint256 tCharityLiquidity) private {
1112         uint256 currentRate = _getRate();
1113         uint256 rCharityLiquidity = tCharityLiquidity.mul(currentRate);
1114         _rOwned[address(this)] = _rOwned[address(this)].add(rCharityLiquidity);
1115         if(_isExcluded[address(this)])
1116             _tOwned[address(this)] = _tOwned[address(this)].add(tCharityLiquidity);
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
1128         (uint256 tTransferAmount, uint256 tFee, uint256 tCharityLiquidityFee) = _getTValues(tAmount, _taxFee, _charityFee.add(_liquidityFee));
1129         uint256 currentRate = _getRate();
1130         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1131         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharityLiquidityFee);
1132     }
1133 
1134     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityLiquidityFee) private pure returns (uint256, uint256, uint256) {
1135         uint256 tFee = tAmount.mul(taxFee).div(100);
1136         uint256 tCharityLiquidityFee = tAmount.mul(charityLiquidityFee).div(100);
1137         uint256 tTransferAmount = tAmount.sub(tFee).sub(charityLiquidityFee);
1138         return (tTransferAmount, tFee, tCharityLiquidityFee);
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
1182     function _setCharityFee(uint256 charityFee) external onlyOwner() {
1183         require(charityFee >= 1 && charityFee <= 49, 'charityFee should be in 1 - 11');
1184         _charityFee = charityFee;
1185     }
1186 
1187     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1188         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 11');
1189         _liquidityFee = liquidityFee;
1190     }
1191 
1192 
1193     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
1194         require(numTokensSellToAddToLiquidity >= 10**9 , 'numTokensSellToAddToLiquidity should be greater than total 1e9');
1195         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
1196     }
1197 
1198     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1199         require(maxTxAmount >= 10**9 , 'maxTxAmount should be greater than total 1e9');
1200         _maxTxAmount = maxTxAmount;
1201     }
1202 }