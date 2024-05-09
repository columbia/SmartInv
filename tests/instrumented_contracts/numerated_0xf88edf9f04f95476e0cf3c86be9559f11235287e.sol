1 // SPDX-License-Identifier: MIT LICENSE
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(
92             newOwner != address(0),
93             "Ownable: new owner is the zero address"
94         );
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 // File: contracts/BGFVault.sol
110 
111 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116 
117  * @dev Interface of the ERC165 standard, as defined in the
118 
119  * https://eips.ethereum.org/EIPS/eip-165[EIP].
120 
121  *
122 
123  * Implementers can declare support of contract interfaces, which can then be
124 
125  * queried by others ({ERC165Checker}).
126 
127  *
128 
129  * For an implementation, see {ERC165}.
130 
131  */
132 
133 interface IERC165 {
134     /**
135 
136      * @dev Returns true if this contract implements the interface defined by
137 
138      * `interfaceId`. See the corresponding
139 
140      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
141 
142      * to learn more about how these ids are created.
143 
144      *
145 
146      * This function call must use less than 30 000 gas.
147 
148      */
149 
150     function supportsInterface(bytes4 interfaceId) external view returns (bool);
151 }
152 
153 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158 
159  * @dev Required interface of an ERC721 compliant contract.
160 
161  */
162 
163 interface IERC721 is IERC165 {
164     /**
165 
166      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
167 
168      */
169 
170     event Transfer(
171         address indexed from,
172         address indexed to,
173         uint256 indexed tokenId
174     );
175 
176     /**
177 
178      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
179 
180      */
181 
182     event Approval(
183         address indexed owner,
184         address indexed approved,
185         uint256 indexed tokenId
186     );
187 
188     /**
189 
190      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
191 
192      */
193 
194     event ApprovalForAll(
195         address indexed owner,
196         address indexed operator,
197         bool approved
198     );
199 
200     /**
201 
202      * @dev Returns the number of tokens in ``owner``'s account.
203 
204      */
205 
206     function balanceOf(address owner) external view returns (uint256 balance);
207 
208     /**
209 
210      * @dev Returns the owner of the `tokenId` token.
211 
212      *
213 
214      * Requirements:
215 
216      *
217 
218      * - `tokenId` must exist.
219 
220      */
221 
222     function ownerOf(uint256 tokenId) external view returns (address owner);
223 
224     /**
225 
226      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
227 
228      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
229 
230      *
231 
232      * Requirements:
233 
234      *
235 
236      * - `from` cannot be the zero address.
237 
238      * - `to` cannot be the zero address.
239 
240      * - `tokenId` token must exist and be owned by `from`.
241 
242      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
243 
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245 
246      *
247 
248      * Emits a {Transfer} event.
249 
250      */
251 
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId
256     ) external;
257 
258     /**
259 
260      * @dev Transfers `tokenId` token from `from` to `to`.
261 
262      *
263 
264      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
265 
266      *
267 
268      * Requirements:
269 
270      *
271 
272      * - `from` cannot be the zero address.
273 
274      * - `to` cannot be the zero address.
275 
276      * - `tokenId` token must be owned by `from`.
277 
278      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
279 
280      *
281 
282      * Emits a {Transfer} event.
283 
284      */
285 
286     function transferFrom(
287         address from,
288         address to,
289         uint256 tokenId
290     ) external;
291 
292     /**
293 
294      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
295 
296      * The approval is cleared when the token is transferred.
297 
298      *
299 
300      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
301 
302      *
303 
304      * Requirements:
305 
306      *
307 
308      * - The caller must own the token or be an approved operator.
309 
310      * - `tokenId` must exist.
311 
312      *
313 
314      * Emits an {Approval} event.
315 
316      */
317 
318     function approve(address to, uint256 tokenId) external;
319 
320     /**
321 
322      * @dev Returns the account approved for `tokenId` token.
323 
324      *
325 
326      * Requirements:
327 
328      *
329 
330      * - `tokenId` must exist.
331 
332      */
333 
334     function getApproved(uint256 tokenId)
335         external
336         view
337         returns (address operator);
338 
339     /**
340 
341      * @dev Approve or remove `operator` as an operator for the caller.
342 
343      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
344 
345      *
346 
347      * Requirements:
348 
349      *
350 
351      * - The `operator` cannot be the caller.
352 
353      *
354 
355      * Emits an {ApprovalForAll} event.
356 
357      */
358 
359     function setApprovalForAll(address operator, bool _approved) external;
360 
361     /**
362 
363      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
364 
365      *
366 
367      * See {setApprovalForAll}
368 
369      */
370 
371     function isApprovedForAll(address owner, address operator)
372         external
373         view
374         returns (bool);
375 
376     /**
377 
378      * @dev Safely transfers `tokenId` token from `from` to `to`.
379 
380      *
381 
382      * Requirements:
383 
384      *
385 
386      * - `from` cannot be the zero address.
387 
388      * - `to` cannot be the zero address.
389 
390      * - `tokenId` token must exist and be owned by `from`.
391 
392      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
393 
394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
395 
396      *
397 
398      * Emits a {Transfer} event.
399 
400      */
401 
402     function safeTransferFrom(
403         address from,
404         address to,
405         uint256 tokenId,
406         bytes calldata data
407     ) external;
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415 
416  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
417 
418  * @dev See https://eips.ethereum.org/EIPS/eip-721
419 
420  */
421 
422 interface IERC721Enumerable is IERC721 {
423     /**
424 
425      * @dev Returns the total amount of tokens stored by the contract.
426 
427      */
428 
429     function totalSupply() external view returns (uint256);
430 
431     /**
432 
433      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
434 
435      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
436 
437      */
438 
439     function tokenOfOwnerByIndex(address owner, uint256 index)
440         external
441         view
442         returns (uint256 tokenId);
443 
444     /**
445 
446      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
447 
448      * Use along with {totalSupply} to enumerate all tokens.
449 
450      */
451 
452     function tokenByIndex(uint256 index) external view returns (uint256);
453 }
454 
455 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460 
461  * @dev Implementation of the {IERC165} interface.
462 
463  *
464 
465  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
466 
467  * for the additional interface id that will be supported. For example:
468 
469  *
470 
471  * ```solidity
472 
473  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
474 
475  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
476 
477  * }
478 
479  * ```
480 
481  *
482 
483  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
484 
485  */
486 
487 abstract contract ERC165 is IERC165 {
488     /**
489 
490      * @dev See {IERC165-supportsInterface}.
491 
492      */
493 
494     function supportsInterface(bytes4 interfaceId)
495         public
496         view
497         virtual
498         override
499         returns (bool)
500     {
501         return interfaceId == type(IERC165).interfaceId;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/utils/Strings.sol
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510 
511  * @dev String operations.
512 
513  */
514 
515 library Strings {
516     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
517 
518     /**
519 
520      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
521 
522      */
523 
524     function toString(uint256 value) internal pure returns (string memory) {
525         // Inspired by OraclizeAPI's implementation - MIT licence
526 
527         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
528 
529         if (value == 0) {
530             return "0";
531         }
532 
533         uint256 temp = value;
534 
535         uint256 digits;
536 
537         while (temp != 0) {
538             digits++;
539 
540             temp /= 10;
541         }
542 
543         bytes memory buffer = new bytes(digits);
544 
545         while (value != 0) {
546             digits -= 1;
547 
548             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
549 
550             value /= 10;
551         }
552 
553         return string(buffer);
554     }
555 
556     /**
557 
558      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
559 
560      */
561 
562     function toHexString(uint256 value) internal pure returns (string memory) {
563         if (value == 0) {
564             return "0x00";
565         }
566 
567         uint256 temp = value;
568 
569         uint256 length = 0;
570 
571         while (temp != 0) {
572             length++;
573 
574             temp >>= 8;
575         }
576 
577         return toHexString(value, length);
578     }
579 
580     /**
581 
582      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
583 
584      */
585 
586     function toHexString(uint256 value, uint256 length)
587         internal
588         pure
589         returns (string memory)
590     {
591         bytes memory buffer = new bytes(2 * length + 2);
592 
593         buffer[0] = "0";
594 
595         buffer[1] = "x";
596 
597         for (uint256 i = 2 * length + 1; i > 1; --i) {
598             buffer[i] = _HEX_SYMBOLS[value & 0xf];
599 
600             value >>= 4;
601         }
602 
603         require(value == 0, "Strings: hex length insufficient");
604 
605         return string(buffer);
606     }
607 }
608 
609 // File: @openzeppelin/contracts/utils/Address.sol
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614 
615  * @dev Collection of functions related to the address type
616 
617  */
618 
619 library Address {
620     /**
621 
622      * @dev Returns true if `account` is a contract.
623 
624      *
625 
626      * [IMPORTANT]
627 
628      * ====
629 
630      * It is unsafe to assume that an address for which this function returns
631 
632      * false is an externally-owned account (EOA) and not a contract.
633 
634      *
635 
636      * Among others, `isContract` will return false for the following
637 
638      * types of addresses:
639 
640      *
641 
642      *  - an externally-owned account
643 
644      *  - a contract in construction
645 
646      *  - an address where a contract will be created
647 
648      *  - an address where a contract lived, but was destroyed
649 
650      * ====
651 
652      */
653 
654     function isContract(address account) internal view returns (bool) {
655         // This method relies on extcodesize, which returns 0 for contracts in
656 
657         // construction, since the code is only stored at the end of the
658 
659         // constructor execution.
660 
661         uint256 size;
662 
663         assembly {
664             size := extcodesize(account)
665         }
666 
667         return size > 0;
668     }
669 
670     /**
671 
672      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
673 
674      * `recipient`, forwarding all available gas and reverting on errors.
675 
676      *
677 
678      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
679 
680      * of certain opcodes, possibly making contracts go over the 2300 gas limit
681 
682      * imposed by `transfer`, making them unable to receive funds via
683 
684      * `transfer`. {sendValue} removes this limitation.
685 
686      *
687 
688      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
689 
690      *
691 
692      * IMPORTANT: because control is transferred to `recipient`, care must be
693 
694      * taken to not create reentrancy vulnerabilities. Consider using
695 
696      * {ReentrancyGuard} or the
697 
698      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
699 
700      */
701 
702     function sendValue(address payable recipient, uint256 amount) internal {
703         require(
704             address(this).balance >= amount,
705             "Address: insufficient balance"
706         );
707 
708         (bool success, ) = recipient.call{value: amount}("");
709 
710         require(
711             success,
712             "Address: unable to send value, recipient may have reverted"
713         );
714     }
715 
716     /**
717 
718      * @dev Performs a Solidity function call using a low level `call`. A
719 
720      * plain `call` is an unsafe replacement for a function call: use this
721 
722      * function instead.
723 
724      *
725 
726      * If `target` reverts with a revert reason, it is bubbled up by this
727 
728      * function (like regular Solidity function calls).
729 
730      *
731 
732      * Returns the raw returned data. To convert to the expected return value,
733 
734      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
735 
736      *
737 
738      * Requirements:
739 
740      *
741 
742      * - `target` must be a contract.
743 
744      * - calling `target` with `data` must not revert.
745 
746      *
747 
748      * _Available since v3.1._
749 
750      */
751 
752     function functionCall(address target, bytes memory data)
753         internal
754         returns (bytes memory)
755     {
756         return functionCall(target, data, "Address: low-level call failed");
757     }
758 
759     /**
760 
761      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
762 
763      * `errorMessage` as a fallback revert reason when `target` reverts.
764 
765      *
766 
767      * _Available since v3.1._
768 
769      */
770 
771     function functionCall(
772         address target,
773         bytes memory data,
774         string memory errorMessage
775     ) internal returns (bytes memory) {
776         return functionCallWithValue(target, data, 0, errorMessage);
777     }
778 
779     /**
780 
781      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
782 
783      * but also transferring `value` wei to `target`.
784 
785      *
786 
787      * Requirements:
788 
789      *
790 
791      * - the calling contract must have an ETH balance of at least `value`.
792 
793      * - the called Solidity function must be `payable`.
794 
795      *
796 
797      * _Available since v3.1._
798 
799      */
800 
801     function functionCallWithValue(
802         address target,
803         bytes memory data,
804         uint256 value
805     ) internal returns (bytes memory) {
806         return
807             functionCallWithValue(
808                 target,
809                 data,
810                 value,
811                 "Address: low-level call with value failed"
812             );
813     }
814 
815     /**
816 
817      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
818 
819      * with `errorMessage` as a fallback revert reason when `target` reverts.
820 
821      *
822 
823      * _Available since v3.1._
824 
825      */
826 
827     function functionCallWithValue(
828         address target,
829         bytes memory data,
830         uint256 value,
831         string memory errorMessage
832     ) internal returns (bytes memory) {
833         require(
834             address(this).balance >= value,
835             "Address: insufficient balance for call"
836         );
837 
838         require(isContract(target), "Address: call to non-contract");
839 
840         (bool success, bytes memory returndata) = target.call{value: value}(
841             data
842         );
843 
844         return verifyCallResult(success, returndata, errorMessage);
845     }
846 
847     /**
848 
849      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
850 
851      * but performing a static call.
852 
853      *
854 
855      * _Available since v3.3._
856 
857      */
858 
859     function functionStaticCall(address target, bytes memory data)
860         internal
861         view
862         returns (bytes memory)
863     {
864         return
865             functionStaticCall(
866                 target,
867                 data,
868                 "Address: low-level static call failed"
869             );
870     }
871 
872     /**
873 
874      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
875 
876      * but performing a static call.
877 
878      *
879 
880      * _Available since v3.3._
881 
882      */
883 
884     function functionStaticCall(
885         address target,
886         bytes memory data,
887         string memory errorMessage
888     ) internal view returns (bytes memory) {
889         require(isContract(target), "Address: static call to non-contract");
890 
891         (bool success, bytes memory returndata) = target.staticcall(data);
892 
893         return verifyCallResult(success, returndata, errorMessage);
894     }
895 
896     /**
897 
898      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
899 
900      * but performing a delegate call.
901 
902      *
903 
904      * _Available since v3.4._
905 
906      */
907 
908     function functionDelegateCall(address target, bytes memory data)
909         internal
910         returns (bytes memory)
911     {
912         return
913             functionDelegateCall(
914                 target,
915                 data,
916                 "Address: low-level delegate call failed"
917             );
918     }
919 
920     /**
921 
922      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
923 
924      * but performing a delegate call.
925 
926      *
927 
928      * _Available since v3.4._
929 
930      */
931 
932     function functionDelegateCall(
933         address target,
934         bytes memory data,
935         string memory errorMessage
936     ) internal returns (bytes memory) {
937         require(isContract(target), "Address: delegate call to non-contract");
938 
939         (bool success, bytes memory returndata) = target.delegatecall(data);
940 
941         return verifyCallResult(success, returndata, errorMessage);
942     }
943 
944     /**
945 
946      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
947 
948      * revert reason using the provided one.
949 
950      *
951 
952      * _Available since v4.3._
953 
954      */
955 
956     function verifyCallResult(
957         bool success,
958         bytes memory returndata,
959         string memory errorMessage
960     ) internal pure returns (bytes memory) {
961         if (success) {
962             return returndata;
963         } else {
964             // Look for revert reason and bubble it up if present
965 
966             if (returndata.length > 0) {
967                 // The easiest way to bubble the revert reason is using memory via assembly
968 
969                 assembly {
970                     let returndata_size := mload(returndata)
971 
972                     revert(add(32, returndata), returndata_size)
973                 }
974             } else {
975                 revert(errorMessage);
976             }
977         }
978     }
979 }
980 
981 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
982 
983 pragma solidity ^0.8.0;
984 
985 /**
986 
987  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
988 
989  * @dev See https://eips.ethereum.org/EIPS/eip-721
990 
991  */
992 
993 interface IERC721Metadata is IERC721 {
994     /**
995 
996      * @dev Returns the token collection name.
997 
998      */
999 
1000     function name() external view returns (string memory);
1001 
1002     /**
1003 
1004      * @dev Returns the token collection symbol.
1005 
1006      */
1007 
1008     function symbol() external view returns (string memory);
1009 
1010     /**
1011 
1012      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1013 
1014      */
1015 
1016     function tokenURI(uint256 tokenId) external view returns (string memory);
1017 }
1018 
1019 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 /**
1024 
1025  * @title ERC721 token receiver interface
1026 
1027  * @dev Interface for any contract that wants to support safeTransfers
1028 
1029  * from ERC721 asset contracts.
1030 
1031  */
1032 
1033 interface IERC721Receiver {
1034     /**
1035 
1036      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1037 
1038      * by `operator` from `from`, this function is called.
1039 
1040      *
1041 
1042      * It must return its Solidity selector to confirm the token transfer.
1043 
1044      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1045 
1046      *
1047 
1048      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1049 
1050      */
1051 
1052     function onERC721Received(
1053         address operator,
1054         address from,
1055         uint256 tokenId,
1056         bytes calldata data
1057     ) external returns (bytes4);
1058 }
1059 
1060 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1061 
1062 pragma solidity ^0.8.0;
1063 
1064 /**
1065 
1066  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1067 
1068  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1069 
1070  * {ERC721Enumerable}.
1071 
1072  */
1073 
1074 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1075     using Address for address;
1076 
1077     using Strings for uint256;
1078 
1079     // Token name
1080 
1081     string private _name;
1082 
1083     // Token symbol
1084 
1085     string private _symbol;
1086 
1087     // Mapping from token ID to owner address
1088 
1089     mapping(uint256 => address) private _owners;
1090 
1091     // Mapping owner address to token count
1092 
1093     mapping(address => uint256) private _balances;
1094 
1095     // Mapping from token ID to approved address
1096 
1097     mapping(uint256 => address) private _tokenApprovals;
1098 
1099     // Mapping from owner to operator approvals
1100 
1101     mapping(address => mapping(address => bool)) private _operatorApprovals;
1102 
1103     /**
1104 
1105      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1106 
1107      */
1108 
1109     constructor(string memory name_, string memory symbol_) {
1110         _name = name_;
1111 
1112         _symbol = symbol_;
1113     }
1114 
1115     /**
1116 
1117      * @dev See {IERC165-supportsInterface}.
1118 
1119      */
1120 
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
1135 
1136      * @dev See {IERC721-balanceOf}.
1137 
1138      */
1139 
1140     function balanceOf(address owner)
1141         public
1142         view
1143         virtual
1144         override
1145         returns (uint256)
1146     {
1147         require(
1148             owner != address(0),
1149             "ERC721: balance query for the zero address"
1150         );
1151 
1152         return _balances[owner];
1153     }
1154 
1155     /**
1156 
1157      * @dev See {IERC721-ownerOf}.
1158 
1159      */
1160 
1161     function ownerOf(uint256 tokenId)
1162         public
1163         view
1164         virtual
1165         override
1166         returns (address)
1167     {
1168         address owner = _owners[tokenId];
1169 
1170         require(
1171             owner != address(0),
1172             "ERC721: owner query for nonexistent token"
1173         );
1174 
1175         return owner;
1176     }
1177 
1178     /**
1179 
1180      * @dev See {IERC721Metadata-name}.
1181 
1182      */
1183 
1184     function name() public view virtual override returns (string memory) {
1185         return _name;
1186     }
1187 
1188     /**
1189 
1190      * @dev See {IERC721Metadata-symbol}.
1191 
1192      */
1193 
1194     function symbol() public view virtual override returns (string memory) {
1195         return _symbol;
1196     }
1197 
1198     /**
1199 
1200      * @dev See {IERC721Metadata-tokenURI}.
1201 
1202      */
1203 
1204     function tokenURI(uint256 tokenId)
1205         public
1206         view
1207         virtual
1208         override
1209         returns (string memory)
1210     {
1211         require(
1212             _exists(tokenId),
1213             "ERC721Metadata: URI query for nonexistent token"
1214         );
1215 
1216         string memory baseURI = _baseURI();
1217 
1218         return
1219             bytes(baseURI).length > 0
1220                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1221                 : "";
1222     }
1223 
1224     /**
1225 
1226      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1227 
1228      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1229 
1230      * by default, can be overriden in child contracts.
1231 
1232      */
1233 
1234     function _baseURI() internal view virtual returns (string memory) {
1235         return "";
1236     }
1237 
1238     /**
1239 
1240      * @dev See {IERC721-approve}.
1241 
1242      */
1243 
1244     function approve(address to, uint256 tokenId) public virtual override {
1245         address owner = ERC721.ownerOf(tokenId);
1246 
1247         require(to != owner, "ERC721: approval to current owner");
1248 
1249         require(
1250             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1251             "ERC721: approve caller is not owner nor approved for all"
1252         );
1253 
1254         _approve(to, tokenId);
1255     }
1256 
1257     /**
1258 
1259      * @dev See {IERC721-getApproved}.
1260 
1261      */
1262 
1263     function getApproved(uint256 tokenId)
1264         public
1265         view
1266         virtual
1267         override
1268         returns (address)
1269     {
1270         require(
1271             _exists(tokenId),
1272             "ERC721: approved query for nonexistent token"
1273         );
1274 
1275         return _tokenApprovals[tokenId];
1276     }
1277 
1278     /**
1279 
1280      * @dev See {IERC721-setApprovalForAll}.
1281 
1282      */
1283 
1284     function setApprovalForAll(address operator, bool approved)
1285         public
1286         virtual
1287         override
1288     {
1289         require(operator != _msgSender(), "ERC721: approve to caller");
1290 
1291         _operatorApprovals[_msgSender()][operator] = approved;
1292 
1293         emit ApprovalForAll(_msgSender(), operator, approved);
1294     }
1295 
1296     /**
1297 
1298      * @dev See {IERC721-isApprovedForAll}.
1299 
1300      */
1301 
1302     function isApprovedForAll(address owner, address operator)
1303         public
1304         view
1305         virtual
1306         override
1307         returns (bool)
1308     {
1309         return _operatorApprovals[owner][operator];
1310     }
1311 
1312     /**
1313 
1314      * @dev See {IERC721-transferFrom}.
1315 
1316      */
1317 
1318     function transferFrom(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) public virtual override {
1323         //solhint-disable-next-line max-line-length
1324 
1325         require(
1326             _isApprovedOrOwner(_msgSender(), tokenId),
1327             "ERC721: transfer caller is not owner nor approved"
1328         );
1329 
1330         _transfer(from, to, tokenId);
1331     }
1332 
1333     /**
1334 
1335      * @dev See {IERC721-safeTransferFrom}.
1336 
1337      */
1338 
1339     function safeTransferFrom(
1340         address from,
1341         address to,
1342         uint256 tokenId
1343     ) public virtual override {
1344         safeTransferFrom(from, to, tokenId, "");
1345     }
1346 
1347     /**
1348 
1349      * @dev See {IERC721-safeTransferFrom}.
1350 
1351      */
1352 
1353     function safeTransferFrom(
1354         address from,
1355         address to,
1356         uint256 tokenId,
1357         bytes memory _data
1358     ) public virtual override {
1359         require(
1360             _isApprovedOrOwner(_msgSender(), tokenId),
1361             "ERC721: transfer caller is not owner nor approved"
1362         );
1363 
1364         _safeTransfer(from, to, tokenId, _data);
1365     }
1366 
1367     /**
1368 
1369      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1370 
1371      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1372 
1373      *
1374 
1375      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1376 
1377      *
1378 
1379      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1380 
1381      * implement alternative mechanisms to perform token transfer, such as signature-based.
1382 
1383      *
1384 
1385      * Requirements:
1386 
1387      *
1388 
1389      * - `from` cannot be the zero address.
1390 
1391      * - `to` cannot be the zero address.
1392 
1393      * - `tokenId` token must exist and be owned by `from`.
1394 
1395      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1396 
1397      *
1398 
1399      * Emits a {Transfer} event.
1400 
1401      */
1402 
1403     function _safeTransfer(
1404         address from,
1405         address to,
1406         uint256 tokenId,
1407         bytes memory _data
1408     ) internal virtual {
1409         _transfer(from, to, tokenId);
1410 
1411         require(
1412             _checkOnERC721Received(from, to, tokenId, _data),
1413             "ERC721: transfer to non ERC721Receiver implementer"
1414         );
1415     }
1416 
1417     /**
1418 
1419      * @dev Returns whether `tokenId` exists.
1420 
1421      *
1422 
1423      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1424 
1425      *
1426 
1427      * Tokens start existing when they are minted (`_mint`),
1428 
1429      * and stop existing when they are burned (`_burn`).
1430 
1431      */
1432 
1433     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1434         return _owners[tokenId] != address(0);
1435     }
1436 
1437     /**
1438 
1439      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1440 
1441      *
1442 
1443      * Requirements:
1444 
1445      *
1446 
1447      * - `tokenId` must exist.
1448 
1449      */
1450 
1451     function _isApprovedOrOwner(address spender, uint256 tokenId)
1452         internal
1453         view
1454         virtual
1455         returns (bool)
1456     {
1457         require(
1458             _exists(tokenId),
1459             "ERC721: operator query for nonexistent token"
1460         );
1461 
1462         address owner = ERC721.ownerOf(tokenId);
1463 
1464         return (spender == owner ||
1465             getApproved(tokenId) == spender ||
1466             isApprovedForAll(owner, spender));
1467     }
1468 
1469     /**
1470 
1471      * @dev Safely mints `tokenId` and transfers it to `to`.
1472 
1473      *
1474 
1475      * Requirements:
1476 
1477      *
1478 
1479      * - `tokenId` must not exist.
1480 
1481      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1482 
1483      *
1484 
1485      * Emits a {Transfer} event.
1486 
1487      */
1488 
1489     function _safeMint(address to, uint256 tokenId) internal virtual {
1490         _safeMint(to, tokenId, "");
1491     }
1492 
1493     /**
1494 
1495      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1496 
1497      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1498 
1499      */
1500 
1501     function _safeMint(
1502         address to,
1503         uint256 tokenId,
1504         bytes memory _data
1505     ) internal virtual {
1506         _mint(to, tokenId);
1507 
1508         require(
1509             _checkOnERC721Received(address(0), to, tokenId, _data),
1510             "ERC721: transfer to non ERC721Receiver implementer"
1511         );
1512     }
1513 
1514     /**
1515 
1516      * @dev Mints `tokenId` and transfers it to `to`.
1517 
1518      *
1519 
1520      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1521 
1522      *
1523 
1524      * Requirements:
1525 
1526      *
1527 
1528      * - `tokenId` must not exist.
1529 
1530      * - `to` cannot be the zero address.
1531 
1532      *
1533 
1534      * Emits a {Transfer} event.
1535 
1536      */
1537 
1538     function _mint(address to, uint256 tokenId) internal virtual {
1539         require(to != address(0), "ERC721: mint to the zero address");
1540 
1541         require(!_exists(tokenId), "ERC721: token already minted");
1542 
1543         _beforeTokenTransfer(address(0), to, tokenId);
1544 
1545         _balances[to] += 1;
1546 
1547         _owners[tokenId] = to;
1548 
1549         emit Transfer(address(0), to, tokenId);
1550     }
1551 
1552     /**
1553 
1554      * @dev Destroys `tokenId`.
1555 
1556      * The approval is cleared when the token is burned.
1557 
1558      *
1559 
1560      * Requirements:
1561 
1562      *
1563 
1564      * - `tokenId` must exist.
1565 
1566      *
1567 
1568      * Emits a {Transfer} event.
1569 
1570      */
1571 
1572     function _burn(uint256 tokenId) internal virtual {
1573         address owner = ERC721.ownerOf(tokenId);
1574 
1575         _beforeTokenTransfer(owner, address(0), tokenId);
1576 
1577         // Clear approvals
1578 
1579         _approve(address(0), tokenId);
1580 
1581         _balances[owner] -= 1;
1582 
1583         delete _owners[tokenId];
1584 
1585         emit Transfer(owner, address(0), tokenId);
1586     }
1587 
1588     /**
1589 
1590      * @dev Transfers `tokenId` from `from` to `to`.
1591 
1592      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1593 
1594      *
1595 
1596      * Requirements:
1597 
1598      *
1599 
1600      * - `to` cannot be the zero address.
1601 
1602      * - `tokenId` token must be owned by `from`.
1603 
1604      *
1605 
1606      * Emits a {Transfer} event.
1607 
1608      */
1609 
1610     function _transfer(
1611         address from,
1612         address to,
1613         uint256 tokenId
1614     ) internal virtual {
1615         require(
1616             ERC721.ownerOf(tokenId) == from,
1617             "ERC721: transfer of token that is not own"
1618         );
1619 
1620         require(to != address(0), "ERC721: transfer to the zero address");
1621 
1622         _beforeTokenTransfer(from, to, tokenId);
1623 
1624         // Clear approvals from the previous owner
1625 
1626         _approve(address(0), tokenId);
1627 
1628         _balances[from] -= 1;
1629 
1630         _balances[to] += 1;
1631 
1632         _owners[tokenId] = to;
1633 
1634         emit Transfer(from, to, tokenId);
1635     }
1636 
1637     /**
1638 
1639      * @dev Approve `to` to operate on `tokenId`
1640 
1641      *
1642 
1643      * Emits a {Approval} event.
1644 
1645      */
1646 
1647     function _approve(address to, uint256 tokenId) internal virtual {
1648         _tokenApprovals[tokenId] = to;
1649 
1650         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1651     }
1652 
1653     /**
1654 
1655      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1656 
1657      * The call is not executed if the target address is not a contract.
1658 
1659      *
1660 
1661      * @param from address representing the previous owner of the given token ID
1662 
1663      * @param to target address that will receive the tokens
1664 
1665      * @param tokenId uint256 ID of the token to be transferred
1666 
1667      * @param _data bytes optional data to send along with the call
1668 
1669      * @return bool whether the call correctly returned the expected magic value
1670 
1671      */
1672 
1673     function _checkOnERC721Received(
1674         address from,
1675         address to,
1676         uint256 tokenId,
1677         bytes memory _data
1678     ) private returns (bool) {
1679         if (to.isContract()) {
1680             try
1681                 IERC721Receiver(to).onERC721Received(
1682                     _msgSender(),
1683                     from,
1684                     tokenId,
1685                     _data
1686                 )
1687             returns (bytes4 retval) {
1688                 return retval == IERC721Receiver.onERC721Received.selector;
1689             } catch (bytes memory reason) {
1690                 if (reason.length == 0) {
1691                     revert(
1692                         "ERC721: transfer to non ERC721Receiver implementer"
1693                     );
1694                 } else {
1695                     assembly {
1696                         revert(add(32, reason), mload(reason))
1697                     }
1698                 }
1699             }
1700         } else {
1701             return true;
1702         }
1703     }
1704 
1705     /**
1706 
1707      * @dev Hook that is called before any token transfer. This includes minting
1708 
1709      * and burning.
1710 
1711      *
1712 
1713      * Calling conditions:
1714 
1715      *
1716 
1717      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1718 
1719      * transferred to `to`.
1720 
1721      * - When `from` is zero, `tokenId` will be minted for `to`.
1722 
1723      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1724 
1725      * - `from` and `to` are never both zero.
1726 
1727      *
1728 
1729      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1730 
1731      */
1732 
1733     function _beforeTokenTransfer(
1734         address from,
1735         address to,
1736         uint256 tokenId
1737     ) internal virtual {}
1738 }
1739 
1740 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1741 
1742 pragma solidity ^0.8.0;
1743 
1744 /**
1745 
1746  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1747 
1748  * enumerability of all the token ids in the contract as well as all token ids owned by each
1749 
1750  * account.
1751 
1752  */
1753 
1754 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1755     // Mapping from owner to list of owned token IDs
1756 
1757     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1758 
1759     // Mapping from token ID to index of the owner tokens list
1760 
1761     mapping(uint256 => uint256) private _ownedTokensIndex;
1762 
1763     // Array with all token ids, used for enumeration
1764 
1765     uint256[] private _allTokens;
1766 
1767     // Mapping from token id to position in the allTokens array
1768 
1769     mapping(uint256 => uint256) private _allTokensIndex;
1770 
1771     /**
1772 
1773      * @dev See {IERC165-supportsInterface}.
1774 
1775      */
1776 
1777     function supportsInterface(bytes4 interfaceId)
1778         public
1779         view
1780         virtual
1781         override(IERC165, ERC721)
1782         returns (bool)
1783     {
1784         return
1785             interfaceId == type(IERC721Enumerable).interfaceId ||
1786             super.supportsInterface(interfaceId);
1787     }
1788 
1789     /**
1790 
1791      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1792 
1793      */
1794 
1795     function tokenOfOwnerByIndex(address owner, uint256 index)
1796         public
1797         view
1798         virtual
1799         override
1800         returns (uint256)
1801     {
1802         require(
1803             index < ERC721.balanceOf(owner),
1804             "ERC721Enumerable: owner index out of bounds"
1805         );
1806 
1807         return _ownedTokens[owner][index];
1808     }
1809 
1810     /**
1811 
1812      * @dev See {IERC721Enumerable-totalSupply}.
1813 
1814      */
1815 
1816     function totalSupply() public view virtual override returns (uint256) {
1817         return _allTokens.length;
1818     }
1819 
1820     /**
1821 
1822      * @dev See {IERC721Enumerable-tokenByIndex}.
1823 
1824      */
1825 
1826     function tokenByIndex(uint256 index)
1827         public
1828         view
1829         virtual
1830         override
1831         returns (uint256)
1832     {
1833         require(
1834             index < ERC721Enumerable.totalSupply(),
1835             "ERC721Enumerable: global index out of bounds"
1836         );
1837 
1838         return _allTokens[index];
1839     }
1840 
1841     /**
1842 
1843      * @dev Hook that is called before any token transfer. This includes minting
1844 
1845      * and burning.
1846 
1847      *
1848 
1849      * Calling conditions:
1850 
1851      *
1852 
1853      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1854 
1855      * transferred to `to`.
1856 
1857      * - When `from` is zero, `tokenId` will be minted for `to`.
1858 
1859      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1860 
1861      * - `from` cannot be the zero address.
1862 
1863      * - `to` cannot be the zero address.
1864 
1865      *
1866 
1867      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1868 
1869      */
1870 
1871     function _beforeTokenTransfer(
1872         address from,
1873         address to,
1874         uint256 tokenId
1875     ) internal virtual override {
1876         super._beforeTokenTransfer(from, to, tokenId);
1877 
1878         if (from == address(0)) {
1879             _addTokenToAllTokensEnumeration(tokenId);
1880         } else if (from != to) {
1881             _removeTokenFromOwnerEnumeration(from, tokenId);
1882         }
1883 
1884         if (to == address(0)) {
1885             _removeTokenFromAllTokensEnumeration(tokenId);
1886         } else if (to != from) {
1887             _addTokenToOwnerEnumeration(to, tokenId);
1888         }
1889     }
1890 
1891     /**
1892 
1893      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1894 
1895      * @param to address representing the new owner of the given token ID
1896 
1897      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1898 
1899      */
1900 
1901     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1902         uint256 length = ERC721.balanceOf(to);
1903 
1904         _ownedTokens[to][length] = tokenId;
1905 
1906         _ownedTokensIndex[tokenId] = length;
1907     }
1908 
1909     /**
1910 
1911      * @dev Private function to add a token to this extension's token tracking data structures.
1912 
1913      * @param tokenId uint256 ID of the token to be added to the tokens list
1914 
1915      */
1916 
1917     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1918         _allTokensIndex[tokenId] = _allTokens.length;
1919 
1920         _allTokens.push(tokenId);
1921     }
1922 
1923     /**
1924 
1925      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1926 
1927      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1928 
1929      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1930 
1931      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1932 
1933      * @param from address representing the previous owner of the given token ID
1934 
1935      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1936 
1937      */
1938 
1939     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1940         private
1941     {
1942         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1943 
1944         // then delete the last slot (swap and pop).
1945 
1946         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1947 
1948         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1949 
1950         // When the token to delete is the last token, the swap operation is unnecessary
1951 
1952         if (tokenIndex != lastTokenIndex) {
1953             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1954 
1955             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1956 
1957             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1958         }
1959 
1960         // This also deletes the contents at the last position of the array
1961 
1962         delete _ownedTokensIndex[tokenId];
1963 
1964         delete _ownedTokens[from][lastTokenIndex];
1965     }
1966 
1967     /**
1968 
1969      * @dev Private function to remove a token from this extension's token tracking data structures.
1970 
1971      * This has O(1) time complexity, but alters the order of the _allTokens array.
1972 
1973      * @param tokenId uint256 ID of the token to be removed from the tokens list
1974 
1975      */
1976 
1977     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1978         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1979 
1980         // then delete the last slot (swap and pop).
1981 
1982         uint256 lastTokenIndex = _allTokens.length - 1;
1983 
1984         uint256 tokenIndex = _allTokensIndex[tokenId];
1985 
1986         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1987 
1988         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1989 
1990         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1991 
1992         uint256 lastTokenId = _allTokens[lastTokenIndex];
1993 
1994         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1995         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1996         // This also deletes the contents at the last position of the array
1997 
1998         delete _allTokensIndex[tokenId];
1999 
2000         _allTokens.pop();
2001     }
2002 }
2003 
2004 pragma solidity ^0.8.0;
2005 
2006 interface HELLISHVAULT {
2007     function getBankBalance(address _address) external returns (uint256);
2008     function spendBalanceTowers(address _address, uint256 _amount) external;
2009 }
2010 
2011 contract BGFTOWERS is ERC721Enumerable, Ownable {
2012     using Strings for uint256;
2013 
2014     string public baseURI;
2015     string public baseExtension = "";
2016     uint256 public maxSupply = 600;
2017     uint256 public price = 800;
2018     bool public paused = true;
2019     address public bgfVault;
2020 
2021     HELLISHVAULT vaultContract;
2022 
2023     constructor() ERC721("Bad Girlfriend Project Towers", "BGFTOWERS") {}
2024 
2025     // internal
2026       function _baseURI() internal view virtual override returns (string memory) {
2027         return baseURI;
2028     }
2029 
2030     function setVaultAddress(address _address) public onlyOwner {
2031         bgfVault = _address;
2032         vaultContract = HELLISHVAULT(_address);
2033     }
2034 
2035     function mint() public {
2036         require(!paused, "Not allowed yet.");
2037         uint256 balance = vaultContract.getBankBalance(msg.sender);
2038         require(balance >= price, "Insufficient Balance.");
2039         uint256 supply = totalSupply();
2040         require(supply + 1 <= maxSupply, "Total supply would be reached.");
2041         vaultContract.spendBalanceTowers(msg.sender, price);
2042         _safeMint(msg.sender, supply + 1);
2043         if (supply + 1 == 100) {
2044             paused = true;
2045         }
2046         if (supply + 1 == 200) {
2047             paused = true;
2048         }
2049         if (supply + 1 == 300) {
2050             paused = true;
2051         }
2052         if (supply + 1 == 400) {
2053             paused = true;
2054         }
2055         if (supply + 1 == 500) {
2056             paused = true;
2057         }
2058     }
2059 
2060     function walletOfOwner(address _owner)
2061         public
2062         view
2063         returns (uint256[] memory)
2064     {
2065         uint256 ownerTokenCount = balanceOf(_owner);
2066         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2067 
2068         for (uint256 i; i < ownerTokenCount; i++) {
2069             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2070         }
2071 
2072         return tokenIds;
2073     }
2074 
2075     function tokenURI(uint256 tokenId)
2076         public
2077         view
2078         virtual
2079         override
2080         returns (string memory)
2081     {
2082         require(_exists(tokenId), "Token doesn't exist.");
2083 
2084         string memory currentBaseURI = _baseURI();
2085 
2086         return
2087             bytes(currentBaseURI).length > 0
2088                 ? string(
2089                     abi.encodePacked(
2090                         currentBaseURI,
2091                         tokenId.toString(),
2092                         baseExtension
2093                     )
2094                 )
2095                 : "";
2096     }
2097 
2098     // only owner
2099     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2100         baseURI = _newBaseURI;
2101     }
2102 
2103     function setBaseExtension(string memory _newBaseExtension)
2104         public
2105         onlyOwner
2106     {
2107         baseExtension = _newBaseExtension;
2108     }
2109 
2110     function pause(bool _state) public onlyOwner {
2111         paused = _state;
2112     }
2113 
2114     function setPrice(uint256 _price) public onlyOwner {
2115         price = _price;
2116     }
2117 
2118     function withdraw() public payable onlyOwner {
2119         require(payable(msg.sender).send(address(this).balance));
2120     }
2121 }