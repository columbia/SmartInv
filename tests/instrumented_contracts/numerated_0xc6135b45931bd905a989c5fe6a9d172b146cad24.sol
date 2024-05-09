1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
3 pragma solidity ^0.8.0;
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b)
22         internal
23         pure
24         returns (bool, uint256)
25     {
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
38     function trySub(uint256 a, uint256 b)
39         internal
40         pure
41         returns (bool, uint256)
42     {
43         unchecked {
44             if (b > a) return (false, 0);
45             return (true, a - b);
46         }
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryMul(uint256 a, uint256 b)
55         internal
56         pure
57         returns (bool, uint256)
58     {
59         unchecked {
60             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61             // benefit is lost if 'b' is also tested.
62             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63             if (a == 0) return (true, 0);
64             uint256 c = a * b;
65             if (c / a != b) return (false, 0);
66             return (true, c);
67         }
68     }
69 
70     /**
71      * @dev Returns the division of two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryDiv(uint256 a, uint256 b)
76         internal
77         pure
78         returns (bool, uint256)
79     {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a / b);
83         }
84     }
85 
86     /**
87      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryMod(uint256 a, uint256 b)
92         internal
93         pure
94         returns (bool, uint256)
95     {
96         unchecked {
97             if (b == 0) return (false, 0);
98             return (true, a % b);
99         }
100     }
101 
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a + b;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a - b;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      *
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a * b;
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers, reverting on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator.
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a / b;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * reverting when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return a % b;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
176      * overflow (when the result is negative).
177      *
178      * CAUTION: This function is deprecated because it requires allocating memory for the error
179      * message unnecessarily. For custom revert reasons use {trySub}.
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(
188         uint256 a,
189         uint256 b,
190         string memory errorMessage
191     ) internal pure returns (uint256) {
192         unchecked {
193             require(b <= a, errorMessage);
194             return a - b;
195         }
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(
211         uint256 a,
212         uint256 b,
213         string memory errorMessage
214     ) internal pure returns (uint256) {
215         unchecked {
216             require(b > 0, errorMessage);
217             return a / b;
218         }
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting with custom message when dividing by zero.
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {tryMod}.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         unchecked {
242             require(b > 0, errorMessage);
243             return a % b;
244         }
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Strings.sol
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev String operations.
254  */
255 library Strings {
256     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
257 
258     /**
259      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
260      */
261     function toString(uint256 value) internal pure returns (string memory) {
262         // Inspired by OraclizeAPI's implementation - MIT licence
263         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
264 
265         if (value == 0) {
266             return "0";
267         }
268         uint256 temp = value;
269         uint256 digits;
270         while (temp != 0) {
271             digits++;
272             temp /= 10;
273         }
274         bytes memory buffer = new bytes(digits);
275         while (value != 0) {
276             digits -= 1;
277             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
278             value /= 10;
279         }
280         return string(buffer);
281     }
282 
283     /**
284      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
285      */
286     function toHexString(uint256 value) internal pure returns (string memory) {
287         if (value == 0) {
288             return "0x00";
289         }
290         uint256 temp = value;
291         uint256 length = 0;
292         while (temp != 0) {
293             length++;
294             temp >>= 8;
295         }
296         return toHexString(value, length);
297     }
298 
299     /**
300      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
301      */
302     function toHexString(uint256 value, uint256 length)
303         internal
304         pure
305         returns (string memory)
306     {
307         bytes memory buffer = new bytes(2 * length + 2);
308         buffer[0] = "0";
309         buffer[1] = "x";
310         for (uint256 i = 2 * length + 1; i > 1; --i) {
311             buffer[i] = _HEX_SYMBOLS[value & 0xf];
312             value >>= 4;
313         }
314         require(value == 0, "Strings: hex length insufficient");
315         return string(buffer);
316     }
317 }
318 
319 // File: @openzeppelin/contracts/utils/Address.sol
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * [IMPORTANT]
331      * ====
332      * It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      *
335      * Among others, `isContract` will return false for the following
336      * types of addresses:
337      *
338      *  - an externally-owned account
339      *  - a contract in construction
340      *  - an address where a contract will be created
341      *  - an address where a contract lived, but was destroyed
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies on extcodesize, which returns 0 for contracts in
346         // construction, since the code is only stored at the end of the
347         // constructor execution.
348 
349         uint256 size;
350         assembly {
351             size := extcodesize(account)
352         }
353         return size > 0;
354     }
355 
356     /**
357      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358      * `recipient`, forwarding all available gas and reverting on errors.
359      *
360      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361      * of certain opcodes, possibly making contracts go over the 2300 gas limit
362      * imposed by `transfer`, making them unable to receive funds via
363      * `transfer`. {sendValue} removes this limitation.
364      *
365      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366      *
367      * IMPORTANT: because control is transferred to `recipient`, care must be
368      * taken to not create reentrancy vulnerabilities. Consider using
369      * {ReentrancyGuard} or the
370      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(
374             address(this).balance >= amount,
375             "Address: insufficient balance"
376         );
377 
378         (bool success, ) = recipient.call{value: amount}("");
379         require(
380             success,
381             "Address: unable to send value, recipient may have reverted"
382         );
383     }
384 
385     /**
386      * @dev Performs a Solidity function call using a low level `call`. A
387      * plain `call` is an unsafe replacement for a function call: use this
388      * function instead.
389      *
390      * If `target` reverts with a revert reason, it is bubbled up by this
391      * function (like regular Solidity function calls).
392      *
393      * Returns the raw returned data. To convert to the expected return value,
394      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
395      *
396      * Requirements:
397      *
398      * - `target` must be a contract.
399      * - calling `target` with `data` must not revert.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data)
404         internal
405         returns (bytes memory)
406     {
407         return functionCall(target, data, "Address: low-level call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
412      * `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, 0, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but also transferring `value` wei to `target`.
427      *
428      * Requirements:
429      *
430      * - the calling contract must have an ETH balance of at least `value`.
431      * - the called Solidity function must be `payable`.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value
439     ) internal returns (bytes memory) {
440         return
441             functionCallWithValue(
442                 target,
443                 data,
444                 value,
445                 "Address: low-level call with value failed"
446             );
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value,
459         string memory errorMessage
460     ) internal returns (bytes memory) {
461         require(
462             address(this).balance >= value,
463             "Address: insufficient balance for call"
464         );
465         require(isContract(target), "Address: call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.call{value: value}(
468             data
469         );
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a static call.
476      *
477      * _Available since v3.3._
478      */
479     function functionStaticCall(address target, bytes memory data)
480         internal
481         view
482         returns (bytes memory)
483     {
484         return
485             functionStaticCall(
486                 target,
487                 data,
488                 "Address: low-level static call failed"
489             );
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
494      * but performing a static call.
495      *
496      * _Available since v3.3._
497      */
498     function functionStaticCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal view returns (bytes memory) {
503         require(isContract(target), "Address: static call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.staticcall(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(address target, bytes memory data)
516         internal
517         returns (bytes memory)
518     {
519         return
520             functionDelegateCall(
521                 target,
522                 data,
523                 "Address: low-level delegate call failed"
524             );
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a delegate call.
530      *
531      * _Available since v3.4._
532      */
533     function functionDelegateCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(isContract(target), "Address: delegate call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.delegatecall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
546      * revert reason using the provided one.
547      *
548      * _Available since v4.3._
549      */
550     function verifyCallResult(
551         bool success,
552         bytes memory returndata,
553         string memory errorMessage
554     ) internal pure returns (bytes memory) {
555         if (success) {
556             return returndata;
557         } else {
558             // Look for revert reason and bubble it up if present
559             if (returndata.length > 0) {
560                 // The easiest way to bubble the revert reason is using memory via assembly
561 
562                 assembly {
563                     let returndata_size := mload(returndata)
564                     revert(add(32, returndata), returndata_size)
565                 }
566             } else {
567                 revert(errorMessage);
568             }
569         }
570     }
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @title ERC721 token receiver interface
579  * @dev Interface for any contract that wants to support safeTransfers
580  * from ERC721 asset contracts.
581  */
582 interface IERC721Receiver {
583     /**
584      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
585      * by `operator` from `from`, this function is called.
586      *
587      * It must return its Solidity selector to confirm the token transfer.
588      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
589      *
590      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
591      */
592     function onERC721Received(
593         address operator,
594         address from,
595         uint256 tokenId,
596         bytes calldata data
597     ) external returns (bytes4);
598 }
599 
600 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
601 
602 pragma solidity ^0.8.0;
603 
604 /**
605  * @dev Interface of the ERC165 standard, as defined in the
606  * https://eips.ethereum.org/EIPS/eip-165[EIP].
607  *
608  * Implementers can declare support of contract interfaces, which can then be
609  * queried by others ({ERC165Checker}).
610  *
611  * For an implementation, see {ERC165}.
612  */
613 interface IERC165 {
614     /**
615      * @dev Returns true if this contract implements the interface defined by
616      * `interfaceId`. See the corresponding
617      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
618      * to learn more about how these ids are created.
619      *
620      * This function call must use less than 30 000 gas.
621      */
622     function supportsInterface(bytes4 interfaceId) external view returns (bool);
623 }
624 
625 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Implementation of the {IERC165} interface.
631  *
632  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
633  * for the additional interface id that will be supported. For example:
634  *
635  * ```solidity
636  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
637  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
638  * }
639  * ```
640  *
641  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
642  */
643 abstract contract ERC165 is IERC165 {
644     /**
645      * @dev See {IERC165-supportsInterface}.
646      */
647     function supportsInterface(bytes4 interfaceId)
648         public
649         view
650         virtual
651         override
652         returns (bool)
653     {
654         return interfaceId == type(IERC165).interfaceId;
655     }
656 }
657 
658 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @dev Required interface of an ERC721 compliant contract.
664  */
665 interface IERC721 is IERC165 {
666     /**
667      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
668      */
669     event Transfer(
670         address indexed from,
671         address indexed to,
672         uint256 indexed tokenId
673     );
674 
675     /**
676      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
677      */
678     event Approval(
679         address indexed owner,
680         address indexed approved,
681         uint256 indexed tokenId
682     );
683 
684     /**
685      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
686      */
687     event ApprovalForAll(
688         address indexed owner,
689         address indexed operator,
690         bool approved
691     );
692 
693     /**
694      * @dev Returns the number of tokens in ``owner``'s account.
695      */
696     function balanceOf(address owner) external view returns (uint256 balance);
697 
698     /**
699      * @dev Returns the owner of the `tokenId` token.
700      *
701      * Requirements:
702      *
703      * - `tokenId` must exist.
704      */
705     function ownerOf(uint256 tokenId) external view returns (address owner);
706 
707     /**
708      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
709      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId
725     ) external;
726 
727     /**
728      * @dev Transfers `tokenId` token from `from` to `to`.
729      *
730      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
731      *
732      * Requirements:
733      *
734      * - `from` cannot be the zero address.
735      * - `to` cannot be the zero address.
736      * - `tokenId` token must be owned by `from`.
737      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
738      *
739      * Emits a {Transfer} event.
740      */
741     function transferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) external;
746 
747     /**
748      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
749      * The approval is cleared when the token is transferred.
750      *
751      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
752      *
753      * Requirements:
754      *
755      * - The caller must own the token or be an approved operator.
756      * - `tokenId` must exist.
757      *
758      * Emits an {Approval} event.
759      */
760     function approve(address to, uint256 tokenId) external;
761 
762     /**
763      * @dev Returns the account approved for `tokenId` token.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must exist.
768      */
769     function getApproved(uint256 tokenId)
770         external
771         view
772         returns (address operator);
773 
774     /**
775      * @dev Approve or remove `operator` as an operator for the caller.
776      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
777      *
778      * Requirements:
779      *
780      * - The `operator` cannot be the caller.
781      *
782      * Emits an {ApprovalForAll} event.
783      */
784     function setApprovalForAll(address operator, bool _approved) external;
785 
786     /**
787      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
788      *
789      * See {setApprovalForAll}
790      */
791     function isApprovedForAll(address owner, address operator)
792         external
793         view
794         returns (bool);
795 
796     /**
797      * @dev Safely transfers `tokenId` token from `from` to `to`.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must exist and be owned by `from`.
804      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function safeTransferFrom(
810         address from,
811         address to,
812         uint256 tokenId,
813         bytes calldata data
814     ) external;
815 }
816 
817 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
823  * @dev See https://eips.ethereum.org/EIPS/eip-721
824  */
825 interface IERC721Enumerable is IERC721 {
826     /**
827      * @dev Returns the total amount of tokens stored by the contract.
828      */
829     function totalSupply() external view returns (uint256);
830 
831     /**
832      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
833      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
834      */
835     function tokenOfOwnerByIndex(address owner, uint256 index)
836         external
837         view
838         returns (uint256 tokenId);
839 
840     /**
841      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
842      * Use along with {totalSupply} to enumerate all tokens.
843      */
844     function tokenByIndex(uint256 index) external view returns (uint256);
845 }
846 
847 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
848 
849 pragma solidity ^0.8.0;
850 
851 /**
852  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
853  * @dev See https://eips.ethereum.org/EIPS/eip-721
854  */
855 interface IERC721Metadata is IERC721 {
856     /**
857      * @dev Returns the token collection name.
858      */
859     function name() external view returns (string memory);
860 
861     /**
862      * @dev Returns the token collection symbol.
863      */
864     function symbol() external view returns (string memory);
865 
866     /**
867      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
868      */
869     function tokenURI(uint256 tokenId) external view returns (string memory);
870 }
871 
872 // File: @openzeppelin/contracts/utils/Counters.sol
873 
874 pragma solidity ^0.8.0;
875 
876 /**
877  * @title Counters
878  * @author Matt Condon (@shrugs)
879  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
880  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
881  *
882  * Include with `using Counters for Counters.Counter;`
883  */
884 library Counters {
885     struct Counter {
886         // This variable should never be directly accessed by users of the library: interactions must be restricted to
887         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
888         // this feature: see https://github.com/ethereum/solidity/issues/4637
889         uint256 _value; // default: 0
890     }
891 
892     function current(Counter storage counter) internal view returns (uint256) {
893         return counter._value;
894     }
895 
896     function increment(Counter storage counter) internal {
897         unchecked {
898             counter._value += 1;
899         }
900     }
901 
902     function decrement(Counter storage counter) internal {
903         uint256 value = counter._value;
904         require(value > 0, "Counter: decrement overflow");
905         unchecked {
906             counter._value = value - 1;
907         }
908     }
909 
910     function reset(Counter storage counter) internal {
911         counter._value = 0;
912     }
913 }
914 
915 // File: @openzeppelin/contracts/utils/Context.sol
916 
917 pragma solidity ^0.8.0;
918 
919 /**
920  * @dev Provides information about the current execution context, including the
921  * sender of the transaction and its data. While these are generally available
922  * via msg.sender and msg.data, they should not be accessed in such a direct
923  * manner, since when dealing with meta-transactions the account sending and
924  * paying for execution may not be the actual sender (as far as an application
925  * is concerned).
926  *
927  * This contract is only required for intermediate, library-like contracts.
928  */
929 abstract contract Context {
930     function _msgSender() internal view virtual returns (address) {
931         return msg.sender;
932     }
933 
934     function _msgData() internal view virtual returns (bytes calldata) {
935         return msg.data;
936     }
937 }
938 
939 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
940 
941 pragma solidity ^0.8.0;
942 
943 /**
944  * @title PaymentSplitter
945  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
946  * that the Ether will be split in this way, since it is handled transparently by the contract.
947  *
948  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
949  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
950  * an amount proportional to the percentage of total shares they were assigned.
951  *
952  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
953  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
954  * function.
955  */
956 contract PaymentSplitter is Context {
957     event PayeeAdded(address account, uint256 shares);
958     event PaymentReleased(address to, uint256 amount);
959     event PaymentReceived(address from, uint256 amount);
960 
961     uint256 private _totalShares;
962     uint256 private _totalReleased;
963 
964     mapping(address => uint256) private _shares;
965     mapping(address => uint256) private _released;
966     address[] private _payees;
967 
968     /**
969      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
970      * the matching position in the `shares` array.
971      *
972      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
973      * duplicates in `payees`.
974      */
975     constructor(address[] memory payees, uint256[] memory shares_) payable {
976         require(
977             payees.length == shares_.length,
978             "PaymentSplitter: payees and shares length mismatch"
979         );
980         require(payees.length > 0, "PaymentSplitter: no payees");
981 
982         for (uint256 i = 0; i < payees.length; i++) {
983             _addPayee(payees[i], shares_[i]);
984         }
985     }
986 
987     /**
988      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
989      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
990      * reliability of the events, and not the actual splitting of Ether.
991      *
992      * To learn more about this see the Solidity documentation for
993      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
994      * functions].
995      */
996     receive() external payable virtual {
997         emit PaymentReceived(_msgSender(), msg.value);
998     }
999 
1000     /**
1001      * @dev Getter for the total shares held by payees.
1002      */
1003     function totalShares() public view returns (uint256) {
1004         return _totalShares;
1005     }
1006 
1007     /**
1008      * @dev Getter for the total amount of Ether already released.
1009      */
1010     function totalReleased() public view returns (uint256) {
1011         return _totalReleased;
1012     }
1013 
1014     /**
1015      * @dev Getter for the amount of shares held by an account.
1016      */
1017     function shares(address account) public view returns (uint256) {
1018         return _shares[account];
1019     }
1020 
1021     /**
1022      * @dev Getter for the amount of Ether already released to a payee.
1023      */
1024     function released(address account) public view returns (uint256) {
1025         return _released[account];
1026     }
1027 
1028     /**
1029      * @dev Getter for the address of the payee number `index`.
1030      */
1031     function payee(uint256 index) public view returns (address) {
1032         return _payees[index];
1033     }
1034 
1035     /**
1036      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1037      * total shares and their previous withdrawals.
1038      */
1039     function release(address payable account) public virtual {
1040         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1041 
1042         uint256 totalReceived = address(this).balance + _totalReleased;
1043         uint256 payment = (totalReceived * _shares[account]) /
1044             _totalShares -
1045             _released[account];
1046 
1047         require(payment != 0, "PaymentSplitter: account is not due payment");
1048 
1049         _released[account] = _released[account] + payment;
1050         _totalReleased = _totalReleased + payment;
1051 
1052         Address.sendValue(account, payment);
1053         emit PaymentReleased(account, payment);
1054     }
1055 
1056     /**
1057      * @dev Add a new payee to the contract.
1058      * @param account The address of the payee to add.
1059      * @param shares_ The number of shares owned by the payee.
1060      */
1061     function _addPayee(address account, uint256 shares_) private {
1062         require(
1063             account != address(0),
1064             "PaymentSplitter: account is the zero address"
1065         );
1066         require(shares_ > 0, "PaymentSplitter: shares are 0");
1067         require(
1068             _shares[account] == 0,
1069             "PaymentSplitter: account already has shares"
1070         );
1071 
1072         _payees.push(account);
1073         _shares[account] = shares_;
1074         _totalShares = _totalShares + shares_;
1075         emit PayeeAdded(account, shares_);
1076     }
1077 }
1078 
1079 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 /**
1084  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1085  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1086  * {ERC721Enumerable}.
1087  */
1088 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1089     using Address for address;
1090     using Strings for uint256;
1091 
1092     // Token name
1093     string private _name;
1094 
1095     // Token symbol
1096     string private _symbol;
1097 
1098     // Mapping from token ID to owner address
1099     mapping(uint256 => address) private _owners;
1100 
1101     // Mapping owner address to token count
1102     mapping(address => uint256) private _balances;
1103 
1104     // Mapping from token ID to approved address
1105     mapping(uint256 => address) private _tokenApprovals;
1106 
1107     // Mapping from owner to operator approvals
1108     mapping(address => mapping(address => bool)) private _operatorApprovals;
1109 
1110     /**
1111      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1112      */
1113     constructor(string memory name_, string memory symbol_) {
1114         _name = name_;
1115         _symbol = symbol_;
1116     }
1117 
1118     /**
1119      * @dev See {IERC165-supportsInterface}.
1120      */
1121     function supportsInterface(bytes4 interfaceId)
1122         public
1123         view
1124         virtual
1125         override(ERC165, IERC165)
1126         returns (bool)
1127     {
1128         return
1129             interfaceId == type(IERC721).interfaceId ||
1130             interfaceId == type(IERC721Metadata).interfaceId ||
1131             super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-balanceOf}.
1136      */
1137     function balanceOf(address owner)
1138         public
1139         view
1140         virtual
1141         override
1142         returns (uint256)
1143     {
1144         require(
1145             owner != address(0),
1146             "ERC721: balance query for the zero address"
1147         );
1148         return _balances[owner];
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-ownerOf}.
1153      */
1154     function ownerOf(uint256 tokenId)
1155         public
1156         view
1157         virtual
1158         override
1159         returns (address)
1160     {
1161         address owner = _owners[tokenId];
1162         require(
1163             owner != address(0),
1164             "ERC721: owner query for nonexistent token"
1165         );
1166         return owner;
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Metadata-name}.
1171      */
1172     function name() public view virtual override returns (string memory) {
1173         return _name;
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Metadata-symbol}.
1178      */
1179     function symbol() public view virtual override returns (string memory) {
1180         return _symbol;
1181     }
1182 
1183     /**
1184      * @dev See {IERC721Metadata-tokenURI}.
1185      */
1186     function tokenURI(uint256 tokenId)
1187         public
1188         view
1189         virtual
1190         override
1191         returns (string memory)
1192     {
1193         require(
1194             _exists(tokenId),
1195             "ERC721Metadata: URI query for nonexistent token"
1196         );
1197 
1198         string memory baseURI = _baseURI();
1199         return
1200             bytes(baseURI).length > 0
1201                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1202                 : "";
1203     }
1204 
1205     /**
1206      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1207      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1208      * by default, can be overriden in child contracts.
1209      */
1210     function _baseURI() internal view virtual returns (string memory) {
1211         return "";
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-approve}.
1216      */
1217     function approve(address to, uint256 tokenId) public virtual override {
1218         address owner = ERC721.ownerOf(tokenId);
1219         require(to != owner, "ERC721: approval to current owner");
1220 
1221         require(
1222             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1223             "ERC721: approve caller is not owner nor approved for all"
1224         );
1225 
1226         _approve(to, tokenId);
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-getApproved}.
1231      */
1232     function getApproved(uint256 tokenId)
1233         public
1234         view
1235         virtual
1236         override
1237         returns (address)
1238     {
1239         require(
1240             _exists(tokenId),
1241             "ERC721: approved query for nonexistent token"
1242         );
1243 
1244         return _tokenApprovals[tokenId];
1245     }
1246 
1247     /**
1248      * @dev See {IERC721-setApprovalForAll}.
1249      */
1250     function setApprovalForAll(address operator, bool approved)
1251         public
1252         virtual
1253         override
1254     {
1255         require(operator != _msgSender(), "ERC721: approve to caller");
1256 
1257         _operatorApprovals[_msgSender()][operator] = approved;
1258         emit ApprovalForAll(_msgSender(), operator, approved);
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-isApprovedForAll}.
1263      */
1264     function isApprovedForAll(address owner, address operator)
1265         public
1266         view
1267         virtual
1268         override
1269         returns (bool)
1270     {
1271         return _operatorApprovals[owner][operator];
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-transferFrom}.
1276      */
1277     function transferFrom(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) public virtual override {
1282         //solhint-disable-next-line max-line-length
1283         require(
1284             _isApprovedOrOwner(_msgSender(), tokenId),
1285             "ERC721: transfer caller is not owner nor approved"
1286         );
1287 
1288         _transfer(from, to, tokenId);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-safeTransferFrom}.
1293      */
1294     function safeTransferFrom(
1295         address from,
1296         address to,
1297         uint256 tokenId
1298     ) public virtual override {
1299         safeTransferFrom(from, to, tokenId, "");
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-safeTransferFrom}.
1304      */
1305     function safeTransferFrom(
1306         address from,
1307         address to,
1308         uint256 tokenId,
1309         bytes memory _data
1310     ) public virtual override {
1311         require(
1312             _isApprovedOrOwner(_msgSender(), tokenId),
1313             "ERC721: transfer caller is not owner nor approved"
1314         );
1315         _safeTransfer(from, to, tokenId, _data);
1316     }
1317 
1318     /**
1319      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1320      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1321      *
1322      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1323      *
1324      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1325      * implement alternative mechanisms to perform token transfer, such as signature-based.
1326      *
1327      * Requirements:
1328      *
1329      * - `from` cannot be the zero address.
1330      * - `to` cannot be the zero address.
1331      * - `tokenId` token must exist and be owned by `from`.
1332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _safeTransfer(
1337         address from,
1338         address to,
1339         uint256 tokenId,
1340         bytes memory _data
1341     ) internal virtual {
1342         _transfer(from, to, tokenId);
1343         require(
1344             _checkOnERC721Received(from, to, tokenId, _data),
1345             "ERC721: transfer to non ERC721Receiver implementer"
1346         );
1347     }
1348 
1349     /**
1350      * @dev Returns whether `tokenId` exists.
1351      *
1352      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1353      *
1354      * Tokens start existing when they are minted (`_mint`),
1355      * and stop existing when they are burned (`_burn`).
1356      */
1357     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1358         return _owners[tokenId] != address(0);
1359     }
1360 
1361     /**
1362      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1363      *
1364      * Requirements:
1365      *
1366      * - `tokenId` must exist.
1367      */
1368     function _isApprovedOrOwner(address spender, uint256 tokenId)
1369         internal
1370         view
1371         virtual
1372         returns (bool)
1373     {
1374         require(
1375             _exists(tokenId),
1376             "ERC721: operator query for nonexistent token"
1377         );
1378         address owner = ERC721.ownerOf(tokenId);
1379         return (spender == owner ||
1380             getApproved(tokenId) == spender ||
1381             isApprovedForAll(owner, spender));
1382     }
1383 
1384     /**
1385      * @dev Safely mints `tokenId` and transfers it to `to`.
1386      *
1387      * Requirements:
1388      *
1389      * - `tokenId` must not exist.
1390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _safeMint(address to, uint256 tokenId) internal virtual {
1395         _safeMint(to, tokenId, "");
1396     }
1397 
1398     /**
1399      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1400      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1401      */
1402     function _safeMint(
1403         address to,
1404         uint256 tokenId,
1405         bytes memory _data
1406     ) internal virtual {
1407         _mint(to, tokenId);
1408         require(
1409             _checkOnERC721Received(address(0), to, tokenId, _data),
1410             "ERC721: transfer to non ERC721Receiver implementer"
1411         );
1412     }
1413 
1414     /**
1415      * @dev Mints `tokenId` and transfers it to `to`.
1416      *
1417      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must not exist.
1422      * - `to` cannot be the zero address.
1423      *
1424      * Emits a {Transfer} event.
1425      */
1426     function _mint(address to, uint256 tokenId) internal virtual {
1427         require(to != address(0), "ERC721: mint to the zero address");
1428         require(!_exists(tokenId), "ERC721: token already minted");
1429 
1430         _beforeTokenTransfer(address(0), to, tokenId);
1431 
1432         _balances[to] += 1;
1433         _owners[tokenId] = to;
1434 
1435         emit Transfer(address(0), to, tokenId);
1436     }
1437 
1438     /**
1439      * @dev Destroys `tokenId`.
1440      * The approval is cleared when the token is burned.
1441      *
1442      * Requirements:
1443      *
1444      * - `tokenId` must exist.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function _burn(uint256 tokenId) internal virtual {
1449         address owner = ERC721.ownerOf(tokenId);
1450 
1451         _beforeTokenTransfer(owner, address(0), tokenId);
1452 
1453         // Clear approvals
1454         _approve(address(0), tokenId);
1455 
1456         _balances[owner] -= 1;
1457         delete _owners[tokenId];
1458 
1459         emit Transfer(owner, address(0), tokenId);
1460     }
1461 
1462     /**
1463      * @dev Transfers `tokenId` from `from` to `to`.
1464      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1465      *
1466      * Requirements:
1467      *
1468      * - `to` cannot be the zero address.
1469      * - `tokenId` token must be owned by `from`.
1470      *
1471      * Emits a {Transfer} event.
1472      */
1473     function _transfer(
1474         address from,
1475         address to,
1476         uint256 tokenId
1477     ) internal virtual {
1478         require(
1479             ERC721.ownerOf(tokenId) == from,
1480             "ERC721: transfer of token that is not own"
1481         );
1482         require(to != address(0), "ERC721: transfer to the zero address");
1483 
1484         _beforeTokenTransfer(from, to, tokenId);
1485 
1486         // Clear approvals from the previous owner
1487         _approve(address(0), tokenId);
1488 
1489         _balances[from] -= 1;
1490         _balances[to] += 1;
1491         _owners[tokenId] = to;
1492 
1493         emit Transfer(from, to, tokenId);
1494     }
1495 
1496     /**
1497      * @dev Approve `to` to operate on `tokenId`
1498      *
1499      * Emits a {Approval} event.
1500      */
1501     function _approve(address to, uint256 tokenId) internal virtual {
1502         _tokenApprovals[tokenId] = to;
1503         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1504     }
1505 
1506     /**
1507      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1508      * The call is not executed if the target address is not a contract.
1509      *
1510      * @param from address representing the previous owner of the given token ID
1511      * @param to target address that will receive the tokens
1512      * @param tokenId uint256 ID of the token to be transferred
1513      * @param _data bytes optional data to send along with the call
1514      * @return bool whether the call correctly returned the expected magic value
1515      */
1516     function _checkOnERC721Received(
1517         address from,
1518         address to,
1519         uint256 tokenId,
1520         bytes memory _data
1521     ) private returns (bool) {
1522         if (to.isContract()) {
1523             try
1524                 IERC721Receiver(to).onERC721Received(
1525                     _msgSender(),
1526                     from,
1527                     tokenId,
1528                     _data
1529                 )
1530             returns (bytes4 retval) {
1531                 return retval == IERC721Receiver.onERC721Received.selector;
1532             } catch (bytes memory reason) {
1533                 if (reason.length == 0) {
1534                     revert(
1535                         "ERC721: transfer to non ERC721Receiver implementer"
1536                     );
1537                 } else {
1538                     assembly {
1539                         revert(add(32, reason), mload(reason))
1540                     }
1541                 }
1542             }
1543         } else {
1544             return true;
1545         }
1546     }
1547 
1548     /**
1549      * @dev Hook that is called before any token transfer. This includes minting
1550      * and burning.
1551      *
1552      * Calling conditions:
1553      *
1554      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1555      * transferred to `to`.
1556      * - When `from` is zero, `tokenId` will be minted for `to`.
1557      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1558      * - `from` and `to` are never both zero.
1559      *
1560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1561      */
1562     function _beforeTokenTransfer(
1563         address from,
1564         address to,
1565         uint256 tokenId
1566     ) internal virtual {}
1567 }
1568 
1569 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1570 
1571 pragma solidity ^0.8.0;
1572 
1573 /**
1574  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1575  * enumerability of all the token ids in the contract as well as all token ids owned by each
1576  * account.
1577  */
1578 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1579     // Mapping from owner to list of owned token IDs
1580     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1581 
1582     // Mapping from token ID to index of the owner tokens list
1583     mapping(uint256 => uint256) private _ownedTokensIndex;
1584 
1585     // Array with all token ids, used for enumeration
1586     uint256[] private _allTokens;
1587 
1588     // Mapping from token id to position in the allTokens array
1589     mapping(uint256 => uint256) private _allTokensIndex;
1590 
1591     /**
1592      * @dev See {IERC165-supportsInterface}.
1593      */
1594     function supportsInterface(bytes4 interfaceId)
1595         public
1596         view
1597         virtual
1598         override(IERC165, ERC721)
1599         returns (bool)
1600     {
1601         return
1602             interfaceId == type(IERC721Enumerable).interfaceId ||
1603             super.supportsInterface(interfaceId);
1604     }
1605 
1606     /**
1607      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1608      */
1609     function tokenOfOwnerByIndex(address owner, uint256 index)
1610         public
1611         view
1612         virtual
1613         override
1614         returns (uint256)
1615     {
1616         require(
1617             index < ERC721.balanceOf(owner),
1618             "ERC721Enumerable: owner index out of bounds"
1619         );
1620         return _ownedTokens[owner][index];
1621     }
1622 
1623     /**
1624      * @dev See {IERC721Enumerable-totalSupply}.
1625      */
1626     function totalSupply() public view virtual override returns (uint256) {
1627         return _allTokens.length;
1628     }
1629 
1630     /**
1631      * @dev See {IERC721Enumerable-tokenByIndex}.
1632      */
1633     function tokenByIndex(uint256 index)
1634         public
1635         view
1636         virtual
1637         override
1638         returns (uint256)
1639     {
1640         require(
1641             index < ERC721Enumerable.totalSupply(),
1642             "ERC721Enumerable: global index out of bounds"
1643         );
1644         return _allTokens[index];
1645     }
1646 
1647     /**
1648      * @dev Hook that is called before any token transfer. This includes minting
1649      * and burning.
1650      *
1651      * Calling conditions:
1652      *
1653      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1654      * transferred to `to`.
1655      * - When `from` is zero, `tokenId` will be minted for `to`.
1656      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1657      * - `from` cannot be the zero address.
1658      * - `to` cannot be the zero address.
1659      *
1660      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1661      */
1662     function _beforeTokenTransfer(
1663         address from,
1664         address to,
1665         uint256 tokenId
1666     ) internal virtual override {
1667         super._beforeTokenTransfer(from, to, tokenId);
1668 
1669         if (from == address(0)) {
1670             _addTokenToAllTokensEnumeration(tokenId);
1671         } else if (from != to) {
1672             _removeTokenFromOwnerEnumeration(from, tokenId);
1673         }
1674         if (to == address(0)) {
1675             _removeTokenFromAllTokensEnumeration(tokenId);
1676         } else if (to != from) {
1677             _addTokenToOwnerEnumeration(to, tokenId);
1678         }
1679     }
1680 
1681     /**
1682      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1683      * @param to address representing the new owner of the given token ID
1684      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1685      */
1686     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1687         uint256 length = ERC721.balanceOf(to);
1688         _ownedTokens[to][length] = tokenId;
1689         _ownedTokensIndex[tokenId] = length;
1690     }
1691 
1692     /**
1693      * @dev Private function to add a token to this extension's token tracking data structures.
1694      * @param tokenId uint256 ID of the token to be added to the tokens list
1695      */
1696     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1697         _allTokensIndex[tokenId] = _allTokens.length;
1698         _allTokens.push(tokenId);
1699     }
1700 
1701     /**
1702      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1703      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1704      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1705      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1706      * @param from address representing the previous owner of the given token ID
1707      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1708      */
1709     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1710         private
1711     {
1712         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1713         // then delete the last slot (swap and pop).
1714 
1715         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1716         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1717 
1718         // When the token to delete is the last token, the swap operation is unnecessary
1719         if (tokenIndex != lastTokenIndex) {
1720             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1721 
1722             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1723             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1724         }
1725 
1726         // This also deletes the contents at the last position of the array
1727         delete _ownedTokensIndex[tokenId];
1728         delete _ownedTokens[from][lastTokenIndex];
1729     }
1730 
1731     /**
1732      * @dev Private function to remove a token from this extension's token tracking data structures.
1733      * This has O(1) time complexity, but alters the order of the _allTokens array.
1734      * @param tokenId uint256 ID of the token to be removed from the tokens list
1735      */
1736     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1737         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1738         // then delete the last slot (swap and pop).
1739 
1740         uint256 lastTokenIndex = _allTokens.length - 1;
1741         uint256 tokenIndex = _allTokensIndex[tokenId];
1742 
1743         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1744         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1745         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1746         uint256 lastTokenId = _allTokens[lastTokenIndex];
1747 
1748         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1749         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1750 
1751         // This also deletes the contents at the last position of the array
1752         delete _allTokensIndex[tokenId];
1753         _allTokens.pop();
1754     }
1755 }
1756 
1757 // File: @openzeppelin/contracts/access/Ownable.sol
1758 
1759 pragma solidity ^0.8.0;
1760 
1761 /**
1762  * @dev Contract module which provides a basic access control mechanism, where
1763  * there is an account (an owner) that can be granted exclusive access to
1764  * specific functions.
1765  *
1766  * By default, the owner account will be the one that deploys the contract. This
1767  * can later be changed with {transferOwnership}.
1768  *
1769  * This module is used through inheritance. It will make available the modifier
1770  * `onlyOwner`, which can be applied to your functions to restrict their use to
1771  * the owner.
1772  */
1773 abstract contract Ownable is Context {
1774     address private _owner;
1775 
1776     event OwnershipTransferred(
1777         address indexed previousOwner,
1778         address indexed newOwner
1779     );
1780 
1781     /**
1782      * @dev Initializes the contract setting the deployer as the initial owner.
1783      */
1784     constructor() {
1785         _setOwner(_msgSender());
1786     }
1787 
1788     /**
1789      * @dev Returns the address of the current owner.
1790      */
1791     function owner() public view virtual returns (address) {
1792         return _owner;
1793     }
1794 
1795     /**
1796      * @dev Throws if called by any account other than the owner.
1797      */
1798     modifier onlyOwner() {
1799         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1800         _;
1801     }
1802 
1803     /**
1804      * @dev Leaves the contract without owner. It will not be possible to call
1805      * `onlyOwner` functions anymore. Can only be called by the current owner.
1806      *
1807      * NOTE: Renouncing ownership will leave the contract without an owner,
1808      * thereby removing any functionality that is only available to the owner.
1809      */
1810     function renounceOwnership() public virtual onlyOwner {
1811         _setOwner(address(0));
1812     }
1813 
1814     /**
1815      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1816      * Can only be called by the current owner.
1817      */
1818     function transferOwnership(address newOwner) public virtual onlyOwner {
1819         require(
1820             newOwner != address(0),
1821             "Ownable: new owner is the zero address"
1822         );
1823         _setOwner(newOwner);
1824     }
1825 
1826     function _setOwner(address newOwner) private {
1827         address oldOwner = _owner;
1828         _owner = newOwner;
1829         emit OwnershipTransferred(oldOwner, newOwner);
1830     }
1831 }
1832 
1833 // File: contracts/DegenzDenGenesis.sol
1834 
1835 pragma solidity ^0.8.0;
1836 
1837 /// @title Degenz Den Smart Contract for the Genesis collection
1838 /// @author Aric Kuter
1839 /// @dev All function calls are currently implemented without events to save on gas
1840 contract DegenzDen is ERC721Enumerable, Ownable, PaymentSplitter {
1841     using Strings for uint256;
1842     using Counters for Counters.Counter;
1843 
1844     Counters.Counter private _tokenIdCounter;
1845 
1846     /// ============ Mutable storage ============
1847 
1848     /// @notice URI for revealed metadata
1849     string public baseURI;
1850     /// @notice URI for hidden metadata
1851     string public hiddenURI;
1852     /// @notice Extension for metadata files
1853     string public baseExtension = ".json";
1854 
1855     /// @notice Mint cost per NFT
1856     uint256 public COST = 0.04 ether;
1857     /// @notice Max supply of NFTs
1858     uint256 public MAX_SUPPLY = 2000;
1859     /// @notice Max mint amount (< is used so 5 is actual limit)
1860     uint256 public MAX_MINT = 6;
1861 
1862     /// @notice Pause or Resume minting
1863     bool public mintMain = false;
1864     /// @notice Open whitelisting
1865     bool public mintWhitelist = false;
1866     /// @notice Reveal metadata
1867     bool public revealed = false;
1868 
1869     /// @notice Map address to minted amount
1870     mapping(address => uint256) public addressMintedBalance;
1871 
1872     address[] PAYEES = [
1873         0x954e501b622EFfEC678f30EA9B85D7A6a6cECBD3, /// @notice C
1874         0xEF4DF42EE7D7ee516399fa54C2D95c4fc1AA67d0, /// @notice A
1875         0xffFa8dF59b90FF4454e8B54F54B3655990710710, /// @notice GG
1876         0x18cdac4146D3B41f0fC9B70B5De3fB3282F83855 /// @notice KIC
1877     ];
1878     uint256[] SHARES = [46, 22, 22, 10];
1879 
1880     /// ============ Constructor ============
1881 
1882     /// @param _name name of NFT
1883     /// @param _symbol symbol of NFT
1884     /// @param _initBaseURI URI for revealed metadata in format: ipfs://HASH/
1885     /// @param _initHiddenURI URI for hidden metadata in format: ipfs://HASH/
1886     /// @param _OWNER_MINT_AMOUNT Number of NFTs to mint to the owners address
1887     constructor(
1888         string memory _name,
1889         string memory _symbol,
1890         string memory _initBaseURI,
1891         string memory _initHiddenURI,
1892         uint256 _OWNER_MINT_AMOUNT
1893     ) ERC721(_name, _symbol) PaymentSplitter(PAYEES, SHARES) {
1894         baseURI = _initBaseURI;
1895         hiddenURI = _initHiddenURI;
1896 
1897         /// @notice increment counter to start at 1 instead of 0
1898         _tokenIdCounter.increment();
1899 
1900         /// @notice mint to owners address
1901         reserveTokens(owner(), _OWNER_MINT_AMOUNT);
1902     }
1903 
1904     /// @return Returns the baseURI
1905     function _baseURI() internal view virtual override returns (string memory) {
1906         return baseURI;
1907     }
1908 
1909     /// @notice Mint NFTs to senders address
1910     /// @param _mintAmount Number of NFTs to mint
1911     function mint(uint256 _mintAmount, bytes memory _signature)
1912         external
1913         payable
1914     {
1915         /// @notice Check the mint is active or the sender is whitelisted
1916         require(
1917             mintMain ||
1918                 (mintWhitelist && isValidAccessMessage(msg.sender, _signature)),
1919             "Minting unavailable"
1920         );
1921         require(_mintAmount > 0 && _mintAmount < MAX_MINT, "Invalid amount");
1922         uint256 _tokenId = _tokenIdCounter.current();
1923         require(_tokenId + _mintAmount <= MAX_SUPPLY, "Supply limit reached");
1924         require(
1925             addressMintedBalance[msg.sender] + _mintAmount < MAX_MINT,
1926             "Mint limit reached"
1927         );
1928         require(msg.value == COST * _mintAmount, "Incorrect ETH");
1929 
1930         /// @notice Increment minted amount for user and safe mint to address
1931         addressMintedBalance[msg.sender] += _mintAmount;
1932         for (uint256 i = 0; i < _mintAmount; i++) {
1933             _safeMint(msg.sender, _tokenId + i);
1934             _tokenIdCounter.increment();
1935         }
1936     }
1937 
1938     /// @notice Reserved mint function for owner only
1939     /// @param _to Address to send tokens to
1940     /// @param _mintAmount Number of NFTs to mint
1941     function reserveTokens(address _to, uint256 _mintAmount) public onlyOwner {
1942         uint256 _tokenId = _tokenIdCounter.current();
1943         /// @notice Safely mint the NFTs
1944         for (uint256 i = 0; i < _mintAmount; i++) {
1945             _safeMint(_to, _tokenId + i);
1946             _tokenIdCounter.increment();
1947         }
1948     }
1949 
1950     /*
1951      * @dev Verifies if message was signed by owner to give access to _add for this contract.
1952      *      Assumes Geth signature prefix.
1953      * @param _add Address of agent with access
1954      * @param _v ECDSA signature parameter v.
1955      * @param _r ECDSA signature parameters r.
1956      * @param _s ECDSA signature parameters s.
1957      * @return Validity of access message for a given address.
1958      */
1959     function isValidAccessMessage(address _addr, bytes memory _signature)
1960         public
1961         view
1962         returns (bool)
1963     {
1964         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1965         bytes32 messageHash = getMessageHash(address(this), _addr);
1966         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1967 
1968         return owner() == ecrecover(ethSignedMessageHash, v, r, s);
1969     }
1970 
1971     function getMessageHash(address _contractAddr, address _addr)
1972         public
1973         pure
1974         returns (bytes32)
1975     {
1976         return keccak256(abi.encodePacked(_contractAddr, _addr));
1977     }
1978 
1979     function getEthSignedMessageHash(bytes32 _messageHash)
1980         public
1981         pure
1982         returns (bytes32)
1983     {
1984         return
1985             keccak256(
1986                 abi.encodePacked(
1987                     "\x19Ethereum Signed Message:\n32",
1988                     _messageHash
1989                 )
1990             );
1991     }
1992 
1993     function recoverSigner(
1994         bytes32 _ethSignedMessageHash,
1995         bytes memory _signature
1996     ) public pure returns (address) {
1997         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1998 
1999         return ecrecover(_ethSignedMessageHash, v, r, s);
2000     }
2001 
2002     function splitSignature(bytes memory sig)
2003         public
2004         pure
2005         returns (
2006             bytes32 r,
2007             bytes32 s,
2008             uint8 v
2009         )
2010     {
2011         require(sig.length == 65, "invalid signature length");
2012 
2013         assembly {
2014             /*
2015             First 32 bytes stores the length of the signature
2016             add(sig, 32) = pointer of sig + 32
2017             effectively, skips first 32 bytes of signature
2018             mload(p) loads next 32 bytes starting at the memory address p into memory
2019             */
2020 
2021             // first 32 bytes, after the length prefix
2022             r := mload(add(sig, 32))
2023             // second 32 bytes
2024             s := mload(add(sig, 64))
2025             // final byte (first byte of the next 32 bytes)
2026             v := byte(0, mload(add(sig, 96)))
2027         }
2028 
2029         // implicitly return (r, s, v)
2030     }
2031 
2032     /// @return Returns a conststructed string in the format: //ipfs/HASH/[tokenId].json
2033     function tokenURI(uint256 tokenId)
2034         public
2035         view
2036         virtual
2037         override
2038         returns (string memory)
2039     {
2040         require(
2041             _exists(tokenId),
2042             "ERC721Metadata: URI query for NonExistent Token."
2043         );
2044 
2045         if (!revealed) {
2046             return hiddenURI;
2047         }
2048 
2049         string memory currentBaseURI = _baseURI();
2050         return
2051             bytes(currentBaseURI).length > 0
2052                 ? string(
2053                     abi.encodePacked(
2054                         currentBaseURI,
2055                         tokenId.toString(),
2056                         baseExtension
2057                     )
2058                 )
2059                 : "";
2060     }
2061 
2062     /// @notice Reveal metadata
2063     function reveal() external onlyOwner {
2064         revealed = true;
2065     }
2066 
2067     /// @notice Set the URI of the hidden metadata
2068     /// @param _hiddenURI URI for hidden metadata NOTE: This URI must be the link to the exact file in format: ipfs//HASH/
2069     function setHiddenURI(string memory _hiddenURI) external onlyOwner {
2070         hiddenURI = _hiddenURI;
2071     }
2072 
2073     /// @notice Set URI of the metadata
2074     /// @param _newBaseURI URI for revealed metadata
2075     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2076         baseURI = _newBaseURI;
2077     }
2078 
2079     /// @notice Set the base extension for the metadata
2080     /// @param _newBaseExtension Base extension value
2081     function setBaseExtension(string memory _newBaseExtension)
2082         external
2083         onlyOwner
2084     {
2085         baseExtension = _newBaseExtension;
2086     }
2087 
2088     function getUserAirdrops(address _user) external view returns (uint256) {
2089         return addressMintedBalance[_user];
2090     }
2091 
2092     /// @notice Toggle mintMain
2093     function toggleMintMain() external onlyOwner {
2094         mintMain = !mintMain;
2095     }
2096 
2097     /// @notice Toggle mintWhitelist
2098     function toggleMintWhitelist() external onlyOwner {
2099         mintWhitelist = !mintWhitelist;
2100     }
2101 }