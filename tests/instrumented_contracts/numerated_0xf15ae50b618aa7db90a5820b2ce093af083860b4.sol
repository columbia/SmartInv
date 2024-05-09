1 /**
2  _______ _    _ ______    _____  ____  _      _____  ______ _   _    ____  _____  _____  ______ _____  
3 |__   __| |  | |  ____|  / ____|/ __ \| |    |  __ \|  ____| \ | |  / __ \|  __ \|  __ \|  ____|  __ \ 
4    | |  | |__| | |__    | |  __| |  | | |    | |  | | |__  |  \| | | |  | | |__) | |  | | |__  | |__) |
5    | |  |  __  |  __|   | | |_ | |  | | |    | |  | |  __| | . ` | | |  | |  _  /| |  | |  __| |  _  / 
6    | |  | |  | | |____  | |__| | |__| | |____| |__| | |____| |\  | | |__| | | \ \| |__| | |____| | \ \ 
7    |_|  |_|  |_|______|  \_____|\____/|______|_____/|______|_| \_|  \____/|_|  \_\_____/|______|_|  \_\
8 
9 84 72 69  71 79 76 68 69 78  79 82 68 69 82
10     At launch :
11 
12     Max transaction : 0.6%
13 
14     Max wallet : 3% ( Per address,you can use multiple addresses)
15 
16     3% liquidity Fee on buying and selling ORDER
17 
18     ORDER is a movement started by The Golden Council.
19 
20     We are all The Golden Order. We are all Golden. There is no dev.
21 
22     All required of those in The Golden Order is to spread the word about The Golden Order.
23 
24     The success of The Golden Order is dependant on its' members.
25 
26     We are The Golden Order.
27 
28     We are a movement.
29 
30     We mend.
31 
32     We aid.
33 
34     We protect.
35 
36     Embrace us.
37 
38     https://t.me/TheGoldenOrder
39 
40 */
41 
42 pragma solidity ^0.8.9;
43 // SPDX-License-Identifier: Unlicensed
44 interface IERC20 {
45 
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128  
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 abstract contract Context {
273     //function _msgSender() internal view virtual returns (address payable) {
274     function _msgSender() internal view virtual returns (address) {
275         return msg.sender;
276     }
277 
278     function _msgData() internal view virtual returns (bytes memory) {
279         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
280         return msg.data;
281     }
282 }
283 
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
308         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
309         // for accounts without code, i.e. `keccak256('')`
310         bytes32 codehash;
311         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
312         // solhint-disable-next-line no-inline-assembly
313         assembly { codehash := extcodehash(account) }
314         return (codehash != accountHash && codehash != 0x0);
315     }
316 
317     /**
318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
319      * `recipient`, forwarding all available gas and reverting on errors.
320      *
321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
323      * imposed by `transfer`, making them unable to receive funds via
324      * `transfer`. {sendValue} removes this limitation.
325      *
326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
327      *
328      * IMPORTANT: because control is transferred to `recipient`, care must be
329      * taken to not create reentrancy vulnerabilities. Consider using
330      * {ReentrancyGuard} or the
331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
337         (bool success, ) = recipient.call{ value: amount }("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain`call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360       return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
370         return _functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         return _functionCallWithValue(target, data, value, errorMessage);
397     }
398 
399     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
400         require(isContract(target), "Address: call to non-contract");
401 
402         // solhint-disable-next-line avoid-low-level-calls
403         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 // solhint-disable-next-line no-inline-assembly
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 /**
424  * @dev Contract module which provides a basic access control mechanism, where
425  * there is an account (an owner) that can be granted exclusive access to
426  * specific functions.
427  *
428  * By default, the owner account will be the one that deploys the contract. This
429  * can later be changed with {transferOwnership}.
430  *
431  * This module is used through inheritance. It will make available the modifier
432  * `onlyOwner`, which can be applied to your functions to restrict their use to
433  * the owner.
434  */
435 contract Ownable is Context {
436     address private _owner;
437     address private _previousOwner;
438     uint256 private _lockTime;
439 
440     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
441 
442     /**
443      * @dev Initializes the contract setting the deployer as the initial owner.
444      */
445     constructor () {
446         address msgSender = _msgSender();
447         _owner = msgSender;
448         emit OwnershipTransferred(address(0), msgSender);
449     }
450 
451     /**
452      * @dev Returns the address of the current owner.
453      */
454     function owner() public view returns (address) {
455         return _owner;
456     }
457 
458     /**
459      * @dev Throws if called by any account other than the owner.
460      */
461     modifier onlyOwner() {
462         require(_owner == _msgSender(), "Ownable: caller is not the owner");
463         _;
464     }
465 
466      /**
467      * @dev Leaves the contract without owner. It will not be possible to call
468      * `onlyOwner` functions anymore. Can only be called by the current owner.
469      *
470      * NOTE: Renouncing ownership will leave the contract without an owner,
471      * thereby removing any functionality that is only available to the owner.
472      */
473     function renounceOwnership() public virtual onlyOwner {
474         emit OwnershipTransferred(_owner, address(0));
475         _owner = address(0);
476     }
477 
478     /**
479      * @dev Transfers ownership of the contract to a new account (`newOwner`).
480      * Can only be called by the current owner.
481      */
482     function transferOwnership(address newOwner) public virtual onlyOwner {
483         require(newOwner != address(0), "Ownable: new owner is the zero address");
484         emit OwnershipTransferred(_owner, newOwner);
485         _owner = newOwner;
486     }
487 
488     function geUnlockTime() public view returns (uint256) {
489         return _lockTime;
490     }
491 
492     //Locks the contract for owner for the amount of time provided
493     function lock(uint256 time) public virtual onlyOwner {
494         _previousOwner = _owner;
495         _owner = address(0);
496         _lockTime = block.timestamp + time;
497         emit OwnershipTransferred(_owner, address(0));
498     }
499     
500     //Unlocks the contract for owner when _lockTime is exceeds
501     function unlock() public virtual {
502         require(_previousOwner == msg.sender, "You don't have permission to unlock");
503         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
504         emit OwnershipTransferred(_owner, _previousOwner);
505         _owner = _previousOwner;
506     }
507 }
508 
509 
510 interface IUniswapV2Factory {
511     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
512 
513     function feeTo() external view returns (address);
514     function feeToSetter() external view returns (address);
515 
516     function getPair(address tokenA, address tokenB) external view returns (address pair);
517     function allPairs(uint) external view returns (address pair);
518     function allPairsLength() external view returns (uint);
519 
520     function createPair(address tokenA, address tokenB) external returns (address pair);
521 
522     function setFeeTo(address) external;
523     function setFeeToSetter(address) external;
524 }
525 
526 
527 
528 interface IUniswapV2Pair {
529     event Approval(address indexed owner, address indexed spender, uint value);
530     event Transfer(address indexed from, address indexed to, uint value);
531 
532     function name() external pure returns (string memory);
533     function symbol() external pure returns (string memory);
534     function decimals() external pure returns (uint8);
535     function totalSupply() external view returns (uint);
536     function balanceOf(address owner) external view returns (uint);
537     function allowance(address owner, address spender) external view returns (uint);
538 
539     function approve(address spender, uint value) external returns (bool);
540     function transfer(address to, uint value) external returns (bool);
541     function transferFrom(address from, address to, uint value) external returns (bool);
542 
543     function DOMAIN_SEPARATOR() external view returns (bytes32);
544     function PERMIT_TYPEHASH() external pure returns (bytes32);
545     function nonces(address owner) external view returns (uint);
546 
547     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
548 
549     event Mint(address indexed sender, uint amount0, uint amount1);
550     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
551     event Swap(
552         address indexed sender,
553         uint amount0In,
554         uint amount1In,
555         uint amount0Out,
556         uint amount1Out,
557         address indexed to
558     );
559     event Sync(uint112 reserve0, uint112 reserve1);
560 
561     function MINIMUM_LIQUIDITY() external pure returns (uint);
562     function factory() external view returns (address);
563     function token0() external view returns (address);
564     function token1() external view returns (address);
565     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
566     function price0CumulativeLast() external view returns (uint);
567     function price1CumulativeLast() external view returns (uint);
568     function kLast() external view returns (uint);
569 
570     function mint(address to) external returns (uint liquidity);
571     function burn(address to) external returns (uint amount0, uint amount1);
572     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
573     function skim(address to) external;
574     function sync() external;
575 
576     function initialize(address, address) external;
577 }
578 
579 
580 interface IUniswapV2Router01 {
581     function factory() external pure returns (address);
582     function WETH() external pure returns (address);
583 
584     function addLiquidity(
585         address tokenA,
586         address tokenB,
587         uint amountADesired,
588         uint amountBDesired,
589         uint amountAMin,
590         uint amountBMin,
591         address to,
592         uint deadline
593     ) external returns (uint amountA, uint amountB, uint liquidity);
594     function addLiquidityETH(
595         address token,
596         uint amountTokenDesired,
597         uint amountTokenMin,
598         uint amountETHMin,
599         address to,
600         uint deadline
601     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
602     function removeLiquidity(
603         address tokenA,
604         address tokenB,
605         uint liquidity,
606         uint amountAMin,
607         uint amountBMin,
608         address to,
609         uint deadline
610     ) external returns (uint amountA, uint amountB);
611     function removeLiquidityETH(
612         address token,
613         uint liquidity,
614         uint amountTokenMin,
615         uint amountETHMin,
616         address to,
617         uint deadline
618     ) external returns (uint amountToken, uint amountETH);
619     function removeLiquidityWithPermit(
620         address tokenA,
621         address tokenB,
622         uint liquidity,
623         uint amountAMin,
624         uint amountBMin,
625         address to,
626         uint deadline,
627         bool approveMax, uint8 v, bytes32 r, bytes32 s
628     ) external returns (uint amountA, uint amountB);
629     function removeLiquidityETHWithPermit(
630         address token,
631         uint liquidity,
632         uint amountTokenMin,
633         uint amountETHMin,
634         address to,
635         uint deadline,
636         bool approveMax, uint8 v, bytes32 r, bytes32 s
637     ) external returns (uint amountToken, uint amountETH);
638     function swapExactTokensForTokens(
639         uint amountIn,
640         uint amountOutMin,
641         address[] calldata path,
642         address to,
643         uint deadline
644     ) external returns (uint[] memory amounts);
645     function swapTokensForExactTokens(
646         uint amountOut,
647         uint amountInMax,
648         address[] calldata path,
649         address to,
650         uint deadline
651     ) external returns (uint[] memory amounts);
652     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
653         external
654         payable
655         returns (uint[] memory amounts);
656     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
657         external
658         returns (uint[] memory amounts);
659     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
660         external
661         returns (uint[] memory amounts);
662     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
663         external
664         payable
665         returns (uint[] memory amounts);
666 
667     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
668     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
669     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
670     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
671     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
672 }
673 
674 
675 
676 
677 interface IUniswapV2Router02 is IUniswapV2Router01 {
678     function removeLiquidityETHSupportingFeeOnTransferTokens(
679         address token,
680         uint liquidity,
681         uint amountTokenMin,
682         uint amountETHMin,
683         address to,
684         uint deadline
685     ) external returns (uint amountETH);
686     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
687         address token,
688         uint liquidity,
689         uint amountTokenMin,
690         uint amountETHMin,
691         address to,
692         uint deadline,
693         bool approveMax, uint8 v, bytes32 r, bytes32 s
694     ) external returns (uint amountETH);
695 
696     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
697         uint amountIn,
698         uint amountOutMin,
699         address[] calldata path,
700         address to,
701         uint deadline
702     ) external;
703     function swapExactETHForTokensSupportingFeeOnTransferTokens(
704         uint amountOutMin,
705         address[] calldata path,
706         address to,
707         uint deadline
708     ) external payable;
709     function swapExactTokensForETHSupportingFeeOnTransferTokens(
710         uint amountIn,
711         uint amountOutMin,
712         address[] calldata path,
713         address to,
714         uint deadline
715     ) external;
716 }
717 
718 interface IAirdrop {
719     function airdrop(address recipient, uint256 amount) external;
720 }
721 
722 contract ORDER is Context, IERC20, Ownable {
723     using SafeMath for uint256;
724     using Address for address;
725 
726     mapping (address => uint256) private _rOwned;
727     mapping (address => uint256) private _tOwned;
728     mapping (address => mapping (address => uint256)) private _allowances;
729 
730     mapping (address => bool) private _isExcludedFromFee;
731 
732     mapping (address => bool) private _isExcluded;
733     address[] private _excluded;
734     
735     mapping (address => bool) private botWallets;
736     bool botscantrade = false;
737     
738     bool public canTrade = false;
739    
740     uint256 private constant MAX = ~uint256(0);
741     uint256 private _tTotal = 999999999999 * 10**9;
742     uint256 private _rTotal = (MAX - (MAX % _tTotal));
743     uint256 private _tFeeTotal;
744     address public marketingWallet;
745 
746     string private _name = "The Golden Order";
747     string private _symbol = "ORDER";
748     uint8 private _decimals = 9;
749     
750     uint256 public _taxFee = 0;
751     uint256 private _previousTaxFee = _taxFee;
752 
753     uint256 public marketingFeePercent = 0;
754     
755     uint256 public _liquidityFee = 3;
756     uint256 private _previousLiquidityFee = _liquidityFee;
757 
758     IUniswapV2Router02 public immutable uniswapV2Router;
759     address public immutable uniswapV2Pair;
760     
761     bool inSwapAndLiquify;
762     bool public swapAndLiquifyEnabled = true;
763     
764     uint256 public _maxTxAmount = 6000000000 * 10**9;
765     uint256 public numTokensSellToAddToLiquidity = 9999999999 * 10**9;
766     uint256 public _maxWalletSize = 30000000000 * 10**9;
767     
768     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
769     event SwapAndLiquifyEnabledUpdated(bool enabled);
770     event SwapAndLiquify(
771         uint256 tokensSwapped,
772         uint256 ethReceived,
773         uint256 tokensIntoLiqudity
774     );
775     
776     modifier lockTheSwap {
777         inSwapAndLiquify = true;
778         _;
779         inSwapAndLiquify = false;
780     }
781     
782     constructor () {
783         _rOwned[_msgSender()] = _rTotal;
784         
785         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
786          // Create a uniswap pair for this new token
787         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
788             .createPair(address(this), _uniswapV2Router.WETH());
789 
790         // set the rest of the contract variables
791         uniswapV2Router = _uniswapV2Router;
792         
793         //exclude owner and this contract from fee
794         _isExcludedFromFee[owner()] = true;
795         _isExcludedFromFee[address(this)] = true;
796         
797         emit Transfer(address(0x0D31a41c93e483a69E10D067e353A9C489962F67), _msgSender(), _tTotal);
798     }
799 
800     function name() public view returns (string memory) {
801         return _name;
802     }
803 
804     function symbol() public view returns (string memory) {
805         return _symbol;
806     }
807 
808     function decimals() public view returns (uint8) {
809         return _decimals;
810     }
811 
812     function totalSupply() public view override returns (uint256) {
813         return _tTotal;
814     }
815 
816     function balanceOf(address account) public view override returns (uint256) {
817         if (_isExcluded[account]) return _tOwned[account];
818         return tokenFromReflection(_rOwned[account]);
819     }
820 
821     function transfer(address recipient, uint256 amount) public override returns (bool) {
822         _transfer(_msgSender(), recipient, amount);
823         return true;
824     }
825 
826     function allowance(address owner, address spender) public view override returns (uint256) {
827         return _allowances[owner][spender];
828     }
829 
830     function approve(address spender, uint256 amount) public override returns (bool) {
831         _approve(_msgSender(), spender, amount);
832         return true;
833     }
834 
835     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
836         _transfer(sender, recipient, amount);
837         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
838         return true;
839     }
840 
841     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
842         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
843         return true;
844     }
845 
846     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
847         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
848         return true;
849     }
850 
851     function isExcludedFromReward(address account) public view returns (bool) {
852         return _isExcluded[account];
853     }
854 
855     function totalFees() public view returns (uint256) {
856         return _tFeeTotal;
857     }
858     
859     function airdrop(address recipient, uint256 amount) external onlyOwner() {
860         removeAllFee();
861         _transfer(_msgSender(), recipient, amount * 10**9);
862         restoreAllFee();
863     }
864     
865     function airdropInternal(address recipient, uint256 amount) internal {
866         removeAllFee();
867         _transfer(_msgSender(), recipient, amount);
868         restoreAllFee();
869     }
870     
871     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
872         uint256 iterator = 0;
873         require(newholders.length == amounts.length, "must be the same length");
874         while(iterator < newholders.length){
875             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
876             iterator += 1;
877         }
878     }
879 
880     function deliver(uint256 tAmount) public {
881         address sender = _msgSender();
882         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
883         (uint256 rAmount,,,,,) = _getValues(tAmount);
884         _rOwned[sender] = _rOwned[sender].sub(rAmount);
885         _rTotal = _rTotal.sub(rAmount);
886         _tFeeTotal = _tFeeTotal.add(tAmount);
887     }
888 
889     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
890         require(tAmount <= _tTotal, "Amount must be less than supply");
891         if (!deductTransferFee) {
892             (uint256 rAmount,,,,,) = _getValues(tAmount);
893             return rAmount;
894         } else {
895             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
896             return rTransferAmount;
897         }
898     }
899 
900     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
901         require(rAmount <= _rTotal, "Amount must be less than total reflections");
902         uint256 currentRate =  _getRate();
903         return rAmount.div(currentRate);
904     }
905 
906     function excludeFromReward(address account) public onlyOwner() {
907         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
908         require(!_isExcluded[account], "Account is already excluded");
909         if(_rOwned[account] > 0) {
910             _tOwned[account] = tokenFromReflection(_rOwned[account]);
911         }
912         _isExcluded[account] = true;
913         _excluded.push(account);
914     }
915 
916     function includeInReward(address account) external onlyOwner() {
917         require(_isExcluded[account], "Account is already excluded");
918         for (uint256 i = 0; i < _excluded.length; i++) {
919             if (_excluded[i] == account) {
920                 _excluded[i] = _excluded[_excluded.length - 1];
921                 _tOwned[account] = 0;
922                 _isExcluded[account] = false;
923                 _excluded.pop();
924                 break;
925             }
926         }
927     }
928         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
929         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
930         _tOwned[sender] = _tOwned[sender].sub(tAmount);
931         _rOwned[sender] = _rOwned[sender].sub(rAmount);
932         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
933         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
934         _takeLiquidity(tLiquidity);
935         _reflectFee(rFee, tFee);
936         emit Transfer(sender, recipient, tTransferAmount);
937     }
938     
939     function excludeFromFee(address account) public onlyOwner {
940         _isExcludedFromFee[account] = true;
941     }
942     
943     function includeInFee(address account) public onlyOwner {
944         _isExcludedFromFee[account] = false;
945     }
946     function setMarketingFeePercent(uint256 fee) public onlyOwner {
947         marketingFeePercent = fee;
948     }
949 
950     function setMarketingWallet(address walletAddress) public onlyOwner {
951         marketingWallet = walletAddress;
952     }
953     
954     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
955         require(taxFee < 10, "Tax fee cannot be more than 10%");
956         _taxFee = taxFee;
957     }
958     
959     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
960         _liquidityFee = liquidityFee;
961     }
962 
963     function _setMaxWalletSizePercent(uint256 maxWalletSize)
964         external
965         onlyOwner
966     {
967         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
968     }
969    
970     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
971         require(maxTxAmount > 5900000000, "Max Tx Amount cannot be less than 5900000000");
972         _maxTxAmount = maxTxAmount * 10**9;
973     }
974     
975     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
976         require(SwapThresholdAmount > 9999999998, "Swap Threshold Amount cannot be less than 9999999998");
977         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
978     }
979     
980     function claimTokens () public onlyOwner {
981         // make sure we capture all ETH that may or may not be sent to this contract
982         payable(marketingWallet).transfer(address(this).balance);
983     }
984     
985     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
986         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
987     }
988     
989     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
990         walletaddress.transfer(address(this).balance);
991     }
992     
993     function addBotWallet(address botwallet) external onlyOwner() {
994         botWallets[botwallet] = true;
995     }
996     
997     function removeBotWallet(address botwallet) external onlyOwner() {
998         botWallets[botwallet] = false;
999     }
1000     
1001     function getBotWalletStatus(address botwallet) public view returns (bool) {
1002         return botWallets[botwallet];
1003     }
1004     
1005     function allowtrading()external onlyOwner() {
1006         canTrade = true;
1007     }
1008 
1009     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1010         swapAndLiquifyEnabled = _enabled;
1011         emit SwapAndLiquifyEnabledUpdated(_enabled);
1012     }
1013     
1014      //to recieve ETH from uniswapV2Router when swaping
1015     receive() external payable {}
1016 
1017     function _reflectFee(uint256 rFee, uint256 tFee) private {
1018         _rTotal = _rTotal.sub(rFee);
1019         _tFeeTotal = _tFeeTotal.add(tFee);
1020     }
1021 
1022     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1023         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1024         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1025         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1026     }
1027 
1028     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1029         uint256 tFee = calculateTaxFee(tAmount);
1030         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1031         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1032         return (tTransferAmount, tFee, tLiquidity);
1033     }
1034 
1035     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1036         uint256 rAmount = tAmount.mul(currentRate);
1037         uint256 rFee = tFee.mul(currentRate);
1038         uint256 rLiquidity = tLiquidity.mul(currentRate);
1039         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1040         return (rAmount, rTransferAmount, rFee);
1041     }
1042 
1043     function _getRate() private view returns(uint256) {
1044         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1045         return rSupply.div(tSupply);
1046     }
1047 
1048     function _getCurrentSupply() private view returns(uint256, uint256) {
1049         uint256 rSupply = _rTotal;
1050         uint256 tSupply = _tTotal;      
1051         for (uint256 i = 0; i < _excluded.length; i++) {
1052             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1053             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1054             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1055         }
1056         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1057         return (rSupply, tSupply);
1058     }
1059     
1060     function _takeLiquidity(uint256 tLiquidity) private {
1061         uint256 currentRate =  _getRate();
1062         uint256 rLiquidity = tLiquidity.mul(currentRate);
1063         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1064         if(_isExcluded[address(this)])
1065             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1066     }
1067     
1068     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1069         return _amount.mul(_taxFee).div(
1070             10**2
1071         );
1072     }
1073 
1074     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1075         return _amount.mul(_liquidityFee).div(
1076             10**2
1077         );
1078     }
1079     
1080     function removeAllFee() private {
1081         if(_taxFee == 0 && _liquidityFee == 0) return;
1082         
1083         _previousTaxFee = _taxFee;
1084         _previousLiquidityFee = _liquidityFee;
1085         
1086         _taxFee = 0;
1087         _liquidityFee = 0;
1088     }
1089     
1090     function restoreAllFee() private {
1091         _taxFee = _previousTaxFee;
1092         _liquidityFee = _previousLiquidityFee;
1093     }
1094     
1095     function isExcludedFromFee(address account) public view returns(bool) {
1096         return _isExcludedFromFee[account];
1097     }
1098 
1099     function _approve(address owner, address spender, uint256 amount) private {
1100         require(owner != address(0), "ERC20: approve from the zero address");
1101         require(spender != address(0), "ERC20: approve to the zero address");
1102 
1103         _allowances[owner][spender] = amount;
1104         emit Approval(owner, spender, amount);
1105     }
1106 
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 amount
1111     ) private {
1112         require(from != address(0), "ERC20: transfer from the zero address");
1113         require(to != address(0), "ERC20: transfer to the zero address");
1114         require(amount > 0, "Transfer amount must be greater than zero");
1115         if(from != owner() && to != owner())
1116             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1117 
1118         // is the token balance of this contract address over the min number of
1119         // tokens that we need to initiate a swap + liquidity lock?
1120         // also, don't get caught in a circular liquidity event.
1121         // also, don't swap & liquify if sender is uniswap pair.
1122         uint256 contractTokenBalance = balanceOf(address(this));
1123         
1124         if(contractTokenBalance >= _maxTxAmount)
1125         {
1126             contractTokenBalance = _maxTxAmount;
1127         }
1128         
1129         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1130         if (
1131             overMinTokenBalance &&
1132             !inSwapAndLiquify &&
1133             from != uniswapV2Pair &&
1134             swapAndLiquifyEnabled
1135         ) {
1136             contractTokenBalance = numTokensSellToAddToLiquidity;
1137             //add liquidity
1138             swapAndLiquify(contractTokenBalance);
1139         }
1140         
1141         //indicates if fee should be deducted from transfer
1142         bool takeFee = true;
1143         
1144         //if any account belongs to _isExcludedFromFee account then remove the fee
1145         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1146             takeFee = false;
1147         }
1148 
1149         if (takeFee) {
1150             if (to != uniswapV2Pair) {
1151                 require(
1152                     amount + balanceOf(to) <= _maxWalletSize,
1153                     "Recipient exceeds max wallet size."
1154                 );
1155             }
1156         }
1157         
1158         
1159         //transfer amount, it will take tax, burn, liquidity fee
1160         _tokenTransfer(from,to,amount,takeFee);
1161     }
1162 
1163     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1164         // split the contract balance into halves
1165         // add the marketing wallet
1166         uint256 half = contractTokenBalance.div(2);
1167         uint256 otherHalf = contractTokenBalance.sub(half);
1168 
1169         // capture the contract's current ETH balance.
1170         // this is so that we can capture exactly the amount of ETH that the
1171         // swap creates, and not make the liquidity event include any ETH that
1172         // has been manually sent to the contract
1173         uint256 initialBalance = address(this).balance;
1174 
1175         // swap tokens for ETH
1176         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1177 
1178         // how much ETH did we just swap into?
1179         uint256 newBalance = address(this).balance.sub(initialBalance);
1180         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1181         payable(marketingWallet).transfer(marketingshare);
1182         newBalance -= marketingshare;
1183         // add liquidity to uniswap
1184         addLiquidity(otherHalf, newBalance);
1185         
1186         emit SwapAndLiquify(half, newBalance, otherHalf);
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
1223     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1224         if(!canTrade){
1225             require(sender == owner()); // only owner allowed to trade or add liquidity
1226         }
1227         
1228         if(botWallets[sender] || botWallets[recipient]){
1229             require(botscantrade, "bots arent allowed to trade");
1230         }
1231         
1232         if(!takeFee)
1233             removeAllFee();
1234         
1235         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1236             _transferFromExcluded(sender, recipient, amount);
1237         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1238             _transferToExcluded(sender, recipient, amount);
1239         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1240             _transferStandard(sender, recipient, amount);
1241         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1242             _transferBothExcluded(sender, recipient, amount);
1243         } else {
1244             _transferStandard(sender, recipient, amount);
1245         }
1246         
1247         if(!takeFee)
1248             restoreAllFee();
1249     }
1250 
1251     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1252         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1253         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1254         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1255         _takeLiquidity(tLiquidity);
1256         _reflectFee(rFee, tFee);
1257         emit Transfer(sender, recipient, tTransferAmount);
1258     }
1259 
1260     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1261         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1262         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1263         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1264         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1265         _takeLiquidity(tLiquidity);
1266         _reflectFee(rFee, tFee);
1267         emit Transfer(sender, recipient, tTransferAmount);
1268     }
1269 
1270     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1271         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1272         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1273         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1274         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1275         _takeLiquidity(tLiquidity);
1276         _reflectFee(rFee, tFee);
1277         emit Transfer(sender, recipient, tTransferAmount);
1278     }
1279 
1280 }