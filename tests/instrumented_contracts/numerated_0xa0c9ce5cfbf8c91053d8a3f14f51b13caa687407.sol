1 /**
2 
3 
4 	   ▀█████████▄   ▄██████▄  ███▄▄▄▄      ▄████████ 
5 		███    ███ ███    ███ ███▀▀▀██▄   ███    ███ 
6 		███    ███ ███    ███ ███   ███   ███    █▀  
7 	   ▄███▄▄▄██▀  ███    ███ ███   ███  ▄███▄▄▄     
8 	  ▀▀███▀▀▀██▄  ███    ███ ███   ███ ▀▀███▀▀▀     
9 		███    ██▄ ███    ███ ███   ███   ███    █▄  
10 		███    ███ ███    ███ ███   ███   ███    ███ 
11 	   ▄█████████▀   ▀██████▀   ▀█   █▀    ██████████ 
12 													
13 					// A $BDOG Charity Production //
14 
15 
16     Total Supply: 1 Billion
17     Transaction Fee: 6%
18 
19     Fee Breakdown:
20         - Charity Wallet Distribution: 2%
21         - Holder Yield: 1%
22         - LP Bonus (BONE/BNB): 2%
23         - Automatic Liquidity: 1%
24 
25     deployed by @sycore0
26 		as part of the Rocket Drop token launch platform
27 		url: https://drop.rocketbunny.io
28 		tg: @RocketBunnyChat
29 
30 
31  */
32 
33 pragma solidity ^0.6.12;
34 // SPDX-License-Identifier: Unlicensed
35 interface IERC20 {
36 
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119  
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      *
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 abstract contract Context {
264     function _msgSender() internal view virtual returns (address payable) {
265         return msg.sender;
266     }
267 
268     function _msgData() internal view virtual returns (bytes memory) {
269         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
270         return msg.data;
271     }
272 }
273 
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
298         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
299         // for accounts without code, i.e. `keccak256('')`
300         bytes32 codehash;
301         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { codehash := extcodehash(account) }
304         return (codehash != accountHash && codehash != 0x0);
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 /**
414  * @dev Contract module which provides a basic access control mechanism, where
415  * there is an account (an owner) that can be granted exclusive access to
416  * specific functions.
417  *
418  * By default, the owner account will be the one that deploys the contract. This
419  * can later be changed with {transferOwnership}.
420  *
421  * This module is used through inheritance. It will make available the modifier
422  * `onlyOwner`, which can be applied to your functions to restrict their use to
423  * the owner.
424  */
425 contract Ownable is Context {
426     address private _owner;
427     address private _previousOwner;
428     uint256 private _lockTime;
429 
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431 
432     /**
433      * @dev Initializes the contract setting the deployer as the initial owner.
434      */
435     constructor () internal {
436         address msgSender = _msgSender();
437         _owner = msgSender;
438         emit OwnershipTransferred(address(0), msgSender);
439     }
440 
441     /**
442      * @dev Returns the address of the current owner.
443      */
444     function owner() public view returns (address) {
445         return _owner;
446     }
447 
448     /**
449      * @dev Throws if called by any account other than the owner.
450      */
451     modifier onlyOwner() {
452         require(_owner == _msgSender(), "Ownable: caller is not the owner");
453         _;
454     }
455 
456      /**
457      * @dev Leaves the contract without owner. It will not be possible to call
458      * `onlyOwner` functions anymore. Can only be called by the current owner.
459      *
460      * NOTE: Renouncing ownership will leave the contract without an owner,
461      * thereby removing any functionality that is only available to the owner.
462      */
463     function renounceOwnership() public virtual onlyOwner {
464         emit OwnershipTransferred(_owner, address(0));
465         _owner = address(0);
466     }
467 
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Can only be called by the current owner.
471      */
472     function transferOwnership(address newOwner) public virtual onlyOwner {
473         require(newOwner != address(0), "Ownable: new owner is the zero address");
474         emit OwnershipTransferred(_owner, newOwner);
475         _owner = newOwner;
476     }
477 
478     function geUnlockTime() public view returns (uint256) {
479         return _lockTime;
480     }
481 
482     //Locks the contract for owner for the amount of time provided
483     function lock(uint256 time) public virtual onlyOwner {
484         _previousOwner = _owner;
485         _owner = address(0);
486         _lockTime = now + time;
487         emit OwnershipTransferred(_owner, address(0));
488     }
489     
490     //Unlocks the contract for owner when _lockTime is exceeds
491     function unlock() public virtual {
492         require(_previousOwner == msg.sender, "You don't have permission to unlock");
493         require(now > _lockTime , "Contract is locked until 7 days");
494         emit OwnershipTransferred(_owner, _previousOwner);
495         _owner = _previousOwner;
496     }
497 }
498 
499 // pragma solidity >=0.5.0;
500 
501 interface IUniswapV2Factory {
502     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
503 
504     function feeTo() external view returns (address);
505     function feeToSetter() external view returns (address);
506 
507     function getPair(address tokenA, address tokenB) external view returns (address pair);
508     function allPairs(uint) external view returns (address pair);
509     function allPairsLength() external view returns (uint);
510 
511     function createPair(address tokenA, address tokenB) external returns (address pair);
512 
513     function setFeeTo(address) external;
514     function setFeeToSetter(address) external;
515 }
516 
517 
518 // pragma solidity >=0.5.0;
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
571 // pragma solidity >=0.6.2;
572 
573 interface IUniswapV2Router01 {
574     function factory() external pure returns (address);
575     function WETH() external pure returns (address);
576 
577     function addLiquidity(
578         address tokenA,
579         address tokenB,
580         uint amountADesired,
581         uint amountBDesired,
582         uint amountAMin,
583         uint amountBMin,
584         address to,
585         uint deadline
586     ) external returns (uint amountA, uint amountB, uint liquidity);
587     function addLiquidityETH(
588         address token,
589         uint amountTokenDesired,
590         uint amountTokenMin,
591         uint amountETHMin,
592         address to,
593         uint deadline
594     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
595     function removeLiquidity(
596         address tokenA,
597         address tokenB,
598         uint liquidity,
599         uint amountAMin,
600         uint amountBMin,
601         address to,
602         uint deadline
603     ) external returns (uint amountA, uint amountB);
604     function removeLiquidityETH(
605         address token,
606         uint liquidity,
607         uint amountTokenMin,
608         uint amountETHMin,
609         address to,
610         uint deadline
611     ) external returns (uint amountToken, uint amountETH);
612     function removeLiquidityWithPermit(
613         address tokenA,
614         address tokenB,
615         uint liquidity,
616         uint amountAMin,
617         uint amountBMin,
618         address to,
619         uint deadline,
620         bool approveMax, uint8 v, bytes32 r, bytes32 s
621     ) external returns (uint amountA, uint amountB);
622     function removeLiquidityETHWithPermit(
623         address token,
624         uint liquidity,
625         uint amountTokenMin,
626         uint amountETHMin,
627         address to,
628         uint deadline,
629         bool approveMax, uint8 v, bytes32 r, bytes32 s
630     ) external returns (uint amountToken, uint amountETH);
631     function swapExactTokensForTokens(
632         uint amountIn,
633         uint amountOutMin,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external returns (uint[] memory amounts);
638     function swapTokensForExactTokens(
639         uint amountOut,
640         uint amountInMax,
641         address[] calldata path,
642         address to,
643         uint deadline
644     ) external returns (uint[] memory amounts);
645     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
646         external
647         payable
648         returns (uint[] memory amounts);
649     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
650         external
651         returns (uint[] memory amounts);
652     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
653         external
654         returns (uint[] memory amounts);
655     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
656         external
657         payable
658         returns (uint[] memory amounts);
659 
660     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
661     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
662     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
663     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
664     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
665 }
666 
667 
668 
669 // pragma solidity >=0.6.2;
670 
671 interface IUniswapV2Router02 is IUniswapV2Router01 {
672     function removeLiquidityETHSupportingFeeOnTransferTokens(
673         address token,
674         uint liquidity,
675         uint amountTokenMin,
676         uint amountETHMin,
677         address to,
678         uint deadline
679     ) external returns (uint amountETH);
680     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
681         address token,
682         uint liquidity,
683         uint amountTokenMin,
684         uint amountETHMin,
685         address to,
686         uint deadline,
687         bool approveMax, uint8 v, bytes32 r, bytes32 s
688     ) external returns (uint amountETH);
689 
690     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
691         uint amountIn,
692         uint amountOutMin,
693         address[] calldata path,
694         address to,
695         uint deadline
696     ) external;
697     function swapExactETHForTokensSupportingFeeOnTransferTokens(
698         uint amountOutMin,
699         address[] calldata path,
700         address to,
701         uint deadline
702     ) external payable;
703     function swapExactTokensForETHSupportingFeeOnTransferTokens(
704         uint amountIn,
705         uint amountOutMin,
706         address[] calldata path,
707         address to,
708         uint deadline
709     ) external;
710 }
711 
712 
713 contract BONE is Context, IERC20, Ownable {
714     using SafeMath for uint256;
715     using Address for address;
716 
717     mapping (address => uint256) private _rOwned;
718     mapping (address => uint256) private _tOwned;
719     mapping (address => mapping (address => uint256)) private _allowances;
720 
721     mapping (address => bool) private _isExcludedFromFee;
722 
723     mapping (address => bool) private _isExcluded;
724     address[] private _excluded;
725    
726     uint256 private constant MAX = ~uint256(0);
727     uint256 private _tTotal = 1 * 10**9 * 10**9;
728     uint256 private _rTotal = (MAX - (MAX % _tTotal));
729     uint256 private _tFeeTotal;
730 
731 	uint256 public _liquidityBonus = 2;
732 	uint256 public _charityPercent = 2;
733 
734     string private _name = "BONE";
735     string private _symbol = "BONE";
736     uint8 private _decimals = 9;
737     
738     uint256 public _taxFee = 1;
739     uint256 private _previousTaxFee = _taxFee;
740     
741     uint256 public _liquidityFee = 1;
742     uint256 private _previousLiquidityFee = _liquidityFee;
743 
744     IUniswapV2Router02 public immutable uniswapV2Router;
745     address public immutable uniswapV2Pair;
746 
747 	address public charityWallet = address(0xf3a15C4BBC332824B10282B5D0cCeaDb06a72518);
748     
749     bool inSwapAndLiquify;
750     bool public swapAndLiquifyEnabled = true;
751     
752     uint256 private numTokensSellToAddToLiquidity = 10**5 * 10**9;
753     
754     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
755     event SwapAndLiquifyEnabledUpdated(bool enabled);
756     event SwapAndLiquify(
757         uint256 tokensSwapped,
758         uint256 ethReceived,
759         uint256 tokensIntoLiqudity
760     );
761     
762     modifier lockTheSwap {
763         inSwapAndLiquify = true;
764         _;
765         inSwapAndLiquify = false;
766     }
767     
768     constructor () public {
769         _rOwned[_msgSender()] = _rTotal;
770         
771         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
783 		charityWallet = owner();
784         
785         emit Transfer(address(0), _msgSender(), _tTotal);
786     }
787 
788     function name() public view returns (string memory) {
789         return _name;
790     }
791 
792     function symbol() public view returns (string memory) {
793         return _symbol;
794     }
795 
796     function decimals() public view returns (uint8) {
797         return _decimals;
798     }
799 
800     function totalSupply() public view override returns (uint256) {
801         return _tTotal;
802     }
803 
804     function balanceOf(address account) public view override returns (uint256) {
805         if (_isExcluded[account]) return _tOwned[account];
806         return tokenFromReflection(_rOwned[account]);
807     }
808 
809     function transfer(address recipient, uint256 amount) public override returns (bool) {
810         _transfer(_msgSender(), recipient, amount);
811         return true;
812     }
813 
814     function allowance(address owner, address spender) public view override returns (uint256) {
815         return _allowances[owner][spender];
816     }
817 
818     function approve(address spender, uint256 amount) public override returns (bool) {
819         _approve(_msgSender(), spender, amount);
820         return true;
821     }
822 
823     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
824         _transfer(sender, recipient, amount);
825         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
826         return true;
827     }
828 
829     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
830         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
831         return true;
832     }
833 
834     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
835         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
836         return true;
837     }
838 
839     function isExcludedFromReward(address account) public view returns (bool) {
840         return _isExcluded[account];
841     }
842 
843     function totalFees() public view returns (uint256) {
844         return _tFeeTotal;
845     }
846 
847     function deliver(uint256 tAmount) public {
848         address sender = _msgSender();
849         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
850         (uint256 rAmount,,,,,) = _getValues(tAmount);
851         _rOwned[sender] = _rOwned[sender].sub(rAmount);
852         _rTotal = _rTotal.sub(rAmount);
853         _tFeeTotal = _tFeeTotal.add(tAmount);
854     }
855 
856     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
857         require(tAmount <= _tTotal, "Amount must be less than supply");
858         if (!deductTransferFee) {
859             (uint256 rAmount,,,,,) = _getValues(tAmount);
860             return rAmount;
861         } else {
862             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
863             return rTransferAmount;
864         }
865     }
866 
867     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
868         require(rAmount <= _rTotal, "Amount must be less than total reflections");
869         uint256 currentRate =  _getRate();
870         return rAmount.div(currentRate);
871     }
872 
873     function excludeFromReward(address account) public onlyOwner() {
874         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
875         require(!_isExcluded[account], "Account is already excluded");
876         if(_rOwned[account] > 0) {
877             _tOwned[account] = tokenFromReflection(_rOwned[account]);
878         }
879         _isExcluded[account] = true;
880         _excluded.push(account);
881     }
882 
883     function includeInReward(address account) external onlyOwner() {
884         require(_isExcluded[account], "Account is already excluded");
885         for (uint256 i = 0; i < _excluded.length; i++) {
886             if (_excluded[i] == account) {
887                 _excluded[i] = _excluded[_excluded.length - 1];
888                 _tOwned[account] = 0;
889                 _isExcluded[account] = false;
890                 _excluded.pop();
891                 break;
892             }
893         }
894     }
895         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
896         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
897         _tOwned[sender] = _tOwned[sender].sub(tAmount);
898         _rOwned[sender] = _rOwned[sender].sub(rAmount);
899         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
900         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
901         _takeLiquidity(tLiquidity);
902         _reflectFee(rFee, tFee);
903         emit Transfer(sender, recipient, tTransferAmount);
904     }
905     
906         function excludeFromFee(address account) public onlyOwner {
907         _isExcludedFromFee[account] = true;
908     }
909     
910     function includeInFee(address account) public onlyOwner {
911         _isExcludedFromFee[account] = false;
912     }
913     
914     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
915         _taxFee = taxFee;
916     }
917     
918     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
919         _liquidityFee = liquidityFee;
920     }
921 
922     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
923         swapAndLiquifyEnabled = _enabled;
924         emit SwapAndLiquifyEnabledUpdated(_enabled);
925     }
926     
927      //to recieve ETH from uniswapV2Router when swaping
928     receive() external payable {}
929 
930     function _reflectFee(uint256 rFee, uint256 tFee) private {
931         _rTotal = _rTotal.sub(rFee);
932         _tFeeTotal = _tFeeTotal.add(tFee);
933     }
934 
935     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
936         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
937         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
938         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
939     }
940 
941     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
942         uint256 tFee = calculateTaxFee(tAmount);
943         uint256 tLiquidity = calculateLiquidityFee(tAmount);
944         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
945         return (tTransferAmount, tFee, tLiquidity);
946     }
947 
948     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
949         uint256 rAmount = tAmount.mul(currentRate);
950         uint256 rFee = tFee.mul(currentRate);
951         uint256 rLiquidity = tLiquidity.mul(currentRate);
952         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
953         return (rAmount, rTransferAmount, rFee);
954     }
955 
956     function _getRate() private view returns(uint256) {
957         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
958         return rSupply.div(tSupply);
959     }
960 
961     function _getCurrentSupply() private view returns(uint256, uint256) {
962         uint256 rSupply = _rTotal;
963         uint256 tSupply = _tTotal;      
964         for (uint256 i = 0; i < _excluded.length; i++) {
965             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
966             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
967             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
968         }
969         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
970         return (rSupply, tSupply);
971     }
972     
973     function _takeLiquidity(uint256 tLiquidity) private {
974         uint256 currentRate =  _getRate();
975         uint256 rLiquidity = tLiquidity.mul(currentRate);
976         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
977         if(_isExcluded[address(this)])
978             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
979     }
980     
981     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
982         return _amount.mul(_taxFee).div(
983             10**2
984         );
985     }
986 
987     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
988         return _amount.mul(_liquidityFee).div(
989             10**2
990         );
991     }
992     
993     function removeAllFee() private {
994         if(_taxFee == 0 && _liquidityFee == 0) return;
995         
996         _previousTaxFee = _taxFee;
997         _previousLiquidityFee = _liquidityFee;
998         
999         _taxFee = 0;
1000         _liquidityFee = 0;
1001     }
1002     
1003     function restoreAllFee() private {
1004         _taxFee = _previousTaxFee;
1005         _liquidityFee = _previousLiquidityFee;
1006     }
1007     
1008     function isExcludedFromFee(address account) public view returns(bool) {
1009         return _isExcludedFromFee[account];
1010     }
1011 
1012     function _approve(address owner, address spender, uint256 amount) private {
1013         require(owner != address(0), "ERC20: approve from the zero address");
1014         require(spender != address(0), "ERC20: approve to the zero address");
1015 
1016         _allowances[owner][spender] = amount;
1017         emit Approval(owner, spender, amount);
1018     }
1019 
1020     function _transfer(
1021         address from,
1022         address to,
1023         uint256 amount
1024     ) private {
1025         require(from != address(0), "ERC20: transfer from the zero address");
1026         require(to != address(0), "ERC20: transfer to the zero address");
1027         require(amount > 0, "Transfer amount must be greater than zero");
1028 
1029         // is the token balance of this contract address over the min number of
1030         // tokens that we need to initiate a swap + liquidity lock?
1031         // also, don't get caught in a circular liquidity event.
1032         // also, don't swap & liquify if sender is uniswap pair.
1033         uint256 contractTokenBalance = balanceOf(address(this));
1034         
1035         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1036         if (
1037             overMinTokenBalance &&
1038             !inSwapAndLiquify &&
1039             from != uniswapV2Pair &&
1040             swapAndLiquifyEnabled
1041         ) {
1042             contractTokenBalance = numTokensSellToAddToLiquidity;
1043             //add liquidity
1044             swapAndLiquify(contractTokenBalance);
1045         }
1046         
1047         //indicates if fee should be deducted from transfer
1048         bool takeFee = true;
1049         
1050         //if any account belongs to _isExcludedFromFee account then remove the fee
1051         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1052             takeFee = false;
1053         } else{
1054 			//calculate LP bonus and Charity amounts
1055 			uint256 LPbonus = amount.mul(_liquidityBonus).div(10**2);
1056 			uint256 charityDist = amount.mul(_charityPercent).div(10**2);
1057 			// transfer liquidity bonus
1058 			_tokenTransfer(from,uniswapV2Pair,LPbonus,false);
1059 			// transfer charity percent
1060 			_tokenTransfer(from,charityWallet,charityDist,false);
1061 
1062 			// adjust amount after charity and LP bonus
1063 			amount = amount.sub(LPbonus).sub(charityDist);
1064 		}
1065         
1066 		
1067 
1068         // transfer amount, it will take tax, burn, liquidity fee
1069 
1070         _tokenTransfer(from,to,amount,takeFee);
1071     }
1072 
1073     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1074         // split the contract balance into halves
1075         uint256 half = contractTokenBalance.div(2);
1076         uint256 otherHalf = contractTokenBalance.sub(half);
1077 
1078         // capture the contract's current ETH balance.
1079         // this is so that we can capture exactly the amount of ETH that the
1080         // swap creates, and not make the liquidity event include any ETH that
1081         // has been manually sent to the contract
1082         uint256 initialBalance = address(this).balance;
1083 
1084         // swap tokens for ETH
1085         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1086 
1087         // how much ETH did we just swap into?
1088         uint256 newBalance = address(this).balance.sub(initialBalance);
1089 
1090         // add liquidity to uniswap
1091         addLiquidity(otherHalf, newBalance);
1092         
1093         emit SwapAndLiquify(half, newBalance, otherHalf);
1094     }
1095 
1096     function swapTokensForEth(uint256 tokenAmount) private {
1097         // generate the uniswap pair path of token -> weth
1098         address[] memory path = new address[](2);
1099         path[0] = address(this);
1100         path[1] = uniswapV2Router.WETH();
1101 
1102         _approve(address(this), address(uniswapV2Router), tokenAmount);
1103 
1104         // make the swap
1105         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1106             tokenAmount,
1107             0, // accept any amount of ETH
1108             path,
1109             address(this),
1110             block.timestamp
1111         );
1112     }
1113     function recycleETH() public onlyOwner {
1114         // generate the uniswap pair path of weth -> token
1115         address[] memory path = new address[](2);
1116         path[0] = uniswapV2Router.WETH();
1117 		path[1] = address(this);
1118 
1119 		uint256 ethBalance = address(this).balance;
1120         // buy the tokens
1121         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethBalance}(
1122             0, // accept any amount of tokens
1123             path,
1124             address(this),
1125             block.timestamp
1126         );
1127     }
1128 
1129     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1130         // approve token transfer to cover all possible scenarios
1131         _approve(address(this), address(uniswapV2Router), tokenAmount);
1132 
1133         // add the liquidity
1134         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1135             address(this),
1136             tokenAmount,
1137             0, // slippage is unavoidable
1138             0, // slippage is unavoidable
1139             owner(),
1140             block.timestamp
1141         );
1142     }
1143 
1144     //this method is responsible for taking all fee, if takeFee is true
1145     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1146         if(!takeFee)
1147             removeAllFee();
1148         
1149         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1150             _transferFromExcluded(sender, recipient, amount);
1151         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1152             _transferToExcluded(sender, recipient, amount);
1153         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1154             _transferStandard(sender, recipient, amount);
1155         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1156             _transferBothExcluded(sender, recipient, amount);
1157         } else {
1158             _transferStandard(sender, recipient, amount);
1159         }
1160         
1161         if(!takeFee)
1162             restoreAllFee();
1163     }
1164 
1165     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1166         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1167         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1168         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1169         _takeLiquidity(tLiquidity);
1170         _reflectFee(rFee, tFee);
1171         emit Transfer(sender, recipient, tTransferAmount);
1172     }
1173 
1174     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1175         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1176         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1177         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1178         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1179         _takeLiquidity(tLiquidity);
1180         _reflectFee(rFee, tFee);
1181         emit Transfer(sender, recipient, tTransferAmount);
1182     }
1183 
1184     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1185         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1186         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1187         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1188         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1189         _takeLiquidity(tLiquidity);
1190         _reflectFee(rFee, tFee);
1191         emit Transfer(sender, recipient, tTransferAmount);
1192     }
1193 
1194     function setLiquifyAmount(uint256 amount) public onlyOwner {
1195         numTokensSellToAddToLiquidity = amount;
1196     }
1197 
1198 	function setCharityWallet(address newWallet) public onlyOwner {
1199 		charityWallet = newWallet;
1200 	}
1201 	
1202 	function setLPbonus(uint256 amount) public onlyOwner {
1203         _liquidityBonus = amount;
1204     }
1205 	function setCharityPercent(uint256 amount) public onlyOwner {
1206         _charityPercent = amount;
1207     }
1208 
1209 	function withdrawNonBONEtokens(address _recipient, address _ERC20address, uint256 _amount) public onlyOwner returns(bool) {
1210         require(_ERC20address != address(this), "Cannot withdraw BONE!");
1211 		require(_ERC20address != uniswapV2Pair, "Cannot withdraw LP!");
1212         IERC20(_ERC20address).transfer(_recipient, _amount); //use of the _ERC20 traditional transfer
1213         return true;
1214     }
1215 
1216 }