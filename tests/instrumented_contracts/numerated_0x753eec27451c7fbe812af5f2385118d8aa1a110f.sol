1 // 
2 //░██████╗██╗░░██╗██╗██████╗░░█████╗░██╗██╗░░░██╗██████╗░
3 //██╔════╝██║░░██║██║██╔══██╗██╔══██╗██║██║░░░██║╚════██╗
4 //╚█████╗░███████║██║██████╦╝███████║██║╚██╗░██╔╝░░███╔═╝
5 //░╚═══██╗██╔══██║██║██╔══██╗██╔══██║██║░╚████╔╝░██╔══╝░░
6 //██████╔╝██║░░██║██║██████╦╝██║░░██║██║░░╚██╔╝░░███████╗
7 //╚═════╝░╚═╝░░╚═╝╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░░╚═╝░░░╚══════╝
8 
9 //Relaunched Under DevelopereUnited."Bringing Clarity, Honesty & Development To The DeFi Space
10 
11 //Telegram: @shibaiv2portal
12 //DevelopersUnited: @Developersunitedportal
13 //Developersunitedwebsite: Developersunited.org
14 
15 pragma solidity ^0.6.12;
16 // SPDX-License-Identifier: Unlicensed
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101  
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      *
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint256 c = a * b;
170         require(c / a == b, "SafeMath: multiplication overflow");
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return div(a, b, "SafeMath: division by zero");
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b > 0, errorMessage);
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return mod(a, b, "SafeMath: modulo by zero");
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts with custom message when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b != 0, errorMessage);
241         return a % b;
242     }
243 }
244 
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address payable) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes memory) {
251         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
252         return msg.data;
253     }
254 }
255 
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
280         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
281         // for accounts without code, i.e. `keccak256('')`
282         bytes32 codehash;
283         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { codehash := extcodehash(account) }
286         return (codehash != accountHash && codehash != 0x0);
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain`call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332       return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 contract Ownable is Context {
408     address private _owner;
409     address private _previousOwner;
410     uint256 private _lockTime;
411 
412     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
413 
414     /**
415      * @dev Initializes the contract setting the deployer as the initial owner.
416      */
417     constructor () internal {
418         address msgSender = _msgSender();
419         _owner = msgSender;
420         emit OwnershipTransferred(address(0), msgSender);
421     }
422 
423     /**
424      * @dev Returns the address of the current owner.
425      */
426     function owner() public view returns (address) {
427         return _owner;
428     }
429 
430     /**
431      * @dev Throws if called by any account other than the owner.
432      */
433     modifier onlyOwner() {
434         require(_owner == _msgSender(), "Ownable: caller is not the owner");
435         _;
436     }
437 
438      /**
439      * @dev Leaves the contract without owner. It will not be possible to call
440      * `onlyOwner` functions anymore. Can only be called by the current owner.
441      *
442      * NOTE: Renouncing ownership will leave the contract without an owner,
443      * thereby removing any functionality that is only available to the owner.
444      */
445     function renounceOwnership() public virtual onlyOwner {
446         emit OwnershipTransferred(_owner, address(0));
447         _owner = address(0);
448     }
449 
450     /**
451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
452      * Can only be called by the current owner.
453      */
454     function transferOwnership(address newOwner) public virtual onlyOwner {
455         require(newOwner != address(0), "Ownable: new owner is the zero address");
456         emit OwnershipTransferred(_owner, newOwner);
457         _owner = newOwner;
458     }
459 
460     function geUnlockTime() public view returns (uint256) {
461         return _lockTime;
462     }
463 
464     //Locks the contract for owner for the amount of time provided
465     function lock(uint256 time) public virtual onlyOwner {
466         _previousOwner = _owner;
467         _owner = address(0);
468         _lockTime = now + time;
469         emit OwnershipTransferred(_owner, address(0));
470     }
471     
472     //Unlocks the contract for owner when _lockTime is exceeds
473     function unlock() public virtual {
474         require(_previousOwner == msg.sender, "You don't have permission to unlock");
475         require(now > _lockTime , "Contract is locked until 7 days");
476         emit OwnershipTransferred(_owner, _previousOwner);
477         _owner = _previousOwner;
478     }
479 }
480 
481 // pragma solidity >=0.5.0;
482 
483 interface IUniswapV2Factory {
484     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
485 
486     function feeTo() external view returns (address);
487     function feeToSetter() external view returns (address);
488 
489     function getPair(address tokenA, address tokenB) external view returns (address pair);
490     function allPairs(uint) external view returns (address pair);
491     function allPairsLength() external view returns (uint);
492 
493     function createPair(address tokenA, address tokenB) external returns (address pair);
494 
495     function setFeeTo(address) external;
496     function setFeeToSetter(address) external;
497 }
498 
499 
500 // pragma solidity >=0.5.0;
501 
502 interface IUniswapV2Pair {
503     event Approval(address indexed owner, address indexed spender, uint value);
504     event Transfer(address indexed from, address indexed to, uint value);
505 
506     function name() external pure returns (string memory);
507     function symbol() external pure returns (string memory);
508     function decimals() external pure returns (uint8);
509     function totalSupply() external view returns (uint);
510     function balanceOf(address owner) external view returns (uint);
511     function allowance(address owner, address spender) external view returns (uint);
512 
513     function approve(address spender, uint value) external returns (bool);
514     function transfer(address to, uint value) external returns (bool);
515     function transferFrom(address from, address to, uint value) external returns (bool);
516 
517     function DOMAIN_SEPARATOR() external view returns (bytes32);
518     function PERMIT_TYPEHASH() external pure returns (bytes32);
519     function nonces(address owner) external view returns (uint);
520 
521     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
522 
523     event Mint(address indexed sender, uint amount0, uint amount1);
524     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
525     event Swap(
526         address indexed sender,
527         uint amount0In,
528         uint amount1In,
529         uint amount0Out,
530         uint amount1Out,
531         address indexed to
532     );
533     event Sync(uint112 reserve0, uint112 reserve1);
534 
535     function MINIMUM_LIQUIDITY() external pure returns (uint);
536     function factory() external view returns (address);
537     function token0() external view returns (address);
538     function token1() external view returns (address);
539     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
540     function price0CumulativeLast() external view returns (uint);
541     function price1CumulativeLast() external view returns (uint);
542     function kLast() external view returns (uint);
543 
544     function mint(address to) external returns (uint liquidity);
545     function burn(address to) external returns (uint amount0, uint amount1);
546     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
547     function skim(address to) external;
548     function sync() external;
549 
550     function initialize(address, address) external;
551 }
552 
553 // pragma solidity >=0.6.2;
554 
555 interface IUniswapV2Router01 {
556     function factory() external pure returns (address);
557     function WETH() external pure returns (address);
558 
559     function addLiquidity(
560         address tokenA,
561         address tokenB,
562         uint amountADesired,
563         uint amountBDesired,
564         uint amountAMin,
565         uint amountBMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountA, uint amountB, uint liquidity);
569     function addLiquidityETH(
570         address token,
571         uint amountTokenDesired,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline
576     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
577     function removeLiquidity(
578         address tokenA,
579         address tokenB,
580         uint liquidity,
581         uint amountAMin,
582         uint amountBMin,
583         address to,
584         uint deadline
585     ) external returns (uint amountA, uint amountB);
586     function removeLiquidityETH(
587         address token,
588         uint liquidity,
589         uint amountTokenMin,
590         uint amountETHMin,
591         address to,
592         uint deadline
593     ) external returns (uint amountToken, uint amountETH);
594     function removeLiquidityWithPermit(
595         address tokenA,
596         address tokenB,
597         uint liquidity,
598         uint amountAMin,
599         uint amountBMin,
600         address to,
601         uint deadline,
602         bool approveMax, uint8 v, bytes32 r, bytes32 s
603     ) external returns (uint amountA, uint amountB);
604     function removeLiquidityETHWithPermit(
605         address token,
606         uint liquidity,
607         uint amountTokenMin,
608         uint amountETHMin,
609         address to,
610         uint deadline,
611         bool approveMax, uint8 v, bytes32 r, bytes32 s
612     ) external returns (uint amountToken, uint amountETH);
613     function swapExactTokensForTokens(
614         uint amountIn,
615         uint amountOutMin,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external returns (uint[] memory amounts);
620     function swapTokensForExactTokens(
621         uint amountOut,
622         uint amountInMax,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external returns (uint[] memory amounts);
627     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
628         external
629         payable
630         returns (uint[] memory amounts);
631     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
632         external
633         returns (uint[] memory amounts);
634     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
635         external
636         returns (uint[] memory amounts);
637     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
638         external
639         payable
640         returns (uint[] memory amounts);
641 
642     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
643     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
644     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
645     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
646     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
647 }
648 
649 
650 
651 // pragma solidity >=0.6.2;
652 
653 interface IUniswapV2Router02 is IUniswapV2Router01 {
654     function removeLiquidityETHSupportingFeeOnTransferTokens(
655         address token,
656         uint liquidity,
657         uint amountTokenMin,
658         uint amountETHMin,
659         address to,
660         uint deadline
661     ) external returns (uint amountETH);
662     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
663         address token,
664         uint liquidity,
665         uint amountTokenMin,
666         uint amountETHMin,
667         address to,
668         uint deadline,
669         bool approveMax, uint8 v, bytes32 r, bytes32 s
670     ) external returns (uint amountETH);
671 
672     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
673         uint amountIn,
674         uint amountOutMin,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external;
679     function swapExactETHForTokensSupportingFeeOnTransferTokens(
680         uint amountOutMin,
681         address[] calldata path,
682         address to,
683         uint deadline
684     ) external payable;
685     function swapExactTokensForETHSupportingFeeOnTransferTokens(
686         uint amountIn,
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external;
692 }
693 
694 
695 contract ShibAiV2 is Context, IERC20, Ownable {
696     using SafeMath for uint256;
697     using Address for address;
698 
699     mapping (address => uint256) private _rOwned;
700     mapping (address => uint256) private _tOwned;
701     mapping (address => mapping (address => uint256)) private _allowances;
702 
703     mapping (address => bool) private _isExcludedFromFee;
704 
705     mapping (address => bool) private _isExcluded;
706     address[] private _excluded;
707     mapping (address => bool) private _isBlackListedBot;
708     address[] private _blackListedBots;
709    
710     uint256 private constant MAX = ~uint256(0);
711     uint256 private _tTotal = 1000000000 * 10**9;
712     uint256 private _rTotal = (MAX - (MAX % _tTotal));
713     uint256 private _tFeeTotal;
714 
715     string private _name = "ShibAiV2";
716     string private _symbol = "SHIBAIV2";
717     uint8 private _decimals = 9;
718     
719     uint256 public _taxFee = 1;
720     uint256 private _previousTaxFee = _taxFee;
721     
722     uint256 public _liquidityFee = 1;
723     uint256 private _previousLiquidityFee = _liquidityFee;
724 
725     uint256 public _marketingFee = 7; // All taxes are divided by 100 for more accuracy.Back End Bot Will Split Amounts Daily Keeping Gas Fees Low For Investors
726     uint256 private _previousMarketingFee = _marketingFee;    
727 
728     IUniswapV2Router02 public immutable uniswapV2Router;
729     address public immutable uniswapV2Pair;
730     
731     address public burnAddress = 0xc53Ac0167c42DDb1feAF6b3e67a1dE67Bc6D1E9a;
732     address payable private _marketingWallet;
733 
734     bool inSwapAndLiquify;
735     bool public swapAndLiquifyEnabled = true;
736     
737     uint256 public _maxTxAmount = 20000000 * 10**9;
738     uint256 private numTokensSellToAddToLiquidity = 2000000 * 10**9;
739     uint256 private _maxWalletSize = 30000000 * 10**9;
740      
741     event botAddedToBlacklist(address account);
742     event botRemovedFromBlacklist(address account);
743     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
744     event SwapAndLiquifyEnabledUpdated(bool enabled);
745     event SwapAndLiquify(
746         uint256 tokensSwapped,
747         uint256 ethReceived,
748         uint256 tokensIntoLiqudity
749     );
750     
751     modifier lockTheSwap {
752         inSwapAndLiquify = true;
753         _;
754         inSwapAndLiquify = false;
755     }
756     
757     constructor (address marketingWallet) public {
758         _rOwned[_msgSender()] = _rTotal;
759         
760         
761         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
762          // Create a uniswap pair for this new token
763         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
764             .createPair(address(this), _uniswapV2Router.WETH());
765 
766         // set the rest of the contract variables
767         uniswapV2Router = _uniswapV2Router;
768         _marketingWallet = payable(marketingWallet);
769         
770         //exclude owner and this contract from fee
771         _isExcludedFromFee[owner()] = true;
772         _isExcludedFromFee[address(this)] = true;
773         
774         emit Transfer(address(0), _msgSender(), _tTotal);
775     }
776 
777     function name() public view returns (string memory) {
778         return _name;
779     }
780 
781     function symbol() public view returns (string memory) {
782         return _symbol;
783     }
784 
785     function decimals() public view returns (uint8) {
786         return _decimals;
787     }
788 
789     function totalSupply() public view override returns (uint256) {
790         return _tTotal;
791     }
792 
793     function balanceOf(address account) public view override returns (uint256) {
794         if (_isExcluded[account]) return _tOwned[account];
795         return tokenFromReflection(_rOwned[account]);
796     }
797 
798     function transfer(address recipient, uint256 amount) public override returns (bool) {
799         _transfer(_msgSender(), recipient, amount);
800         return true;
801     }
802 
803     function allowance(address owner, address spender) public view override returns (uint256) {
804         return _allowances[owner][spender];
805     }
806 
807     function approve(address spender, uint256 amount) public override returns (bool) {
808         _approve(_msgSender(), spender, amount);
809         return true;
810     }
811 
812     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
813         _transfer(sender, recipient, amount);
814         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
815         return true;
816     }
817 
818     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
819         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
820         return true;
821     }
822 
823     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
824         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
825         return true;
826     }
827 
828     function isExcludedFromReward(address account) public view returns (bool) {
829         return _isExcluded[account];
830     }
831 
832     function totalFees() public view returns (uint256) {
833         return _tFeeTotal;
834     }
835 
836     function deliver(uint256 tAmount) public {
837         address sender = _msgSender();
838         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
839         (uint256 rAmount,,,,,) = _getValues(tAmount);
840         _rOwned[sender] = _rOwned[sender].sub(rAmount);
841         _rTotal = _rTotal.sub(rAmount);
842         _tFeeTotal = _tFeeTotal.add(tAmount);
843     }
844 
845     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
846         require(tAmount <= _tTotal, "Amount must be less than supply");
847         if (!deductTransferFee) {
848             (uint256 rAmount,,,,,) = _getValues(tAmount);
849             return rAmount;
850         } else {
851             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
852             return rTransferAmount;
853         }
854     }
855 
856     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
857         require(rAmount <= _rTotal, "Amount must be less than total reflections");
858         uint256 currentRate =  _getRate();
859         return rAmount.div(currentRate);
860     }
861     
862     function addBotToBlacklist (address account) external onlyOwner() {
863            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
864            require (!_isBlackListedBot[account], 'Account is already blacklisted');
865            _isBlackListedBot[account] = true;
866            _blackListedBots.push(account);
867         }
868 
869         function removeBotFromBlacklist(address account) external onlyOwner() {
870           require (_isBlackListedBot[account], 'Account is not blacklisted');
871           for (uint256 i = 0; i < _blackListedBots.length; i++) {
872                  if (_blackListedBots[i] == account) {
873                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
874                      _isBlackListedBot[account] = false;
875                      _blackListedBots.pop();
876                      break;
877                  }
878            }
879        }
880 
881     function excludeFromReward(address account) public onlyOwner() {
882         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
883         require(!_isExcluded[account], "Account is already excluded");
884         if(_rOwned[account] > 0) {
885             _tOwned[account] = tokenFromReflection(_rOwned[account]);
886         }
887         _isExcluded[account] = true;
888         _excluded.push(account);
889     }
890 
891     function includeInReward(address account) external onlyOwner() {
892         require(_isExcluded[account], "Account is already excluded");
893         for (uint256 i = 0; i < _excluded.length; i++) {
894             if (_excluded[i] == account) {
895                 _excluded[i] = _excluded[_excluded.length - 1];
896                 _tOwned[account] = 0;
897                 _isExcluded[account] = false;
898                 _excluded.pop();
899                 break;
900             }
901         }
902     }
903         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
904         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
905         _tOwned[sender] = _tOwned[sender].sub(tAmount);
906         _rOwned[sender] = _rOwned[sender].sub(rAmount);
907         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
908         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
909         _takeLiquidity(tLiquidity);
910         _reflectFee(rFee, tFee);
911         emit Transfer(sender, recipient, tTransferAmount);
912     }
913     
914         function excludeFromFee(address account) public onlyOwner {
915         _isExcludedFromFee[account] = true;
916     }
917     
918     function includeInFee(address account) public onlyOwner {
919         _isExcludedFromFee[account] = false;
920     }
921     
922     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
923         _taxFee = taxFee;
924     }
925     
926     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
927         _liquidityFee = liquidityFee;
928     }
929 
930     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
931         _marketingFee = marketingFee;
932     }    
933    
934   
935     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
936         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
937             10**2
938         );
939     }
940 
941     function setMarketingWallet(address payable newWallet) external onlyOwner {
942         require(_marketingWallet != newWallet, "Wallet already set!");
943         _marketingWallet = payable(newWallet);
944     } 
945        
946 
947     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
948         swapAndLiquifyEnabled = _enabled;
949         emit SwapAndLiquifyEnabledUpdated(_enabled);
950     }
951     
952      //to recieve ETH from uniswapV2Router when swaping
953     receive() external payable {}
954 
955     function _reflectFee(uint256 rFee, uint256 tFee) private {
956         _rTotal = _rTotal.sub(rFee);
957         _tFeeTotal = _tFeeTotal.add(tFee);
958     }
959 
960     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
961         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
962         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
963         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
964     }
965 
966     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
967         uint256 tFee = calculateTaxFee(tAmount);
968         uint256 tLiquidity = calculateLiquidityFee(tAmount);
969         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
970         return (tTransferAmount, tFee, tLiquidity);
971     }
972 
973     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
974         uint256 rAmount = tAmount.mul(currentRate);
975         uint256 rFee = tFee.mul(currentRate);
976         uint256 rLiquidity = tLiquidity.mul(currentRate);
977         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
978         return (rAmount, rTransferAmount, rFee);
979     }
980 
981     function _getRate() private view returns(uint256) {
982         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
983         return rSupply.div(tSupply);
984     }
985     
986     function _getMaxWalletSize() public view returns(uint256) {
987             return _maxWalletSize;
988     }
989     
990     function _getCurrentSupply() private view returns(uint256, uint256) {
991         uint256 rSupply = _rTotal;
992         uint256 tSupply = _tTotal;      
993         for (uint256 i = 0; i < _excluded.length; i++) {
994             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
995             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
996             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
997         }
998         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
999         return (rSupply, tSupply);
1000     }
1001     
1002     function _takeLiquidity(uint256 tLiquidity) private {
1003         uint256 currentRate =  _getRate();
1004         uint256 rLiquidity = tLiquidity.mul(currentRate);
1005         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1006         if(_isExcluded[address(this)])
1007             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1008     }
1009     
1010     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1011         return _amount.mul(_taxFee).div(
1012             10**2
1013         );
1014     }
1015 
1016     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1017         return _amount.mul(_liquidityFee.add(_marketingFee)).div(
1018             10**2
1019         );
1020     }
1021     
1022     function removeAllFee() private {
1023         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
1024         
1025         _previousTaxFee = _taxFee;
1026         _previousLiquidityFee = _liquidityFee;
1027         _previousMarketingFee = _marketingFee;
1028         
1029         _taxFee = 0;
1030         _liquidityFee = 0;
1031         _marketingFee = 0;
1032         
1033     }
1034     
1035     function restoreAllFee() private {
1036         _taxFee = _previousTaxFee;
1037         _liquidityFee = _previousLiquidityFee;
1038         _marketingFee = _previousMarketingFee;
1039     }
1040     
1041     function isExcludedFromFee(address account) public view returns(bool) {
1042         return _isExcludedFromFee[account];
1043     }
1044 
1045     function _approve(address owner, address spender, uint256 amount) private {
1046         require(owner != address(0), "ERC20: approve from the zero address");
1047         require(spender != address(0), "ERC20: approve to the zero address");
1048 
1049         _allowances[owner][spender] = amount;
1050         emit Approval(owner, spender, amount);
1051     }
1052 
1053     function _transfer(
1054         address from,
1055         address to,
1056         uint256 amount
1057     ) private {
1058         require(from != address(0), "ERC20: transfer from the zero address");
1059         require(to != address(0), "ERC20: transfer to the zero address");
1060         require(amount > 0, "Transfer amount must be greater than zero");
1061         require(!_isBlackListedBot[from], "You are blacklisted");
1062         require(!_isBlackListedBot[msg.sender], "You are blacklisted");
1063         require(!_isBlackListedBot[tx.origin], "You are blacklisted");
1064         if(from != owner() && to != owner())
1065             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1066         
1067         
1068         if(from != owner() && to != owner() && to != uniswapV2Pair && to != address(0xdead)) {
1069             uint256 tokenBalanceRecipient = balanceOf(to);
1070             require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
1071         }
1072         // is the token balance of this contract address over the min number of
1073         // tokens that we need to initiate a swap + liquidity lock?
1074         // also, don't get caught in a circular liquidity event.
1075         // also, don't swap & liquify if sender is uniswap pair.
1076         uint256 contractTokenBalance = balanceOf(address(this));
1077         
1078         if(contractTokenBalance >= _maxTxAmount)
1079         {
1080             contractTokenBalance = _maxTxAmount;
1081         }
1082         
1083         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1084         if (
1085             overMinTokenBalance &&
1086             !inSwapAndLiquify &&
1087             from != uniswapV2Pair &&
1088             swapAndLiquifyEnabled
1089         ) {
1090             contractTokenBalance = numTokensSellToAddToLiquidity;
1091             //add liquidity
1092             swapAndLiquify(contractTokenBalance);
1093         }
1094         
1095         //indicates if fee should be deducted from transfer
1096         bool takeFee = true;
1097         
1098         //if any account belongs to _isExcludedFromFee account then remove the fee
1099         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1100             takeFee = false;
1101         }
1102         
1103         //transfer amount, it will take tax, burn, liquidity fee
1104         _tokenTransfer(from,to,amount,takeFee);
1105     }
1106 
1107     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1108         if (_marketingFee + _liquidityFee == 0)
1109             return;
1110         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
1111         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
1112 
1113         // split the contract balance into halves
1114         uint256 half = toLiquify.div(2);
1115         uint256 otherHalf = toLiquify.sub(half);
1116 
1117         // capture the contract's current ETH balance.
1118         // this is so that we can capture exactly the amount of ETH that the
1119         // swap creates, and not make the liquidity event include any ETH that
1120         // has been manually sent to the contract
1121         uint256 initialBalance = address(this).balance;
1122 
1123         // swap tokens for ETH
1124         uint256 toSwapForEth = half.add(toMarketing);
1125         swapTokensForEth(toSwapForEth);
1126 
1127         // how much ETH did we just swap into?
1128         uint256 fromSwap = address(this).balance.sub(initialBalance);
1129         uint256 liquidityBalance = fromSwap.mul(half).div(toSwapForEth);
1130 
1131         addLiquidity(otherHalf, liquidityBalance);
1132 
1133         emit SwapAndLiquify(half, liquidityBalance, otherHalf);
1134 
1135         _marketingWallet.transfer(fromSwap.sub(liquidityBalance));
1136     }
1137 
1138     function swapTokensForEth(uint256 tokenAmount) private {
1139         // generate the uniswap pair path of token -> weth
1140         address[] memory path = new address[](2);
1141         path[0] = address(this);
1142         path[1] = uniswapV2Router.WETH();
1143 
1144         _approve(address(this), address(uniswapV2Router), tokenAmount);
1145 
1146         // make the swap
1147         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1148             tokenAmount,
1149             0, // accept any amount of ETH
1150             path,
1151             address(this),
1152             block.timestamp
1153         );
1154     }
1155 
1156     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1157         // approve token transfer to cover all possible scenarios
1158         _approve(address(this), address(uniswapV2Router), tokenAmount);
1159 
1160         // add the liquidity
1161         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1162             address(this),
1163             tokenAmount,
1164             0, // slippage is unavoidable
1165             0, // slippage is unavoidable
1166             burnAddress,
1167             block.timestamp
1168         );
1169     }
1170 
1171     //this method is responsible for taking all fee, if takeFee is true
1172     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1173         if(!takeFee)
1174             removeAllFee();
1175         
1176         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1177             _transferFromExcluded(sender, recipient, amount);
1178         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1179             _transferToExcluded(sender, recipient, amount);
1180         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1181             _transferStandard(sender, recipient, amount);
1182         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1183             _transferBothExcluded(sender, recipient, amount);
1184         } else {
1185             _transferStandard(sender, recipient, amount);
1186         }
1187         
1188         if(!takeFee)
1189             restoreAllFee();
1190     }
1191 
1192     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1193         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1194         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1195         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1196         _takeLiquidity(tLiquidity);
1197         _reflectFee(rFee, tFee);
1198         emit Transfer(sender, recipient, tTransferAmount);
1199     }
1200 
1201     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1202         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1203         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1204         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1205         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1206         _takeLiquidity(tLiquidity);
1207         _reflectFee(rFee, tFee);
1208         emit Transfer(sender, recipient, tTransferAmount);
1209     }
1210 
1211     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1212         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1213         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1214         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1215         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1216         _takeLiquidity(tLiquidity);
1217         _reflectFee(rFee, tFee);
1218         emit Transfer(sender, recipient, tTransferAmount);
1219     }
1220 
1221     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
1222         require(SwapThresholdAmount > 2000000 , "Swap Threshold Amount cannot be less than 2000000 tokens");
1223         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
1224     }
1225     
1226     function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1227           _maxWalletSize = maxWalletSize;
1228         }
1229 
1230     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
1231         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
1232     }
1233     
1234     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
1235         walletaddress.transfer(address(this).balance);
1236     }
1237     
1238     function setburnAddress(address walletAddress) public onlyOwner {
1239         burnAddress = walletAddress;
1240     }
1241 
1242 }