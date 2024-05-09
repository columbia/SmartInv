1 /**
2  *Submitted for verification at BscScan.com on 2021-05-05
3  */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity >=0.6.0 <0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(
96             newOwner != address(0),
97             "Ownable: new owner is the zero address"
98         );
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/math/SafeMath.sol
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
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryAdd(uint256 a, uint256 b)
126         internal
127         pure
128         returns (bool, uint256)
129     {
130         uint256 c = a + b;
131         if (c < a) return (false, 0);
132         return (true, c);
133     }
134 
135     /**
136      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function trySub(uint256 a, uint256 b)
141         internal
142         pure
143         returns (bool, uint256)
144     {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b)
155         internal
156         pure
157         returns (bool, uint256)
158     {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) return (true, 0);
163         uint256 c = a * b;
164         if (c / a != b) return (false, 0);
165         return (true, c);
166     }
167 
168     /**
169      * @dev Returns the division of two unsigned integers, with a division by zero flag.
170      *
171      * _Available since v3.4._
172      */
173     function tryDiv(uint256 a, uint256 b)
174         internal
175         pure
176         returns (bool, uint256)
177     {
178         if (b == 0) return (false, 0);
179         return (true, a / b);
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryMod(uint256 a, uint256 b)
188         internal
189         pure
190         returns (bool, uint256)
191     {
192         if (b == 0) return (false, 0);
193         return (true, a % b);
194     }
195 
196     /**
197      * @dev Returns the addition of two unsigned integers, reverting on
198      * overflow.
199      *
200      * Counterpart to Solidity's `+` operator.
201      *
202      * Requirements:
203      *
204      * - Addition cannot overflow.
205      */
206     function add(uint256 a, uint256 b) internal pure returns (uint256) {
207         uint256 c = a + b;
208         require(c >= a, "SafeMath: addition overflow");
209         return c;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         require(b <= a, "SafeMath: subtraction overflow");
224         return a - b;
225     }
226 
227     /**
228      * @dev Returns the multiplication of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `*` operator.
232      *
233      * Requirements:
234      *
235      * - Multiplication cannot overflow.
236      */
237     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
238         if (a == 0) return 0;
239         uint256 c = a * b;
240         require(c / a == b, "SafeMath: multiplication overflow");
241         return c;
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers, reverting on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function div(uint256 a, uint256 b) internal pure returns (uint256) {
257         require(b > 0, "SafeMath: division by zero");
258         return a / b;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * reverting when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
274         require(b > 0, "SafeMath: modulo by zero");
275         return a % b;
276     }
277 
278     /**
279      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
280      * overflow (when the result is negative).
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {trySub}.
284      *
285      * Counterpart to Solidity's `-` operator.
286      *
287      * Requirements:
288      *
289      * - Subtraction cannot overflow.
290      */
291     function sub(
292         uint256 a,
293         uint256 b,
294         string memory errorMessage
295     ) internal pure returns (uint256) {
296         require(b <= a, errorMessage);
297         return a - b;
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
302      * division by zero. The result is rounded towards zero.
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {tryDiv}.
306      *
307      * Counterpart to Solidity's `/` operator. Note: this function uses a
308      * `revert` opcode (which leaves remaining gas untouched) while Solidity
309      * uses an invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function div(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a / b;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * reverting with custom message when dividing by zero.
327      *
328      * CAUTION: This function is deprecated because it requires allocating memory for the error
329      * message unnecessarily. For custom revert reasons use {tryMod}.
330      *
331      * Counterpart to Solidity's `%` operator. This function uses a `revert`
332      * opcode (which leaves remaining gas untouched) while Solidity uses an
333      * invalid opcode to revert (consuming all remaining gas).
334      *
335      * Requirements:
336      *
337      * - The divisor cannot be zero.
338      */
339     function mod(
340         uint256 a,
341         uint256 b,
342         string memory errorMessage
343     ) internal pure returns (uint256) {
344         require(b > 0, errorMessage);
345         return a % b;
346     }
347 }
348 
349 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
350 
351 /**
352  * @dev Contract module that helps prevent reentrant calls to a function.
353  *
354  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
355  * available, which can be applied to functions to make sure there are no nested
356  * (reentrant) calls to them.
357  *
358  * Note that because there is a single `nonReentrant` guard, functions marked as
359  * `nonReentrant` may not call one another. This can be worked around by making
360  * those functions `private`, and then adding `external` `nonReentrant` entry
361  * points to them.
362  *
363  * TIP: If you would like to learn more about reentrancy and alternative ways
364  * to protect against it, check out our blog post
365  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
366  */
367 abstract contract ReentrancyGuard {
368     // Booleans are more expensive than uint256 or any type that takes up a full
369     // word because each write operation emits an extra SLOAD to first read the
370     // slot's contents, replace the bits taken up by the boolean, and then write
371     // back. This is the compiler's defense against contract upgrades and
372     // pointer aliasing, and it cannot be disabled.
373 
374     // The values being non-zero value makes deployment a bit more expensive,
375     // but in exchange the refund on every call to nonReentrant will be lower in
376     // amount. Since refunds are capped to a percentage of the total
377     // transaction's gas, it is best to keep them low in cases like this one, to
378     // increase the likelihood of the full refund coming into effect.
379     uint256 private constant _NOT_ENTERED = 1;
380     uint256 private constant _ENTERED = 2;
381 
382     uint256 private _status;
383 
384     constructor() {
385         _status = _NOT_ENTERED;
386     }
387 
388     /**
389      * @dev Prevents a contract from calling itself, directly or indirectly.
390      * Calling a `nonReentrant` function from another `nonReentrant`
391      * function is not supported. It is possible to prevent this from happening
392      * by making the `nonReentrant` function external, and make it call a
393      * `private` function that does the actual work.
394      */
395     modifier nonReentrant() {
396         // On the first call to nonReentrant, _notEntered will be true
397         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
398 
399         // Any calls to nonReentrant after this point will fail
400         _status = _ENTERED;
401 
402         _;
403 
404         // By storing the original value once again, a refund is triggered (see
405         // https://eips.ethereum.org/EIPS/eip-2200)
406         _status = _NOT_ENTERED;
407     }
408 }
409 
410 // File: bsc-library/contracts/IBEP20.sol
411 
412 interface IBEP20 {
413     /**
414      * @dev Returns the amount of tokens in existence.
415      */
416     function totalSupply() external view returns (uint256);
417 
418     /**
419      * @dev Returns the token decimals.
420      */
421     function decimals() external view returns (uint8);
422 
423     /**
424      * @dev Returns the token symbol.
425      */
426     function symbol() external view returns (string memory);
427 
428     /**
429      * @dev Returns the token name.
430      */
431     function name() external view returns (string memory);
432 
433     /**
434      * @dev Returns the bep token owner.
435      */
436     function getOwner() external view returns (address);
437 
438     /**
439      * @dev Returns the amount of tokens owned by `account`.
440      */
441     function balanceOf(address account) external view returns (uint256);
442 
443     /**
444      * @dev Moves `amount` tokens from the caller's account to `recipient`.
445      *
446      * Returns a boolean value indicating whether the operation succeeded.
447      *
448      * Emits a {Transfer} event.
449      */
450     function transfer(address recipient, uint256 amount)
451         external
452         returns (bool);
453 
454     /**
455      * @dev Returns the remaining number of tokens that `spender` will be
456      * allowed to spend on behalf of `owner` through {transferFrom}. This is
457      * zero by default.
458      *
459      * This value changes when {approve} or {transferFrom} are called.
460      */
461     function allowance(address _owner, address spender)
462         external
463         view
464         returns (uint256);
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
468      *
469      * Returns a boolean value indicating whether the operation succeeded.
470      *
471      * IMPORTANT: Beware that changing an allowance with this method brings the risk
472      * that someone may use both the old and the new allowance by unfortunate
473      * transaction ordering. One possible solution to mitigate this race
474      * condition is to first reduce the spender's allowance to 0 and set the
475      * desired value afterwards:
476      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address spender, uint256 amount) external returns (bool);
481 
482     /**
483      * @dev Moves `amount` tokens from `sender` to `recipient` using the
484      * allowance mechanism. `amount` is then deducted from the caller's
485      * allowance.
486      *
487      * Returns a boolean value indicating whether the operation succeeded.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transferFrom(
492         address sender,
493         address recipient,
494         uint256 amount
495     ) external returns (bool);
496 
497     /**
498      * @dev Emitted when `value` tokens are moved from one account (`from`) to
499      * another (`to`).
500      *
501      * Note that `value` may be zero.
502      */
503     event Transfer(address indexed from, address indexed to, uint256 value);
504 
505     /**
506      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
507      * a call to {approve}. `value` is the new allowance.
508      */
509     event Approval(
510         address indexed owner,
511         address indexed spender,
512         uint256 value
513     );
514 }
515 
516 // File: @openzeppelin/contracts/utils/Address.sol
517 
518 /**
519  * @dev Collection of functions related to the address type
520  */
521 library Address {
522     /**
523      * @dev Returns true if `account` is a contract.
524      *
525      * [IMPORTANT]
526      * ====
527      * It is unsafe to assume that an address for which this function returns
528      * false is an externally-owned account (EOA) and not a contract.
529      *
530      * Among others, `isContract` will return false for the following
531      * types of addresses:
532      *
533      *  - an externally-owned account
534      *  - a contract in construction
535      *  - an address where a contract will be created
536      *  - an address where a contract lived, but was destroyed
537      * ====
538      */
539     function isContract(address account) internal view returns (bool) {
540         // This method relies on extcodesize, which returns 0 for contracts in
541         // construction, since the code is only stored at the end of the
542         // constructor execution.
543 
544         uint256 size;
545         // solhint-disable-next-line no-inline-assembly
546         assembly {
547             size := extcodesize(account)
548         }
549         return size > 0;
550     }
551 
552     /**
553      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
554      * `recipient`, forwarding all available gas and reverting on errors.
555      *
556      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
557      * of certain opcodes, possibly making contracts go over the 2300 gas limit
558      * imposed by `transfer`, making them unable to receive funds via
559      * `transfer`. {sendValue} removes this limitation.
560      *
561      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
562      *
563      * IMPORTANT: because control is transferred to `recipient`, care must be
564      * taken to not create reentrancy vulnerabilities. Consider using
565      * {ReentrancyGuard} or the
566      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
567      */
568     function sendValue(address payable recipient, uint256 amount) internal {
569         require(
570             address(this).balance >= amount,
571             "Address: insufficient balance"
572         );
573 
574         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
575         (bool success, ) = recipient.call{value: amount}("");
576         require(
577             success,
578             "Address: unable to send value, recipient may have reverted"
579         );
580     }
581 
582     /**
583      * @dev Performs a Solidity function call using a low level `call`. A
584      * plain`call` is an unsafe replacement for a function call: use this
585      * function instead.
586      *
587      * If `target` reverts with a revert reason, it is bubbled up by this
588      * function (like regular Solidity function calls).
589      *
590      * Returns the raw returned data. To convert to the expected return value,
591      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
592      *
593      * Requirements:
594      *
595      * - `target` must be a contract.
596      * - calling `target` with `data` must not revert.
597      *
598      * _Available since v3.1._
599      */
600     function functionCall(address target, bytes memory data)
601         internal
602         returns (bytes memory)
603     {
604         return functionCall(target, data, "Address: low-level call failed");
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
609      * `errorMessage` as a fallback revert reason when `target` reverts.
610      *
611      * _Available since v3.1._
612      */
613     function functionCall(
614         address target,
615         bytes memory data,
616         string memory errorMessage
617     ) internal returns (bytes memory) {
618         return functionCallWithValue(target, data, 0, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but also transferring `value` wei to `target`.
624      *
625      * Requirements:
626      *
627      * - the calling contract must have an ETH balance of at least `value`.
628      * - the called Solidity function must be `payable`.
629      *
630      * _Available since v3.1._
631      */
632     function functionCallWithValue(
633         address target,
634         bytes memory data,
635         uint256 value
636     ) internal returns (bytes memory) {
637         return
638             functionCallWithValue(
639                 target,
640                 data,
641                 value,
642                 "Address: low-level call with value failed"
643             );
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
648      * with `errorMessage` as a fallback revert reason when `target` reverts.
649      *
650      * _Available since v3.1._
651      */
652     function functionCallWithValue(
653         address target,
654         bytes memory data,
655         uint256 value,
656         string memory errorMessage
657     ) internal returns (bytes memory) {
658         require(
659             address(this).balance >= value,
660             "Address: insufficient balance for call"
661         );
662         require(isContract(target), "Address: call to non-contract");
663 
664         // solhint-disable-next-line avoid-low-level-calls
665         (bool success, bytes memory returndata) = target.call{value: value}(
666             data
667         );
668         return _verifyCallResult(success, returndata, errorMessage);
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
673      * but performing a static call.
674      *
675      * _Available since v3.3._
676      */
677     function functionStaticCall(address target, bytes memory data)
678         internal
679         view
680         returns (bytes memory)
681     {
682         return
683             functionStaticCall(
684                 target,
685                 data,
686                 "Address: low-level static call failed"
687             );
688     }
689 
690     /**
691      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
692      * but performing a static call.
693      *
694      * _Available since v3.3._
695      */
696     function functionStaticCall(
697         address target,
698         bytes memory data,
699         string memory errorMessage
700     ) internal view returns (bytes memory) {
701         require(isContract(target), "Address: static call to non-contract");
702 
703         // solhint-disable-next-line avoid-low-level-calls
704         (bool success, bytes memory returndata) = target.staticcall(data);
705         return _verifyCallResult(success, returndata, errorMessage);
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
710      * but performing a delegate call.
711      *
712      * _Available since v3.4._
713      */
714     function functionDelegateCall(address target, bytes memory data)
715         internal
716         returns (bytes memory)
717     {
718         return
719             functionDelegateCall(
720                 target,
721                 data,
722                 "Address: low-level delegate call failed"
723             );
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
728      * but performing a delegate call.
729      *
730      * _Available since v3.4._
731      */
732     function functionDelegateCall(
733         address target,
734         bytes memory data,
735         string memory errorMessage
736     ) internal returns (bytes memory) {
737         require(isContract(target), "Address: delegate call to non-contract");
738 
739         // solhint-disable-next-line avoid-low-level-calls
740         (bool success, bytes memory returndata) = target.delegatecall(data);
741         return _verifyCallResult(success, returndata, errorMessage);
742     }
743 
744     function _verifyCallResult(
745         bool success,
746         bytes memory returndata,
747         string memory errorMessage
748     ) private pure returns (bytes memory) {
749         if (success) {
750             return returndata;
751         } else {
752             // Look for revert reason and bubble it up if present
753             if (returndata.length > 0) {
754                 // The easiest way to bubble the revert reason is using memory via assembly
755 
756                 // solhint-disable-next-line no-inline-assembly
757                 assembly {
758                     let returndata_size := mload(returndata)
759                     revert(add(32, returndata), returndata_size)
760                 }
761             } else {
762                 revert(errorMessage);
763             }
764         }
765     }
766 }
767 
768 // File: bsc-library/contracts/SafeBEP20.sol
769 
770 /**
771  * @title SafeBEP20
772  * @dev Wrappers around BEP20 operations that throw on failure (when the token
773  * contract returns false). Tokens that return no value (and instead revert or
774  * throw on failure) are also supported, non-reverting calls are assumed to be
775  * successful.
776  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
777  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
778  */
779 library SafeBEP20 {
780     using SafeMath for uint256;
781     using Address for address;
782 
783     function safeTransfer(
784         IBEP20 token,
785         address to,
786         uint256 value
787     ) internal {
788         _callOptionalReturn(
789             token,
790             abi.encodeWithSelector(token.transfer.selector, to, value)
791         );
792     }
793 
794     function safeTransferFrom(
795         IBEP20 token,
796         address from,
797         address to,
798         uint256 value
799     ) internal {
800         _callOptionalReturn(
801             token,
802             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
803         );
804     }
805 
806     /**
807      * @dev Deprecated. This function has issues similar to the ones found in
808      * {IBEP20-approve}, and its usage is discouraged.
809      *
810      * Whenever possible, use {safeIncreaseAllowance} and
811      * {safeDecreaseAllowance} instead.
812      */
813     function safeApprove(
814         IBEP20 token,
815         address spender,
816         uint256 value
817     ) internal {
818         // safeApprove should only be called when setting an initial allowance,
819         // or when resetting it to zero. To increase and decrease it, use
820         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
821         // solhint-disable-next-line max-line-length
822         require(
823             (value == 0) || (token.allowance(address(this), spender) == 0),
824             "SafeBEP20: approve from non-zero to non-zero allowance"
825         );
826         _callOptionalReturn(
827             token,
828             abi.encodeWithSelector(token.approve.selector, spender, value)
829         );
830     }
831 
832     function safeIncreaseAllowance(
833         IBEP20 token,
834         address spender,
835         uint256 value
836     ) internal {
837         uint256 newAllowance = token.allowance(address(this), spender).add(
838             value
839         );
840         _callOptionalReturn(
841             token,
842             abi.encodeWithSelector(
843                 token.approve.selector,
844                 spender,
845                 newAllowance
846             )
847         );
848     }
849 
850     function safeDecreaseAllowance(
851         IBEP20 token,
852         address spender,
853         uint256 value
854     ) internal {
855         uint256 newAllowance = token.allowance(address(this), spender).sub(
856             value,
857             "SafeBEP20: decreased allowance below zero"
858         );
859         _callOptionalReturn(
860             token,
861             abi.encodeWithSelector(
862                 token.approve.selector,
863                 spender,
864                 newAllowance
865             )
866         );
867     }
868 
869     /**
870      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
871      * on the return value: the return value is optional (but if data is returned, it must not be false).
872      * @param token The token targeted by the call.
873      * @param data The call data (encoded using abi.encode or one of its variants).
874      */
875     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
876         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
877         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
878         // the target address contains contract code and also asserts for success in the low-level call.
879 
880         bytes memory returndata = address(token).functionCall(
881             data,
882             "SafeBEP20: low-level call failed"
883         );
884         if (returndata.length > 0) {
885             // Return data is optional
886             // solhint-disable-next-line max-line-length
887             require(
888                 abi.decode(returndata, (bool)),
889                 "SafeBEP20: BEP20 operation did not succeed"
890             );
891         }
892     }
893 }
894 
895 // File: contracts/SmartChefInitializable.sol
896 
897 contract SmartChefInitializable is Ownable, ReentrancyGuard {
898     using SafeMath for uint256;
899     using SafeBEP20 for IBEP20;
900 
901     address public dev1;
902     address public dev2;
903     address public dev3;
904 
905     // Deposit fee in basis points
906     uint256 public depositFeeBP = 300; //3%
907 
908     // Withdraw fee in basis points
909     uint256 public withdrawFeeBP = 300; //3%
910 
911     // Claim fee in basis points
912     uint256 public HarvestfeeBP = 1000; //10%
913 
914     // The address of the smart chef factory
915     address public SMART_CHEF_FACTORY;
916 
917     // Whether a limit is set for users
918     bool public hasUserLimit;
919 
920     // Whether it is initialized
921     bool public isInitialized;
922 
923     // Accrued token per share
924     uint256 public accTokenPerShare;
925 
926     // The block number when Chedda mining ends.
927     uint256 public bonusEndBlock;
928 
929     // The block number when Chedda mining starts.
930     uint256 public startBlock;
931 
932     // The block number of the last pool update
933     uint256 public lastRewardBlock;
934 
935     // The pool limit (0 if none)
936     uint256 public poolLimitPerUser;
937 
938     // Chedda tokens created per block.
939     uint256 public rewardPerBlock;
940 
941     // The precision factor
942     uint256 public PRECISION_FACTOR;
943 
944     // The reward token
945     IBEP20 public rewardToken;
946 
947     // The staked token
948     IBEP20 public stakedToken;
949 
950     // Info of each user that stakes tokens (stakedToken)
951     mapping(address => UserInfo) public userInfo;
952 
953     struct UserInfo {
954         address playerAddy;
955         uint256 amount; // How many staked tokens the user has provided
956         uint256 rewardDebt; // Reward debt
957     }
958 
959     UserInfo[] public UsersInfo;
960 
961     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
962     event Deposit(address indexed user, uint256 amount);
963     event EmergencyWithdraw(address indexed user, uint256 amount);
964     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
965     event NewRewardPerBlock(uint256 rewardPerBlock);
966     event NewPoolLimit(uint256 poolLimitPerUser);
967     event RewardsStop(uint256 blockNumber);
968     event Withdraw(address indexed user, uint256 amount);
969     event SetDevs(address dev1, address dev2, address dev3);
970     event SetDepositFee(uint256 depositFeeBP);
971     event SetWithdrawFee(uint256 withdrawFeeBP);
972     event SetHarvestfee(uint256 HarvestfeeBP);
973 
974     constructor() {
975         SMART_CHEF_FACTORY = msg.sender;
976     }
977 
978     /*
979      * @notice Initialize the contract
980      * @param _stakedToken: staked token address
981      * @param _rewardToken: reward token address
982      * @param _rewardPerBlock: reward per block (in rewardToken)
983      * @param _startBlock: start block
984      * @param _bonusEndBlock: end block
985      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
986      * @param _admin: admin address with ownership
987      */
988 
989     function initialize(
990         IBEP20 _stakedToken,
991         IBEP20 _rewardToken,
992         uint256 _rewardPerBlock,
993         uint256 _startBlock,
994         uint256 _bonusEndBlock,
995         uint256 _poolLimitPerUser,
996         address _admin
997     ) external {
998         require(!isInitialized, "Already initialized");
999         require(msg.sender == SMART_CHEF_FACTORY, "Not factory");
1000 
1001         // Make this contract initialized
1002         isInitialized = true;
1003 
1004         stakedToken = _stakedToken;
1005         rewardToken = _rewardToken;
1006         rewardPerBlock = _rewardPerBlock;
1007         startBlock = _startBlock;
1008         bonusEndBlock = _bonusEndBlock;
1009 
1010         if (_poolLimitPerUser > 0) {
1011             hasUserLimit = true;
1012             poolLimitPerUser = _poolLimitPerUser;
1013         }
1014 
1015         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
1016         require(decimalsRewardToken < 30, "Must be inferior to 30");
1017 
1018         PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
1019 
1020         // Set the lastRewardBlock as the startBlock
1021         lastRewardBlock = startBlock;
1022 
1023         // Transfer ownership to the admin address who becomes owner of the contract
1024         transferOwnership(_admin);
1025     }
1026 
1027     /*
1028      * @notice Deposit staked tokens and collect reward tokens (if any)
1029      * @param _amount: amount to withdraw (in rewardToken)
1030      */
1031     function deposit(uint256 _amount) external nonReentrant {
1032         UserInfo storage user = userInfo[msg.sender];
1033 
1034         if (user.playerAddy != msg.sender) {
1035             user.playerAddy = msg.sender;
1036             UsersInfo.push(user);
1037         }
1038 
1039         if (hasUserLimit) {
1040             require(
1041                 _amount.add(user.amount) <= poolLimitPerUser,
1042                 "User amount above limit"
1043             );
1044         }
1045         _updatePool();
1046 
1047         if (user.amount > 0) {
1048             uint256 pending = user
1049                 .amount
1050                 .mul(accTokenPerShare)
1051                 .div(PRECISION_FACTOR)
1052                 .sub(user.rewardDebt);
1053             if (pending > 0) {
1054                 uint256 Harvestfee = (pending * HarvestfeeBP) / 10000;
1055                 rewardToken.safeTransfer(address(msg.sender), pending);
1056                 rewardToken.safeTransfer(dev3, Harvestfee);
1057             }
1058         }
1059 
1060         if (_amount > 0) {
1061             uint256 depositFee = (_amount * depositFeeBP) / 10000;
1062             uint256 depositAmount = _amount.sub(depositFee);
1063             user.amount = user.amount.add(depositAmount);
1064             stakedToken.safeTransferFrom(
1065                 address(msg.sender),
1066                 address(this),
1067                 depositAmount
1068             );
1069             stakedToken.safeTransferFrom(address(msg.sender), dev2, depositFee);
1070         }
1071 
1072         user.rewardDebt = user.amount.mul(accTokenPerShare).div(
1073             PRECISION_FACTOR
1074         );
1075 
1076         emit Deposit(msg.sender, _amount);
1077     }
1078 
1079     /*
1080      * @notice Withdraw staked tokens and collect reward tokens
1081      * @param _amount: amount to withdraw (in rewardToken)
1082      */
1083     function withdraw(uint256 _amount) external nonReentrant {
1084         UserInfo storage user = userInfo[msg.sender];
1085         require(user.amount >= _amount, "Amount to withdraw too high");
1086 
1087         _updatePool();
1088 
1089         uint256 pending = user
1090             .amount
1091             .mul(accTokenPerShare)
1092             .div(PRECISION_FACTOR)
1093             .sub(user.rewardDebt);
1094 
1095         if (_amount > 0) {
1096             user.amount = user.amount.sub(_amount);
1097             uint256 WithdrawFee = (_amount * withdrawFeeBP) / 10000;
1098             stakedToken.safeTransfer(
1099                 address(msg.sender),
1100                 _amount.sub(WithdrawFee)
1101             );
1102             stakedToken.safeTransfer(dev1, WithdrawFee);
1103         }
1104 
1105         if (pending > 0) {
1106             uint256 Harvestfee = (pending * HarvestfeeBP) / 10000;
1107             rewardToken.safeTransfer(address(msg.sender), pending);
1108             rewardToken.safeTransfer(dev3, Harvestfee);
1109         }
1110 
1111         user.rewardDebt = user.amount.mul(accTokenPerShare).div(
1112             PRECISION_FACTOR
1113         );
1114         emit Withdraw(msg.sender, _amount);
1115     }
1116 
1117     /*
1118      * @notice Withdraw staked tokens without caring about rewards rewards
1119      * @dev Needs to be for emergency.
1120      */
1121     function emergencyWithdraw() external nonReentrant {
1122         UserInfo storage user = userInfo[msg.sender];
1123 
1124         if (user.amount > 0) {
1125             uint256 WithdrawFee = (user.amount * withdrawFeeBP) / 10000;
1126             stakedToken.safeTransfer(
1127                 address(msg.sender),
1128                 user.amount.sub(WithdrawFee)
1129             );
1130             stakedToken.safeTransfer(dev1, WithdrawFee);
1131         }
1132 
1133         user.amount = 0;
1134         user.rewardDebt = 0;
1135         emit EmergencyWithdraw(msg.sender, user.amount);
1136     }
1137 
1138     /*
1139      * @notice Stop rewards
1140      * @dev Only callable by owner. Needs to be for emergency.
1141      */
1142     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
1143         rewardToken.safeTransfer(address(msg.sender), _amount);
1144     }
1145 
1146     /**
1147      * @notice It allows the admin to recover wrong tokens sent to the contract
1148      * @param _tokenAddress: the address of the token to withdraw
1149      * @param _tokenAmount: the number of tokens to withdraw
1150      * @dev This function is only callable by admin.
1151      */
1152 
1153     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount)
1154         external
1155         onlyOwner
1156     {
1157         require(
1158             _tokenAddress != address(stakedToken),
1159             "Cannot be staked token"
1160         );
1161         require(
1162             _tokenAddress != address(rewardToken),
1163             "Cannot be reward token"
1164         );
1165 
1166         IBEP20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
1167 
1168         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
1169     }
1170 
1171     /*
1172      * @notice Stop rewards
1173      * @dev Only callable by owner
1174      */
1175     function stopReward() external onlyOwner {
1176         bonusEndBlock = block.number;
1177     }
1178 
1179     /*
1180      * @notice Update pool limit per user
1181      * @dev Only callable by owner.
1182      * @param _hasUserLimit: whether the limit remains forced
1183      * @param _poolLimitPerUser: new pool limit per user
1184      */
1185 
1186     function updatePoolLimitPerUser(
1187         bool _hasUserLimit,
1188         uint256 _poolLimitPerUser
1189     ) external onlyOwner {
1190         require(hasUserLimit, "Must be set");
1191         if (_hasUserLimit) {
1192             require(
1193                 _poolLimitPerUser > poolLimitPerUser,
1194                 "New limit must be higher"
1195             );
1196             poolLimitPerUser = _poolLimitPerUser;
1197         } else {
1198             hasUserLimit = _hasUserLimit;
1199             poolLimitPerUser = 0;
1200         }
1201         emit NewPoolLimit(poolLimitPerUser);
1202     }
1203 
1204     /*
1205      * @notice Update reward per block
1206      * @dev Only callable by owner.
1207      * @param _rewardPerBlock: the reward per block
1208      */
1209     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
1210         rewardPerBlock = _rewardPerBlock;
1211         emit NewRewardPerBlock(_rewardPerBlock);
1212     }
1213 
1214     /**
1215      * @notice It allows the admin to update start and end blocks
1216      * @dev This function is only callable by owner.
1217      * @param _startBlock: the new start block
1218      * @param _bonusEndBlock: the new end block
1219      */
1220 
1221     function updateStartAndEndBlocks(
1222         uint256 _startBlock,
1223         uint256 _bonusEndBlock
1224     ) external onlyOwner {
1225         require(block.number < startBlock, "Pool has started");
1226         require(
1227             _startBlock < _bonusEndBlock,
1228             "New startBlock must be lower than new endBlock"
1229         );
1230         require(
1231             block.number < _startBlock,
1232             "New startBlock must be higher than current block"
1233         );
1234 
1235         startBlock = _startBlock;
1236         bonusEndBlock = _bonusEndBlock;
1237 
1238         // Set the lastRewardBlock as the startBlock
1239         lastRewardBlock = startBlock;
1240 
1241         emit NewStartAndEndBlocks(_startBlock, _bonusEndBlock);
1242     }
1243 
1244     /*
1245      * @notice View function to see pending reward on frontend.
1246      * @param _user: user address
1247      * @return Pending reward for a given user
1248      */
1249 
1250     function pendingRewards() public view returns (uint256) {
1251         uint256 pendingRewardsTotal = 0;
1252         for (uint256 i = 0; i < UsersInfo.length; i++) {
1253             pendingRewardsTotal += pendingReward(UsersInfo[i].playerAddy);
1254         }
1255         return pendingRewardsTotal;
1256     }
1257 
1258     function effectiveRewards() public view returns (uint256) {
1259         uint256 effectiveReward=0;
1260         if (rewardToken.balanceOf(address(this)) > pendingRewards())
1261         {
1262         effectiveReward = rewardToken.balanceOf(address(this)).sub(
1263             pendingRewards()
1264         );
1265         }
1266         return effectiveReward;
1267     }
1268 
1269     function pendingReward(address _user) public view returns (uint256) {
1270         UserInfo storage user = userInfo[_user];
1271         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1272         if (block.number > lastRewardBlock && stakedTokenSupply != 0) {
1273             uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1274             uint256 CheddaReward = multiplier.mul(rewardPerBlock);
1275             uint256 adjustedTokenPerShare = accTokenPerShare.add(
1276                 CheddaReward.mul(PRECISION_FACTOR).div(stakedTokenSupply)
1277             );
1278             return
1279                 user
1280                     .amount
1281                     .mul(adjustedTokenPerShare)
1282                     .div(PRECISION_FACTOR)
1283                     .sub(user.rewardDebt);
1284         } else {
1285             return
1286                 user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(
1287                     user.rewardDebt
1288                 );
1289         }
1290     }
1291 
1292     /*
1293      * @notice Update reward variables of the given pool to be up-to-date.
1294      */
1295     function _updatePool() internal {
1296         if (block.number <= lastRewardBlock) {
1297             return;
1298         }
1299 
1300         uint256 stakedTokenSupply = stakedToken.balanceOf(address(this));
1301 
1302         if (stakedTokenSupply == 0) {
1303             lastRewardBlock = block.number;
1304             return;
1305         }
1306 
1307         uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
1308         uint256 CheddaReward = multiplier.mul(rewardPerBlock);
1309         accTokenPerShare = accTokenPerShare.add(
1310             CheddaReward.mul(PRECISION_FACTOR).div(stakedTokenSupply)
1311         );
1312         lastRewardBlock = block.number;
1313     }
1314 
1315     /*
1316      * @notice Return reward multiplier over the given _from to _to block.
1317      * @param _from: block to start
1318      * @param _to: block to finish
1319      */
1320     function _getMultiplier(uint256 _from, uint256 _to)
1321         internal
1322         view
1323         returns (uint256)
1324     {
1325         if (_to <= bonusEndBlock) {
1326             return _to.sub(_from);
1327         } else if (_from >= bonusEndBlock) {
1328             return 0;
1329         } else {
1330             return bonusEndBlock.sub(_from);
1331         }
1332     }
1333 
1334  function ChangedevAddress(address _dev1, address _dev2, address _dev3) external onlyOwner {
1335         require(_dev1 != address(0), "!nonzero");
1336         require(_dev2 != address(0), "!nonzero");
1337         require(_dev3 != address(0), "!nonzero");
1338         dev1 = _dev1;
1339         dev2 = _dev2;
1340         dev3 = _dev3;
1341         emit SetDevs(_dev1, _dev2, _dev3);
1342     }
1343 
1344     function ChangedepositFeeBP(uint256 _depositFeeBP) external onlyOwner {
1345         depositFeeBP = _depositFeeBP;
1346         emit SetDepositFee(_depositFeeBP);
1347     }
1348 
1349     function ChangewithdrawFeeBP(uint256 _withdrawFeeBP) external onlyOwner {
1350         withdrawFeeBP = _withdrawFeeBP;
1351         emit SetWithdrawFee(_withdrawFeeBP);
1352     }
1353 
1354     function ChangeHarvestfeeBP(uint256 _HarvestfeeBP) external onlyOwner {
1355         require(_HarvestfeeBP < 2000, "max 20%");
1356         HarvestfeeBP = _HarvestfeeBP;
1357         emit SetHarvestfee(_HarvestfeeBP);
1358     }
1359 }