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
880 // Dependency file: contracts/interfaces/IPinkAntiBot.sol
881 
882 // pragma solidity >=0.5.0;
883 
884 interface IPinkAntiBot {
885   function setTokenOwner(address owner) external;
886 
887   function onPreTransferCheck(
888     address from,
889     address to,
890     uint256 amount
891   ) external;
892 }
893 
894 
895 // Dependency file: contracts/BaseToken.sol
896 
897 // pragma solidity =0.8.4;
898 
899 enum TokenType {
900     standard,
901     antiBotStandard,
902     liquidityGenerator,
903     antiBotLiquidityGenerator,
904     baby,
905     antiBotBaby,
906     buybackBaby,
907     antiBotBuybackBaby
908 }
909 
910 abstract contract BaseToken {
911     event TokenCreated(
912         address indexed owner,
913         address indexed token,
914         TokenType tokenType,
915         uint256 version
916     );
917 }
918 
919 
920 // Root file: contracts/liquidity-generator/AntiBotLiquidityGeneratorToken.sol
921 
922 pragma solidity =0.8.4;
923 
924 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
925 // import "@openzeppelin/contracts/access/Ownable.sol";
926 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
927 // import "@openzeppelin/contracts/utils/Address.sol";
928 // import "contracts/interfaces/IUniswapV2Router02.sol";
929 // import "contracts/interfaces/IUniswapV2Factory.sol";
930 // import "contracts/interfaces/IPinkAntiBot.sol";
931 // import "contracts/BaseToken.sol";
932 
933 contract AntiBotLiquidityGeneratorToken is IERC20, Ownable, BaseToken {
934     using SafeMath for uint256;
935     using Address for address;
936 
937     uint256 public constant VERSION = 1;
938 
939     mapping(address => uint256) private _rOwned;
940     mapping(address => uint256) private _tOwned;
941     mapping(address => mapping(address => uint256)) private _allowances;
942 
943     mapping(address => bool) private _isExcludedFromFee;
944     mapping(address => bool) private _isExcluded;
945     address[] private _excluded;
946 
947     uint256 private constant MAX = ~uint256(0);
948     uint256 private _tTotal;
949     uint256 private _rTotal;
950     uint256 private _tFeeTotal;
951 
952     string private _name;
953     string private _symbol;
954     uint8 private _decimals;
955 
956     uint256 public _taxFee;
957     uint256 private _previousTaxFee = _taxFee;
958 
959     uint256 public _liquidityFee;
960     uint256 private _previousLiquidityFee = _liquidityFee;
961 
962     uint256 public _charityFee;
963     uint256 private _previousCharityFee = _charityFee;
964 
965     IUniswapV2Router02 public uniswapV2Router;
966     address public uniswapV2Pair;
967     address public _charityAddress;
968 
969     bool inSwapAndLiquify;
970     bool public swapAndLiquifyEnabled;
971 
972     uint256 private numTokensSellToAddToLiquidity;
973 
974     IPinkAntiBot public pinkAntiBot;
975     bool public enableAntiBot;
976 
977     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
978     event SwapAndLiquifyEnabledUpdated(bool enabled);
979     event SwapAndLiquify(
980         uint256 tokensSwapped,
981         uint256 ethReceived,
982         uint256 tokensIntoLiqudity
983     );
984 
985     modifier lockTheSwap() {
986         inSwapAndLiquify = true;
987         _;
988         inSwapAndLiquify = false;
989     }
990 
991     constructor(
992         string memory name_,
993         string memory symbol_,
994         uint256 totalSupply_,
995         address router_,
996         address charityAddress_,
997         uint16 taxFeeBps_,
998         uint16 liquidityFeeBps_,
999         uint16 charityFeeBps_,
1000         address pinkAntiBot_,
1001         address serviceFeeReceiver_,
1002         uint256 serviceFee_
1003     ) payable {
1004         require(taxFeeBps_ >= 0 && taxFeeBps_ <= 10**4, "Invalid tax fee");
1005         require(
1006             liquidityFeeBps_ >= 0 && liquidityFeeBps_ <= 10**4,
1007             "Invalid liquidity fee"
1008         );
1009         require(
1010             charityFeeBps_ >= 0 && charityFeeBps_ <= 10**4,
1011             "Invalid charity fee"
1012         );
1013         if (charityAddress_ == address(0)) {
1014             require(
1015                 charityFeeBps_ == 0,
1016                 "Cant set both charity address to address 0 and charity percent more than 0"
1017             );
1018         }
1019         require(
1020             taxFeeBps_ + liquidityFeeBps_ + charityFeeBps_ <= 10**4,
1021             "Total fee is over 100% of transfer amount"
1022         );
1023 
1024         pinkAntiBot = IPinkAntiBot(pinkAntiBot_);
1025         pinkAntiBot.setTokenOwner(owner());
1026         enableAntiBot = true;
1027 
1028         _name = name_;
1029         _symbol = symbol_;
1030         _decimals = 9;
1031 
1032         _tTotal = totalSupply_;
1033         _rTotal = (MAX - (MAX % _tTotal));
1034 
1035         _taxFee = taxFeeBps_;
1036         _previousTaxFee = _taxFee;
1037 
1038         _liquidityFee = liquidityFeeBps_;
1039         _previousLiquidityFee = _liquidityFee;
1040 
1041         _charityAddress = charityAddress_;
1042         _charityFee = charityFeeBps_;
1043         _previousCharityFee = _charityFee;
1044 
1045         numTokensSellToAddToLiquidity = totalSupply_.mul(5).div(10**4); // 0.05%
1046 
1047         swapAndLiquifyEnabled = true;
1048 
1049         _rOwned[owner()] = _rTotal;
1050 
1051         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router_);
1052         // Create a uniswap pair for this new token
1053         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1054             .createPair(address(this), _uniswapV2Router.WETH());
1055 
1056         // set the rest of the contract variables
1057         uniswapV2Router = _uniswapV2Router;
1058 
1059         // exclude owner and this contract from fee
1060         _isExcludedFromFee[owner()] = true;
1061         _isExcludedFromFee[address(this)] = true;
1062 
1063         emit Transfer(address(0), owner(), _tTotal);
1064 
1065         emit TokenCreated(
1066             owner(),
1067             address(this),
1068             TokenType.antiBotLiquidityGenerator,
1069             VERSION
1070         );
1071 
1072         payable(serviceFeeReceiver_).transfer(serviceFee_);
1073     }
1074 
1075     function setEnableAntiBot(bool _enable) external onlyOwner {
1076         enableAntiBot = _enable;
1077     }
1078 
1079     function name() public view returns (string memory) {
1080         return _name;
1081     }
1082 
1083     function symbol() public view returns (string memory) {
1084         return _symbol;
1085     }
1086 
1087     function decimals() public view returns (uint8) {
1088         return _decimals;
1089     }
1090 
1091     function totalSupply() public view override returns (uint256) {
1092         return _tTotal;
1093     }
1094 
1095     function balanceOf(address account) public view override returns (uint256) {
1096         if (_isExcluded[account]) return _tOwned[account];
1097         return tokenFromReflection(_rOwned[account]);
1098     }
1099 
1100     function transfer(address recipient, uint256 amount)
1101         public
1102         override
1103         returns (bool)
1104     {
1105         _transfer(_msgSender(), recipient, amount);
1106         return true;
1107     }
1108 
1109     function allowance(address owner, address spender)
1110         public
1111         view
1112         override
1113         returns (uint256)
1114     {
1115         return _allowances[owner][spender];
1116     }
1117 
1118     function approve(address spender, uint256 amount)
1119         public
1120         override
1121         returns (bool)
1122     {
1123         _approve(_msgSender(), spender, amount);
1124         return true;
1125     }
1126 
1127     function transferFrom(
1128         address sender,
1129         address recipient,
1130         uint256 amount
1131     ) public override returns (bool) {
1132         _transfer(sender, recipient, amount);
1133         _approve(
1134             sender,
1135             _msgSender(),
1136             _allowances[sender][_msgSender()].sub(
1137                 amount,
1138                 "ERC20: transfer amount exceeds allowance"
1139             )
1140         );
1141         return true;
1142     }
1143 
1144     function increaseAllowance(address spender, uint256 addedValue)
1145         public
1146         virtual
1147         returns (bool)
1148     {
1149         _approve(
1150             _msgSender(),
1151             spender,
1152             _allowances[_msgSender()][spender].add(addedValue)
1153         );
1154         return true;
1155     }
1156 
1157     function decreaseAllowance(address spender, uint256 subtractedValue)
1158         public
1159         virtual
1160         returns (bool)
1161     {
1162         _approve(
1163             _msgSender(),
1164             spender,
1165             _allowances[_msgSender()][spender].sub(
1166                 subtractedValue,
1167                 "ERC20: decreased allowance below zero"
1168             )
1169         );
1170         return true;
1171     }
1172 
1173     function isExcludedFromReward(address account) public view returns (bool) {
1174         return _isExcluded[account];
1175     }
1176 
1177     function totalFees() public view returns (uint256) {
1178         return _tFeeTotal;
1179     }
1180 
1181     function deliver(uint256 tAmount) public {
1182         address sender = _msgSender();
1183         require(
1184             !_isExcluded[sender],
1185             "Excluded addresses cannot call this function"
1186         );
1187         (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1188         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1189         _rTotal = _rTotal.sub(rAmount);
1190         _tFeeTotal = _tFeeTotal.add(tAmount);
1191     }
1192 
1193     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1194         public
1195         view
1196         returns (uint256)
1197     {
1198         require(tAmount <= _tTotal, "Amount must be less than supply");
1199         if (!deductTransferFee) {
1200             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1201             return rAmount;
1202         } else {
1203             (, uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
1204             return rTransferAmount;
1205         }
1206     }
1207 
1208     function tokenFromReflection(uint256 rAmount)
1209         public
1210         view
1211         returns (uint256)
1212     {
1213         require(
1214             rAmount <= _rTotal,
1215             "Amount must be less than total reflections"
1216         );
1217         uint256 currentRate = _getRate();
1218         return rAmount.div(currentRate);
1219     }
1220 
1221     function excludeFromReward(address account) public onlyOwner {
1222         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1223         require(!_isExcluded[account], "Account is already excluded");
1224         if (_rOwned[account] > 0) {
1225             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1226         }
1227         _isExcluded[account] = true;
1228         _excluded.push(account);
1229     }
1230 
1231     function includeInReward(address account) external onlyOwner {
1232         require(_isExcluded[account], "Account is already excluded");
1233         for (uint256 i = 0; i < _excluded.length; i++) {
1234             if (_excluded[i] == account) {
1235                 _excluded[i] = _excluded[_excluded.length - 1];
1236                 _tOwned[account] = 0;
1237                 _isExcluded[account] = false;
1238                 _excluded.pop();
1239                 break;
1240             }
1241         }
1242     }
1243 
1244     function _transferBothExcluded(
1245         address sender,
1246         address recipient,
1247         uint256 tAmount
1248     ) private {
1249         (
1250             uint256 rAmount,
1251             uint256 rTransferAmount,
1252             uint256 rFee,
1253             uint256 tTransferAmount,
1254             uint256 tFee,
1255             uint256 tLiquidity,
1256             uint256 tCharity
1257         ) = _getValues(tAmount);
1258         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1259         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1260         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1261         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1262         _takeLiquidity(tLiquidity);
1263         _takeCharityFee(tCharity);
1264         _reflectFee(rFee, tFee);
1265         emit Transfer(sender, recipient, tTransferAmount);
1266     }
1267 
1268     function excludeFromFee(address account) public onlyOwner {
1269         _isExcludedFromFee[account] = true;
1270     }
1271 
1272     function includeInFee(address account) public onlyOwner {
1273         _isExcludedFromFee[account] = false;
1274     }
1275 
1276     function setTaxFeePercent(uint256 taxFeeBps) external onlyOwner {
1277         require(taxFeeBps >= 0 && taxFeeBps <= 10**4, "Invalid bps");
1278         _taxFee = taxFeeBps;
1279     }
1280 
1281     function setLiquidityFeePercent(uint256 liquidityFeeBps)
1282         external
1283         onlyOwner
1284     {
1285         require(
1286             liquidityFeeBps >= 0 && liquidityFeeBps <= 10**4,
1287             "Invalid bps"
1288         );
1289         _liquidityFee = liquidityFeeBps;
1290     }
1291 
1292     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1293         swapAndLiquifyEnabled = _enabled;
1294         emit SwapAndLiquifyEnabledUpdated(_enabled);
1295     }
1296 
1297     //to recieve ETH from uniswapV2Router when swaping
1298     receive() external payable {}
1299 
1300     function _reflectFee(uint256 rFee, uint256 tFee) private {
1301         _rTotal = _rTotal.sub(rFee);
1302         _tFeeTotal = _tFeeTotal.add(tFee);
1303     }
1304 
1305     function _getValues(uint256 tAmount)
1306         private
1307         view
1308         returns (
1309             uint256,
1310             uint256,
1311             uint256,
1312             uint256,
1313             uint256,
1314             uint256,
1315             uint256
1316         )
1317     {
1318         (
1319             uint256 tTransferAmount,
1320             uint256 tFee,
1321             uint256 tLiquidity,
1322             uint256 tCharity
1323         ) = _getTValues(tAmount);
1324         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1325             tAmount,
1326             tFee,
1327             tLiquidity,
1328             tCharity,
1329             _getRate()
1330         );
1331         return (
1332             rAmount,
1333             rTransferAmount,
1334             rFee,
1335             tTransferAmount,
1336             tFee,
1337             tLiquidity,
1338             tCharity
1339         );
1340     }
1341 
1342     function _getTValues(uint256 tAmount)
1343         private
1344         view
1345         returns (
1346             uint256,
1347             uint256,
1348             uint256,
1349             uint256
1350         )
1351     {
1352         uint256 tFee = calculateTaxFee(tAmount);
1353         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1354         uint256 tCharityFee = calculateCharityFee(tAmount);
1355         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(
1356             tCharityFee
1357         );
1358         return (tTransferAmount, tFee, tLiquidity, tCharityFee);
1359     }
1360 
1361     function _getRValues(
1362         uint256 tAmount,
1363         uint256 tFee,
1364         uint256 tLiquidity,
1365         uint256 tCharity,
1366         uint256 currentRate
1367     )
1368         private
1369         pure
1370         returns (
1371             uint256,
1372             uint256,
1373             uint256
1374         )
1375     {
1376         uint256 rAmount = tAmount.mul(currentRate);
1377         uint256 rFee = tFee.mul(currentRate);
1378         uint256 rLiquidity = tLiquidity.mul(currentRate);
1379         uint256 rCharity = tCharity.mul(currentRate);
1380         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(
1381             rCharity
1382         );
1383         return (rAmount, rTransferAmount, rFee);
1384     }
1385 
1386     function _getRate() private view returns (uint256) {
1387         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1388         return rSupply.div(tSupply);
1389     }
1390 
1391     function _getCurrentSupply() private view returns (uint256, uint256) {
1392         uint256 rSupply = _rTotal;
1393         uint256 tSupply = _tTotal;
1394         for (uint256 i = 0; i < _excluded.length; i++) {
1395             if (
1396                 _rOwned[_excluded[i]] > rSupply ||
1397                 _tOwned[_excluded[i]] > tSupply
1398             ) return (_rTotal, _tTotal);
1399             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1400             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1401         }
1402         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1403         return (rSupply, tSupply);
1404     }
1405 
1406     function _takeLiquidity(uint256 tLiquidity) private {
1407         uint256 currentRate = _getRate();
1408         uint256 rLiquidity = tLiquidity.mul(currentRate);
1409         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1410         if (_isExcluded[address(this)])
1411             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1412     }
1413 
1414     function _takeCharityFee(uint256 tCharity) private {
1415         if (tCharity > 0) {
1416             uint256 currentRate = _getRate();
1417             uint256 rCharity = tCharity.mul(currentRate);
1418             _rOwned[_charityAddress] = _rOwned[_charityAddress].add(rCharity);
1419             if (_isExcluded[_charityAddress])
1420                 _tOwned[_charityAddress] = _tOwned[_charityAddress].add(
1421                     tCharity
1422                 );
1423             emit Transfer(_msgSender(), _charityAddress, tCharity);
1424         }
1425     }
1426 
1427     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1428         return _amount.mul(_taxFee).div(10**4);
1429     }
1430 
1431     function calculateLiquidityFee(uint256 _amount)
1432         private
1433         view
1434         returns (uint256)
1435     {
1436         return _amount.mul(_liquidityFee).div(10**4);
1437     }
1438 
1439     function calculateCharityFee(uint256 _amount)
1440         private
1441         view
1442         returns (uint256)
1443     {
1444         if (_charityAddress == address(0)) return 0;
1445         return _amount.mul(_charityFee).div(10**4);
1446     }
1447 
1448     function removeAllFee() private {
1449         if (_taxFee == 0 && _liquidityFee == 0 && _charityFee == 0) return;
1450 
1451         _previousTaxFee = _taxFee;
1452         _previousLiquidityFee = _liquidityFee;
1453         _previousCharityFee = _charityFee;
1454 
1455         _taxFee = 0;
1456         _liquidityFee = 0;
1457         _charityFee = 0;
1458     }
1459 
1460     function restoreAllFee() private {
1461         _taxFee = _previousTaxFee;
1462         _liquidityFee = _previousLiquidityFee;
1463         _charityFee = _previousCharityFee;
1464     }
1465 
1466     function isExcludedFromFee(address account) public view returns (bool) {
1467         return _isExcludedFromFee[account];
1468     }
1469 
1470     function _approve(
1471         address owner,
1472         address spender,
1473         uint256 amount
1474     ) private {
1475         require(owner != address(0), "ERC20: approve from the zero address");
1476         require(spender != address(0), "ERC20: approve to the zero address");
1477 
1478         _allowances[owner][spender] = amount;
1479         emit Approval(owner, spender, amount);
1480     }
1481 
1482     function _transfer(
1483         address from,
1484         address to,
1485         uint256 amount
1486     ) private {
1487         require(from != address(0), "ERC20: transfer from the zero address");
1488         require(to != address(0), "ERC20: transfer to the zero address");
1489         require(amount > 0, "Transfer amount must be greater than zero");
1490 
1491         if (enableAntiBot) {
1492             pinkAntiBot.onPreTransferCheck(from, to, amount);
1493         }
1494 
1495         // is the token balance of this contract address over the min number of
1496         // tokens that we need to initiate a swap + liquidity lock?
1497         // also, don't get caught in a circular liquidity event.
1498         // also, don't swap & liquify if sender is uniswap pair.
1499         uint256 contractTokenBalance = balanceOf(address(this));
1500 
1501         bool overMinTokenBalance = contractTokenBalance >=
1502             numTokensSellToAddToLiquidity;
1503         if (
1504             overMinTokenBalance &&
1505             !inSwapAndLiquify &&
1506             from != uniswapV2Pair &&
1507             swapAndLiquifyEnabled
1508         ) {
1509             contractTokenBalance = numTokensSellToAddToLiquidity;
1510             //add liquidity
1511             swapAndLiquify(contractTokenBalance);
1512         }
1513 
1514         //indicates if fee should be deducted from transfer
1515         bool takeFee = true;
1516 
1517         //if any account belongs to _isExcludedFromFee account then remove the fee
1518         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1519             takeFee = false;
1520         }
1521 
1522         //transfer amount, it will take tax, burn, liquidity fee
1523         _tokenTransfer(from, to, amount, takeFee);
1524     }
1525 
1526     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1527         // split the contract balance into halves
1528         uint256 half = contractTokenBalance.div(2);
1529         uint256 otherHalf = contractTokenBalance.sub(half);
1530 
1531         // capture the contract's current ETH balance.
1532         // this is so that we can capture exactly the amount of ETH that the
1533         // swap creates, and not make the liquidity event include any ETH that
1534         // has been manually sent to the contract
1535         uint256 initialBalance = address(this).balance;
1536 
1537         // swap tokens for ETH
1538         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1539 
1540         // how much ETH did we just swap into?
1541         uint256 newBalance = address(this).balance.sub(initialBalance);
1542 
1543         // add liquidity to uniswap
1544         addLiquidity(otherHalf, newBalance);
1545 
1546         emit SwapAndLiquify(half, newBalance, otherHalf);
1547     }
1548 
1549     function swapTokensForEth(uint256 tokenAmount) private {
1550         // generate the uniswap pair path of token -> weth
1551         address[] memory path = new address[](2);
1552         path[0] = address(this);
1553         path[1] = uniswapV2Router.WETH();
1554 
1555         _approve(address(this), address(uniswapV2Router), tokenAmount);
1556 
1557         // make the swap
1558         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1559             tokenAmount,
1560             0, // accept any amount of ETH
1561             path,
1562             address(this),
1563             block.timestamp
1564         );
1565     }
1566 
1567     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1568         // approve token transfer to cover all possible scenarios
1569         _approve(address(this), address(uniswapV2Router), tokenAmount);
1570 
1571         // add the liquidity
1572         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1573             address(this),
1574             tokenAmount,
1575             0, // slippage is unavoidable
1576             0, // slippage is unavoidable
1577             owner(),
1578             block.timestamp
1579         );
1580     }
1581 
1582     //this method is responsible for taking all fee, if takeFee is true
1583     function _tokenTransfer(
1584         address sender,
1585         address recipient,
1586         uint256 amount,
1587         bool takeFee
1588     ) private {
1589         if (!takeFee) removeAllFee();
1590 
1591         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1592             _transferFromExcluded(sender, recipient, amount);
1593         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1594             _transferToExcluded(sender, recipient, amount);
1595         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1596             _transferStandard(sender, recipient, amount);
1597         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1598             _transferBothExcluded(sender, recipient, amount);
1599         } else {
1600             _transferStandard(sender, recipient, amount);
1601         }
1602 
1603         if (!takeFee) restoreAllFee();
1604     }
1605 
1606     function _transferStandard(
1607         address sender,
1608         address recipient,
1609         uint256 tAmount
1610     ) private {
1611         (
1612             uint256 rAmount,
1613             uint256 rTransferAmount,
1614             uint256 rFee,
1615             uint256 tTransferAmount,
1616             uint256 tFee,
1617             uint256 tLiquidity,
1618             uint256 tCharity
1619         ) = _getValues(tAmount);
1620         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1621         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1622         _takeLiquidity(tLiquidity);
1623         _takeCharityFee(tCharity);
1624         _reflectFee(rFee, tFee);
1625         emit Transfer(sender, recipient, tTransferAmount);
1626     }
1627 
1628     function _transferToExcluded(
1629         address sender,
1630         address recipient,
1631         uint256 tAmount
1632     ) private {
1633         (
1634             uint256 rAmount,
1635             uint256 rTransferAmount,
1636             uint256 rFee,
1637             uint256 tTransferAmount,
1638             uint256 tFee,
1639             uint256 tLiquidity,
1640             uint256 tCharity
1641         ) = _getValues(tAmount);
1642         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1643         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1644         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1645         _takeLiquidity(tLiquidity);
1646         _takeCharityFee(tCharity);
1647         _reflectFee(rFee, tFee);
1648         emit Transfer(sender, recipient, tTransferAmount);
1649     }
1650 
1651     function _transferFromExcluded(
1652         address sender,
1653         address recipient,
1654         uint256 tAmount
1655     ) private {
1656         (
1657             uint256 rAmount,
1658             uint256 rTransferAmount,
1659             uint256 rFee,
1660             uint256 tTransferAmount,
1661             uint256 tFee,
1662             uint256 tLiquidity,
1663             uint256 tCharity
1664         ) = _getValues(tAmount);
1665         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1666         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1667         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1668         _takeLiquidity(tLiquidity);
1669         _takeCharityFee(tCharity);
1670         _reflectFee(rFee, tFee);
1671         emit Transfer(sender, recipient, tTransferAmount);
1672     }
1673 }