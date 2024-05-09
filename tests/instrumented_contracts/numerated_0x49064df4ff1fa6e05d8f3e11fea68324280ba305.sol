1 
2   
3 //-------------DEPENDENCIES--------------------------//
4 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
5 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's + operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's - operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's * operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's / operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's % operator. This function uses a revert
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's - operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's / operator. Note: this function uses a
187      * revert opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's % operator. This function uses a revert
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 
233 // File: @openzeppelin/contracts/utils/Context.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Provides information about the current execution context, including the
242  * sender of the transaction and its data. While these are generally available
243  * via msg.sender and msg.data, they should not be accessed in such a direct
244  * manner, since when dealing with meta-transactions the account sending and
245  * paying for execution may not be the actual sender (as far as an application
246  * is concerned).
247  *
248  * This contract is only required for intermediate, library-like contracts.
249  */
250 abstract contract Context {
251     function _msgSender() internal view virtual returns (address) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view virtual returns (bytes calldata) {
256         return msg.data;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/security/Pausable.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 
268 /**
269  * @dev Contract module which allows children to implement an emergency stop
270  * mechanism that can be triggered by an authorized account.
271  *
272  * This module is used through inheritance. It will make available the
273  * modifiers whenNotPaused and whenPaused, which can be applied to
274  * the functions of your contract. Note that they will not be pausable by
275  * simply including this module, only once the modifiers are put in place.
276  */
277 abstract contract Pausable is Context {
278     /**
279      * @dev Emitted when the pause is triggered by account.
280      */
281     event Paused(address account);
282 
283     /**
284      * @dev Emitted when the pause is lifted by account.
285      */
286     event Unpaused(address account);
287 
288     bool private _paused;
289 
290     /**
291      * @dev Initializes the contract in unpaused state.
292      */
293     constructor() {
294         _paused = false;
295     }
296 
297     /**
298      * @dev Returns true if the contract is paused, and false otherwise.
299      */
300     function paused() public view virtual returns (bool) {
301         return _paused;
302     }
303 
304     /**
305      * @dev Modifier to make a function callable only when the contract is not paused.
306      *
307      * Requirements:
308      *
309      * - The contract must not be paused.
310      */
311     modifier whenNotPaused() {
312         require(!paused(), "Pausable: paused");
313         _;
314     }
315 
316     /**
317      * @dev Modifier to make a function callable only when the contract is paused.
318      *
319      * Requirements:
320      *
321      * - The contract must be paused.
322      */
323     modifier whenPaused() {
324         require(paused(), "Pausable: not paused");
325         _;
326     }
327 
328     /**
329      * @dev Triggers stopped state.
330      *
331      * Requirements:
332      *
333      * - The contract must not be paused.
334      */
335     function _pause() internal virtual whenNotPaused {
336         _paused = true;
337         emit Paused(_msgSender());
338     }
339 
340     /**
341      * @dev Returns to normal state.
342      *
343      * Requirements:
344      *
345      * - The contract must be paused.
346      */
347     function _unpause() internal virtual whenPaused {
348         _paused = false;
349         emit Unpaused(_msgSender());
350     }
351 }
352 
353 // File: @openzeppelin/contracts/access/Ownable.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 
361 /**
362  * @dev Contract module which provides a basic access control mechanism, where
363  * there is an account (an owner) that can be granted exclusive access to
364  * specific functions.
365  *
366  * By default, the owner account will be the one that deploys the contract. This
367  * can later be changed with {transferOwnership}.
368  *
369  * This module is used through inheritance. It will make available the modifier
370  * onlyOwner, which can be applied to your functions to restrict their use to
371  * the owner.
372  */
373 abstract contract Ownable is Context {
374     address private _owner;
375 
376     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
377 
378     /**
379      * @dev Initializes the contract setting the deployer as the initial owner.
380      */
381     constructor() {
382         _transferOwnership(_msgSender());
383     }
384 
385     /**
386      * @dev Returns the address of the current owner.
387      */
388     function owner() public view virtual returns (address) {
389         return _owner;
390     }
391 
392     /**
393      * @dev Throws if called by any account other than the owner.
394      */
395     modifier onlyOwner() {
396         require(owner() == _msgSender(), "Ownable: caller is not the owner");
397         _;
398     }
399 
400     /**
401      * @dev Leaves the contract without owner. It will not be possible to call
402      * onlyOwner functions anymore. Can only be called by the current owner.
403      *
404      * NOTE: Renouncing ownership will leave the contract without an owner,
405      * thereby removing any functionality that is only available to the owner.
406      */
407     function renounceOwnership() public virtual onlyOwner {
408         _transferOwnership(address(0));
409     }
410 
411     /**
412      * @dev Transfers ownership of the contract to a new account (newOwner).
413      * Can only be called by the current owner.
414      */
415     function transferOwnership(address newOwner) public virtual onlyOwner {
416         require(newOwner != address(0), "Ownable: new owner is the zero address");
417         _transferOwnership(newOwner);
418     }
419 
420     /**
421      * @dev Transfers ownership of the contract to a new account (newOwner).
422      * Internal function without access restriction.
423      */
424     function _transferOwnership(address newOwner) internal virtual {
425         address oldOwner = _owner;
426         _owner = newOwner;
427         emit OwnershipTransferred(oldOwner, newOwner);
428     }
429 }
430 
431 // File: @openzeppelin/contracts/utils/Address.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Collection of functions related to the address type
440  */
441 library Address {
442     /**
443      * @dev Returns true if account is a contract.
444      *
445      * [IMPORTANT]
446      * ====
447      * It is unsafe to assume that an address for which this function returns
448      * false is an externally-owned account (EOA) and not a contract.
449      *
450      * Among others, isContract will return false for the following
451      * types of addresses:
452      *
453      *  - an externally-owned account
454      *  - a contract in construction
455      *  - an address where a contract will be created
456      *  - an address where a contract lived, but was destroyed
457      * ====
458      */
459     function isContract(address account) internal view returns (bool) {
460         // This method relies on extcodesize, which returns 0 for contracts in
461         // construction, since the code is only stored at the end of the
462         // constructor execution.
463 
464         uint256 size;
465         assembly {
466             size := extcodesize(account)
467         }
468         return size > 0;
469     }
470 
471     /**
472      * @dev Replacement for Solidity's transfer: sends amount wei to
473      * recipient, forwarding all available gas and reverting on errors.
474      *
475      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
476      * of certain opcodes, possibly making contracts go over the 2300 gas limit
477      * imposed by transfer, making them unable to receive funds via
478      * transfer. {sendValue} removes this limitation.
479      *
480      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
481      *
482      * IMPORTANT: because control is transferred to recipient, care must be
483      * taken to not create reentrancy vulnerabilities. Consider using
484      * {ReentrancyGuard} or the
485      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
486      */
487     function sendValue(address payable recipient, uint256 amount) internal {
488         require(address(this).balance >= amount, "Address: insufficient balance");
489 
490         (bool success, ) = recipient.call{value: amount}("");
491         require(success, "Address: unable to send value, recipient may have reverted");
492     }
493 
494     /**
495      * @dev Performs a Solidity function call using a low level call. A
496      * plain call is an unsafe replacement for a function call: use this
497      * function instead.
498      *
499      * If target reverts with a revert reason, it is bubbled up by this
500      * function (like regular Solidity function calls).
501      *
502      * Returns the raw returned data. To convert to the expected return value,
503      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
504      *
505      * Requirements:
506      *
507      * - target must be a contract.
508      * - calling target with data must not revert.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
513         return functionCall(target, data, "Address: low-level call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
518      * errorMessage as a fallback revert reason when target reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, 0, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
532      * but also transferring value wei to target.
533      *
534      * Requirements:
535      *
536      * - the calling contract must have an ETH balance of at least value.
537      * - the called Solidity function must be payable.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
551      * with errorMessage as a fallback revert reason when target reverts.
552      *
553      * _Available since v3.1._
554      */
555     function functionCallWithValue(
556         address target,
557         bytes memory data,
558         uint256 value,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(address(this).balance >= value, "Address: insufficient balance for call");
562         require(isContract(target), "Address: call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.call{value: value}(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
570      * but performing a static call.
571      *
572      * _Available since v3.3._
573      */
574     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
575         return functionStaticCall(target, data, "Address: low-level static call failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
580      * but performing a static call.
581      *
582      * _Available since v3.3._
583      */
584     function functionStaticCall(
585         address target,
586         bytes memory data,
587         string memory errorMessage
588     ) internal view returns (bytes memory) {
589         require(isContract(target), "Address: static call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.staticcall(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
597      * but performing a delegate call.
598      *
599      * _Available since v3.4._
600      */
601     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
602         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal returns (bytes memory) {
616         require(isContract(target), "Address: delegate call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.delegatecall(data);
619         return verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
624      * revert reason using the provided one.
625      *
626      * _Available since v4.3._
627      */
628     function verifyCallResult(
629         bool success,
630         bytes memory returndata,
631         string memory errorMessage
632     ) internal pure returns (bytes memory) {
633         if (success) {
634             return returndata;
635         } else {
636             // Look for revert reason and bubble it up if present
637             if (returndata.length > 0) {
638                 // The easiest way to bubble the revert reason is using memory via assembly
639 
640                 assembly {
641                     let returndata_size := mload(returndata)
642                     revert(add(32, returndata), returndata_size)
643                 }
644             } else {
645                 revert(errorMessage);
646             }
647         }
648     }
649 }
650 
651 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Interface of the ERC165 standard, as defined in the
660  * https://eips.ethereum.org/EIPS/eip-165[EIP].
661  *
662  * Implementers can declare support of contract interfaces, which can then be
663  * queried by others ({ERC165Checker}).
664  *
665  * For an implementation, see {ERC165}.
666  */
667 interface IERC165 {
668     /**
669      * @dev Returns true if this contract implements the interface defined by
670      * interfaceId. See the corresponding
671      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
672      * to learn more about how these ids are created.
673      *
674      * This function call must use less than 30 000 gas.
675      */
676     function supportsInterface(bytes4 interfaceId) external view returns (bool);
677 }
678 
679 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 
687 /**
688  * @dev Implementation of the {IERC165} interface.
689  *
690  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
691  * for the additional interface id that will be supported. For example:
692  *
693  * solidity
694  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
696  * }
697  * 
698  *
699  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
700  */
701 abstract contract ERC165 is IERC165 {
702     /**
703      * @dev See {IERC165-supportsInterface}.
704      */
705     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
706         return interfaceId == type(IERC165).interfaceId;
707     }
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
711 
712 
713 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 /**
719  * @dev _Available since v3.1._
720  */
721 interface IERC1155Receiver is IERC165 {
722     /**
723         @dev Handles the receipt of a single ERC1155 token type. This function is
724         called at the end of a safeTransferFrom after the balance has been updated.
725         To accept the transfer, this must return
726         bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
727         (i.e. 0xf23a6e61, or its own function selector).
728         @param operator The address which initiated the transfer (i.e. msg.sender)
729         @param from The address which previously owned the token
730         @param id The ID of the token being transferred
731         @param value The amount of tokens being transferred
732         @param data Additional data with no specified format
733         @return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)")) if transfer is allowed
734     */
735     function onERC1155Received(
736         address operator,
737         address from,
738         uint256 id,
739         uint256 value,
740         bytes calldata data
741     ) external returns (bytes4);
742 
743     /**
744         @dev Handles the receipt of a multiple ERC1155 token types. This function
745         is called at the end of a safeBatchTransferFrom after the balances have
746         been updated. To accept the transfer(s), this must return
747         bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
748         (i.e. 0xbc197c81, or its own function selector).
749         @param operator The address which initiated the batch transfer (i.e. msg.sender)
750         @param from The address which previously owned the token
751         @param ids An array containing ids of each token being transferred (order and length must match values array)
752         @param values An array containing amounts of each token being transferred (order and length must match ids array)
753         @param data Additional data with no specified format
754         @return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)")) if transfer is allowed
755     */
756     function onERC1155BatchReceived(
757         address operator,
758         address from,
759         uint256[] calldata ids,
760         uint256[] calldata values,
761         bytes calldata data
762     ) external returns (bytes4);
763 }
764 
765 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
766 
767 
768 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 
773 /**
774  * @dev Required interface of an ERC1155 compliant contract, as defined in the
775  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
776  *
777  * _Available since v3.1._
778  */
779 interface IERC1155 is IERC165 {
780     /**
781      * @dev Emitted when value tokens of token type id are transferred from from to to by operator.
782      */
783     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
784 
785     /**
786      * @dev Equivalent to multiple {TransferSingle} events, where operator, from and to are the same for all
787      * transfers.
788      */
789     event TransferBatch(
790         address indexed operator,
791         address indexed from,
792         address indexed to,
793         uint256[] ids,
794         uint256[] values
795     );
796 
797     /**
798      * @dev Emitted when account grants or revokes permission to operator to transfer their tokens, according to
799      * approved.
800      */
801     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
802 
803     /**
804      * @dev Emitted when the URI for token type id changes to value, if it is a non-programmatic URI.
805      *
806      * If an {URI} event was emitted for id, the standard
807      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that value will equal the value
808      * returned by {IERC1155MetadataURI-uri}.
809      */
810     event URI(string value, uint256 indexed id);
811 
812     /**
813      * @dev Returns the amount of tokens of token type id owned by account.
814      *
815      * Requirements:
816      *
817      * - account cannot be the zero address.
818      */
819     function balanceOf(address account, uint256 id) external view returns (uint256);
820 
821     /**
822      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
823      *
824      * Requirements:
825      *
826      * - accounts and ids must have the same length.
827      */
828     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
829         external
830         view
831         returns (uint256[] memory);
832 
833     /**
834      * @dev Grants or revokes permission to operator to transfer the caller's tokens, according to approved,
835      *
836      * Emits an {ApprovalForAll} event.
837      *
838      * Requirements:
839      *
840      * - operator cannot be the caller.
841      */
842     function setApprovalForAll(address operator, bool approved) external;
843 
844     /**
845      * @dev Returns true if operator is approved to transfer account's tokens.
846      *
847      * See {setApprovalForAll}.
848      */
849     function isApprovedForAll(address account, address operator) external view returns (bool);
850 
851     /**
852      * @dev Transfers amount tokens of token type id from from to to.
853      *
854      * Emits a {TransferSingle} event.
855      *
856      * Requirements:
857      *
858      * - to cannot be the zero address.
859      * - If the caller is not from, it must be have been approved to spend from's tokens via {setApprovalForAll}.
860      * - from must have a balance of tokens of type id of at least amount.
861      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
862      * acceptance magic value.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 id,
868         uint256 amount,
869         bytes calldata data
870     ) external;
871 
872     /**
873      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
874      *
875      * Emits a {TransferBatch} event.
876      *
877      * Requirements:
878      *
879      * - ids and amounts must have the same length.
880      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
881      * acceptance magic value.
882      */
883     function safeBatchTransferFrom(
884         address from,
885         address to,
886         uint256[] calldata ids,
887         uint256[] calldata amounts,
888         bytes calldata data
889     ) external;
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
893 
894 
895 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 
900 /**
901  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
902  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
903  *
904  * _Available since v3.1._
905  */
906 interface IERC1155MetadataURI is IERC1155 {
907     /**
908      * @dev Returns the URI for token type id.
909      *
910      * If the {id} substring is present in the URI, it must be replaced by
911      * clients with the actual token type ID.
912      */
913     function uri(uint256 id) external view returns (string memory);
914 }
915 
916 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
917 
918 
919 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
920 
921 pragma solidity ^0.8.0;
922 
923 
924 
925 
926 
927 
928 
929 /**
930  * @dev Implementation of the basic standard multi-token.
931  * See https://eips.ethereum.org/EIPS/eip-1155
932  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
933  *
934  * _Available since v3.1._
935  */
936 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
937     using Address for address;
938     
939     // Mapping for token ID that are not able to traded
940     // For reasons mapping to uint8 instead of boolean
941     // so 1 = false and 255 = true
942     mapping (uint256 => uint8) tokenTradingStatus;
943 
944     // Mapping from token ID to account balances
945     mapping(uint256 => mapping(address => uint256)) private _balances;
946 
947     // Mapping from account to operator approvals
948     mapping(address => mapping(address => bool)) private _operatorApprovals;
949 
950     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
951     string private _uri;
952 
953     /**
954      * @dev See {_setURI}.
955      */
956     constructor(string memory uri_) {
957         _setURI(uri_);
958     }
959 
960     /**
961      * @dev See {IERC165-supportsInterface}.
962      */
963     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
964         return
965             interfaceId == type(IERC1155).interfaceId ||
966             interfaceId == type(IERC1155MetadataURI).interfaceId ||
967             super.supportsInterface(interfaceId);
968     }
969 
970     /**
971      * @dev See {IERC1155MetadataURI-uri}.
972      *
973      * This implementation returns the same URI for *all* token types. It relies
974      * on the token type ID substitution mechanism
975      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
976      *
977      * Clients calling this function must replace the {id} substring with the
978      * actual token type ID.
979      */
980     function uri(uint256) public view virtual override returns (string memory) {
981         return _uri;
982     }
983 
984     /**
985      * @dev See {IERC1155-balanceOf}.
986      *
987      * Requirements:
988      *
989      * - account cannot be the zero address.
990      */
991     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
992         require(account != address(0), "ERC1155: balance query for the zero address");
993         return _balances[id][account];
994     }
995 
996     /**
997      * @dev See {IERC1155-balanceOfBatch}.
998      *
999      * Requirements:
1000      *
1001      * - accounts and ids must have the same length.
1002      */
1003     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1004         public
1005         view
1006         virtual
1007         override
1008         returns (uint256[] memory)
1009     {
1010         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1011 
1012         uint256[] memory batchBalances = new uint256[](accounts.length);
1013 
1014         for (uint256 i = 0; i < accounts.length; ++i) {
1015             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1016         }
1017 
1018         return batchBalances;
1019     }
1020 
1021     /**
1022      * @dev See {IERC1155-setApprovalForAll}.
1023      */
1024     function setApprovalForAll(address operator, bool approved) public virtual override {
1025         _setApprovalForAll(_msgSender(), operator, approved);
1026     }
1027 
1028     /**
1029      * @dev See {IERC1155-isApprovedForAll}.
1030      */
1031     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1032         return _operatorApprovals[account][operator];
1033     }
1034 
1035     /**
1036      * @dev See {IERC1155-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 id,
1042         uint256 amount,
1043         bytes memory data
1044     ) public virtual override {
1045         require(tokenTradingStatus[id] == 255, "Token is not tradeable!");
1046         require(
1047             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1048             "ERC1155: caller is not owner nor approved"
1049         );
1050         _safeTransferFrom(from, to, id, amount, data);
1051     }
1052 
1053     /**
1054      * @dev See {IERC1155-safeBatchTransferFrom}.
1055      */
1056     function safeBatchTransferFrom(
1057         address from,
1058         address to,
1059         uint256[] memory ids,
1060         uint256[] memory amounts,
1061         bytes memory data
1062     ) public virtual override {
1063         for (uint256 i = 0; i < ids.length; ++i) {
1064             require(tokenTradingStatus[ids[i]] == 255, "Token is not tradeable!");
1065         }
1066 
1067         require(
1068             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1069             "ERC1155: transfer caller is not owner nor approved"
1070         );
1071         _safeBatchTransferFrom(from, to, ids, amounts, data);
1072     }
1073 
1074     /**
1075      * @dev Transfers amount tokens of token type id from from to to.
1076      *
1077      * Emits a {TransferSingle} event.
1078      *
1079      * Requirements:
1080      *
1081      * - to cannot be the zero address.
1082      * - from must have a balance of tokens of type id of at least amount.
1083      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1084      * acceptance magic value.
1085      */
1086     function _safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 id,
1090         uint256 amount,
1091         bytes memory data
1092     ) internal virtual {
1093         require(to != address(0), "ERC1155: transfer to the zero address");
1094 
1095         address operator = _msgSender();
1096 
1097         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1098 
1099         uint256 fromBalance = _balances[id][from];
1100         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1101         unchecked {
1102             _balances[id][from] = fromBalance - amount;
1103         }
1104         _balances[id][to] += amount;
1105 
1106         emit TransferSingle(operator, from, to, id, amount);
1107 
1108         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1109     }
1110 
1111     /**
1112      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1113      *
1114      * Emits a {TransferBatch} event.
1115      *
1116      * Requirements:
1117      *
1118      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1119      * acceptance magic value.
1120      */
1121     function _safeBatchTransferFrom(
1122         address from,
1123         address to,
1124         uint256[] memory ids,
1125         uint256[] memory amounts,
1126         bytes memory data
1127     ) internal virtual {
1128         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1129         require(to != address(0), "ERC1155: transfer to the zero address");
1130 
1131         address operator = _msgSender();
1132 
1133         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1134 
1135         for (uint256 i = 0; i < ids.length; ++i) {
1136             uint256 id = ids[i];
1137             uint256 amount = amounts[i];
1138 
1139             uint256 fromBalance = _balances[id][from];
1140             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1141             unchecked {
1142                 _balances[id][from] = fromBalance - amount;
1143             }
1144             _balances[id][to] += amount;
1145         }
1146 
1147         emit TransferBatch(operator, from, to, ids, amounts);
1148 
1149         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1150     }
1151 
1152     /**
1153      * @dev Sets a new URI for all token types, by relying on the token type ID
1154      * substitution mechanism
1155      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1156      *
1157      * By this mechanism, any occurrence of the {id} substring in either the
1158      * URI or any of the amounts in the JSON file at said URI will be replaced by
1159      * clients with the token type ID.
1160      *
1161      * For example, the https://token-cdn-domain/{id}.json URI would be
1162      * interpreted by clients as
1163      * https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json
1164      * for token type ID 0x4cce0.
1165      *
1166      * See {uri}.
1167      *
1168      * Because these URIs cannot be meaningfully represented by the {URI} event,
1169      * this function emits no events.
1170      */
1171     function _setURI(string memory newuri) internal virtual {
1172         _uri = newuri;
1173     }
1174 
1175     /**
1176      * @dev Creates amount tokens of token type id, and assigns them to to.
1177      *
1178      * Emits a {TransferSingle} event.
1179      *
1180      * Requirements:
1181      *
1182      * - to cannot be the zero address.
1183      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1184      * acceptance magic value.
1185      */
1186     function _mint(
1187         address to,
1188         uint256 id,
1189         uint256 amount,
1190         bytes memory data
1191     ) internal virtual {
1192         require(to != address(0), "ERC1155: mint to the zero address");
1193 
1194         address operator = _msgSender();
1195 
1196         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1197 
1198         _balances[id][to] += amount;
1199         emit TransferSingle(operator, address(0), to, id, amount);
1200 
1201         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1202     }
1203 
1204     /**
1205      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1206      *
1207      * Requirements:
1208      *
1209      * - ids and amounts must have the same length.
1210      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1211      * acceptance magic value.
1212      */
1213     function _mintBatch(
1214         address to,
1215         uint256[] memory ids,
1216         uint256[] memory amounts,
1217         bytes memory data
1218     ) internal virtual {
1219         require(to != address(0), "ERC1155: mint to the zero address");
1220         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1221 
1222         address operator = _msgSender();
1223 
1224         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1225 
1226         for (uint256 i = 0; i < ids.length; i++) {
1227             _balances[ids[i]][to] += amounts[i];
1228         }
1229 
1230         emit TransferBatch(operator, address(0), to, ids, amounts);
1231 
1232         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1233     }
1234 
1235     /**
1236      * @dev Destroys amount tokens of token type id from from
1237      *
1238      * Requirements:
1239      *
1240      * - from cannot be the zero address.
1241      * - from must have at least amount tokens of token type id.
1242      */
1243     function _burn(
1244         address from,
1245         uint256 id,
1246         uint256 amount
1247     ) internal virtual {
1248         require(from != address(0), "ERC1155: burn from the zero address");
1249 
1250         address operator = _msgSender();
1251 
1252         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1253 
1254         uint256 fromBalance = _balances[id][from];
1255         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1256         unchecked {
1257             _balances[id][from] = fromBalance - amount;
1258         }
1259 
1260         emit TransferSingle(operator, from, address(0), id, amount);
1261     }
1262 
1263     /**
1264      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1265      *
1266      * Requirements:
1267      *
1268      * - ids and amounts must have the same length.
1269      */
1270     function _burnBatch(
1271         address from,
1272         uint256[] memory ids,
1273         uint256[] memory amounts
1274     ) internal virtual {
1275         require(from != address(0), "ERC1155: burn from the zero address");
1276         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1277 
1278         address operator = _msgSender();
1279 
1280         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1281 
1282         for (uint256 i = 0; i < ids.length; i++) {
1283             uint256 id = ids[i];
1284             uint256 amount = amounts[i];
1285 
1286             uint256 fromBalance = _balances[id][from];
1287             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1288             unchecked {
1289                 _balances[id][from] = fromBalance - amount;
1290             }
1291         }
1292 
1293         emit TransferBatch(operator, from, address(0), ids, amounts);
1294     }
1295 
1296     /**
1297      * @dev Approve operator to operate on all of owner tokens
1298      *
1299      * Emits a {ApprovalForAll} event.
1300      */
1301     function _setApprovalForAll(
1302         address owner,
1303         address operator,
1304         bool approved
1305     ) internal virtual {
1306         require(owner != operator, "ERC1155: setting approval status for self");
1307         _operatorApprovals[owner][operator] = approved;
1308         emit ApprovalForAll(owner, operator, approved);
1309     }
1310 
1311     /**
1312      * @dev Hook that is called before any token transfer. This includes minting
1313      * and burning, as well as batched variants.
1314      *
1315      * The same hook is called on both single and batched variants. For single
1316      * transfers, the length of the id and amount arrays will be 1.
1317      *
1318      * Calling conditions (for each id and amount pair):
1319      *
1320      * - When from and to are both non-zero, amount of from's tokens
1321      * of token type id will be  transferred to to.
1322      * - When from is zero, amount tokens of token type id will be minted
1323      * for to.
1324      * - when to is zero, amount of from's tokens of token type id
1325      * will be burned.
1326      * - from and to are never both zero.
1327      * - ids and amounts have the same, non-zero length.
1328      *
1329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1330      */
1331     function _beforeTokenTransfer(
1332         address operator,
1333         address from,
1334         address to,
1335         uint256[] memory ids,
1336         uint256[] memory amounts,
1337         bytes memory data
1338     ) internal virtual {}
1339 
1340     function _doSafeTransferAcceptanceCheck(
1341         address operator,
1342         address from,
1343         address to,
1344         uint256 id,
1345         uint256 amount,
1346         bytes memory data
1347     ) private {
1348         if (to.isContract()) {
1349             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1350                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1351                     revert("ERC1155: ERC1155Receiver rejected tokens");
1352                 }
1353             } catch Error(string memory reason) {
1354                 revert(reason);
1355             } catch {
1356                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1357             }
1358         }
1359     }
1360 
1361     function _doSafeBatchTransferAcceptanceCheck(
1362         address operator,
1363         address from,
1364         address to,
1365         uint256[] memory ids,
1366         uint256[] memory amounts,
1367         bytes memory data
1368     ) private {
1369         if (to.isContract()) {
1370             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1371                 bytes4 response
1372             ) {
1373                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1374                     revert("ERC1155: ERC1155Receiver rejected tokens");
1375                 }
1376             } catch Error(string memory reason) {
1377                 revert(reason);
1378             } catch {
1379                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1380             }
1381         }
1382     }
1383 
1384     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1385         uint256[] memory array = new uint256[](1);
1386         array[0] = element;
1387 
1388         return array;
1389     }
1390 }
1391 
1392 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1393 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1394 
1395 pragma solidity ^0.8.0;
1396 
1397 
1398 /**
1399  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1400  *
1401  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1402  * clearly identified. Note: While a totalSupply of 1 might mean the
1403  * corresponding is an NFT, there is no guarantees that no other token with the
1404  * same id are not going to be minted.
1405  */
1406 abstract contract ERC1155Supply is ERC1155, Ownable {
1407     using SafeMath for uint256;
1408     mapping (uint256 => uint256) private _totalSupply;
1409     mapping (uint256 => uint256) private tokenSupplyCap;
1410 
1411     /**
1412      * @dev Total amount of tokens in with a given id.
1413      */
1414     function totalSupply(uint256 _id) public view virtual returns (uint256) {
1415         return _totalSupply[_id];
1416     }
1417 
1418     function getTokenSupplyCap(uint256 _id) public view virtual returns (uint256) {
1419         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1420         return tokenSupplyCap[_id];
1421     }
1422 
1423     function setTokenSupplyCap(uint256 _id, uint256 _newSupplyCap) public onlyOwner {
1424         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1425         require(_newSupplyCap > tokenSupplyCap[_id], "New Supply Cap can only be greater than previous supply cap.");
1426         tokenSupplyCap[_id] = _newSupplyCap;
1427     }
1428 
1429     /**
1430      * @dev Indicates whether any token exist with a given id, or not.
1431      */
1432     function exists(uint256 id) public view virtual returns (bool) {
1433         return ERC1155Supply.totalSupply(id) > 0;
1434     }
1435 
1436     /**
1437      * @dev See {ERC1155-_beforeTokenTransfer}.
1438      */
1439     function _beforeTokenTransfer(
1440         address operator,
1441         address from,
1442         address to,
1443         uint256[] memory ids,
1444         uint256[] memory amounts,
1445         bytes memory data
1446     ) internal virtual override {
1447         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1448 
1449         if (from == address(0)) {
1450             for (uint256 i = 0; i < ids.length; ++i) {
1451                 _totalSupply[ids[i]] += amounts[i];
1452             }
1453         }
1454 
1455         if (to == address(0)) {
1456             for (uint256 i = 0; i < ids.length; ++i) {
1457                 _totalSupply[ids[i]] -= amounts[i];
1458             }
1459         }
1460     }
1461 }
1462 //-------------END DEPENDENCIES------------------------//
1463 
1464 
1465   
1466   // File: MerkleProof.sol - OpenZeppelin Standard
1467   
1468   pragma solidity ^0.8.0;
1469   
1470   /**
1471   * @dev These functions deal with verification of Merkle Trees proofs.
1472   *
1473   * The proofs can be generated using the JavaScript library
1474   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1475   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1476   *
1477   *
1478   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1479   * hashing, or use a hash function other than keccak256 for hashing leaves.
1480   * This is because the concatenation of a sorted pair of internal nodes in
1481   * the merkle tree could be reinterpreted as a leaf value.
1482   */
1483   library MerkleProof {
1484       /**
1485       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1486       * defined by 'root'. For this, a 'proof' must be provided, containing
1487       * sibling hashes on the branch from the leaf to the root of the tree. Each
1488       * pair of leaves and each pair of pre-images are assumed to be sorted.
1489       */
1490       function verify(
1491           bytes32[] memory proof,
1492           bytes32 root,
1493           bytes32 leaf
1494       ) internal pure returns (bool) {
1495           return processProof(proof, leaf) == root;
1496       }
1497   
1498       /**
1499       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1500       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1501       * hash matches the root of the tree. When processing the proof, the pairs
1502       * of leafs & pre-images are assumed to be sorted.
1503       *
1504       * _Available since v4.4._
1505       */
1506       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1507           bytes32 computedHash = leaf;
1508           for (uint256 i = 0; i < proof.length; i++) {
1509               bytes32 proofElement = proof[i];
1510               if (computedHash <= proofElement) {
1511                   // Hash(current computed hash + current element of the proof)
1512                   computedHash = _efficientHash(computedHash, proofElement);
1513               } else {
1514                   // Hash(current element of the proof + current computed hash)
1515                   computedHash = _efficientHash(proofElement, computedHash);
1516               }
1517           }
1518           return computedHash;
1519       }
1520   
1521       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1522           assembly {
1523               mstore(0x00, a)
1524               mstore(0x20, b)
1525               value := keccak256(0x00, 0x40)
1526           }
1527       }
1528   }
1529   
1530   // File: Allowlist.sol
1531   pragma solidity ^0.8.0;
1532   
1533   abstract contract Allowlist is Ownable {
1534       mapping(uint256 => bytes32) private merkleRoot;
1535       mapping(uint256 => bool) private allowlistMode;
1536       bool public onlyAllowlistMode = false;
1537 
1538       /**
1539       * @dev Get merkle root for specific token in collection
1540       * @param _id token id from collection
1541       */
1542       function merkleRootForToken(uint256 _id) public view returns(bytes32) {
1543           return merkleRoot[_id];
1544       }
1545 
1546       /**
1547       * @dev Update merkle root to reflect changes in Allowlist
1548       * @param _id token if for merkle root
1549       * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1550       */
1551       function updateMerkleRoot(uint256 _id, bytes32 _newMerkleRoot) public onlyOwner {
1552           require(_newMerkleRoot != merkleRoot[_id], "Merkle root will be unchanged!");
1553           merkleRoot[_id] = _newMerkleRoot;
1554       }
1555 
1556       /**
1557       * @dev Check the proof of an address if valid for merkle root
1558       * @param _address address to check for proof
1559       * @param _tokenId token id to check root of
1560       * @param _merkleProof Proof of the address to validate against root and leaf
1561       */
1562       function isAllowlisted(address _address, uint256 _tokenId, bytes32[] calldata _merkleProof) public view returns(bool) {
1563           require(merkleRootForToken(_tokenId) != 0, "Merkle root is not set!");
1564           bytes32 leaf = keccak256(abi.encodePacked(_address));
1565 
1566           return MerkleProof.verify(_merkleProof, merkleRoot[_tokenId], leaf);
1567       }
1568 
1569       function inAllowlistMode(uint256 _id) public view returns (bool) {
1570           return allowlistMode[_id] == true;
1571       }
1572 
1573       function enableAllowlistOnlyMode(uint256 _id) public onlyOwner {
1574           allowlistMode[_id] = true;
1575       }
1576 
1577       function disableAllowlistOnlyMode(uint256 _id) public onlyOwner {
1578           allowlistMode[_id] = false;
1579       }
1580   }
1581   
1582   
1583 abstract contract Ramppable {
1584   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1585 
1586   modifier isRampp() {
1587       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1588       _;
1589   }
1590 }
1591 
1592 
1593   
1594 interface IERC20 {
1595   function transfer(address _to, uint256 _amount) external returns (bool);
1596   function balanceOf(address account) external view returns (uint256);
1597 }
1598 
1599 abstract contract Withdrawable is Ownable, Ramppable {
1600   address[] public payableAddresses = [RAMPPADDRESS,0x334591c10f85b437915C56b41C8B88922a910B15];
1601   uint256[] public payableFees = [5,95];
1602   uint256 public payableAddressCount = 2;
1603 
1604   function withdrawAll() public onlyOwner {
1605       require(address(this).balance > 0);
1606       _withdrawAll();
1607   }
1608   
1609   function withdrawAllRampp() public isRampp {
1610       require(address(this).balance > 0);
1611       _withdrawAll();
1612   }
1613 
1614   function _withdrawAll() private {
1615       uint256 balance = address(this).balance;
1616       
1617       for(uint i=0; i < payableAddressCount; i++ ) {
1618           _widthdraw(
1619               payableAddresses[i],
1620               (balance * payableFees[i]) / 100
1621           );
1622       }
1623   }
1624   
1625   function _widthdraw(address _address, uint256 _amount) private {
1626       (bool success, ) = _address.call{value: _amount}("");
1627       require(success, "Transfer failed.");
1628   }
1629 
1630   /**
1631     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1632     * while still splitting royalty payments to all other team members.
1633     * in the event ERC-20 tokens are paid to the contract.
1634     * @param _tokenContract contract of ERC-20 token to withdraw
1635     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1636     */
1637   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1638     require(_amount > 0);
1639     IERC20 tokenContract = IERC20(_tokenContract);
1640     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1641 
1642     for(uint i=0; i < payableAddressCount; i++ ) {
1643         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1644     }
1645   }
1646 
1647   /**
1648   * @dev Allows Rampp wallet to update its own reference as well as update
1649   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1650   * and since Rampp is always the first address this function is limited to the rampp payout only.
1651   * @param _newAddress updated Rampp Address
1652   */
1653   function setRamppAddress(address _newAddress) public isRampp {
1654     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1655     RAMPPADDRESS = _newAddress;
1656     payableAddresses[0] = _newAddress;
1657   }
1658 }
1659 
1660 
1661   
1662 // File: isFeeable.sol
1663 abstract contract isPriceable is Ownable {
1664     using SafeMath for uint256;
1665     mapping (uint256 => uint256) tokenPrice;
1666 
1667     function getPriceForToken(uint256 _id) public view returns(uint256) {
1668         return tokenPrice[_id];
1669     }
1670 
1671     function setPriceForToken(uint256 _id, uint256 _feeInWei) public onlyOwner {
1672         tokenPrice[_id] = _feeInWei;
1673     }
1674 }
1675 
1676 
1677   
1678 // File: hasTransactionCap.sol
1679 abstract contract hasTransactionCap is Ownable {
1680     using SafeMath for uint256;
1681     mapping (uint256 => uint256) transactionCap;
1682 
1683     function getTransactionCapForToken(uint256 _id) public view returns(uint256) {
1684         return transactionCap[_id];
1685     }
1686 
1687     function setTransactionCapForToken(uint256 _id, uint256 _transactionCap) public onlyOwner {
1688         require(_transactionCap > 0, "Quantity must be more than zero");
1689         transactionCap[_id] = _transactionCap;
1690     }
1691 
1692     function canMintQtyForTransaction(uint256 _id, uint256 _qty) internal view returns(bool) {
1693         return _qty <= transactionCap[_id];
1694     }
1695 }
1696 
1697 
1698   
1699 // File: hasWalletCap.sol
1700 abstract contract hasWalletCap is Ownable {
1701     using SafeMath for uint256;
1702     mapping (uint256 => bool) private walletCapEnabled;
1703     mapping (uint256 => uint256) private walletMaxes;
1704     mapping (address => mapping(uint256 => uint256)) private walletMints;
1705 
1706     /**
1707     * @dev establish the inital settings of the wallet cap upon creation
1708     * @param _id token id
1709     * @param _initWalletCapStatus initial state of wallet cap
1710     * @param _initWalletMax initial state of wallet cap limit
1711     */
1712     function setWalletCap(uint256 _id, bool _initWalletCapStatus, uint256 _initWalletMax) internal {
1713       walletCapEnabled[_id] = _initWalletCapStatus;
1714       walletMaxes[_id] = _initWalletMax;
1715     }
1716 
1717     function enableWalletCap(uint256 _id) public onlyOwner {
1718       walletCapEnabled[_id] = true;
1719     }
1720 
1721     function disableWalletCap(uint256 _id) public onlyOwner {
1722       walletCapEnabled[_id] = false;
1723     }
1724 
1725     function addTokenMints(uint256 _id, address _address, uint256 _amount) internal {
1726       walletMints[_address][_id] = SafeMath.add(walletMints[_address][_id], _amount);
1727     }
1728 
1729     /**
1730     * @dev Allow contract owner to reset the amount of tokens claimed to be minted per address
1731     * @param _id token id
1732     * @param _address address to reset counter of
1733     */
1734     function resetMints(uint256 _id, address _address) public onlyOwner {
1735       walletMints[_address][_id] = 0;
1736     }
1737 
1738     /**
1739     * @dev update the wallet max per wallet per token
1740     * @param _id token id
1741     * @param _newMax the new wallet max per wallet
1742     */
1743     function setTokenWalletMax(uint256 _id, uint256 _newMax) public onlyOwner {
1744       require(_newMax >= 1, "Token wallet max must be greater than or equal to one.");
1745       walletMaxes[_id] = _newMax;
1746     }
1747 
1748     /**
1749     * @dev Check if wallet over maximum mint
1750     * @param _id token id to query against
1751     * @param _address address in question to check if minted count exceeds max
1752     */
1753     function canMintAmount(uint256 _id, address _address, uint256 _amount) public view returns(bool) {
1754         if(isWalletCapEnabled(_id) == false) {
1755           return true;
1756         }
1757   
1758         require(_amount >= 1, "Amount must be greater than or equal to 1");
1759         return SafeMath.add(currentMintCount(_id, _address), _amount) <= tokenWalletCap(_id);
1760     }
1761 
1762     /**
1763     * @dev Get current wallet cap for token
1764     * @param _id token id to query against
1765     */
1766     function tokenWalletCap(uint256 _id) public view returns(uint256) {
1767       return walletMaxes[_id];
1768     }
1769 
1770     /**
1771     * @dev Check if token is enforcing wallet caps
1772     * @param _id token id to query against
1773     */
1774     function isWalletCapEnabled(uint256 _id) public view returns(bool) {
1775       return walletCapEnabled[_id] == true;
1776     }
1777 
1778     /**
1779     * @dev Check current mint count for token and address
1780     * @param _id token id to query against
1781     * @param _address address to check mint count of
1782     */
1783     function currentMintCount(uint256 _id, address _address) public view returns(uint256) {
1784       return walletMints[_address][_id];
1785     }
1786 }
1787 
1788 
1789   
1790 // File: Closeable.sol
1791 abstract contract Closeable is Ownable {
1792     mapping (uint256 => bool) mintingOpen;
1793 
1794     function openMinting(uint256 _id) public onlyOwner {
1795         mintingOpen[_id] = true;
1796     }
1797 
1798     function closeMinting(uint256 _id) public onlyOwner {
1799         mintingOpen[_id] = false;
1800     }
1801 
1802     function isMintingOpen(uint256 _id) public view returns(bool) {
1803         return mintingOpen[_id] == true;
1804     }
1805 
1806     function setInitialMintingStatus(uint256 _id, bool _initStatus) internal {
1807         mintingOpen[_id] = _initStatus;
1808     }
1809 }
1810   
1811 
1812   
1813 // File: contracts/JuicePassContract.sol
1814 //SPDX-License-Identifier: MIT
1815 
1816 pragma solidity ^0.8.2;
1817 
1818 
1819 contract JuicePassContract is 
1820     ERC1155,
1821     Ownable, 
1822     Pausable, 
1823     ERC1155Supply, 
1824     Withdrawable,
1825     Closeable,
1826     isPriceable,
1827     hasTransactionCap,
1828     hasWalletCap,
1829     Allowlist
1830 {
1831     constructor() ERC1155('') {}
1832     using SafeMath for uint256;
1833 
1834     uint8 public CONTRACT_VERSION = 2;
1835     bytes private emptyBytes;
1836     uint256 public currentTokenID = 0;
1837     string public name = "Juice Pass";
1838     string public symbol = "Juice";
1839 
1840     mapping (uint256 => string) baseTokenURI;
1841 
1842     /**
1843     * @dev returns the URI for a specific token to show metadata on marketplaces
1844     * @param _id the maximum supply of tokens for this token
1845     */
1846     function uri(uint256 _id) public override view returns (string memory) {
1847         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1848         return baseTokenURI[_id];
1849     }
1850 
1851     function contractURI() public pure returns (string memory) {
1852       return "https://us-central1-nft-rampp.cloudfunctions.net/app/cT9hB4BzxndFOnUe7p5f/contract-metadata";
1853     }
1854 
1855     
1856   /////////////// Admin Mint Functions
1857   function mintToAdmin(address _address, uint256 _id, uint256 _qty) public onlyOwner {
1858       require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1859       require(_qty > 0, "Minting quantity must be over 0");
1860       require(totalSupply(_id).add(_qty) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1861       
1862       _mint(_address, _id, _qty, emptyBytes);
1863   }
1864 
1865   function mintManyAdmin(address[] memory addresses, uint256 _id, uint256 _qtyToEach) public onlyOwner {
1866       for(uint256 i=0; i < addresses.length; i++) {
1867           _mint(addresses[i], _id, _qtyToEach, emptyBytes);
1868       }
1869   }
1870 
1871     
1872   /////////////// Public Mint Functions
1873   /**
1874   * @dev Mints a single token to an address.
1875   * fee may or may not be required*
1876   * @param _id token id of collection
1877   */
1878   function mintTo(uint256 _id) public payable whenNotPaused {
1879       require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1880       require(totalSupply(_id).add(1) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1881       require(msg.value == getPrice(_id, 1), "Value needs to be exactly the mint fee!");
1882 
1883       require(inAllowlistMode(_id) == false, "Public minting is not enabled while contract is in allowlist only mode.");
1884       require(isMintingOpen(_id), "Minting for this token is not open");
1885       require(canMintAmount(_id, msg.sender, 1), "Wallet mint maximum reached for token.");
1886 
1887       addTokenMints(_id, msg.sender, 1);
1888       _mint(msg.sender, _id, 1, emptyBytes);
1889   }
1890 
1891   /**
1892   * @dev Mints a number of tokens to a single address.
1893   * fee may or may not be required*
1894   * @param _id token id of collection
1895   * @param _qty amount to mint
1896   */
1897   function mintToMultiple(uint256 _id, uint256 _qty) public payable whenNotPaused {
1898       require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1899       require(_qty >= 1, "Must mint at least 1 token");
1900       require(canMintQtyForTransaction(_id, _qty), "Cannot mint more than max mint per transaction");
1901       require(totalSupply(_id).add(_qty) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1902       require(msg.value == getPrice(_id, _qty), "Value needs to be exactly the mint fee!");
1903 
1904       require(inAllowlistMode(_id) == false, "Public minting is not enabled while contract is in allowlist only mode.");
1905       require(isMintingOpen(_id), "Minting for this token is not open");
1906       require(canMintAmount(_id, msg.sender, _qty), "Wallet mint maximum reached for token.");
1907 
1908       addTokenMints(_id, msg.sender, _qty);
1909       _mint(msg.sender, _id, _qty, emptyBytes);
1910   }
1911 
1912     
1913     ///////////// ALLOWLIST MINTING FUNCTIONS
1914 
1915     /**
1916     * @dev Mints a single token to an address.
1917     * fee may or may not be required - required to have proof of AL*
1918     * @param _id token id of collection
1919     * @param _merkleProof merkle proof tree for sender
1920     */
1921     function mintToAL(uint256 _id, bytes32[] calldata _merkleProof) public payable whenNotPaused {
1922         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1923         require(totalSupply(_id).add(1) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1924         require(msg.value == getPrice(_id, 1), "Value needs to be exactly the mint fee!");
1925 
1926         require(inAllowlistMode(_id) && isMintingOpen(_id), "Allowlist Mode and Minting must be enabled to mint");
1927         require(isAllowlisted(msg.sender, _id, _merkleProof), "Address is not in Allowlist!");
1928         require(canMintAmount(_id, msg.sender, 1), "Wallet mint maximum reached for token.");
1929 
1930         addTokenMints(_id, msg.sender, 1);
1931         _mint(msg.sender, _id, 1, emptyBytes);
1932     }
1933 
1934     /**
1935     * @dev Mints a number of tokens to a single address.
1936     * fee may or may not be required*
1937     * @param _id token id of collection
1938     * @param _qty amount to mint
1939     * @param _merkleProof merkle proof tree for sender
1940     */
1941     function mintToMultipleAL(uint256 _id, uint256 _qty, bytes32[] calldata _merkleProof) public payable whenNotPaused {
1942         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1943         require(_qty >= 1, "Must mint at least 1 token");
1944         require(canMintQtyForTransaction(_id, _qty), "Cannot mint more than max mint per transaction");
1945         require(totalSupply(_id).add(_qty) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1946         require(msg.value == getPrice(_id, _qty), "Value needs to be exactly the mint fee!");
1947 
1948         require(inAllowlistMode(_id) && isMintingOpen(_id), "Allowlist Mode and Minting must be enabled to mint");
1949         require(isAllowlisted(msg.sender, _id, _merkleProof), "Address is not in Allowlist!");
1950         require(canMintAmount(_id, msg.sender, _qty), "Wallet mint maximum reached for token.");
1951 
1952         addTokenMints(_id, msg.sender, _qty);
1953         _mint(msg.sender, _id, _qty, emptyBytes);
1954     }
1955 
1956 
1957     /**
1958     * @dev Creates a new primary token for contract and gives creator first token
1959     * @param _tokenSupplyCap the maximum supply of tokens for this token
1960     * @param _tokenTransactionCap maximum amount of tokens one can buy per tx
1961     * @param _tokenFeeInWei payable fee per token
1962     * @param _isOpenDefaultStatus can token be publically minted once created
1963     * @param _allowTradingDefaultStatus is the token intially able to be transferred
1964     * @param _enableWalletCap is the token going to enforce wallet caps on creation
1965     * @param _walletCap wallet cap limit inital setting
1966     * @param _tokenURI the token URI to the metadata for this token
1967     */
1968     function createToken(
1969             uint256 _tokenSupplyCap, 
1970             uint256 _tokenTransactionCap,
1971             uint256 _tokenFeeInWei, 
1972             bool _isOpenDefaultStatus,
1973             bool _allowTradingDefaultStatus,
1974             bool _enableWalletCap,
1975             uint256 _walletCap,
1976             string memory _tokenURI
1977         ) public onlyOwner {
1978         require(_tokenSupplyCap > 0, "Token Supply Cap must be greater than zero.");
1979         require(_tokenTransactionCap > 0, "Token Transaction Cap must be greater than zero.");
1980         require(bytes(_tokenURI).length > 0, "Token URI cannot be an empty value");
1981 
1982         uint256 tokenId = _getNextTokenID();
1983 
1984         _mint(msg.sender, tokenId, 1, emptyBytes);
1985         baseTokenURI[tokenId] = _tokenURI;
1986 
1987         setTokenSupplyCap(tokenId, _tokenSupplyCap);
1988         setPriceForToken(tokenId, _tokenFeeInWei);
1989         setTransactionCapForToken(tokenId, _tokenTransactionCap);
1990         setInitialMintingStatus(tokenId, _isOpenDefaultStatus);
1991         setWalletCap(tokenId, _enableWalletCap, _walletCap);
1992         tokenTradingStatus[tokenId] = _allowTradingDefaultStatus ? 255 : 1;
1993 
1994         _incrementTokenTypeId();
1995     }
1996 
1997     /**
1998     * @dev pauses minting for all tokens in the contract
1999     */
2000     function pause() public onlyOwner {
2001         _pause();
2002     }
2003 
2004     /**
2005     * @dev unpauses minting for all tokens in the contract
2006     */
2007     function unpause() public onlyOwner {
2008         _unpause();
2009     }
2010 
2011     /**
2012     * @dev set the URI for a specific token on the contract
2013     * @param _id token id
2014     * @param _newTokenURI string for new metadata url (ex: ipfs://something)
2015     */
2016     function setTokenURI(uint256 _id, string memory _newTokenURI) public onlyOwner {
2017         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
2018         baseTokenURI[_id] = _newTokenURI;
2019     }
2020 
2021     /**
2022     * @dev calculates price for a token based on qty
2023     * @param _id token id
2024     * @param _qty desired amount to mint
2025     */
2026     function getPrice(uint256 _id, uint256 _qty) public view returns (uint256) {
2027         require(_qty > 0, "Quantity must be more than zero");
2028         return getPriceForToken(_id).mul(_qty);
2029     }
2030 
2031     /**
2032     * @dev prevent token from being transferred (aka soulbound)
2033     * @param tokenId token id
2034     */
2035     function setTokenUntradeable(uint256 tokenId) public onlyOwner {
2036         require(tokenTradingStatus[tokenId] != 1, "Token ID is already untradeable!");
2037         require(exists(tokenId), "Token ID does not exist!");
2038         tokenTradingStatus[tokenId] = 1;
2039     }
2040 
2041     /**
2042     * @dev allow token from being transferred - the default mode
2043     * @param tokenId token id
2044     */
2045     function setTokenTradeable(uint256 tokenId) public onlyOwner {
2046         require(tokenTradingStatus[tokenId] != 255, "Token ID is already tradeable!");
2047         require(exists(tokenId), "Token ID does not exist!");
2048         tokenTradingStatus[tokenId] = 255;
2049     }
2050 
2051     /**
2052     * @dev check if token id is tradeable
2053     * @param tokenId token id
2054     */
2055     function isTokenTradeable(uint256 tokenId) public view returns (bool) {
2056         require(exists(tokenId), "Token ID does not exist!");
2057         return tokenTradingStatus[tokenId] == 255;
2058     }
2059 
2060     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
2061         internal
2062         whenNotPaused
2063         override(ERC1155, ERC1155Supply)
2064     {
2065         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2066     }
2067 
2068     function _getNextTokenID() private view returns (uint256) {
2069         return currentTokenID.add(1);
2070     }
2071 
2072     /**
2073     * @dev increments the value of currentTokenID
2074     */
2075     function _incrementTokenTypeId() private  {
2076         currentTokenID++;
2077     }
2078 }
2079   
2080 //*********************************************************************//
2081 //*********************************************************************//  
2082 //                       Rampp v2.0.0
2083 //
2084 //         This smart contract was generated by rampp.xyz.
2085 //            Rampp allows creators like you to launch 
2086 //             large scale NFT communities without code!
2087 //
2088 //    Rampp is not responsible for the content of this contract and
2089 //        hopes it is being used in a responsible and kind way.  
2090 //       Rampp is not associated or affiliated with this project.                                                    
2091 //             Twitter: @Rampp_ ---- rampp.xyz
2092 //*********************************************************************//                                                     
2093 //*********************************************************************// 
