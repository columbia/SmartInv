1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 // Dependency file: @openzeppelin/contracts/utils/Context.sol
87 
88 
89 // pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 
112 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
113 
114 
115 // pragma solidity ^0.8.0;
116 
117 // import "@openzeppelin/contracts/utils/Context.sol";
118 
119 /**
120  * @dev Contract module which provides a basic access control mechanism, where
121  * there is an account (an owner) that can be granted exclusive access to
122  * specific functions.
123  *
124  * By default, the owner account will be the one that deploys the contract. This
125  * can later be changed with {transferOwnership}.
126  *
127  * This module is used through inheritance. It will make available the modifier
128  * `onlyOwner`, which can be applied to your functions to restrict their use to
129  * the owner.
130  */
131 abstract contract Ownable is Context {
132     address private _owner;
133 
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136     /**
137      * @dev Initializes the contract setting the deployer as the initial owner.
138      */
139     constructor() {
140         _setOwner(_msgSender());
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if called by any account other than the owner.
152      */
153     modifier onlyOwner() {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     /**
159      * @dev Leaves the contract without owner. It will not be possible to call
160      * `onlyOwner` functions anymore. Can only be called by the current owner.
161      *
162      * NOTE: Renouncing ownership will leave the contract without an owner,
163      * thereby removing any functionality that is only available to the owner.
164      */
165     function renounceOwnership() public virtual onlyOwner {
166         _setOwner(address(0));
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         _setOwner(newOwner);
176     }
177 
178     function _setOwner(address newOwner) private {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 
186 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
187 
188 
189 // pragma solidity ^0.8.0;
190 
191 // CAUTION
192 // This version of SafeMath should only be used with Solidity 0.8 or later,
193 // because it relies on the compiler's built in overflow checks.
194 
195 /**
196  * @dev Wrappers over Solidity's arithmetic operations.
197  *
198  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
199  * now has built in overflow checking.
200  */
201 library SafeMath {
202     /**
203      * @dev Returns the addition of two unsigned integers, with an overflow flag.
204      *
205      * _Available since v3.4._
206      */
207     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
208         unchecked {
209             uint256 c = a + b;
210             if (c < a) return (false, 0);
211             return (true, c);
212         }
213     }
214 
215     /**
216      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
217      *
218      * _Available since v3.4._
219      */
220     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         unchecked {
222             if (b > a) return (false, 0);
223             return (true, a - b);
224         }
225     }
226 
227     /**
228      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
229      *
230      * _Available since v3.4._
231      */
232     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
233         unchecked {
234             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
235             // benefit is lost if 'b' is also tested.
236             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
237             if (a == 0) return (true, 0);
238             uint256 c = a * b;
239             if (c / a != b) return (false, 0);
240             return (true, c);
241         }
242     }
243 
244     /**
245      * @dev Returns the division of two unsigned integers, with a division by zero flag.
246      *
247      * _Available since v3.4._
248      */
249     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b == 0) return (false, 0);
252             return (true, a / b);
253         }
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
258      *
259      * _Available since v3.4._
260      */
261     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             if (b == 0) return (false, 0);
264             return (true, a % b);
265         }
266     }
267 
268     /**
269      * @dev Returns the addition of two unsigned integers, reverting on
270      * overflow.
271      *
272      * Counterpart to Solidity's `+` operator.
273      *
274      * Requirements:
275      *
276      * - Addition cannot overflow.
277      */
278     function add(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a + b;
280     }
281 
282     /**
283      * @dev Returns the subtraction of two unsigned integers, reverting on
284      * overflow (when the result is negative).
285      *
286      * Counterpart to Solidity's `-` operator.
287      *
288      * Requirements:
289      *
290      * - Subtraction cannot overflow.
291      */
292     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a - b;
294     }
295 
296     /**
297      * @dev Returns the multiplication of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `*` operator.
301      *
302      * Requirements:
303      *
304      * - Multiplication cannot overflow.
305      */
306     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a * b;
308     }
309 
310     /**
311      * @dev Returns the integer division of two unsigned integers, reverting on
312      * division by zero. The result is rounded towards zero.
313      *
314      * Counterpart to Solidity's `/` operator.
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function div(uint256 a, uint256 b) internal pure returns (uint256) {
321         return a / b;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * reverting when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
337         return a % b;
338     }
339 
340     /**
341      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
342      * overflow (when the result is negative).
343      *
344      * CAUTION: This function is deprecated because it requires allocating memory for the error
345      * message unnecessarily. For custom revert reasons use {trySub}.
346      *
347      * Counterpart to Solidity's `-` operator.
348      *
349      * Requirements:
350      *
351      * - Subtraction cannot overflow.
352      */
353     function sub(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b <= a, errorMessage);
360             return a - b;
361         }
362     }
363 
364     /**
365      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
366      * division by zero. The result is rounded towards zero.
367      *
368      * Counterpart to Solidity's `/` operator. Note: this function uses a
369      * `revert` opcode (which leaves remaining gas untouched) while Solidity
370      * uses an invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      *
374      * - The divisor cannot be zero.
375      */
376     function div(
377         uint256 a,
378         uint256 b,
379         string memory errorMessage
380     ) internal pure returns (uint256) {
381         unchecked {
382             require(b > 0, errorMessage);
383             return a / b;
384         }
385     }
386 
387     /**
388      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
389      * reverting with custom message when dividing by zero.
390      *
391      * CAUTION: This function is deprecated because it requires allocating memory for the error
392      * message unnecessarily. For custom revert reasons use {tryMod}.
393      *
394      * Counterpart to Solidity's `%` operator. This function uses a `revert`
395      * opcode (which leaves remaining gas untouched) while Solidity uses an
396      * invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      *
400      * - The divisor cannot be zero.
401      */
402     function mod(
403         uint256 a,
404         uint256 b,
405         string memory errorMessage
406     ) internal pure returns (uint256) {
407         unchecked {
408             require(b > 0, errorMessage);
409             return a % b;
410         }
411     }
412 }
413 
414 
415 // Dependency file: @openzeppelin/contracts/utils/Address.sol
416 
417 
418 // pragma solidity ^0.8.0;
419 
420 /**
421  * @dev Collection of functions related to the address type
422  */
423 library Address {
424     /**
425      * @dev Returns true if `account` is a contract.
426      *
427      * [IMPORTANT]
428      * ====
429      * It is unsafe to assume that an address for which this function returns
430      * false is an externally-owned account (EOA) and not a contract.
431      *
432      * Among others, `isContract` will return false for the following
433      * types of addresses:
434      *
435      *  - an externally-owned account
436      *  - a contract in construction
437      *  - an address where a contract will be created
438      *  - an address where a contract lived, but was destroyed
439      * ====
440      */
441     function isContract(address account) internal view returns (bool) {
442         // This method relies on extcodesize, which returns 0 for contracts in
443         // construction, since the code is only stored at the end of the
444         // constructor execution.
445 
446         uint256 size;
447         assembly {
448             size := extcodesize(account)
449         }
450         return size > 0;
451     }
452 
453     /**
454      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
455      * `recipient`, forwarding all available gas and reverting on errors.
456      *
457      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
458      * of certain opcodes, possibly making contracts go over the 2300 gas limit
459      * imposed by `transfer`, making them unable to receive funds via
460      * `transfer`. {sendValue} removes this limitation.
461      *
462      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
463      *
464      * IMPORTANT: because control is transferred to `recipient`, care must be
465      * taken to not create reentrancy vulnerabilities. Consider using
466      * {ReentrancyGuard} or the
467      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
468      */
469     function sendValue(address payable recipient, uint256 amount) internal {
470         require(address(this).balance >= amount, "Address: insufficient balance");
471 
472         (bool success, ) = recipient.call{value: amount}("");
473         require(success, "Address: unable to send value, recipient may have reverted");
474     }
475 
476     /**
477      * @dev Performs a Solidity function call using a low level `call`. A
478      * plain `call` is an unsafe replacement for a function call: use this
479      * function instead.
480      *
481      * If `target` reverts with a revert reason, it is bubbled up by this
482      * function (like regular Solidity function calls).
483      *
484      * Returns the raw returned data. To convert to the expected return value,
485      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
486      *
487      * Requirements:
488      *
489      * - `target` must be a contract.
490      * - calling `target` with `data` must not revert.
491      *
492      * _Available since v3.1._
493      */
494     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
495         return functionCall(target, data, "Address: low-level call failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
500      * `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, 0, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but also transferring `value` wei to `target`.
515      *
516      * Requirements:
517      *
518      * - the calling contract must have an ETH balance of at least `value`.
519      * - the called Solidity function must be `payable`.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(
524         address target,
525         bytes memory data,
526         uint256 value
527     ) internal returns (bytes memory) {
528         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
533      * with `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCallWithValue(
538         address target,
539         bytes memory data,
540         uint256 value,
541         string memory errorMessage
542     ) internal returns (bytes memory) {
543         require(address(this).balance >= value, "Address: insufficient balance for call");
544         require(isContract(target), "Address: call to non-contract");
545 
546         (bool success, bytes memory returndata) = target.call{value: value}(data);
547         return verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
557         return functionStaticCall(target, data, "Address: low-level static call failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
562      * but performing a static call.
563      *
564      * _Available since v3.3._
565      */
566     function functionStaticCall(
567         address target,
568         bytes memory data,
569         string memory errorMessage
570     ) internal view returns (bytes memory) {
571         require(isContract(target), "Address: static call to non-contract");
572 
573         (bool success, bytes memory returndata) = target.staticcall(data);
574         return verifyCallResult(success, returndata, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but performing a delegate call.
580      *
581      * _Available since v3.4._
582      */
583     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
584         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
589      * but performing a delegate call.
590      *
591      * _Available since v3.4._
592      */
593     function functionDelegateCall(
594         address target,
595         bytes memory data,
596         string memory errorMessage
597     ) internal returns (bytes memory) {
598         require(isContract(target), "Address: delegate call to non-contract");
599 
600         (bool success, bytes memory returndata) = target.delegatecall(data);
601         return verifyCallResult(success, returndata, errorMessage);
602     }
603 
604     /**
605      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
606      * revert reason using the provided one.
607      *
608      * _Available since v4.3._
609      */
610     function verifyCallResult(
611         bool success,
612         bytes memory returndata,
613         string memory errorMessage
614     ) internal pure returns (bytes memory) {
615         if (success) {
616             return returndata;
617         } else {
618             // Look for revert reason and bubble it up if present
619             if (returndata.length > 0) {
620                 // The easiest way to bubble the revert reason is using memory via assembly
621 
622                 assembly {
623                     let returndata_size := mload(returndata)
624                     revert(add(32, returndata), returndata_size)
625                 }
626             } else {
627                 revert(errorMessage);
628             }
629         }
630     }
631 }
632 
633 
634 // Dependency file: contracts/interfaces/IUniswapV2Router02.sol
635 
636 // pragma solidity >=0.6.2;
637 
638 interface IUniswapV2Router01 {
639     function factory() external pure returns (address);
640 
641     function WETH() external pure returns (address);
642 
643     function addLiquidity(
644         address tokenA,
645         address tokenB,
646         uint256 amountADesired,
647         uint256 amountBDesired,
648         uint256 amountAMin,
649         uint256 amountBMin,
650         address to,
651         uint256 deadline
652     )
653         external
654         returns (
655             uint256 amountA,
656             uint256 amountB,
657             uint256 liquidity
658         );
659 
660     function addLiquidityETH(
661         address token,
662         uint256 amountTokenDesired,
663         uint256 amountTokenMin,
664         uint256 amountETHMin,
665         address to,
666         uint256 deadline
667     )
668         external
669         payable
670         returns (
671             uint256 amountToken,
672             uint256 amountETH,
673             uint256 liquidity
674         );
675 
676     function removeLiquidity(
677         address tokenA,
678         address tokenB,
679         uint256 liquidity,
680         uint256 amountAMin,
681         uint256 amountBMin,
682         address to,
683         uint256 deadline
684     ) external returns (uint256 amountA, uint256 amountB);
685 
686     function removeLiquidityETH(
687         address token,
688         uint256 liquidity,
689         uint256 amountTokenMin,
690         uint256 amountETHMin,
691         address to,
692         uint256 deadline
693     ) external returns (uint256 amountToken, uint256 amountETH);
694 
695     function removeLiquidityWithPermit(
696         address tokenA,
697         address tokenB,
698         uint256 liquidity,
699         uint256 amountAMin,
700         uint256 amountBMin,
701         address to,
702         uint256 deadline,
703         bool approveMax,
704         uint8 v,
705         bytes32 r,
706         bytes32 s
707     ) external returns (uint256 amountA, uint256 amountB);
708 
709     function removeLiquidityETHWithPermit(
710         address token,
711         uint256 liquidity,
712         uint256 amountTokenMin,
713         uint256 amountETHMin,
714         address to,
715         uint256 deadline,
716         bool approveMax,
717         uint8 v,
718         bytes32 r,
719         bytes32 s
720     ) external returns (uint256 amountToken, uint256 amountETH);
721 
722     function swapExactTokensForTokens(
723         uint256 amountIn,
724         uint256 amountOutMin,
725         address[] calldata path,
726         address to,
727         uint256 deadline
728     ) external returns (uint256[] memory amounts);
729 
730     function swapTokensForExactTokens(
731         uint256 amountOut,
732         uint256 amountInMax,
733         address[] calldata path,
734         address to,
735         uint256 deadline
736     ) external returns (uint256[] memory amounts);
737 
738     function swapExactETHForTokens(
739         uint256 amountOutMin,
740         address[] calldata path,
741         address to,
742         uint256 deadline
743     ) external payable returns (uint256[] memory amounts);
744 
745     function swapTokensForExactETH(
746         uint256 amountOut,
747         uint256 amountInMax,
748         address[] calldata path,
749         address to,
750         uint256 deadline
751     ) external returns (uint256[] memory amounts);
752 
753     function swapExactTokensForETH(
754         uint256 amountIn,
755         uint256 amountOutMin,
756         address[] calldata path,
757         address to,
758         uint256 deadline
759     ) external returns (uint256[] memory amounts);
760 
761     function swapETHForExactTokens(
762         uint256 amountOut,
763         address[] calldata path,
764         address to,
765         uint256 deadline
766     ) external payable returns (uint256[] memory amounts);
767 
768     function quote(
769         uint256 amountA,
770         uint256 reserveA,
771         uint256 reserveB
772     ) external pure returns (uint256 amountB);
773 
774     function getAmountOut(
775         uint256 amountIn,
776         uint256 reserveIn,
777         uint256 reserveOut
778     ) external pure returns (uint256 amountOut);
779 
780     function getAmountIn(
781         uint256 amountOut,
782         uint256 reserveIn,
783         uint256 reserveOut
784     ) external pure returns (uint256 amountIn);
785 
786     function getAmountsOut(uint256 amountIn, address[] calldata path)
787         external
788         view
789         returns (uint256[] memory amounts);
790 
791     function getAmountsIn(uint256 amountOut, address[] calldata path)
792         external
793         view
794         returns (uint256[] memory amounts);
795 }
796 
797 interface IUniswapV2Router02 is IUniswapV2Router01 {
798     function removeLiquidityETHSupportingFeeOnTransferTokens(
799         address token,
800         uint256 liquidity,
801         uint256 amountTokenMin,
802         uint256 amountETHMin,
803         address to,
804         uint256 deadline
805     ) external returns (uint256 amountETH);
806 
807     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
808         address token,
809         uint256 liquidity,
810         uint256 amountTokenMin,
811         uint256 amountETHMin,
812         address to,
813         uint256 deadline,
814         bool approveMax,
815         uint8 v,
816         bytes32 r,
817         bytes32 s
818     ) external returns (uint256 amountETH);
819 
820     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
821         uint256 amountIn,
822         uint256 amountOutMin,
823         address[] calldata path,
824         address to,
825         uint256 deadline
826     ) external;
827 
828     function swapExactETHForTokensSupportingFeeOnTransferTokens(
829         uint256 amountOutMin,
830         address[] calldata path,
831         address to,
832         uint256 deadline
833     ) external payable;
834 
835     function swapExactTokensForETHSupportingFeeOnTransferTokens(
836         uint256 amountIn,
837         uint256 amountOutMin,
838         address[] calldata path,
839         address to,
840         uint256 deadline
841     ) external;
842 }
843 
844 
845 // Dependency file: contracts/interfaces/IUniswapV2Factory.sol
846 
847 // pragma solidity >=0.5.0;
848 
849 interface IUniswapV2Factory {
850     event PairCreated(
851         address indexed token0,
852         address indexed token1,
853         address pair,
854         uint256
855     );
856 
857     function feeTo() external view returns (address);
858 
859     function feeToSetter() external view returns (address);
860 
861     function getPair(address tokenA, address tokenB)
862         external
863         view
864         returns (address pair);
865 
866     function allPairs(uint256) external view returns (address pair);
867 
868     function allPairsLength() external view returns (uint256);
869 
870     function createPair(address tokenA, address tokenB)
871         external
872         returns (address pair);
873 
874     function setFeeTo(address) external;
875 
876     function setFeeToSetter(address) external;
877 }
878 
879 
880 // Dependency file: contracts/BaseToken.sol
881 
882 // pragma solidity =0.8.4;
883 
884 enum TokenType {
885     standard,
886     antiBotStandard,
887     liquidityGenerator,
888     antiBotLiquidityGenerator,
889     baby,
890     antiBotBaby,
891     buybackBaby,
892     antiBotBuybackBaby
893 }
894 
895 abstract contract BaseToken {
896     event TokenCreated(
897         address indexed owner,
898         address indexed token,
899         TokenType tokenType,
900         uint256 version
901     );
902 }
903 
904 
905 // Root file: contracts/liquidity-generator/LiquidityGeneratorToken.sol
906 
907 pragma solidity =0.8.4;
908 
909 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
910 // import "@openzeppelin/contracts/access/Ownable.sol";
911 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
912 // import "@openzeppelin/contracts/utils/Address.sol";
913 // import "contracts/interfaces/IUniswapV2Router02.sol";
914 // import "contracts/interfaces/IUniswapV2Factory.sol";
915 // import "contracts/BaseToken.sol";
916 
917 contract LiquidityGeneratorToken is IERC20, Ownable, BaseToken {
918     using SafeMath for uint256;
919     using Address for address;
920 
921     uint256 public constant VERSION = 1;
922 
923     mapping(address => uint256) private _rOwned;
924     mapping(address => uint256) private _tOwned;
925     mapping(address => mapping(address => uint256)) private _allowances;
926 
927     mapping(address => bool) private _isExcludedFromFee;
928     mapping(address => bool) private _isExcluded;
929     address[] private _excluded;
930 
931     uint256 private constant MAX = ~uint256(0);
932     uint256 private _tTotal;
933     uint256 private _rTotal;
934     uint256 private _tFeeTotal;
935 
936     string private _name;
937     string private _symbol;
938     uint8 private _decimals;
939 
940     uint256 public _taxFee;
941     uint256 private _previousTaxFee = _taxFee;
942 
943     uint256 public _liquidityFee;
944     uint256 private _previousLiquidityFee = _liquidityFee;
945 
946     uint256 public _charityFee;
947     uint256 private _previousCharityFee = _charityFee;
948 
949     IUniswapV2Router02 public uniswapV2Router;
950     address public uniswapV2Pair;
951     address public _charityAddress;
952 
953     bool inSwapAndLiquify;
954     bool public swapAndLiquifyEnabled;
955 
956     uint256 private numTokensSellToAddToLiquidity;
957 
958     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
959     event SwapAndLiquifyEnabledUpdated(bool enabled);
960     event SwapAndLiquify(
961         uint256 tokensSwapped,
962         uint256 ethReceived,
963         uint256 tokensIntoLiqudity
964     );
965 
966     modifier lockTheSwap() {
967         inSwapAndLiquify = true;
968         _;
969         inSwapAndLiquify = false;
970     }
971 
972     constructor(
973         string memory name_,
974         string memory symbol_,
975         uint256 totalSupply_,
976         address router_,
977         address charityAddress_,
978         uint16 taxFeeBps_,
979         uint16 liquidityFeeBps_,
980         uint16 charityFeeBps_,
981         address serviceFeeReceiver_,
982         uint256 serviceFee_
983     ) payable {
984         require(taxFeeBps_ >= 0, "Invalid tax fee");
985         require(liquidityFeeBps_ >= 0, "Invalid liquidity fee");
986         require(charityFeeBps_ >= 0, "Invalid charity fee");
987         if (charityAddress_ == address(0)) {
988             require(
989                 charityFeeBps_ == 0,
990                 "Cant set both charity address to address 0 and charity percent more than 0"
991             );
992         }
993         require(
994             taxFeeBps_ + liquidityFeeBps_ + charityFeeBps_ <= 10**4 / 4,
995             "Total fee is over 25%"
996         );
997 
998         _name = name_;
999         _symbol = symbol_;
1000         _decimals = 9;
1001 
1002         _tTotal = totalSupply_;
1003         _rTotal = (MAX - (MAX % _tTotal));
1004 
1005         _taxFee = taxFeeBps_;
1006         _previousTaxFee = _taxFee;
1007 
1008         _liquidityFee = liquidityFeeBps_;
1009         _previousLiquidityFee = _liquidityFee;
1010 
1011         _charityAddress = charityAddress_;
1012         _charityFee = charityFeeBps_;
1013         _previousCharityFee = _charityFee;
1014 
1015         numTokensSellToAddToLiquidity = totalSupply_.mul(5).div(10**4); // 0.05%
1016 
1017         swapAndLiquifyEnabled = true;
1018 
1019         _rOwned[owner()] = _rTotal;
1020 
1021         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router_);
1022         // Create a uniswap pair for this new token
1023         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1024             .createPair(address(this), _uniswapV2Router.WETH());
1025 
1026         // set the rest of the contract variables
1027         uniswapV2Router = _uniswapV2Router;
1028 
1029         // exclude owner and this contract from fee
1030         _isExcludedFromFee[owner()] = true;
1031         _isExcludedFromFee[address(this)] = true;
1032 
1033         emit Transfer(address(0), owner(), _tTotal);
1034 
1035         emit TokenCreated(
1036             owner(),
1037             address(this),
1038             TokenType.liquidityGenerator,
1039             VERSION
1040         );
1041 
1042         payable(serviceFeeReceiver_).transfer(serviceFee_);
1043     }
1044 
1045     function name() public view returns (string memory) {
1046         return _name;
1047     }
1048 
1049     function symbol() public view returns (string memory) {
1050         return _symbol;
1051     }
1052 
1053     function decimals() public view returns (uint8) {
1054         return _decimals;
1055     }
1056 
1057     function totalSupply() public view override returns (uint256) {
1058         return _tTotal;
1059     }
1060 
1061     function balanceOf(address account) public view override returns (uint256) {
1062         if (_isExcluded[account]) return _tOwned[account];
1063         return tokenFromReflection(_rOwned[account]);
1064     }
1065 
1066     function transfer(address recipient, uint256 amount)
1067         public
1068         override
1069         returns (bool)
1070     {
1071         _transfer(_msgSender(), recipient, amount);
1072         return true;
1073     }
1074 
1075     function allowance(address owner, address spender)
1076         public
1077         view
1078         override
1079         returns (uint256)
1080     {
1081         return _allowances[owner][spender];
1082     }
1083 
1084     function approve(address spender, uint256 amount)
1085         public
1086         override
1087         returns (bool)
1088     {
1089         _approve(_msgSender(), spender, amount);
1090         return true;
1091     }
1092 
1093     function transferFrom(
1094         address sender,
1095         address recipient,
1096         uint256 amount
1097     ) public override returns (bool) {
1098         _transfer(sender, recipient, amount);
1099         _approve(
1100             sender,
1101             _msgSender(),
1102             _allowances[sender][_msgSender()].sub(
1103                 amount,
1104                 "ERC20: transfer amount exceeds allowance"
1105             )
1106         );
1107         return true;
1108     }
1109 
1110     function increaseAllowance(address spender, uint256 addedValue)
1111         public
1112         virtual
1113         returns (bool)
1114     {
1115         _approve(
1116             _msgSender(),
1117             spender,
1118             _allowances[_msgSender()][spender].add(addedValue)
1119         );
1120         return true;
1121     }
1122 
1123     function decreaseAllowance(address spender, uint256 subtractedValue)
1124         public
1125         virtual
1126         returns (bool)
1127     {
1128         _approve(
1129             _msgSender(),
1130             spender,
1131             _allowances[_msgSender()][spender].sub(
1132                 subtractedValue,
1133                 "ERC20: decreased allowance below zero"
1134             )
1135         );
1136         return true;
1137     }
1138 
1139     function isExcludedFromReward(address account) public view returns (bool) {
1140         return _isExcluded[account];
1141     }
1142 
1143     function totalFees() public view returns (uint256) {
1144         return _tFeeTotal;
1145     }
1146 
1147     function deliver(uint256 tAmount) public {
1148         address sender = _msgSender();
1149         require(
1150             !_isExcluded[sender],
1151             "Excluded addresses cannot call this function"
1152         );
1153         (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1154         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1155         _rTotal = _rTotal.sub(rAmount);
1156         _tFeeTotal = _tFeeTotal.add(tAmount);
1157     }
1158 
1159     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1160         public
1161         view
1162         returns (uint256)
1163     {
1164         require(tAmount <= _tTotal, "Amount must be less than supply");
1165         if (!deductTransferFee) {
1166             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1167             return rAmount;
1168         } else {
1169             (, uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
1170             return rTransferAmount;
1171         }
1172     }
1173 
1174     function tokenFromReflection(uint256 rAmount)
1175         public
1176         view
1177         returns (uint256)
1178     {
1179         require(
1180             rAmount <= _rTotal,
1181             "Amount must be less than total reflections"
1182         );
1183         uint256 currentRate = _getRate();
1184         return rAmount.div(currentRate);
1185     }
1186 
1187     function excludeFromReward(address account) public onlyOwner {
1188         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1189         require(!_isExcluded[account], "Account is already excluded");
1190         if (_rOwned[account] > 0) {
1191             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1192         }
1193         _isExcluded[account] = true;
1194         _excluded.push(account);
1195     }
1196 
1197     function includeInReward(address account) external onlyOwner {
1198         require(_isExcluded[account], "Account is already excluded");
1199         for (uint256 i = 0; i < _excluded.length; i++) {
1200             if (_excluded[i] == account) {
1201                 _excluded[i] = _excluded[_excluded.length - 1];
1202                 _tOwned[account] = 0;
1203                 _isExcluded[account] = false;
1204                 _excluded.pop();
1205                 break;
1206             }
1207         }
1208     }
1209 
1210     function _transferBothExcluded(
1211         address sender,
1212         address recipient,
1213         uint256 tAmount
1214     ) private {
1215         (
1216             uint256 rAmount,
1217             uint256 rTransferAmount,
1218             uint256 rFee,
1219             uint256 tTransferAmount,
1220             uint256 tFee,
1221             uint256 tLiquidity,
1222             uint256 tCharity
1223         ) = _getValues(tAmount);
1224         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1225         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1226         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1227         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1228         _takeLiquidity(tLiquidity);
1229         _takeCharityFee(tCharity);
1230         _reflectFee(rFee, tFee);
1231         emit Transfer(sender, recipient, tTransferAmount);
1232     }
1233 
1234     function excludeFromFee(address account) public onlyOwner {
1235         _isExcludedFromFee[account] = true;
1236     }
1237 
1238     function includeInFee(address account) public onlyOwner {
1239         _isExcludedFromFee[account] = false;
1240     }
1241 
1242     function setTaxFeePercent(uint256 taxFeeBps) external onlyOwner {
1243         _taxFee = taxFeeBps;
1244         require(
1245             _taxFee + _liquidityFee + _charityFee <= 10**4 / 4,
1246             "Total fee is over 25%"
1247         );
1248     }
1249 
1250     function setLiquidityFeePercent(uint256 liquidityFeeBps)
1251         external
1252         onlyOwner
1253     {
1254         _liquidityFee = liquidityFeeBps;
1255         require(
1256             _taxFee + _liquidityFee + _charityFee <= 10**4 / 4,
1257             "Total fee is over 25%"
1258         );
1259     }
1260 
1261     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1262         swapAndLiquifyEnabled = _enabled;
1263         emit SwapAndLiquifyEnabledUpdated(_enabled);
1264     }
1265 
1266     //to recieve ETH from uniswapV2Router when swaping
1267     receive() external payable {}
1268 
1269     function _reflectFee(uint256 rFee, uint256 tFee) private {
1270         _rTotal = _rTotal.sub(rFee);
1271         _tFeeTotal = _tFeeTotal.add(tFee);
1272     }
1273 
1274     function _getValues(uint256 tAmount)
1275         private
1276         view
1277         returns (
1278             uint256,
1279             uint256,
1280             uint256,
1281             uint256,
1282             uint256,
1283             uint256,
1284             uint256
1285         )
1286     {
1287         (
1288             uint256 tTransferAmount,
1289             uint256 tFee,
1290             uint256 tLiquidity,
1291             uint256 tCharity
1292         ) = _getTValues(tAmount);
1293         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1294             tAmount,
1295             tFee,
1296             tLiquidity,
1297             tCharity,
1298             _getRate()
1299         );
1300         return (
1301             rAmount,
1302             rTransferAmount,
1303             rFee,
1304             tTransferAmount,
1305             tFee,
1306             tLiquidity,
1307             tCharity
1308         );
1309     }
1310 
1311     function _getTValues(uint256 tAmount)
1312         private
1313         view
1314         returns (
1315             uint256,
1316             uint256,
1317             uint256,
1318             uint256
1319         )
1320     {
1321         uint256 tFee = calculateTaxFee(tAmount);
1322         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1323         uint256 tCharityFee = calculateCharityFee(tAmount);
1324         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(
1325             tCharityFee
1326         );
1327         return (tTransferAmount, tFee, tLiquidity, tCharityFee);
1328     }
1329 
1330     function _getRValues(
1331         uint256 tAmount,
1332         uint256 tFee,
1333         uint256 tLiquidity,
1334         uint256 tCharity,
1335         uint256 currentRate
1336     )
1337         private
1338         pure
1339         returns (
1340             uint256,
1341             uint256,
1342             uint256
1343         )
1344     {
1345         uint256 rAmount = tAmount.mul(currentRate);
1346         uint256 rFee = tFee.mul(currentRate);
1347         uint256 rLiquidity = tLiquidity.mul(currentRate);
1348         uint256 rCharity = tCharity.mul(currentRate);
1349         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(
1350             rCharity
1351         );
1352         return (rAmount, rTransferAmount, rFee);
1353     }
1354 
1355     function _getRate() private view returns (uint256) {
1356         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1357         return rSupply.div(tSupply);
1358     }
1359 
1360     function _getCurrentSupply() private view returns (uint256, uint256) {
1361         uint256 rSupply = _rTotal;
1362         uint256 tSupply = _tTotal;
1363         for (uint256 i = 0; i < _excluded.length; i++) {
1364             if (
1365                 _rOwned[_excluded[i]] > rSupply ||
1366                 _tOwned[_excluded[i]] > tSupply
1367             ) return (_rTotal, _tTotal);
1368             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1369             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1370         }
1371         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1372         return (rSupply, tSupply);
1373     }
1374 
1375     function _takeLiquidity(uint256 tLiquidity) private {
1376         uint256 currentRate = _getRate();
1377         uint256 rLiquidity = tLiquidity.mul(currentRate);
1378         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1379         if (_isExcluded[address(this)])
1380             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1381     }
1382 
1383     function _takeCharityFee(uint256 tCharity) private {
1384         if (tCharity > 0) {
1385             uint256 currentRate = _getRate();
1386             uint256 rCharity = tCharity.mul(currentRate);
1387             _rOwned[_charityAddress] = _rOwned[_charityAddress].add(rCharity);
1388             if (_isExcluded[_charityAddress])
1389                 _tOwned[_charityAddress] = _tOwned[_charityAddress].add(
1390                     tCharity
1391                 );
1392             emit Transfer(_msgSender(), _charityAddress, tCharity);
1393         }
1394     }
1395 
1396     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1397         return _amount.mul(_taxFee).div(10**4);
1398     }
1399 
1400     function calculateLiquidityFee(uint256 _amount)
1401         private
1402         view
1403         returns (uint256)
1404     {
1405         return _amount.mul(_liquidityFee).div(10**4);
1406     }
1407 
1408     function calculateCharityFee(uint256 _amount)
1409         private
1410         view
1411         returns (uint256)
1412     {
1413         if (_charityAddress == address(0)) return 0;
1414         return _amount.mul(_charityFee).div(10**4);
1415     }
1416 
1417     function removeAllFee() private {
1418         if (_taxFee == 0 && _liquidityFee == 0 && _charityFee == 0) return;
1419 
1420         _previousTaxFee = _taxFee;
1421         _previousLiquidityFee = _liquidityFee;
1422         _previousCharityFee = _charityFee;
1423 
1424         _taxFee = 0;
1425         _liquidityFee = 0;
1426         _charityFee = 0;
1427     }
1428 
1429     function restoreAllFee() private {
1430         _taxFee = _previousTaxFee;
1431         _liquidityFee = _previousLiquidityFee;
1432         _charityFee = _previousCharityFee;
1433     }
1434 
1435     function isExcludedFromFee(address account) public view returns (bool) {
1436         return _isExcludedFromFee[account];
1437     }
1438 
1439     function _approve(
1440         address owner,
1441         address spender,
1442         uint256 amount
1443     ) private {
1444         require(owner != address(0), "ERC20: approve from the zero address");
1445         require(spender != address(0), "ERC20: approve to the zero address");
1446 
1447         _allowances[owner][spender] = amount;
1448         emit Approval(owner, spender, amount);
1449     }
1450 
1451     function _transfer(
1452         address from,
1453         address to,
1454         uint256 amount
1455     ) private {
1456         require(from != address(0), "ERC20: transfer from the zero address");
1457         require(to != address(0), "ERC20: transfer to the zero address");
1458         require(amount > 0, "Transfer amount must be greater than zero");
1459 
1460         // is the token balance of this contract address over the min number of
1461         // tokens that we need to initiate a swap + liquidity lock?
1462         // also, don't get caught in a circular liquidity event.
1463         // also, don't swap & liquify if sender is uniswap pair.
1464         uint256 contractTokenBalance = balanceOf(address(this));
1465 
1466         bool overMinTokenBalance = contractTokenBalance >=
1467             numTokensSellToAddToLiquidity;
1468         if (
1469             overMinTokenBalance &&
1470             !inSwapAndLiquify &&
1471             from != uniswapV2Pair &&
1472             swapAndLiquifyEnabled
1473         ) {
1474             contractTokenBalance = numTokensSellToAddToLiquidity;
1475             //add liquidity
1476             swapAndLiquify(contractTokenBalance);
1477         }
1478 
1479         //indicates if fee should be deducted from transfer
1480         bool takeFee = true;
1481 
1482         //if any account belongs to _isExcludedFromFee account then remove the fee
1483         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1484             takeFee = false;
1485         }
1486 
1487         //transfer amount, it will take tax, burn, liquidity fee
1488         _tokenTransfer(from, to, amount, takeFee);
1489     }
1490 
1491     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1492         // split the contract balance into halves
1493         uint256 half = contractTokenBalance.div(2);
1494         uint256 otherHalf = contractTokenBalance.sub(half);
1495 
1496         // capture the contract's current ETH balance.
1497         // this is so that we can capture exactly the amount of ETH that the
1498         // swap creates, and not make the liquidity event include any ETH that
1499         // has been manually sent to the contract
1500         uint256 initialBalance = address(this).balance;
1501 
1502         // swap tokens for ETH
1503         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1504 
1505         // how much ETH did we just swap into?
1506         uint256 newBalance = address(this).balance.sub(initialBalance);
1507 
1508         // add liquidity to uniswap
1509         addLiquidity(otherHalf, newBalance);
1510 
1511         emit SwapAndLiquify(half, newBalance, otherHalf);
1512     }
1513 
1514     function swapTokensForEth(uint256 tokenAmount) private {
1515         // generate the uniswap pair path of token -> weth
1516         address[] memory path = new address[](2);
1517         path[0] = address(this);
1518         path[1] = uniswapV2Router.WETH();
1519 
1520         _approve(address(this), address(uniswapV2Router), tokenAmount);
1521 
1522         // make the swap
1523         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1524             tokenAmount,
1525             0, // accept any amount of ETH
1526             path,
1527             address(this),
1528             block.timestamp
1529         );
1530     }
1531 
1532     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1533         // approve token transfer to cover all possible scenarios
1534         _approve(address(this), address(uniswapV2Router), tokenAmount);
1535 
1536         // add the liquidity
1537         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1538             address(this),
1539             tokenAmount,
1540             0, // slippage is unavoidable
1541             0, // slippage is unavoidable
1542             owner(),
1543             block.timestamp
1544         );
1545     }
1546 
1547     //this method is responsible for taking all fee, if takeFee is true
1548     function _tokenTransfer(
1549         address sender,
1550         address recipient,
1551         uint256 amount,
1552         bool takeFee
1553     ) private {
1554         if (!takeFee) removeAllFee();
1555 
1556         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1557             _transferFromExcluded(sender, recipient, amount);
1558         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1559             _transferToExcluded(sender, recipient, amount);
1560         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1561             _transferStandard(sender, recipient, amount);
1562         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1563             _transferBothExcluded(sender, recipient, amount);
1564         } else {
1565             _transferStandard(sender, recipient, amount);
1566         }
1567 
1568         if (!takeFee) restoreAllFee();
1569     }
1570 
1571     function _transferStandard(
1572         address sender,
1573         address recipient,
1574         uint256 tAmount
1575     ) private {
1576         (
1577             uint256 rAmount,
1578             uint256 rTransferAmount,
1579             uint256 rFee,
1580             uint256 tTransferAmount,
1581             uint256 tFee,
1582             uint256 tLiquidity,
1583             uint256 tCharity
1584         ) = _getValues(tAmount);
1585         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1586         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1587         _takeLiquidity(tLiquidity);
1588         _takeCharityFee(tCharity);
1589         _reflectFee(rFee, tFee);
1590         emit Transfer(sender, recipient, tTransferAmount);
1591     }
1592 
1593     function _transferToExcluded(
1594         address sender,
1595         address recipient,
1596         uint256 tAmount
1597     ) private {
1598         (
1599             uint256 rAmount,
1600             uint256 rTransferAmount,
1601             uint256 rFee,
1602             uint256 tTransferAmount,
1603             uint256 tFee,
1604             uint256 tLiquidity,
1605             uint256 tCharity
1606         ) = _getValues(tAmount);
1607         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1608         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1609         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1610         _takeLiquidity(tLiquidity);
1611         _takeCharityFee(tCharity);
1612         _reflectFee(rFee, tFee);
1613         emit Transfer(sender, recipient, tTransferAmount);
1614     }
1615 
1616     function _transferFromExcluded(
1617         address sender,
1618         address recipient,
1619         uint256 tAmount
1620     ) private {
1621         (
1622             uint256 rAmount,
1623             uint256 rTransferAmount,
1624             uint256 rFee,
1625             uint256 tTransferAmount,
1626             uint256 tFee,
1627             uint256 tLiquidity,
1628             uint256 tCharity
1629         ) = _getValues(tAmount);
1630         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1631         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1632         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1633         _takeLiquidity(tLiquidity);
1634         _takeCharityFee(tCharity);
1635         _reflectFee(rFee, tFee);
1636         emit Transfer(sender, recipient, tTransferAmount);
1637     }
1638 }