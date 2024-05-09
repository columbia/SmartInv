1 /**
2 
3 RETURN TO SPACE 
4 
5 SPACE 
6 
7 https://t.me/return_to_space_ETH
8 
9 THE NEW NETLFIX DOCUMETARY 
10 
11 Return to Space is an upcoming American documentary film made for Netflix. 
12 Its story follows Elon Musk's and SpaceX engineers' two-decade mission to send NASA astronauts back to the International Space Station and revolutionize space travel. 
13 The film is set to be released on April 7, 2022
14 
15 #ReturnToSpace 
16 #SPACE 
17 
18 */
19 
20 // SPDX-License-Identifier: Unlicensed
21 
22 pragma solidity ^0.8.0;
23 
24 interface IERC20 {
25 
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108  
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, "SafeMath: subtraction overflow");
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the multiplication of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `*` operator.
163      *
164      * Requirements:
165      *
166      * - Multiplication cannot overflow.
167      */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         return div(a, b, "SafeMath: division by zero");
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         uint256 c = a / b;
213         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return mod(a, b, "SafeMath: modulo by zero");
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts with custom message when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b != 0, errorMessage);
248         return a % b;
249     }
250 }
251 
252 abstract contract Context {
253     function _msgSender() internal view virtual returns (address payable) {
254         return payable(msg.sender);
255     }
256 
257     function _msgData() internal view virtual returns (bytes memory) {
258         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
259         return msg.data;
260     }
261 }
262 
263 
264 abstract contract Pausable is Context {
265     /**
266      * @dev Emitted when the pause is triggered by `account`.
267      */
268     event Paused(address account);
269 
270     /**
271      * @dev Emitted when the pause is lifted by `account`.
272      */
273     event Unpaused(address account);
274 
275     bool private _paused;
276 
277     /**
278      * @dev Initializes the contract in unpaused state.
279      */
280     constructor() {
281         _paused = false;
282     }
283 
284     /**
285      * @dev Returns true if the contract is paused, and false otherwise.
286      */
287     function paused() public view virtual returns (bool) {
288         return _paused;
289     }
290 
291     /**
292      * @dev Modifier to make a function callable only when the contract is not paused.
293      *
294      * Requirements:
295      *
296      * - The contract must not be paused.
297      */
298     modifier whenNotPaused() {
299         require(!paused(), "Pausable: paused");
300         _;
301     }
302 
303     /**
304      * @dev Modifier to make a function callable only when the contract is paused.
305      *
306      * Requirements:
307      *
308      * - The contract must be paused.
309      */
310     modifier whenPaused() {
311         require(paused(), "Pausable: not paused");
312         _;
313     }
314 
315     /**
316      * @dev Triggers stopped state.
317      *
318      * Requirements:
319      *
320      * - The contract must not be paused.
321      */
322     function _activate() external virtual whenNotPaused {
323         _paused = true;
324         emit Paused(_msgSender());
325     }
326 
327     /**
328      * @dev Returns to normal state.
329      *
330      * Requirements:
331      *
332      * - The contract must be paused.
333      */
334     function startTrading() external virtual whenPaused {
335         _paused = false;
336         emit Unpaused(_msgSender());
337     }
338 }
339 
340 
341 /**
342  * @dev Collection of functions related to the address type
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * [IMPORTANT]
349      * ====
350      * It is unsafe to assume that an address for which this function returns
351      * false is an externally-owned account (EOA) and not a contract.
352      *
353      * Among others, `isContract` will return false for the following
354      * types of addresses:
355      *
356      *  - an externally-owned account
357      *  - a contract in construction
358      *  - an address where a contract will be created
359      *  - an address where a contract lived, but was destroyed
360      * ====
361      */
362     function isContract(address account) internal view returns (bool) {
363         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
364         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
365         // for accounts without code, i.e. `keccak256('')`
366         bytes32 codehash;
367         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
368         // solhint-disable-next-line no-inline-assembly
369         assembly { codehash := extcodehash(account) }
370         return (codehash != accountHash && codehash != 0x0);
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      */
389     function sendValue(address payable recipient, uint256 amount) internal {
390         require(address(this).balance >= amount, "Address: insufficient balance");
391 
392         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
393         (bool success, ) = recipient.call{ value: amount }("");
394         require(success, "Address: unable to send value, recipient may have reverted");
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain`call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416       return functionCall(target, data, "Address: low-level call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421      * `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
426         return _functionCallWithValue(target, data, 0, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but also transferring `value` wei to `target`.
432      *
433      * Requirements:
434      *
435      * - the calling contract must have an ETH balance of at least `value`.
436      * - the called Solidity function must be `payable`.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446      * with `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
451         require(address(this).balance >= value, "Address: insufficient balance for call");
452         return _functionCallWithValue(target, data, value, errorMessage);
453     }
454 
455     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
456         require(isContract(target), "Address: call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
460         if (success) {
461             return returndata;
462         } else {
463             // Look for revert reason and bubble it up if present
464             if (returndata.length > 0) {
465                 // The easiest way to bubble the revert reason is using memory via assembly
466 
467                 // solhint-disable-next-line no-inline-assembly
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 /**
480  * @dev Contract module which provides a basic access control mechanism, where
481  * there is an account (an owner) that can be granted exclusive access to
482  * specific functions.
483  *
484  * By default, the owner account will be the one that deploys the contract. This
485  * can later be changed with {transferOwnership}.
486  *
487  * This module is used through inheritance. It will make available the modifier
488  * `onlyOwner`, which can be applied to your functions to restrict their use to
489  * the owner.
490  */
491 contract Ownable is Context {
492     address private _owner;
493     address private _previousOwner;
494     uint256 private _lockTime;
495 
496     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
497 
498     /**
499      * @dev Initializes the contract setting the deployer as the initial owner.
500      */
501     constructor() {
502         address msgSender = _msgSender();
503         _owner = msgSender;
504         emit OwnershipTransferred(address(0), msgSender);
505     }
506 
507     /**
508      * @dev Returns the address of the current owner.
509      */
510     function owner() public view returns (address) {
511         return _owner;
512     }
513 
514     /**
515      * @dev Throws if called by any account other than the owner.
516      */
517     modifier onlyOwner() {
518         require(_owner == _msgSender(), "Ownable: caller is not the owner");
519         _;
520     }
521 
522      /**
523      * @dev Leaves the contract without owner. It will not be possible to call
524      * `onlyOwner` functions anymore. Can only be called by the current owner.
525      *
526      * NOTE: Renouncing ownership will leave the contract without an owner,
527      * thereby removing any functionality that is only available to the owner.
528      */
529     function renounceOwnership() public virtual onlyOwner {
530         emit OwnershipTransferred(_owner, address(0));
531         _owner = address(0);
532     }
533 
534     /**
535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
536      * Can only be called by the current owner.
537      */
538     function transferOwnership(address newOwner) public virtual onlyOwner {
539         require(newOwner != address(0), "Ownable: new owner is the zero address");
540         emit OwnershipTransferred(_owner, newOwner);
541         _owner = newOwner;
542     }
543 
544     function geUnlockTime() public view returns (uint256) {
545         return _lockTime;
546     }
547 
548     //Locks the contract for owner for the amount of time provided
549     function lock(uint256 time) public virtual onlyOwner {
550         _previousOwner = _owner;
551         _owner = address(0);
552         _lockTime = block.timestamp + time;
553         emit OwnershipTransferred(_owner, address(0));
554     }
555     
556     //Unlocks the contract for owner when _lockTime is exceeds
557     function unlock() public virtual {
558         require(_previousOwner == msg.sender, "You don't have permission to unlock");
559         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
560         emit OwnershipTransferred(_owner, _previousOwner);
561         _owner = _previousOwner;
562     }
563 }
564 
565 // pragma solidity >=0.5.0;
566 
567 interface IUniswapV2Factory {
568     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
569 
570     function feeTo() external view returns (address);
571     function feeToSetter() external view returns (address);
572 
573     function getPair(address tokenA, address tokenB) external view returns (address pair);
574     function allPairs(uint) external view returns (address pair);
575     function allPairsLength() external view returns (uint);
576 
577     function createPair(address tokenA, address tokenB) external returns (address pair);
578 
579     function setFeeTo(address) external;
580     function setFeeToSetter(address) external;
581 }
582 
583 
584 // pragma solidity >=0.5.0;
585 
586 interface IUniswapV2Pair {
587     event Approval(address indexed owner, address indexed spender, uint value);
588     event Transfer(address indexed from, address indexed to, uint value);
589 
590     function name() external pure returns (string memory);
591     function symbol() external pure returns (string memory);
592     function decimals() external pure returns (uint8);
593     function totalSupply() external view returns (uint);
594     function balanceOf(address owner) external view returns (uint);
595     function allowance(address owner, address spender) external view returns (uint);
596 
597     function approve(address spender, uint value) external returns (bool);
598     function transfer(address to, uint value) external returns (bool);
599     function transferFrom(address from, address to, uint value) external returns (bool);
600 
601     function DOMAIN_SEPARATOR() external view returns (bytes32);
602     function PERMIT_TYPEHASH() external pure returns (bytes32);
603     function nonces(address owner) external view returns (uint);
604 
605     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
606 
607     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
608     event Swap(
609         address indexed sender,
610         uint amount0In,
611         uint amount1In,
612         uint amount0Out,
613         uint amount1Out,
614         address indexed to
615     );
616     event Sync(uint112 reserve0, uint112 reserve1);
617 
618     function MINIMUM_LIQUIDITY() external pure returns (uint);
619     function factory() external view returns (address);
620     function token0() external view returns (address);
621     function token1() external view returns (address);
622     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
623     function price0CumulativeLast() external view returns (uint);
624     function price1CumulativeLast() external view returns (uint);
625     function kLast() external view returns (uint);
626 
627     function burn(address to) external returns (uint amount0, uint amount1);
628     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
629     function skim(address to) external;
630     function sync() external;
631 
632     function initialize(address, address) external;
633 }
634 
635 // pragma solidity >=0.6.2;
636 
637 interface IUniswapV2Router01 {
638     function factory() external pure returns (address);
639     function WETH() external pure returns (address);
640 
641     function addLiquidity(
642         address tokenA,
643         address tokenB,
644         uint amountADesired,
645         uint amountBDesired,
646         uint amountAMin,
647         uint amountBMin,
648         address to,
649         uint deadline
650     ) external returns (uint amountA, uint amountB, uint liquidity);
651     function addLiquidityETH(
652         address token,
653         uint amountTokenDesired,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline
658     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
659     function removeLiquidity(
660         address tokenA,
661         address tokenB,
662         uint liquidity,
663         uint amountAMin,
664         uint amountBMin,
665         address to,
666         uint deadline
667     ) external returns (uint amountA, uint amountB);
668     function removeLiquidityETH(
669         address token,
670         uint liquidity,
671         uint amountTokenMin,
672         uint amountETHMin,
673         address to,
674         uint deadline
675     ) external returns (uint amountToken, uint amountETH);
676     function removeLiquidityWithPermit(
677         address tokenA,
678         address tokenB,
679         uint liquidity,
680         uint amountAMin,
681         uint amountBMin,
682         address to,
683         uint deadline,
684         bool approveMax, uint8 v, bytes32 r, bytes32 s
685     ) external returns (uint amountA, uint amountB);
686     function removeLiquidityETHWithPermit(
687         address token,
688         uint liquidity,
689         uint amountTokenMin,
690         uint amountETHMin,
691         address to,
692         uint deadline,
693         bool approveMax, uint8 v, bytes32 r, bytes32 s
694     ) external returns (uint amountToken, uint amountETH);
695     function swapExactTokensForTokens(
696         uint amountIn,
697         uint amountOutMin,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external returns (uint[] memory amounts);
702     function swapTokensForExactTokens(
703         uint amountOut,
704         uint amountInMax,
705         address[] calldata path,
706         address to,
707         uint deadline
708     ) external returns (uint[] memory amounts);
709     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
710         external
711         payable
712         returns (uint[] memory amounts);
713     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
714         external
715         returns (uint[] memory amounts);
716     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
717         external
718         returns (uint[] memory amounts);
719     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
720         external
721         payable
722         returns (uint[] memory amounts);
723 
724     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
725     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
726     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
727     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
728     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
729 }
730 
731 
732 
733 // pragma solidity >=0.6.2;
734 
735 interface IUniswapV2Router02 is IUniswapV2Router01 {
736     function removeLiquidityETHSupportingFeeOnTransferTokens(
737         address token,
738         uint liquidity,
739         uint amountTokenMin,
740         uint amountETHMin,
741         address to,
742         uint deadline
743     ) external returns (uint amountETH);
744     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
745         address token,
746         uint liquidity,
747         uint amountTokenMin,
748         uint amountETHMin,
749         address to,
750         uint deadline,
751         bool approveMax, uint8 v, bytes32 r, bytes32 s
752     ) external returns (uint amountETH);
753 
754     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
755         uint amountIn,
756         uint amountOutMin,
757         address[] calldata path,
758         address to,
759         uint deadline
760     ) external;
761     function swapExactETHForTokensSupportingFeeOnTransferTokens(
762         uint amountOutMin,
763         address[] calldata path,
764         address to,
765         uint deadline
766     ) external payable;
767     function swapExactTokensForETHSupportingFeeOnTransferTokens(
768         uint amountIn,
769         uint amountOutMin,
770         address[] calldata path,
771         address to,
772         uint deadline
773     ) external;
774 }
775 
776 
777 contract RETURNTOSPACE is Context, IERC20, Ownable, Pausable {
778     using SafeMath for uint256;
779     using Address for address;
780 
781     mapping (address => uint256) private _rOwned;
782     mapping (address => uint256) private _tOwned;
783     mapping (address => mapping (address => uint256)) private _allowances;
784 
785     mapping (address => bool) private _whiteList;
786 
787     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
788 
789     mapping (address => bool) private _isExcluded;
790     address[] private _excluded;
791    
792     uint256 private constant MAX = ~uint256(0);
793     uint256 private _tTotal = 1261154896 * 10**9;
794     uint256 private _rTotal = (MAX - (MAX % _tTotal));
795     uint256 private _tFeeTotal;
796 
797     string private _name = "RETURN TO SPACE";
798     string private _symbol = "SPACE";
799     uint8 private _decimals = 9;
800     
801      //Buy Fees
802     uint256 public _buyTaxFee = 0;
803     uint256 public _buyLiquidityFee = 0;
804     uint256 public _buyMarketingFee = 8;
805     uint256 public _buyBurnFee = 0;
806 
807     //Sell Fees
808     uint256 public _sellTaxFee = 0;
809     uint256 public _sellMarketingFee = 8;
810     uint256 public _sellLiquidityFee = 0;
811     uint256 public _sellBurnFee = 0;
812 
813     // Fees (Current)
814     uint256 private _taxFee;
815     uint256 private _marketingFee;
816     uint256 private _liquidityFee;
817     uint256 private _burnFee;
818     address payable public marketingWallet = payable(0x3856f0bd06a5F4760B5014524039D97e63567ed0);
819 
820     mapping(address => bool) public _isBlacklisted;
821 
822     IUniswapV2Router02 public  uniswapV2Router;
823     address public  uniswapV2Pair;
824     
825     bool inSwapAndLiquify;
826     bool public swapAndLiquifyEnabled = true;
827 
828     uint256 public numTokensSellToAddToLiquidity = 1261154 * 10**9; //0.1%
829     uint256 public _maxTxAmount = 3152887 * 10**9;
830     uint256 public maxBuyTransactionAmount = 3152887 * 10**9;  //0.25%
831     uint256 public maxWalletToken = 12611548 * 10**9; //1%
832     
833     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
834     event SwapAndLiquifyEnabledUpdated(bool enabled);
835     event SwapAndLiquify(
836         uint256 tokensSwapped,
837         uint256 ethReceived,
838         uint256 tokensIntoLiqudity
839     );
840     
841     modifier lockTheSwap {
842         inSwapAndLiquify = true;
843         _;
844         inSwapAndLiquify = false;
845     }
846     
847     constructor() {
848         _rOwned[_msgSender()] = _rTotal;
849         
850         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
851          // Create a uniswap pair for this new token
852         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
853             .createPair(address(this), _uniswapV2Router.WETH());
854 
855         // set the rest of the contract variables
856         uniswapV2Router = _uniswapV2Router;
857         
858         //exclude owner and this contract from fee
859         _whiteList[owner()] = true;
860         _whiteList[address(this)] = true;
861         
862         emit Transfer(address(0), _msgSender(), _tTotal);
863     }
864     function blacklistAddress(address account, bool value) external onlyOwner{
865         _isBlacklisted[account] = value;
866     }
867 
868     function name() public view returns (string memory) {
869         return _name;
870     }
871 
872     function symbol() public view returns (string memory) {
873         return _symbol;
874     }
875 
876     function decimals() public view returns (uint8) {
877         return _decimals;
878     }
879 
880     function totalSupply() public view override returns (uint256) {
881         return _tTotal;
882     }
883 
884     function balanceOf(address account) public view override returns (uint256) {
885         if (_isExcluded[account]) return _tOwned[account];
886         return tokenFromReflection(_rOwned[account]);
887     }
888 
889     function transfer(address recipient, uint256 amount) public override returns (bool) {
890         _transfer(_msgSender(), recipient, amount);
891         return true;
892     }
893 
894     function allowance(address owner, address spender) public view override returns (uint256) {
895         return _allowances[owner][spender];
896     }
897 
898     function approve(address spender, uint256 amount) public override returns (bool) {
899         _approve(_msgSender(), spender, amount);
900         return true;
901     }
902 
903     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
904         _transfer(sender, recipient, amount);
905         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
906         return true;
907     }
908 
909     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
910         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
911         return true;
912     }
913 
914     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
915         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
916         return true;
917     }
918 
919     function isExcludedFromReward(address account) public view returns (bool) {
920         return _isExcluded[account];
921     }
922 
923     function totalFees() public view returns (uint256) {
924         return _tFeeTotal;
925     }
926 
927     function deliver(uint256 tAmount) public {
928         address sender = _msgSender();
929         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
930         (uint256 rAmount,,,,,) = _getValues(tAmount);
931         _rOwned[sender] = _rOwned[sender].sub(rAmount);
932         _rTotal = _rTotal.sub(rAmount);
933         _tFeeTotal = _tFeeTotal.add(tAmount);
934     }
935 
936     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
937         require(tAmount <= _tTotal, "Amount must be less than supply");
938         if (!deductTransferFee) {
939             (uint256 rAmount,,,,,) = _getValues(tAmount);
940             return rAmount;
941         } else {
942             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
943             return rTransferAmount;
944         }
945     }
946 
947     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
948         require(rAmount <= _rTotal, "Amount must be less than total reflections");
949         uint256 currentRate =  _getRate();
950         return rAmount.div(currentRate);
951     }
952 
953     function excludeFromReward(address account) public onlyOwner() {
954         require(!_isExcluded[account], "Account is already excluded");
955         if(_rOwned[account] > 0) {
956             _tOwned[account] = tokenFromReflection(_rOwned[account]);
957         }
958         _isExcluded[account] = true;
959         _excluded.push(account);
960     }
961 
962     function includeInReward(address account) external onlyOwner() {
963         require(_isExcluded[account], "Account is already excluded");
964         for (uint256 i = 0; i < _excluded.length; i++) {
965             if (_excluded[i] == account) {
966                 _excluded[i] = _excluded[_excluded.length - 1];
967                 _tOwned[account] = 0;
968                 _isExcluded[account] = false;
969                 _excluded.pop();
970                 break;
971             }
972         }
973     }
974 
975     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
976         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
977         _tOwned[sender] = _tOwned[sender].sub(tAmount);
978         _rOwned[sender] = _rOwned[sender].sub(rAmount);
979         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
980         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
981         _takeLiquidity(tLiquidity);
982         _reflectFee(rFee, tFee);
983         emit Transfer(sender, recipient, tTransferAmount);
984     }
985     
986 
987     
988      //to recieve ETH from uniswapV2Router when swaping
989     receive() external payable {}
990 
991     function _reflectFee(uint256 rFee, uint256 tFee) private {
992         _rTotal = _rTotal.sub(rFee);
993         _tFeeTotal = _tFeeTotal.add(tFee);
994     }
995 
996     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
997         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
998         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
999         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1000     }
1001 
1002     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1003         uint256 tFee = calculateTaxFee(tAmount);
1004         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1005         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1006         return (tTransferAmount, tFee, tLiquidity);
1007     }
1008 
1009     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1010         uint256 rAmount = tAmount.mul(currentRate);
1011         uint256 rFee = tFee.mul(currentRate);
1012         uint256 rLiquidity = tLiquidity.mul(currentRate);
1013         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1014         return (rAmount, rTransferAmount, rFee);
1015     }
1016 
1017     function _getRate() private view returns(uint256) {
1018         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1019         return rSupply.div(tSupply);
1020     }
1021 
1022     function _getCurrentSupply() private view returns(uint256, uint256) {
1023         uint256 rSupply = _rTotal;
1024         uint256 tSupply = _tTotal;      
1025         for (uint256 i = 0; i < _excluded.length; i++) {
1026             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1027             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1028             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1029         }
1030         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1031         return (rSupply, tSupply);
1032     }
1033     
1034     function _takeLiquidity(uint256 tLiquidity) private {
1035         uint256 currentRate =  _getRate();
1036         uint256 rLiquidity = tLiquidity.mul(currentRate);
1037         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1038         if(_isExcluded[address(this)])
1039             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1040     }
1041     
1042     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1043         return _amount.mul(_taxFee).div(
1044             10**2
1045         );
1046     }
1047 
1048     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1049         return _amount.mul(_liquidityFee).div(
1050             10**2
1051         );
1052     }
1053     
1054     function removeAllFee() private {
1055         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee==0 && _burnFee==0) return;
1056 
1057         
1058         _taxFee = 0;
1059         _liquidityFee = 0;
1060         _marketingFee = 0;
1061         _burnFee = 0;
1062     }
1063     
1064 
1065     
1066     function isWhiteListed(address account) public view returns(bool) {
1067         return _whiteList[account];
1068     }
1069 
1070     function _approve(address owner, address spender, uint256 amount) private {
1071         require(owner != address(0), "ERC20: approve from the zero address");
1072         require(spender != address(0), "ERC20: approve to the zero address");
1073 
1074         _allowances[owner][spender] = amount;
1075         emit Approval(owner, spender, amount);
1076     }
1077 
1078     function _transfer(
1079         address from,
1080         address to,
1081         uint256 amount
1082     ) whenNotPaused() private {
1083         require(from != address(0), "ERC20: transfer from the zero address");
1084         require(amount > 0, "Transfer amount must be greater than zero");
1085         require(!_isBlacklisted[from] && !_isBlacklisted[to], 'Blacklisted address');
1086         
1087         if (
1088             from != owner() &&
1089             to != owner() &&
1090             to != address(0) &&
1091             to != address(0xdead) &&
1092             to != uniswapV2Pair
1093         ) {
1094 
1095             uint256 contractBalanceRecepient = balanceOf(to);
1096             require(
1097                 contractBalanceRecepient + amount <= maxWalletToken,
1098                 "Exceeds maximum wallet token amount."
1099             );
1100             
1101         }
1102         
1103         
1104         if(from == uniswapV2Pair &&  !isWhiteListed(to)){
1105             require(amount <= maxBuyTransactionAmount, "Buy transfer amount exceeds the maxBuyTransactionAmount.");
1106         }
1107 
1108         // is the token balance of this contract address over the min number of
1109         // tokens that we need to initiate a swap + liquidity lock?
1110         // also, don't get caught in a circular liquidity event.
1111         // also, don't swap & liquify if sender is uniswap pair.
1112         uint256 contractTokenBalance = balanceOf(address(this));        
1113         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1114         if (
1115             overMinTokenBalance &&
1116             !inSwapAndLiquify &&
1117             from != uniswapV2Pair &&
1118             swapAndLiquifyEnabled
1119         ) {
1120             contractTokenBalance = numTokensSellToAddToLiquidity;
1121             //add liquidity
1122             swapAndLiquify(contractTokenBalance);
1123         }
1124 
1125          // Indicates if fee should be deducted from transfer
1126         bool takeFee = true;
1127 
1128 
1129         // If any account belongs to _isExcludedFromFee account then remove the fee
1130         if(isWhiteListed(from) || isWhiteListed(to)){
1131             takeFee = false;
1132         }
1133 
1134         // Set buy fees
1135         if(from == uniswapV2Pair || from.isContract()) {
1136             _taxFee = _buyTaxFee;
1137             _marketingFee = _buyMarketingFee;
1138             _liquidityFee = _buyLiquidityFee;
1139             _burnFee = _buyBurnFee;
1140         }
1141         
1142         // Set sell fees
1143         if(to == uniswapV2Pair || to.isContract()) {
1144             _taxFee = _sellTaxFee;
1145             _marketingFee = _sellMarketingFee;
1146             _liquidityFee = _sellLiquidityFee; 
1147             _burnFee = _sellBurnFee;           
1148         }
1149         
1150         //transfer amount, it will take tax, burn, liquidity fee
1151         _tokenTransfer(from,to,amount);
1152     }
1153 
1154     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1155         uint256 combineFees = _liquidityFee.add(_marketingFee); // marketing + liquidity fees
1156         uint256 tokensForLiquidity = contractTokenBalance.mul(_liquidityFee).div(combineFees); 
1157         
1158         uint256 tokensForMarketing = contractTokenBalance.sub(tokensForLiquidity);
1159         
1160         // split the Liquidity tokens balance into halves
1161         uint256 half = tokensForLiquidity.div(2);
1162         uint256 otherHalf = tokensForLiquidity.sub(half);
1163 
1164         // capture the contract's current ETH balance.
1165         // this is so that we can capture exactly the amount of ETH that the
1166         // swap creates, and not make the liquidity event include any ETH that
1167         // has been manually sent to the contract
1168         uint256 initialBalance = address(this).balance;
1169 
1170         // swap tokens for ETH
1171         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1172 
1173         // how much ETH did we just swap into?
1174         uint256 newBalance = address(this).balance.sub(initialBalance);
1175 
1176         // add liquidity to uniswap
1177         addLiquidity(otherHalf, newBalance);
1178         
1179         emit SwapAndLiquify(half, newBalance, otherHalf);
1180         
1181         uint256 contractBalance = address(this).balance;
1182         swapTokensForEth(tokensForMarketing);
1183         uint256 transferredBalance = address(this).balance.sub(contractBalance);
1184         
1185         //Send to Marketing address
1186         transferToAddressETH(marketingWallet, transferredBalance);
1187     }
1188 
1189     function swapTokensForEth(uint256 tokenAmount) private {
1190         // generate the uniswap pair path of token -> weth
1191         address[] memory path = new address[](2);
1192         path[0] = address(this);
1193         path[1] = uniswapV2Router.WETH();
1194 
1195         _approve(address(this), address(uniswapV2Router), tokenAmount);
1196 
1197         // make the swap
1198         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1199             tokenAmount,
1200             0, // accept any amount of ETH
1201             path,
1202             address(this),
1203             block.timestamp
1204         );
1205     }
1206 
1207     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1208         // approve token transfer to cover all possible scenarios
1209         _approve(address(this), address(uniswapV2Router), tokenAmount);
1210 
1211         // add the liquidity
1212         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1213             address(this),
1214             tokenAmount,
1215             0, // slippage is unavoidable
1216             0, // slippage is unavoidable
1217             owner(),
1218             block.timestamp
1219         );
1220     }
1221 
1222     //this method is responsible for taking all fee, if takeFee is true
1223     function _tokenTransfer(address sender, address recipient, uint256 amount) private 
1224     {
1225         if(_whiteList[sender] || _whiteList[recipient])
1226         {   
1227            removeAllFee(); 
1228         }
1229         else  
1230         {
1231             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1232         }
1233 
1234         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1235             _transferFromExcluded(sender, recipient, amount);
1236         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1237             _transferToExcluded(sender, recipient, amount);
1238         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1239             _transferStandard(sender, recipient, amount);
1240         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1241             _transferBothExcluded(sender, recipient, amount);
1242         } else {
1243             _transferStandard(sender, recipient, amount);
1244         }
1245     }
1246 
1247 
1248 
1249     function _transferStandard(address sender, address recipient, uint256 tAmount) private 
1250     {
1251         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1252         (tTransferAmount, rTransferAmount) = takeBurn(sender, tTransferAmount, rTransferAmount, tAmount);
1253         (tTransferAmount, rTransferAmount) = takeMarketing(sender, tTransferAmount, rTransferAmount, tAmount);
1254         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1255         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1256         _takeLiquidity(tLiquidity);
1257         _reflectFee(rFee, tFee);
1258         emit Transfer(sender, recipient, tTransferAmount);
1259     }
1260 
1261 
1262     function takeBurn(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
1263     returns (uint256, uint256)
1264     {
1265         if(_burnFee==0) {  return(tTransferAmount, rTransferAmount); }
1266         uint256 tBurn = tAmount.div(100).mul(_burnFee);
1267         uint256 rBurn = tBurn.mul(_getRate());
1268         rTransferAmount = rTransferAmount.sub(rBurn);
1269         tTransferAmount = tTransferAmount.sub(tBurn);
1270         _rOwned[deadAddress] = _rOwned[deadAddress].add(rBurn);
1271         emit Transfer(sender, deadAddress, tBurn);
1272         return(tTransferAmount, rTransferAmount);
1273     }
1274 
1275 
1276     function takeMarketing(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
1277     returns (uint256, uint256)
1278     {
1279         if(_marketingFee==0) {  return(tTransferAmount, rTransferAmount); }
1280         uint256 tMarketing = tAmount.div(100).mul(_marketingFee);
1281         uint256 rMarketing = tMarketing.mul(_getRate());
1282         rTransferAmount = rTransferAmount.sub(rMarketing);
1283         tTransferAmount = tTransferAmount.sub(tMarketing);
1284         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1285         emit Transfer(sender, address(this), tMarketing);
1286         return(tTransferAmount, rTransferAmount); 
1287     }
1288 
1289 
1290     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1291         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1292         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1293         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1294         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1295         _takeLiquidity(tLiquidity);
1296         _reflectFee(rFee, tFee);
1297         emit Transfer(sender, recipient, tTransferAmount);
1298     }
1299 
1300     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1301         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1302         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1303         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1304         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1305         _takeLiquidity(tLiquidity);
1306         _reflectFee(rFee, tFee);
1307         emit Transfer(sender, recipient, tTransferAmount);
1308     }
1309 
1310     function excludeFromFee(address account) public onlyOwner {
1311         _whiteList[account] = true;
1312     }
1313     
1314     function includeInFee(address account) public onlyOwner {
1315         _whiteList[account] = false;
1316     }
1317     
1318     function setMarketingWallet(address payable newWallet) external onlyOwner() {
1319         marketingWallet = newWallet;
1320     }
1321     
1322    
1323     function setBuyFeePercent(uint256 taxFee, uint256 MarketingFee, uint256 liquidityFee, uint256 burnFee) external onlyOwner() {
1324         _buyTaxFee = taxFee;
1325         _buyMarketingFee = MarketingFee;
1326         _buyLiquidityFee = liquidityFee;
1327         _buyBurnFee = burnFee;
1328     }
1329 
1330     function setSellFeePercent(uint256 taxFee, uint256 MarketingFee, uint256 liquidityFee, uint256 burnFee) external onlyOwner() {
1331         _sellTaxFee = taxFee;
1332         _sellMarketingFee = MarketingFee;
1333         _sellLiquidityFee = liquidityFee;
1334         _sellBurnFee = burnFee;
1335     }
1336     
1337     function setNumTokensSellToAddToLiquidity(uint256 newAmt) external onlyOwner() {
1338         numTokensSellToAddToLiquidity = newAmt*10**_decimals;
1339     }
1340     
1341     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1342         require(maxTxAmount > 0, "Cannot set transaction amount as zero");
1343         _maxTxAmount = maxTxAmount * 10**_decimals;
1344     }
1345 
1346     function setMaxBuytx(uint256 _newAmount) public onlyOwner {
1347         maxBuyTransactionAmount = _newAmount * 10**_decimals;
1348     }
1349 
1350     function setMaxWalletToken(uint256 _maxToken) external onlyOwner {
1351   	    maxWalletToken = _maxToken * 10**_decimals;
1352   	}
1353     
1354     //New router address?
1355     //No problem, just change it here!
1356     function setRouterAddress(address newRouter) public onlyOwner() {
1357         IUniswapV2Router02 _newPancakeRouter = IUniswapV2Router02(newRouter);
1358         uniswapV2Pair = IUniswapV2Factory(_newPancakeRouter.factory()).createPair(address(this), _newPancakeRouter.WETH());
1359         uniswapV2Router = _newPancakeRouter;
1360     }
1361     
1362     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1363         swapAndLiquifyEnabled = _enabled;
1364         emit SwapAndLiquifyEnabledUpdated(_enabled);
1365     }
1366     
1367     function transferToAddressETH(address payable recipient, uint256 amount) private {
1368         recipient.transfer(amount);
1369     }
1370     
1371 }