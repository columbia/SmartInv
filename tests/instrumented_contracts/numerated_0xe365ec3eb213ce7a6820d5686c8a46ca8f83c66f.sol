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
921     uint256 public constant VERSION = 2;
922 
923     uint256 public constant MAX_FEE = 10**4 / 4;
924 
925     mapping(address => uint256) private _rOwned;
926     mapping(address => uint256) private _tOwned;
927     mapping(address => mapping(address => uint256)) private _allowances;
928 
929     mapping(address => bool) private _isExcludedFromFee;
930     mapping(address => bool) private _isExcluded;
931     address[] private _excluded;
932 
933     uint256 private constant MAX = ~uint256(0);
934     uint256 private _tTotal;
935     uint256 private _rTotal;
936     uint256 private _tFeeTotal;
937 
938     string private _name;
939     string private _symbol;
940     uint8 private _decimals;
941 
942     uint256 public _taxFee;
943     uint256 private _previousTaxFee;
944 
945     uint256 public _liquidityFee;
946     uint256 private _previousLiquidityFee;
947 
948     uint256 public _charityFee;
949     uint256 private _previousCharityFee;
950 
951     IUniswapV2Router02 public uniswapV2Router;
952     address public uniswapV2Pair;
953     address public _charityAddress;
954 
955     bool inSwapAndLiquify;
956     bool public swapAndLiquifyEnabled;
957 
958     uint256 private numTokensSellToAddToLiquidity;
959 
960     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
961     event SwapAndLiquifyAmountUpdated(uint256 amount);
962     event SwapAndLiquify(
963         uint256 tokensSwapped,
964         uint256 ethReceived,
965         uint256 tokensIntoLiqudity
966     );
967 
968     modifier lockTheSwap() {
969         inSwapAndLiquify = true;
970         _;
971         inSwapAndLiquify = false;
972     }
973 
974     constructor(
975         string memory name_,
976         string memory symbol_,
977         uint256 totalSupply_,
978         address router_,
979         address charityAddress_,
980         uint16 taxFeeBps_,
981         uint16 liquidityFeeBps_,
982         uint16 charityFeeBps_,
983         address serviceFeeReceiver_,
984         uint256 serviceFee_
985     ) payable {
986         if (charityAddress_ == address(0)) {
987             require(
988                 charityFeeBps_ == 0,
989                 "Cant set both charity address to address 0 and charity percent more than 0"
990             );
991         }
992         require(
993             taxFeeBps_ + liquidityFeeBps_ + charityFeeBps_ <= MAX_FEE,
994             "Total fee is over 25%"
995         );
996 
997         _name = name_;
998         _symbol = symbol_;
999         _decimals = 9;
1000 
1001         _tTotal = totalSupply_;
1002         _rTotal = (MAX - (MAX % _tTotal));
1003 
1004         _taxFee = taxFeeBps_;
1005         _previousTaxFee = _taxFee;
1006 
1007         _liquidityFee = liquidityFeeBps_;
1008         _previousLiquidityFee = _liquidityFee;
1009 
1010         _charityAddress = charityAddress_;
1011         _charityFee = charityFeeBps_;
1012         _previousCharityFee = _charityFee;
1013 
1014         numTokensSellToAddToLiquidity = totalSupply_.div(10**3); // 0.1%
1015 
1016         swapAndLiquifyEnabled = true;
1017 
1018         _rOwned[owner()] = _rTotal;
1019 
1020         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router_);
1021         // Create a uniswap pair for this new token
1022         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1023             .createPair(address(this), _uniswapV2Router.WETH());
1024 
1025         // set the rest of the contract variables
1026         uniswapV2Router = _uniswapV2Router;
1027 
1028         // exclude owner and this contract from fee
1029         _isExcludedFromFee[owner()] = true;
1030         _isExcludedFromFee[address(this)] = true;
1031 
1032         emit Transfer(address(0), owner(), _tTotal);
1033 
1034         emit TokenCreated(
1035             owner(),
1036             address(this),
1037             TokenType.liquidityGenerator,
1038             VERSION
1039         );
1040 
1041         payable(serviceFeeReceiver_).transfer(serviceFee_);
1042     }
1043 
1044     function name() public view returns (string memory) {
1045         return _name;
1046     }
1047 
1048     function symbol() public view returns (string memory) {
1049         return _symbol;
1050     }
1051 
1052     function decimals() public view returns (uint8) {
1053         return _decimals;
1054     }
1055 
1056     function totalSupply() public view override returns (uint256) {
1057         return _tTotal;
1058     }
1059 
1060     function balanceOf(address account) public view override returns (uint256) {
1061         if (_isExcluded[account]) return _tOwned[account];
1062         return tokenFromReflection(_rOwned[account]);
1063     }
1064 
1065     function transfer(address recipient, uint256 amount)
1066         public
1067         override
1068         returns (bool)
1069     {
1070         _transfer(_msgSender(), recipient, amount);
1071         return true;
1072     }
1073 
1074     function allowance(address owner, address spender)
1075         public
1076         view
1077         override
1078         returns (uint256)
1079     {
1080         return _allowances[owner][spender];
1081     }
1082 
1083     function approve(address spender, uint256 amount)
1084         public
1085         override
1086         returns (bool)
1087     {
1088         _approve(_msgSender(), spender, amount);
1089         return true;
1090     }
1091 
1092     function transferFrom(
1093         address sender,
1094         address recipient,
1095         uint256 amount
1096     ) public override returns (bool) {
1097         _transfer(sender, recipient, amount);
1098         _approve(
1099             sender,
1100             _msgSender(),
1101             _allowances[sender][_msgSender()].sub(
1102                 amount,
1103                 "ERC20: transfer amount exceeds allowance"
1104             )
1105         );
1106         return true;
1107     }
1108 
1109     function increaseAllowance(address spender, uint256 addedValue)
1110         public
1111         virtual
1112         returns (bool)
1113     {
1114         _approve(
1115             _msgSender(),
1116             spender,
1117             _allowances[_msgSender()][spender].add(addedValue)
1118         );
1119         return true;
1120     }
1121 
1122     function decreaseAllowance(address spender, uint256 subtractedValue)
1123         public
1124         virtual
1125         returns (bool)
1126     {
1127         _approve(
1128             _msgSender(),
1129             spender,
1130             _allowances[_msgSender()][spender].sub(
1131                 subtractedValue,
1132                 "ERC20: decreased allowance below zero"
1133             )
1134         );
1135         return true;
1136     }
1137 
1138     function isExcludedFromReward(address account) public view returns (bool) {
1139         return _isExcluded[account];
1140     }
1141 
1142     function totalFees() public view returns (uint256) {
1143         return _tFeeTotal;
1144     }
1145 
1146     function deliver(uint256 tAmount) public {
1147         address sender = _msgSender();
1148         require(
1149             !_isExcluded[sender],
1150             "Excluded addresses cannot call this function"
1151         );
1152         (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1153         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1154         _rTotal = _rTotal.sub(rAmount);
1155         _tFeeTotal = _tFeeTotal.add(tAmount);
1156     }
1157 
1158     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1159         public
1160         view
1161         returns (uint256)
1162     {
1163         require(tAmount <= _tTotal, "Amount must be less than supply");
1164         if (!deductTransferFee) {
1165             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
1166             return rAmount;
1167         } else {
1168             (, uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
1169             return rTransferAmount;
1170         }
1171     }
1172 
1173     function tokenFromReflection(uint256 rAmount)
1174         public
1175         view
1176         returns (uint256)
1177     {
1178         require(
1179             rAmount <= _rTotal,
1180             "Amount must be less than total reflections"
1181         );
1182         uint256 currentRate = _getRate();
1183         return rAmount.div(currentRate);
1184     }
1185 
1186     function excludeFromReward(address account) public onlyOwner {
1187         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1188         require(!_isExcluded[account], "Account is already excluded");
1189         if (_rOwned[account] > 0) {
1190             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1191         }
1192         _isExcluded[account] = true;
1193         _excluded.push(account);
1194     }
1195 
1196     function includeInReward(address account) external onlyOwner {
1197         require(_isExcluded[account], "Account is already excluded");
1198         for (uint256 i = 0; i < _excluded.length; i++) {
1199             if (_excluded[i] == account) {
1200                 _excluded[i] = _excluded[_excluded.length - 1];
1201                 _tOwned[account] = 0;
1202                 _isExcluded[account] = false;
1203                 _excluded.pop();
1204                 break;
1205             }
1206         }
1207     }
1208 
1209     function _transferBothExcluded(
1210         address sender,
1211         address recipient,
1212         uint256 tAmount
1213     ) private {
1214         (
1215             uint256 rAmount,
1216             uint256 rTransferAmount,
1217             uint256 rFee,
1218             uint256 tTransferAmount,
1219             uint256 tFee,
1220             uint256 tLiquidity,
1221             uint256 tCharity
1222         ) = _getValues(tAmount);
1223         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1224         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1225         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1226         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1227         _takeLiquidity(tLiquidity);
1228         _takeCharityFee(tCharity);
1229         _reflectFee(rFee, tFee);
1230         emit Transfer(sender, recipient, tTransferAmount);
1231     }
1232 
1233     function excludeFromFee(address account) public onlyOwner {
1234         _isExcludedFromFee[account] = true;
1235     }
1236 
1237     function setTaxFeePercent(uint256 taxFeeBps) external onlyOwner {
1238         _taxFee = taxFeeBps;
1239         require(
1240             _taxFee + _liquidityFee + _charityFee <= MAX_FEE,
1241             "Total fee is over 25%"
1242         );
1243     }
1244 
1245     function setLiquidityFeePercent(uint256 liquidityFeeBps)
1246         external
1247         onlyOwner
1248     {
1249         _liquidityFee = liquidityFeeBps;
1250         require(
1251             _taxFee + _liquidityFee + _charityFee <= MAX_FEE,
1252             "Total fee is over 25%"
1253         );
1254     }
1255 
1256     function setCharityFeePercent(uint256 charityFeeBps) external onlyOwner {
1257         _charityFee = charityFeeBps;
1258         require(
1259             _taxFee + _liquidityFee + _charityFee <= MAX_FEE,
1260             "Total fee is over 25%"
1261         );
1262     }
1263 
1264     function setSwapBackSettings(uint256 _amount) external onlyOwner {
1265         require(
1266             _amount >= totalSupply().mul(5).div(10**4),
1267             "Swapback amount should be at least 0.05% of total supply"
1268         );
1269         numTokensSellToAddToLiquidity = _amount;
1270         emit SwapAndLiquifyAmountUpdated(_amount);
1271     }
1272 
1273     //to recieve ETH from uniswapV2Router when swaping
1274     receive() external payable {}
1275 
1276     function _reflectFee(uint256 rFee, uint256 tFee) private {
1277         _rTotal = _rTotal.sub(rFee);
1278         _tFeeTotal = _tFeeTotal.add(tFee);
1279     }
1280 
1281     function _getValues(uint256 tAmount)
1282         private
1283         view
1284         returns (
1285             uint256,
1286             uint256,
1287             uint256,
1288             uint256,
1289             uint256,
1290             uint256,
1291             uint256
1292         )
1293     {
1294         (
1295             uint256 tTransferAmount,
1296             uint256 tFee,
1297             uint256 tLiquidity,
1298             uint256 tCharity
1299         ) = _getTValues(tAmount);
1300         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1301             tAmount,
1302             tFee,
1303             tLiquidity,
1304             tCharity,
1305             _getRate()
1306         );
1307         return (
1308             rAmount,
1309             rTransferAmount,
1310             rFee,
1311             tTransferAmount,
1312             tFee,
1313             tLiquidity,
1314             tCharity
1315         );
1316     }
1317 
1318     function _getTValues(uint256 tAmount)
1319         private
1320         view
1321         returns (
1322             uint256,
1323             uint256,
1324             uint256,
1325             uint256
1326         )
1327     {
1328         uint256 tFee = calculateTaxFee(tAmount);
1329         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1330         uint256 tCharityFee = calculateCharityFee(tAmount);
1331         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(
1332             tCharityFee
1333         );
1334         return (tTransferAmount, tFee, tLiquidity, tCharityFee);
1335     }
1336 
1337     function _getRValues(
1338         uint256 tAmount,
1339         uint256 tFee,
1340         uint256 tLiquidity,
1341         uint256 tCharity,
1342         uint256 currentRate
1343     )
1344         private
1345         pure
1346         returns (
1347             uint256,
1348             uint256,
1349             uint256
1350         )
1351     {
1352         uint256 rAmount = tAmount.mul(currentRate);
1353         uint256 rFee = tFee.mul(currentRate);
1354         uint256 rLiquidity = tLiquidity.mul(currentRate);
1355         uint256 rCharity = tCharity.mul(currentRate);
1356         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(
1357             rCharity
1358         );
1359         return (rAmount, rTransferAmount, rFee);
1360     }
1361 
1362     function _getRate() private view returns (uint256) {
1363         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1364         return rSupply.div(tSupply);
1365     }
1366 
1367     function _getCurrentSupply() private view returns (uint256, uint256) {
1368         uint256 rSupply = _rTotal;
1369         uint256 tSupply = _tTotal;
1370         for (uint256 i = 0; i < _excluded.length; i++) {
1371             if (
1372                 _rOwned[_excluded[i]] > rSupply ||
1373                 _tOwned[_excluded[i]] > tSupply
1374             ) return (_rTotal, _tTotal);
1375             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1376             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1377         }
1378         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1379         return (rSupply, tSupply);
1380     }
1381 
1382     function _takeLiquidity(uint256 tLiquidity) private {
1383         uint256 currentRate = _getRate();
1384         uint256 rLiquidity = tLiquidity.mul(currentRate);
1385         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1386         if (_isExcluded[address(this)])
1387             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1388     }
1389 
1390     function _takeCharityFee(uint256 tCharity) private {
1391         if (tCharity > 0) {
1392             uint256 currentRate = _getRate();
1393             uint256 rCharity = tCharity.mul(currentRate);
1394             _rOwned[_charityAddress] = _rOwned[_charityAddress].add(rCharity);
1395             if (_isExcluded[_charityAddress])
1396                 _tOwned[_charityAddress] = _tOwned[_charityAddress].add(
1397                     tCharity
1398                 );
1399             emit Transfer(_msgSender(), _charityAddress, tCharity);
1400         }
1401     }
1402 
1403     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1404         return _amount.mul(_taxFee).div(10**4);
1405     }
1406 
1407     function calculateLiquidityFee(uint256 _amount)
1408         private
1409         view
1410         returns (uint256)
1411     {
1412         return _amount.mul(_liquidityFee).div(10**4);
1413     }
1414 
1415     function calculateCharityFee(uint256 _amount)
1416         private
1417         view
1418         returns (uint256)
1419     {
1420         if (_charityAddress == address(0)) return 0;
1421         return _amount.mul(_charityFee).div(10**4);
1422     }
1423 
1424     function removeAllFee() private {
1425         _previousTaxFee = _taxFee;
1426         _previousLiquidityFee = _liquidityFee;
1427         _previousCharityFee = _charityFee;
1428 
1429         _taxFee = 0;
1430         _liquidityFee = 0;
1431         _charityFee = 0;
1432     }
1433 
1434     function restoreAllFee() private {
1435         _taxFee = _previousTaxFee;
1436         _liquidityFee = _previousLiquidityFee;
1437         _charityFee = _previousCharityFee;
1438     }
1439 
1440     function isExcludedFromFee(address account) public view returns (bool) {
1441         return _isExcludedFromFee[account];
1442     }
1443 
1444     function _approve(
1445         address owner,
1446         address spender,
1447         uint256 amount
1448     ) private {
1449         require(owner != address(0), "ERC20: approve from the zero address");
1450         require(spender != address(0), "ERC20: approve to the zero address");
1451 
1452         _allowances[owner][spender] = amount;
1453         emit Approval(owner, spender, amount);
1454     }
1455 
1456     function _transfer(
1457         address from,
1458         address to,
1459         uint256 amount
1460     ) private {
1461         require(from != address(0), "ERC20: transfer from the zero address");
1462         require(to != address(0), "ERC20: transfer to the zero address");
1463         require(amount > 0, "Transfer amount must be greater than zero");
1464 
1465         // is the token balance of this contract address over the min number of
1466         // tokens that we need to initiate a swap + liquidity lock?
1467         // also, don't get caught in a circular liquidity event.
1468         // also, don't swap & liquify if sender is uniswap pair.
1469         uint256 contractTokenBalance = balanceOf(address(this));
1470 
1471         bool overMinTokenBalance = contractTokenBalance >=
1472             numTokensSellToAddToLiquidity;
1473         if (
1474             overMinTokenBalance &&
1475             !inSwapAndLiquify &&
1476             from != uniswapV2Pair &&
1477             swapAndLiquifyEnabled
1478         ) {
1479             contractTokenBalance = numTokensSellToAddToLiquidity;
1480             //add liquidity
1481             swapAndLiquify(contractTokenBalance);
1482         }
1483 
1484         //indicates if fee should be deducted from transfer
1485         bool takeFee = true;
1486 
1487         //if any account belongs to _isExcludedFromFee account then remove the fee
1488         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1489             takeFee = false;
1490         }
1491 
1492         //transfer amount, it will take tax, burn, liquidity fee
1493         _tokenTransfer(from, to, amount, takeFee);
1494     }
1495 
1496     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1497         // split the contract balance into halves
1498         uint256 half = contractTokenBalance.div(2);
1499         uint256 otherHalf = contractTokenBalance.sub(half);
1500 
1501         // capture the contract's current ETH balance.
1502         // this is so that we can capture exactly the amount of ETH that the
1503         // swap creates, and not make the liquidity event include any ETH that
1504         // has been manually sent to the contract
1505         uint256 initialBalance = address(this).balance;
1506 
1507         // swap tokens for ETH
1508         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1509 
1510         // how much ETH did we just swap into?
1511         uint256 newBalance = address(this).balance.sub(initialBalance);
1512 
1513         // add liquidity to uniswap
1514         addLiquidity(otherHalf, newBalance);
1515 
1516         emit SwapAndLiquify(half, newBalance, otherHalf);
1517     }
1518 
1519     function swapTokensForEth(uint256 tokenAmount) private {
1520         // generate the uniswap pair path of token -> weth
1521         address[] memory path = new address[](2);
1522         path[0] = address(this);
1523         path[1] = uniswapV2Router.WETH();
1524 
1525         _approve(address(this), address(uniswapV2Router), tokenAmount);
1526 
1527         // make the swap
1528         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1529             tokenAmount,
1530             0, // accept any amount of ETH
1531             path,
1532             address(this),
1533             block.timestamp
1534         );
1535     }
1536 
1537     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1538         // approve token transfer to cover all possible scenarios
1539         _approve(address(this), address(uniswapV2Router), tokenAmount);
1540 
1541         // add the liquidity
1542         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1543             address(this),
1544             tokenAmount,
1545             0, // slippage is unavoidable
1546             0, // slippage is unavoidable
1547             address(0xdead),
1548             block.timestamp
1549         );
1550     }
1551 
1552     //this method is responsible for taking all fee, if takeFee is true
1553     function _tokenTransfer(
1554         address sender,
1555         address recipient,
1556         uint256 amount,
1557         bool takeFee
1558     ) private {
1559         if (!takeFee) removeAllFee();
1560 
1561         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1562             _transferFromExcluded(sender, recipient, amount);
1563         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1564             _transferToExcluded(sender, recipient, amount);
1565         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1566             _transferStandard(sender, recipient, amount);
1567         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1568             _transferBothExcluded(sender, recipient, amount);
1569         } else {
1570             _transferStandard(sender, recipient, amount);
1571         }
1572 
1573         if (!takeFee) restoreAllFee();
1574     }
1575 
1576     function _transferStandard(
1577         address sender,
1578         address recipient,
1579         uint256 tAmount
1580     ) private {
1581         (
1582             uint256 rAmount,
1583             uint256 rTransferAmount,
1584             uint256 rFee,
1585             uint256 tTransferAmount,
1586             uint256 tFee,
1587             uint256 tLiquidity,
1588             uint256 tCharity
1589         ) = _getValues(tAmount);
1590         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1591         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1592         _takeLiquidity(tLiquidity);
1593         _takeCharityFee(tCharity);
1594         _reflectFee(rFee, tFee);
1595         emit Transfer(sender, recipient, tTransferAmount);
1596     }
1597 
1598     function _transferToExcluded(
1599         address sender,
1600         address recipient,
1601         uint256 tAmount
1602     ) private {
1603         (
1604             uint256 rAmount,
1605             uint256 rTransferAmount,
1606             uint256 rFee,
1607             uint256 tTransferAmount,
1608             uint256 tFee,
1609             uint256 tLiquidity,
1610             uint256 tCharity
1611         ) = _getValues(tAmount);
1612         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1613         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1614         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1615         _takeLiquidity(tLiquidity);
1616         _takeCharityFee(tCharity);
1617         _reflectFee(rFee, tFee);
1618         emit Transfer(sender, recipient, tTransferAmount);
1619     }
1620 
1621     function _transferFromExcluded(
1622         address sender,
1623         address recipient,
1624         uint256 tAmount
1625     ) private {
1626         (
1627             uint256 rAmount,
1628             uint256 rTransferAmount,
1629             uint256 rFee,
1630             uint256 tTransferAmount,
1631             uint256 tFee,
1632             uint256 tLiquidity,
1633             uint256 tCharity
1634         ) = _getValues(tAmount);
1635         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1636         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1637         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1638         _takeLiquidity(tLiquidity);
1639         _takeCharityFee(tCharity);
1640         _reflectFee(rFee, tFee);
1641         emit Transfer(sender, recipient, tTransferAmount);
1642     }
1643 }