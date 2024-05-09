1 //Telegram:http://t.me/SHUKYOPORTAL
2         //Website:https://www.shukyo.online/
3         //Twitter:https://twitter.com/ShukyoEth
4 
5             
6                 //Faithless is he that says farewell when the road darkens.
7                 //Faithless is he that says farewell when the road darkens.
8                 //Faithless is he that says farewell when the road darkens.
9                 //Faithless is he that says farewell when the road darkens.
10                 //Faithless is he that says farewell when the road darkens.
11                 //Faithless is he that says farewell when the road darkens.
12                 //Faithless is he that says farewell when the road darkens.
13                 //Faithless is he that says farewell when the road darkens.
14                 //Faithless is he that says farewell when the road darkens.
15                 //Faithless is he that says farewell when the road darkens.
16                 //Faithless is he that says farewell when the road darkens.
17                 //Faithless is he that says farewell when the road darkens.
18                 //Faithless is he that says farewell when the road darkens.
19                 //Faithless is he that says farewell when the road darkens.
20                 //Faithless is he that says farewell when the road darkens.
21                 //Faithless is he that says farewell when the road darkens.
22                 //Faithless is he that says farewell when the road darkens.
23                 //Faithless is he that says farewell when the road darkens.
24                 //Faithless is he that says farewell when the road darkens.
25                 //Faithless is he that says farewell when the road darkens.
26                 //Faithless is he that says farewell when the road darkens.
27                 //Faithless is he that says farewell when the road darkens.
28                 //Faithless is he that says farewell when the road darkens.
29                 //Faithless is he that says farewell when the road darkens.
30                 //Faithless is he that says farewell when the road darkens.
31                 //Faithless is he that says farewell when the road darkens.
32                 //Faithless is he that says farewell when the road darkens.
33                 //Faithless is he that says farewell when the road darkens.
34                 //Faithless is he that says farewell when the road darkens.
35                 //Faithless is he that says farewell when the road darkens.
36                 //Faithless is he that says farewell when the road darkens.
37 
38 pragma solidity ^0.8.14;
39 
40 // SPDX-License-Identifier: Unlicensed
41 
42 interface IERC20 {
43 
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 abstract contract Context {
271     function _msgSender() internal view virtual returns (address payable) {
272         return payable(msg.sender);
273     }
274 
275     function _msgData() internal view virtual returns (bytes memory) {
276         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
277         return msg.data;
278     }
279 }
280 
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
305         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
306         // for accounts without code, i.e. `keccak256('')`
307         bytes32 codehash;
308         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
309         // solhint-disable-next-line no-inline-assembly
310         assembly { codehash := extcodehash(account) }
311         return (codehash != accountHash && codehash != 0x0);
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
334         (bool success, ) = recipient.call{ value: amount }("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain`call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         return _functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         return _functionCallWithValue(target, data, value, errorMessage);
394     }
395 
396     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
397         require(isContract(target), "Address: call to non-contract");
398 
399         // solhint-disable-next-line avoid-low-level-calls
400         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 // solhint-disable-next-line no-inline-assembly
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 /**
421  * @dev Contract module which provides a basic access control mechanism, where
422  * there is an account (an owner) that can be granted exclusive access to
423  * specific functions.
424  *
425  * By default, the owner account will be the one that deploys the contract. This
426  * can later be changed with {transferOwnership}.
427  *
428  * This module is used through inheritance. It will make available the modifier
429  * `onlyOwner`, which can be applied to your functions to restrict their use to
430  * the owner.
431  */
432 contract Ownable is Context {
433     address private _owner;
434     address private _previousOwner;
435     uint256 private _lockTime;
436 
437     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
438 
439     /**
440      * @dev Initializes the contract setting the deployer as the initial owner.
441      */
442     constructor () {
443         address msgSender = _msgSender();
444         _owner = msgSender;
445         emit OwnershipTransferred(address(0), msgSender);
446     }
447 
448     /**
449      * @dev Returns the address of the current owner.
450      */
451     function owner() public view returns (address) {
452         return _owner;
453     }
454 
455     /**
456      * @dev Throws if called by any account other than the owner.
457      */
458     modifier onlyOwner() {
459         require(_owner == _msgSender(), "Ownable: caller is not the owner");
460         _;
461     }
462 
463     /**
464     * @dev Leaves the contract without owner. It will not be possible to call
465     * `onlyOwner` functions anymore. Can only be called by the current owner.
466     *
467     * NOTE: Renouncing ownership will leave the contract without an owner,
468     * thereby removing any functionality that is only available to the owner.
469     */
470     function renounceOwnership() public virtual onlyOwner {
471         emit OwnershipTransferred(_owner, address(0));
472         _owner = address(0);
473     }
474 
475     /**
476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
477      * Can only be called by the current owner.
478      */
479     function transferOwnership(address newOwner) public virtual onlyOwner {
480         require(newOwner != address(0), "Ownable: new owner is the zero address");
481         emit OwnershipTransferred(_owner, newOwner);
482         _owner = newOwner;
483     }
484 }
485 // pragma solidity >=0.5.0;
486 
487 interface IUniswapV2Factory {
488     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
489 
490     function feeTo() external view returns (address);
491     function feeToSetter() external view returns (address);
492 
493     function getPair(address tokenA, address tokenB) external view returns (address pair);
494     function allPairs(uint) external view returns (address pair);
495     function allPairsLength() external view returns (uint);
496 
497     function createPair(address tokenA, address tokenB) external returns (address pair);
498 
499     function setFeeTo(address) external;
500     function setFeeToSetter(address) external;
501 }
502 
503 
504 // pragma solidity >=0.5.0;
505 
506 interface IUniswapV2Pair {
507     event Approval(address indexed owner, address indexed spender, uint value);
508     event Transfer(address indexed from, address indexed to, uint value);
509 
510     function name() external pure returns (string memory);
511     function symbol() external pure returns (string memory);
512     function decimals() external pure returns (uint8);
513     function totalSupply() external view returns (uint);
514     function balanceOf(address owner) external view returns (uint);
515     function allowance(address owner, address spender) external view returns (uint);
516 
517     function approve(address spender, uint value) external returns (bool);
518     function transfer(address to, uint value) external returns (bool);
519     function transferFrom(address from, address to, uint value) external returns (bool);
520 
521     function DOMAIN_SEPARATOR() external view returns (bytes32);
522     function PERMIT_TYPEHASH() external pure returns (bytes32);
523     function nonces(address owner) external view returns (uint);
524 
525     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
526 
527     event Mint(address indexed sender, uint amount0, uint amount1);
528     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
529     event Swap(
530         address indexed sender,
531         uint amount0In,
532         uint amount1In,
533         uint amount0Out,
534         uint amount1Out,
535         address indexed to
536     );
537     event Sync(uint112 reserve0, uint112 reserve1);
538 
539     function MINIMUM_LIQUIDITY() external pure returns (uint);
540     function factory() external view returns (address);
541     function token0() external view returns (address);
542     function token1() external view returns (address);
543     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
544     function price0CumulativeLast() external view returns (uint);
545     function price1CumulativeLast() external view returns (uint);
546     function kLast() external view returns (uint);
547 
548     function mint(address to) external returns (uint liquidity);
549     function burn(address to) external returns (uint amount0, uint amount1);
550     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
551     function skim(address to) external;
552     function sync() external;
553 
554     function initialize(address, address) external;
555 }
556 
557 // pragma solidity >=0.6.2;
558 
559 interface IUniswapV2Router01 {
560     function factory() external pure returns (address);
561     function WETH() external pure returns (address);
562 
563     function addLiquidity(
564         address tokenA,
565         address tokenB,
566         uint amountADesired,
567         uint amountBDesired,
568         uint amountAMin,
569         uint amountBMin,
570         address to,
571         uint deadline
572     ) external returns (uint amountA, uint amountB, uint liquidity);
573     function addLiquidityETH(
574         address token,
575         uint amountTokenDesired,
576         uint amountTokenMin,
577         uint amountETHMin,
578         address to,
579         uint deadline
580     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
581     function removeLiquidity(
582         address tokenA,
583         address tokenB,
584         uint liquidity,
585         uint amountAMin,
586         uint amountBMin,
587         address to,
588         uint deadline
589     ) external returns (uint amountA, uint amountB);
590     function removeLiquidityETH(
591         address token,
592         uint liquidity,
593         uint amountTokenMin,
594         uint amountETHMin,
595         address to,
596         uint deadline
597     ) external returns (uint amountToken, uint amountETH);
598     function removeLiquidityWithPermit(
599         address tokenA,
600         address tokenB,
601         uint liquidity,
602         uint amountAMin,
603         uint amountBMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountA, uint amountB);
608     function removeLiquidityETHWithPermit(
609         address token,
610         uint liquidity,
611         uint amountTokenMin,
612         uint amountETHMin,
613         address to,
614         uint deadline,
615         bool approveMax, uint8 v, bytes32 r, bytes32 s
616     ) external returns (uint amountToken, uint amountETH);
617     function swapExactTokensForTokens(
618         uint amountIn,
619         uint amountOutMin,
620         address[] calldata path,
621         address to,
622         uint deadline
623     ) external returns (uint[] memory amounts);
624     function swapTokensForExactTokens(
625         uint amountOut,
626         uint amountInMax,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external returns (uint[] memory amounts);
631     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
632     external
633     payable
634     returns (uint[] memory amounts);
635     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
636     external
637     returns (uint[] memory amounts);
638     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
639     external
640     returns (uint[] memory amounts);
641     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
642     external
643     payable
644     returns (uint[] memory amounts);
645 
646     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
647     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
648     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
649     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
650     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
651 }
652 
653 
654 // pragma solidity >=0.6.2;
655 
656 interface IUniswapV2Router02 is IUniswapV2Router01 {
657     function removeLiquidityETHSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline
664     ) external returns (uint amountETH);
665     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
666         address token,
667         uint liquidity,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         uint deadline,
672         bool approveMax, uint8 v, bytes32 r, bytes32 s
673     ) external returns (uint amountETH);
674 
675     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
676         uint amountIn,
677         uint amountOutMin,
678         address[] calldata path,
679         address to,
680         uint deadline
681     ) external;
682     function swapExactETHForTokensSupportingFeeOnTransferTokens(
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external payable;
688     function swapExactTokensForETHSupportingFeeOnTransferTokens(
689         uint amountIn,
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external;
695 }
696 
697 
698         
699 
700 contract SHUKYO is Context, IERC20, Ownable {
701     using SafeMath for uint256;
702     using Address for address;
703 
704 
705     struct RValuesStruct {
706         uint256 rAmount;
707         uint256 rTransferAmount;
708         uint256 rReflectionFee;
709         uint256 rBurnFee;
710         uint256 rmarketingTokenFee;
711         uint256 rMarketingETHFee;
712     }
713 
714     struct TValuesStruct {
715         uint256 tTransferAmount;
716         uint256 tReflectionFee;
717         uint256 tBurnFee;
718         uint256 tmarketingTokenFee;
719         uint256 tMarketingETHFee;
720     }
721 
722     struct ValuesStruct {
723         uint256 rAmount;
724         uint256 rTransferAmount;
725         uint256 rReflectionFee;
726         uint256 rBurnFee;
727         uint256 rmarketingTokenFee;
728         uint256 rMarketingETHFee;
729         uint256 tTransferAmount;
730         uint256 tReflectionFee;
731         uint256 tBurnFee;
732         uint256 tmarketingTokenFee;
733         uint256 tMarketingETHFee;
734     }
735 
736     mapping (address => uint256) private _rOwned;
737     mapping (address => uint256) private _tOwned;
738     mapping (address => mapping (address => uint256)) private _allowances;
739 
740     mapping (address => bool) private _isExcludedFromFee;
741 
742     mapping (address => bool) private _isExcluded;
743     address[] private _excluded;
744 
745     uint256 private constant MAX = ~uint256(0);
746     uint256 private _tTotal = 100 * 10**9 * 10**9;
747     uint256 private _rTotal = (MAX - (MAX % _tTotal));
748     uint256 private _tReflectionFeeTotal;
749     uint256 private _tBurnFeeTotal;
750 
751     string private _name = "SHUKYO";
752     string private _symbol = "SHUKYO";
753     uint8 private _decimals = 9;
754 
755     uint256 public _reflectionFee = 0;
756 
757     uint256 public _burnFee = 0;
758 
759     uint256 public _marketingTokenFee = 0;
760 
761     uint256 public _marketingETHFee = 5;
762 
763     address public marketingTokenFeeWallet = 0xa0e804f9C4f53922151091a9b3D71252d5C055EE;
764     address public marketingETHFeeWallet = 0xa0e804f9C4f53922151091a9b3D71252d5C055EE;
765 
766     IUniswapV2Router02 public immutable uniswapV2Router;
767     address public immutable uniswapV2Pair;
768 
769     bool inMarketingEthSwap = false;
770     bool public _marketingConverttoETH = true;
771     bool public _tradingEnabled = false;
772     
773     uint256 public _maxTxAmount = 1000 * 10**6 * 10**9;
774     uint256 private _numTokensSwapToETHForMarketing = 200 * 10**6 * 10**9;
775 
776     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
777  
778     modifier lockTheSwap {
779         inMarketingEthSwap = true;
780         _;
781         inMarketingEthSwap = false;
782     }
783 
784     constructor () {
785         _rOwned[_msgSender()] = _rTotal;
786  
787         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  // Uniswap V2
788         // Create a uniswap pair for this new token
789         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
790         .createPair(address(this), _uniswapV2Router.WETH());
791 
792         // set the rest of the contract variables
793         uniswapV2Router = _uniswapV2Router;
794 
795         //exclude owner and this contract from fee
796         _isExcludedFromFee[owner()] = true;
797         _isExcludedFromFee[address(this)] = true;
798 
799         emit Transfer(address(0), _msgSender(), _tTotal);
800     }
801 
802     function name() public view returns (string memory) {
803         return _name;
804     }
805 
806     function symbol() public view returns (string memory) {
807         return _symbol;
808     }
809 
810     function decimals() public view returns (uint8) {
811         return _decimals;
812     }
813 
814     function totalSupply() public view override returns (uint256) {
815         return _tTotal;
816     }
817 
818     function balanceOf(address account) public view override returns (uint256) {
819         if (_isExcluded[account]) return _tOwned[account];
820         return tokenFromReflection(_rOwned[account]);
821     }
822 
823     function transfer(address recipient, uint256 amount) public override returns (bool) {
824         _transfer(_msgSender(), recipient, amount);
825         return true;
826     }
827 
828     function allowance(address owner, address spender) public view override returns (uint256) {
829         return _allowances[owner][spender];
830     }
831 
832     function approve(address spender, uint256 amount) public override returns (bool) {
833         _approve(_msgSender(), spender, amount);
834         return true;
835     }
836 
837     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
838         _transfer(sender, recipient, amount);
839         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
840         return true;
841     }
842 
843     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
844         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
845         return true;
846     }
847 
848     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
849         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
850         return true;
851     }
852 
853     function isExcludedFromReward(address account) public view returns (bool) {
854         return _isExcluded[account];
855     }
856 
857     function totalReflectionFees() public view returns (uint256) {
858         return _tReflectionFeeTotal;
859     }
860 
861     function totalBurnFees() public view returns (uint256) {
862         return _tBurnFeeTotal;
863     }
864 
865     /**
866      * @dev Returns the Number of tokens in contract that are needed to be reached before swapping to ETH and sending to Marketing Wallet. .
867      */
868     function numTokensSwapToETHForMarketing() public view returns (uint256) {
869         return _numTokensSwapToETHForMarketing;
870     }
871 
872     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
873         require(tAmount <= _tTotal, "Amount must be less than supply");
874         if (!deductTransferFee) {
875             uint256 rAmount = _getValues(tAmount).rAmount;
876             return rAmount;
877         } else {
878             uint256 rTransferAmount = _getValues(tAmount).rTransferAmount;
879             return rTransferAmount;
880         }
881     }
882 
883     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
884         require(rAmount <= _rTotal, "Amount must be less than total reflections");
885         uint256 currentRate =  _getRate();
886         return rAmount.div(currentRate);
887     }
888 
889     function excludeFromReward(address account) public onlyOwner() {
890         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
891         require(!_isExcluded[account], "Account already excluded");
892         require(_excluded.length < 100, "Excluded list is too long");
893         if(_rOwned[account] > 0) {
894             _tOwned[account] = tokenFromReflection(_rOwned[account]);
895         }
896         _isExcluded[account] = true;
897         _excluded.push(account);
898     }
899 
900     //to recieve ETH from uniswapV2Router when swaping
901     receive() external payable {}
902 
903     function _distributeFee(uint256 rReflectionFee, uint256 rBurnFee, uint256 rmarketingTokenFee, uint256 tReflectionFee, uint256 tBurnFee, uint256 tmarketingTokenFee) private {
904         _rTotal = _rTotal.sub(rReflectionFee).sub(rBurnFee);
905         _tReflectionFeeTotal = _tReflectionFeeTotal.add(tReflectionFee);
906         _tTotal = _tTotal.sub(tBurnFee);
907         _tBurnFeeTotal = _tBurnFeeTotal.add(tBurnFee);
908 
909         _rOwned[marketingTokenFeeWallet] = _rOwned[marketingTokenFeeWallet].add(rmarketingTokenFee);
910         if (_isExcluded[marketingTokenFeeWallet]) {
911             _tOwned[marketingTokenFeeWallet] = _tOwned[marketingTokenFeeWallet].add(tmarketingTokenFee);
912         }
913     }
914 
915     function _getValues(uint256 tAmount) private view returns (ValuesStruct memory) {
916         TValuesStruct memory tvs = _getTValues(tAmount);
917         RValuesStruct memory rvs = _getRValues(tAmount, tvs.tReflectionFee, tvs.tBurnFee, tvs.tmarketingTokenFee, tvs.tMarketingETHFee, _getRate());
918 
919         return ValuesStruct(
920             rvs.rAmount,
921             rvs.rTransferAmount,
922             rvs.rReflectionFee,
923             rvs.rBurnFee,
924             rvs.rmarketingTokenFee,
925             rvs.rMarketingETHFee,
926             tvs.tTransferAmount,
927             tvs.tReflectionFee,
928             tvs.tBurnFee,
929             tvs.tmarketingTokenFee,
930             tvs.tMarketingETHFee
931         );
932     }
933 
934     function _getTValues(uint256 tAmount) private view returns (TValuesStruct memory) {
935         uint256 tReflectionFee = calculateReflectionFee(tAmount);
936         uint256 tBurnFee = calculateBurnFee(tAmount);
937         uint256 tmarketingTokenFee = calculatemarketingTokenFee(tAmount);
938         uint256 tMarketingETHFee = calculateMarketingETHFee(tAmount);
939         uint256 tTransferAmount = tAmount.sub(tReflectionFee).sub(tBurnFee).sub(tmarketingTokenFee).sub(tMarketingETHFee);
940         return TValuesStruct(tTransferAmount, tReflectionFee, tBurnFee, tmarketingTokenFee, tMarketingETHFee);
941     }
942 
943     function _getRValues(uint256 tAmount, uint256 tReflectionFee, uint256 tBurnFee, uint256 tmarketingTokenFee, uint256 tMarketingETHFee, uint256 currentRate) private pure returns (RValuesStruct memory) {
944         uint256 rAmount = tAmount.mul(currentRate);
945         uint256 rReflectionFee = tReflectionFee.mul(currentRate);
946         uint256 rBurnFee = tBurnFee.mul(currentRate);
947         uint256 rmarketingTokenFee = tmarketingTokenFee.mul(currentRate);
948         uint256 rMarketingETHFee = tMarketingETHFee.mul(currentRate);
949         uint256 rTransferAmount = rAmount.sub(rReflectionFee).sub(rMarketingETHFee).sub(rBurnFee).sub(rmarketingTokenFee);
950         return RValuesStruct(rAmount, rTransferAmount, rReflectionFee, rBurnFee, rmarketingTokenFee, rMarketingETHFee);
951     }
952 
953     function _getRate() private view returns(uint256) {
954         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
955         return rSupply.div(tSupply);
956     }
957 
958     function _getCurrentSupply() private view returns(uint256, uint256) {
959         uint256 rSupply = _rTotal;
960         uint256 tSupply = _tTotal;
961         for (uint256 i = 0; i < _excluded.length; i++) {
962             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
963             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
964             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
965         }
966         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
967         return (rSupply, tSupply);
968     }
969 
970     function _takeMarketingETHFee(uint256 rMarketingETHFee, uint256 tMarketingETHFee) private {
971         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingETHFee);
972         if(_isExcluded[address(this)])
973             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingETHFee);
974     }
975 
976     function calculateReflectionFee(uint256 _amount) private view returns (uint256) {
977         return _amount.mul(_reflectionFee).div(
978             10**2
979         );
980     }
981 
982     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
983         return _amount.mul(_burnFee).div(
984             10**2
985         );
986     }
987 
988     function calculatemarketingTokenFee(uint256 _amount) private view returns (uint256) {
989         return _amount.mul(_marketingTokenFee).div(
990             10**2
991         );
992     }
993 
994     function calculateMarketingETHFee(uint256 _amount) private view returns (uint256) {
995         return _amount.mul(_marketingETHFee).div(
996             10**2
997         );
998     }
999 
1000     function removeAllFee() private {
1001         _reflectionFee = 0;
1002         _marketingETHFee = 0;
1003         _burnFee = 0;
1004         _marketingTokenFee = 0;
1005     }
1006 
1007     function restoreAllFee() private {
1008         _reflectionFee = 0;
1009         _marketingETHFee = 5;
1010         _marketingTokenFee = 0;
1011         _burnFee = 0;
1012 	}
1013 
1014     function isExcludedFromFee(address account) public view returns(bool) {
1015         return _isExcludedFromFee[account];
1016     }
1017 
1018     function _approve(address owner, address spender, uint256 amount) private {
1019         require(owner != address(0), "ERC20: approve from the zero address");
1020         require(spender != address(0), "ERC20: approve to the zero address");
1021 		_allowances[owner][spender] = amount;
1022         emit Approval(owner, spender, amount);
1023     }
1024 
1025     function _transfer(
1026         address from,
1027         address to,
1028         uint256 amount
1029     ) private {
1030         require(from != address(0), "ERC20: transfer from the zero address");
1031         require(to != address(0), "ERC20: transfer to the zero address");
1032         require(amount > 0, "Transfer amount must be greater than zero");
1033         
1034         // block trading until owner has added liquidity and enabled trading
1035         if(!_tradingEnabled && from != owner()) {
1036             revert("Trading not yet enabled!");
1037         }
1038         
1039         // is the token balance of this contract address over the min number of
1040         // tokens that we need to initiate a swaptoEth lock?
1041         // also, don't get caught in a circular liquidity event.
1042         // also, don't SwapMarketingAndSendETH if sender is uniswap pair.
1043         uint256 contractTokenBalance = balanceOf(address(this));
1044         bool overMinTokenBalance = contractTokenBalance >= _numTokensSwapToETHForMarketing;
1045         if (
1046             overMinTokenBalance &&
1047             !inMarketingEthSwap &&
1048             from != uniswapV2Pair &&
1049             _marketingConverttoETH
1050         ) {
1051             contractTokenBalance = _numTokensSwapToETHForMarketing;
1052             //Perform a Swap of Token for ETH Portion of Marketing Fees
1053             swapMarketingAndSendEth(contractTokenBalance);
1054         }
1055 
1056         //transfer amount, it will take tax, burn, liquidity fee
1057         _tokenTransfer(from,to,amount);
1058 
1059     }
1060 
1061      function swapMarketingAndSendEth(uint256 tokenAmount) private lockTheSwap {
1062         // generate the uniswap pair path of token -> weth
1063         address[] memory path = new address[](2);
1064         path[0] = address(this);
1065         path[1] = uniswapV2Router.WETH();
1066 
1067         _approve(address(this), address(uniswapV2Router), tokenAmount);
1068 
1069         // make the swap
1070         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1071             tokenAmount,
1072             0, // accept any amount of ETH
1073             path,
1074             marketingETHFeeWallet,
1075             block.timestamp
1076         );
1077     }
1078 
1079     //this method is responsible for taking all fee, if takeFee is true
1080     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
1081         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1082             removeAllFee();
1083         }
1084         else{
1085             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1086         }
1087 
1088         ValuesStruct memory vs = _getValues(amount);
1089         _takeMarketingETHFee(vs.rMarketingETHFee, vs.tMarketingETHFee);
1090         _distributeFee(vs.rReflectionFee, vs.rBurnFee, vs.rmarketingTokenFee, vs.tReflectionFee, vs.tBurnFee, vs.tmarketingTokenFee);
1091 
1092         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1093             _transferFromExcluded(sender, recipient, amount, vs);
1094         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1095             _transferToExcluded(sender, recipient, vs);
1096         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1097             _transferStandard(sender, recipient, vs);
1098         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1099             _transferBothExcluded(sender, recipient, amount, vs);
1100         }
1101 
1102         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1103             restoreAllFee();
1104     }
1105 
1106     function _transferStandard(address sender, address recipient, ValuesStruct memory vs) private {
1107         _rOwned[sender] = _rOwned[sender].sub(vs.rAmount);
1108         _rOwned[recipient] = _rOwned[recipient].add(vs.rTransferAmount);
1109         emit Transfer(sender, recipient, vs.tTransferAmount);
1110     }
1111 
1112     function _transferToExcluded(address sender, address recipient, ValuesStruct memory vs) private {
1113         _rOwned[sender] = _rOwned[sender].sub(vs.rAmount);
1114         _tOwned[recipient] = _tOwned[recipient].add(vs.tTransferAmount);
1115         _rOwned[recipient] = _rOwned[recipient].add(vs.rTransferAmount);
1116         emit Transfer(sender, recipient, vs.tTransferAmount);
1117     }
1118 
1119     function _transferFromExcluded(address sender, address recipient, uint256 tAmount, ValuesStruct memory vs) private {
1120         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1121         _rOwned[sender] = _rOwned[sender].sub(vs.rAmount);
1122         _rOwned[recipient] = _rOwned[recipient].add(vs.rTransferAmount);
1123         emit Transfer(sender, recipient, vs.tTransferAmount);
1124     }
1125 
1126     function _transferBothExcluded(address sender, address recipient, uint256 tAmount, ValuesStruct memory vs) private {
1127         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1128         _rOwned[sender] = _rOwned[sender].sub(vs.rAmount);
1129         _tOwned[recipient] = _tOwned[recipient].add(vs.tTransferAmount);
1130         _rOwned[recipient] = _rOwned[recipient].add(vs.rTransferAmount);
1131         emit Transfer(sender, recipient, vs.tTransferAmount);
1132     }
1133 
1134     function excludeFromFee(address account) public onlyOwner {
1135         _isExcludedFromFee[account] = true;
1136     }
1137 
1138     function includeInFee(address account) public onlyOwner {
1139         _isExcludedFromFee[account] = false;
1140     }
1141 
1142     function enableAllFees() external onlyOwner() {
1143         _reflectionFee = 0;
1144         _burnFee = 0;
1145         _marketingTokenFee = 0;
1146         _marketingETHFee = 5;
1147         _marketingConverttoETH = true;
1148     }
1149 
1150     function disableAllFees() external onlyOwner() {
1151         _reflectionFee = 0;
1152         _burnFee = 0;
1153         _marketingTokenFee = 0;
1154         _marketingETHFee = 0;
1155         _marketingConverttoETH = false;
1156     }
1157 
1158     function setMarketingETHWallet(address newWallet) external onlyOwner() {
1159         marketingETHFeeWallet = newWallet;
1160     }
1161 
1162     function setMarketingTokenWallet(address newWallet) external onlyOwner() {
1163         marketingTokenFeeWallet = newWallet;
1164     }
1165 
1166     function setMaxTxAmount(uint256 maxAmountInTokensWithDecimals) external onlyOwner() {
1167         require(maxAmountInTokensWithDecimals > 100 * 10**6 * 10**9, "Cannot set transaction amount less than 0.1 percent of initial Total Supply!");
1168         _maxTxAmount = maxAmountInTokensWithDecimals;
1169     }
1170 
1171     function enableTrading() public onlyOwner {
1172         require(!_tradingEnabled, "Trading already enabled!");
1173         _tradingEnabled = true;
1174     }
1175 
1176     function setmarketingConverttoETH(bool _enabled) public onlyOwner {
1177         _marketingConverttoETH = _enabled;
1178     }
1179 
1180     // Number of Tokens to Accrue before Selling To Add to Marketing
1181 	function setnumTokensSwapToETHForMarketing(uint256 tokenAmount) external onlyOwner() {
1182        _numTokensSwapToETHForMarketing = tokenAmount;
1183     }
1184 
1185     /**
1186      * @dev Function to recover any ETH sent to Contract by Mistake.
1187     */	
1188     function recoverETHFromContract(uint256 weiAmount) external onlyOwner{
1189         require(address(this).balance >= weiAmount, "insufficient ETH balance");
1190         payable(owner()).transfer(weiAmount);
1191     }
1192        
1193     /**
1194      * @dev Function to recover any ERC20 Tokens sent to Contract by Mistake.
1195     */
1196     function recoverAnyERC20TokensFromContract(address _tokenAddr, address _to, uint _amount) public onlyOwner {
1197         IERC20(_tokenAddr).transfer(_to, _amount);
1198     }
1199 
1200 }