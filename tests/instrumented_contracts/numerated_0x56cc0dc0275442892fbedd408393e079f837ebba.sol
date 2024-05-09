1 // ___    __     __    _  __  _   ___    __
2 //| _ \  /__\   /__\  | |/ / | | | __| /' _/
3 //| v / | \/ | | \/ | |   <  | | | _|  `._`.
4 //|_|_\  \__/   \__/  |_|\_\ |_| |___| |___/
5 
6 // Copyright (C) 2021 Rookies
7 
8 // SPDX-License-Identifier: MIT
9 
10 // File contracts/utils/introspection/IERC165.sol
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC165 standard, as defined in the
16  * https://eips.ethereum.org/EIPS/eip-165[EIP].
17  *
18  * Implementers can declare support of contract interfaces, which can then be
19  * queried by others ({ERC165Checker}).
20  *
21  * For an implementation, see {ERC165}.
22  */
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 // File contracts/ERC721/IERC721.sol
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(
47         address indexed from,
48         address indexed to,
49         uint256 indexed tokenId
50     );
51 
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(
56         address indexed owner,
57         address indexed approved,
58         uint256 indexed tokenId
59     );
60 
61     /**
62      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
63      */
64     event ApprovalForAll(
65         address indexed owner,
66         address indexed operator,
67         bool approved
68     );
69 
70     /**
71      * @dev Returns the number of tokens in ``owner``'s account.
72      */
73     function balanceOf(address owner) external view returns (uint256 balance);
74 
75     /**
76      * @dev Returns the owner of the `tokenId` token.
77      *
78      * Requirements:
79      *
80      * - `tokenId` must exist.
81      */
82     function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84     /**
85      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Transfers `tokenId` token from `from` to `to`.
106      *
107      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must be owned by `from`.
114      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Returns the account approved for `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function getApproved(uint256 tokenId)
147         external
148         view
149         returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator)
169         external
170         view
171         returns (bool);
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`.
175      *
176      * Requirements:
177      *
178      * - `from` cannot be the zero address.
179      * - `to` cannot be the zero address.
180      * - `tokenId` token must exist and be owned by `from`.
181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183      *
184      * Emits a {Transfer} event.
185      */
186     function safeTransferFrom(
187         address from,
188         address to,
189         uint256 tokenId,
190         bytes calldata data
191     ) external;
192 }
193 
194 // File contracts/ERC721/IERC721Receiver.sol
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title ERC721 token receiver interface
200  * @dev Interface for any contract that wants to support safeTransfers
201  * from ERC721 asset contracts.
202  */
203 interface IERC721Receiver {
204     /**
205      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
206      * by `operator` from `from`, this function is called.
207      *
208      * It must return its Solidity selector to confirm the token transfer.
209      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
210      *
211      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
212      */
213     function onERC721Received(
214         address operator,
215         address from,
216         uint256 tokenId,
217         bytes calldata data
218     ) external returns (bytes4);
219 }
220 
221 // File contracts/ERC721/extensions/IERC721Metadata.sol
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
227  * @dev See https://eips.ethereum.org/EIPS/eip-721
228  */
229 interface IERC721Metadata is IERC721 {
230     /**
231      * @dev Returns the token collection name.
232      */
233     function name() external view returns (string memory);
234 
235     /**
236      * @dev Returns the token collection symbol.
237      */
238     function symbol() external view returns (string memory);
239 
240     /**
241      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
242      */
243     function tokenURI(uint256 tokenId) external view returns (string memory);
244 }
245 
246 // File contracts/utils/Address.sol
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize, which returns 0 for contracts in
273         // construction, since the code is only stored at the end of the
274         // constructor execution.
275 
276         uint256 size;
277         assembly {
278             size := extcodesize(account)
279         }
280         return size > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(
301             address(this).balance >= amount,
302             "Address: insufficient balance"
303         );
304 
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(
307             success,
308             "Address: unable to send value, recipient may have reverted"
309         );
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain `call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data)
331         internal
332         returns (bytes memory)
333     {
334         return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value
366     ) internal returns (bytes memory) {
367         return
368             functionCallWithValue(
369                 target,
370                 data,
371                 value,
372                 "Address: low-level call with value failed"
373             );
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(
383         address target,
384         bytes memory data,
385         uint256 value,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(
389             address(this).balance >= value,
390             "Address: insufficient balance for call"
391         );
392         require(isContract(target), "Address: call to non-contract");
393 
394         (bool success, bytes memory returndata) =
395             target.call{ value: value }(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(address target, bytes memory data)
406         internal
407         view
408         returns (bytes memory)
409     {
410         return
411             functionStaticCall(
412                 target,
413                 data,
414                 "Address: low-level static call failed"
415             );
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal view returns (bytes memory) {
429         require(isContract(target), "Address: static call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.staticcall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(address target, bytes memory data)
442         internal
443         returns (bytes memory)
444     {
445         return
446             functionDelegateCall(
447                 target,
448                 data,
449                 "Address: low-level delegate call failed"
450             );
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.4._
458      */
459     function functionDelegateCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         require(isContract(target), "Address: delegate call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.delegatecall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
472      * revert reason using the provided one.
473      *
474      * _Available since v4.3._
475      */
476     function verifyCallResult(
477         bool success,
478         bytes memory returndata,
479         string memory errorMessage
480     ) internal pure returns (bytes memory) {
481         if (success) {
482             return returndata;
483         } else {
484             // Look for revert reason and bubble it up if present
485             if (returndata.length > 0) {
486                 // The easiest way to bubble the revert reason is using memory via assembly
487 
488                 assembly {
489                     let returndata_size := mload(returndata)
490                     revert(add(32, returndata), returndata_size)
491                 }
492             } else {
493                 revert(errorMessage);
494             }
495         }
496     }
497 }
498 
499 // File contracts/utils/Context.sol
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Provides information about the current execution context, including the
505  * sender of the transaction and its data. While these are generally available
506  * via msg.sender and msg.data, they should not be accessed in such a direct
507  * manner, since when dealing with meta-transactions the account sending and
508  * paying for execution may not be the actual sender (as far as an application
509  * is concerned).
510  *
511  * This contract is only required for intermediate, library-like contracts.
512  */
513 abstract contract Context {
514     function _msgSender() internal view virtual returns (address) {
515         return msg.sender;
516     }
517 
518     function _msgData() internal view virtual returns (bytes calldata) {
519         return msg.data;
520     }
521 }
522 
523 // File contracts/utils/Strings.sol
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
535      */
536     function toString(uint256 value) internal pure returns (string memory) {
537         // Inspired by OraclizeAPI's implementation - MIT licence
538         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
539 
540         if (value == 0) {
541             return "0";
542         }
543         uint256 temp = value;
544         uint256 digits;
545         while (temp != 0) {
546             digits++;
547             temp /= 10;
548         }
549         bytes memory buffer = new bytes(digits);
550         while (value != 0) {
551             digits -= 1;
552             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
553             value /= 10;
554         }
555         return string(buffer);
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
560      */
561     function toHexString(uint256 value) internal pure returns (string memory) {
562         if (value == 0) {
563             return "0x00";
564         }
565         uint256 temp = value;
566         uint256 length = 0;
567         while (temp != 0) {
568             length++;
569             temp >>= 8;
570         }
571         return toHexString(value, length);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
576      */
577     function toHexString(uint256 value, uint256 length)
578         internal
579         pure
580         returns (string memory)
581     {
582         bytes memory buffer = new bytes(2 * length + 2);
583         buffer[0] = "0";
584         buffer[1] = "x";
585         for (uint256 i = 2 * length + 1; i > 1; --i) {
586             buffer[i] = _HEX_SYMBOLS[value & 0xf];
587             value >>= 4;
588         }
589         require(value == 0, "Strings: hex length insufficient");
590         return string(buffer);
591     }
592 }
593 
594 // File contracts/utils/introspection/ERC165.sol
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev Implementation of the {IERC165} interface.
600  *
601  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
602  * for the additional interface id that will be supported. For example:
603  *
604  * ```solidity
605  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
607  * }
608  * ```
609  *
610  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
611  */
612 abstract contract ERC165 is IERC165 {
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId)
617         public
618         view
619         virtual
620         override
621         returns (bool)
622     {
623         return interfaceId == type(IERC165).interfaceId;
624     }
625 }
626 
627 // File contracts/ERC721/ERC721.sol
628 
629 pragma solidity ^0.8.0;
630 
631 /**
632  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
633  * the Metadata extension, but not including the Enumerable extension, which is available separately as
634  * {ERC721Enumerable}.
635  */
636 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
637     using Address for address;
638     using Strings for uint256;
639 
640     // Token name
641     string private _name;
642 
643     // Token symbol
644     string private _symbol;
645 
646     // Mapping from token ID to owner address
647     mapping(uint256 => address) private _owners;
648 
649     // Mapping owner address to token count
650     mapping(address => uint256) private _balances;
651 
652     // Mapping from token ID to approved address
653     mapping(uint256 => address) private _tokenApprovals;
654 
655     // Mapping from owner to operator approvals
656     mapping(address => mapping(address => bool)) private _operatorApprovals;
657 
658     /**
659      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
660      */
661     constructor(string memory name_, string memory symbol_) {
662         _name = name_;
663         _symbol = symbol_;
664     }
665 
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      */
669     function supportsInterface(bytes4 interfaceId)
670         public
671         view
672         virtual
673         override(ERC165, IERC165)
674         returns (bool)
675     {
676         return
677             interfaceId == type(IERC721).interfaceId ||
678             interfaceId == type(IERC721Metadata).interfaceId ||
679             super.supportsInterface(interfaceId);
680     }
681 
682     /**
683      * @dev See {IERC721-balanceOf}.
684      */
685     function balanceOf(address owner)
686         public
687         view
688         virtual
689         override
690         returns (uint256)
691     {
692         require(
693             owner != address(0),
694             "ERC721: balance query for the zero address"
695         );
696         return _balances[owner];
697     }
698 
699     /**
700      * @dev See {IERC721-ownerOf}.
701      */
702     function ownerOf(uint256 tokenId)
703         public
704         view
705         virtual
706         override
707         returns (address)
708     {
709         address owner = _owners[tokenId];
710         require(
711             owner != address(0),
712             "ERC721: owner query for nonexistent token"
713         );
714         return owner;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-name}.
719      */
720     function name() public view virtual override returns (string memory) {
721         return _name;
722     }
723 
724     /**
725      * @dev See {IERC721Metadata-symbol}.
726      */
727     function symbol() public view virtual override returns (string memory) {
728         return _symbol;
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-tokenURI}.
733      */
734     function tokenURI(uint256 tokenId)
735         public
736         view
737         virtual
738         override
739         returns (string memory)
740     {
741         require(
742             _exists(tokenId),
743             "ERC721Metadata: URI query for nonexistent token"
744         );
745 
746         string memory baseURI = _baseURI();
747         return
748             bytes(baseURI).length > 0
749                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
750                 : "";
751     }
752 
753     /**
754      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
755      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
756      * by default, can be overriden in child contracts.
757      */
758     function _baseURI() internal view virtual returns (string memory) {
759         return "";
760     }
761 
762     /**
763      * @dev See {IERC721-approve}.
764      */
765     function approve(address to, uint256 tokenId) public virtual override {
766         address owner = ERC721.ownerOf(tokenId);
767         require(to != owner, "ERC721: approval to current owner");
768 
769         require(
770             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
771             "ERC721: approve caller is not owner nor approved for all"
772         );
773 
774         _approve(to, tokenId);
775     }
776 
777     /**
778      * @dev See {IERC721-getApproved}.
779      */
780     function getApproved(uint256 tokenId)
781         public
782         view
783         virtual
784         override
785         returns (address)
786     {
787         require(
788             _exists(tokenId),
789             "ERC721: approved query for nonexistent token"
790         );
791 
792         return _tokenApprovals[tokenId];
793     }
794 
795     /**
796      * @dev See {IERC721-setApprovalForAll}.
797      */
798     function setApprovalForAll(address operator, bool approved)
799         public
800         virtual
801         override
802     {
803         require(operator != _msgSender(), "ERC721: approve to caller");
804 
805         _operatorApprovals[_msgSender()][operator] = approved;
806         emit ApprovalForAll(_msgSender(), operator, approved);
807     }
808 
809     /**
810      * @dev See {IERC721-isApprovedForAll}.
811      */
812     function isApprovedForAll(address owner, address operator)
813         public
814         view
815         virtual
816         override
817         returns (bool)
818     {
819         return _operatorApprovals[owner][operator];
820     }
821 
822     /**
823      * @dev See {IERC721-transferFrom}.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public virtual override {
830         //solhint-disable-next-line max-line-length
831         require(
832             _isApprovedOrOwner(_msgSender(), tokenId),
833             "ERC721: transfer caller is not owner nor approved"
834         );
835 
836         _transfer(from, to, tokenId);
837     }
838 
839     /**
840      * @dev See {IERC721-safeTransferFrom}.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public virtual override {
847         safeTransferFrom(from, to, tokenId, "");
848     }
849 
850     /**
851      * @dev See {IERC721-safeTransferFrom}.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) public virtual override {
859         require(
860             _isApprovedOrOwner(_msgSender(), tokenId),
861             "ERC721: transfer caller is not owner nor approved"
862         );
863         _safeTransfer(from, to, tokenId, _data);
864     }
865 
866     /**
867      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
868      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
869      *
870      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
871      *
872      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
873      * implement alternative mechanisms to perform token transfer, such as signature-based.
874      *
875      * Requirements:
876      *
877      * - `from` cannot be the zero address.
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must exist and be owned by `from`.
880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _safeTransfer(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) internal virtual {
890         _transfer(from, to, tokenId);
891         require(
892             _checkOnERC721Received(from, to, tokenId, _data),
893             "ERC721: transfer to non ERC721Receiver implementer"
894         );
895     }
896 
897     /**
898      * @dev Returns whether `tokenId` exists.
899      *
900      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
901      *
902      * Tokens start existing when they are minted (`_mint`),
903      * and stop existing when they are burned (`_burn`).
904      */
905     function _exists(uint256 tokenId) internal view virtual returns (bool) {
906         return _owners[tokenId] != address(0);
907     }
908 
909     /**
910      * @dev Returns whether `spender` is allowed to manage `tokenId`.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      */
916     function _isApprovedOrOwner(address spender, uint256 tokenId)
917         internal
918         view
919         virtual
920         returns (bool)
921     {
922         require(
923             _exists(tokenId),
924             "ERC721: operator query for nonexistent token"
925         );
926         address owner = ERC721.ownerOf(tokenId);
927         return (spender == owner ||
928             getApproved(tokenId) == spender ||
929             isApprovedForAll(owner, spender));
930     }
931 
932     /**
933      * @dev Safely mints `tokenId` and transfers it to `to`.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must not exist.
938      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _safeMint(address to, uint256 tokenId) internal virtual {
943         _safeMint(to, tokenId, "");
944     }
945 
946     /**
947      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
948      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
949      */
950     function _safeMint(
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) internal virtual {
955         _mint(to, tokenId);
956         require(
957             _checkOnERC721Received(address(0), to, tokenId, _data),
958             "ERC721: transfer to non ERC721Receiver implementer"
959         );
960     }
961 
962     /**
963      * @dev Mints `tokenId` and transfers it to `to`.
964      *
965      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
966      *
967      * Requirements:
968      *
969      * - `tokenId` must not exist.
970      * - `to` cannot be the zero address.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _mint(address to, uint256 tokenId) internal virtual {
975         require(to != address(0), "ERC721: mint to the zero address");
976         require(!_exists(tokenId), "ERC721: token already minted");
977 
978         _beforeTokenTransfer(address(0), to, tokenId);
979 
980         _balances[to] += 1;
981         _owners[tokenId] = to;
982 
983         emit Transfer(address(0), to, tokenId);
984     }
985 
986     /**
987      * @dev Destroys `tokenId`.
988      * The approval is cleared when the token is burned.
989      *
990      * Requirements:
991      *
992      * - `tokenId` must exist.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _burn(uint256 tokenId) internal virtual {
997         address owner = ERC721.ownerOf(tokenId);
998 
999         _beforeTokenTransfer(owner, address(0), tokenId);
1000 
1001         // Clear approvals
1002         _approve(address(0), tokenId);
1003 
1004         _balances[owner] -= 1;
1005         delete _owners[tokenId];
1006 
1007         emit Transfer(owner, address(0), tokenId);
1008     }
1009 
1010     /**
1011      * @dev Transfers `tokenId` from `from` to `to`.
1012      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must be owned by `from`.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _transfer(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) internal virtual {
1026         require(
1027             ERC721.ownerOf(tokenId) == from,
1028             "ERC721: transfer of token that is not own"
1029         );
1030         require(to != address(0), "ERC721: transfer to the zero address");
1031 
1032         _beforeTokenTransfer(from, to, tokenId);
1033 
1034         // Clear approvals from the previous owner
1035         _approve(address(0), tokenId);
1036 
1037         _balances[from] -= 1;
1038         _balances[to] += 1;
1039         _owners[tokenId] = to;
1040 
1041         emit Transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Approve `to` to operate on `tokenId`
1046      *
1047      * Emits a {Approval} event.
1048      */
1049     function _approve(address to, uint256 tokenId) internal virtual {
1050         _tokenApprovals[tokenId] = to;
1051         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1056      * The call is not executed if the target address is not a contract.
1057      *
1058      * @param from address representing the previous owner of the given token ID
1059      * @param to target address that will receive the tokens
1060      * @param tokenId uint256 ID of the token to be transferred
1061      * @param _data bytes optional data to send along with the call
1062      * @return bool whether the call correctly returned the expected magic value
1063      */
1064     function _checkOnERC721Received(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) private returns (bool) {
1070         if (to.isContract()) {
1071             try
1072                 IERC721Receiver(to).onERC721Received(
1073                     _msgSender(),
1074                     from,
1075                     tokenId,
1076                     _data
1077                 )
1078             returns (bytes4 retval) {
1079                 return retval == IERC721Receiver.onERC721Received.selector;
1080             } catch (bytes memory reason) {
1081                 if (reason.length == 0) {
1082                     revert(
1083                         "ERC721: transfer to non ERC721Receiver implementer"
1084                     );
1085                 } else {
1086                     assembly {
1087                         revert(add(32, reason), mload(reason))
1088                     }
1089                 }
1090             }
1091         } else {
1092             return true;
1093         }
1094     }
1095 
1096     /**
1097      * @dev Hook that is called before any token transfer. This includes minting
1098      * and burning.
1099      *
1100      * Calling conditions:
1101      *
1102      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1103      * transferred to `to`.
1104      * - When `from` is zero, `tokenId` will be minted for `to`.
1105      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1106      * - `from` and `to` are never both zero.
1107      *
1108      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1109      */
1110     function _beforeTokenTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {}
1115 }
1116 
1117 // File contracts/ERC721/extensions/IERC721Enumerable.sol
1118 
1119 pragma solidity ^0.8.0;
1120 
1121 /**
1122  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1123  * @dev See https://eips.ethereum.org/EIPS/eip-721
1124  */
1125 interface IERC721Enumerable is IERC721 {
1126     /**
1127      * @dev Returns the total amount of tokens stored by the contract.
1128      */
1129     function totalSupply() external view returns (uint256);
1130 
1131     /**
1132      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1133      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1134      */
1135     function tokenOfOwnerByIndex(address owner, uint256 index)
1136         external
1137         view
1138         returns (uint256 tokenId);
1139 
1140     /**
1141      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1142      * Use along with {totalSupply} to enumerate all tokens.
1143      */
1144     function tokenByIndex(uint256 index) external view returns (uint256);
1145 }
1146 
1147 // File contracts/ERC721/extensions/ERC721Enumerable.sol
1148 
1149 pragma solidity ^0.8.0;
1150 
1151 /**
1152  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1153  * enumerability of all the token ids in the contract as well as all token ids owned by each
1154  * account.
1155  */
1156 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1157     // Mapping from owner to list of owned token IDs
1158     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1159 
1160     // Mapping from token ID to index of the owner tokens list
1161     mapping(uint256 => uint256) private _ownedTokensIndex;
1162 
1163     // Array with all token ids, used for enumeration
1164     uint256[] private _allTokens;
1165 
1166     // Mapping from token id to position in the allTokens array
1167     mapping(uint256 => uint256) private _allTokensIndex;
1168 
1169     /**
1170      * @dev See {IERC165-supportsInterface}.
1171      */
1172     function supportsInterface(bytes4 interfaceId)
1173         public
1174         view
1175         virtual
1176         override(IERC165, ERC721)
1177         returns (bool)
1178     {
1179         return
1180             interfaceId == type(IERC721Enumerable).interfaceId ||
1181             super.supportsInterface(interfaceId);
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1186      */
1187     function tokenOfOwnerByIndex(address owner, uint256 index)
1188         public
1189         view
1190         virtual
1191         override
1192         returns (uint256)
1193     {
1194         require(
1195             index < ERC721.balanceOf(owner),
1196             "ERC721Enumerable: owner index out of bounds"
1197         );
1198         return _ownedTokens[owner][index];
1199     }
1200 
1201     /**
1202      * @dev See {IERC721Enumerable-totalSupply}.
1203      */
1204     function totalSupply() public view virtual override returns (uint256) {
1205         return _allTokens.length;
1206     }
1207 
1208     /**
1209      * @dev See {IERC721Enumerable-tokenByIndex}.
1210      */
1211     function tokenByIndex(uint256 index)
1212         public
1213         view
1214         virtual
1215         override
1216         returns (uint256)
1217     {
1218         require(
1219             index < ERC721Enumerable.totalSupply(),
1220             "ERC721Enumerable: global index out of bounds"
1221         );
1222         return _allTokens[index];
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before any token transfer. This includes minting
1227      * and burning.
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` will be minted for `to`.
1234      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1235      * - `from` cannot be the zero address.
1236      * - `to` cannot be the zero address.
1237      *
1238      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1239      */
1240     function _beforeTokenTransfer(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) internal virtual override {
1245         super._beforeTokenTransfer(from, to, tokenId);
1246 
1247         if (from == address(0)) {
1248             _addTokenToAllTokensEnumeration(tokenId);
1249         } else if (from != to) {
1250             _removeTokenFromOwnerEnumeration(from, tokenId);
1251         }
1252         if (to == address(0)) {
1253             _removeTokenFromAllTokensEnumeration(tokenId);
1254         } else if (to != from) {
1255             _addTokenToOwnerEnumeration(to, tokenId);
1256         }
1257     }
1258 
1259     /**
1260      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1261      * @param to address representing the new owner of the given token ID
1262      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1263      */
1264     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1265         uint256 length = ERC721.balanceOf(to);
1266         _ownedTokens[to][length] = tokenId;
1267         _ownedTokensIndex[tokenId] = length;
1268     }
1269 
1270     /**
1271      * @dev Private function to add a token to this extension's token tracking data structures.
1272      * @param tokenId uint256 ID of the token to be added to the tokens list
1273      */
1274     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1275         _allTokensIndex[tokenId] = _allTokens.length;
1276         _allTokens.push(tokenId);
1277     }
1278 
1279     /**
1280      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1281      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1282      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1283      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1284      * @param from address representing the previous owner of the given token ID
1285      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1286      */
1287     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1288         private
1289     {
1290         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1291         // then delete the last slot (swap and pop).
1292 
1293         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1294         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1295 
1296         // When the token to delete is the last token, the swap operation is unnecessary
1297         if (tokenIndex != lastTokenIndex) {
1298             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1299 
1300             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1301             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1302         }
1303 
1304         // This also deletes the contents at the last position of the array
1305         delete _ownedTokensIndex[tokenId];
1306         delete _ownedTokens[from][lastTokenIndex];
1307     }
1308 
1309     /**
1310      * @dev Private function to remove a token from this extension's token tracking data structures.
1311      * This has O(1) time complexity, but alters the order of the _allTokens array.
1312      * @param tokenId uint256 ID of the token to be removed from the tokens list
1313      */
1314     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1315         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1316         // then delete the last slot (swap and pop).
1317 
1318         uint256 lastTokenIndex = _allTokens.length - 1;
1319         uint256 tokenIndex = _allTokensIndex[tokenId];
1320 
1321         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1322         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1323         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1324         uint256 lastTokenId = _allTokens[lastTokenIndex];
1325 
1326         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1327         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1328 
1329         // This also deletes the contents at the last position of the array
1330         delete _allTokensIndex[tokenId];
1331         _allTokens.pop();
1332     }
1333 }
1334 
1335 // File contracts/access/Ownable.sol
1336 
1337 pragma solidity ^0.8.0;
1338 
1339 /**
1340  * @dev Contract module which provides a basic access control mechanism, where
1341  * there is an account (an owner) that can be granted exclusive access to
1342  * specific functions.
1343  *
1344  * By default, the owner account will be the one that deploys the contract. This
1345  * can later be changed with {transferOwnership}.
1346  *
1347  * This module is used through inheritance. It will make available the modifier
1348  * `onlyOwner`, which can be applied to your functions to restrict their use to
1349  * the owner.
1350  */
1351 abstract contract Ownable is Context {
1352     address private _owner;
1353 
1354     event OwnershipTransferred(
1355         address indexed previousOwner,
1356         address indexed newOwner
1357     );
1358 
1359     /**
1360      * @dev Initializes the contract setting the deployer as the initial owner.
1361      */
1362     constructor() {
1363         _setOwner(_msgSender());
1364     }
1365 
1366     /**
1367      * @dev Returns the address of the current owner.
1368      */
1369     function owner() public view virtual returns (address) {
1370         return _owner;
1371     }
1372 
1373     /**
1374      * @dev Throws if called by any account other than the owner.
1375      */
1376     modifier onlyOwner() {
1377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1378         _;
1379     }
1380 
1381     /**
1382      * @dev Leaves the contract without owner. It will not be possible to call
1383      * `onlyOwner` functions anymore. Can only be called by the current owner.
1384      *
1385      * NOTE: Renouncing ownership will leave the contract without an owner,
1386      * thereby removing any functionality that is only available to the owner.
1387      */
1388     function renounceOwnership() public virtual onlyOwner {
1389         _setOwner(address(0));
1390     }
1391 
1392     /**
1393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1394      * Can only be called by the current owner.
1395      */
1396     function transferOwnership(address newOwner) public virtual onlyOwner {
1397         require(
1398             newOwner != address(0),
1399             "Ownable: new owner is the zero address"
1400         );
1401         _setOwner(newOwner);
1402     }
1403 
1404     function _setOwner(address newOwner) private {
1405         address oldOwner = _owner;
1406         _owner = newOwner;
1407         emit OwnershipTransferred(oldOwner, newOwner);
1408     }
1409 }
1410 
1411 // File contracts/Rookies.sol
1412 
1413 pragma solidity ^0.8.0;
1414 
1415 contract Rookies is ERC721Enumerable, Ownable {
1416     // Constants
1417     uint256 MAX_MINT_QUANTITY = 10;
1418     uint256 MAX_SUPPLY = 10000;
1419 
1420     // Active sale
1421     bool isActive;
1422 
1423     //URI
1424     string private _baseURIExtended;
1425 
1426     constructor() ERC721("Rookies", "rookies") {}
1427 
1428     function mint(uint256 quantity) external {
1429         require(isActive, "Minting is not active");
1430         require(quantity > 0, "Can't mint 0 tokens");
1431         require(
1432             quantity <= MAX_MINT_QUANTITY,
1433             "Can only mint 10 rookies per transaction"
1434         );
1435         require(
1436             totalSupply() + quantity <= MAX_SUPPLY,
1437             "Minting would exceed maximum supply"
1438         );
1439 
1440         for (uint256 i = 0; i < quantity; i++) {
1441             _safeMint(msg.sender, totalSupply());
1442         }
1443     }
1444 
1445     function flipMintingState() external onlyOwner {
1446         isActive = !isActive;
1447     }
1448 
1449     function _baseURI() internal view virtual override returns (string memory) {
1450         return _baseURIExtended;
1451     }
1452 
1453     function setBaseURI(string memory baseURI_) external onlyOwner {
1454         _baseURIExtended = baseURI_;
1455     }
1456 }