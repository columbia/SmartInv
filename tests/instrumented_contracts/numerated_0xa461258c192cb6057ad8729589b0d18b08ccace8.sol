1 /*
2     
3  ____    ___                            __        ______                    
4 /\  _`\ /\_ \                          /\ \__    /\__  _\                   
5 \ \ \L\ \//\ \      __      ___      __\ \ ,_\   \/_/\ \/     ___   __  __  
6  \ \ ,__/ \ \ \   /'__`\  /' _ `\  /'__`\ \ \/      \ \ \   /' _ `\/\ \/\ \ 
7   \ \ \/   \_\ \_/\ \L\.\_/\ \/\ \/\  __/\ \ \_      \_\ \__/\ \/\ \ \ \_\ \
8    \ \_\   /\____\ \__/.\_\ \_\ \_\ \____\\ \__\     /\_____\ \_\ \_\ \____/
9     \/_/   \/____/\/__/\/_/\/_/\/_/\/____/ \/__/     \/_____/\/_/\/_/\/___/ 
10 
11     Planet Inu - $PLANETINU
12 
13     Terrestrial planet spotted at the end of the Inu Way galaxy. Inhabitable planet with running water and a good ecosystem, which gives every inhabitant 2% income.
14 
15     Characteristics of the planet:
16     2% reflection 
17     4% liquidity
18     4% marketing
19     2% dev
20 
21     Is the planet safe?
22     Liquidity lock at start ☑️
23     Renouncing at start ☑️
24 
25     Telegram: https://t.me/PlanetInu
26     Website: https://www.planetinutoken.com/
27     Twitter: https://twitter.com/PlanetInu
28 
29 */
30 
31 
32 
33 // SPDX-License-Identifier: Unlicensed
34 
35 pragma solidity ^0.8.9;
36 interface IERC20 {
37 
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120  
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 abstract contract Context {
265     //function _msgSender() internal view virtual returns (address payable) {
266     function _msgSender() internal view virtual returns (address) {
267         return msg.sender;
268     }
269 
270     function _msgData() internal view virtual returns (bytes memory) {
271         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
272         return msg.data;
273     }
274 }
275 
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 /**
416  * @dev Contract module which provides a basic access control mechanism, where
417  * there is an account (an owner) that can be granted exclusive access to
418  * specific functions.
419  *
420  * By default, the owner account will be the one that deploys the contract. This
421  * can later be changed with {transferOwnership}.
422  *
423  * This module is used through inheritance. It will make available the modifier
424  * `onlyOwner`, which can be applied to your functions to restrict their use to
425  * the owner.
426  */
427 contract Ownable is Context {
428     address private _owner;
429     address private _previousOwner;
430     uint256 private _lockTime;
431 
432     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
433 
434     /**
435      * @dev Initializes the contract setting the deployer as the initial owner.
436      */
437     constructor () {
438         address msgSender = _msgSender();
439         _owner = msgSender;
440         emit OwnershipTransferred(address(0), msgSender);
441     }
442 
443     /**
444      * @dev Returns the address of the current owner.
445      */
446     function owner() public view returns (address) {
447         return _owner;
448     }
449 
450     /**
451      * @dev Throws if called by any account other than the owner.
452      */
453     modifier onlyOwner() {
454         require(_owner == _msgSender(), "Ownable: caller is not the owner");
455         _;
456     }
457 
458      /**
459      * @dev Leaves the contract without owner. It will not be possible to call
460      * `onlyOwner` functions anymore. Can only be called by the current owner.
461      *
462      * NOTE: Renouncing ownership will leave the contract without an owner,
463      * thereby removing any functionality that is only available to the owner.
464      */
465     function renounceOwnership() public virtual onlyOwner {
466         emit OwnershipTransferred(_owner, address(0));
467         _owner = address(0);
468     }
469 
470     /**
471      * @dev Transfers ownership of the contract to a new account (`newOwner`).
472      * Can only be called by the current owner.
473      */
474     function transferOwnership(address newOwner) public virtual onlyOwner {
475         require(newOwner != address(0), "Ownable: new owner is the zero address");
476         emit OwnershipTransferred(_owner, newOwner);
477         _owner = newOwner;
478     }
479 
480     function geUnlockTime() public view returns (uint256) {
481         return _lockTime;
482     }
483 
484     //Locks the contract for owner for the amount of time provided
485     function lock(uint256 time) public virtual onlyOwner {
486         _previousOwner = _owner;
487         _owner = address(0);
488         _lockTime = block.timestamp + time;
489         emit OwnershipTransferred(_owner, address(0));
490     }
491     
492     //Unlocks the contract for owner when _lockTime is exceeds
493     function unlock() public virtual {
494         require(_previousOwner == msg.sender, "You don't have permission to unlock");
495         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
496         emit OwnershipTransferred(_owner, _previousOwner);
497         _owner = _previousOwner;
498     }
499 }
500 
501 
502 interface IUniswapV2Factory {
503     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
504 
505     function feeTo() external view returns (address);
506     function feeToSetter() external view returns (address);
507 
508     function getPair(address tokenA, address tokenB) external view returns (address pair);
509     function allPairs(uint) external view returns (address pair);
510     function allPairsLength() external view returns (uint);
511 
512     function createPair(address tokenA, address tokenB) external returns (address pair);
513 
514     function setFeeTo(address) external;
515     function setFeeToSetter(address) external;
516 }
517 
518 
519 
520 interface IUniswapV2Pair {
521     event Approval(address indexed owner, address indexed spender, uint value);
522     event Transfer(address indexed from, address indexed to, uint value);
523 
524     function name() external pure returns (string memory);
525     function symbol() external pure returns (string memory);
526     function decimals() external pure returns (uint8);
527     function totalSupply() external view returns (uint);
528     function balanceOf(address owner) external view returns (uint);
529     function allowance(address owner, address spender) external view returns (uint);
530 
531     function approve(address spender, uint value) external returns (bool);
532     function transfer(address to, uint value) external returns (bool);
533     function transferFrom(address from, address to, uint value) external returns (bool);
534 
535     function DOMAIN_SEPARATOR() external view returns (bytes32);
536     function PERMIT_TYPEHASH() external pure returns (bytes32);
537     function nonces(address owner) external view returns (uint);
538 
539     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
540 
541     event Mint(address indexed sender, uint amount0, uint amount1);
542     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
543     event Swap(
544         address indexed sender,
545         uint amount0In,
546         uint amount1In,
547         uint amount0Out,
548         uint amount1Out,
549         address indexed to
550     );
551     event Sync(uint112 reserve0, uint112 reserve1);
552 
553     function MINIMUM_LIQUIDITY() external pure returns (uint);
554     function factory() external view returns (address);
555     function token0() external view returns (address);
556     function token1() external view returns (address);
557     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
558     function price0CumulativeLast() external view returns (uint);
559     function price1CumulativeLast() external view returns (uint);
560     function kLast() external view returns (uint);
561 
562     function mint(address to) external returns (uint liquidity);
563     function burn(address to) external returns (uint amount0, uint amount1);
564     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
565     function skim(address to) external;
566     function sync() external;
567 
568     function initialize(address, address) external;
569 }
570 
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
668 
669 interface IUniswapV2Router02 is IUniswapV2Router01 {
670     function removeLiquidityETHSupportingFeeOnTransferTokens(
671         address token,
672         uint liquidity,
673         uint amountTokenMin,
674         uint amountETHMin,
675         address to,
676         uint deadline
677     ) external returns (uint amountETH);
678     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
679         address token,
680         uint liquidity,
681         uint amountTokenMin,
682         uint amountETHMin,
683         address to,
684         uint deadline,
685         bool approveMax, uint8 v, bytes32 r, bytes32 s
686     ) external returns (uint amountETH);
687 
688     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
689         uint amountIn,
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external;
695     function swapExactETHForTokensSupportingFeeOnTransferTokens(
696         uint amountOutMin,
697         address[] calldata path,
698         address to,
699         uint deadline
700     ) external payable;
701     function swapExactTokensForETHSupportingFeeOnTransferTokens(
702         uint amountIn,
703         uint amountOutMin,
704         address[] calldata path,
705         address to,
706         uint deadline
707     ) external;
708 }
709 
710 interface IAirdrop {
711     function airdrop(address recipient, uint256 amount) external;
712 }
713 
714 contract PLANETINU is Context, IERC20, Ownable {
715     using SafeMath for uint256;
716     using Address for address;
717 
718     mapping (address => uint256) private _rOwned;
719     mapping (address => uint256) private _tOwned;
720     mapping (address => mapping (address => uint256)) private _allowances;
721 
722     mapping (address => bool) private _isExcludedFromFee;
723 
724     mapping (address => bool) private _isExcluded;
725     address[] private _excluded;
726     
727     mapping (address => bool) private botWallets;
728     bool botscantrade = false;
729     
730     bool public canTrade = false;
731    
732     uint256 private constant MAX = ~uint256(0);
733     uint256 private _tTotal = 69000000000000000000000 * 10**9;
734     uint256 private _rTotal = (MAX - (MAX % _tTotal));
735     uint256 private _tFeeTotal;
736     address public marketingWallet;
737 
738     string private _name = "Planet Inu";
739     string private _symbol = "PLANETINU";
740     uint8 private _decimals = 9;
741     
742     uint256 public _taxFee = 2;
743     uint256 private _previousTaxFee = _taxFee;
744     
745     uint256 public _liquidityFee = 11;
746     uint256 private _previousLiquidityFee = _liquidityFee;
747 
748     IUniswapV2Router02 public immutable uniswapV2Router;
749     address public immutable uniswapV2Pair;
750     
751     bool inSwapAndLiquify;
752     bool public swapAndLiquifyEnabled = true;
753     
754     uint256 public _maxTxAmount = 990000000000000000000 * 10**9;
755     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
756     
757     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
758     event SwapAndLiquifyEnabledUpdated(bool enabled);
759     event SwapAndLiquify(
760         uint256 tokensSwapped,
761         uint256 ethReceived,
762         uint256 tokensIntoLiqudity
763     );
764     
765     modifier lockTheSwap {
766         inSwapAndLiquify = true;
767         _;
768         inSwapAndLiquify = false;
769     }
770     
771     constructor () {
772         _rOwned[_msgSender()] = _rTotal;
773         
774         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
775          // Create a uniswap pair for this new token
776         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
777             .createPair(address(this), _uniswapV2Router.WETH());
778 
779         // set the rest of the contract variables
780         uniswapV2Router = _uniswapV2Router;
781         
782         //exclude owner and this contract from fee
783         _isExcludedFromFee[owner()] = true;
784         _isExcludedFromFee[address(this)] = true;
785         
786         emit Transfer(address(0), _msgSender(), _tTotal);
787     }
788 
789     function name() public view returns (string memory) {
790         return _name;
791     }
792 
793     function symbol() public view returns (string memory) {
794         return _symbol;
795     }
796 
797     function decimals() public view returns (uint8) {
798         return _decimals;
799     }
800 
801     function totalSupply() public view override returns (uint256) {
802         return _tTotal;
803     }
804 
805     function balanceOf(address account) public view override returns (uint256) {
806         if (_isExcluded[account]) return _tOwned[account];
807         return tokenFromReflection(_rOwned[account]);
808     }
809 
810     function transfer(address recipient, uint256 amount) public override returns (bool) {
811         _transfer(_msgSender(), recipient, amount);
812         return true;
813     }
814 
815     function allowance(address owner, address spender) public view override returns (uint256) {
816         return _allowances[owner][spender];
817     }
818 
819     function approve(address spender, uint256 amount) public override returns (bool) {
820         _approve(_msgSender(), spender, amount);
821         return true;
822     }
823 
824     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
825         _transfer(sender, recipient, amount);
826         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
827         return true;
828     }
829 
830     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
831         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
832         return true;
833     }
834 
835     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
836         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
837         return true;
838     }
839 
840     function isExcludedFromReward(address account) public view returns (bool) {
841         return _isExcluded[account];
842     }
843 
844     function totalFees() public view returns (uint256) {
845         return _tFeeTotal;
846     }
847     
848     function airdrop(address recipient, uint256 amount) external onlyOwner() {
849         removeAllFee();
850         _transfer(_msgSender(), recipient, amount * 10**9);
851         restoreAllFee();
852     }
853     
854     function airdropInternal(address recipient, uint256 amount) internal {
855         removeAllFee();
856         _transfer(_msgSender(), recipient, amount);
857         restoreAllFee();
858     }
859     
860     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
861         uint256 iterator = 0;
862         require(newholders.length == amounts.length, "must be the same length");
863         while(iterator < newholders.length){
864             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
865             iterator += 1;
866         }
867     }
868 
869     function deliver(uint256 tAmount) public {
870         address sender = _msgSender();
871         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
872         (uint256 rAmount,,,,,) = _getValues(tAmount);
873         _rOwned[sender] = _rOwned[sender].sub(rAmount);
874         _rTotal = _rTotal.sub(rAmount);
875         _tFeeTotal = _tFeeTotal.add(tAmount);
876     }
877 
878     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
879         require(tAmount <= _tTotal, "Amount must be less than supply");
880         if (!deductTransferFee) {
881             (uint256 rAmount,,,,,) = _getValues(tAmount);
882             return rAmount;
883         } else {
884             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
885             return rTransferAmount;
886         }
887     }
888 
889     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
890         require(rAmount <= _rTotal, "Amount must be less than total reflections");
891         uint256 currentRate =  _getRate();
892         return rAmount.div(currentRate);
893     }
894 
895     function excludeFromReward(address account) public onlyOwner() {
896         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
897         require(!_isExcluded[account], "Account is already excluded");
898         if(_rOwned[account] > 0) {
899             _tOwned[account] = tokenFromReflection(_rOwned[account]);
900         }
901         _isExcluded[account] = true;
902         _excluded.push(account);
903     }
904 
905     function includeInReward(address account) external onlyOwner() {
906         require(_isExcluded[account], "Account is already excluded");
907         for (uint256 i = 0; i < _excluded.length; i++) {
908             if (_excluded[i] == account) {
909                 _excluded[i] = _excluded[_excluded.length - 1];
910                 _tOwned[account] = 0;
911                 _isExcluded[account] = false;
912                 _excluded.pop();
913                 break;
914             }
915         }
916     }
917         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
918         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
919         _tOwned[sender] = _tOwned[sender].sub(tAmount);
920         _rOwned[sender] = _rOwned[sender].sub(rAmount);
921         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
922         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
923         _takeLiquidity(tLiquidity);
924         _reflectFee(rFee, tFee);
925         emit Transfer(sender, recipient, tTransferAmount);
926     }
927     
928     function excludeFromFee(address account) public onlyOwner {
929         _isExcludedFromFee[account] = true;
930     }
931     
932     function includeInFee(address account) public onlyOwner {
933         _isExcludedFromFee[account] = false;
934     }
935 
936     function setMarketingWallet(address walletAddress) public onlyOwner {
937         marketingWallet = walletAddress;
938     }
939     
940     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
941         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
942         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
943     }
944     
945     function claimTokens () public onlyOwner {
946         // make sure we capture all BNB that may or may not be sent to this contract
947         payable(marketingWallet).transfer(address(this).balance);
948     }
949     
950     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
951         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
952     }
953     
954     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
955         walletaddress.transfer(address(this).balance);
956     }
957     
958     function addBotWallet(address botwallet) external onlyOwner() {
959         botWallets[botwallet] = true;
960     }
961     
962     function removeBotWallet(address botwallet) external onlyOwner() {
963         botWallets[botwallet] = false;
964     }
965     
966     function getBotWalletStatus(address botwallet) public view returns (bool) {
967         return botWallets[botwallet];
968     }
969     
970     function allowtrading()external onlyOwner() {
971         canTrade = true;
972     }
973 
974     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
975         swapAndLiquifyEnabled = _enabled;
976         emit SwapAndLiquifyEnabledUpdated(_enabled);
977     }
978     
979      //to recieve ETH from uniswapV2Router when swaping
980     receive() external payable {}
981 
982     function _reflectFee(uint256 rFee, uint256 tFee) private {
983         _rTotal = _rTotal.sub(rFee);
984         _tFeeTotal = _tFeeTotal.add(tFee);
985     }
986 
987     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
988         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
989         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
990         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
991     }
992 
993     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
994         uint256 tFee = calculateTaxFee(tAmount);
995         uint256 tLiquidity = calculateLiquidityFee(tAmount);
996         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
997         return (tTransferAmount, tFee, tLiquidity);
998     }
999 
1000     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1001         uint256 rAmount = tAmount.mul(currentRate);
1002         uint256 rFee = tFee.mul(currentRate);
1003         uint256 rLiquidity = tLiquidity.mul(currentRate);
1004         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1005         return (rAmount, rTransferAmount, rFee);
1006     }
1007 
1008     function _getRate() private view returns(uint256) {
1009         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1010         return rSupply.div(tSupply);
1011     }
1012 
1013     function _getCurrentSupply() private view returns(uint256, uint256) {
1014         uint256 rSupply = _rTotal;
1015         uint256 tSupply = _tTotal;      
1016         for (uint256 i = 0; i < _excluded.length; i++) {
1017             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1018             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1019             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1020         }
1021         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1022         return (rSupply, tSupply);
1023     }
1024     
1025     function _takeLiquidity(uint256 tLiquidity) private {
1026         uint256 currentRate =  _getRate();
1027         uint256 rLiquidity = tLiquidity.mul(currentRate);
1028         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1029         if(_isExcluded[address(this)])
1030             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1031     }
1032     
1033     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1034         return _amount.mul(_taxFee).div(
1035             10**2
1036         );
1037     }
1038 
1039     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1040         return _amount.mul(_liquidityFee).div(
1041             10**2
1042         );
1043     }
1044     
1045     function removeAllFee() private {
1046         if(_taxFee == 0 && _liquidityFee == 0) return;
1047         
1048         _previousTaxFee = _taxFee;
1049         _previousLiquidityFee = _liquidityFee;
1050         
1051         _taxFee = 0;
1052         _liquidityFee = 0;
1053     }
1054     
1055     function restoreAllFee() private {
1056         _taxFee = _previousTaxFee;
1057         _liquidityFee = _previousLiquidityFee;
1058     }
1059     
1060     function isExcludedFromFee(address account) public view returns(bool) {
1061         return _isExcludedFromFee[account];
1062     }
1063 
1064     function _approve(address owner, address spender, uint256 amount) private {
1065         require(owner != address(0), "ERC20: approve from the zero address");
1066         require(spender != address(0), "ERC20: approve to the zero address");
1067 
1068         _allowances[owner][spender] = amount;
1069         emit Approval(owner, spender, amount);
1070     }
1071 
1072     function _transfer(
1073         address from,
1074         address to,
1075         uint256 amount
1076     ) private {
1077         require(from != address(0), "ERC20: transfer from the zero address");
1078         require(to != address(0), "ERC20: transfer to the zero address");
1079         require(amount > 0, "Transfer amount must be greater than zero");
1080         if(from != owner() && to != owner())
1081             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1082 
1083         // is the token balance of this contract address over the min number of
1084         // tokens that we need to initiate a swap + liquidity lock?
1085         // also, don't get caught in a circular liquidity event.
1086         // also, don't swap & liquify if sender is uniswap pair.
1087         uint256 contractTokenBalance = balanceOf(address(this));
1088         
1089         if(contractTokenBalance >= _maxTxAmount)
1090         {
1091             contractTokenBalance = _maxTxAmount;
1092         }
1093         
1094         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1095         if (
1096             overMinTokenBalance &&
1097             !inSwapAndLiquify &&
1098             from != uniswapV2Pair &&
1099             swapAndLiquifyEnabled
1100         ) {
1101             contractTokenBalance = numTokensSellToAddToLiquidity;
1102             //add liquidity
1103             swapAndLiquify(contractTokenBalance);
1104         }
1105         
1106         //indicates if fee should be deducted from transfer
1107         bool takeFee = true;
1108         
1109         //if any account belongs to _isExcludedFromFee account then remove the fee
1110         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1111             takeFee = false;
1112         }
1113         
1114         //transfer amount, it will take tax, burn, liquidity fee
1115         _tokenTransfer(from,to,amount,takeFee);
1116     }
1117 
1118     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1119         // split the contract balance into halves
1120         // add the marketing wallet
1121         uint256 half = contractTokenBalance.div(2);
1122         uint256 otherHalf = contractTokenBalance.sub(half);
1123 
1124         // capture the contract's current ETH balance.
1125         // this is so that we can capture exactly the amount of ETH that the
1126         // swap creates, and not make the liquidity event include any ETH that
1127         // has been manually sent to the contract
1128         uint256 initialBalance = address(this).balance;
1129 
1130         // swap tokens for ETH
1131         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1132 
1133         // how much ETH did we just swap into?
1134         uint256 newBalance = address(this).balance.sub(initialBalance);
1135         uint256 marketingshare = newBalance.mul(75).div(100);
1136         payable(marketingWallet).transfer(marketingshare);
1137         newBalance -= marketingshare;
1138         // add liquidity to uniswap
1139         addLiquidity(otherHalf, newBalance);
1140         
1141         emit SwapAndLiquify(half, newBalance, otherHalf);
1142     }
1143 
1144     function swapTokensForEth(uint256 tokenAmount) private {
1145         // generate the uniswap pair path of token -> weth
1146         address[] memory path = new address[](2);
1147         path[0] = address(this);
1148         path[1] = uniswapV2Router.WETH();
1149 
1150         _approve(address(this), address(uniswapV2Router), tokenAmount);
1151 
1152         // make the swap
1153         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1154             tokenAmount,
1155             0, // accept any amount of ETH
1156             path,
1157             address(this),
1158             block.timestamp
1159         );
1160     }
1161 
1162     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1163         // approve token transfer to cover all possible scenarios
1164         _approve(address(this), address(uniswapV2Router), tokenAmount);
1165 
1166         // add the liquidity
1167         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1168             address(this),
1169             tokenAmount,
1170             0, // slippage is unavoidable
1171             0, // slippage is unavoidable
1172             owner(),
1173             block.timestamp
1174         );
1175     }
1176 
1177     //this method is responsible for taking all fee, if takeFee is true
1178     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1179         if(!canTrade){
1180             require(sender == owner()); // only owner allowed to trade or add liquidity
1181         }
1182         
1183         if(botWallets[sender] || botWallets[recipient]){
1184             require(botscantrade, "bots arent allowed to trade");
1185         }
1186         
1187         if(!takeFee)
1188             removeAllFee();
1189         
1190         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1191             _transferFromExcluded(sender, recipient, amount);
1192         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1193             _transferToExcluded(sender, recipient, amount);
1194         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1195             _transferStandard(sender, recipient, amount);
1196         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1197             _transferBothExcluded(sender, recipient, amount);
1198         } else {
1199             _transferStandard(sender, recipient, amount);
1200         }
1201         
1202         if(!takeFee)
1203             restoreAllFee();
1204     }
1205 
1206     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1207         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1208         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1209         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1210         _takeLiquidity(tLiquidity);
1211         _reflectFee(rFee, tFee);
1212         emit Transfer(sender, recipient, tTransferAmount);
1213     }
1214 
1215     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1216         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1217         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1218         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1219         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1220         _takeLiquidity(tLiquidity);
1221         _reflectFee(rFee, tFee);
1222         emit Transfer(sender, recipient, tTransferAmount);
1223     }
1224 
1225     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1226         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1227         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1228         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1229         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1230         _takeLiquidity(tLiquidity);
1231         _reflectFee(rFee, tFee);
1232         emit Transfer(sender, recipient, tTransferAmount);
1233     }
1234 
1235 }