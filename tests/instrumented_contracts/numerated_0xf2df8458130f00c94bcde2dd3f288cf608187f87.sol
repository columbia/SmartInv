1 /**
2     FEAST.finance
3    
4    #LIQ+#RFI+#SHIB+#BUNNY+#FEG+#PIG, combine together to creat #FEAST designed to make everyone FEAST!
5     
6     I make this #FEAST to hand over it to the community.
7     Create the community by yourself if you are interested.   
8     I suggest a telegram group name for you to create: https://t.me/FEASTfinance , https://t.me/FEASTbsc
9 
10    Great features:
11    3% fee auto add to the liquidity pool to locked forever when selling
12    2% fee auto distribute to all holders
13    50% burn to the black hole, with such big black hole and 3% fee, the strong holder will get a valuable reward
14 
15    I will burn liquidity LPs to burn addresses to lock the pool forever.
16    I will renounce the ownership to burn addresses to transfer #FEAST to the community, make sure it's 100% safe.
17 
18    I will add 5 BNB and all the left 49.5% total supply to the pool
19    Can you make #FEAST 10000000X? 
20 
21    1,000,000,000,000,000 total supply
22    5,000,000,000,000 tokens limitation for trade
23    1% tokens for dev
24 
25    3% fee for liquidity will go to an address that the contract creates, 
26    and the contract will sell it and add to liquidity automatically, 
27    it's the best part of the #FEAST idea, increasing the liquidity pool automatically, 
28    help the pool grow from the small init pool.
29 
30  */
31 
32 pragma solidity ^0.6.12;
33 // SPDX-License-Identifier: Unlicensed
34 interface IERC20 {
35 
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118  
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 abstract contract Context {
263     function _msgSender() internal view virtual returns (address payable) {
264         return msg.sender;
265     }
266 
267     function _msgData() internal view virtual returns (bytes memory) {
268         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
269         return msg.data;
270     }
271 }
272 
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
297         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
298         // for accounts without code, i.e. `keccak256('')`
299         bytes32 codehash;
300         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
301         // solhint-disable-next-line no-inline-assembly
302         assembly { codehash := extcodehash(account) }
303         return (codehash != accountHash && codehash != 0x0);
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
326         (bool success, ) = recipient.call{ value: amount }("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349       return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
359         return _functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         return _functionCallWithValue(target, data, value, errorMessage);
386     }
387 
388     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
389         require(isContract(target), "Address: call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399 
400                 // solhint-disable-next-line no-inline-assembly
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 /**
413  * @dev Contract module which provides a basic access control mechanism, where
414  * there is an account (an owner) that can be granted exclusive access to
415  * specific functions.
416  *
417  * By default, the owner account will be the one that deploys the contract. This
418  * can later be changed with {transferOwnership}.
419  *
420  * This module is used through inheritance. It will make available the modifier
421  * `onlyOwner`, which can be applied to your functions to restrict their use to
422  * the owner.
423  */
424 contract Ownable is Context {
425     address private _owner;
426     address private _previousOwner;
427     uint256 private _lockTime;
428 
429     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
430 
431     /**
432      * @dev Initializes the contract setting the deployer as the initial owner.
433      */
434     constructor () internal {
435         address msgSender = _msgSender();
436         _owner = msgSender;
437         emit OwnershipTransferred(address(0), msgSender);
438     }
439 
440     /**
441      * @dev Returns the address of the current owner.
442      */
443     function owner() public view returns (address) {
444         return _owner;
445     }
446 
447     /**
448      * @dev Throws if called by any account other than the owner.
449      */
450     modifier onlyOwner() {
451         require(_owner == _msgSender(), "Ownable: caller is not the owner");
452         _;
453     }
454 
455      /**
456      * @dev Leaves the contract without owner. It will not be possible to call
457      * `onlyOwner` functions anymore. Can only be called by the current owner.
458      *
459      * NOTE: Renouncing ownership will leave the contract without an owner,
460      * thereby removing any functionality that is only available to the owner.
461      */
462     function renounceOwnership() public virtual onlyOwner {
463         emit OwnershipTransferred(_owner, address(0));
464         _owner = address(0);
465     }
466 
467     /**
468      * @dev Transfers ownership of the contract to a new account (`newOwner`).
469      * Can only be called by the current owner.
470      */
471     function transferOwnership(address newOwner) public virtual onlyOwner {
472         require(newOwner != address(0), "Ownable: new owner is the zero address");
473         emit OwnershipTransferred(_owner, newOwner);
474         _owner = newOwner;
475     }
476 
477     function geUnlockTime() public view returns (uint256) {
478         return _lockTime;
479     }
480 
481     //Locks the contract for owner for the amount of time provided
482     function lock(uint256 time) public virtual onlyOwner {
483         _previousOwner = _owner;
484         _owner = address(0);
485         _lockTime = now + time;
486         emit OwnershipTransferred(_owner, address(0));
487     }
488     
489     //Unlocks the contract for owner when _lockTime is exceeds
490     function unlock() public virtual {
491         require(_previousOwner == msg.sender, "You don't have permission to unlock");
492         require(now > _lockTime , "Contract is locked until 7 days");
493         emit OwnershipTransferred(_owner, _previousOwner);
494         _owner = _previousOwner;
495     }
496 }
497 
498 // pragma solidity >=0.5.0;
499 
500 interface IUniswapV2Factory {
501     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
502 
503     function feeTo() external view returns (address);
504     function feeToSetter() external view returns (address);
505 
506     function getPair(address tokenA, address tokenB) external view returns (address pair);
507     function allPairs(uint) external view returns (address pair);
508     function allPairsLength() external view returns (uint);
509 
510     function createPair(address tokenA, address tokenB) external returns (address pair);
511 
512     function setFeeTo(address) external;
513     function setFeeToSetter(address) external;
514 }
515 
516 
517 // pragma solidity >=0.5.0;
518 
519 interface IUniswapV2Pair {
520     event Approval(address indexed owner, address indexed spender, uint value);
521     event Transfer(address indexed from, address indexed to, uint value);
522 
523     function name() external pure returns (string memory);
524     function symbol() external pure returns (string memory);
525     function decimals() external pure returns (uint8);
526     function totalSupply() external view returns (uint);
527     function balanceOf(address owner) external view returns (uint);
528     function allowance(address owner, address spender) external view returns (uint);
529 
530     function approve(address spender, uint value) external returns (bool);
531     function transfer(address to, uint value) external returns (bool);
532     function transferFrom(address from, address to, uint value) external returns (bool);
533 
534     function DOMAIN_SEPARATOR() external view returns (bytes32);
535     function PERMIT_TYPEHASH() external pure returns (bytes32);
536     function nonces(address owner) external view returns (uint);
537 
538     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
539 
540     event Mint(address indexed sender, uint amount0, uint amount1);
541     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
542     event Swap(
543         address indexed sender,
544         uint amount0In,
545         uint amount1In,
546         uint amount0Out,
547         uint amount1Out,
548         address indexed to
549     );
550     event Sync(uint112 reserve0, uint112 reserve1);
551 
552     function MINIMUM_LIQUIDITY() external pure returns (uint);
553     function factory() external view returns (address);
554     function token0() external view returns (address);
555     function token1() external view returns (address);
556     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
557     function price0CumulativeLast() external view returns (uint);
558     function price1CumulativeLast() external view returns (uint);
559     function kLast() external view returns (uint);
560 
561     function mint(address to) external returns (uint liquidity);
562     function burn(address to) external returns (uint amount0, uint amount1);
563     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
564     function skim(address to) external;
565     function sync() external;
566 
567     function initialize(address, address) external;
568 }
569 
570 // pragma solidity >=0.6.2;
571 
572 interface IUniswapV2Router01 {
573     function factory() external pure returns (address);
574     function WETH() external pure returns (address);
575 
576     function addLiquidity(
577         address tokenA,
578         address tokenB,
579         uint amountADesired,
580         uint amountBDesired,
581         uint amountAMin,
582         uint amountBMin,
583         address to,
584         uint deadline
585     ) external returns (uint amountA, uint amountB, uint liquidity);
586     function addLiquidityETH(
587         address token,
588         uint amountTokenDesired,
589         uint amountTokenMin,
590         uint amountETHMin,
591         address to,
592         uint deadline
593     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
594     function removeLiquidity(
595         address tokenA,
596         address tokenB,
597         uint liquidity,
598         uint amountAMin,
599         uint amountBMin,
600         address to,
601         uint deadline
602     ) external returns (uint amountA, uint amountB);
603     function removeLiquidityETH(
604         address token,
605         uint liquidity,
606         uint amountTokenMin,
607         uint amountETHMin,
608         address to,
609         uint deadline
610     ) external returns (uint amountToken, uint amountETH);
611     function removeLiquidityWithPermit(
612         address tokenA,
613         address tokenB,
614         uint liquidity,
615         uint amountAMin,
616         uint amountBMin,
617         address to,
618         uint deadline,
619         bool approveMax, uint8 v, bytes32 r, bytes32 s
620     ) external returns (uint amountA, uint amountB);
621     function removeLiquidityETHWithPermit(
622         address token,
623         uint liquidity,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline,
628         bool approveMax, uint8 v, bytes32 r, bytes32 s
629     ) external returns (uint amountToken, uint amountETH);
630     function swapExactTokensForTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external returns (uint[] memory amounts);
637     function swapTokensForExactTokens(
638         uint amountOut,
639         uint amountInMax,
640         address[] calldata path,
641         address to,
642         uint deadline
643     ) external returns (uint[] memory amounts);
644     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
645         external
646         payable
647         returns (uint[] memory amounts);
648     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
649         external
650         returns (uint[] memory amounts);
651     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
652         external
653         returns (uint[] memory amounts);
654     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
655         external
656         payable
657         returns (uint[] memory amounts);
658 
659     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
660     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
661     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
662     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
663     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
664 }
665 
666 
667 
668 // pragma solidity >=0.6.2;
669 
670 interface IUniswapV2Router02 is IUniswapV2Router01 {
671     function removeLiquidityETHSupportingFeeOnTransferTokens(
672         address token,
673         uint liquidity,
674         uint amountTokenMin,
675         uint amountETHMin,
676         address to,
677         uint deadline
678     ) external returns (uint amountETH);
679     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
680         address token,
681         uint liquidity,
682         uint amountTokenMin,
683         uint amountETHMin,
684         address to,
685         uint deadline,
686         bool approveMax, uint8 v, bytes32 r, bytes32 s
687     ) external returns (uint amountETH);
688 
689     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
690         uint amountIn,
691         uint amountOutMin,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external;
696     function swapExactETHForTokensSupportingFeeOnTransferTokens(
697         uint amountOutMin,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external payable;
702     function swapExactTokensForETHSupportingFeeOnTransferTokens(
703         uint amountIn,
704         uint amountOutMin,
705         address[] calldata path,
706         address to,
707         uint deadline
708     ) external;
709 }
710 
711 
712 contract FEASTFinance is Context, IERC20, Ownable {
713     using SafeMath for uint256;
714     using Address for address;
715 
716     mapping (address => uint256) private _rOwned;
717     mapping (address => uint256) private _tOwned;
718     mapping (address => mapping (address => uint256)) private _allowances;
719 
720     mapping (address => bool) private _isExcludedFromFee;
721 
722     mapping (address => bool) private _isExcluded;
723     address[] private _excluded;
724    
725     uint256 private constant MAX = ~uint256(0);
726     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
727     uint256 private _rTotal = (MAX - (MAX % _tTotal));
728     uint256 private _tFeeTotal;
729 
730     string private _name = "FEAST.finance";
731     string private _symbol = "FEAST";
732     uint8 private _decimals = 9;
733     
734     uint256 public _taxFee = 2;
735     uint256 private _previousTaxFee = _taxFee;
736     
737     uint256 public _liquidityFee = 3;
738     uint256 private _previousLiquidityFee = _liquidityFee;
739 
740     IUniswapV2Router02 public immutable uniswapV2Router;
741     address public immutable uniswapV2Pair;
742     
743     bool inSwapAndLiquify;
744     bool public swapAndLiquifyEnabled = true;
745     
746     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
747     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
748     
749     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
750     event SwapAndLiquifyEnabledUpdated(bool enabled);
751     event SwapAndLiquify(
752         uint256 tokensSwapped,
753         uint256 ethReceived,
754         uint256 tokensIntoLiqudity
755     );
756     
757     modifier lockTheSwap {
758         inSwapAndLiquify = true;
759         _;
760         inSwapAndLiquify = false;
761     }
762     
763     constructor () public {
764         _rOwned[_msgSender()] = _rTotal;
765         
766         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
767          // Create a uniswap pair for this new token
768         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
769             .createPair(address(this), _uniswapV2Router.WETH());
770 
771         // set the rest of the contract variables
772         uniswapV2Router = _uniswapV2Router;
773         
774         //exclude owner and this contract from fee
775         _isExcludedFromFee[owner()] = true;
776         _isExcludedFromFee[address(this)] = true;
777         
778         emit Transfer(address(0), _msgSender(), _tTotal);
779     }
780 
781     function name() public view returns (string memory) {
782         return _name;
783     }
784 
785     function symbol() public view returns (string memory) {
786         return _symbol;
787     }
788 
789     function decimals() public view returns (uint8) {
790         return _decimals;
791     }
792 
793     function totalSupply() public view override returns (uint256) {
794         return _tTotal;
795     }
796 
797     function balanceOf(address account) public view override returns (uint256) {
798         if (_isExcluded[account]) return _tOwned[account];
799         return tokenFromReflection(_rOwned[account]);
800     }
801 
802     function transfer(address recipient, uint256 amount) public override returns (bool) {
803         _transfer(_msgSender(), recipient, amount);
804         return true;
805     }
806 
807     function allowance(address owner, address spender) public view override returns (uint256) {
808         return _allowances[owner][spender];
809     }
810 
811     function approve(address spender, uint256 amount) public override returns (bool) {
812         _approve(_msgSender(), spender, amount);
813         return true;
814     }
815 
816     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
817         _transfer(sender, recipient, amount);
818         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
819         return true;
820     }
821 
822     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
823         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
824         return true;
825     }
826 
827     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
828         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
829         return true;
830     }
831 
832     function isExcludedFromReward(address account) public view returns (bool) {
833         return _isExcluded[account];
834     }
835 
836     function totalFees() public view returns (uint256) {
837         return _tFeeTotal;
838     }
839 
840     function deliver(uint256 tAmount) public {
841         address sender = _msgSender();
842         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
843         (uint256 rAmount,,,,,) = _getValues(tAmount);
844         _rOwned[sender] = _rOwned[sender].sub(rAmount);
845         _rTotal = _rTotal.sub(rAmount);
846         _tFeeTotal = _tFeeTotal.add(tAmount);
847     }
848 
849     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
850         require(tAmount <= _tTotal, "Amount must be less than supply");
851         if (!deductTransferFee) {
852             (uint256 rAmount,,,,,) = _getValues(tAmount);
853             return rAmount;
854         } else {
855             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
856             return rTransferAmount;
857         }
858     }
859 
860     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
861         require(rAmount <= _rTotal, "Amount must be less than total reflections");
862         uint256 currentRate =  _getRate();
863         return rAmount.div(currentRate);
864     }
865 
866     function excludeFromReward(address account) public onlyOwner() {
867         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
868         require(!_isExcluded[account], "Account is already excluded");
869         if(_rOwned[account] > 0) {
870             _tOwned[account] = tokenFromReflection(_rOwned[account]);
871         }
872         _isExcluded[account] = true;
873         _excluded.push(account);
874     }
875 
876     function includeInReward(address account) external onlyOwner() {
877         require(_isExcluded[account], "Account is already excluded");
878         for (uint256 i = 0; i < _excluded.length; i++) {
879             if (_excluded[i] == account) {
880                 _excluded[i] = _excluded[_excluded.length - 1];
881                 _tOwned[account] = 0;
882                 _isExcluded[account] = false;
883                 _excluded.pop();
884                 break;
885             }
886         }
887     }
888         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
889         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
890         _tOwned[sender] = _tOwned[sender].sub(tAmount);
891         _rOwned[sender] = _rOwned[sender].sub(rAmount);
892         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
893         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
894         _takeLiquidity(tLiquidity);
895         _reflectFee(rFee, tFee);
896         emit Transfer(sender, recipient, tTransferAmount);
897     }
898     
899         function excludeFromFee(address account) public onlyOwner {
900         _isExcludedFromFee[account] = true;
901     }
902     
903     function includeInFee(address account) public onlyOwner {
904         _isExcludedFromFee[account] = false;
905     }
906     
907     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
908         _taxFee = taxFee;
909     }
910     
911     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
912         _liquidityFee = liquidityFee;
913     }
914    
915     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
916         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
917             10**2
918         );
919     }
920 
921     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
922         swapAndLiquifyEnabled = _enabled;
923         emit SwapAndLiquifyEnabledUpdated(_enabled);
924     }
925     
926      //to recieve ETH from uniswapV2Router when swaping
927     receive() external payable {}
928 
929     function _reflectFee(uint256 rFee, uint256 tFee) private {
930         _rTotal = _rTotal.sub(rFee);
931         _tFeeTotal = _tFeeTotal.add(tFee);
932     }
933 
934     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
935         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
936         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
937         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
938     }
939 
940     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
941         uint256 tFee = calculateTaxFee(tAmount);
942         uint256 tLiquidity = calculateLiquidityFee(tAmount);
943         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
944         return (tTransferAmount, tFee, tLiquidity);
945     }
946 
947     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
948         uint256 rAmount = tAmount.mul(currentRate);
949         uint256 rFee = tFee.mul(currentRate);
950         uint256 rLiquidity = tLiquidity.mul(currentRate);
951         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
952         return (rAmount, rTransferAmount, rFee);
953     }
954 
955     function _getRate() private view returns(uint256) {
956         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
957         return rSupply.div(tSupply);
958     }
959 
960     function _getCurrentSupply() private view returns(uint256, uint256) {
961         uint256 rSupply = _rTotal;
962         uint256 tSupply = _tTotal;      
963         for (uint256 i = 0; i < _excluded.length; i++) {
964             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
965             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
966             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
967         }
968         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
969         return (rSupply, tSupply);
970     }
971     
972     function _takeLiquidity(uint256 tLiquidity) private {
973         uint256 currentRate =  _getRate();
974         uint256 rLiquidity = tLiquidity.mul(currentRate);
975         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
976         if(_isExcluded[address(this)])
977             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
978     }
979     
980     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
981         return _amount.mul(_taxFee).div(
982             10**2
983         );
984     }
985 
986     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
987         return _amount.mul(_liquidityFee).div(
988             10**2
989         );
990     }
991     
992     function removeAllFee() private {
993         if(_taxFee == 0 && _liquidityFee == 0) return;
994         
995         _previousTaxFee = _taxFee;
996         _previousLiquidityFee = _liquidityFee;
997         
998         _taxFee = 0;
999         _liquidityFee = 0;
1000     }
1001     
1002     function restoreAllFee() private {
1003         _taxFee = _previousTaxFee;
1004         _liquidityFee = _previousLiquidityFee;
1005     }
1006     
1007     function isExcludedFromFee(address account) public view returns(bool) {
1008         return _isExcludedFromFee[account];
1009     }
1010 
1011     function _approve(address owner, address spender, uint256 amount) private {
1012         require(owner != address(0), "ERC20: approve from the zero address");
1013         require(spender != address(0), "ERC20: approve to the zero address");
1014 
1015         _allowances[owner][spender] = amount;
1016         emit Approval(owner, spender, amount);
1017     }
1018 
1019     function _transfer(
1020         address from,
1021         address to,
1022         uint256 amount
1023     ) private {
1024         require(from != address(0), "ERC20: transfer from the zero address");
1025         require(to != address(0), "ERC20: transfer to the zero address");
1026         require(amount > 0, "Transfer amount must be greater than zero");
1027         if(from != owner() && to != owner())
1028             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1029 
1030         // is the token balance of this contract address over the min number of
1031         // tokens that we need to initiate a swap + liquidity lock?
1032         // also, don't get caught in a circular liquidity event.
1033         // also, don't swap & liquify if sender is uniswap pair.
1034         uint256 contractTokenBalance = balanceOf(address(this));
1035         
1036         if(contractTokenBalance >= _maxTxAmount)
1037         {
1038             contractTokenBalance = _maxTxAmount;
1039         }
1040         
1041         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1042         if (
1043             overMinTokenBalance &&
1044             !inSwapAndLiquify &&
1045             from != uniswapV2Pair &&
1046             swapAndLiquifyEnabled
1047         ) {
1048             contractTokenBalance = numTokensSellToAddToLiquidity;
1049             //add liquidity
1050             swapAndLiquify(contractTokenBalance);
1051         }
1052         
1053         //indicates if fee should be deducted from transfer
1054         bool takeFee = true;
1055         
1056         //if any account belongs to _isExcludedFromFee account then remove the fee
1057         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1058             takeFee = false;
1059         }
1060         
1061         //transfer amount, it will take tax, burn, liquidity fee
1062         _tokenTransfer(from,to,amount,takeFee);
1063     }
1064 
1065     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1066         // split the contract balance into halves
1067         uint256 half = contractTokenBalance.div(2);
1068         uint256 otherHalf = contractTokenBalance.sub(half);
1069 
1070         // capture the contract's current ETH balance.
1071         // this is so that we can capture exactly the amount of ETH that the
1072         // swap creates, and not make the liquidity event include any ETH that
1073         // has been manually sent to the contract
1074         uint256 initialBalance = address(this).balance;
1075 
1076         // swap tokens for ETH
1077         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1078 
1079         // how much ETH did we just swap into?
1080         uint256 newBalance = address(this).balance.sub(initialBalance);
1081 
1082         // add liquidity to uniswap
1083         addLiquidity(otherHalf, newBalance);
1084         
1085         emit SwapAndLiquify(half, newBalance, otherHalf);
1086     }
1087 
1088     function swapTokensForEth(uint256 tokenAmount) private {
1089         // generate the uniswap pair path of token -> weth
1090         address[] memory path = new address[](2);
1091         path[0] = address(this);
1092         path[1] = uniswapV2Router.WETH();
1093 
1094         _approve(address(this), address(uniswapV2Router), tokenAmount);
1095 
1096         // make the swap
1097         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1098             tokenAmount,
1099             0, // accept any amount of ETH
1100             path,
1101             address(this),
1102             block.timestamp
1103         );
1104     }
1105 
1106     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1107         // approve token transfer to cover all possible scenarios
1108         _approve(address(this), address(uniswapV2Router), tokenAmount);
1109 
1110         // add the liquidity
1111         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1112             address(this),
1113             tokenAmount,
1114             0, // slippage is unavoidable
1115             0, // slippage is unavoidable
1116             owner(),
1117             block.timestamp
1118         );
1119     }
1120 
1121     //this method is responsible for taking all fee, if takeFee is true
1122     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1123         if(!takeFee)
1124             removeAllFee();
1125         
1126         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1127             _transferFromExcluded(sender, recipient, amount);
1128         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1129             _transferToExcluded(sender, recipient, amount);
1130         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1131             _transferStandard(sender, recipient, amount);
1132         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1133             _transferBothExcluded(sender, recipient, amount);
1134         } else {
1135             _transferStandard(sender, recipient, amount);
1136         }
1137         
1138         if(!takeFee)
1139             restoreAllFee();
1140     }
1141 
1142     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1143         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1144         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1145         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1146         _takeLiquidity(tLiquidity);
1147         _reflectFee(rFee, tFee);
1148         emit Transfer(sender, recipient, tTransferAmount);
1149     }
1150 
1151     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1152         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1153         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1154         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1155         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1156         _takeLiquidity(tLiquidity);
1157         _reflectFee(rFee, tFee);
1158         emit Transfer(sender, recipient, tTransferAmount);
1159     }
1160 
1161     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1162         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1163         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1164         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1165         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1166         _takeLiquidity(tLiquidity);
1167         _reflectFee(rFee, tFee);
1168         emit Transfer(sender, recipient, tTransferAmount);
1169     }
1170 
1171 
1172     
1173 
1174 }