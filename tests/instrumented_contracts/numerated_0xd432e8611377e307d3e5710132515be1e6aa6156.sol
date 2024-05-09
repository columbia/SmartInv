1 /**
2  *Submitted for verification at BscScan.com on 2021-02-26
3 */
4 
5 /**
6    #PIG
7    
8    #LIQ+#RFI+#SHIB+#DOGE, combine together to #PIG  
9 
10     I make this #PIG to hand over it to the community.
11     Create the community by yourself if you are interested.   
12     I suggest a telegram group name for you to create: https://t.me/PigTokenBSC
13 
14    Great features:
15    3% fee auto add to the liquidity pool to locked forever when selling
16    2% fee auto distribute to all holders
17    50% burn to the black hole, with such big black hole and 3% fee, the strong holder will get a valuable reward
18 
19    I will burn liquidity LPs to burn addresses to lock the pool forever.
20    I will renounce the ownership to burn addresses to transfer #PIG to the community, make sure it's 100% safe.
21 
22    I will add 0.999 BNB and all the left 49.5% total supply to the pool
23    Can you make #PIG 10000000X? 
24 
25    1,000,000,000,000,000 total supply
26    5,000,000,000,000 tokens limitation for trade
27    0.5% tokens for dev
28 
29    3% fee for liquidity will go to an address that the contract creates, 
30    and the contract will sell it and add to liquidity automatically, 
31    it's the best part of the #PIG idea, increasing the liquidity pool automatically, 
32    help the pool grow from the small init pool.
33 
34  */
35 
36 pragma solidity ^0.6.12;
37 // SPDX-License-Identifier: Unlicensed
38 interface IERC20 {
39 
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 
109 /**
110  * @dev Wrappers over Solidity's arithmetic operations with added overflow
111  * checks.
112  *
113  * Arithmetic operations in Solidity wrap on overflow. This can easily result
114  * in bugs, because programmers usually assume that an overflow raises an
115  * error, which is the standard behavior in high level programming languages.
116  * `SafeMath` restores this intuition by reverting the transaction when an
117  * operation overflows.
118  *
119  * Using this library instead of the unchecked operations eliminates an entire
120  * class of bugs, so it's recommended to use it always.
121  */
122  
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 abstract contract Context {
267     function _msgSender() internal view virtual returns (address payable) {
268         return msg.sender;
269     }
270 
271     function _msgData() internal view virtual returns (bytes memory) {
272         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
273         return msg.data;
274     }
275 }
276 
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
301         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
302         // for accounts without code, i.e. `keccak256('')`
303         bytes32 codehash;
304         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
305         // solhint-disable-next-line no-inline-assembly
306         assembly { codehash := extcodehash(account) }
307         return (codehash != accountHash && codehash != 0x0);
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330         (bool success, ) = recipient.call{ value: amount }("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353       return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         return _functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         return _functionCallWithValue(target, data, value, errorMessage);
390     }
391 
392     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
393         require(isContract(target), "Address: call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 // solhint-disable-next-line no-inline-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 /**
417  * @dev Contract module which provides a basic access control mechanism, where
418  * there is an account (an owner) that can be granted exclusive access to
419  * specific functions.
420  *
421  * By default, the owner account will be the one that deploys the contract. This
422  * can later be changed with {transferOwnership}.
423  *
424  * This module is used through inheritance. It will make available the modifier
425  * `onlyOwner`, which can be applied to your functions to restrict their use to
426  * the owner.
427  */
428 contract Ownable is Context {
429     address private _owner;
430     address private _previousOwner;
431     uint256 private _lockTime;
432 
433     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
434 
435     /**
436      * @dev Initializes the contract setting the deployer as the initial owner.
437      */
438     constructor () internal {
439         address msgSender = _msgSender();
440         _owner = msgSender;
441         emit OwnershipTransferred(address(0), msgSender);
442     }
443 
444     /**
445      * @dev Returns the address of the current owner.
446      */
447     function owner() public view returns (address) {
448         return _owner;
449     }
450 
451     /**
452      * @dev Throws if called by any account other than the owner.
453      */
454     modifier onlyOwner() {
455         require(_owner == _msgSender(), "Ownable: caller is not the owner");
456         _;
457     }
458 
459      /**
460      * @dev Leaves the contract without owner. It will not be possible to call
461      * `onlyOwner` functions anymore. Can only be called by the current owner.
462      *
463      * NOTE: Renouncing ownership will leave the contract without an owner,
464      * thereby removing any functionality that is only available to the owner.
465      */
466     function renounceOwnership() public virtual onlyOwner {
467         emit OwnershipTransferred(_owner, address(0));
468         _owner = address(0);
469     }
470 
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Can only be called by the current owner.
474      */
475     function transferOwnership(address newOwner) public virtual onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         emit OwnershipTransferred(_owner, newOwner);
478         _owner = newOwner;
479     }
480 
481     function geUnlockTime() public view returns (uint256) {
482         return _lockTime;
483     }
484 
485     //Locks the contract for owner for the amount of time provided
486     function lock(uint256 time) public virtual onlyOwner {
487         _previousOwner = _owner;
488         _owner = address(0);
489         _lockTime = now + time;
490         emit OwnershipTransferred(_owner, address(0));
491     }
492     
493     //Unlocks the contract for owner when _lockTime is exceeds
494     function unlock() public virtual {
495         require(_previousOwner == msg.sender, "You don't have permission to unlock");
496         require(now > _lockTime , "Contract is locked until 7 days");
497         emit OwnershipTransferred(_owner, _previousOwner);
498         _owner = _previousOwner;
499     }
500 }
501 
502 // pragma solidity >=0.5.0;
503 
504 interface IUniswapV2Factory {
505     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
506 
507     function feeTo() external view returns (address);
508     function feeToSetter() external view returns (address);
509 
510     function getPair(address tokenA, address tokenB) external view returns (address pair);
511     function allPairs(uint) external view returns (address pair);
512     function allPairsLength() external view returns (uint);
513 
514     function createPair(address tokenA, address tokenB) external returns (address pair);
515 
516     function setFeeTo(address) external;
517     function setFeeToSetter(address) external;
518 }
519 
520 
521 // pragma solidity >=0.5.0;
522 
523 interface IUniswapV2Pair {
524     event Approval(address indexed owner, address indexed spender, uint value);
525     event Transfer(address indexed from, address indexed to, uint value);
526 
527     function name() external pure returns (string memory);
528     function symbol() external pure returns (string memory);
529     function decimals() external pure returns (uint8);
530     function totalSupply() external view returns (uint);
531     function balanceOf(address owner) external view returns (uint);
532     function allowance(address owner, address spender) external view returns (uint);
533 
534     function approve(address spender, uint value) external returns (bool);
535     function transfer(address to, uint value) external returns (bool);
536     function transferFrom(address from, address to, uint value) external returns (bool);
537 
538     function DOMAIN_SEPARATOR() external view returns (bytes32);
539     function PERMIT_TYPEHASH() external pure returns (bytes32);
540     function nonces(address owner) external view returns (uint);
541 
542     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
543 
544     event Mint(address indexed sender, uint amount0, uint amount1);
545     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
546     event Swap(
547         address indexed sender,
548         uint amount0In,
549         uint amount1In,
550         uint amount0Out,
551         uint amount1Out,
552         address indexed to
553     );
554     event Sync(uint112 reserve0, uint112 reserve1);
555 
556     function MINIMUM_LIQUIDITY() external pure returns (uint);
557     function factory() external view returns (address);
558     function token0() external view returns (address);
559     function token1() external view returns (address);
560     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
561     function price0CumulativeLast() external view returns (uint);
562     function price1CumulativeLast() external view returns (uint);
563     function kLast() external view returns (uint);
564 
565     function mint(address to) external returns (uint liquidity);
566     function burn(address to) external returns (uint amount0, uint amount1);
567     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
568     function skim(address to) external;
569     function sync() external;
570 
571     function initialize(address, address) external;
572 }
573 
574 // pragma solidity >=0.6.2;
575 
576 interface IUniswapV2Router01 {
577     function factory() external pure returns (address);
578     function WETH() external pure returns (address);
579 
580     function addLiquidity(
581         address tokenA,
582         address tokenB,
583         uint amountADesired,
584         uint amountBDesired,
585         uint amountAMin,
586         uint amountBMin,
587         address to,
588         uint deadline
589     ) external returns (uint amountA, uint amountB, uint liquidity);
590     function addLiquidityETH(
591         address token,
592         uint amountTokenDesired,
593         uint amountTokenMin,
594         uint amountETHMin,
595         address to,
596         uint deadline
597     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
598     function removeLiquidity(
599         address tokenA,
600         address tokenB,
601         uint liquidity,
602         uint amountAMin,
603         uint amountBMin,
604         address to,
605         uint deadline
606     ) external returns (uint amountA, uint amountB);
607     function removeLiquidityETH(
608         address token,
609         uint liquidity,
610         uint amountTokenMin,
611         uint amountETHMin,
612         address to,
613         uint deadline
614     ) external returns (uint amountToken, uint amountETH);
615     function removeLiquidityWithPermit(
616         address tokenA,
617         address tokenB,
618         uint liquidity,
619         uint amountAMin,
620         uint amountBMin,
621         address to,
622         uint deadline,
623         bool approveMax, uint8 v, bytes32 r, bytes32 s
624     ) external returns (uint amountA, uint amountB);
625     function removeLiquidityETHWithPermit(
626         address token,
627         uint liquidity,
628         uint amountTokenMin,
629         uint amountETHMin,
630         address to,
631         uint deadline,
632         bool approveMax, uint8 v, bytes32 r, bytes32 s
633     ) external returns (uint amountToken, uint amountETH);
634     function swapExactTokensForTokens(
635         uint amountIn,
636         uint amountOutMin,
637         address[] calldata path,
638         address to,
639         uint deadline
640     ) external returns (uint[] memory amounts);
641     function swapTokensForExactTokens(
642         uint amountOut,
643         uint amountInMax,
644         address[] calldata path,
645         address to,
646         uint deadline
647     ) external returns (uint[] memory amounts);
648     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
649         external
650         payable
651         returns (uint[] memory amounts);
652     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
653         external
654         returns (uint[] memory amounts);
655     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
656         external
657         returns (uint[] memory amounts);
658     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
659         external
660         payable
661         returns (uint[] memory amounts);
662 
663     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
664     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
665     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
666     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
667     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
668 }
669 
670 
671 
672 // pragma solidity >=0.6.2;
673 
674 interface IUniswapV2Router02 is IUniswapV2Router01 {
675     function removeLiquidityETHSupportingFeeOnTransferTokens(
676         address token,
677         uint liquidity,
678         uint amountTokenMin,
679         uint amountETHMin,
680         address to,
681         uint deadline
682     ) external returns (uint amountETH);
683     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
684         address token,
685         uint liquidity,
686         uint amountTokenMin,
687         uint amountETHMin,
688         address to,
689         uint deadline,
690         bool approveMax, uint8 v, bytes32 r, bytes32 s
691     ) external returns (uint amountETH);
692 
693     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
694         uint amountIn,
695         uint amountOutMin,
696         address[] calldata path,
697         address to,
698         uint deadline
699     ) external;
700     function swapExactETHForTokensSupportingFeeOnTransferTokens(
701         uint amountOutMin,
702         address[] calldata path,
703         address to,
704         uint deadline
705     ) external payable;
706     function swapExactTokensForETHSupportingFeeOnTransferTokens(
707         uint amountIn,
708         uint amountOutMin,
709         address[] calldata path,
710         address to,
711         uint deadline
712     ) external;
713 }
714 
715 
716 contract PigToken is Context, IERC20, Ownable {
717     using SafeMath for uint256;
718     using Address for address;
719 
720     mapping (address => uint256) private _rOwned;
721     mapping (address => uint256) private _tOwned;
722     mapping (address => mapping (address => uint256)) private _allowances;
723 
724     mapping (address => bool) private _isExcludedFromFee;
725 
726     mapping (address => bool) private _isExcluded;
727     address[] private _excluded;
728    
729     uint256 private constant MAX = ~uint256(0);
730     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
731     uint256 private _rTotal = (MAX - (MAX % _tTotal));
732     uint256 private _tFeeTotal;
733 
734     string private _name = "FaceDao Token";
735     string private _symbol = "FACE";
736     uint8 private _decimals = 9;
737     
738     uint256 public _taxFee = 25;
739     uint256 private _previousTaxFee = _taxFee;
740     
741     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
742     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
743     
744     address burnAddress = 0x8888888888888888888888888888888888888888;
745 
746     constructor () public {
747         _rOwned[_msgSender()] = _rTotal;
748         //exclude owner and this contract from fee
749         _isExcludedFromFee[owner()] = true;
750         _isExcludedFromFee[address(this)] = true;
751         _isExcludedFromFee[address(0xcFf09971465C2c836326fF4cd68451c31D0F6531)] = true;
752         emit Transfer(address(0), _msgSender(), _tTotal);
753     }
754 
755     function name() public view returns (string memory) {
756         return _name;
757     }
758 
759     function symbol() public view returns (string memory) {
760         return _symbol;
761     }
762 
763     function decimals() public view returns (uint8) {
764         return _decimals;
765     }
766 
767     function totalSupply() public view override returns (uint256) {
768         return _tTotal;
769     }
770 
771     function balanceOf(address account) public view override returns (uint256) {
772         if (_isExcluded[account]) return _tOwned[account];
773         return tokenFromReflection(_rOwned[account]);
774     }
775 
776     function transfer(address recipient, uint256 amount) public override returns (bool) {
777         _transfer(_msgSender(), recipient, amount);
778         return true;
779     }
780 
781     function allowance(address owner, address spender) public view override returns (uint256) {
782         return _allowances[owner][spender];
783     }
784 
785     function approve(address spender, uint256 amount) public override returns (bool) {
786         _approve(_msgSender(), spender, amount);
787         return true;
788     }
789 
790     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
791         _transfer(sender, recipient, amount);
792         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
793         return true;
794     }
795 
796     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
798         return true;
799     }
800 
801     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
802         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
803         return true;
804     }
805 
806     function isExcludedFromReward(address account) public view returns (bool) {
807         return _isExcluded[account];
808     }
809 
810     function totalFees() public view returns (uint256) {
811         return _tFeeTotal;
812     }
813 
814     function deliver(uint256 tAmount) public {
815         address sender = _msgSender();
816         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
817         (uint256 rAmount,,,,,) = _getValues(tAmount);
818         _rOwned[sender] = _rOwned[sender].sub(rAmount);
819         _rTotal = _rTotal.sub(rAmount);
820         _tFeeTotal = _tFeeTotal.add(tAmount);
821     }
822 
823     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
824         require(tAmount <= _tTotal, "Amount must be less than supply");
825         if (!deductTransferFee) {
826             (uint256 rAmount,,,,,) = _getValues(tAmount);
827             return rAmount;
828         } else {
829             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
830             return rTransferAmount;
831         }
832     }
833 
834     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
835         require(rAmount <= _rTotal, "Amount must be less than total reflections");
836         uint256 currentRate =  _getRate();
837         return rAmount.div(currentRate);
838     }
839 
840     function excludeFromReward(address account) public onlyOwner() {
841         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
842         require(!_isExcluded[account], "Account is already excluded");
843         if(_rOwned[account] > 0) {
844             _tOwned[account] = tokenFromReflection(_rOwned[account]);
845         }
846         _isExcluded[account] = true;
847         _excluded.push(account);
848     }
849 
850     function includeInReward(address account) external onlyOwner() {
851         require(_isExcluded[account], "Account is already excluded");
852         for (uint256 i = 0; i < _excluded.length; i++) {
853             if (_excluded[i] == account) {
854                 _excluded[i] = _excluded[_excluded.length - 1];
855                 _tOwned[account] = 0;
856                 _isExcluded[account] = false;
857                 _excluded.pop();
858                 break;
859             }
860         }
861     }
862         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
863         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
864         _tOwned[sender] = _tOwned[sender].sub(tAmount);
865         _rOwned[sender] = _rOwned[sender].sub(rAmount);
866         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
867         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
868         _takeLiquidity(tLiquidity);
869         _reflectFee(rFee, tFee);
870         emit Transfer(sender, burnAddress, tLiquidity);
871         emit Transfer(sender, recipient, tTransferAmount);
872 
873     }
874     
875         function excludeFromFee(address account) public onlyOwner {
876         _isExcludedFromFee[account] = true;
877     }
878     
879     function includeInFee(address account) public onlyOwner {
880         _isExcludedFromFee[account] = false;
881     }
882     
883     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
884         _taxFee = taxFee;
885     }
886      
887     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
888         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
889             10**2
890         );
891     }
892     
893      //to recieve ETH from uniswapV2Router when swaping
894     receive() external payable {}
895 
896     function _reflectFee(uint256 rFee, uint256 tFee) private {
897         _rTotal = _rTotal.sub(rFee);
898         _tFeeTotal = _tFeeTotal.add(tFee);
899     }
900 
901     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
902         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
903         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
904         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
905     }
906 
907     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
908         uint256 tFee = calculateTaxFee(tAmount);
909 
910         uint256 tTransferAmount = tAmount.sub(tFee).sub(tFee);
911         return (tTransferAmount, tFee, tFee);
912     }
913 
914     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
915         uint256 rAmount = tAmount.mul(currentRate);
916         uint256 rFee = tFee.mul(currentRate);
917         uint256 rLiquidity = tLiquidity.mul(currentRate);
918         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
919         return (rAmount, rTransferAmount, rFee);
920     }
921 
922     function _getRate() private view returns(uint256) {
923         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
924         return rSupply.div(tSupply);
925     }
926 
927     function _getCurrentSupply() private view returns(uint256, uint256) {
928         uint256 rSupply = _rTotal;
929         uint256 tSupply = _tTotal;      
930         for (uint256 i = 0; i < _excluded.length; i++) {
931             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
932             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
933             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
934         }
935         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
936         return (rSupply, tSupply);
937     }
938     
939     function _takeLiquidity(uint256 tLiquidity) private {
940         uint256 currentRate =  _getRate();
941         uint256 rLiquidity = tLiquidity.mul(currentRate);
942         _rOwned[address(burnAddress)] = _rOwned[address(burnAddress)].add(rLiquidity);
943         if(_isExcluded[address(burnAddress)])
944             _tOwned[address(burnAddress)] = _tOwned[address(burnAddress)].add(tLiquidity);
945         
946     }
947     
948     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
949         return _amount.mul(_taxFee).div(
950             10**3
951         );
952     }
953     
954     function removeAllFee() private {
955         if(_taxFee == 0 ) return;
956         
957         _previousTaxFee = _taxFee;
958         _taxFee = 0;
959        
960     }
961     
962     function restoreAllFee() private {
963         _taxFee = _previousTaxFee;
964     }
965     
966     function isExcludedFromFee(address account) public view returns(bool) {
967         return _isExcludedFromFee[account];
968     }
969 
970     function _approve(address owner, address spender, uint256 amount) private {
971         require(owner != address(0), "ERC20: approve from the zero address");
972         require(spender != address(0), "ERC20: approve to the zero address");
973 
974         _allowances[owner][spender] = amount;
975         emit Approval(owner, spender, amount);
976     }
977 
978     function _transfer(
979         address from,
980         address to,
981         uint256 amount
982     ) private {
983         require(from != address(0), "ERC20: transfer from the zero address");
984         require(to != address(0), "ERC20: transfer to the zero address");
985         require(amount > 0, "Transfer amount must be greater than zero");
986         if(from != owner() && to != owner())
987             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
988 
989         // is the token balance of this contract address over the min number of
990         // tokens that we need to initiate a swap + liquidity lock?
991         // also, don't get caught in a circular liquidity event.
992         // also, don't swap & liquify if sender is uniswap pair.
993         uint256 contractTokenBalance = balanceOf(address(this));
994         
995         if(contractTokenBalance >= _maxTxAmount)
996         {
997             contractTokenBalance = _maxTxAmount;
998         }   
999         //indicates if fee should be deducted from transfer
1000         bool takeFee = true;
1001         
1002         //if any account belongs to _isExcludedFromFee account then remove the fee
1003         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1004             takeFee = false;
1005         }
1006         
1007         //transfer amount, it will take tax, burn, liquidity fee
1008         _tokenTransfer(from,to,amount,takeFee);
1009     }
1010     //this method is responsible for taking all fee, if takeFee is true
1011     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1012         if(!takeFee)
1013             removeAllFee();
1014         
1015         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1016             _transferFromExcluded(sender, recipient, amount);
1017         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1018             _transferToExcluded(sender, recipient, amount);
1019         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1020             _transferStandard(sender, recipient, amount);
1021         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1022             _transferBothExcluded(sender, recipient, amount);
1023         } else {
1024             _transferStandard(sender, recipient, amount);
1025         }
1026         
1027         if(!takeFee)
1028             restoreAllFee();
1029     }
1030 
1031     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1032         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1033         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1034         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1035         _takeLiquidity(tLiquidity);
1036         _reflectFee(rFee, tFee);
1037         emit Transfer(sender, burnAddress, tLiquidity);
1038         emit Transfer(sender, recipient, tTransferAmount);
1039     }
1040 
1041     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1042         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1043         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1044         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1045         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1046         _takeLiquidity(tLiquidity);
1047         _reflectFee(rFee, tFee);
1048         emit Transfer(sender, burnAddress, tLiquidity);
1049         emit Transfer(sender, recipient, tTransferAmount);
1050     }
1051 
1052     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1053         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1054         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1055         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1056         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1057         _takeLiquidity(tLiquidity);
1058         _reflectFee(rFee, tFee);
1059         emit Transfer(sender, burnAddress, tLiquidity);
1060         emit Transfer(sender, recipient, tTransferAmount);
1061     }
1062 
1063 
1064     
1065 
1066 }