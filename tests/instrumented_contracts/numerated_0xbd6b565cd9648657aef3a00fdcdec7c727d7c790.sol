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
937     uint256 public constant VERSION = 2;
938 
939     uint256 public constant MAX_FEE = 10**4 / 4;
940 
941     mapping(address => uint256) private _rOwned;
942     mapping(address => uint256) private _tOwned;
943     mapping(address => mapping(address => uint256)) private _allowances;
944 
945     mapping(address => bool) private _isExcludedFromFee;
946     mapping(address => bool) private _isExcluded;
947     address[] private _excluded;
948 
949     uint256 private constant MAX = ~uint256(0);
950     uint256 private _tTotal;
951     uint256 private _rTotal;
952     uint256 private _tFeeTotal;
953 
954     string private _name;
955     string private _symbol;
956     uint8 private _decimals;
957 
958     uint256 public _taxFee;
959     uint256 private _previousTaxFee;
960 
961     uint256 public _liquidityFee;
962     uint256 private _previousLiquidityFee;
963 
964     uint256 public _charityFee;
965     uint256 private _previousCharityFee;
966 
967     IUniswapV2Router02 public uniswapV2Router;
968     address public uniswapV2Pair;
969     address public _charityAddress;
970 
971     bool inSwapAndLiquify;
972     bool public swapAndLiquifyEnabled;
973 
974     uint256 private numTokensSellToAddToLiquidity;
975 
976     IPinkAntiBot public pinkAntiBot;
977     bool public enableAntiBot;
978 
979     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
980     event SwapAndLiquifyAmountUpdated(uint256 amount);
981     event SwapAndLiquify(
982         uint256 tokensSwapped,
983         uint256 ethReceived,
984         uint256 tokensIntoLiqudity
985     );
986 
987     modifier lockTheSwap() {
988         inSwapAndLiquify = true;
989         _;
990         inSwapAndLiquify = false;
991     }
992 
993     constructor(
994         string memory name_,
995         string memory symbol_,
996         uint256 totalSupply_,
997         address router_,
998         address charityAddress_,
999         uint16 taxFeeBps_,
1000         uint16 liquidityFeeBps_,
1001         uint16 charityFeeBps_,
1002         address pinkAntiBot_,
1003         address serviceFeeReceiver_,
1004         uint256 serviceFee_
1005     ) payable {
1006         if (charityAddress_ == address(0)) {
1007             require(
1008                 charityFeeBps_ == 0,
1009                 "Cant set both charity address to address 0 and charity percent more than 0"
1010             );
1011         }
1012         require(
1013             taxFeeBps_ + liquidityFeeBps_ + charityFeeBps_ <= MAX_FEE,
1014             "Total fee is over 25%"
1015         );
1016 
1017         pinkAntiBot = IPinkAntiBot(pinkAntiBot_);
1018         pinkAntiBot.setTokenOwner(owner());
1019         enableAntiBot = true;
1020 
1021         _name = name_;
1022         _symbol = symbol_;
1023         _decimals = 9;
1024 
1025         _tTotal = totalSupply_;
1026         _rTotal = (MAX - (MAX % _tTotal));
1027 
1028         _taxFee = taxFeeBps_;
1029         _previousTaxFee = _taxFee;
1030 
1031         _liquidityFee = liquidityFeeBps_;
1032         _previousLiquidityFee = _liquidityFee;
1033 
1034         _charityAddress = charityAddress_;
1035         _charityFee = charityFeeBps_;
1036         _previousCharityFee = _charityFee;
1037 
1038         numTokensSellToAddToLiquidity = totalSupply_.div(10**3); // 0.1%
1039 
1040         swapAndLiquifyEnabled = true;
1041 
1042         _rOwned[owner()] = _rTotal;
1043 
1044         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router_);
1045         // Create a uniswap pair for this new token
1046         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1047             .createPair(address(this), _uniswapV2Router.WETH());
1048 
1049         // set the rest of the contract variables
1050         uniswapV2Router = _uniswapV2Router;
1051 
1052         // exclude owner and this contract from fee
1053         _isExcludedFromFee[owner()] = true;
1054         _isExcludedFromFee[address(this)] = true;
1055 
1056         emit Transfer(address(0), owner(), _tTotal);
1057 
1058         emit TokenCreated(
1059             owner(),
1060             address(this),
1061             TokenType.antiBotLiquidityGenerator,
1062             VERSION
1063         );
1064 
1065         payable(serviceFeeReceiver_).transfer(serviceFee_);
1066     }
1067 
1068     function setEnableAntiBot(bool _enable) external onlyOwner {
1069         enableAntiBot = _enable;
1070     }
1071 
1072     function name() public view returns (string memory) {
1073         return _name;
1074     }
1075 
1076     function symbol() public view returns (string memory) {
1077         return _symbol;
1078     }
1079 
1080     function decimals() public view returns (uint8) {
1081         return _decimals;
1082     }
1083 
1084     function totalSupply() public view override returns (uint256) {
1085         return _tTotal;
1086     }
1087 
1088     function balanceOf(address account) public view override returns (uint256) {
1089         if (_isExcluded[account]) return _tOwned[account];
1090         return tokenFromReflection(_rOwned[account]);
1091     }
1092 
1093     function transfer(address recipient, uint256 amount)
1094         public
1095         override
1096         returns (bool)
1097     {
1098         _transfer(_msgSender(), recipient, amount);
1099         return true;
1100     }
1101 
1102     function allowance(address owner, address spender)
1103         public
1104         view
1105         override
1106         returns (uint256)
1107     {
1108         return _allowances[owner][spender];
1109     }
1110 
1111     function approve(address spender, uint256 amount)
1112         public
1113         override
1114         returns (bool)
1115     {
1116         _approve(_msgSender(), spender, amount);
1117         return true;
1118     }
1119 
1120     function transferFrom(
1121         address sender,
1122         address recipient,
1123         uint256 amount
1124     ) public override returns (bool) {
1125         _transfer(sender, recipient, amount);
1126         _approve(
1127             sender,
1128             _msgSender(),
1129             _allowances[sender][_msgSender()].sub(
1130                 amount,
1131                 "ERC20: transfer amount exceeds allowance"
1132             )
1133         );
1134         return true;
1135     }
1136 
1137     function increaseAllowance(address spender, uint256 addedValue)
1138         public
1139         virtual
1140         returns (bool)
1141     {
1142         _approve(
1143             _msgSender(),
1144             spender,
1145             _allowances[_msgSender()][spender].add(addedValue)
1146         );
1147         return true;
1148     }
1149 
1150     function decreaseAllowance(address spender, uint256 subtractedValue)
1151         public
1152         virtual
1153         returns (bool)
1154     {
1155         _approve(
1156             _msgSender(),
1157             spender,
1158             _allowances[_msgSender()][spender].sub(
1159                 subtractedValue,
1160                 "ERC20: decreased allowance below zero"
1161             )
1162         );
1163         return true;
1164     }
1165 
1166     function isExcludedFromReward(address account) public view returns (bool) {
1167         return _isExcluded[account];
1168     }
1169 
1170     function totalFees() public view returns (uint256) {
1171         return _tFeeTotal;
1172     }
1173 
1174     function deliver(uint256 tAmount) public {
1175         address sender = _msgSender();
1176         require(
1177             !_isExcluded[sender],
1178             "Excluded addresses cannot call this function"
1179         );
1180         (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1181         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1182         _rTotal = _rTotal.sub(rAmount);
1183         _tFeeTotal = _tFeeTotal.add(tAmount);
1184     }
1185 
1186     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1187         public
1188         view
1189         returns (uint256)
1190     {
1191         require(tAmount <= _tTotal, "Amount must be less than supply");
1192         if (!deductTransferFee) {
1193             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1194             return rAmount;
1195         } else {
1196             (, uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
1197             return rTransferAmount;
1198         }
1199     }
1200 
1201     function tokenFromReflection(uint256 rAmount)
1202         public
1203         view
1204         returns (uint256)
1205     {
1206         require(
1207             rAmount <= _rTotal,
1208             "Amount must be less than total reflections"
1209         );
1210         uint256 currentRate = _getRate();
1211         return rAmount.div(currentRate);
1212     }
1213 
1214     function excludeFromReward(address account) public onlyOwner {
1215         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1216         require(!_isExcluded[account], "Account is already excluded");
1217         if (_rOwned[account] > 0) {
1218             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1219         }
1220         _isExcluded[account] = true;
1221         _excluded.push(account);
1222     }
1223 
1224     function includeInReward(address account) external onlyOwner {
1225         require(_isExcluded[account], "Account is already excluded");
1226         for (uint256 i = 0; i < _excluded.length; i++) {
1227             if (_excluded[i] == account) {
1228                 _excluded[i] = _excluded[_excluded.length - 1];
1229                 _tOwned[account] = 0;
1230                 _isExcluded[account] = false;
1231                 _excluded.pop();
1232                 break;
1233             }
1234         }
1235     }
1236 
1237     function _transferBothExcluded(
1238         address sender,
1239         address recipient,
1240         uint256 tAmount
1241     ) private {
1242         (
1243             uint256 rAmount,
1244             uint256 rTransferAmount,
1245             uint256 rFee,
1246             uint256 tTransferAmount,
1247             uint256 tFee,
1248             uint256 tLiquidity,
1249             uint256 tCharity
1250         ) = _getValues(tAmount);
1251         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1252         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1253         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1254         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1255         _takeLiquidity(tLiquidity);
1256         _takeCharityFee(tCharity);
1257         _reflectFee(rFee, tFee);
1258         emit Transfer(sender, recipient, tTransferAmount);
1259     }
1260 
1261     function excludeFromFee(address account) public onlyOwner {
1262         _isExcludedFromFee[account] = true;
1263     }
1264 
1265     function setTaxFeePercent(uint256 taxFeeBps) external onlyOwner {
1266         _taxFee = taxFeeBps;
1267         require(
1268             _taxFee + _liquidityFee + _charityFee <= MAX_FEE,
1269             "Total fee is over 25%"
1270         );
1271     }
1272 
1273     function setLiquidityFeePercent(uint256 liquidityFeeBps)
1274         external
1275         onlyOwner
1276     {
1277         _liquidityFee = liquidityFeeBps;
1278         require(
1279             _taxFee + _liquidityFee + _charityFee <= MAX_FEE,
1280             "Total fee is over 25%"
1281         );
1282     }
1283 
1284     function setCharityFeePercent(uint256 charityFeeBps) external onlyOwner {
1285         _charityFee = charityFeeBps;
1286         require(
1287             _taxFee + _liquidityFee + _charityFee <= MAX_FEE,
1288             "Total fee is over 25%"
1289         );
1290     }
1291 
1292     function setSwapBackSettings(uint256 _amount) external onlyOwner {
1293         require(
1294             _amount >= totalSupply().mul(5).div(10**4),
1295             "Swapback amount should be at least 0.05% of total supply"
1296         );
1297         numTokensSellToAddToLiquidity = _amount;
1298         emit SwapAndLiquifyAmountUpdated(_amount);
1299     }
1300 
1301     //to recieve ETH from uniswapV2Router when swaping
1302     receive() external payable {}
1303 
1304     function _reflectFee(uint256 rFee, uint256 tFee) private {
1305         _rTotal = _rTotal.sub(rFee);
1306         _tFeeTotal = _tFeeTotal.add(tFee);
1307     }
1308 
1309     function _getValues(uint256 tAmount)
1310         private
1311         view
1312         returns (
1313             uint256,
1314             uint256,
1315             uint256,
1316             uint256,
1317             uint256,
1318             uint256,
1319             uint256
1320         )
1321     {
1322         (
1323             uint256 tTransferAmount,
1324             uint256 tFee,
1325             uint256 tLiquidity,
1326             uint256 tCharity
1327         ) = _getTValues(tAmount);
1328         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1329             tAmount,
1330             tFee,
1331             tLiquidity,
1332             tCharity,
1333             _getRate()
1334         );
1335         return (
1336             rAmount,
1337             rTransferAmount,
1338             rFee,
1339             tTransferAmount,
1340             tFee,
1341             tLiquidity,
1342             tCharity
1343         );
1344     }
1345 
1346     function _getTValues(uint256 tAmount)
1347         private
1348         view
1349         returns (
1350             uint256,
1351             uint256,
1352             uint256,
1353             uint256
1354         )
1355     {
1356         uint256 tFee = calculateTaxFee(tAmount);
1357         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1358         uint256 tCharityFee = calculateCharityFee(tAmount);
1359         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(
1360             tCharityFee
1361         );
1362         return (tTransferAmount, tFee, tLiquidity, tCharityFee);
1363     }
1364 
1365     function _getRValues(
1366         uint256 tAmount,
1367         uint256 tFee,
1368         uint256 tLiquidity,
1369         uint256 tCharity,
1370         uint256 currentRate
1371     )
1372         private
1373         pure
1374         returns (
1375             uint256,
1376             uint256,
1377             uint256
1378         )
1379     {
1380         uint256 rAmount = tAmount.mul(currentRate);
1381         uint256 rFee = tFee.mul(currentRate);
1382         uint256 rLiquidity = tLiquidity.mul(currentRate);
1383         uint256 rCharity = tCharity.mul(currentRate);
1384         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(
1385             rCharity
1386         );
1387         return (rAmount, rTransferAmount, rFee);
1388     }
1389 
1390     function _getRate() private view returns (uint256) {
1391         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1392         return rSupply.div(tSupply);
1393     }
1394 
1395     function _getCurrentSupply() private view returns (uint256, uint256) {
1396         uint256 rSupply = _rTotal;
1397         uint256 tSupply = _tTotal;
1398         for (uint256 i = 0; i < _excluded.length; i++) {
1399             if (
1400                 _rOwned[_excluded[i]] > rSupply ||
1401                 _tOwned[_excluded[i]] > tSupply
1402             ) return (_rTotal, _tTotal);
1403             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1404             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1405         }
1406         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1407         return (rSupply, tSupply);
1408     }
1409 
1410     function _takeLiquidity(uint256 tLiquidity) private {
1411         uint256 currentRate = _getRate();
1412         uint256 rLiquidity = tLiquidity.mul(currentRate);
1413         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1414         if (_isExcluded[address(this)])
1415             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1416     }
1417 
1418     function _takeCharityFee(uint256 tCharity) private {
1419         if (tCharity > 0) {
1420             uint256 currentRate = _getRate();
1421             uint256 rCharity = tCharity.mul(currentRate);
1422             _rOwned[_charityAddress] = _rOwned[_charityAddress].add(rCharity);
1423             if (_isExcluded[_charityAddress])
1424                 _tOwned[_charityAddress] = _tOwned[_charityAddress].add(
1425                     tCharity
1426                 );
1427             emit Transfer(_msgSender(), _charityAddress, tCharity);
1428         }
1429     }
1430 
1431     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1432         return _amount.mul(_taxFee).div(10**4);
1433     }
1434 
1435     function calculateLiquidityFee(uint256 _amount)
1436         private
1437         view
1438         returns (uint256)
1439     {
1440         return _amount.mul(_liquidityFee).div(10**4);
1441     }
1442 
1443     function calculateCharityFee(uint256 _amount)
1444         private
1445         view
1446         returns (uint256)
1447     {
1448         if (_charityAddress == address(0)) return 0;
1449         return _amount.mul(_charityFee).div(10**4);
1450     }
1451 
1452     function removeAllFee() private {
1453         _previousTaxFee = _taxFee;
1454         _previousLiquidityFee = _liquidityFee;
1455         _previousCharityFee = _charityFee;
1456 
1457         _taxFee = 0;
1458         _liquidityFee = 0;
1459         _charityFee = 0;
1460     }
1461 
1462     function restoreAllFee() private {
1463         _taxFee = _previousTaxFee;
1464         _liquidityFee = _previousLiquidityFee;
1465         _charityFee = _previousCharityFee;
1466     }
1467 
1468     function isExcludedFromFee(address account) public view returns (bool) {
1469         return _isExcludedFromFee[account];
1470     }
1471 
1472     function _approve(
1473         address owner,
1474         address spender,
1475         uint256 amount
1476     ) private {
1477         require(owner != address(0), "ERC20: approve from the zero address");
1478         require(spender != address(0), "ERC20: approve to the zero address");
1479 
1480         _allowances[owner][spender] = amount;
1481         emit Approval(owner, spender, amount);
1482     }
1483 
1484     function _transfer(
1485         address from,
1486         address to,
1487         uint256 amount
1488     ) private {
1489         require(from != address(0), "ERC20: transfer from the zero address");
1490         require(to != address(0), "ERC20: transfer to the zero address");
1491         require(amount > 0, "Transfer amount must be greater than zero");
1492 
1493         if (enableAntiBot) {
1494             pinkAntiBot.onPreTransferCheck(from, to, amount);
1495         }
1496 
1497         // is the token balance of this contract address over the min number of
1498         // tokens that we need to initiate a swap + liquidity lock?
1499         // also, don't get caught in a circular liquidity event.
1500         // also, don't swap & liquify if sender is uniswap pair.
1501         uint256 contractTokenBalance = balanceOf(address(this));
1502 
1503         bool overMinTokenBalance = contractTokenBalance >=
1504             numTokensSellToAddToLiquidity;
1505         if (
1506             overMinTokenBalance &&
1507             !inSwapAndLiquify &&
1508             from != uniswapV2Pair &&
1509             swapAndLiquifyEnabled
1510         ) {
1511             contractTokenBalance = numTokensSellToAddToLiquidity;
1512             //add liquidity
1513             swapAndLiquify(contractTokenBalance);
1514         }
1515 
1516         //indicates if fee should be deducted from transfer
1517         bool takeFee = true;
1518 
1519         //if any account belongs to _isExcludedFromFee account then remove the fee
1520         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1521             takeFee = false;
1522         }
1523 
1524         //transfer amount, it will take tax, burn, liquidity fee
1525         _tokenTransfer(from, to, amount, takeFee);
1526     }
1527 
1528     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1529         // split the contract balance into halves
1530         uint256 half = contractTokenBalance.div(2);
1531         uint256 otherHalf = contractTokenBalance.sub(half);
1532 
1533         // capture the contract's current ETH balance.
1534         // this is so that we can capture exactly the amount of ETH that the
1535         // swap creates, and not make the liquidity event include any ETH that
1536         // has been manually sent to the contract
1537         uint256 initialBalance = address(this).balance;
1538 
1539         // swap tokens for ETH
1540         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1541 
1542         // how much ETH did we just swap into?
1543         uint256 newBalance = address(this).balance.sub(initialBalance);
1544 
1545         // add liquidity to uniswap
1546         addLiquidity(otherHalf, newBalance);
1547 
1548         emit SwapAndLiquify(half, newBalance, otherHalf);
1549     }
1550 
1551     function swapTokensForEth(uint256 tokenAmount) private {
1552         // generate the uniswap pair path of token -> weth
1553         address[] memory path = new address[](2);
1554         path[0] = address(this);
1555         path[1] = uniswapV2Router.WETH();
1556 
1557         _approve(address(this), address(uniswapV2Router), tokenAmount);
1558 
1559         // make the swap
1560         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1561             tokenAmount,
1562             0, // accept any amount of ETH
1563             path,
1564             address(this),
1565             block.timestamp
1566         );
1567     }
1568 
1569     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1570         // approve token transfer to cover all possible scenarios
1571         _approve(address(this), address(uniswapV2Router), tokenAmount);
1572 
1573         // add the liquidity
1574         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1575             address(this),
1576             tokenAmount,
1577             0, // slippage is unavoidable
1578             0, // slippage is unavoidable
1579             address(0xdead),
1580             block.timestamp
1581         );
1582     }
1583 
1584     //this method is responsible for taking all fee, if takeFee is true
1585     function _tokenTransfer(
1586         address sender,
1587         address recipient,
1588         uint256 amount,
1589         bool takeFee
1590     ) private {
1591         if (!takeFee) removeAllFee();
1592 
1593         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1594             _transferFromExcluded(sender, recipient, amount);
1595         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1596             _transferToExcluded(sender, recipient, amount);
1597         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1598             _transferStandard(sender, recipient, amount);
1599         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1600             _transferBothExcluded(sender, recipient, amount);
1601         } else {
1602             _transferStandard(sender, recipient, amount);
1603         }
1604 
1605         if (!takeFee) restoreAllFee();
1606     }
1607 
1608     function _transferStandard(
1609         address sender,
1610         address recipient,
1611         uint256 tAmount
1612     ) private {
1613         (
1614             uint256 rAmount,
1615             uint256 rTransferAmount,
1616             uint256 rFee,
1617             uint256 tTransferAmount,
1618             uint256 tFee,
1619             uint256 tLiquidity,
1620             uint256 tCharity
1621         ) = _getValues(tAmount);
1622         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1623         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1624         _takeLiquidity(tLiquidity);
1625         _takeCharityFee(tCharity);
1626         _reflectFee(rFee, tFee);
1627         emit Transfer(sender, recipient, tTransferAmount);
1628     }
1629 
1630     function _transferToExcluded(
1631         address sender,
1632         address recipient,
1633         uint256 tAmount
1634     ) private {
1635         (
1636             uint256 rAmount,
1637             uint256 rTransferAmount,
1638             uint256 rFee,
1639             uint256 tTransferAmount,
1640             uint256 tFee,
1641             uint256 tLiquidity,
1642             uint256 tCharity
1643         ) = _getValues(tAmount);
1644         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1645         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1646         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1647         _takeLiquidity(tLiquidity);
1648         _takeCharityFee(tCharity);
1649         _reflectFee(rFee, tFee);
1650         emit Transfer(sender, recipient, tTransferAmount);
1651     }
1652 
1653     function _transferFromExcluded(
1654         address sender,
1655         address recipient,
1656         uint256 tAmount
1657     ) private {
1658         (
1659             uint256 rAmount,
1660             uint256 rTransferAmount,
1661             uint256 rFee,
1662             uint256 tTransferAmount,
1663             uint256 tFee,
1664             uint256 tLiquidity,
1665             uint256 tCharity
1666         ) = _getValues(tAmount);
1667         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1668         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1669         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1670         _takeLiquidity(tLiquidity);
1671         _takeCharityFee(tCharity);
1672         _reflectFee(rFee, tFee);
1673         emit Transfer(sender, recipient, tTransferAmount);
1674     }
1675 }