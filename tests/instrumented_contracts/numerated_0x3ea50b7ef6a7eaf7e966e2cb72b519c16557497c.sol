1 /*
2     ____                __          __     ____                             
3    / __ \ ____   _____ / /__ ___   / /_   / __ ) __  __ ____   ____   __  __
4   / /_/ // __ \ / ___// //_// _ \ / __/  / __  |/ / / // __ \ / __ \ / / / /
5  / _, _// /_/ // /__ / ,<  /  __// /_   / /_/ // /_/ // / / // / / // /_/ / 
6 /_/ |_| \____/ \___//_/|_| \___/ \__/  /_____/ \__,_//_/ /_//_/ /_/ \__, /  
7                                                                    /____/   
8 
9 Just for buying Rocket Bunny and holding it in your wallet, you will earn passive income that is deposited
10 directly into your wallet via frictionless yield on all transactions of Rocket Bunny.No staking required!
11 
12 Rocket Bunny combines the most sought after tokenomics across DeFi: automatic liquidity adds, 
13 compounding yield, deflationary supply, liquidity provider rewards, and price shock protection.
14 
15 Rocket Bunny is a deflationary token with a max circulating supply of 777 Quadrilion. Each transaction 
16 incurs a 4% tax that is distributed in four equal parts: 1% to holders, 1% burned to The Rabbit's Hole, 
17 1% locked liquidity, and 1% as a bonus to liquidity providers. As volume increases, the amount burned 
18 increases logarithmically, eventually leading to an exponential decrease in supply.
19 
20 The Rabbit Hole burns do not stop, the instant holder rewards do not stop, the 2x rewards for liquidity 
21 providers do not stop, and the locked liquidity adds do not stop. This means the Rocket Bunny supply will 
22 become more scarce, your holdings will continue to increase, particularly if you are a liquidty provider 
23 earning 2x rewards, and the price floor for Rocket Bunny will continue to rise.
24 
25 - Deflationary supply
26 - Rewards directly into your wallet
27 - 2x rewards for LP
28 - Automatic & locked liquidity adds
29 - Whale dump protection
30 
31 web: rocketbunny.io
32 tg: @RocketBunnyChat
33 
34 */
35 
36 // SPDX-License-Identifier: MIT
37 
38 pragma solidity ^0.6.12;
39 
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 interface IERC20 {
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `recipient`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Returns the remaining number of tokens that `spender` will be
73      * allowed to spend on behalf of `owner` through {transferFrom}. This is
74      * zero by default.
75      *
76      * This value changes when {approve} or {transferFrom} are called.
77      */
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     /**
81      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * IMPORTANT: Beware that changing an allowance with this method brings the risk
86      * that someone may use both the old and the new allowance by unfortunate
87      * transaction ordering. One possible solution to mitigate this race
88      * condition is to first reduce the spender's allowance to 0 and set the
89      * desired value afterwards:
90      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Moves `amount` tokens from `sender` to `recipient` using the
98      * allowance mechanism. `amount` is then deducted from the caller's
99      * allowance.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      *
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         return sub(a, b, "SafeMath: subtraction overflow");
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      *
179      * - Multiplication cannot overflow.
180      */
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183         // benefit is lost if 'b' is also tested.
184         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b != 0, errorMessage);
261         return a % b;
262     }
263 }
264 
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // pragma solidity >=0.5.0;
401 
402 interface IUniswapV2Factory {
403     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
404 
405     function feeTo() external view returns (address);
406     function feeToSetter() external view returns (address);
407 
408     function getPair(address tokenA, address tokenB) external view returns (address pair);
409     function allPairs(uint) external view returns (address pair);
410     function allPairsLength() external view returns (uint);
411 
412     function createPair(address tokenA, address tokenB) external returns (address pair);
413 
414     function setFeeTo(address) external;
415     function setFeeToSetter(address) external;
416 }
417 
418 
419 // pragma solidity >=0.5.0;
420 
421 interface IUniswapV2ERC20 {
422     event Approval(address indexed owner, address indexed spender, uint value);
423     event Transfer(address indexed from, address indexed to, uint value);
424 
425     function name() external pure returns (string memory);
426     function symbol() external pure returns (string memory);
427     function decimals() external pure returns (uint8);
428     function totalSupply() external view returns (uint);
429     function balanceOf(address owner) external view returns (uint);
430     function allowance(address owner, address spender) external view returns (uint);
431 
432     function approve(address spender, uint value) external returns (bool);
433     function transfer(address to, uint value) external returns (bool);
434     function transferFrom(address from, address to, uint value) external returns (bool);
435 
436     function DOMAIN_SEPARATOR() external view returns (bytes32);
437     function PERMIT_TYPEHASH() external pure returns (bytes32);
438     function nonces(address owner) external view returns (uint);
439 
440     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
441 }
442 
443 
444 
445 
446 // pragma solidity >=0.6.2;
447 
448 interface IUniswapV2Router01 {
449     function factory() external pure returns (address);
450     function WETH() external pure returns (address);
451 
452     function addLiquidity(
453         address tokenA,
454         address tokenB,
455         uint amountADesired,
456         uint amountBDesired,
457         uint amountAMin,
458         uint amountBMin,
459         address to,
460         uint deadline
461     ) external returns (uint amountA, uint amountB, uint liquidity);
462     function addLiquidityETH(
463         address token,
464         uint amountTokenDesired,
465         uint amountTokenMin,
466         uint amountETHMin,
467         address to,
468         uint deadline
469     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
470     function removeLiquidity(
471         address tokenA,
472         address tokenB,
473         uint liquidity,
474         uint amountAMin,
475         uint amountBMin,
476         address to,
477         uint deadline
478     ) external returns (uint amountA, uint amountB);
479     function removeLiquidityETH(
480         address token,
481         uint liquidity,
482         uint amountTokenMin,
483         uint amountETHMin,
484         address to,
485         uint deadline
486     ) external returns (uint amountToken, uint amountETH);
487     function removeLiquidityWithPermit(
488         address tokenA,
489         address tokenB,
490         uint liquidity,
491         uint amountAMin,
492         uint amountBMin,
493         address to,
494         uint deadline,
495         bool approveMax, uint8 v, bytes32 r, bytes32 s
496     ) external returns (uint amountA, uint amountB);
497     function removeLiquidityETHWithPermit(
498         address token,
499         uint liquidity,
500         uint amountTokenMin,
501         uint amountETHMin,
502         address to,
503         uint deadline,
504         bool approveMax, uint8 v, bytes32 r, bytes32 s
505     ) external returns (uint amountToken, uint amountETH);
506     function swapExactTokensForTokens(
507         uint amountIn,
508         uint amountOutMin,
509         address[] calldata path,
510         address to,
511         uint deadline
512     ) external returns (uint[] memory amounts);
513     function swapTokensForExactTokens(
514         uint amountOut,
515         uint amountInMax,
516         address[] calldata path,
517         address to,
518         uint deadline
519     ) external returns (uint[] memory amounts);
520     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
521         external
522         payable
523         returns (uint[] memory amounts);
524     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
525         external
526         returns (uint[] memory amounts);
527     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
528         external
529         returns (uint[] memory amounts);
530     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
531         external
532         payable
533         returns (uint[] memory amounts);
534 
535     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
536     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
537     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
538     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
539     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
540 }
541 
542 
543 
544 // pragma solidity >=0.6.2;
545 
546 
547 
548 interface IUniswapV2Router02 is IUniswapV2Router01 {
549     function removeLiquidityETHSupportingFeeOnTransferTokens(
550         address token,
551         uint liquidity,
552         uint amountTokenMin,
553         uint amountETHMin,
554         address to,
555         uint deadline
556     ) external returns (uint amountETH);
557     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
558         address token,
559         uint liquidity,
560         uint amountTokenMin,
561         uint amountETHMin,
562         address to,
563         uint deadline,
564         bool approveMax, uint8 v, bytes32 r, bytes32 s
565     ) external returns (uint amountETH);
566 
567     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
568         uint amountIn,
569         uint amountOutMin,
570         address[] calldata path,
571         address to,
572         uint deadline
573     ) external;
574     function swapExactETHForTokensSupportingFeeOnTransferTokens(
575         uint amountOutMin,
576         address[] calldata path,
577         address to,
578         uint deadline
579     ) external payable;
580     function swapExactTokensForETHSupportingFeeOnTransferTokens(
581         uint amountIn,
582         uint amountOutMin,
583         address[] calldata path,
584         address to,
585         uint deadline
586     ) external;
587 }
588 
589 contract Ownable is Context {
590     address private _owner;
591 
592     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
593 
594     /**
595      * @dev Initializes the contract setting the deployer as the initial owner.
596      */
597     constructor () internal {
598         address msgSender = _msgSender();
599         _owner = msgSender;
600         emit OwnershipTransferred(address(0), msgSender);
601     }
602 
603     /**
604      * @dev Returns the address of the current owner.
605      */
606     function owner() public view returns (address) {
607         return _owner;
608     }
609 
610     /**
611      * @dev Throws if called by any account other than the owner.
612      */
613     modifier onlyOwner() {
614         require(_owner == _msgSender(), "Ownable: caller is not the owner");
615         _;
616     }
617 
618     /**
619      * @dev Leaves the contract without owner. It will not be possible to call
620      * `onlyOwner` functions anymore. Can only be called by the current owner.
621      *
622      * NOTE: Renouncing ownership will leave the contract without an owner,
623      * thereby removing any functionality that is only available to the owner.
624      */
625     function renounceOwnership() public virtual onlyOwner {
626         emit OwnershipTransferred(_owner, address(0));
627         _owner = address(0);
628     }
629 
630     /**
631      * @dev Transfers ownership of the contract to a new account (`newOwner`).
632      * Can only be called by the current owner.
633      */
634     function transferOwnership(address newOwner) public virtual onlyOwner {
635         require(newOwner != address(0), "Ownable: new owner is the zero address");
636         emit OwnershipTransferred(_owner, newOwner);
637         _owner = newOwner;
638     }
639 }
640 
641 
642 
643 contract RocketBunny is Context, IERC20, Ownable {
644     using SafeMath for uint256;
645     using Address for address;
646 
647     //////////////////////////////////////////
648     // start liquid variables etc.
649     //////////////////////////////////////////
650 
651     IUniswapV2Router02 public immutable uniswapV2Router;
652     //address public immutable uniswapV2Pair;
653     address public uniswapV2Pair;
654     address public _burnPool = 0x18159f21D6A2F72Dc97FC1d2ddEbCEcfa614142C;
655     
656 
657     uint8 public _feeDecimals = 2;
658     uint32 public _feePercentage = 200;
659     uint128 private _minTokensBeforeSwap;
660     
661     uint256 public _totalBurnedLpTokens;
662     
663     bool inSwapAndLiquify;
664     bool swappingInProgress;
665     bool public _swapAndLiquifyEnabled;
666 
667     event FeeUpdated(uint8 _feeDecimals, uint32 _feePercentage);
668     event MinTokensBeforeSwapUpdated(uint128 _minTokensBeforeSwap);
669     event SwapAndLiquifyEnabledUpdated(bool enabled);
670     event SwapAndLiquify(
671         uint256 tokensSwapped,
672         uint256 ethReceived,
673         uint256 tokensIntoLiqudity
674     );
675 
676     modifier lockTheSwap {
677         inSwapAndLiquify = true;
678         _;
679         inSwapAndLiquify = false;
680     }
681 
682     //////////////////////////////////////////
683     // end liquid variables etc.
684     //////////////////////////////////////////
685 
686     // anti-dumping mechanism
687     bool public _antiDumpToggle = false;
688     uint256 public _maxSellAmount = 4;      // sell amount divided by this amount (4 = 25%)
689 
690     mapping (address => uint256) private _rOwned;
691     mapping (address => uint256) private _tOwned;
692     mapping (address => mapping (address => uint256)) private _allowances;
693 
694     mapping (address => bool) private _isExcluded;
695     address[] private _excluded;
696    
697     uint256 private constant MAX = ~uint256(0);
698     uint256 private constant _tTotal = 777 * 10**15 * 10**9;
699     uint256 private _rTotal = (MAX - (MAX % _tTotal));
700     uint256 private _tFeeTotal;
701 
702     string private _name = 'Rocket Bunny';
703     string private _symbol = 'BUNNY';
704     uint8 private _decimals = 9;
705 
706     constructor (
707 
708         //////////////////////////////////////////
709         // start liquid constructor vars etc.
710         //////////////////////////////////////////
711         IUniswapV2Router02 _uniswapV2Router,
712         uint128 minTokensBeforeSwap,
713         bool swapAndLiquifyEnabled
714         //////////////////////////////////////////
715         // end liquid constructor vars etc.
716         //////////////////////////////////////////
717     ) public {
718         _rOwned[_msgSender()] = _rTotal;
719         
720         emit Transfer(address(0), _msgSender(), _tTotal);
721 
722         // Create a uniswap pair for this new token
723         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
724             .createPair(address(this), _uniswapV2Router.WETH());
725 
726         uniswapV2Router = _uniswapV2Router;
727         //updateFee(_feeDecimals, _feePercentage);
728         updateMinTokensBeforeSwap(minTokensBeforeSwap);
729         updateSwapAndLiquifyEnabled(swapAndLiquifyEnabled);
730     }
731 
732     function name() public view returns (string memory) {
733         return _name;
734     }
735 
736     function symbol() public view returns (string memory) {
737         return _symbol;
738     }
739 
740     function decimals() public view returns (uint8) {
741         return _decimals;
742     }
743 
744     function totalSupply() public view override returns (uint256) {
745         return _tTotal;
746     }
747 
748     function balanceOf(address account) public view override returns (uint256) {
749         if (_isExcluded[account]) return _tOwned[account];
750         return tokenFromReflection(_rOwned[account]);
751     }
752 
753     function transfer(address recipient, uint256 amount) public override returns (bool) {
754         _transfer(_msgSender(), recipient, amount);
755         return true;
756     }
757 
758     function allowance(address owner, address spender) public view override returns (uint256) {
759         return _allowances[owner][spender];
760     }
761 
762     function approve(address spender, uint256 amount) public override returns (bool) {
763         _approve(_msgSender(), spender, amount);
764         return true;
765     }
766 
767     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
768         _transfer(sender, recipient, amount);
769         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
770         return true;
771     }
772 
773     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
774         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
775         return true;
776     }
777 
778     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
779         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
780         return true;
781     }
782 
783     function isExcluded(address account) public view returns (bool) {
784         return _isExcluded[account];
785     }
786 
787     function totalFees() public view returns (uint256) {
788         return _tFeeTotal;
789     }
790 
791     function antiDumpToggle(bool setting) public {
792         _antiDumpToggle = setting;
793     }
794 
795     function antiDumpAmount(uint256 divisor) public {
796         _maxSellAmount = divisor;
797     }
798 
799 
800     function reflect(uint256 tAmount) public {
801         address sender = _msgSender();
802         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
803         (uint256 rAmount,,,,) = _getValues(tAmount);
804         _rOwned[sender] = _rOwned[sender].sub(rAmount);
805         _rTotal = _rTotal.sub(rAmount);
806         _tFeeTotal = _tFeeTotal.add(tAmount);
807     }
808 
809     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
810         require(tAmount <= _tTotal, "Amount must be less than supply");
811         if (!deductTransferFee) {
812             (uint256 rAmount,,,,) = _getValues(tAmount);
813             return rAmount;
814         } else {
815             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
816             return rTransferAmount;
817         }
818     }
819 
820     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
821         require(rAmount <= _rTotal, "Amount must be less than total reflections");
822         uint256 currentRate =  _getRate();
823         return rAmount.div(currentRate);
824     }
825 
826     function excludeAccount(address account) external onlyOwner() {
827         require(!_isExcluded[account], "Account is already excluded");
828         if(_rOwned[account] > 0) {
829             _tOwned[account] = tokenFromReflection(_rOwned[account]);
830         }
831         _isExcluded[account] = true;
832         _excluded.push(account);
833     }
834 
835     function includeAccount(address account) external onlyOwner() {
836         require(_isExcluded[account], "Account is already excluded");
837         for (uint256 i = 0; i < _excluded.length; i++) {
838             if (_excluded[i] == account) {
839                 _excluded[i] = _excluded[_excluded.length - 1];
840                 _tOwned[account] = 0;
841                 _isExcluded[account] = false;
842                 _excluded.pop();
843                 break;
844             }
845         }
846     }
847 
848     function _approve(address owner, address spender, uint256 amount) private {
849         require(owner != address(0), "ERC20: approve from the zero address");
850         require(spender != address(0), "ERC20: approve to the zero address");
851 
852         _allowances[owner][spender] = amount;
853         emit Approval(owner, spender, amount);
854     }
855 
856     function _transfer(address sender, address recipient, uint256 amount) private {
857         require(sender != address(0), "ERC20: transfer from the zero address");
858         require(recipient != address(0), "ERC20: transfer to the zero address");
859         require(amount > 0, "Transfer amount must be greater than zero");
860 
861         // check if we're in the middle of liquidity add to avoid unnecessary transactions and save gas
862         if(swappingInProgress){
863             _transferBothExcluded(sender, recipient, amount);
864             swappingInProgress = false;
865         } else{
866             if(_antiDumpToggle){
867                 if(recipient == address(uniswapV2Pair) || recipient == address(uniswapV2Router)){
868                     uint256 senderBalance = balanceOf(sender);
869                     uint256 threshold = (totalSupply().sub(balanceOf(_burnPool))).div(99);
870                     if(senderBalance > threshold){
871                         require(amount < senderBalance.div(4), "You can only sell 25% at a time if you hold 1% or more of supply!");
872                     }
873                 }
874             }
875 
876             ////////////////////////////////////////
877             // adding liquidity lock mechanism here
878             ////////////////////////////////////////
879 
880         
881 
882             uint256 contractTokenBalance = balanceOf(address(this));
883             bool overMinTokenBalance = contractTokenBalance >= _minTokensBeforeSwap;
884             if (
885                 overMinTokenBalance &&
886                 !inSwapAndLiquify &&
887                 msg.sender != uniswapV2Pair &&
888                 _swapAndLiquifyEnabled
889             ) {
890                 swappingInProgress = true;
891                 swapAndLiquify(contractTokenBalance);
892             }
893 
894             // calculate the number of tokens to take as a fee
895             uint256 liquidityFee = calculateTokenFee(
896                 amount,
897                 _feeDecimals,
898                 _feePercentage
899             );
900 
901             // take the fee and send those tokens to this contract address
902             // and then send the remainder of tokens to original recipient
903             amount = amount.sub(liquidityFee);
904             
905 
906             uint256 bonusLP = liquidityFee.div(2);
907             uint256 tokensToLock = liquidityFee.sub(bonusLP);
908 
909             _transferToExcluded(sender, address(this), tokensToLock);
910             _transferToExcluded(sender, address(uniswapV2Pair), bonusLP);
911 
912             ////////////////////////////////////////////////
913             // end liquidity lock mechanism. carry on now...
914             ////////////////////////////////////////////////
915 
916             if (_isExcluded[sender] && !_isExcluded[recipient]) {
917                 _transferFromExcluded(sender, recipient, amount);
918             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
919                 _transferToExcluded(sender, recipient, amount);
920             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
921                 _transferStandard(sender, recipient, amount);
922             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
923                 _transferBothExcluded(sender, recipient, amount);
924             } else {
925                 _transferStandard(sender, recipient, amount);
926             }
927         }
928     }
929 
930     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
931         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
932         _rOwned[sender] = _rOwned[sender].sub(rAmount);
933         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
934         _reflectFee(rFee, tFee);
935         emit Transfer(sender, recipient, tTransferAmount);
936     }
937 
938     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
939         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
940         _rOwned[sender] = _rOwned[sender].sub(rAmount);
941         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
942         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
943         _reflectFee(rFee, tFee);
944         emit Transfer(sender, recipient, tTransferAmount);
945     }
946 
947     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
948         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
949         _tOwned[sender] = _tOwned[sender].sub(tAmount);
950         _rOwned[sender] = _rOwned[sender].sub(rAmount);
951         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
952         _reflectFee(rFee, tFee);
953         emit Transfer(sender, recipient, tTransferAmount);
954     }
955 
956     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
957         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
958         _tOwned[sender] = _tOwned[sender].sub(tAmount);
959         _rOwned[sender] = _rOwned[sender].sub(rAmount);
960         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
961         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
962         _reflectFee(rFee, tFee);
963         emit Transfer(sender, recipient, tTransferAmount);
964     }
965 
966     function _reflectFee(uint256 rFee, uint256 tFee) private {
967         _rTotal = _rTotal.sub(rFee);
968         _tFeeTotal = _tFeeTotal.add(tFee);
969     }
970 
971     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
972         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
973         uint256 currentRate =  _getRate();
974         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
975         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
976     }
977 
978     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
979         uint256 tFee = tAmount.div(100).mul(2);
980         uint256 tTransferAmount = tAmount.sub(tFee);
981         return (tTransferAmount, tFee);
982     }
983 
984     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
985         uint256 rAmount = tAmount.mul(currentRate);
986         uint256 rFee = tFee.mul(currentRate);
987         uint256 rTransferAmount = rAmount.sub(rFee);
988         return (rAmount, rTransferAmount, rFee);
989     }
990 
991     function _getRate() private view returns(uint256) {
992         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
993         return rSupply.div(tSupply);
994     }
995 
996     function _getCurrentSupply() private view returns(uint256, uint256) {
997         uint256 rSupply = _rTotal;
998         uint256 tSupply = _tTotal;      
999         for (uint256 i = 0; i < _excluded.length; i++) {
1000             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1001             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1002             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1003         }
1004         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1005         return (rSupply, tSupply);
1006     }
1007 
1008     ////////////////////////////////////////////////
1009     // start liquidity lock functions
1010     ////////////////////////////////////////////////
1011 
1012     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1013         // split the contract balance into halves
1014         uint256 half = contractTokenBalance.div(2);
1015         uint256 otherHalf = contractTokenBalance.sub(half);
1016 
1017         // capture the contract's current ETH balance.
1018         // this is so that we can capture exactly the amount of ETH that the
1019         // swap creates, and not make the liquidity event include any ETH that
1020         // has been manually sent to the contract
1021         uint256 initialBalance = address(this).balance;
1022 
1023         // swap tokens for ETH
1024         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1025 
1026         // how much ETH did we just swap into?
1027         uint256 newBalance = address(this).balance.sub(initialBalance);
1028 
1029         // add liquidity to uniswap
1030         addLiquidity(otherHalf, newBalance);
1031         
1032 
1033         emit SwapAndLiquify(half, newBalance, otherHalf);
1034     }
1035 
1036     function swapTokensForEth(uint256 tokenAmount) private {
1037         // generate the uniswap pair path of token -> weth
1038         address[] memory path = new address[](2);
1039         path[0] = address(this);
1040         path[1] = uniswapV2Router.WETH();
1041 
1042         _approve(address(this), address(uniswapV2Router), tokenAmount);
1043 
1044         // make the swap
1045         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1046             tokenAmount,
1047             0, // accept any amount of ETH
1048             path,
1049             address(this),
1050             block.timestamp
1051         );
1052     }
1053 
1054     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1055         // approve token transfer to cover all possible scenarios
1056         _approve(address(this), address(uniswapV2Router), tokenAmount);
1057 
1058         // add the liquidity
1059         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1060             address(this),
1061             tokenAmount,
1062             0, // slippage is unavoidable
1063             0, // slippage is unavoidable
1064             address(this),
1065             block.timestamp
1066         );
1067     }
1068 
1069     /*
1070         calculates a percentage of tokens to hold as the fee
1071     */
1072     function calculateTokenFee(
1073         uint256 _amount,
1074         uint8 feeDecimals,
1075         uint32 feePercentage
1076     ) public pure returns (uint256 locked) {
1077         locked = _amount.mul(feePercentage).div(
1078             10**(uint256(feeDecimals) + 2)
1079         );
1080     }
1081 
1082     ///
1083     /// Ownership adjustments
1084     ///
1085 
1086     function updateFee(uint32 feePercentage)
1087         public
1088         onlyOwner
1089     {
1090         require(feePercentage <= 200, "Can't have a higher fee than 2%!");
1091         _feePercentage = feePercentage;
1092         emit FeeUpdated(_feeDecimals, _feePercentage);
1093     }
1094 
1095     function updateMinTokensBeforeSwap(uint128 minTokensBeforeSwap)
1096         public
1097         onlyOwner
1098     {
1099         _minTokensBeforeSwap = minTokensBeforeSwap;
1100         emit MinTokensBeforeSwapUpdated(_minTokensBeforeSwap);
1101     }
1102 
1103     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1104         _swapAndLiquifyEnabled = _enabled;
1105         emit SwapAndLiquifyEnabledUpdated(_enabled);
1106     }
1107 
1108     function burnLiq(address _token, address _to, uint256 _amount) public onlyOwner {
1109         require(_to != address(0),"ERC20 transfer to zero address");
1110         
1111         IUniswapV2ERC20 token = IUniswapV2ERC20(_token);
1112         _totalBurnedLpTokens = _totalBurnedLpTokens.sub(_amount);
1113         
1114         token.transfer(_burnPool, _amount);
1115     }
1116 
1117     receive() external payable {}
1118 
1119     ////////////////////////////////////////////////
1120     // end liquidity lock functions
1121     ////////////////////////////////////////////////
1122 }