1 // SPDX-License-Identifier: MIT
2 
3 // literally digital hot air
4 // nothing.gg
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 /**
9  * @title ERC721 token receiver interface
10  * @dev Interface for any contract that wants to support safeTransfers
11  * from ERC721 asset contracts.
12  */
13 interface IERC721Receiver {
14     /**
15      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
16      * by `operator` from `from`, this function is called.
17      *
18      * It must return its Solidity selector to confirm the token transfer.
19      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
20      *
21      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
22      */
23     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
24 }
25 
26 
27   /**
28    * @dev Implementation of the {IERC721Receiver} interface.
29    *
30    * Accepts all token transfers.
31    * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
32    */
33 contract ERC721Holder is IERC721Receiver {
34 
35     /**
36      * @dev See {IERC721Receiver-onERC721Received}.
37      *
38      * Always returns `IERC721Receiver.onERC721Received.selector`.
39      */
40     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
41         return this.onERC721Received.selector;
42     }
43 }
44 
45 pragma solidity ^0.6.12;
46 interface IERC20 {
47 
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130  
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b > 0, errorMessage);
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273 
274 abstract contract Context {
275     function _msgSender() internal view virtual returns (address payable) {
276         return msg.sender;
277     }
278 
279     function _msgData() internal view virtual returns (bytes memory) {
280         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
281         return msg.data;
282     }
283 }
284 
285 
286 /**
287  * @dev Collection of functions related to the address type
288  */
289 library Address {
290     /**
291      * @dev Returns true if `account` is a contract.
292      *
293      * [IMPORTANT]
294      * ====
295      * It is unsafe to assume that an address for which this function returns
296      * false is an externally-owned account (EOA) and not a contract.
297      *
298      * Among others, `isContract` will return false for the following
299      * types of addresses:
300      *
301      *  - an externally-owned account
302      *  - a contract in construction
303      *  - an address where a contract will be created
304      *  - an address where a contract lived, but was destroyed
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
309         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
310         // for accounts without code, i.e. `keccak256('')`
311         bytes32 codehash;
312         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
313         // solhint-disable-next-line no-inline-assembly
314         assembly { codehash := extcodehash(account) }
315         return (codehash != accountHash && codehash != 0x0);
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
338         (bool success, ) = recipient.call{ value: amount }("");
339         require(success, "Address: unable to send value, recipient may have reverted");
340     }
341 
342     /**
343      * @dev Performs a Solidity function call using a low level `call`. A
344      * plain`call` is an unsafe replacement for a function call: use this
345      * function instead.
346      *
347      * If `target` reverts with a revert reason, it is bubbled up by this
348      * function (like regular Solidity function calls).
349      *
350      * Returns the raw returned data. To convert to the expected return value,
351      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
352      *
353      * Requirements:
354      *
355      * - `target` must be a contract.
356      * - calling `target` with `data` must not revert.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
361       return functionCall(target, data, "Address: low-level call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
366      * `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
371         return _functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
391      * with `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         return _functionCallWithValue(target, data, value, errorMessage);
398     }
399 
400     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
401         require(isContract(target), "Address: call to non-contract");
402 
403         // solhint-disable-next-line avoid-low-level-calls
404         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
405         if (success) {
406             return returndata;
407         } else {
408             // Look for revert reason and bubble it up if present
409             if (returndata.length > 0) {
410                 // The easiest way to bubble the revert reason is using memory via assembly
411 
412                 // solhint-disable-next-line no-inline-assembly
413                 assembly {
414                     let returndata_size := mload(returndata)
415                     revert(add(32, returndata), returndata_size)
416                 }
417             } else {
418                 revert(errorMessage);
419             }
420         }
421     }
422 }
423 
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * By default, the owner account will be the one that deploys the contract. This
430  * can later be changed with {transferOwnership}.
431  *
432  * This module is used through inheritance. It will make available the modifier
433  * `onlyOwner`, which can be applied to your functions to restrict their use to
434  * the owner.
435  */
436 contract Ownable is Context {
437     address private _owner;
438     address private _previousOwner;
439     uint256 private _lockTime;
440 
441     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
442 
443     /**
444      * @dev Initializes the contract setting the deployer as the initial owner.
445      */
446     constructor () internal {
447         address msgSender = _msgSender();
448         _owner = msgSender;
449         emit OwnershipTransferred(address(0), msgSender);
450     }
451 
452     /**
453      * @dev Returns the address of the current owner.
454      */
455     function owner() public view returns (address) {
456         return _owner;
457     }
458 
459     /**
460      * @dev Throws if called by any account other than the owner.
461      */
462     modifier onlyOwner() {
463         require(_owner == _msgSender(), "Ownable: caller is not the owner");
464         _;
465     }
466 
467      /**
468      * @dev Leaves the contract without owner. It will not be possible to call
469      * `onlyOwner` functions anymore. Can only be called by the current owner.
470      *
471      * NOTE: Renouncing ownership will leave the contract without an owner,
472      * thereby removing any functionality that is only available to the owner.
473      */
474     function renounceOwnership() public virtual onlyOwner {
475         emit OwnershipTransferred(_owner, address(0));
476         _owner = address(0);
477     }
478 
479     /**
480      * @dev Transfers ownership of the contract to a new account (`newOwner`).
481      * Can only be called by the current owner.
482      */
483     function transferOwnership(address newOwner) public virtual onlyOwner {
484         require(newOwner != address(0), "Ownable: new owner is the zero address");
485         emit OwnershipTransferred(_owner, newOwner);
486         _owner = newOwner;
487     }
488 
489     function geUnlockTime() public view returns (uint256) {
490         return _lockTime;
491     }
492 
493     //Locks the contract for owner for the amount of time provided
494     function lock(uint256 time) public virtual onlyOwner {
495         _previousOwner = _owner;
496         _owner = address(0);
497         _lockTime = now + time;
498         emit OwnershipTransferred(_owner, address(0));
499     }
500     
501     //Unlocks the contract for owner when _lockTime is exceeds
502     function unlock() public virtual {
503         require(_previousOwner == msg.sender, "You don't have permission to unlock");
504         require(now > _lockTime , "Contract is locked until 7 days");
505         emit OwnershipTransferred(_owner, _previousOwner);
506         _owner = _previousOwner;
507     }
508 }
509 
510 // pragma solidity >=0.5.0;
511 
512 interface IUniswapV2Factory {
513     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
514 
515     function feeTo() external view returns (address);
516     function feeToSetter() external view returns (address);
517 
518     function getPair(address tokenA, address tokenB) external view returns (address pair);
519     function allPairs(uint) external view returns (address pair);
520     function allPairsLength() external view returns (uint);
521 
522     function createPair(address tokenA, address tokenB) external returns (address pair);
523 
524     function setFeeTo(address) external;
525     function setFeeToSetter(address) external;
526     function WETH() external pure returns (address); 
527 }
528 
529 
530 // pragma solidity >=0.5.0;
531 
532 interface IUniswapV2Pair {
533     event Approval(address indexed owner, address indexed spender, uint value);
534     event Transfer(address indexed from, address indexed to, uint value);
535 
536     function name() external pure returns (string memory);
537     function symbol() external pure returns (string memory);
538     function decimals() external pure returns (uint8);
539     function totalSupply() external view returns (uint);
540     function balanceOf(address owner) external view returns (uint);
541     function allowance(address owner, address spender) external view returns (uint);
542 
543     function approve(address spender, uint value) external returns (bool);
544     function transfer(address to, uint value) external returns (bool);
545     function transferFrom(address from, address to, uint value) external returns (bool);
546 
547     function DOMAIN_SEPARATOR() external view returns (bytes32);
548     function PERMIT_TYPEHASH() external pure returns (bytes32);
549     function nonces(address owner) external view returns (uint);
550 
551     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
552 
553     event Mint(address indexed sender, uint amount0, uint amount1);
554     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
555     event Swap(
556         address indexed sender,
557         uint amount0In,
558         uint amount1In,
559         uint amount0Out,
560         uint amount1Out,
561         address indexed to
562     );
563     event Sync(uint112 reserve0, uint112 reserve1);
564 
565     function MINIMUM_LIQUIDITY() external pure returns (uint);
566     function factory() external view returns (address);
567     function token0() external view returns (address);
568     function token1() external view returns (address);
569     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
570     function price0CumulativeLast() external view returns (uint);
571     function price1CumulativeLast() external view returns (uint);
572     function kLast() external view returns (uint);
573 
574     function mint(address to) external returns (uint liquidity);
575     function burn(address to) external returns (uint amount0, uint amount1);
576     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
577     function skim(address to) external;
578     function sync() external;
579 
580     function initialize(address, address) external;
581 }
582 
583 // pragma solidity >=0.6.2;
584 
585 interface IUniswapV2Router01 {
586     function factory() external pure returns (address);
587     function WETH() external pure returns (address);
588 
589     function addLiquidity(
590         address tokenA,
591         address tokenB,
592         uint amountADesired,
593         uint amountBDesired,
594         uint amountAMin,
595         uint amountBMin,
596         address to,
597         uint deadline
598     ) external returns (uint amountA, uint amountB, uint liquidity);
599     function addLiquidityETH(
600         address token,
601         uint amountTokenDesired,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline
606     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
607     function removeLiquidity(
608         address tokenA,
609         address tokenB,
610         uint liquidity,
611         uint amountAMin,
612         uint amountBMin,
613         address to,
614         uint deadline
615     ) external returns (uint amountA, uint amountB);
616     function removeLiquidityETH(
617         address token,
618         uint liquidity,
619         uint amountTokenMin,
620         uint amountETHMin,
621         address to,
622         uint deadline
623     ) external returns (uint amountToken, uint amountETH);
624     function removeLiquidityWithPermit(
625         address tokenA,
626         address tokenB,
627         uint liquidity,
628         uint amountAMin,
629         uint amountBMin,
630         address to,
631         uint deadline,
632         bool approveMax, uint8 v, bytes32 r, bytes32 s
633     ) external returns (uint amountA, uint amountB);
634     function removeLiquidityETHWithPermit(
635         address token,
636         uint liquidity,
637         uint amountTokenMin,
638         uint amountETHMin,
639         address to,
640         uint deadline,
641         bool approveMax, uint8 v, bytes32 r, bytes32 s
642     ) external returns (uint amountToken, uint amountETH);
643     function swapExactTokensForTokens(
644         uint amountIn,
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external returns (uint[] memory amounts);
650     function swapTokensForExactTokens(
651         uint amountOut,
652         uint amountInMax,
653         address[] calldata path,
654         address to,
655         uint deadline
656     ) external returns (uint[] memory amounts);
657     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
658         external
659         payable
660         returns (uint[] memory amounts);
661     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
662         external
663         returns (uint[] memory amounts);
664     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
665         external
666         returns (uint[] memory amounts);
667     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
668         external
669         payable
670         returns (uint[] memory amounts);
671 
672     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
673     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
674     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
675     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
676     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
677 }
678 
679 
680 
681 // pragma solidity >=0.6.2;
682 
683 interface IUniswapV2Router02 is IUniswapV2Router01 {
684     function removeLiquidityETHSupportingFeeOnTransferTokens(
685         address token,
686         uint liquidity,
687         uint amountTokenMin,
688         uint amountETHMin,
689         address to,
690         uint deadline
691     ) external returns (uint amountETH);
692     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
693         address token,
694         uint liquidity,
695         uint amountTokenMin,
696         uint amountETHMin,
697         address to,
698         uint deadline,
699         bool approveMax, uint8 v, bytes32 r, bytes32 s
700     ) external returns (uint amountETH);
701 
702     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
703         uint amountIn,
704         uint amountOutMin,
705         address[] calldata path,
706         address to,
707         uint deadline
708     ) external;
709     function swapExactETHForTokensSupportingFeeOnTransferTokens(
710         uint amountOutMin,
711         address[] calldata path,
712         address to,
713         uint deadline
714     ) external payable;
715     function swapExactTokensForETHSupportingFeeOnTransferTokens(
716         uint amountIn,
717         uint amountOutMin,
718         address[] calldata path,
719         address to,
720         uint deadline
721     ) external;
722 }
723 
724 
725 contract NOTHING is Context, IERC20, Ownable, ERC721Holder {
726     using SafeMath for uint256;
727     using Address for address;
728 
729     mapping (address => uint256) private _rOwned;
730     mapping (address => uint256) private _tOwned;
731     mapping (address => mapping (address => uint256)) private _allowances;
732 
733     mapping (address => bool) private _isExcludedFromFee;
734 
735     mapping (address => bool) private _isExcluded;
736     address[] private _excluded;
737    
738     uint256 private constant MAX = ~uint256(0);
739     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
740     uint256 private _rTotal = (MAX - (MAX % _tTotal));
741     uint256 private _tFeeTotal;
742 
743     string private _name = "NOTHING";
744     string private _symbol = "NADA";
745     uint8 private _decimals = 9;
746     
747     uint256 public _taxFee = 0;
748     uint256 private _previousTaxFee = _taxFee;
749     
750     uint256 public _liquidityFee = 0;
751     uint256 private _previousLiquidityFee = _liquidityFee;
752 
753     uint256 public _buyFee = 10;
754     uint256 public _sellFee = 20;
755 
756     IUniswapV2Router02 public immutable uniswapV2Router;
757     address public immutable uniswapV2Pair;
758     
759     bool inSwapAndLiquify;
760     bool public swapAndLiquifyEnabled = true;
761     
762     uint256 public _maxTxAmount = 10000 * 10**6 * 10**9;
763     uint256 private numTokensSellToAddToLiquidity = 500 * 10**6 * 10**9;
764     uint256 public _maxAllocation = 10000 * 10**6 * 10**9;
765     address public lpReciever;
766     
767     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
768     event SwapAndLiquifyEnabledUpdated(bool enabled);
769     event SwapAndLiquify(
770         uint256 tokensSwapped,
771         uint256 ethReceived,
772         uint256 tokensIntoLiqudity
773     );
774     
775     modifier lockTheSwap {
776         inSwapAndLiquify = true;
777         _;
778         inSwapAndLiquify = false;
779     }
780 
781     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
782     address public UNISWAP_FACTORY_ADDRESS = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
783     
784     constructor () public {
785         _rOwned[_msgSender()] = _rTotal;
786         
787         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
788          // Create a uniswap pair for this new token
789         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
790             .createPair(address(this), _uniswapV2Router.WETH());
791 
792         // set the rest of the contract variables
793         uniswapV2Router = _uniswapV2Router;
794         
795         //exclude owner and this contract from fee
796         _isExcludedFromFee[owner()] = true;
797         _isExcludedFromFee[address(this)] = true;
798 
799         lpReciever = owner();
800         
801         emit Transfer(address(0), _msgSender(), _tTotal);
802     }
803 
804     function setRouter(address _router) external onlyOwner {
805         router = _router;
806     }
807 
808     function name() public view returns (string memory) {
809         return _name;
810     }
811 
812     function symbol() public view returns (string memory) {
813         return _symbol;
814     }
815 
816     function decimals() public view returns (uint8) {
817         return _decimals;
818     }
819 
820     function totalSupply() public view override returns (uint256) {
821         return _tTotal;
822     }
823 
824     function balanceOf(address account) public view override returns (uint256) {
825         if (_isExcluded[account]) return _tOwned[account];
826         return tokenFromReflection(_rOwned[account]);
827     }
828 
829     function transfer(address recipient, uint256 amount) public override returns (bool) {
830         _transfer(_msgSender(), recipient, amount);
831         return true;
832     }
833 
834     function allowance(address owner, address spender) public view override returns (uint256) {
835         return _allowances[owner][spender];
836     }
837 
838     function approve(address spender, uint256 amount) public override returns (bool) {
839         _approve(_msgSender(), spender, amount);
840         return true;
841     }
842 
843     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
844         _transfer(sender, recipient, amount);
845         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
846         return true;
847     }
848 
849     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
850         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
851         return true;
852     }
853 
854     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
855         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
856         return true;
857     }
858 
859     function isExcludedFromReward(address account) public view returns (bool) {
860         return _isExcluded[account];
861     }
862 
863     function totalFees() public view returns (uint256) {
864         return _tFeeTotal;
865     }
866 
867     function deliver(uint256 tAmount) public {
868         address sender = _msgSender();
869         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
870         (uint256 rAmount,,,,,) = _getValues(tAmount);
871         _rOwned[sender] = _rOwned[sender].sub(rAmount);
872         _rTotal = _rTotal.sub(rAmount);
873         _tFeeTotal = _tFeeTotal.add(tAmount);
874     }
875 
876     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
877         require(tAmount <= _tTotal, "Amount must be less than supply");
878         if (!deductTransferFee) {
879             (uint256 rAmount,,,,,) = _getValues(tAmount);
880             return rAmount;
881         } else {
882             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
883             return rTransferAmount;
884         }
885     }
886 
887     function setNumTokensSellToAddToLiquidity(uint256 _numTokensSellAddToLiquidity) external onlyOwner returns(uint256) {
888         numTokensSellToAddToLiquidity = _numTokensSellAddToLiquidity;
889         return numTokensSellToAddToLiquidity;
890     }
891 
892     function setLpReciever(address _lpReciever) external onlyOwner returns (address) {
893         lpReciever = _lpReciever;
894         return lpReciever;
895     }
896 
897     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
898         require(rAmount <= _rTotal, "Amount must be less than total reflections");
899         uint256 currentRate =  _getRate();
900         return rAmount.div(currentRate);
901     }
902 
903     function excludeFromReward(address account) public onlyOwner() {
904         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
905         require(!_isExcluded[account], "Account is already excluded");
906         if(_rOwned[account] > 0) {
907             _tOwned[account] = tokenFromReflection(_rOwned[account]);
908         }
909         _isExcluded[account] = true;
910         _excluded.push(account);
911     }
912 
913     function includeInReward(address account) external onlyOwner() {
914         require(_isExcluded[account], "Account is already excluded");
915         for (uint256 i = 0; i < _excluded.length; i++) {
916             if (_excluded[i] == account) {
917                 _excluded[i] = _excluded[_excluded.length - 1];
918                 _tOwned[account] = 0;
919                 _isExcluded[account] = false;
920                 _excluded.pop();
921                 break;
922             }
923         }
924     }
925     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
926         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
927         _tOwned[sender] = _tOwned[sender].sub(tAmount);
928         _rOwned[sender] = _rOwned[sender].sub(rAmount);
929         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
930         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
931         _takeLiquidity(tLiquidity);
932         _reflectFee(rFee, tFee);
933         emit Transfer(sender, recipient, tTransferAmount);
934     }
935     
936         function excludeFromFee(address account) public onlyOwner {
937         _isExcludedFromFee[account] = true;
938     }
939     
940     function includeInFee(address account) public onlyOwner {
941         _isExcludedFromFee[account] = false;
942     }
943     
944     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
945         _taxFee = taxFee;
946     }
947     
948     function setLiquidityFeePercent(uint256 liquidityFee) internal {
949         _liquidityFee = liquidityFee;
950     }
951 
952     function setBuyFeePercent(uint256 buyFee) external onlyOwner() {
953         _buyFee = buyFee;
954     }
955 
956     function setSellFeePercent(uint256 sellFee) external onlyOwner() {
957         _sellFee = sellFee;
958     }
959    
960     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
961         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
962             10**2
963         );
964     }
965 
966     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
967         swapAndLiquifyEnabled = _enabled;
968         emit SwapAndLiquifyEnabledUpdated(_enabled);
969     }
970     
971      //to recieve ETH from uniswapV2Router when swaping
972     receive() external payable {}
973 
974     function _reflectFee(uint256 rFee, uint256 tFee) private {
975         _rTotal = _rTotal.sub(rFee);
976         _tFeeTotal = _tFeeTotal.add(tFee);
977     }
978 
979     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
980         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
981         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
982         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
983     }
984 
985     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
986         uint256 tFee = calculateTaxFee(tAmount);
987         uint256 tLiquidity = calculateLiquidityFee(tAmount);
988         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
989         return (tTransferAmount, tFee, tLiquidity);
990     }
991 
992     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
993         uint256 rAmount = tAmount.mul(currentRate);
994         uint256 rFee = tFee.mul(currentRate);
995         uint256 rLiquidity = tLiquidity.mul(currentRate);
996         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
997         return (rAmount, rTransferAmount, rFee);
998     }
999 
1000     function _getRate() private view returns(uint256) {
1001         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1002         return rSupply.div(tSupply);
1003     }
1004 
1005     function _getCurrentSupply() private view returns(uint256, uint256) {
1006         uint256 rSupply = _rTotal;
1007         uint256 tSupply = _tTotal;      
1008         for (uint256 i = 0; i < _excluded.length; i++) {
1009             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1010             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1011             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1012         }
1013         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1014         return (rSupply, tSupply);
1015     }
1016     
1017     function _takeLiquidity(uint256 tLiquidity) private {
1018         uint256 currentRate =  _getRate();
1019         uint256 rLiquidity = tLiquidity.mul(currentRate);
1020         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1021         if(_isExcluded[address(this)])
1022             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1023     }
1024     
1025     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1026         return _amount.mul(_taxFee).div(
1027             10**2
1028         );
1029     }
1030 
1031     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1032         return _amount.mul(_liquidityFee).div(
1033             10**2
1034         );
1035     }
1036     
1037     function removeAllFee() private {
1038         if(_taxFee == 0 && _liquidityFee == 0) return;
1039         
1040         _previousTaxFee = _taxFee;
1041         _previousLiquidityFee = _liquidityFee;
1042         
1043         _taxFee = 0;
1044         _liquidityFee = 0;
1045     }
1046     
1047     function restoreAllFee() private {
1048         _taxFee = _previousTaxFee;
1049         _liquidityFee = _previousLiquidityFee;
1050     }
1051     
1052     function isExcludedFromFee(address account) public view returns(bool) {
1053         return _isExcludedFromFee[account];
1054     }
1055 
1056     function _approve(address owner, address spender, uint256 amount) private {
1057         require(owner != address(0), "ERC20: approve from the zero address");
1058         require(spender != address(0), "ERC20: approve to the zero address");
1059 
1060         _allowances[owner][spender] = amount;
1061         emit Approval(owner, spender, amount);
1062     }
1063 
1064     function _transfer(
1065         address from,
1066         address to,
1067         uint256 amount
1068     ) private {
1069         require(from != address(0), "ERC20: transfer from the zero address");
1070         require(to != address(0), "ERC20: transfer to the zero address");
1071         require(amount > 0, "Transfer amount must be greater than zero");
1072         if(from != owner() && to != owner())
1073             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1074         
1075         if(from != owner() && to != owner())
1076             require(balanceOf(to) + amount <= _maxAllocation, "Recipient exceeds maxAllocation");
1077 
1078         // is the token balance of this contract address over the min number of
1079         // tokens that we need to initiate a swap + liquidity lock?
1080         // also, don't get caught in a circular liquidity event.
1081         // also, don't swap & liquify if sender is uniswap pair.
1082         uint256 contractTokenBalance = balanceOf(address(this));
1083         
1084         if(contractTokenBalance >= _maxTxAmount)
1085         {
1086             contractTokenBalance = _maxTxAmount;
1087         }
1088         
1089         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1090         if (
1091             overMinTokenBalance &&
1092             !inSwapAndLiquify &&
1093             from != uniswapV2Pair &&
1094             swapAndLiquifyEnabled
1095         ) {
1096             contractTokenBalance = numTokensSellToAddToLiquidity;
1097             //add liquidity
1098             swapAndLiquify(contractTokenBalance);
1099         }
1100         
1101         bool takeFee = false;
1102 
1103         //indicates if fee should be deducted from transfer
1104         if (isSell(from, to)) {
1105             takeFee = true;
1106             setLiquidityFeePercent(_sellFee);
1107         }
1108 
1109         if (isBuy(from, to)) {
1110             takeFee = true;
1111             setLiquidityFeePercent(_buyFee);
1112         }
1113         
1114         // //if any account belongs to _isExcludedFromFee account then remove the fee
1115         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1116             takeFee = false;
1117         }
1118         
1119         //transfer amount, it will take tax, burn, liquidity fee
1120         _tokenTransfer(from,to,amount,takeFee);
1121     }
1122 
1123     function setMaxAllocation(uint256 maxAllocation) external onlyOwner {
1124         _maxAllocation = maxAllocation;
1125     }
1126 
1127     function isBuy(address sender, address recipient) internal view returns (bool) {
1128         return (sender == uniswapV2Pair && recipient != router);
1129     }
1130 
1131     function isSell(address sender, address recipient) internal view returns (bool) {
1132         return (recipient == uniswapV2Pair && sender != router);
1133     }
1134 
1135     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1136         // split the contract balance into halves
1137         uint256 half = contractTokenBalance.div(2);
1138         uint256 otherHalf = contractTokenBalance.sub(half);
1139 
1140         // capture the contract's current ETH balance.
1141         // this is so that we can capture exactly the amount of ETH that the
1142         // swap creates, and not make the liquidity event include any ETH that
1143         // has been manually sent to the contract
1144         uint256 initialBalance = address(this).balance;
1145 
1146         // swap tokens for ETH
1147         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1148 
1149         // how much ETH did we just swap into?
1150         uint256 newBalance = address(this).balance.sub(initialBalance);
1151 
1152         // add liquidity to uniswap
1153         addLiquidity(otherHalf, newBalance);
1154         
1155         emit SwapAndLiquify(half, newBalance, otherHalf);
1156     }
1157 
1158     function swapTokensForEth(uint256 tokenAmount) private {
1159         // generate the uniswap pair path of token -> weth
1160         address[] memory path = new address[](2);
1161         path[0] = address(this);
1162         path[1] = uniswapV2Router.WETH();
1163 
1164         _approve(address(this), address(uniswapV2Router), tokenAmount);
1165 
1166         // make the swap
1167         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1168             tokenAmount,
1169             0, // accept any amount of ETH
1170             path,
1171             address(this),
1172             block.timestamp
1173         );
1174     }
1175 
1176     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1177         // approve token transfer to cover all possible scenarios
1178         _approve(address(this), address(uniswapV2Router), tokenAmount);
1179 
1180         // add the liquidity
1181         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1182             address(this),
1183             tokenAmount,
1184             0, // slippage is unavoidable
1185             0, // slippage is unavoidable
1186             lpReciever,
1187             block.timestamp
1188         );
1189     }
1190 
1191     //this method is responsible for taking all fee, if takeFee is true
1192     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1193         if(!takeFee)
1194             removeAllFee();
1195         
1196         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1197             _transferFromExcluded(sender, recipient, amount);
1198         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1199             _transferToExcluded(sender, recipient, amount);
1200         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1201             _transferStandard(sender, recipient, amount);
1202         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1203             _transferBothExcluded(sender, recipient, amount);
1204         } else {
1205             _transferStandard(sender, recipient, amount);
1206         }
1207         
1208         if(!takeFee)
1209             restoreAllFee();
1210     }
1211 
1212     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1213         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1214         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1215         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1216         _takeLiquidity(tLiquidity);
1217         _reflectFee(rFee, tFee);
1218         emit Transfer(sender, recipient, tTransferAmount);
1219     }
1220 
1221     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1222         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1223         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1224         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1225         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1226         _takeLiquidity(tLiquidity);
1227         _reflectFee(rFee, tFee);
1228         emit Transfer(sender, recipient, tTransferAmount);
1229     }
1230 
1231     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1232         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1233         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1234         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1235         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1236         _takeLiquidity(tLiquidity);
1237         _reflectFee(rFee, tFee);
1238         emit Transfer(sender, recipient, tTransferAmount);
1239     }
1240 
1241 
1242     
1243 
1244 }