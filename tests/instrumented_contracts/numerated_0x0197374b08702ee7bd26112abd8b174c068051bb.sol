1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-30
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.7;
12 
13 
14 
15 // Part: Address
16 
17 // Part: Address
18 
19 // Part: Address
20 
21 /**
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if `account` is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, `isContract` will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies on extcodesize, which returns 0 for contracts in
44         // construction, since the code is only stored at the end of the
45         // constructor execution.
46 
47         uint256 size;
48         assembly {
49             size := extcodesize(account)
50         }
51         return size > 0;
52     }
53 
54     /**
55      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
56      * `recipient`, forwarding all available gas and reverting on errors.
57      *
58      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
59      * of certain opcodes, possibly making contracts go over the 2300 gas limit
60      * imposed by `transfer`, making them unable to receive funds via
61      * `transfer`. {sendValue} removes this limitation.
62      *
63      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
64      *
65      * IMPORTANT: because control is transferred to `recipient`, care must be
66      * taken to not create reentrancy vulnerabilities. Consider using
67      * {ReentrancyGuard} or the
68      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
69      */
70     function sendValue(address payable recipient, uint256 amount) internal {
71         require(address(this).balance >= amount, "Address: insufficient balance");
72 
73         (bool success, ) = recipient.call{value: amount}("");
74         require(success, "Address: unable to send value, recipient may have reverted");
75     }
76 
77     /**
78      * @dev Performs a Solidity function call using a low level `call`. A
79      * plain `call` is an unsafe replacement for a function call: use this
80      * function instead.
81      *
82      * If `target` reverts with a revert reason, it is bubbled up by this
83      * function (like regular Solidity function calls).
84      *
85      * Returns the raw returned data. To convert to the expected return value,
86      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
87      *
88      * Requirements:
89      *
90      * - `target` must be a contract.
91      * - calling `target` with `data` must not revert.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96         return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
101      * `errorMessage` as a fallback revert reason when `target` reverts.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(
106         address target,
107         bytes memory data,
108         string memory errorMessage
109     ) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, 0, errorMessage);
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
115      * but also transferring `value` wei to `target`.
116      *
117      * Requirements:
118      *
119      * - the calling contract must have an ETH balance of at least `value`.
120      * - the called Solidity function must be `payable`.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(
125         address target,
126         bytes memory data,
127         uint256 value
128     ) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
134      * with `errorMessage` as a fallback revert reason when `target` reverts.
135      *
136      * _Available since v3.1._
137      */
138     function functionCallWithValue(
139         address target,
140         bytes memory data,
141         uint256 value,
142         string memory errorMessage
143     ) internal returns (bytes memory) {
144         require(address(this).balance >= value, "Address: insufficient balance for call");
145         require(isContract(target), "Address: call to non-contract");
146 
147         (bool success, bytes memory returndata) = target.call{value: value}(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
158         return functionStaticCall(target, data, "Address: low-level static call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal view returns (bytes memory) {
172         require(isContract(target), "Address: static call to non-contract");
173 
174         (bool success, bytes memory returndata) = target.staticcall(data);
175         return _verifyCallResult(success, returndata, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but performing a delegate call.
181      *
182      * _Available since v3.4._
183      */
184     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
190      * but performing a delegate call.
191      *
192      * _Available since v3.4._
193      */
194     function functionDelegateCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         require(isContract(target), "Address: delegate call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.delegatecall(data);
202         return _verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     function _verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) private pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 // Part: Context
229 
230 // Part: Context
231 
232 // Part: Context
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes calldata) {
250         return msg.data;
251     }
252 }
253 
254 // Part: Counters
255 
256 // Part: Counters
257 
258 // Part: Counters
259 
260 /**
261  * @title Counters
262  * @author Matt Condon (@shrugs)
263  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
264  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
265  *
266  * Include with `using Counters for Counters.Counter;`
267  */
268 library Counters {
269     struct Counter {
270         // This variable should never be directly accessed by users of the library: interactions must be restricted to
271         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
272         // this feature: see https://github.com/ethereum/solidity/issues/4637
273         uint256 _value; // default: 0
274     }
275 
276     function current(Counter storage counter) internal view returns (uint256) {
277         return counter._value;
278     }
279 
280     function increment(Counter storage counter) internal {
281         unchecked {
282             counter._value += 1;
283         }
284     }
285 
286     function decrement(Counter storage counter) internal {
287         uint256 value = counter._value;
288         require(value > 0, "Counter: decrement overflow");
289         unchecked {
290             counter._value = value - 1;
291         }
292     }
293 
294     function reset(Counter storage counter) internal {
295         counter._value = 0;
296     }
297 }
298 
299 // Part: IERC165
300 
301 // Part: IERC165
302 
303 // Part: IERC165
304 
305 /**
306  * @dev Interface of the ERC165 standard, as defined in the
307  * https://eips.ethereum.org/EIPS/eip-165[EIP].
308  *
309  * Implementers can declare support of contract interfaces, which can then be
310  * queried by others ({ERC165Checker}).
311  *
312  * For an implementation, see {ERC165}.
313  */
314 interface IERC165 {
315     /**
316      * @dev Returns true if this contract implements the interface defined by
317      * `interfaceId`. See the corresponding
318      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
319      * to learn more about how these ids are created.
320      *
321      * This function call must use less than 30 000 gas.
322      */
323     function supportsInterface(bytes4 interfaceId) external view returns (bool);
324 }
325 
326 // Part: IERC721Receiver
327 
328 // Part: IERC721Receiver
329 
330 // Part: IERC721Receiver
331 
332 /**
333  * @title ERC721 token receiver interface
334  * @dev Interface for any contract that wants to support safeTransfers
335  * from ERC721 asset contracts.
336  */
337 interface IERC721Receiver {
338     /**
339      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
340      * by `operator` from `from`, this function is called.
341      *
342      * It must return its Solidity selector to confirm the token transfer.
343      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
344      *
345      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
346      */
347     function onERC721Received(
348         address operator,
349         address from,
350         uint256 tokenId,
351         bytes calldata data
352     ) external returns (bytes4);
353 }
354 
355 // Part: ReentrancyGuard
356 
357 // Part: ReentrancyGuard
358 
359 // Part: ReentrancyGuard
360 
361 /**
362  * @dev Contract module that helps prevent reentrant calls to a function.
363  *
364  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
365  * available, which can be applied to functions to make sure there are no nested
366  * (reentrant) calls to them.
367  *
368  * Note that because there is a single `nonReentrant` guard, functions marked as
369  * `nonReentrant` may not call one another. This can be worked around by making
370  * those functions `private`, and then adding `external` `nonReentrant` entry
371  * points to them.
372  *
373  * TIP: If you would like to learn more about reentrancy and alternative ways
374  * to protect against it, check out our blog post
375  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
376  */
377 abstract contract ReentrancyGuard {
378     // Booleans are more expensive than uint256 or any type that takes up a full
379     // word because each write operation emits an extra SLOAD to first read the
380     // slot's contents, replace the bits taken up by the boolean, and then write
381     // back. This is the compiler's defense against contract upgrades and
382     // pointer aliasing, and it cannot be disabled.
383 
384     // The values being non-zero value makes deployment a bit more expensive,
385     // but in exchange the refund on every call to nonReentrant will be lower in
386     // amount. Since refunds are capped to a percentage of the total
387     // transaction's gas, it is best to keep them low in cases like this one, to
388     // increase the likelihood of the full refund coming into effect.
389     uint256 private constant _NOT_ENTERED = 1;
390     uint256 private constant _ENTERED = 2;
391 
392     uint256 private _status;
393 
394     constructor() {
395         _status = _NOT_ENTERED;
396     }
397 
398     /**
399      * @dev Prevents a contract from calling itself, directly or indirectly.
400      * Calling a `nonReentrant` function from another `nonReentrant`
401      * function is not supported. It is possible to prevent this from happening
402      * by making the `nonReentrant` function external, and make it call a
403      * `private` function that does the actual work.
404      */
405     modifier nonReentrant() {
406         // On the first call to nonReentrant, _notEntered will be true
407         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
408 
409         // Any calls to nonReentrant after this point will fail
410         _status = _ENTERED;
411 
412         _;
413 
414         // By storing the original value once again, a refund is triggered (see
415         // https://eips.ethereum.org/EIPS/eip-2200)
416         _status = _NOT_ENTERED;
417     }
418 }
419 
420 // Part: SafeMath
421 
422 // Part: SafeMath
423 
424 // Part: SafeMath
425 
426 // CAUTION
427 // This version of SafeMath should only be used with Solidity 0.8 or later,
428 // because it relies on the compiler's built in overflow checks.
429 
430 /**
431  * @dev Wrappers over Solidity's arithmetic operations.
432  *
433  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
434  * now has built in overflow checking.
435  */
436 library SafeMath {
437     /**
438      * @dev Returns the addition of two unsigned integers, with an overflow flag.
439      *
440      * _Available since v3.4._
441      */
442     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
443         unchecked {
444             uint256 c = a + b;
445             if (c < a) return (false, 0);
446             return (true, c);
447         }
448     }
449 
450     /**
451      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
452      *
453      * _Available since v3.4._
454      */
455     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
456         unchecked {
457             if (b > a) return (false, 0);
458             return (true, a - b);
459         }
460     }
461 
462     /**
463      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
464      *
465      * _Available since v3.4._
466      */
467     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
468         unchecked {
469             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
470             // benefit is lost if 'b' is also tested.
471             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
472             if (a == 0) return (true, 0);
473             uint256 c = a * b;
474             if (c / a != b) return (false, 0);
475             return (true, c);
476         }
477     }
478 
479     /**
480      * @dev Returns the division of two unsigned integers, with a division by zero flag.
481      *
482      * _Available since v3.4._
483      */
484     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
485         unchecked {
486             if (b == 0) return (false, 0);
487             return (true, a / b);
488         }
489     }
490 
491     /**
492      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
493      *
494      * _Available since v3.4._
495      */
496     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
497         unchecked {
498             if (b == 0) return (false, 0);
499             return (true, a % b);
500         }
501     }
502 
503     /**
504      * @dev Returns the addition of two unsigned integers, reverting on
505      * overflow.
506      *
507      * Counterpart to Solidity's `+` operator.
508      *
509      * Requirements:
510      *
511      * - Addition cannot overflow.
512      */
513     function add(uint256 a, uint256 b) internal pure returns (uint256) {
514         return a + b;
515     }
516 
517     /**
518      * @dev Returns the subtraction of two unsigned integers, reverting on
519      * overflow (when the result is negative).
520      *
521      * Counterpart to Solidity's `-` operator.
522      *
523      * Requirements:
524      *
525      * - Subtraction cannot overflow.
526      */
527     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
528         return a - b;
529     }
530 
531     /**
532      * @dev Returns the multiplication of two unsigned integers, reverting on
533      * overflow.
534      *
535      * Counterpart to Solidity's `*` operator.
536      *
537      * Requirements:
538      *
539      * - Multiplication cannot overflow.
540      */
541     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
542         return a * b;
543     }
544 
545     /**
546      * @dev Returns the integer division of two unsigned integers, reverting on
547      * division by zero. The result is rounded towards zero.
548      *
549      * Counterpart to Solidity's `/` operator.
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         return a / b;
557     }
558 
559     /**
560      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
561      * reverting when dividing by zero.
562      *
563      * Counterpart to Solidity's `%` operator. This function uses a `revert`
564      * opcode (which leaves remaining gas untouched) while Solidity uses an
565      * invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
572         return a % b;
573     }
574 
575     /**
576      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
577      * overflow (when the result is negative).
578      *
579      * CAUTION: This function is deprecated because it requires allocating memory for the error
580      * message unnecessarily. For custom revert reasons use {trySub}.
581      *
582      * Counterpart to Solidity's `-` operator.
583      *
584      * Requirements:
585      *
586      * - Subtraction cannot overflow.
587      */
588     function sub(
589         uint256 a,
590         uint256 b,
591         string memory errorMessage
592     ) internal pure returns (uint256) {
593         unchecked {
594             require(b <= a, errorMessage);
595             return a - b;
596         }
597     }
598 
599     /**
600      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
601      * division by zero. The result is rounded towards zero.
602      *
603      * Counterpart to Solidity's `/` operator. Note: this function uses a
604      * `revert` opcode (which leaves remaining gas untouched) while Solidity
605      * uses an invalid opcode to revert (consuming all remaining gas).
606      *
607      * Requirements:
608      *
609      * - The divisor cannot be zero.
610      */
611     function div(
612         uint256 a,
613         uint256 b,
614         string memory errorMessage
615     ) internal pure returns (uint256) {
616         unchecked {
617             require(b > 0, errorMessage);
618             return a / b;
619         }
620     }
621 
622     /**
623      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
624      * reverting with custom message when dividing by zero.
625      *
626      * CAUTION: This function is deprecated because it requires allocating memory for the error
627      * message unnecessarily. For custom revert reasons use {tryMod}.
628      *
629      * Counterpart to Solidity's `%` operator. This function uses a `revert`
630      * opcode (which leaves remaining gas untouched) while Solidity uses an
631      * invalid opcode to revert (consuming all remaining gas).
632      *
633      * Requirements:
634      *
635      * - The divisor cannot be zero.
636      */
637     function mod(
638         uint256 a,
639         uint256 b,
640         string memory errorMessage
641     ) internal pure returns (uint256) {
642         unchecked {
643             require(b > 0, errorMessage);
644             return a % b;
645         }
646     }
647 }
648 
649 // Part: Strings
650 
651 // Part: Strings
652 
653 // Part: Strings
654 
655 /**
656  * @dev String operations.
657  */
658 library Strings {
659     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
660 
661     /**
662      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
663      */
664     function toString(uint256 value) internal pure returns (string memory) {
665         // Inspired by OraclizeAPI's implementation - MIT licence
666         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
667 
668         if (value == 0) {
669             return "0";
670         }
671         uint256 temp = value;
672         uint256 digits;
673         while (temp != 0) {
674             digits++;
675             temp /= 10;
676         }
677         bytes memory buffer = new bytes(digits);
678         while (value != 0) {
679             digits -= 1;
680             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
681             value /= 10;
682         }
683         return string(buffer);
684     }
685 
686     /**
687      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
688      */
689     function toHexString(uint256 value) internal pure returns (string memory) {
690         if (value == 0) {
691             return "0x00";
692         }
693         uint256 temp = value;
694         uint256 length = 0;
695         while (temp != 0) {
696             length++;
697             temp >>= 8;
698         }
699         return toHexString(value, length);
700     }
701 
702     /**
703      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
704      */
705     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
706         bytes memory buffer = new bytes(2 * length + 2);
707         buffer[0] = "0";
708         buffer[1] = "x";
709         for (uint256 i = 2 * length + 1; i > 1; --i) {
710             buffer[i] = _HEX_SYMBOLS[value & 0xf];
711             value >>= 4;
712         }
713         require(value == 0, "Strings: hex length insufficient");
714         return string(buffer);
715     }
716 }
717 
718 // Part: ERC165
719 
720 // Part: ERC165
721 
722 // Part: ERC165
723 
724 /**
725  * @dev Implementation of the {IERC165} interface.
726  *
727  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
728  * for the additional interface id that will be supported. For example:
729  *
730  * ```solidity
731  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
732  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
733  * }
734  * ```
735  *
736  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
737  */
738 abstract contract ERC165 is IERC165 {
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
743         return interfaceId == type(IERC165).interfaceId;
744     }
745 }
746 
747 // Part: IERC721
748 
749 // Part: IERC721
750 
751 // Part: IERC721
752 
753 /**
754  * @dev Required interface of an ERC721 compliant contract.
755  */
756 interface IERC721 is IERC165 {
757     /**
758      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
759      */
760     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
761 
762     /**
763      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
764      */
765     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
766 
767     /**
768      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
769      */
770     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
771 
772     /**
773      * @dev Returns the number of tokens in ``owner``'s account.
774      */
775     function balanceOf(address owner) external view returns (uint256 balance);
776 
777     /**
778      * @dev Returns the owner of the `tokenId` token.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      */
784     function ownerOf(uint256 tokenId) external view returns (address owner);
785 
786     /**
787      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
788      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external;
805 
806     /**
807      * @dev Transfers `tokenId` token from `from` to `to`.
808      *
809      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must be owned by `from`.
816      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
817      *
818      * Emits a {Transfer} event.
819      */
820     function transferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) external;
825 
826     /**
827      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
828      * The approval is cleared when the token is transferred.
829      *
830      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
831      *
832      * Requirements:
833      *
834      * - The caller must own the token or be an approved operator.
835      * - `tokenId` must exist.
836      *
837      * Emits an {Approval} event.
838      */
839     function approve(address to, uint256 tokenId) external;
840 
841     /**
842      * @dev Returns the account approved for `tokenId` token.
843      *
844      * Requirements:
845      *
846      * - `tokenId` must exist.
847      */
848     function getApproved(uint256 tokenId) external view returns (address operator);
849 
850     /**
851      * @dev Approve or remove `operator` as an operator for the caller.
852      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
853      *
854      * Requirements:
855      *
856      * - The `operator` cannot be the caller.
857      *
858      * Emits an {ApprovalForAll} event.
859      */
860     function setApprovalForAll(address operator, bool _approved) external;
861 
862     /**
863      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
864      *
865      * See {setApprovalForAll}
866      */
867     function isApprovedForAll(address owner, address operator) external view returns (bool);
868 
869     /**
870      * @dev Safely transfers `tokenId` token from `from` to `to`.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must exist and be owned by `from`.
877      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
878      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
879      *
880      * Emits a {Transfer} event.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes calldata data
887     ) external;
888 }
889 
890 // Part: Ownable
891 
892 // Part: Ownable
893 
894 // Part: Ownable
895 
896 /**
897  * @dev Contract module which provides a basic access control mechanism, where
898  * there is an account (an owner) that can be granted exclusive access to
899  * specific functions.
900  *
901  * By default, the owner account will be the one that deploys the contract. This
902  * can later be changed with {transferOwnership}.
903  *
904  * This module is used through inheritance. It will make available the modifier
905  * `onlyOwner`, which can be applied to your functions to restrict their use to
906  * the owner.
907  */
908 abstract contract Ownable is Context {
909     address private _owner;
910 
911     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
912 
913     /**
914      * @dev Initializes the contract setting the deployer as the initial owner.
915      */
916     constructor() {
917         _setOwner(_msgSender());
918     }
919 
920     /**
921      * @dev Returns the address of the current owner.
922      */
923     function owner() public view virtual returns (address) {
924         return _owner;
925     }
926 
927     /**
928      * @dev Throws if called by any account other than the owner.
929      */
930     modifier onlyOwner() {
931         require(owner() == _msgSender(), "Ownable: caller is not the owner");
932         _;
933     }
934 
935     /**
936      * @dev Leaves the contract without owner. It will not be possible to call
937      * `onlyOwner` functions anymore. Can only be called by the current owner.
938      *
939      * NOTE: Renouncing ownership will leave the contract without an owner,
940      * thereby removing any functionality that is only available to the owner.
941      */
942     function renounceOwnership() public virtual onlyOwner {
943         _setOwner(address(0));
944     }
945 
946     /**
947      * @dev Transfers ownership of the contract to a new account (`newOwner`).
948      * Can only be called by the current owner.
949      */
950     function transferOwnership(address newOwner) public virtual onlyOwner {
951         require(newOwner != address(0), "Ownable: new owner is the zero address");
952         _setOwner(newOwner);
953     }
954 
955 
956     function _setOwner(address newOwner) private {
957         address oldOwner = _owner;
958         _owner = newOwner;
959         emit OwnershipTransferred(oldOwner, newOwner);
960     }
961 }
962 
963 // Part: IERC721Metadata
964 
965 // Part: IERC721Metadata
966 
967 // Part: IERC721Metadata
968 
969 /**
970  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
971  * @dev See https://eips.ethereum.org/EIPS/eip-721
972  */
973 interface IERC721Metadata is IERC721 {
974     /**
975      * @dev Returns the token collection name.
976      */
977     function name() external view returns (string memory);
978 
979     /**
980      * @dev Returns the token collection symbol.
981      */
982     function symbol() external view returns (string memory);
983 
984     /**
985      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
986      */
987     function tokenURI(uint256 tokenId) external view returns (string memory);
988 }
989 
990 // Part: ERC721
991 
992 // Part: ERC721
993 
994 // Part: ERC721
995 
996 /**
997  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
998  * the Metadata extension, but not including the Enumerable extension, which is available separately as
999  * {ERC721Enumerable}.
1000  */
1001 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1002     using Address for address;
1003     using Strings for uint256;
1004 
1005     // Token name
1006     string private _name;
1007 
1008     // Token symbol
1009     string private _symbol;
1010 
1011     // Mapping from token ID to owner address
1012     mapping(uint256 => address) private _owners;
1013 
1014     // Mapping owner address to token count
1015     mapping(address => uint256) private _balances;
1016 
1017     // Mapping from token ID to approved address
1018     mapping(uint256 => address) private _tokenApprovals;
1019 
1020     // Mapping from owner to operator approvals
1021     mapping(address => mapping(address => bool)) private _operatorApprovals;
1022 
1023     /**
1024      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1025      */
1026     constructor(string memory name_, string memory symbol_) {
1027         _name = name_;
1028         _symbol = symbol_;
1029     }
1030 
1031     /**
1032      * @dev See {IERC165-supportsInterface}.
1033      */
1034     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1035         return
1036             interfaceId == type(IERC721).interfaceId ||
1037             interfaceId == type(IERC721Metadata).interfaceId ||
1038             super.supportsInterface(interfaceId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-balanceOf}.
1043      */
1044     function balanceOf(address owner) public view virtual override returns (uint256) {
1045         require(owner != address(0), "ERC721: balance query for the zero address");
1046         return _balances[owner];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-ownerOf}.
1051      */
1052     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1053         address owner = _owners[tokenId];
1054         require(owner != address(0), "ERC721: owner query for nonexistent token");
1055         return owner;
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Metadata-name}.
1060      */
1061     function name() public view virtual override returns (string memory) {
1062         return _name;
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Metadata-symbol}.
1067      */
1068     function symbol() public view virtual override returns (string memory) {
1069         return _symbol;
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Metadata-tokenURI}.
1074      */
1075     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1076         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1077 
1078         string memory baseURI = _baseURI();
1079         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1080     }
1081 
1082 
1083     /**
1084      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1085      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1086      * by default, can be overriden in child contracts.
1087      */
1088     function _baseURI() internal view virtual returns (string memory) {
1089         return "";
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-approve}.
1094      */
1095     function approve(address to, uint256 tokenId) public virtual override {
1096         address owner = ERC721.ownerOf(tokenId);
1097         require(to != owner, "ERC721: approval to current owner");
1098 
1099         require(
1100             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1101             "ERC721: approve caller is not owner nor approved for all"
1102         );
1103 
1104         _approve(to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-getApproved}.
1109      */
1110     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1111         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1112 
1113         return _tokenApprovals[tokenId];
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-setApprovalForAll}.
1118      */
1119     function setApprovalForAll(address operator, bool approved) public virtual override {
1120         require(operator != _msgSender(), "ERC721: approve to caller");
1121 
1122         _operatorApprovals[_msgSender()][operator] = approved;
1123         emit ApprovalForAll(_msgSender(), operator, approved);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-isApprovedForAll}.
1128      */
1129     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1130         return _operatorApprovals[owner][operator];
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-transferFrom}.
1135      */
1136     function transferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) public virtual override {
1141         //solhint-disable-next-line max-line-length
1142         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1143 
1144         _transfer(from, to, tokenId);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-safeTransferFrom}.
1149      */
1150     function safeTransferFrom(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) public virtual override {
1155         safeTransferFrom(from, to, tokenId, "");
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-safeTransferFrom}.
1160      */
1161     function safeTransferFrom(
1162         address from,
1163         address to,
1164         uint256 tokenId,
1165         bytes memory _data
1166     ) public virtual override {
1167         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1168         _safeTransfer(from, to, tokenId, _data);
1169     }
1170 
1171     /**
1172      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1173      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1174      *
1175      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1176      *
1177      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1178      * implement alternative mechanisms to perform token transfer, such as signature-based.
1179      *
1180      * Requirements:
1181      *
1182      * - `from` cannot be the zero address.
1183      * - `to` cannot be the zero address.
1184      * - `tokenId` token must exist and be owned by `from`.
1185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _safeTransfer(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) internal virtual {
1195         _transfer(from, to, tokenId);
1196         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1197     }
1198 
1199     /**
1200      * @dev Returns whether `tokenId` exists.
1201      *
1202      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1203      *
1204      * Tokens start existing when they are minted (`_mint`),
1205      * and stop existing when they are burned (`_burn`).
1206      */
1207     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1208         return _owners[tokenId] != address(0);
1209     }
1210 
1211     /**
1212      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      */
1218     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1219         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1220         address owner = ERC721.ownerOf(tokenId);
1221         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1222     }
1223 
1224     /**
1225      * @dev Safely mints `tokenId` and transfers it to `to`.
1226      *
1227      * Requirements:
1228      *
1229      * - `tokenId` must not exist.
1230      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _safeMint(address to, uint256 tokenId) internal virtual {
1235         _safeMint(to, tokenId, "");
1236     }
1237 
1238     /**
1239      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1240      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1241      */
1242     function _safeMint(
1243         address to,
1244         uint256 tokenId,
1245         bytes memory _data
1246     ) internal virtual {
1247         _mint(to, tokenId);
1248         require(
1249             _checkOnERC721Received(address(0), to, tokenId, _data),
1250             "ERC721: transfer to non ERC721Receiver implementer"
1251         );
1252     }
1253 
1254     /**
1255      * @dev Mints `tokenId` and transfers it to `to`.
1256      *
1257      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must not exist.
1262      * - `to` cannot be the zero address.
1263      *
1264      * Emits a {Transfer} event.
1265      */
1266     function _mint(address to, uint256 tokenId) internal virtual {
1267         require(to != address(0), "ERC721: mint to the zero address");
1268         require(!_exists(tokenId), "ERC721: token already minted");
1269 
1270         _beforeTokenTransfer(address(0), to, tokenId);
1271 
1272         _balances[to] += 1;
1273         _owners[tokenId] = to;
1274 
1275         emit Transfer(address(0), to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Destroys `tokenId`.
1280      * The approval is cleared when the token is burned.
1281      *
1282      * Requirements:
1283      *
1284      * - `tokenId` must exist.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function _burn(uint256 tokenId) internal virtual {
1289         address owner = ERC721.ownerOf(tokenId);
1290 
1291         _beforeTokenTransfer(owner, address(0), tokenId);
1292 
1293         // Clear approvals
1294         _approve(address(0), tokenId);
1295 
1296         _balances[owner] -= 1;
1297         delete _owners[tokenId];
1298 
1299         emit Transfer(owner, address(0), tokenId);
1300     }
1301 
1302     /**
1303      * @dev Transfers `tokenId` from `from` to `to`.
1304      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1305      *
1306      * Requirements:
1307      *
1308      * - `to` cannot be the zero address.
1309      * - `tokenId` token must be owned by `from`.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _transfer(
1314         address from,
1315         address to,
1316         uint256 tokenId
1317     ) internal virtual {
1318         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1319         require(to != address(0), "ERC721: transfer to the zero address");
1320 
1321         _beforeTokenTransfer(from, to, tokenId);
1322 
1323         // Clear approvals from the previous owner
1324         _approve(address(0), tokenId);
1325 
1326         _balances[from] -= 1;
1327         _balances[to] += 1;
1328         _owners[tokenId] = to;
1329 
1330         emit Transfer(from, to, tokenId);
1331     }
1332 
1333     /**
1334      * @dev Approve `to` to operate on `tokenId`
1335      *
1336      * Emits a {Approval} event.
1337      */
1338     function _approve(address to, uint256 tokenId) internal virtual {
1339         _tokenApprovals[tokenId] = to;
1340         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1345      * The call is not executed if the target address is not a contract.
1346      *
1347      * @param from address representing the previous owner of the given token ID
1348      * @param to target address that will receive the tokens
1349      * @param tokenId uint256 ID of the token to be transferred
1350      * @param _data bytes optional data to send along with the call
1351      * @return bool whether the call correctly returned the expected magic value
1352      */
1353     function _checkOnERC721Received(
1354         address from,
1355         address to,
1356         uint256 tokenId,
1357         bytes memory _data
1358     ) private returns (bool) {
1359         if (to.isContract()) {
1360             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1361                 return retval == IERC721Receiver(to).onERC721Received.selector;
1362             } catch (bytes memory reason) {
1363                 if (reason.length == 0) {
1364                     revert("ERC721: transfer to non ERC721Receiver implementer");
1365                 } else {
1366                     assembly {
1367                         revert(add(32, reason), mload(reason))
1368                     }
1369                 }
1370             }
1371         } else {
1372             return true;
1373         }
1374     }
1375 
1376     /**
1377      * @dev Hook that is called before any token transfer. This includes minting
1378      * and burning.
1379      *
1380      * Calling conditions:
1381      *
1382      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1383      * transferred to `to`.
1384      * - When `from` is zero, `tokenId` will be minted for `to`.
1385      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1386      * - `from` and `to` are never both zero.
1387      *
1388      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1389      */
1390     function _beforeTokenTransfer(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) internal virtual {}
1395 }
1396 
1397 // File: main.sol
1398 
1399 // File: main.sol
1400 
1401 // File: main.sol
1402 
1403 contract CryptoDoctors is ERC721, Ownable, ReentrancyGuard {
1404   using Counters for Counters.Counter;
1405   using SafeMath for uint256;
1406   Counters.Counter public _tokenIds;
1407   uint256 public _mintCost = 0.04 ether;
1408   uint256 public _maxSupply = 502;
1409   bool public _isPublicMintEnabled = true;
1410   string public _baseTokenURI = "https://cryptodoctors.io/doctors/metamadness/";
1411   
1412   /**
1413   * @dev Initializes the contract setting the `tokenName` and `symbol` of the nft, `cost` of each mint call, and maximum `supply` of the nft.
1414   * Note: `cost` is in wei. 
1415   */
1416   constructor() ERC721("Crypto Doctors", "CD") {
1417   }
1418 
1419     /*
1420     * Pause sale if active, make active if paused
1421     */
1422   function flipSaleState() public onlyOwner {
1423     _isPublicMintEnabled = !_isPublicMintEnabled;
1424   }
1425 
1426   /**
1427   * @dev Mint `count` tokens if requirements are satisfied.
1428   * 
1429   */
1430   function mintTokens(uint256 count)
1431   public
1432   payable
1433   nonReentrant{
1434     require(_isPublicMintEnabled, "Mint disabled");
1435     require(count > 0 && count <= 10, "Min 1, Max 10 is allowed per tx");
1436     require(count.add(_tokenIds.current()) < _maxSupply, "Exceeds max supply");
1437     require(owner() == msg.sender || msg.value >= _mintCost.mul(count),
1438            "Ether value sent is below the price");
1439     for(uint i=0; i<count; i++){
1440         _mint(msg.sender);
1441      }
1442   }
1443 
1444 
1445   /**
1446   * @dev Update the cost to mint a token.
1447   * Can only be called by the current owner.
1448   */
1449   function setCost(uint256 cost) public onlyOwner{
1450     _mintCost = cost;
1451   }
1452 
1453   /**
1454   * @dev Update the max supply.
1455   * Can only be called by the current owner.
1456   */
1457   function setMaxSupply(uint256 max) public onlyOwner{
1458     _maxSupply = max;
1459   }
1460 
1461   function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
1462     _baseTokenURI = __baseTokenURI;
1463   }
1464 
1465 
1466   /**
1467   * @dev Transfers contract balance to contract owner.
1468   * Can only be called by the current owner.
1469   */
1470   function setApprovalForWithdraw() public onlyOwner{
1471     payable(owner()).transfer(address(this).balance);
1472   }
1473   
1474   
1475 
1476   /**
1477   * @dev Used by public mint functions and by owner functions.
1478   * Can only be called internally by other functions.
1479   */
1480   function _mint(address to) internal virtual returns (uint256){
1481     _tokenIds.increment();
1482     uint256 id = _tokenIds.current();
1483     _safeMint(to, id);
1484 
1485     return id;
1486   }
1487 
1488   function getCost() public view returns (uint256){
1489     return _mintCost;
1490   }
1491   function totalSupply() public view returns (uint256){
1492     return _maxSupply;
1493   }
1494   function getCurrentSupply() public view returns (uint256){
1495     return _tokenIds.current();
1496   }
1497   function getMintStatus() public view returns (bool) {
1498     return _isPublicMintEnabled;
1499   }
1500 
1501   /**
1502   * @dev Returns a URI for a given token ID's metadata
1503   */
1504   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1505     return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId), ".json"));
1506   }
1507 
1508 }