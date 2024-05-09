1 /**
2     Magick DAO $MAGICK 
3 
4     This token is being spearheaded by head Wizard, Steven Brundage.
5     Steven, a young and established magician/artist, has worked with
6     top-tier celebrities like Kobe Bryant, Tony Hawk, and Chadwick Boseman
7     to name a few. Additionally, he placed in the top 3 on US talent show
8     Americas Got Talent, has done national interviews on syndicated US
9     television (GMA, Regis&Kelly), and currently tours his curated
10     Rubix-cube Art all over the world.
11 
12     Tokenomics: 
13 
14     14% buy/sell tax:
15 
16     4% reflections
17     10% marketing/liquidity 
18 
19 
20     Website:
21     https://www.magickdao.com
22 
23     Telegram:
24     https://t.me/magickDAO
25 
26     Twitter:
27     https://twitter.com/MagickDAO
28 
29 */
30 
31 // SPDX-License-Identifier: Unlicensed
32 pragma solidity ^0.8.4;
33 
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
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
114 pragma solidity ^0.8.0;
115 
116 // CAUTION
117 // This version of SafeMath should only be used with Solidity 0.8 or later,
118 // because it relies on the compiler's built in overflow checks.
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations.
122  *
123  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
124  * now has built in overflow checking.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             uint256 c = a + b;
135             if (c < a) return (false, 0);
136             return (true, c);
137         }
138     }
139 
140     /**
141      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b > a) return (false, 0);
148             return (true, a - b);
149         }
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         unchecked {
159             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160             // benefit is lost if 'b' is also tested.
161             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162             if (a == 0) return (true, 0);
163             uint256 c = a * b;
164             if (c / a != b) return (false, 0);
165             return (true, c);
166         }
167     }
168 
169     /**
170      * @dev Returns the division of two unsigned integers, with a division by zero flag.
171      *
172      * _Available since v3.4._
173      */
174     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         unchecked {
176             if (b == 0) return (false, 0);
177             return (true, a / b);
178         }
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         unchecked {
188             if (b == 0) return (false, 0);
189             return (true, a % b);
190         }
191     }
192 
193     /**
194      * @dev Returns the addition of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `+` operator.
198      *
199      * Requirements:
200      *
201      * - Addition cannot overflow.
202      */
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a + b;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a - b;
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `*` operator.
226      *
227      * Requirements:
228      *
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a * b;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers, reverting on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator.
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(uint256 a, uint256 b) internal pure returns (uint256) {
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         return a % b;
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
267      * overflow (when the result is negative).
268      *
269      * CAUTION: This function is deprecated because it requires allocating memory for the error
270      * message unnecessarily. For custom revert reasons use {trySub}.
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      *
276      * - Subtraction cannot overflow.
277      */
278     function sub(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b <= a, errorMessage);
285             return a - b;
286         }
287     }
288 
289     /**
290      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
291      * division by zero. The result is rounded towards zero.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b > 0, errorMessage);
308             return a / b;
309         }
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * reverting with custom message when dividing by zero.
315      *
316      * CAUTION: This function is deprecated because it requires allocating memory for the error
317      * message unnecessarily. For custom revert reasons use {tryMod}.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a % b;
335         }
336     }
337 }
338 
339 /*
340  * @dev Provides information about the current execution context, including the
341  * sender of the transaction and its data. While these are generally available
342  * via msg.sender and msg.data, they should not be accessed in such a direct
343  * manner, since when dealing with meta-transactions the account sending and
344  * paying for execution may not be the actual sender (as far as an application
345  * is concerned).
346  *
347  * This contract is only required for intermediate, library-like contracts.
348  */
349 abstract contract Context {
350     function _msgSender() internal view virtual returns (address) {
351         return msg.sender;
352     }
353 
354     function _msgData() internal view virtual returns (bytes calldata) {
355         return msg.data;
356     }
357 }
358 
359 /**
360  * @dev Contract module which provides a basic access control mechanism, where
361  * there is an account (an owner) that can be granted exclusive access to
362  * specific functions.
363  *
364  * By default, the owner account will be the one that deploys the contract. This
365  * can later be changed with {transferOwnership}.
366  *
367  * This module is used through inheritance. It will make available the modifier
368  * `onlyOwner`, which can be applied to your functions to restrict their use to
369  * the owner.
370  */
371 abstract contract Ownable is Context {
372     address private _owner;
373 
374     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
375 
376     /**
377      * @dev Initializes the contract setting the deployer as the initial owner.
378      */
379     constructor() {
380         _setOwner(_msgSender());
381     }
382 
383     /**
384      * @dev Returns the address of the current owner.
385      */
386     function owner() public view virtual returns (address) {
387         return _owner;
388     }
389 
390     /**
391      * @dev Throws if called by any account other than the owner.
392      */
393     modifier onlyOwner() {
394         require(owner() == _msgSender(), "Ownable: caller is not the owner");
395         _;
396     }
397 
398     /**
399      * @dev Leaves the contract without owner. It will not be possible to call
400      * `onlyOwner` functions anymore. Can only be called by the current owner.
401      *
402      * NOTE: Renouncing ownership will leave the contract without an owner,
403      * thereby removing any functionality that is only available to the owner.
404      */
405     function renounceOwnership() public virtual onlyOwner {
406         _setOwner(address(0));
407     }
408 
409     /**
410      * @dev Transfers ownership of the contract to a new account (`newOwner`).
411      * Can only be called by the current owner.
412      */
413     function transferOwnership(address newOwner) public virtual onlyOwner {
414         require(newOwner != address(0), "Ownable: new owner is the zero address");
415         _setOwner(newOwner);
416     }
417 
418     function _setOwner(address newOwner) private {
419         address oldOwner = _owner;
420         _owner = newOwner;
421         emit OwnershipTransferred(oldOwner, newOwner);
422     }
423 }
424 
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev Collection of functions related to the address type
430  */
431 library Address {
432     /**
433      * @dev Returns true if `account` is a contract.
434      *
435      * [IMPORTANT]
436      * ====
437      * It is unsafe to assume that an address for which this function returns
438      * false is an externally-owned account (EOA) and not a contract.
439      *
440      * Among others, `isContract` will return false for the following
441      * types of addresses:
442      *
443      *  - an externally-owned account
444      *  - a contract in construction
445      *  - an address where a contract will be created
446      *  - an address where a contract lived, but was destroyed
447      * ====
448      */
449     function isContract(address account) internal view returns (bool) {
450         // This method relies on extcodesize, which returns 0 for contracts in
451         // construction, since the code is only stored at the end of the
452         // constructor execution.
453 
454         uint256 size;
455         assembly {
456             size := extcodesize(account)
457         }
458         return size > 0;
459     }
460 
461     /**
462      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
463      * `recipient`, forwarding all available gas and reverting on errors.
464      *
465      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
466      * of certain opcodes, possibly making contracts go over the 2300 gas limit
467      * imposed by `transfer`, making them unable to receive funds via
468      * `transfer`. {sendValue} removes this limitation.
469      *
470      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
471      *
472      * IMPORTANT: because control is transferred to `recipient`, care must be
473      * taken to not create reentrancy vulnerabilities. Consider using
474      * {ReentrancyGuard} or the
475      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
476      */
477     function sendValue(address payable recipient, uint256 amount) internal {
478         require(address(this).balance >= amount, "Address: insufficient balance");
479 
480         (bool success, ) = recipient.call{value: amount}("");
481         require(success, "Address: unable to send value, recipient may have reverted");
482     }
483 
484     /**
485      * @dev Performs a Solidity function call using a low level `call`. A
486      * plain `call` is an unsafe replacement for a function call: use this
487      * function instead.
488      *
489      * If `target` reverts with a revert reason, it is bubbled up by this
490      * function (like regular Solidity function calls).
491      *
492      * Returns the raw returned data. To convert to the expected return value,
493      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
494      *
495      * Requirements:
496      *
497      * - `target` must be a contract.
498      * - calling `target` with `data` must not revert.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
503         return functionCall(target, data, "Address: low-level call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
508      * `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(
513         address target,
514         bytes memory data,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         return functionCallWithValue(target, data, 0, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but also transferring `value` wei to `target`.
523      *
524      * Requirements:
525      *
526      * - the calling contract must have an ETH balance of at least `value`.
527      * - the called Solidity function must be `payable`.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(
532         address target,
533         bytes memory data,
534         uint256 value
535     ) internal returns (bytes memory) {
536         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
541      * with `errorMessage` as a fallback revert reason when `target` reverts.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         require(address(this).balance >= value, "Address: insufficient balance for call");
552         require(isContract(target), "Address: call to non-contract");
553 
554         (bool success, bytes memory returndata) = target.call{value: value}(data);
555         return _verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
565         return functionStaticCall(target, data, "Address: low-level static call failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a static call.
571      *
572      * _Available since v3.3._
573      */
574     function functionStaticCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal view returns (bytes memory) {
579         require(isContract(target), "Address: static call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.staticcall(data);
582         return _verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
592         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
597      * but performing a delegate call.
598      *
599      * _Available since v3.4._
600      */
601     function functionDelegateCall(
602         address target,
603         bytes memory data,
604         string memory errorMessage
605     ) internal returns (bytes memory) {
606         require(isContract(target), "Address: delegate call to non-contract");
607 
608         (bool success, bytes memory returndata) = target.delegatecall(data);
609         return _verifyCallResult(success, returndata, errorMessage);
610     }
611 
612     function _verifyCallResult(
613         bool success,
614         bytes memory returndata,
615         string memory errorMessage
616     ) private pure returns (bytes memory) {
617         if (success) {
618             return returndata;
619         } else {
620             // Look for revert reason and bubble it up if present
621             if (returndata.length > 0) {
622                 // The easiest way to bubble the revert reason is using memory via assembly
623 
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 pragma solidity >=0.5.0;
636 
637 interface IUniswapV2Factory {
638     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
639 
640     function feeTo() external view returns (address);
641     function feeToSetter() external view returns (address);
642 
643     function getPair(address tokenA, address tokenB) external view returns (address pair);
644     function allPairs(uint) external view returns (address pair);
645     function allPairsLength() external view returns (uint);
646 
647     function createPair(address tokenA, address tokenB) external returns (address pair);
648 
649     function setFeeTo(address) external;
650     function setFeeToSetter(address) external;
651 }
652 
653 pragma solidity >=0.5.0;
654 
655 interface IUniswapV2Pair {
656     event Approval(address indexed owner, address indexed spender, uint value);
657     event Transfer(address indexed from, address indexed to, uint value);
658 
659     function name() external pure returns (string memory);
660     function symbol() external pure returns (string memory);
661     function decimals() external pure returns (uint8);
662     function totalSupply() external view returns (uint);
663     function balanceOf(address owner) external view returns (uint);
664     function allowance(address owner, address spender) external view returns (uint);
665 
666     function approve(address spender, uint value) external returns (bool);
667     function transfer(address to, uint value) external returns (bool);
668     function transferFrom(address from, address to, uint value) external returns (bool);
669 
670     function DOMAIN_SEPARATOR() external view returns (bytes32);
671     function PERMIT_TYPEHASH() external pure returns (bytes32);
672     function nonces(address owner) external view returns (uint);
673 
674     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
675 
676     event Mint(address indexed sender, uint amount0, uint amount1);
677     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
678     event Swap(
679         address indexed sender,
680         uint amount0In,
681         uint amount1In,
682         uint amount0Out,
683         uint amount1Out,
684         address indexed to
685     );
686     event Sync(uint112 reserve0, uint112 reserve1);
687 
688     function MINIMUM_LIQUIDITY() external pure returns (uint);
689     function factory() external view returns (address);
690     function token0() external view returns (address);
691     function token1() external view returns (address);
692     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
693     function price0CumulativeLast() external view returns (uint);
694     function price1CumulativeLast() external view returns (uint);
695     function kLast() external view returns (uint);
696 
697     function mint(address to) external returns (uint liquidity);
698     function burn(address to) external returns (uint amount0, uint amount1);
699     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
700     function skim(address to) external;
701     function sync() external;
702 
703     function initialize(address, address) external;
704 }
705 
706 pragma solidity >=0.6.2;
707 
708 interface IUniswapV2Router01 {
709     function factory() external pure returns (address);
710     function WETH() external pure returns (address);
711 
712     function addLiquidity(
713         address tokenA,
714         address tokenB,
715         uint amountADesired,
716         uint amountBDesired,
717         uint amountAMin,
718         uint amountBMin,
719         address to,
720         uint deadline
721     ) external returns (uint amountA, uint amountB, uint liquidity);
722     function addLiquidityETH(
723         address token,
724         uint amountTokenDesired,
725         uint amountTokenMin,
726         uint amountETHMin,
727         address to,
728         uint deadline
729     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
730     function removeLiquidity(
731         address tokenA,
732         address tokenB,
733         uint liquidity,
734         uint amountAMin,
735         uint amountBMin,
736         address to,
737         uint deadline
738     ) external returns (uint amountA, uint amountB);
739     function removeLiquidityETH(
740         address token,
741         uint liquidity,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline
746     ) external returns (uint amountToken, uint amountETH);
747     function removeLiquidityWithPermit(
748         address tokenA,
749         address tokenB,
750         uint liquidity,
751         uint amountAMin,
752         uint amountBMin,
753         address to,
754         uint deadline,
755         bool approveMax, uint8 v, bytes32 r, bytes32 s
756     ) external returns (uint amountA, uint amountB);
757     function removeLiquidityETHWithPermit(
758         address token,
759         uint liquidity,
760         uint amountTokenMin,
761         uint amountETHMin,
762         address to,
763         uint deadline,
764         bool approveMax, uint8 v, bytes32 r, bytes32 s
765     ) external returns (uint amountToken, uint amountETH);
766     function swapExactTokensForTokens(
767         uint amountIn,
768         uint amountOutMin,
769         address[] calldata path,
770         address to,
771         uint deadline
772     ) external returns (uint[] memory amounts);
773     function swapTokensForExactTokens(
774         uint amountOut,
775         uint amountInMax,
776         address[] calldata path,
777         address to,
778         uint deadline
779     ) external returns (uint[] memory amounts);
780     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
781         external
782         payable
783         returns (uint[] memory amounts);
784     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
785         external
786         returns (uint[] memory amounts);
787     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
788         external
789         returns (uint[] memory amounts);
790     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
791         external
792         payable
793         returns (uint[] memory amounts);
794 
795     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
796     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
797     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
798     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
799     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
800 }
801 
802 interface IUniswapV2Router02 is IUniswapV2Router01 {
803     function removeLiquidityETHSupportingFeeOnTransferTokens(
804         address token,
805         uint liquidity,
806         uint amountTokenMin,
807         uint amountETHMin,
808         address to,
809         uint deadline
810     ) external returns (uint amountETH);
811     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
812         address token,
813         uint liquidity,
814         uint amountTokenMin,
815         uint amountETHMin,
816         address to,
817         uint deadline,
818         bool approveMax, uint8 v, bytes32 r, bytes32 s
819     ) external returns (uint amountETH);
820 
821     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
822         uint amountIn,
823         uint amountOutMin,
824         address[] calldata path,
825         address to,
826         uint deadline
827     ) external;
828     function swapExactETHForTokensSupportingFeeOnTransferTokens(
829         uint amountOutMin,
830         address[] calldata path,
831         address to,
832         uint deadline
833     ) external payable;
834     function swapExactTokensForETHSupportingFeeOnTransferTokens(
835         uint amountIn,
836         uint amountOutMin,
837         address[] calldata path,
838         address to,
839         uint deadline
840     ) external;
841 }
842 
843 // Contract implementation
844 contract MagickDAO is Context, IERC20, Ownable {
845   using SafeMath for uint256;
846   using Address for address;
847 
848   mapping(address => uint256) private _rOwned;
849   mapping(address => uint256) private _tOwned;
850   mapping(address => mapping(address => uint256)) private _allowances;
851 
852   mapping(address => bool) private _isExcludedFromFee;
853 
854   mapping(address => bool) private _isExcluded;
855   address[] private _excluded;
856 
857   uint256 private constant MAX = ~uint256(0);
858   uint256 private _tTotal = 4206900000000 * 10**9;
859   uint256 private _rTotal = (MAX - (MAX % _tTotal));
860   uint256 private _tFeeTotal;
861 
862   string private _name = 'Magick DAO';
863   string private _symbol = 'MAGICK';
864   uint8 private _decimals = 9;
865 
866   uint256 private _taxFee = 4;
867   uint256 private _teamFee = 10;
868   uint256 private _previousTaxFee = _taxFee;
869   uint256 private _previousTeamFee = _teamFee;
870 
871   address payable public _MagickWalletAddress;
872   address payable public _marketingWalletAddress;
873 
874   IUniswapV2Router02 public immutable uniswapV2Router;
875   address public immutable uniswapV2Pair;
876   mapping(address => bool) private _isUniswapPair;
877 
878   bool inSwap = false;
879   bool public swapEnabled = true;
880 
881   uint8 _sellTaxMultiplier = 1;
882 
883   uint256 private _maxTxAmount = 21000000000e9;
884   // We will set a minimum amount of tokens to be swaped => 5M
885   uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
886 
887   struct AirdropReceiver {
888     address addy;
889     uint256 amount;
890   }
891 
892   event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
893   event SwapEnabledUpdated(bool enabled);
894 
895   modifier lockTheSwap() {
896     inSwap = true;
897     _;
898     inSwap = false;
899   }
900 
901   constructor(
902     address payable MagickWalletAddress,
903     address payable marketingWalletAddress
904   ) {
905     _MagickWalletAddress = MagickWalletAddress;
906     _marketingWalletAddress = marketingWalletAddress;
907     _rOwned[_msgSender()] = _rTotal;
908 
909     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
910       0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
911     ); // UniswapV2 for Ethereum network
912     // Create a uniswap pair for this new token
913     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
914       address(this),
915       _uniswapV2Router.WETH()
916     );
917 
918     // set the rest of the contract variables
919     uniswapV2Router = _uniswapV2Router;
920 
921     // Exclude owner and this contract from fee
922     _isExcludedFromFee[owner()] = true;
923     _isExcludedFromFee[address(this)] = true;
924 
925     emit Transfer(address(0), _msgSender(), _tTotal);
926   }
927 
928   function name() public view returns (string memory) {
929     return _name;
930   }
931 
932   function symbol() public view returns (string memory) {
933     return _symbol;
934   }
935 
936   function decimals() public view returns (uint8) {
937     return _decimals;
938   }
939 
940   function totalSupply() public view override returns (uint256) {
941     return _tTotal;
942   }
943 
944   function balanceOf(address account) public view override returns (uint256) {
945     if (_isExcluded[account]) return _tOwned[account];
946     return tokenFromReflection(_rOwned[account]);
947   }
948 
949   function transfer(address recipient, uint256 amount)
950     public
951     override
952     returns (bool)
953   {
954     _transfer(_msgSender(), recipient, amount);
955     return true;
956   }
957 
958   function allowance(address owner, address spender)
959     public
960     view
961     override
962     returns (uint256)
963   {
964     return _allowances[owner][spender];
965   }
966 
967   function approve(address spender, uint256 amount)
968     public
969     override
970     returns (bool)
971   {
972     _approve(_msgSender(), spender, amount);
973     return true;
974   }
975 
976   function transferFrom(
977     address sender,
978     address recipient,
979     uint256 amount
980   ) public override returns (bool) {
981     _transfer(sender, recipient, amount);
982     _approve(
983       sender,
984       _msgSender(),
985       _allowances[sender][_msgSender()].sub(
986         amount,
987         'ERC20: transfer amount exceeds allowance'
988       )
989     );
990     return true;
991   }
992 
993   function increaseAllowance(address spender, uint256 addedValue)
994     public
995     virtual
996     returns (bool)
997   {
998     _approve(
999       _msgSender(),
1000       spender,
1001       _allowances[_msgSender()][spender].add(addedValue)
1002     );
1003     return true;
1004   }
1005 
1006   function decreaseAllowance(address spender, uint256 subtractedValue)
1007     public
1008     virtual
1009     returns (bool)
1010   {
1011     _approve(
1012       _msgSender(),
1013       spender,
1014       _allowances[_msgSender()][spender].sub(
1015         subtractedValue,
1016         'ERC20: decreased allowance below zero'
1017       )
1018     );
1019     return true;
1020   }
1021 
1022   function isExcluded(address account) public view returns (bool) {
1023     return _isExcluded[account];
1024   }
1025 
1026   function setExcludeFromFee(address account, bool excluded)
1027     external
1028     onlyOwner
1029   {
1030     _isExcludedFromFee[account] = excluded;
1031   }
1032 
1033   function totalFees() public view returns (uint256) {
1034     return _tFeeTotal;
1035   }
1036 
1037   function deliver(uint256 tAmount) public {
1038     address sender = _msgSender();
1039     require(
1040       !_isExcluded[sender],
1041       'Excluded addresses cannot call this function'
1042     );
1043     (uint256 rAmount, , , , , ) = _getValues(tAmount, false);
1044     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1045     _rTotal = _rTotal.sub(rAmount);
1046     _tFeeTotal = _tFeeTotal.add(tAmount);
1047   }
1048 
1049   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1050     public
1051     view
1052     returns (uint256)
1053   {
1054     require(tAmount <= _tTotal, 'Amount must be less than supply');
1055     if (!deductTransferFee) {
1056       (uint256 rAmount, , , , , ) = _getValues(tAmount, false);
1057       return rAmount;
1058     } else {
1059       (, uint256 rTransferAmount, , , , ) = _getValues(tAmount, false);
1060       return rTransferAmount;
1061     }
1062   }
1063 
1064   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
1065     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
1066     uint256 currentRate = _getRate();
1067     return rAmount.div(currentRate);
1068   }
1069 
1070   function excludeAccount(address account) external onlyOwner {
1071     require(
1072       account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1073       'We can not exclude Uniswap router.'
1074     );
1075     require(!_isExcluded[account], 'Account is already excluded');
1076     if (_rOwned[account] > 0) {
1077       _tOwned[account] = tokenFromReflection(_rOwned[account]);
1078     }
1079     _isExcluded[account] = true;
1080     _excluded.push(account);
1081   }
1082 
1083   function includeAccount(address account) external onlyOwner {
1084     require(_isExcluded[account], 'Account is already excluded');
1085     for (uint256 i = 0; i < _excluded.length; i++) {
1086       if (_excluded[i] == account) {
1087         _excluded[i] = _excluded[_excluded.length - 1];
1088         _tOwned[account] = 0;
1089         _isExcluded[account] = false;
1090         _excluded.pop();
1091         break;
1092       }
1093     }
1094   }
1095 
1096   function removeAllFee() private {
1097     if (_taxFee == 0 && _teamFee == 0) return;
1098 
1099     _previousTaxFee = _taxFee;
1100     _previousTeamFee = _teamFee;
1101 
1102     _taxFee = 0;
1103     _teamFee = 0;
1104   }
1105 
1106   function restoreAllFee() private {
1107     _taxFee = _previousTaxFee;
1108     _teamFee = _previousTeamFee;
1109   }
1110 
1111   function isExcludedFromFee(address account) public view returns (bool) {
1112     return _isExcludedFromFee[account];
1113   }
1114 
1115   function _approve(
1116     address owner,
1117     address spender,
1118     uint256 amount
1119   ) private {
1120     require(owner != address(0), 'ERC20: approve from the zero address');
1121     require(spender != address(0), 'ERC20: approve to the zero address');
1122 
1123     _allowances[owner][spender] = amount;
1124     emit Approval(owner, spender, amount);
1125   }
1126 
1127   function _transfer(
1128     address sender,
1129     address recipient,
1130     uint256 amount
1131   ) private {
1132     require(sender != address(0), 'ERC20: transfer from the zero address');
1133     require(recipient != address(0), 'ERC20: transfer to the zero address');
1134     require(amount > 0, 'Transfer amount must be greater than zero');
1135 
1136     if (sender != owner() && recipient != owner())
1137       require(
1138         amount <= _maxTxAmount,
1139         'Transfer amount exceeds the maxTxAmount.'
1140       );
1141 
1142     // is the token balance of this contract address over the min number of
1143     // tokens that we need to initiate a swap?
1144     // also, don't get caught in a circular team event.
1145     // also, don't swap if sender is uniswap pair.
1146     uint256 contractTokenBalance = balanceOf(address(this));
1147 
1148     if (contractTokenBalance >= _maxTxAmount) {
1149       contractTokenBalance = _maxTxAmount;
1150     }
1151 
1152     bool overMinTokenBalance = contractTokenBalance >=
1153       _numOfTokensToExchangeForTeam;
1154     if (
1155       !inSwap &&
1156       swapEnabled &&
1157       overMinTokenBalance &&
1158       (recipient == uniswapV2Pair || _isUniswapPair[recipient])
1159     ) {
1160       // We need to swap the current tokens to ETH and send to the team wallet
1161       swapTokensForEth(contractTokenBalance);
1162 
1163       uint256 contractETHBalance = address(this).balance;
1164       if (contractETHBalance > 0) {
1165         sendETHToTeam(address(this).balance);
1166       }
1167     }
1168 
1169     // indicates if fee should be deducted from transfer
1170     bool takeFee = false;
1171 
1172     // take fee only on swaps
1173     if (
1174       (sender == uniswapV2Pair ||
1175         recipient == uniswapV2Pair ||
1176         _isUniswapPair[recipient] ||
1177         _isUniswapPair[sender]) &&
1178       !(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1179     ) {
1180       takeFee = true;
1181     }
1182 
1183     //transfer amount, it will take tax and team fee
1184     _tokenTransfer(sender, recipient, amount, takeFee);
1185   }
1186 
1187   function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1188     // generate the uniswap pair path of token -> weth
1189     address[] memory path = new address[](2);
1190     path[0] = address(this);
1191     path[1] = uniswapV2Router.WETH();
1192 
1193     _approve(address(this), address(uniswapV2Router), tokenAmount);
1194 
1195     // make the swap
1196     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1197       tokenAmount,
1198       0, // accept any amount of ETH
1199       path,
1200       address(this),
1201       block.timestamp
1202     );
1203   }
1204 
1205   function sendETHToTeam(uint256 amount) private {
1206     _MagickWalletAddress.call{ value: amount.div(2) }('');
1207     _marketingWalletAddress.call{ value: amount.div(2) }('');
1208   }
1209 
1210   // We are exposing these functions to be able to manual swap and send
1211   // in case the token is highly valued and 5M becomes too much
1212   function manualSwap() external onlyOwner {
1213     uint256 contractBalance = balanceOf(address(this));
1214     swapTokensForEth(contractBalance);
1215   }
1216 
1217   function manualSend() external onlyOwner {
1218     uint256 contractETHBalance = address(this).balance;
1219     sendETHToTeam(contractETHBalance);
1220   }
1221 
1222   function setSwapEnabled(bool enabled) external onlyOwner {
1223     swapEnabled = enabled;
1224   }
1225 
1226   function _tokenTransfer(
1227     address sender,
1228     address recipient,
1229     uint256 amount,
1230     bool takeFee
1231   ) private {
1232     if (!takeFee) removeAllFee();
1233 
1234     if (_isExcluded[sender] && !_isExcluded[recipient]) {
1235       _transferFromExcluded(sender, recipient, amount);
1236     } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1237       _transferToExcluded(sender, recipient, amount);
1238     } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1239       _transferBothExcluded(sender, recipient, amount);
1240     } else {
1241       _transferStandard(sender, recipient, amount);
1242     }
1243 
1244     if (!takeFee) restoreAllFee();
1245   }
1246 
1247   function _transferStandard(
1248     address sender,
1249     address recipient,
1250     uint256 tAmount
1251   ) private {
1252     (
1253       uint256 rAmount,
1254       uint256 rTransferAmount,
1255       uint256 rFee,
1256       uint256 tTransferAmount,
1257       uint256 tFee,
1258       uint256 tTeam
1259     ) = _getValues(tAmount, _isSelling(recipient));
1260     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1261     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1262     _takeTeam(tTeam);
1263     _reflectFee(rFee, tFee);
1264     emit Transfer(sender, recipient, tTransferAmount);
1265   }
1266 
1267   function _transferToExcluded(
1268     address sender,
1269     address recipient,
1270     uint256 tAmount
1271   ) private {
1272     (
1273       uint256 rAmount,
1274       uint256 rTransferAmount,
1275       uint256 rFee,
1276       uint256 tTransferAmount,
1277       uint256 tFee,
1278       uint256 tTeam
1279     ) = _getValues(tAmount, _isSelling(recipient));
1280     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1281     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1282     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1283     _takeTeam(tTeam);
1284     _reflectFee(rFee, tFee);
1285     emit Transfer(sender, recipient, tTransferAmount);
1286   }
1287 
1288   function _transferFromExcluded(
1289     address sender,
1290     address recipient,
1291     uint256 tAmount
1292   ) private {
1293     (
1294       uint256 rAmount,
1295       uint256 rTransferAmount,
1296       uint256 rFee,
1297       uint256 tTransferAmount,
1298       uint256 tFee,
1299       uint256 tTeam
1300     ) = _getValues(tAmount, _isSelling(recipient));
1301     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1302     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1303     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1304     _takeTeam(tTeam);
1305     _reflectFee(rFee, tFee);
1306     emit Transfer(sender, recipient, tTransferAmount);
1307   }
1308 
1309   function _transferBothExcluded(
1310     address sender,
1311     address recipient,
1312     uint256 tAmount
1313   ) private {
1314     (
1315       uint256 rAmount,
1316       uint256 rTransferAmount,
1317       uint256 rFee,
1318       uint256 tTransferAmount,
1319       uint256 tFee,
1320       uint256 tTeam
1321     ) = _getValues(tAmount, _isSelling(recipient));
1322     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1323     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1324     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1325     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1326     _takeTeam(tTeam);
1327     _reflectFee(rFee, tFee);
1328     emit Transfer(sender, recipient, tTransferAmount);
1329   }
1330 
1331   function _takeTeam(uint256 tTeam) private {
1332     uint256 currentRate = _getRate();
1333     uint256 rTeam = tTeam.mul(currentRate);
1334     _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1335     if (_isExcluded[address(this)])
1336       _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1337   }
1338 
1339   function _reflectFee(uint256 rFee, uint256 tFee) private {
1340     _rTotal = _rTotal.sub(rFee);
1341     _tFeeTotal = _tFeeTotal.add(tFee);
1342   }
1343 
1344   //to recieve ETH from uniswapV2Router when swaping
1345   receive() external payable {}
1346 
1347   function _getValues(uint256 tAmount, bool isSelling)
1348     private
1349     view
1350     returns (
1351       uint256,
1352       uint256,
1353       uint256,
1354       uint256,
1355       uint256,
1356       uint256
1357     )
1358   {
1359     (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
1360       tAmount,
1361       _taxFee,
1362       _teamFee,
1363       isSelling
1364     );
1365     uint256 currentRate = _getRate();
1366     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1367       tAmount,
1368       tFee,
1369       tTeam,
1370       currentRate
1371     );
1372     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1373   }
1374 
1375   function _getTValues(
1376     uint256 tAmount,
1377     uint256 taxFee,
1378     uint256 teamFee,
1379     bool isSelling
1380   )
1381     private
1382     view
1383     returns (
1384       uint256,
1385       uint256,
1386       uint256
1387     )
1388   {
1389     uint256 finalTax = isSelling ? taxFee.mul(_sellTaxMultiplier) : taxFee;
1390     uint256 finalTeam = isSelling ? teamFee.mul(_sellTaxMultiplier) : teamFee;
1391 
1392     uint256 tFee = tAmount.mul(finalTax).div(100);
1393     uint256 tTeam = tAmount.mul(finalTeam).div(100);
1394     uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1395     return (tTransferAmount, tFee, tTeam);
1396   }
1397 
1398   function _getRValues(
1399     uint256 tAmount,
1400     uint256 tFee,
1401     uint256 tTeam,
1402     uint256 currentRate
1403   )
1404     private
1405     pure
1406     returns (
1407       uint256,
1408       uint256,
1409       uint256
1410     )
1411   {
1412     uint256 rAmount = tAmount.mul(currentRate);
1413     uint256 rFee = tFee.mul(currentRate);
1414     uint256 rTeam = tTeam.mul(currentRate);
1415     uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1416     return (rAmount, rTransferAmount, rFee);
1417   }
1418 
1419   function _getRate() private view returns (uint256) {
1420     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1421     return rSupply.div(tSupply);
1422   }
1423 
1424   function _getCurrentSupply() private view returns (uint256, uint256) {
1425     uint256 rSupply = _rTotal;
1426     uint256 tSupply = _tTotal;
1427     for (uint256 i = 0; i < _excluded.length; i++) {
1428       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
1429         return (_rTotal, _tTotal);
1430       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1431       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1432     }
1433     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1434     return (rSupply, tSupply);
1435   }
1436 
1437   function _getTaxFee() private view returns (uint256) {
1438     return _taxFee;
1439   }
1440 
1441   function _getMaxTxAmount() private view returns (uint256) {
1442     return _maxTxAmount;
1443   }
1444 
1445   function _isSelling(address recipient) private view returns (bool) {
1446     return recipient == uniswapV2Pair || _isUniswapPair[recipient];
1447   }
1448 
1449   function _getETHBalance() public view returns (uint256 balance) {
1450     return address(this).balance;
1451   }
1452 
1453   function _setTaxFee(uint256 taxFee) external onlyOwner {
1454     require(taxFee <= 5, 'taxFee should be in 0 - 5');
1455     _taxFee = taxFee;
1456   }
1457 
1458   function _setTeamFee(uint256 teamFee) external onlyOwner {
1459     require(teamFee <= 5, 'teamFee should be in 0 - 5');
1460     _teamFee = teamFee;
1461   }
1462 
1463   function _setSellTaxMultiplier(uint8 mult) external onlyOwner {
1464     require(mult >= 1 && mult <= 3, 'multiplier should be in 1 - 3');
1465     _sellTaxMultiplier = mult;
1466   }
1467 
1468   function _setMagickWallet(address payable MagickWalletAddress) external onlyOwner {
1469     _MagickWalletAddress = MagickWalletAddress;
1470   }
1471 
1472   function _setMarketingWallet(address payable marketingWalletAddress)
1473     external
1474     onlyOwner
1475   {
1476     _marketingWalletAddress = marketingWalletAddress;
1477   }
1478 
1479   function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1480     require(
1481       maxTxAmount >= 100000000000000e9,
1482       'maxTxAmount should be greater than 100000000000000e9'
1483     );
1484     _maxTxAmount = maxTxAmount;
1485   }
1486 
1487   function isUniswapPair(address _pair) external view returns (bool) {
1488     if (_pair == uniswapV2Pair) return true;
1489     return _isUniswapPair[_pair];
1490   }
1491 
1492   function addUniswapPair(address _pair) external onlyOwner {
1493     _isUniswapPair[_pair] = true;
1494   }
1495 
1496   function removeUniswapPair(address _pair) external onlyOwner {
1497     _isUniswapPair[_pair] = false;
1498   }
1499 
1500   function Airdrop(AirdropReceiver[] memory recipients) external onlyOwner {
1501     for (uint256 _i = 0; _i < recipients.length; _i++) {
1502       AirdropReceiver memory _user = recipients[_i];
1503       transferFrom(msg.sender, _user.addy, _user.amount);
1504     }
1505   }
1506 }