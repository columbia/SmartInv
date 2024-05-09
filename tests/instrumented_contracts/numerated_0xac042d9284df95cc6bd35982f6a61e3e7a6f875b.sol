1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-21
3 */
4 
5 /**
6  *
7  *
8  *
9  *░█████░         ░█████████      ░████████       ░████████      ░████   █████    
10  * ░███░         ░███░░░░░███     ░███    ░██     ░███    ░██     ░███   ░███  
11  * ░███░         ░███    ░███     ░███    ░███    ░███    ░███    ░███   ░███    
12  * ░███░         ░███    ░███     ░███    ░██     ░███    ░██      ░███ ░███   
13  * ░███░         ░███    ░███     ░█████████      ░█████████       ░███████  
14  * ░███░         ░███    ░███     ░███    ░██     ░███    ░██        ░███    
15  * ░███░         ░███    ░███     ░███    ░███    ░███    ░███       ░███    
16  * ░███░         ░███    ░███     ░███    ░██     ░███    ░██        ░███    
17  *░███████████    ░█████████      ░████████       ░████████        ░███████   
18  *░░░░░░░░░░░     ░░░░░░░░░       ░░░░░░░░        ░░░░░░░░         ░░░░░░░                                               
19  *                                                                           
20 */                                                              
21 
22 // LOBBY ETH
23 // Version: 20211121001
24 
25 pragma solidity ^0.8.9;
26 // SPDX-License-Identifier: Unlicensed
27 interface IERC20 {
28 
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations with added overflow
100  * checks.
101  *
102  * Arithmetic operations in Solidity wrap on overflow. This can easily result
103  * in bugs, because programmers usually assume that an overflow raises an
104  * error, which is the standard behavior in high level programming languages.
105  * `SafeMath` restores this intuition by reverting the transaction when an
106  * operation overflows.
107  *
108  * Using this library instead of the unchecked operations eliminates an entire
109  * class of bugs, so it's recommended to use it always.
110  */
111  
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `+` operator.
118      *
119      * Requirements:
120      *
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      *
169      * - Multiplication cannot overflow.
170      */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts with custom message when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 abstract contract Context {
256     //function _msgSender() internal view virtual returns (address payable) {
257     function _msgSender() internal view virtual returns (address) {
258         return msg.sender;
259     }
260 
261     function _msgData() internal view virtual returns (bytes memory) {
262         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
263         return msg.data;
264     }
265 }
266 
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly { codehash := extcodehash(account) }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
320         (bool success, ) = recipient.call{ value: amount }("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain`call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343       return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
353         return _functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         return _functionCallWithValue(target, data, value, errorMessage);
380     }
381 
382     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
383         require(isContract(target), "Address: call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 // solhint-disable-next-line no-inline-assembly
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 /**
407  * @dev Contract module which provides a basic access control mechanism, where
408  * there is an account (an owner) that can be granted exclusive access to
409  * specific functions.
410  *
411  * By default, the owner account will be the one that deploys the contract. This
412  * can later be changed with {transferOwnership}.
413  *
414  * This module is used through inheritance. It will make available the modifier
415  * `onlyOwner`, which can be applied to your functions to restrict their use to
416  * the owner.
417  */
418 contract Ownable is Context {
419     address private _owner;
420     address private _previousOwner;
421     uint256 private _lockTime;
422 
423     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
424 
425     /**
426      * @dev Initializes the contract setting the deployer as the initial owner.
427      */
428     constructor () {
429         address msgSender = _msgSender();
430         _owner = msgSender;
431         emit OwnershipTransferred(address(0), msgSender);
432     }
433 
434     /**
435      * @dev Returns the address of the current owner.
436      */
437     function owner() public view returns (address) {
438         return _owner;
439     }
440 
441     /**
442      * @dev Throws if called by any account other than the owner.
443      */
444     modifier onlyOwner() {
445         require(_owner == _msgSender(), "Ownable: caller is not the owner");
446         _;
447     }
448 
449      /**
450      * @dev Leaves the contract without owner. It will not be possible to call
451      * `onlyOwner` functions anymore. Can only be called by the current owner.
452      *
453      * NOTE: Renouncing ownership will leave the contract without an owner,
454      * thereby removing any functionality that is only available to the owner.
455      */
456     function renounceOwnership() public virtual onlyOwner {
457         emit OwnershipTransferred(_owner, address(0));
458         _owner = address(0);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Can only be called by the current owner.
464      */
465     function transferOwnership(address newOwner) public virtual onlyOwner {
466         require(newOwner != address(0), "Ownable: new owner is the zero address");
467         emit OwnershipTransferred(_owner, newOwner);
468         _owner = newOwner;
469     }
470 
471     function geUnlockTime() public view returns (uint256) {
472         return _lockTime;
473     }
474 
475     //Locks the contract for owner for the amount of time provided
476     function lock(uint256 time) public virtual onlyOwner {
477         _previousOwner = _owner;
478         _owner = address(0);
479         _lockTime = block.timestamp + time;
480         emit OwnershipTransferred(_owner, address(0));
481     }
482     
483     //Unlocks the contract for owner when _lockTime is exceeds
484     function unlock() public virtual {
485         require(_previousOwner == msg.sender, "You don't have permission to unlock");
486         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
487         emit OwnershipTransferred(_owner, _previousOwner);
488         _owner = _previousOwner;
489     }
490 }
491 
492 
493 interface IUniswapV2Factory {
494     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
495 
496     function feeTo() external view returns (address);
497     function feeToSetter() external view returns (address);
498 
499     function getPair(address tokenA, address tokenB) external view returns (address pair);
500     function allPairs(uint) external view returns (address pair);
501     function allPairsLength() external view returns (uint);
502 
503     function createPair(address tokenA, address tokenB) external returns (address pair);
504 
505     function setFeeTo(address) external;
506     function setFeeToSetter(address) external;
507 }
508 
509 
510 
511 interface IUniswapV2Pair {
512     event Approval(address indexed owner, address indexed spender, uint value);
513     event Transfer(address indexed from, address indexed to, uint value);
514 
515     function name() external pure returns (string memory);
516     function symbol() external pure returns (string memory);
517     function decimals() external pure returns (uint8);
518     function totalSupply() external view returns (uint);
519     function balanceOf(address owner) external view returns (uint);
520     function allowance(address owner, address spender) external view returns (uint);
521 
522     function approve(address spender, uint value) external returns (bool);
523     function transfer(address to, uint value) external returns (bool);
524     function transferFrom(address from, address to, uint value) external returns (bool);
525 
526     function DOMAIN_SEPARATOR() external view returns (bytes32);
527     function PERMIT_TYPEHASH() external pure returns (bytes32);
528     function nonces(address owner) external view returns (uint);
529 
530     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
531 
532     event Mint(address indexed sender, uint amount0, uint amount1);
533     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
534     event Swap(
535         address indexed sender,
536         uint amount0In,
537         uint amount1In,
538         uint amount0Out,
539         uint amount1Out,
540         address indexed to
541     );
542     event Sync(uint112 reserve0, uint112 reserve1);
543 
544     function MINIMUM_LIQUIDITY() external pure returns (uint);
545     function factory() external view returns (address);
546     function token0() external view returns (address);
547     function token1() external view returns (address);
548     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
549     function price0CumulativeLast() external view returns (uint);
550     function price1CumulativeLast() external view returns (uint);
551     function kLast() external view returns (uint);
552 
553     function mint(address to) external returns (uint liquidity);
554     function burn(address to) external returns (uint amount0, uint amount1);
555     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
556     function skim(address to) external;
557     function sync() external;
558 
559     function initialize(address, address) external;
560 }
561 
562 
563 interface IUniswapV2Router01 {
564     function factory() external pure returns (address);
565     function WETH() external pure returns (address);
566 
567     function addLiquidity(
568         address tokenA,
569         address tokenB,
570         uint amountADesired,
571         uint amountBDesired,
572         uint amountAMin,
573         uint amountBMin,
574         address to,
575         uint deadline
576     ) external returns (uint amountA, uint amountB, uint liquidity);
577     function addLiquidityETH(
578         address token,
579         uint amountTokenDesired,
580         uint amountTokenMin,
581         uint amountETHMin,
582         address to,
583         uint deadline
584     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
585     function removeLiquidity(
586         address tokenA,
587         address tokenB,
588         uint liquidity,
589         uint amountAMin,
590         uint amountBMin,
591         address to,
592         uint deadline
593     ) external returns (uint amountA, uint amountB);
594     function removeLiquidityETH(
595         address token,
596         uint liquidity,
597         uint amountTokenMin,
598         uint amountETHMin,
599         address to,
600         uint deadline
601     ) external returns (uint amountToken, uint amountETH);
602     function removeLiquidityWithPermit(
603         address tokenA,
604         address tokenB,
605         uint liquidity,
606         uint amountAMin,
607         uint amountBMin,
608         address to,
609         uint deadline,
610         bool approveMax, uint8 v, bytes32 r, bytes32 s
611     ) external returns (uint amountA, uint amountB);
612     function removeLiquidityETHWithPermit(
613         address token,
614         uint liquidity,
615         uint amountTokenMin,
616         uint amountETHMin,
617         address to,
618         uint deadline,
619         bool approveMax, uint8 v, bytes32 r, bytes32 s
620     ) external returns (uint amountToken, uint amountETH);
621     function swapExactTokensForTokens(
622         uint amountIn,
623         uint amountOutMin,
624         address[] calldata path,
625         address to,
626         uint deadline
627     ) external returns (uint[] memory amounts);
628     function swapTokensForExactTokens(
629         uint amountOut,
630         uint amountInMax,
631         address[] calldata path,
632         address to,
633         uint deadline
634     ) external returns (uint[] memory amounts);
635     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
636         external
637         payable
638         returns (uint[] memory amounts);
639     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
640         external
641         returns (uint[] memory amounts);
642     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
643         external
644         returns (uint[] memory amounts);
645     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
646         external
647         payable
648         returns (uint[] memory amounts);
649 
650     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
651     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
652     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
653     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
654     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
655 }
656 
657 
658 
659 
660 interface IUniswapV2Router02 is IUniswapV2Router01 {
661     function removeLiquidityETHSupportingFeeOnTransferTokens(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline
668     ) external returns (uint amountETH);
669     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
670         address token,
671         uint liquidity,
672         uint amountTokenMin,
673         uint amountETHMin,
674         address to,
675         uint deadline,
676         bool approveMax, uint8 v, bytes32 r, bytes32 s
677     ) external returns (uint amountETH);
678 
679     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
680         uint amountIn,
681         uint amountOutMin,
682         address[] calldata path,
683         address to,
684         uint deadline
685     ) external;
686     function swapExactETHForTokensSupportingFeeOnTransferTokens(
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external payable;
692     function swapExactTokensForETHSupportingFeeOnTransferTokens(
693         uint amountIn,
694         uint amountOutMin,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external;
699 }
700 
701 interface IAirdrop {
702     function airdrop(address recipient, uint256 amount) external;
703 }
704 
705 contract Lobby is Context, IERC20, Ownable {
706     using SafeMath for uint256;
707     using Address for address;
708 
709     mapping (address => uint256) private _rOwned;
710     mapping (address => uint256) private _tOwned;
711     mapping (address => mapping (address => uint256)) private _allowances;
712 
713     mapping (address => bool) private _isExcludedFromFee;
714 
715     mapping (address => bool) private _isExcluded;
716     address[] private _excluded;
717     
718     mapping (address => bool) private botWallets;
719     bool botscantrade = false;
720     
721     bool public canTrade = false;
722     uint256 public launchTime;
723    
724     uint256 private constant MAX = ~uint256(0);
725     uint256 private _tTotal = 10000000 * 10**3 * 10**9;
726     uint256 private _rTotal = (MAX - (MAX % _tTotal));
727     uint256 private _tFeeTotal;
728     address public charityWallet;
729 
730     string private _name = "Lobby";
731     string private _symbol = "LBY";
732     uint8 private _decimals = 9;
733     
734     uint256 public _taxFee = 0;
735     uint256 private _previousTaxFee = _taxFee;
736 
737     uint256 public charityFeePercent = 4;
738     
739     uint256 public _liquidityFee = 1;
740     uint256 private _previousLiquidityFee = _liquidityFee;
741 
742     IUniswapV2Router02 public immutable uniswapV2Router;
743     address public immutable uniswapV2Pair;
744     
745     bool inSwapAndLiquify;
746     bool public swapAndLiquifyEnabled = true;
747     
748     uint256 public _maxTxAmount = 1000000 * 10**3 * 10**9;
749     uint256 public numTokensSellToAddToLiquidity = 1000000 * 10**3 * 10**9;
750     
751     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
752     event SwapAndLiquifyEnabledUpdated(bool enabled);
753     event SwapAndLiquify(
754         uint256 tokensSwapped,
755         uint256 ethReceived,
756         uint256 tokensIntoLiqudity
757     );
758     
759     modifier lockTheSwap {
760         inSwapAndLiquify = true;
761         _;
762         inSwapAndLiquify = false;
763     }
764     
765     constructor () {
766         _rOwned[_msgSender()] = _rTotal;
767         
768         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Mainnet BSC
769         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //Testnet BSC
770         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
771          // Create a uniswap pair for this new token
772         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
773             .createPair(address(this), _uniswapV2Router.WETH());
774 
775         // set the rest of the contract variables
776         uniswapV2Router = _uniswapV2Router;
777         
778         //exclude owner and this contract from fee
779         _isExcludedFromFee[owner()] = true;
780         _isExcludedFromFee[address(this)] = true;
781         
782         emit Transfer(address(0), _msgSender(), _tTotal);
783     }
784 
785     function name() public view returns (string memory) {
786         return _name;
787     }
788 
789     function symbol() public view returns (string memory) {
790         return _symbol;
791     }
792 
793     function decimals() public view returns (uint8) {
794         return _decimals;
795     }
796 
797     function totalSupply() public view override returns (uint256) {
798         return _tTotal;
799     }
800 
801     function balanceOf(address account) public view override returns (uint256) {
802         if (_isExcluded[account]) return _tOwned[account];
803         return tokenFromReflection(_rOwned[account]);
804     }
805 
806     function transfer(address recipient, uint256 amount) public override returns (bool) {
807         _transfer(_msgSender(), recipient, amount);
808         return true;
809     }
810 
811     function allowance(address owner, address spender) public view override returns (uint256) {
812         return _allowances[owner][spender];
813     }
814 
815     function approve(address spender, uint256 amount) public override returns (bool) {
816         _approve(_msgSender(), spender, amount);
817         return true;
818     }
819 
820     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
821         _transfer(sender, recipient, amount);
822         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
823         return true;
824     }
825 
826     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
827         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
828         return true;
829     }
830 
831     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
832         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
833         return true;
834     }
835 
836     function isExcludedFromReward(address account) public view returns (bool) {
837         return _isExcluded[account];
838     }
839 
840     function totalFees() public view returns (uint256) {
841         return _tFeeTotal;
842     }
843     
844     function airdrop(address recipient, uint256 amount) external onlyOwner() {
845         removeAllFee();
846         _transfer(_msgSender(), recipient, amount * 10**9);
847         restoreAllFee();
848     }
849     
850     function airdropInternal(address recipient, uint256 amount) internal {
851         removeAllFee();
852         _transfer(_msgSender(), recipient, amount);
853         restoreAllFee();
854     }
855     
856     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
857         uint256 iterator = 0;
858         require(newholders.length == amounts.length, "must be the same length");
859         while(iterator < newholders.length){
860             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
861             iterator += 1;
862         }
863     }
864 
865     function deliver(uint256 tAmount) public {
866         address sender = _msgSender();
867         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
868         (uint256 rAmount,,,,,) = _getValues(tAmount);
869         _rOwned[sender] = _rOwned[sender].sub(rAmount);
870         _rTotal = _rTotal.sub(rAmount);
871         _tFeeTotal = _tFeeTotal.add(tAmount);
872     }
873 
874     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
875         require(tAmount <= _tTotal, "Amount must be less than supply");
876         if (!deductTransferFee) {
877             (uint256 rAmount,,,,,) = _getValues(tAmount);
878             return rAmount;
879         } else {
880             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
881             return rTransferAmount;
882         }
883     }
884 
885     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
886         require(rAmount <= _rTotal, "Amount must be less than total reflections");
887         uint256 currentRate =  _getRate();
888         return rAmount.div(currentRate);
889     }
890 
891     function excludeFromReward(address account) public onlyOwner() {
892         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
893         require(!_isExcluded[account], "Account is already excluded");
894         if(_rOwned[account] > 0) {
895             _tOwned[account] = tokenFromReflection(_rOwned[account]);
896         }
897         _isExcluded[account] = true;
898         _excluded.push(account);
899     }
900 
901     function includeInReward(address account) external onlyOwner() {
902         require(_isExcluded[account], "Account is already excluded");
903         for (uint256 i = 0; i < _excluded.length; i++) {
904             if (_excluded[i] == account) {
905                 _excluded[i] = _excluded[_excluded.length - 1];
906                 _tOwned[account] = 0;
907                 _isExcluded[account] = false;
908                 _excluded.pop();
909                 break;
910             }
911         }
912     }
913         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
914         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
915         _tOwned[sender] = _tOwned[sender].sub(tAmount);
916         _rOwned[sender] = _rOwned[sender].sub(rAmount);
917         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
918         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
919         _takeLiquidity(tLiquidity);
920         _reflectFee(rFee, tFee);
921         emit Transfer(sender, recipient, tTransferAmount);
922     }
923     
924     function excludeFromFee(address account) public onlyOwner {
925         _isExcludedFromFee[account] = true;
926     }
927     
928     function includeInFee(address account) public onlyOwner {
929         _isExcludedFromFee[account] = false;
930     }
931     function setCharityFeePercent(uint256 fee) public onlyOwner {
932         require(fee < 50, "Charity fee cannot be more than 50% of liquidity");
933         charityFeePercent = fee;
934     }
935 
936     function setCharityWallet(address walletAddress) public onlyOwner {
937         charityWallet = walletAddress;
938     }
939     
940     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
941         require(taxFee < 10, "Tax fee cannot be more than 10%");
942         _taxFee = taxFee;
943     }
944     
945     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
946         _liquidityFee = liquidityFee;
947     }
948    
949     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
950         require(maxTxAmount > 10000000, "Max Tx Amount cannot be less than 10 Million");
951         _maxTxAmount = maxTxAmount * 10**9;
952     }
953     
954     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
955         require(SwapThresholdAmount > 10000000, "Swap Threshold Amount cannot be less than 10 Million");
956         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
957     }
958     
959     function claimTokens () public onlyOwner {
960         // make sure we capture all BNB that may or may not be sent to this contract
961         payable(charityWallet).transfer(address(this).balance);
962     }
963     
964     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
965         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
966     }
967     
968     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
969         walletaddress.transfer(address(this).balance);
970     }
971     
972     function addBotWallet(address botwallet) external onlyOwner() {
973         botWallets[botwallet] = true;
974     }
975     
976     function removeBotWallet(address botwallet) external onlyOwner() {
977         botWallets[botwallet] = false;
978     }
979     
980     function getBotWalletStatus(address botwallet) public view returns (bool) {
981         return botWallets[botwallet];
982     }
983     
984     function allowtrading()external onlyOwner() {
985         canTrade = true;
986         launchTime = block.timestamp;
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
1098         // resgister snipers!
1099         if (
1100             from == uniswapV2Pair &&
1101             to != address(uniswapV2Router) &&
1102             !_isExcludedFromFee[to] &&
1103             block.timestamp == launchTime
1104         ) {
1105             botWallets[to] = true;
1106         }
1107 
1108         // is the token balance of this contract address over the min number of
1109         // tokens that we need to initiate a swap + liquidity lock?
1110         // also, don't get caught in a circular liquidity event.
1111         // also, don't swap & liquify if sender is uniswap pair.
1112         uint256 contractTokenBalance = balanceOf(address(this));
1113         
1114         if(contractTokenBalance >= _maxTxAmount)
1115         {
1116             contractTokenBalance = _maxTxAmount;
1117         }
1118         
1119         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1120         if (
1121             overMinTokenBalance &&
1122             !inSwapAndLiquify &&
1123             from != uniswapV2Pair &&
1124             swapAndLiquifyEnabled
1125         ) {
1126             contractTokenBalance = numTokensSellToAddToLiquidity;
1127             //add liquidity
1128             swapAndLiquify(contractTokenBalance);
1129         }
1130         
1131         //indicates if fee should be deducted from transfer
1132         bool takeFee = true;
1133         
1134         //if any account belongs to _isExcludedFromFee account then remove the fee
1135         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1136             takeFee = false;
1137         }
1138         
1139         //transfer amount, it will take tax, burn, liquidity fee
1140         _tokenTransfer(from,to,amount,takeFee);
1141     }
1142 
1143     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1144         // split the contract balance into halves
1145         // add the charity wallet
1146         uint256 half = contractTokenBalance.div(2);
1147         uint256 otherHalf = contractTokenBalance.sub(half);
1148 
1149         // capture the contract's current ETH balance.
1150         // this is so that we can capture exactly the amount of ETH that the
1151         // swap creates, and not make the liquidity event include any ETH that
1152         // has been manually sent to the contract
1153         uint256 initialBalance = address(this).balance;
1154 
1155         // swap tokens for ETH
1156         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1157 
1158         // how much ETH did we just swap into?
1159         uint256 newBalance = address(this).balance.sub(initialBalance);
1160         uint256 charityshare = newBalance.mul(charityFeePercent).div(100);
1161         payable(charityWallet).transfer(charityshare);
1162         newBalance -= charityshare;
1163         // add liquidity to uniswap
1164         addLiquidity(otherHalf, newBalance);
1165         
1166         emit SwapAndLiquify(half, newBalance, otherHalf);
1167     }
1168 
1169     function swapTokensForEth(uint256 tokenAmount) private {
1170         // generate the uniswap pair path of token -> weth
1171         address[] memory path = new address[](2);
1172         path[0] = address(this);
1173         path[1] = uniswapV2Router.WETH();
1174 
1175         _approve(address(this), address(uniswapV2Router), tokenAmount);
1176 
1177         // make the swap
1178         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1179             tokenAmount,
1180             0, // accept any amount of ETH
1181             path,
1182             address(this),
1183             block.timestamp
1184         );
1185     }
1186 
1187     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1188         // approve token transfer to cover all possible scenarios
1189         _approve(address(this), address(uniswapV2Router), tokenAmount);
1190 
1191         // add the liquidity
1192         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1193             address(this),
1194             tokenAmount,
1195             0, // slippage is unavoidable
1196             0, // slippage is unavoidable
1197             owner(),
1198             block.timestamp
1199         );
1200     }
1201 
1202     //this method is responsible for taking all fee, if takeFee is true
1203     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1204         if(!canTrade){
1205             require(sender == owner()); // only owner allowed to trade or add liquidity
1206         }
1207         
1208         if(botWallets[sender] || botWallets[recipient]){
1209             require(botscantrade, "bots arent allowed to trade");
1210         }
1211         
1212         if(!takeFee)
1213             removeAllFee();
1214         
1215         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1216             _transferFromExcluded(sender, recipient, amount);
1217         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1218             _transferToExcluded(sender, recipient, amount);
1219         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1220             _transferStandard(sender, recipient, amount);
1221         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1222             _transferBothExcluded(sender, recipient, amount);
1223         } else {
1224             _transferStandard(sender, recipient, amount);
1225         }
1226         
1227         if(!takeFee)
1228             restoreAllFee();
1229     }
1230 
1231     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1232         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1233         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1234         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1235         _takeLiquidity(tLiquidity);
1236         _reflectFee(rFee, tFee);
1237         emit Transfer(sender, recipient, tTransferAmount);
1238     }
1239 
1240     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1241         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1242         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1243         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1244         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1245         _takeLiquidity(tLiquidity);
1246         _reflectFee(rFee, tFee);
1247         emit Transfer(sender, recipient, tTransferAmount);
1248     }
1249 
1250     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1251         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1252         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1253         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1254         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1255         _takeLiquidity(tLiquidity);
1256         _reflectFee(rFee, tFee);
1257         emit Transfer(sender, recipient, tTransferAmount);
1258     }
1259 
1260 }