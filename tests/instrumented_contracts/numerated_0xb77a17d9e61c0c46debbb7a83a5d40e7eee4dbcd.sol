1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-25
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b)
25         internal
26         pure
27         returns (bool, uint256)
28     {
29         unchecked {
30             uint256 c = a + b;
31             if (c < a) return (false, 0);
32             return (true, c);
33         }
34     }
35 
36     /**
37      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function trySub(uint256 a, uint256 b)
42         internal
43         pure
44         returns (bool, uint256)
45     {
46         unchecked {
47             if (b > a) return (false, 0);
48             return (true, a - b);
49         }
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
54      *
55      * _Available since v3.4._
56      */
57     function tryMul(uint256 a, uint256 b)
58         internal
59         pure
60         returns (bool, uint256)
61     {
62         unchecked {
63             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64             // benefit is lost if 'b' is also tested.
65             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66             if (a == 0) return (true, 0);
67             uint256 c = a * b;
68             if (c / a != b) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     /**
74      * @dev Returns the division of two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryDiv(uint256 a, uint256 b)
79         internal
80         pure
81         returns (bool, uint256)
82     {
83         unchecked {
84             if (b == 0) return (false, 0);
85             return (true, a / b);
86         }
87     }
88 
89     /**
90      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryMod(uint256 a, uint256 b)
95         internal
96         pure
97         returns (bool, uint256)
98     {
99         unchecked {
100             if (b == 0) return (false, 0);
101             return (true, a % b);
102         }
103     }
104 
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      *
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a + b;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a - b;
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `*` operator.
138      *
139      * Requirements:
140      *
141      * - Multiplication cannot overflow.
142      */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a * b;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers, reverting on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator.
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function div(uint256 a, uint256 b) internal pure returns (uint256) {
158         return a / b;
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * reverting when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a % b;
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
179      * overflow (when the result is negative).
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {trySub}.
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         unchecked {
196             require(b <= a, errorMessage);
197             return a - b;
198         }
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a / b;
225         }
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * reverting with custom message when dividing by zero.
231      *
232      * CAUTION: This function is deprecated because it requires allocating memory for the error
233      * message unnecessarily. For custom revert reasons use {tryMod}.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         unchecked {
249             require(b > 0, errorMessage);
250             return a % b;
251         }
252     }
253 }
254 
255 /**
256  * @dev Interface of the ERC165 standard, as defined in the
257  * https://eips.ethereum.org/EIPS/eip-165[EIP].
258  *
259  * Implementers can declare support of contract interfaces, which can then be
260  * queried by others ({ERC165Checker}).
261  *
262  * For an implementation, see {ERC165}.
263  */
264 interface IERC165 {
265     /**
266      * @dev Returns true if this contract implements the interface defined by
267      * `interfaceId`. See the corresponding
268      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
269      * to learn more about how these ids are created.
270      *
271      * This function call must use less than 30 000 gas.
272      */
273     function supportsInterface(bytes4 interfaceId) external view returns (bool);
274 }
275 
276 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
277 
278 /**
279  * @dev Required interface of an ERC721 compliant contract.
280  */
281 interface IERC721 is IERC165 {
282     /**
283      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
284      */
285     event Transfer(
286         address indexed from,
287         address indexed to,
288         uint256 indexed tokenId
289     );
290 
291     /**
292      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
293      */
294     event Approval(
295         address indexed owner,
296         address indexed approved,
297         uint256 indexed tokenId
298     );
299 
300     /**
301      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
302      */
303     event ApprovalForAll(
304         address indexed owner,
305         address indexed operator,
306         bool approved
307     );
308 
309     /**
310      * @dev Returns the number of tokens in ``owner``'s account.
311      */
312     function balanceOf(address owner) external view returns (uint256 balance);
313 
314     /**
315      * @dev Returns the owner of the `tokenId` token.
316      *
317      * Requirements:
318      *
319      * - `tokenId` must exist.
320      */
321     function ownerOf(uint256 tokenId) external view returns (address owner);
322 
323     /**
324      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
325      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
326      *
327      * Requirements:
328      *
329      * - `from` cannot be the zero address.
330      * - `to` cannot be the zero address.
331      * - `tokenId` token must exist and be owned by `from`.
332      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
333      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
334      *
335      * Emits a {Transfer} event.
336      */
337     function safeTransferFrom(
338         address from,
339         address to,
340         uint256 tokenId
341     ) external;
342 
343     /**
344      * @dev Transfers `tokenId` token from `from` to `to`.
345      *
346      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
347      *
348      * Requirements:
349      *
350      * - `from` cannot be the zero address.
351      * - `to` cannot be the zero address.
352      * - `tokenId` token must be owned by `from`.
353      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transferFrom(
358         address from,
359         address to,
360         uint256 tokenId
361     ) external;
362 
363     /**
364      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
365      * The approval is cleared when the token is transferred.
366      *
367      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
368      *
369      * Requirements:
370      *
371      * - The caller must own the token or be an approved operator.
372      * - `tokenId` must exist.
373      *
374      * Emits an {Approval} event.
375      */
376     function approve(address to, uint256 tokenId) external;
377 
378     /**
379      * @dev Returns the account approved for `tokenId` token.
380      *
381      * Requirements:
382      *
383      * - `tokenId` must exist.
384      */
385     function getApproved(uint256 tokenId)
386         external
387         view
388         returns (address operator);
389 
390     /**
391      * @dev Approve or remove `operator` as an operator for the caller.
392      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
393      *
394      * Requirements:
395      *
396      * - The `operator` cannot be the caller.
397      *
398      * Emits an {ApprovalForAll} event.
399      */
400     function setApprovalForAll(address operator, bool _approved) external;
401 
402     /**
403      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
404      *
405      * See {setApprovalForAll}
406      */
407     function isApprovedForAll(address owner, address operator)
408         external
409         view
410         returns (bool);
411 
412     /**
413      * @dev Safely transfers `tokenId` token from `from` to `to`.
414      *
415      * Requirements:
416      *
417      * - `from` cannot be the zero address.
418      * - `to` cannot be the zero address.
419      * - `tokenId` token must exist and be owned by `from`.
420      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
421      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
422      *
423      * Emits a {Transfer} event.
424      */
425     function safeTransferFrom(
426         address from,
427         address to,
428         uint256 tokenId,
429         bytes calldata data
430     ) external;
431 }
432 
433 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
434 
435 /**
436  * @title ERC721 token receiver interface
437  * @dev Interface for any contract that wants to support safeTransfers
438  * from ERC721 asset contracts.
439  */
440 interface IERC721Receiver {
441     /**
442      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
443      * by `operator` from `from`, this function is called.
444      *
445      * It must return its Solidity selector to confirm the token transfer.
446      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
447      *
448      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
449      */
450     function onERC721Received(
451         address operator,
452         address from,
453         uint256 tokenId,
454         bytes calldata data
455     ) external returns (bytes4);
456 }
457 
458 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
459 
460 /**
461  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
462  * @dev See https://eips.ethereum.org/EIPS/eip-721
463  */
464 interface IERC721Metadata is IERC721 {
465     /**
466      * @dev Returns the token collection name.
467      */
468     function name() external view returns (string memory);
469 
470     /**
471      * @dev Returns the token collection symbol.
472      */
473     function symbol() external view returns (string memory);
474 
475     /**
476      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
477      */
478     function tokenURI(uint256 tokenId) external view returns (string memory);
479 }
480 
481 // File: @openzeppelin/contracts/utils/Address.sol
482 
483 /**
484  * @dev Collection of functions related to the address type
485  */
486 library Address {
487     /**
488      * @dev Returns true if `account` is a contract.
489      *
490      * [IMPORTANT]
491      * ====
492      * It is unsafe to assume that an address for which this function returns
493      * false is an externally-owned account (EOA) and not a contract.
494      *
495      * Among others, `isContract` will return false for the following
496      * types of addresses:
497      *
498      *  - an externally-owned account
499      *  - a contract in construction
500      *  - an address where a contract will be created
501      *  - an address where a contract lived, but was destroyed
502      * ====
503      */
504     function isContract(address account) internal view returns (bool) {
505         // This method relies on extcodesize, which returns 0 for contracts in
506         // construction, since the code is only stored at the end of the
507         // constructor execution.
508 
509         uint256 size;
510         // solhint-disable-next-line no-inline-assembly
511         assembly {
512             size := extcodesize(account)
513         }
514         return size > 0;
515     }
516 
517     /**
518      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
519      * `recipient`, forwarding all available gas and reverting on errors.
520      *
521      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
522      * of certain opcodes, possibly making contracts go over the 2300 gas limit
523      * imposed by `transfer`, making them unable to receive funds via
524      * `transfer`. {sendValue} removes this limitation.
525      *
526      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
527      *
528      * IMPORTANT: because control is transferred to `recipient`, care must be
529      * taken to not create reentrancy vulnerabilities. Consider using
530      * {ReentrancyGuard} or the
531      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
532      */
533     function sendValue(address payable recipient, uint256 amount) internal {
534         require(
535             address(this).balance >= amount,
536             "Address: insufficient balance"
537         );
538 
539         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
540         (bool success, ) = recipient.call{value: amount}("");
541         require(
542             success,
543             "Address: unable to send value, recipient may have reverted"
544         );
545     }
546 
547     /**
548      * @dev Performs a Solidity function call using a low level `call`. A
549      * plain`call` is an unsafe replacement for a function call: use this
550      * function instead.
551      *
552      * If `target` reverts with a revert reason, it is bubbled up by this
553      * function (like regular Solidity function calls).
554      *
555      * Returns the raw returned data. To convert to the expected return value,
556      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
557      *
558      * Requirements:
559      *
560      * - `target` must be a contract.
561      * - calling `target` with `data` must not revert.
562      *
563      * _Available since v3.1._
564      */
565     function functionCall(address target, bytes memory data)
566         internal
567         returns (bytes memory)
568     {
569         return functionCall(target, data, "Address: low-level call failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
574      * `errorMessage` as a fallback revert reason when `target` reverts.
575      *
576      * _Available since v3.1._
577      */
578     function functionCall(
579         address target,
580         bytes memory data,
581         string memory errorMessage
582     ) internal returns (bytes memory) {
583         return functionCallWithValue(target, data, 0, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but also transferring `value` wei to `target`.
589      *
590      * Requirements:
591      *
592      * - the calling contract must have an ETH balance of at least `value`.
593      * - the called Solidity function must be `payable`.
594      *
595      * _Available since v3.1._
596      */
597     function functionCallWithValue(
598         address target,
599         bytes memory data,
600         uint256 value
601     ) internal returns (bytes memory) {
602         return
603             functionCallWithValue(
604                 target,
605                 data,
606                 value,
607                 "Address: low-level call with value failed"
608             );
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
613      * with `errorMessage` as a fallback revert reason when `target` reverts.
614      *
615      * _Available since v3.1._
616      */
617     function functionCallWithValue(
618         address target,
619         bytes memory data,
620         uint256 value,
621         string memory errorMessage
622     ) internal returns (bytes memory) {
623         require(
624             address(this).balance >= value,
625             "Address: insufficient balance for call"
626         );
627         require(isContract(target), "Address: call to non-contract");
628 
629         // solhint-disable-next-line avoid-low-level-calls
630         (bool success, bytes memory returndata) = target.call{value: value}(
631             data
632         );
633         return _verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but performing a static call.
639      *
640      * _Available since v3.3._
641      */
642     function functionStaticCall(address target, bytes memory data)
643         internal
644         view
645         returns (bytes memory)
646     {
647         return
648             functionStaticCall(
649                 target,
650                 data,
651                 "Address: low-level static call failed"
652             );
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
657      * but performing a static call.
658      *
659      * _Available since v3.3._
660      */
661     function functionStaticCall(
662         address target,
663         bytes memory data,
664         string memory errorMessage
665     ) internal view returns (bytes memory) {
666         require(isContract(target), "Address: static call to non-contract");
667 
668         // solhint-disable-next-line avoid-low-level-calls
669         (bool success, bytes memory returndata) = target.staticcall(data);
670         return _verifyCallResult(success, returndata, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but performing a delegate call.
676      *
677      * _Available since v3.4._
678      */
679     function functionDelegateCall(address target, bytes memory data)
680         internal
681         returns (bytes memory)
682     {
683         return
684             functionDelegateCall(
685                 target,
686                 data,
687                 "Address: low-level delegate call failed"
688             );
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
693      * but performing a delegate call.
694      *
695      * _Available since v3.4._
696      */
697     function functionDelegateCall(
698         address target,
699         bytes memory data,
700         string memory errorMessage
701     ) internal returns (bytes memory) {
702         require(isContract(target), "Address: delegate call to non-contract");
703 
704         // solhint-disable-next-line avoid-low-level-calls
705         (bool success, bytes memory returndata) = target.delegatecall(data);
706         return _verifyCallResult(success, returndata, errorMessage);
707     }
708 
709     function _verifyCallResult(
710         bool success,
711         bytes memory returndata,
712         string memory errorMessage
713     ) private pure returns (bytes memory) {
714         if (success) {
715             return returndata;
716         } else {
717             // Look for revert reason and bubble it up if present
718             if (returndata.length > 0) {
719                 // The easiest way to bubble the revert reason is using memory via assembly
720 
721                 // solhint-disable-next-line no-inline-assembly
722                 assembly {
723                     let returndata_size := mload(returndata)
724                     revert(add(32, returndata), returndata_size)
725                 }
726             } else {
727                 revert(errorMessage);
728             }
729         }
730     }
731 }
732 
733 // File: @openzeppelin/contracts/utils/Context.sol
734 
735 /*
736  * @dev Provides information about the current execution context, including the
737  * sender of the transaction and its data. While these are generally available
738  * via msg.sender and msg.data, they should not be accessed in such a direct
739  * manner, since when dealing with meta-transactions the account sending and
740  * paying for execution may not be the actual sender (as far as an application
741  * is concerned).
742  *
743  * This contract is only required for intermediate, library-like contracts.
744  */
745 abstract contract Context {
746     function _msgSender() internal view virtual returns (address) {
747         return msg.sender;
748     }
749 
750     function _msgData() internal view virtual returns (bytes calldata) {
751         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
752         return msg.data;
753     }
754 }
755 
756 // File: @openzeppelin/contracts/utils/Strings.sol
757 
758 /**
759  * @dev String operations.
760  */
761 library Strings {
762     bytes16 private constant alphabet = "0123456789abcdef";
763 
764     /**
765      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
766      */
767     function toString(uint256 value) internal pure returns (string memory) {
768         // Inspired by OraclizeAPI's implementation - MIT licence
769         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
770 
771         if (value == 0) {
772             return "0";
773         }
774         uint256 temp = value;
775         uint256 digits;
776         while (temp != 0) {
777             digits++;
778             temp /= 10;
779         }
780         bytes memory buffer = new bytes(digits);
781         while (value != 0) {
782             digits -= 1;
783             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
784             value /= 10;
785         }
786         return string(buffer);
787     }
788 
789     /**
790      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
791      */
792     function toHexString(uint256 value) internal pure returns (string memory) {
793         if (value == 0) {
794             return "0x00";
795         }
796         uint256 temp = value;
797         uint256 length = 0;
798         while (temp != 0) {
799             length++;
800             temp >>= 8;
801         }
802         return toHexString(value, length);
803     }
804 
805     /**
806      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
807      */
808     function toHexString(uint256 value, uint256 length)
809         internal
810         pure
811         returns (string memory)
812     {
813         bytes memory buffer = new bytes(2 * length + 2);
814         buffer[0] = "0";
815         buffer[1] = "x";
816         for (uint256 i = 2 * length + 1; i > 1; --i) {
817             buffer[i] = alphabet[value & 0xf];
818             value >>= 4;
819         }
820         require(value == 0, "Strings: hex length insufficient");
821         return string(buffer);
822     }
823 }
824 
825 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
826 
827 /**
828  * @dev Implementation of the {IERC165} interface.
829  *
830  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
831  * for the additional interface id that will be supported. For example:
832  *
833  * ```solidity
834  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
835  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
836  * }
837  * ```
838  *
839  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
840  */
841 abstract contract ERC165 is IERC165 {
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId)
846         public
847         view
848         virtual
849         override
850         returns (bool)
851     {
852         return interfaceId == type(IERC165).interfaceId;
853     }
854 }
855 
856 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
857 
858 /**
859  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
860  * the Metadata extension, but not including the Enumerable extension, which is available separately as
861  * {ERC721Enumerable}.
862  */
863 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
864     using Address for address;
865     using Strings for uint256;
866 
867     // Token name
868     string private _name;
869 
870     // Token symbol
871     string private _symbol;
872 
873     // Mapping from token ID to owner address
874     mapping(uint256 => address) private _owners;
875 
876     // Mapping owner address to token count
877     mapping(address => uint256) private _balances;
878 
879     // Mapping from token ID to approved address
880     mapping(uint256 => address) private _tokenApprovals;
881 
882     // Mapping from owner to operator approvals
883     mapping(address => mapping(address => bool)) private _operatorApprovals;
884 
885     /**
886      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
887      */
888     constructor(string memory name_, string memory symbol_) {
889         _name = name_;
890         _symbol = symbol_;
891     }
892 
893     /**
894      * @dev See {IERC165-supportsInterface}.
895      */
896     function supportsInterface(bytes4 interfaceId)
897         public
898         view
899         virtual
900         override(ERC165, IERC165)
901         returns (bool)
902     {
903         return
904             interfaceId == type(IERC721).interfaceId ||
905             interfaceId == type(IERC721Metadata).interfaceId ||
906             super.supportsInterface(interfaceId);
907     }
908 
909     /**
910      * @dev See {IERC721-balanceOf}.
911      */
912     function balanceOf(address owner)
913         public
914         view
915         virtual
916         override
917         returns (uint256)
918     {
919         require(
920             owner != address(0),
921             "ERC721: balance query for the zero address"
922         );
923         return _balances[owner];
924     }
925 
926     /**
927      * @dev See {IERC721-ownerOf}.
928      */
929     function ownerOf(uint256 tokenId)
930         public
931         view
932         virtual
933         override
934         returns (address)
935     {
936         address owner = _owners[tokenId];
937         require(
938             owner != address(0),
939             "ERC721: owner query for nonexistent token"
940         );
941         return owner;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-name}.
946      */
947     function name() public view virtual override returns (string memory) {
948         return _name;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-symbol}.
953      */
954     function symbol() public view virtual override returns (string memory) {
955         return _symbol;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-tokenURI}.
960      */
961     function tokenURI(uint256 tokenId)
962         public
963         view
964         virtual
965         override
966         returns (string memory)
967     {
968         require(
969             _exists(tokenId),
970             "ERC721Metadata: URI query for nonexistent token"
971         );
972 
973         string memory baseURI = _baseURI();
974         return
975             bytes(baseURI).length > 0
976                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
977                 : "";
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
982      * in child contracts.
983      */
984     function _baseURI() internal view virtual returns (string memory) {
985         return "";
986     }
987 
988     /**
989      * @dev See {IERC721-approve}.
990      */
991     function approve(address to, uint256 tokenId) public virtual override {
992         address owner = ERC721.ownerOf(tokenId);
993         require(to != owner, "ERC721: approval to current owner");
994 
995         require(
996             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
997             "ERC721: approve caller is not owner nor approved for all"
998         );
999 
1000         _approve(to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-getApproved}.
1005      */
1006     function getApproved(uint256 tokenId)
1007         public
1008         view
1009         virtual
1010         override
1011         returns (address)
1012     {
1013         require(
1014             _exists(tokenId),
1015             "ERC721: approved query for nonexistent token"
1016         );
1017 
1018         return _tokenApprovals[tokenId];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-setApprovalForAll}.
1023      */
1024     function setApprovalForAll(address operator, bool approved)
1025         public
1026         virtual
1027         override
1028     {
1029         require(operator != _msgSender(), "ERC721: approve to caller");
1030 
1031         _operatorApprovals[_msgSender()][operator] = approved;
1032         emit ApprovalForAll(_msgSender(), operator, approved);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-isApprovedForAll}.
1037      */
1038     function isApprovedForAll(address owner, address operator)
1039         public
1040         view
1041         virtual
1042         override
1043         returns (bool)
1044     {
1045         return _operatorApprovals[owner][operator];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-transferFrom}.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public virtual override {
1056         //solhint-disable-next-line max-line-length
1057         require(
1058             _isApprovedOrOwner(_msgSender(), tokenId),
1059             "ERC721: transfer caller is not owner nor approved"
1060         );
1061 
1062         _transfer(from, to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-safeTransferFrom}.
1067      */
1068     function safeTransferFrom(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) public virtual override {
1073         safeTransferFrom(from, to, tokenId, "");
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-safeTransferFrom}.
1078      */
1079     function safeTransferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) public virtual override {
1085         require(
1086             _isApprovedOrOwner(_msgSender(), tokenId),
1087             "ERC721: transfer caller is not owner nor approved"
1088         );
1089         _safeTransfer(from, to, tokenId, _data);
1090     }
1091 
1092     /**
1093      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1094      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1095      *
1096      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1097      *
1098      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1099      * implement alternative mechanisms to perform token transfer, such as signature-based.
1100      *
1101      * Requirements:
1102      *
1103      * - `from` cannot be the zero address.
1104      * - `to` cannot be the zero address.
1105      * - `tokenId` token must exist and be owned by `from`.
1106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _safeTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes memory _data
1115     ) internal virtual {
1116         _transfer(from, to, tokenId);
1117         require(
1118             _checkOnERC721Received(from, to, tokenId, _data),
1119             "ERC721: transfer to non ERC721Receiver implementer"
1120         );
1121     }
1122 
1123     /**
1124      * @dev Returns whether `tokenId` exists.
1125      *
1126      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1127      *
1128      * Tokens start existing when they are minted (`_mint`),
1129      * and stop existing when they are burned (`_burn`).
1130      */
1131     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1132         return _owners[tokenId] != address(0);
1133     }
1134 
1135     /**
1136      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1137      *
1138      * Requirements:
1139      *
1140      * - `tokenId` must exist.
1141      */
1142     function _isApprovedOrOwner(address spender, uint256 tokenId)
1143         internal
1144         view
1145         virtual
1146         returns (bool)
1147     {
1148         require(
1149             _exists(tokenId),
1150             "ERC721: operator query for nonexistent token"
1151         );
1152         address owner = ERC721.ownerOf(tokenId);
1153         return (spender == owner ||
1154             getApproved(tokenId) == spender ||
1155             isApprovedForAll(owner, spender));
1156     }
1157 
1158     /**
1159      * @dev Safely mints `tokenId` and transfers it to `to`.
1160      *
1161      * Requirements:
1162      *
1163      * - `tokenId` must not exist.
1164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _safeMint(address to, uint256 tokenId) internal virtual {
1169         _safeMint(to, tokenId, "");
1170     }
1171 
1172     /**
1173      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1174      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1175      */
1176     function _safeMint(
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) internal virtual {
1181         _mint(to, tokenId);
1182         require(
1183             _checkOnERC721Received(address(0), to, tokenId, _data),
1184             "ERC721: transfer to non ERC721Receiver implementer"
1185         );
1186     }
1187 
1188     /**
1189      * @dev Mints `tokenId` and transfers it to `to`.
1190      *
1191      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1192      *
1193      * Requirements:
1194      *
1195      * - `tokenId` must not exist.
1196      * - `to` cannot be the zero address.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _mint(address to, uint256 tokenId) internal virtual {
1201         require(to != address(0), "ERC721: mint to the zero address");
1202         require(!_exists(tokenId), "ERC721: token already minted");
1203 
1204         _beforeTokenTransfer(address(0), to, tokenId);
1205 
1206         _balances[to] += 1;
1207         _owners[tokenId] = to;
1208 
1209         emit Transfer(address(0), to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev Destroys `tokenId`.
1214      * The approval is cleared when the token is burned.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _burn(uint256 tokenId) internal virtual {
1223         address owner = ERC721.ownerOf(tokenId);
1224 
1225         _beforeTokenTransfer(owner, address(0), tokenId);
1226 
1227         // Clear approvals
1228         _approve(address(0), tokenId);
1229 
1230         _balances[owner] -= 1;
1231         delete _owners[tokenId];
1232 
1233         emit Transfer(owner, address(0), tokenId);
1234     }
1235 
1236     /**
1237      * @dev Transfers `tokenId` from `from` to `to`.
1238      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1239      *
1240      * Requirements:
1241      *
1242      * - `to` cannot be the zero address.
1243      * - `tokenId` token must be owned by `from`.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _transfer(
1248         address from,
1249         address to,
1250         uint256 tokenId
1251     ) internal virtual {
1252         require(
1253             ERC721.ownerOf(tokenId) == from,
1254             "ERC721: transfer of token that is not own"
1255         );
1256         require(to != address(0), "ERC721: transfer to the zero address");
1257 
1258         _beforeTokenTransfer(from, to, tokenId);
1259 
1260         // Clear approvals from the previous owner
1261         _approve(address(0), tokenId);
1262 
1263         _balances[from] -= 1;
1264         _balances[to] += 1;
1265         _owners[tokenId] = to;
1266 
1267         emit Transfer(from, to, tokenId);
1268     }
1269 
1270     /**
1271      * @dev Approve `to` to operate on `tokenId`
1272      *
1273      * Emits a {Approval} event.
1274      */
1275     function _approve(address to, uint256 tokenId) internal virtual {
1276         _tokenApprovals[tokenId] = to;
1277         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1278     }
1279 
1280     /**
1281      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1282      * The call is not executed if the target address is not a contract.
1283      *
1284      * @param from address representing the previous owner of the given token ID
1285      * @param to target address that will receive the tokens
1286      * @param tokenId uint256 ID of the token to be transferred
1287      * @param _data bytes optional data to send along with the call
1288      * @return bool whether the call correctly returned the expected magic value
1289      */
1290     function _checkOnERC721Received(
1291         address from,
1292         address to,
1293         uint256 tokenId,
1294         bytes memory _data
1295     ) private returns (bool) {
1296         if (to.isContract()) {
1297             try
1298                 IERC721Receiver(to).onERC721Received(
1299                     _msgSender(),
1300                     from,
1301                     tokenId,
1302                     _data
1303                 )
1304             returns (bytes4 retval) {
1305                 return retval == IERC721Receiver(to).onERC721Received.selector;
1306             } catch (bytes memory reason) {
1307                 if (reason.length == 0) {
1308                     revert(
1309                         "ERC721: transfer to non ERC721Receiver implementer"
1310                     );
1311                 } else {
1312                     // solhint-disable-next-line no-inline-assembly
1313                     assembly {
1314                         revert(add(32, reason), mload(reason))
1315                     }
1316                 }
1317             }
1318         } else {
1319             return true;
1320         }
1321     }
1322 
1323     /**
1324      * @dev Hook that is called before any token transfer. This includes minting
1325      * and burning.
1326      *
1327      * Calling conditions:
1328      *
1329      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1330      * transferred to `to`.
1331      * - When `from` is zero, `tokenId` will be minted for `to`.
1332      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1333      * - `from` cannot be the zero address.
1334      * - `to` cannot be the zero address.
1335      *
1336      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1337      */
1338     function _beforeTokenTransfer(
1339         address from,
1340         address to,
1341         uint256 tokenId
1342     ) internal virtual {}
1343 }
1344 
1345 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1346 
1347 /**
1348  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1349  * @dev See https://eips.ethereum.org/EIPS/eip-721
1350  */
1351 interface IERC721Enumerable is IERC721 {
1352     /**
1353      * @dev Returns the total amount of tokens stored by the contract.
1354      */
1355     function totalSupply() external view returns (uint256);
1356 
1357     /**
1358      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1359      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1360      */
1361     function tokenOfOwnerByIndex(address owner, uint256 index)
1362         external
1363         view
1364         returns (uint256 tokenId);
1365 
1366     /**
1367      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1368      * Use along with {totalSupply} to enumerate all tokens.
1369      */
1370     function tokenByIndex(uint256 index) external view returns (uint256);
1371 }
1372 
1373 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1374 
1375 /**
1376  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1377  * enumerability of all the token ids in the contract as well as all token ids owned by each
1378  * account.
1379  */
1380 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1381     // Mapping from owner to list of owned token IDs
1382     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1383 
1384     // Mapping from token ID to index of the owner tokens list
1385     mapping(uint256 => uint256) private _ownedTokensIndex;
1386 
1387     // Array with all token ids, used for enumeration
1388     uint256[] private _allTokens;
1389 
1390     // Mapping from token id to position in the allTokens array
1391     mapping(uint256 => uint256) private _allTokensIndex;
1392 
1393     /**
1394      * @dev See {IERC165-supportsInterface}.
1395      */
1396     function supportsInterface(bytes4 interfaceId)
1397         public
1398         view
1399         virtual
1400         override(IERC165, ERC721)
1401         returns (bool)
1402     {
1403         return
1404             interfaceId == type(IERC721Enumerable).interfaceId ||
1405             super.supportsInterface(interfaceId);
1406     }
1407 
1408     /**
1409      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1410      */
1411     function tokenOfOwnerByIndex(address owner, uint256 index)
1412         public
1413         view
1414         virtual
1415         override
1416         returns (uint256)
1417     {
1418         require(
1419             index < ERC721.balanceOf(owner),
1420             "ERC721Enumerable: owner index out of bounds"
1421         );
1422         return _ownedTokens[owner][index];
1423     }
1424 
1425     /**
1426      * @dev See {IERC721Enumerable-totalSupply}.
1427      */
1428     function totalSupply() public view virtual override returns (uint256) {
1429         return _allTokens.length;
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Enumerable-tokenByIndex}.
1434      */
1435     function tokenByIndex(uint256 index)
1436         public
1437         view
1438         virtual
1439         override
1440         returns (uint256)
1441     {
1442         require(
1443             index < ERC721Enumerable.totalSupply(),
1444             "ERC721Enumerable: global index out of bounds"
1445         );
1446         return _allTokens[index];
1447     }
1448 
1449     /**
1450      * @dev Hook that is called before any token transfer. This includes minting
1451      * and burning.
1452      *
1453      * Calling conditions:
1454      *
1455      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1456      * transferred to `to`.
1457      * - When `from` is zero, `tokenId` will be minted for `to`.
1458      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1459      * - `from` cannot be the zero address.
1460      * - `to` cannot be the zero address.
1461      *
1462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1463      */
1464     function _beforeTokenTransfer(
1465         address from,
1466         address to,
1467         uint256 tokenId
1468     ) internal virtual override {
1469         super._beforeTokenTransfer(from, to, tokenId);
1470 
1471         if (from == address(0)) {
1472             _addTokenToAllTokensEnumeration(tokenId);
1473         } else if (from != to) {
1474             _removeTokenFromOwnerEnumeration(from, tokenId);
1475         }
1476         if (to == address(0)) {
1477             _removeTokenFromAllTokensEnumeration(tokenId);
1478         } else if (to != from) {
1479             _addTokenToOwnerEnumeration(to, tokenId);
1480         }
1481     }
1482 
1483     /**
1484      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1485      * @param to address representing the new owner of the given token ID
1486      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1487      */
1488     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1489         uint256 length = ERC721.balanceOf(to);
1490         _ownedTokens[to][length] = tokenId;
1491         _ownedTokensIndex[tokenId] = length;
1492     }
1493 
1494     /**
1495      * @dev Private function to add a token to this extension's token tracking data structures.
1496      * @param tokenId uint256 ID of the token to be added to the tokens list
1497      */
1498     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1499         _allTokensIndex[tokenId] = _allTokens.length;
1500         _allTokens.push(tokenId);
1501     }
1502 
1503     /**
1504      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1505      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1506      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1507      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1508      * @param from address representing the previous owner of the given token ID
1509      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1510      */
1511     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1512         private
1513     {
1514         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1515         // then delete the last slot (swap and pop).
1516 
1517         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1518         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1519 
1520         // When the token to delete is the last token, the swap operation is unnecessary
1521         if (tokenIndex != lastTokenIndex) {
1522             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1523 
1524             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1525             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1526         }
1527 
1528         // This also deletes the contents at the last position of the array
1529         delete _ownedTokensIndex[tokenId];
1530         delete _ownedTokens[from][lastTokenIndex];
1531     }
1532 
1533     /**
1534      * @dev Private function to remove a token from this extension's token tracking data structures.
1535      * This has O(1) time complexity, but alters the order of the _allTokens array.
1536      * @param tokenId uint256 ID of the token to be removed from the tokens list
1537      */
1538     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1539         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1540         // then delete the last slot (swap and pop).
1541 
1542         uint256 lastTokenIndex = _allTokens.length - 1;
1543         uint256 tokenIndex = _allTokensIndex[tokenId];
1544 
1545         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1546         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1547         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1548         uint256 lastTokenId = _allTokens[lastTokenIndex];
1549 
1550         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1551         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1552 
1553         // This also deletes the contents at the last position of the array
1554         delete _allTokensIndex[tokenId];
1555         _allTokens.pop();
1556     }
1557 }
1558 
1559 // File: @openzeppelin/contracts/access/Ownable.sol
1560 
1561 /**
1562  * @dev Contract module which provides a basic access control mechanism, where
1563  * there is an account (an owner) that can be granted exclusive access to
1564  * specific functions.
1565  *
1566  * By default, the owner account will be the one that deploys the contract. This
1567  * can later be changed with {transferOwnership}.
1568  *
1569  * This module is used through inheritance. It will make available the modifier
1570  * `onlyOwner`, which can be applied to your functions to restrict their use to
1571  * the owner.
1572  */
1573 abstract contract Ownable is Context {
1574     address private _owner;
1575 
1576     event OwnershipTransferred(
1577         address indexed previousOwner,
1578         address indexed newOwner
1579     );
1580 
1581     /**
1582      * @dev Initializes the contract setting the deployer as the initial owner.
1583      */
1584     constructor() {
1585         address msgSender = _msgSender();
1586         _owner = msgSender;
1587         emit OwnershipTransferred(address(0), msgSender);
1588     }
1589 
1590     /**
1591      * @dev Returns the address of the current owner.
1592      */
1593     function owner() public view virtual returns (address) {
1594         return _owner;
1595     }
1596 
1597     /**
1598      * @dev Throws if called by any account other than the owner.
1599      */
1600     modifier onlyOwner() {
1601         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1602         _;
1603     }
1604 
1605     /**
1606      * @dev Leaves the contract without owner. It will not be possible to call
1607      * `onlyOwner` functions anymore. Can only be called by the current owner.
1608      *
1609      * NOTE: Renouncing ownership will leave the contract without an owner,
1610      * thereby removing any functionality that is only available to the owner.
1611      */
1612     function renounceOwnership() public virtual onlyOwner {
1613         emit OwnershipTransferred(_owner, address(0));
1614         _owner = address(0);
1615     }
1616 
1617     /**
1618      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1619      * Can only be called by the current owner.
1620      */
1621     function transferOwnership(address newOwner) public virtual onlyOwner {
1622         require(
1623             newOwner != address(0),
1624             "Ownable: new owner is the zero address"
1625         );
1626         emit OwnershipTransferred(_owner, newOwner);
1627         _owner = newOwner;
1628     }
1629 }
1630 
1631 // File: contracts/zombit.sol
1632 contract ZombitContract is ERC721Enumerable, Ownable {
1633     using SafeMath for uint256;
1634     address admin;
1635     uint256 public maxZombitPurchase = 10;
1636     uint256 public presaleMaxZombitPurchase = 5;
1637     uint256 public zombitPrice = 80000000000000000; //0.08 ETH
1638     uint256 public maxZombits = 10000;
1639     uint256 public saleStatus = 0; //0 close purchase,1 Pre-sale,2 public sale,3 close purchase
1640     mapping(address => bool) public whitelist;
1641     mapping(address => uint256) public totalAmount;
1642     // Base URI
1643     string private m_BaseURI = "";
1644 
1645     constructor(
1646         string memory name,
1647         string memory symbol,
1648         string memory baseURI
1649     ) ERC721(name, symbol) {
1650         admin = msg.sender;
1651         m_BaseURI = baseURI;
1652     }
1653 
1654     modifier onlyAdmin() {
1655         require(msg.sender == admin, "Not admin");
1656         _;
1657     }
1658 
1659     /**
1660      * Mint Zombits
1661      */
1662     function mintZombits(uint256 numberOfTokens) public payable {
1663         require(
1664             numberOfTokens <= maxZombitPurchase,
1665             "Exceeds max number of Zombits in one transaction"
1666         );
1667         require(saleStatus == 1 || saleStatus == 2, "Purchase not open");
1668         require(
1669             totalSupply().add(numberOfTokens) <= maxZombits,
1670             "Purchase would exceed max supply of Zombits"
1671         );
1672         require(
1673             zombitPrice.mul(numberOfTokens) == msg.value,
1674             "Ether value sent is not correct"
1675         );
1676         // Pre-sale
1677         if (saleStatus == 1) {
1678             require(
1679                 whitelist[_msgSender()],
1680                 "No permission to participate in the pre-sale"
1681             );
1682             require(
1683                 totalAmount[_msgSender()] + numberOfTokens <=
1684                     presaleMaxZombitPurchase,
1685                 "Exceeded quantity limit"
1686             );
1687         }
1688         for (uint256 i = 0; i < numberOfTokens; i++) {
1689             uint256 tokenId = totalSupply();
1690             _safeMint(_msgSender(), tokenId);
1691         }
1692         totalAmount[_msgSender()] = totalAmount[_msgSender()] + numberOfTokens;
1693     }
1694 
1695     /**
1696      * Recycle Zombits
1697      */
1698     function recycleZombits(uint256 numberOfTokens) public onlyAdmin {
1699         require(
1700             totalSupply().add(numberOfTokens) <= maxZombits,
1701             "Purchase would exceed max supply of Zombits"
1702         );
1703         for (uint256 i = 0; i < numberOfTokens; i++) {
1704             uint256 tokenId = totalSupply();
1705             _safeMint(_msgSender(), tokenId);
1706         }
1707     }
1708 
1709     /**
1710      * Add whitelist address
1711      */
1712     function addWhitelist(address[] memory addr) public onlyAdmin {
1713         for (uint256 i = 0; i < addr.length; i++) {
1714             whitelist[addr[i]] = true;
1715         }
1716     }
1717 
1718     /**
1719      * Remove whitelist address
1720      */
1721     function removeWhitelist(address[] memory addr) public onlyAdmin {
1722         for (uint256 i = 0; i < addr.length; i++) {
1723             whitelist[addr[i]] = false;
1724         }
1725     }
1726 
1727     /**
1728      * Withdraw all balance to the admin address
1729      */
1730     function withdraw() public onlyAdmin {
1731         uint256 balance = address(this).balance;
1732         require(balance > 0);
1733         payable(_msgSender()).transfer(balance);
1734     }
1735 
1736     //Sales switch
1737     function flipSaleState() public onlyAdmin {
1738         if (saleStatus < 3) {
1739             saleStatus = saleStatus + 1;
1740         }
1741     }
1742 
1743     function setAdmin(address addr) external onlyAdmin {
1744         admin = addr;
1745     }
1746 
1747     function setMaxToken(uint256 _value) external onlyAdmin {
1748         require(
1749             _value > totalSupply() && _value <= 10_000,
1750             "Wrong value for max supply"
1751         );
1752 
1753         maxZombits = _value;
1754     }
1755 
1756     function setPrice(uint256 _price) external onlyAdmin {
1757         zombitPrice = _price;
1758     }
1759 
1760     function setMaxPurchase(uint256 _value) external onlyAdmin {
1761         require(_value > 0, "Invalid value");
1762         maxZombitPurchase = _value;
1763     }
1764 
1765     function setPresaleMaxZombitPurchase(uint256 _value) external onlyAdmin {
1766         require(_value > 0, "Invalid value");
1767         presaleMaxZombitPurchase = _value;
1768     }
1769 
1770     // setBaseURI
1771     //  -  Metadata lives here
1772     function setBaseURI(string memory baseURI) external onlyAdmin {
1773         m_BaseURI = baseURI;
1774     }
1775 
1776     // _baseURI
1777     function _baseURI() internal view override returns (string memory) {
1778         return m_BaseURI;
1779     }
1780 
1781     //All tokens under this address
1782     function tokensOfOwner(address _owner)
1783         external
1784         view
1785         returns (uint256[] memory ownerTokens)
1786     {
1787         uint256 tokenCount = balanceOf(_owner);
1788 
1789         if (tokenCount == 0) {
1790             // Return an empty array
1791             return new uint256[](0);
1792         } else {
1793             uint256[] memory result = new uint256[](tokenCount);
1794             for (uint256 i = 0; i < tokenCount; i++) {
1795                 uint256 index = tokenOfOwnerByIndex(_owner, i);
1796                 result[i] = index;
1797             }
1798             return result;
1799         }
1800     }
1801 }