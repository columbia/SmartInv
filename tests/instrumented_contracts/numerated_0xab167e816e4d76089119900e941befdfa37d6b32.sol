1 /**
2  *
3  *
4  *
5  *  █████████  █████       ███  █████                         █████      ███ 
6  * ███░░░░░███░░███       ░░░  ░░███                         ░░███      ░░░  
7  *░███    ░░░  ░███████   ████  ░███████  ████████    ██████  ░███████  ████ 
8  *░░█████████  ░███░░███ ░░███  ░███░░███░░███░░███  ███░░███ ░███░░███░░███ 
9  * ░░░░░░░░███ ░███ ░███  ░███  ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███ 
10  * ███    ░███ ░███ ░███  ░███  ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███ 
11  *░░█████████  ████ █████ █████ ████████  ████ █████░░██████  ████████  █████
12  * ░░░░░░░░░  ░░░░ ░░░░░ ░░░░░ ░░░░░░░░  ░░░░ ░░░░░  ░░░░░░  ░░░░░░░░  ░░░░░ 
13  *                                                                           
14  *                                                                           
15 */                                                                           
16 
17 // Shibnobi ETH
18 // Version: 20211106001
19 // Website: www.shibnobi.com
20 // Twitter: https://twitter.com/Shib_nobi (@Shib_nobi)
21 // TG: https://t.me/ShibnobiCommunity
22 // Facebook: https://www.facebook.com/Shibnobi
23 // Instagram: https://www.instagram.com/shibnobi/
24 // Medium: https://medium.com/@Shibnobi
25 // Reddit: https://www.reddit.com/r/Shibnobi/
26 
27 pragma solidity ^0.8.9;
28 // SPDX-License-Identifier: Unlicensed
29 interface IERC20 {
30 
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113  
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175         // benefit is lost if 'b' is also tested.
176         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 abstract contract Context {
258     //function _msgSender() internal view virtual returns (address payable) {
259     function _msgSender() internal view virtual returns (address) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view virtual returns (bytes memory) {
264         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
265         return msg.data;
266     }
267 }
268 
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { codehash := extcodehash(account) }
299         return (codehash != accountHash && codehash != 0x0);
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345       return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return _functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         return _functionCallWithValue(target, data, value, errorMessage);
382     }
383 
384     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
385         require(isContract(target), "Address: call to non-contract");
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 /**
409  * @dev Contract module which provides a basic access control mechanism, where
410  * there is an account (an owner) that can be granted exclusive access to
411  * specific functions.
412  *
413  * By default, the owner account will be the one that deploys the contract. This
414  * can later be changed with {transferOwnership}.
415  *
416  * This module is used through inheritance. It will make available the modifier
417  * `onlyOwner`, which can be applied to your functions to restrict their use to
418  * the owner.
419  */
420 contract Ownable is Context {
421     address private _owner;
422     address private _previousOwner;
423     uint256 private _lockTime;
424 
425     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
426 
427     /**
428      * @dev Initializes the contract setting the deployer as the initial owner.
429      */
430     constructor () {
431         address msgSender = _msgSender();
432         _owner = msgSender;
433         emit OwnershipTransferred(address(0), msgSender);
434     }
435 
436     /**
437      * @dev Returns the address of the current owner.
438      */
439     function owner() public view returns (address) {
440         return _owner;
441     }
442 
443     /**
444      * @dev Throws if called by any account other than the owner.
445      */
446     modifier onlyOwner() {
447         require(_owner == _msgSender(), "Ownable: caller is not the owner");
448         _;
449     }
450 
451      /**
452      * @dev Leaves the contract without owner. It will not be possible to call
453      * `onlyOwner` functions anymore. Can only be called by the current owner.
454      *
455      * NOTE: Renouncing ownership will leave the contract without an owner,
456      * thereby removing any functionality that is only available to the owner.
457      */
458     function renounceOwnership() public virtual onlyOwner {
459         emit OwnershipTransferred(_owner, address(0));
460         _owner = address(0);
461     }
462 
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Can only be called by the current owner.
466      */
467     function transferOwnership(address newOwner) public virtual onlyOwner {
468         require(newOwner != address(0), "Ownable: new owner is the zero address");
469         emit OwnershipTransferred(_owner, newOwner);
470         _owner = newOwner;
471     }
472 
473     function geUnlockTime() public view returns (uint256) {
474         return _lockTime;
475     }
476 
477     //Locks the contract for owner for the amount of time provided
478     function lock(uint256 time) public virtual onlyOwner {
479         _previousOwner = _owner;
480         _owner = address(0);
481         _lockTime = block.timestamp + time;
482         emit OwnershipTransferred(_owner, address(0));
483     }
484     
485     //Unlocks the contract for owner when _lockTime is exceeds
486     function unlock() public virtual {
487         require(_previousOwner == msg.sender, "You don't have permission to unlock");
488         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
489         emit OwnershipTransferred(_owner, _previousOwner);
490         _owner = _previousOwner;
491     }
492 }
493 
494 
495 interface IUniswapV2Factory {
496     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
497 
498     function feeTo() external view returns (address);
499     function feeToSetter() external view returns (address);
500 
501     function getPair(address tokenA, address tokenB) external view returns (address pair);
502     function allPairs(uint) external view returns (address pair);
503     function allPairsLength() external view returns (uint);
504 
505     function createPair(address tokenA, address tokenB) external returns (address pair);
506 
507     function setFeeTo(address) external;
508     function setFeeToSetter(address) external;
509 }
510 
511 
512 
513 interface IUniswapV2Pair {
514     event Approval(address indexed owner, address indexed spender, uint value);
515     event Transfer(address indexed from, address indexed to, uint value);
516 
517     function name() external pure returns (string memory);
518     function symbol() external pure returns (string memory);
519     function decimals() external pure returns (uint8);
520     function totalSupply() external view returns (uint);
521     function balanceOf(address owner) external view returns (uint);
522     function allowance(address owner, address spender) external view returns (uint);
523 
524     function approve(address spender, uint value) external returns (bool);
525     function transfer(address to, uint value) external returns (bool);
526     function transferFrom(address from, address to, uint value) external returns (bool);
527 
528     function DOMAIN_SEPARATOR() external view returns (bytes32);
529     function PERMIT_TYPEHASH() external pure returns (bytes32);
530     function nonces(address owner) external view returns (uint);
531 
532     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
533 
534     event Mint(address indexed sender, uint amount0, uint amount1);
535     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
536     event Swap(
537         address indexed sender,
538         uint amount0In,
539         uint amount1In,
540         uint amount0Out,
541         uint amount1Out,
542         address indexed to
543     );
544     event Sync(uint112 reserve0, uint112 reserve1);
545 
546     function MINIMUM_LIQUIDITY() external pure returns (uint);
547     function factory() external view returns (address);
548     function token0() external view returns (address);
549     function token1() external view returns (address);
550     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
551     function price0CumulativeLast() external view returns (uint);
552     function price1CumulativeLast() external view returns (uint);
553     function kLast() external view returns (uint);
554 
555     function mint(address to) external returns (uint liquidity);
556     function burn(address to) external returns (uint amount0, uint amount1);
557     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
558     function skim(address to) external;
559     function sync() external;
560 
561     function initialize(address, address) external;
562 }
563 
564 
565 interface IUniswapV2Router01 {
566     function factory() external pure returns (address);
567     function WETH() external pure returns (address);
568 
569     function addLiquidity(
570         address tokenA,
571         address tokenB,
572         uint amountADesired,
573         uint amountBDesired,
574         uint amountAMin,
575         uint amountBMin,
576         address to,
577         uint deadline
578     ) external returns (uint amountA, uint amountB, uint liquidity);
579     function addLiquidityETH(
580         address token,
581         uint amountTokenDesired,
582         uint amountTokenMin,
583         uint amountETHMin,
584         address to,
585         uint deadline
586     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
587     function removeLiquidity(
588         address tokenA,
589         address tokenB,
590         uint liquidity,
591         uint amountAMin,
592         uint amountBMin,
593         address to,
594         uint deadline
595     ) external returns (uint amountA, uint amountB);
596     function removeLiquidityETH(
597         address token,
598         uint liquidity,
599         uint amountTokenMin,
600         uint amountETHMin,
601         address to,
602         uint deadline
603     ) external returns (uint amountToken, uint amountETH);
604     function removeLiquidityWithPermit(
605         address tokenA,
606         address tokenB,
607         uint liquidity,
608         uint amountAMin,
609         uint amountBMin,
610         address to,
611         uint deadline,
612         bool approveMax, uint8 v, bytes32 r, bytes32 s
613     ) external returns (uint amountA, uint amountB);
614     function removeLiquidityETHWithPermit(
615         address token,
616         uint liquidity,
617         uint amountTokenMin,
618         uint amountETHMin,
619         address to,
620         uint deadline,
621         bool approveMax, uint8 v, bytes32 r, bytes32 s
622     ) external returns (uint amountToken, uint amountETH);
623     function swapExactTokensForTokens(
624         uint amountIn,
625         uint amountOutMin,
626         address[] calldata path,
627         address to,
628         uint deadline
629     ) external returns (uint[] memory amounts);
630     function swapTokensForExactTokens(
631         uint amountOut,
632         uint amountInMax,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external returns (uint[] memory amounts);
637     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
638         external
639         payable
640         returns (uint[] memory amounts);
641     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
642         external
643         returns (uint[] memory amounts);
644     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
645         external
646         returns (uint[] memory amounts);
647     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
648         external
649         payable
650         returns (uint[] memory amounts);
651 
652     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
653     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
654     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
655     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
656     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
657 }
658 
659 
660 
661 
662 interface IUniswapV2Router02 is IUniswapV2Router01 {
663     function removeLiquidityETHSupportingFeeOnTransferTokens(
664         address token,
665         uint liquidity,
666         uint amountTokenMin,
667         uint amountETHMin,
668         address to,
669         uint deadline
670     ) external returns (uint amountETH);
671     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
672         address token,
673         uint liquidity,
674         uint amountTokenMin,
675         uint amountETHMin,
676         address to,
677         uint deadline,
678         bool approveMax, uint8 v, bytes32 r, bytes32 s
679     ) external returns (uint amountETH);
680 
681     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
682         uint amountIn,
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external;
688     function swapExactETHForTokensSupportingFeeOnTransferTokens(
689         uint amountOutMin,
690         address[] calldata path,
691         address to,
692         uint deadline
693     ) external payable;
694     function swapExactTokensForETHSupportingFeeOnTransferTokens(
695         uint amountIn,
696         uint amountOutMin,
697         address[] calldata path,
698         address to,
699         uint deadline
700     ) external;
701 }
702 
703 interface IAirdrop {
704     function airdrop(address recipient, uint256 amount) external;
705 }
706 
707 contract Shibnobi is Context, IERC20, Ownable {
708     using SafeMath for uint256;
709     using Address for address;
710 
711     mapping (address => uint256) private _rOwned;
712     mapping (address => uint256) private _tOwned;
713     mapping (address => mapping (address => uint256)) private _allowances;
714 
715     mapping (address => bool) private _isExcludedFromFee;
716 
717     mapping (address => bool) private _isExcluded;
718     address[] private _excluded;
719     
720     mapping (address => bool) private botWallets;
721     bool botscantrade = false;
722     
723     bool public canTrade = false;
724    
725     uint256 private constant MAX = ~uint256(0);
726     uint256 private _tTotal = 69000000000000000000000 * 10**9;
727     uint256 private _rTotal = (MAX - (MAX % _tTotal));
728     uint256 private _tFeeTotal;
729     address public marketingWallet;
730 
731     string private _name = "Shibnobi";
732     string private _symbol = "SHINJA";
733     uint8 private _decimals = 9;
734     
735     uint256 public _taxFee = 5;
736     uint256 private _previousTaxFee = _taxFee;
737 
738     uint256 public marketingFeePercent = 38;
739     
740     uint256 public _liquidityFee = 8;
741     uint256 private _previousLiquidityFee = _liquidityFee;
742 
743     IUniswapV2Router02 public immutable uniswapV2Router;
744     address public immutable uniswapV2Pair;
745     
746     bool inSwapAndLiquify;
747     bool public swapAndLiquifyEnabled = true;
748     
749     uint256 public _maxTxAmount = 690000000000000000000 * 10**9;
750     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
751     
752     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
753     event SwapAndLiquifyEnabledUpdated(bool enabled);
754     event SwapAndLiquify(
755         uint256 tokensSwapped,
756         uint256 ethReceived,
757         uint256 tokensIntoLiqudity
758     );
759     
760     modifier lockTheSwap {
761         inSwapAndLiquify = true;
762         _;
763         inSwapAndLiquify = false;
764     }
765     
766     constructor () {
767         _rOwned[_msgSender()] = _rTotal;
768         
769         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Mainnet BSC
770         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //Testnet BSC
771         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
772          // Create a uniswap pair for this new token
773         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
774             .createPair(address(this), _uniswapV2Router.WETH());
775 
776         // set the rest of the contract variables
777         uniswapV2Router = _uniswapV2Router;
778         
779         //exclude owner and this contract from fee
780         _isExcludedFromFee[owner()] = true;
781         _isExcludedFromFee[address(this)] = true;
782         
783         emit Transfer(address(0), _msgSender(), _tTotal);
784     }
785 
786     function name() public view returns (string memory) {
787         return _name;
788     }
789 
790     function symbol() public view returns (string memory) {
791         return _symbol;
792     }
793 
794     function decimals() public view returns (uint8) {
795         return _decimals;
796     }
797 
798     function totalSupply() public view override returns (uint256) {
799         return _tTotal;
800     }
801 
802     function balanceOf(address account) public view override returns (uint256) {
803         if (_isExcluded[account]) return _tOwned[account];
804         return tokenFromReflection(_rOwned[account]);
805     }
806 
807     function transfer(address recipient, uint256 amount) public override returns (bool) {
808         _transfer(_msgSender(), recipient, amount);
809         return true;
810     }
811 
812     function allowance(address owner, address spender) public view override returns (uint256) {
813         return _allowances[owner][spender];
814     }
815 
816     function approve(address spender, uint256 amount) public override returns (bool) {
817         _approve(_msgSender(), spender, amount);
818         return true;
819     }
820 
821     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
822         _transfer(sender, recipient, amount);
823         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
824         return true;
825     }
826 
827     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
828         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
829         return true;
830     }
831 
832     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
833         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
834         return true;
835     }
836 
837     function isExcludedFromReward(address account) public view returns (bool) {
838         return _isExcluded[account];
839     }
840 
841     function totalFees() public view returns (uint256) {
842         return _tFeeTotal;
843     }
844     
845     function airdrop(address recipient, uint256 amount) external onlyOwner() {
846         removeAllFee();
847         _transfer(_msgSender(), recipient, amount * 10**9);
848         restoreAllFee();
849     }
850     
851     function airdropInternal(address recipient, uint256 amount) internal {
852         removeAllFee();
853         _transfer(_msgSender(), recipient, amount);
854         restoreAllFee();
855     }
856     
857     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
858         uint256 iterator = 0;
859         require(newholders.length == amounts.length, "must be the same length");
860         while(iterator < newholders.length){
861             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
862             iterator += 1;
863         }
864     }
865 
866     function deliver(uint256 tAmount) public {
867         address sender = _msgSender();
868         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
869         (uint256 rAmount,,,,,) = _getValues(tAmount);
870         _rOwned[sender] = _rOwned[sender].sub(rAmount);
871         _rTotal = _rTotal.sub(rAmount);
872         _tFeeTotal = _tFeeTotal.add(tAmount);
873     }
874 
875     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
876         require(tAmount <= _tTotal, "Amount must be less than supply");
877         if (!deductTransferFee) {
878             (uint256 rAmount,,,,,) = _getValues(tAmount);
879             return rAmount;
880         } else {
881             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
882             return rTransferAmount;
883         }
884     }
885 
886     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
887         require(rAmount <= _rTotal, "Amount must be less than total reflections");
888         uint256 currentRate =  _getRate();
889         return rAmount.div(currentRate);
890     }
891 
892     function excludeFromReward(address account) public onlyOwner() {
893         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
894         require(!_isExcluded[account], "Account is already excluded");
895         if(_rOwned[account] > 0) {
896             _tOwned[account] = tokenFromReflection(_rOwned[account]);
897         }
898         _isExcluded[account] = true;
899         _excluded.push(account);
900     }
901 
902     function includeInReward(address account) external onlyOwner() {
903         require(_isExcluded[account], "Account is already excluded");
904         for (uint256 i = 0; i < _excluded.length; i++) {
905             if (_excluded[i] == account) {
906                 _excluded[i] = _excluded[_excluded.length - 1];
907                 _tOwned[account] = 0;
908                 _isExcluded[account] = false;
909                 _excluded.pop();
910                 break;
911             }
912         }
913     }
914         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
915         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
916         _tOwned[sender] = _tOwned[sender].sub(tAmount);
917         _rOwned[sender] = _rOwned[sender].sub(rAmount);
918         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
919         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
920         _takeLiquidity(tLiquidity);
921         _reflectFee(rFee, tFee);
922         emit Transfer(sender, recipient, tTransferAmount);
923     }
924     
925     function excludeFromFee(address account) public onlyOwner {
926         _isExcludedFromFee[account] = true;
927     }
928     
929     function includeInFee(address account) public onlyOwner {
930         _isExcludedFromFee[account] = false;
931     }
932     function setMarketingFeePercent(uint256 fee) public onlyOwner {
933         require(fee < 50, "Marketing fee cannot be more than 50% of liquidity");
934         marketingFeePercent = fee;
935     }
936 
937     function setMarketingWallet(address walletAddress) public onlyOwner {
938         marketingWallet = walletAddress;
939     }
940     
941     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
942         require(taxFee < 10, "Tax fee cannot be more than 10%");
943         _taxFee = taxFee;
944     }
945     
946     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
947         _liquidityFee = liquidityFee;
948     }
949    
950     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
951         require(maxTxAmount > 69000000, "Max Tx Amount cannot be less than 69 Million");
952         _maxTxAmount = maxTxAmount * 10**9;
953     }
954     
955     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
956         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
957         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
958     }
959     
960     function claimTokens () public onlyOwner {
961         // make sure we capture all BNB that may or may not be sent to this contract
962         payable(marketingWallet).transfer(address(this).balance);
963     }
964     
965     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
966         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
967     }
968     
969     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
970         walletaddress.transfer(address(this).balance);
971     }
972     
973     function addBotWallet(address botwallet) external onlyOwner() {
974         botWallets[botwallet] = true;
975     }
976     
977     function removeBotWallet(address botwallet) external onlyOwner() {
978         botWallets[botwallet] = false;
979     }
980     
981     function getBotWalletStatus(address botwallet) public view returns (bool) {
982         return botWallets[botwallet];
983     }
984     
985     function allowtrading()external onlyOwner() {
986         canTrade = true;
987     }
988 
989     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
990         swapAndLiquifyEnabled = _enabled;
991         emit SwapAndLiquifyEnabledUpdated(_enabled);
992     }
993     
994      //to recieve ETH from uniswapV2Router when swaping
995     receive() external payable {}
996 
997     function _reflectFee(uint256 rFee, uint256 tFee) private {
998         _rTotal = _rTotal.sub(rFee);
999         _tFeeTotal = _tFeeTotal.add(tFee);
1000     }
1001 
1002     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1003         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1004         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1005         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1006     }
1007 
1008     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1009         uint256 tFee = calculateTaxFee(tAmount);
1010         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1011         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1012         return (tTransferAmount, tFee, tLiquidity);
1013     }
1014 
1015     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1016         uint256 rAmount = tAmount.mul(currentRate);
1017         uint256 rFee = tFee.mul(currentRate);
1018         uint256 rLiquidity = tLiquidity.mul(currentRate);
1019         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1020         return (rAmount, rTransferAmount, rFee);
1021     }
1022 
1023     function _getRate() private view returns(uint256) {
1024         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1025         return rSupply.div(tSupply);
1026     }
1027 
1028     function _getCurrentSupply() private view returns(uint256, uint256) {
1029         uint256 rSupply = _rTotal;
1030         uint256 tSupply = _tTotal;      
1031         for (uint256 i = 0; i < _excluded.length; i++) {
1032             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1033             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1034             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1035         }
1036         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1037         return (rSupply, tSupply);
1038     }
1039     
1040     function _takeLiquidity(uint256 tLiquidity) private {
1041         uint256 currentRate =  _getRate();
1042         uint256 rLiquidity = tLiquidity.mul(currentRate);
1043         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1044         if(_isExcluded[address(this)])
1045             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1046     }
1047     
1048     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1049         return _amount.mul(_taxFee).div(
1050             10**2
1051         );
1052     }
1053 
1054     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1055         return _amount.mul(_liquidityFee).div(
1056             10**2
1057         );
1058     }
1059     
1060     function removeAllFee() private {
1061         if(_taxFee == 0 && _liquidityFee == 0) return;
1062         
1063         _previousTaxFee = _taxFee;
1064         _previousLiquidityFee = _liquidityFee;
1065         
1066         _taxFee = 0;
1067         _liquidityFee = 0;
1068     }
1069     
1070     function restoreAllFee() private {
1071         _taxFee = _previousTaxFee;
1072         _liquidityFee = _previousLiquidityFee;
1073     }
1074     
1075     function isExcludedFromFee(address account) public view returns(bool) {
1076         return _isExcludedFromFee[account];
1077     }
1078 
1079     function _approve(address owner, address spender, uint256 amount) private {
1080         require(owner != address(0), "ERC20: approve from the zero address");
1081         require(spender != address(0), "ERC20: approve to the zero address");
1082 
1083         _allowances[owner][spender] = amount;
1084         emit Approval(owner, spender, amount);
1085     }
1086 
1087     function _transfer(
1088         address from,
1089         address to,
1090         uint256 amount
1091     ) private {
1092         require(from != address(0), "ERC20: transfer from the zero address");
1093         require(to != address(0), "ERC20: transfer to the zero address");
1094         require(amount > 0, "Transfer amount must be greater than zero");
1095         if(from != owner() && to != owner())
1096             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1097 
1098         // is the token balance of this contract address over the min number of
1099         // tokens that we need to initiate a swap + liquidity lock?
1100         // also, don't get caught in a circular liquidity event.
1101         // also, don't swap & liquify if sender is uniswap pair.
1102         uint256 contractTokenBalance = balanceOf(address(this));
1103         
1104         if(contractTokenBalance >= _maxTxAmount)
1105         {
1106             contractTokenBalance = _maxTxAmount;
1107         }
1108         
1109         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1110         if (
1111             overMinTokenBalance &&
1112             !inSwapAndLiquify &&
1113             from != uniswapV2Pair &&
1114             swapAndLiquifyEnabled
1115         ) {
1116             contractTokenBalance = numTokensSellToAddToLiquidity;
1117             //add liquidity
1118             swapAndLiquify(contractTokenBalance);
1119         }
1120         
1121         //indicates if fee should be deducted from transfer
1122         bool takeFee = true;
1123         
1124         //if any account belongs to _isExcludedFromFee account then remove the fee
1125         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1126             takeFee = false;
1127         }
1128         
1129         //transfer amount, it will take tax, burn, liquidity fee
1130         _tokenTransfer(from,to,amount,takeFee);
1131     }
1132 
1133     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1134         // split the contract balance into halves
1135         // add the marketing wallet
1136         uint256 half = contractTokenBalance.div(2);
1137         uint256 otherHalf = contractTokenBalance.sub(half);
1138 
1139         // capture the contract's current ETH balance.
1140         // this is so that we can capture exactly the amount of ETH that the
1141         // swap creates, and not make the liquidity event include any ETH that
1142         // has been manually sent to the contract
1143         uint256 initialBalance = address(this).balance;
1144 
1145         // swap tokens for ETH
1146         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1147 
1148         // how much ETH did we just swap into?
1149         uint256 newBalance = address(this).balance.sub(initialBalance);
1150         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1151         payable(marketingWallet).transfer(marketingshare);
1152         newBalance -= marketingshare;
1153         // add liquidity to uniswap
1154         addLiquidity(otherHalf, newBalance);
1155         
1156         emit SwapAndLiquify(half, newBalance, otherHalf);
1157     }
1158 
1159     function swapTokensForEth(uint256 tokenAmount) private {
1160         // generate the uniswap pair path of token -> weth
1161         address[] memory path = new address[](2);
1162         path[0] = address(this);
1163         path[1] = uniswapV2Router.WETH();
1164 
1165         _approve(address(this), address(uniswapV2Router), tokenAmount);
1166 
1167         // make the swap
1168         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1169             tokenAmount,
1170             0, // accept any amount of ETH
1171             path,
1172             address(this),
1173             block.timestamp
1174         );
1175     }
1176 
1177     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1178         // approve token transfer to cover all possible scenarios
1179         _approve(address(this), address(uniswapV2Router), tokenAmount);
1180 
1181         // add the liquidity
1182         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1183             address(this),
1184             tokenAmount,
1185             0, // slippage is unavoidable
1186             0, // slippage is unavoidable
1187             owner(),
1188             block.timestamp
1189         );
1190     }
1191 
1192     //this method is responsible for taking all fee, if takeFee is true
1193     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1194         if(!canTrade){
1195             require(sender == owner()); // only owner allowed to trade or add liquidity
1196         }
1197         
1198         if(botWallets[sender] || botWallets[recipient]){
1199             require(botscantrade, "bots arent allowed to trade");
1200         }
1201         
1202         if(!takeFee)
1203             removeAllFee();
1204         
1205         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1206             _transferFromExcluded(sender, recipient, amount);
1207         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1208             _transferToExcluded(sender, recipient, amount);
1209         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1210             _transferStandard(sender, recipient, amount);
1211         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1212             _transferBothExcluded(sender, recipient, amount);
1213         } else {
1214             _transferStandard(sender, recipient, amount);
1215         }
1216         
1217         if(!takeFee)
1218             restoreAllFee();
1219     }
1220 
1221     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1222         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1223         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1224         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1225         _takeLiquidity(tLiquidity);
1226         _reflectFee(rFee, tFee);
1227         emit Transfer(sender, recipient, tTransferAmount);
1228     }
1229 
1230     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1231         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1232         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1233         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1234         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1235         _takeLiquidity(tLiquidity);
1236         _reflectFee(rFee, tFee);
1237         emit Transfer(sender, recipient, tTransferAmount);
1238     }
1239 
1240     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1241         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1242         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1243         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1244         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1245         _takeLiquidity(tLiquidity);
1246         _reflectFee(rFee, tFee);
1247         emit Transfer(sender, recipient, tTransferAmount);
1248     }
1249 
1250 }