1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(
37         address indexed from,
38         address indexed to,
39         uint256 indexed tokenId
40     );
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(
46         address indexed owner,
47         address indexed approved,
48         uint256 indexed tokenId
49     );
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(
55         address indexed owner,
56         address indexed operator,
57         bool approved
58     );
59 
60     /**
61      * @dev Returns the number of tokens in ``owner``'s account.
62      */
63     function balanceOf(address owner) external view returns (uint256 balance);
64 
65     /**
66      * @dev Returns the owner of the `tokenId` token.
67      *
68      * Requirements:
69      *
70      * - `tokenId` must exist.
71      */
72     function ownerOf(uint256 tokenId) external view returns (address owner);
73 
74     /**
75      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
76      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must exist and be owned by `from`.
83      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
84      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
85      *
86      * Emits a {Transfer} event.
87      */
88     function safeTransferFrom(
89         address from,
90         address to,
91         uint256 tokenId
92     ) external;
93 
94     /**
95      * @dev Transfers `tokenId` token from `from` to `to`.
96      *
97      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must be owned by `from`.
104      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId)
137         external
138         view
139         returns (address operator);
140 
141     /**
142      * @dev Approve or remove `operator` as an operator for the caller.
143      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
144      *
145      * Requirements:
146      *
147      * - The `operator` cannot be the caller.
148      *
149      * Emits an {ApprovalForAll} event.
150      */
151     function setApprovalForAll(address operator, bool _approved) external;
152 
153     /**
154      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
155      *
156      * See {setApprovalForAll}
157      */
158     function isApprovedForAll(address owner, address operator)
159         external
160         view
161         returns (bool);
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId,
180         bytes calldata data
181     ) external;
182 }
183 
184 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
185 
186 /**
187  * @title ERC721 token receiver interface
188  * @dev Interface for any contract that wants to support safeTransfers
189  * from ERC721 asset contracts.
190  */
191 interface IERC721Receiver {
192     /**
193      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
194      * by `operator` from `from`, this function is called.
195      *
196      * It must return its Solidity selector to confirm the token transfer.
197      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
198      *
199      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
200      */
201     function onERC721Received(
202         address operator,
203         address from,
204         uint256 tokenId,
205         bytes calldata data
206     ) external returns (bytes4);
207 }
208 
209 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Metadata is IERC721 {
216     /**
217      * @dev Returns the token collection name.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the token collection symbol.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
228      */
229     function tokenURI(uint256 tokenId) external view returns (string memory);
230 }
231 
232 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         assembly {
262             size := extcodesize(account)
263         }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(
285             address(this).balance >= amount,
286             "Address: insufficient balance"
287         );
288 
289         (bool success, ) = recipient.call{value: amount}("");
290         require(
291             success,
292             "Address: unable to send value, recipient may have reverted"
293         );
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data)
315         internal
316         returns (bytes memory)
317     {
318         return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value
350     ) internal returns (bytes memory) {
351         return
352             functionCallWithValue(
353                 target,
354                 data,
355                 value,
356                 "Address: low-level call with value failed"
357             );
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(
373             address(this).balance >= value,
374             "Address: insufficient balance for call"
375         );
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(
379             data
380         );
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data)
391         internal
392         view
393         returns (bytes memory)
394     {
395         return
396             functionStaticCall(
397                 target,
398                 data,
399                 "Address: low-level static call failed"
400             );
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal view returns (bytes memory) {
414         require(isContract(target), "Address: static call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.staticcall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(address target, bytes memory data)
427         internal
428         returns (bytes memory)
429     {
430         return
431             functionDelegateCall(
432                 target,
433                 data,
434                 "Address: low-level delegate call failed"
435             );
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         require(isContract(target), "Address: delegate call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.delegatecall(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
457      * revert reason using the provided one.
458      *
459      * _Available since v4.3._
460      */
461     function verifyCallResult(
462         bool success,
463         bytes memory returndata,
464         string memory errorMessage
465     ) internal pure returns (bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
485 
486 /**
487  * @dev Provides information about the current execution context, including the
488  * sender of the transaction and its data. While these are generally available
489  * via msg.sender and msg.data, they should not be accessed in such a direct
490  * manner, since when dealing with meta-transactions the account sending and
491  * paying for execution may not be the actual sender (as far as an application
492  * is concerned).
493  *
494  * This contract is only required for intermediate, library-like contracts.
495  */
496 abstract contract Context {
497     function _msgSender() internal view virtual returns (address) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view virtual returns (bytes calldata) {
502         return msg.data;
503     }
504 }
505 
506 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
507 
508 /**
509  * @dev String operations.
510  */
511 library Strings {
512     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
513 
514     /**
515      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
516      */
517     function toString(uint256 value) internal pure returns (string memory) {
518         // Inspired by OraclizeAPI's implementation - MIT licence
519         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
520 
521         if (value == 0) {
522             return "0";
523         }
524         uint256 temp = value;
525         uint256 digits;
526         while (temp != 0) {
527             digits++;
528             temp /= 10;
529         }
530         bytes memory buffer = new bytes(digits);
531         while (value != 0) {
532             digits -= 1;
533             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
534             value /= 10;
535         }
536         return string(buffer);
537     }
538 
539     /**
540      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
541      */
542     function toHexString(uint256 value) internal pure returns (string memory) {
543         if (value == 0) {
544             return "0x00";
545         }
546         uint256 temp = value;
547         uint256 length = 0;
548         while (temp != 0) {
549             length++;
550             temp >>= 8;
551         }
552         return toHexString(value, length);
553     }
554 
555     /**
556      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
557      */
558     function toHexString(uint256 value, uint256 length)
559         internal
560         pure
561         returns (string memory)
562     {
563         bytes memory buffer = new bytes(2 * length + 2);
564         buffer[0] = "0";
565         buffer[1] = "x";
566         for (uint256 i = 2 * length + 1; i > 1; --i) {
567             buffer[i] = _HEX_SYMBOLS[value & 0xf];
568             value >>= 4;
569         }
570         require(value == 0, "Strings: hex length insufficient");
571         return string(buffer);
572     }
573 }
574 
575 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
576 
577 /**
578  * @dev Implementation of the {IERC165} interface.
579  *
580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
581  * for the additional interface id that will be supported. For example:
582  *
583  * ```solidity
584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
586  * }
587  * ```
588  *
589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
590  */
591 abstract contract ERC165 is IERC165 {
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId)
596         public
597         view
598         virtual
599         override
600         returns (bool)
601     {
602         return interfaceId == type(IERC165).interfaceId;
603     }
604 }
605 
606 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
607 
608 /**
609  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
610  * the Metadata extension, but not including the Enumerable extension, which is available separately as
611  * {ERC721Enumerable}.
612  */
613 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
614     using Address for address;
615     using Strings for uint256;
616 
617     // Token name
618     string private _name;
619 
620     // Token symbol
621     string private _symbol;
622 
623     // Mapping from token ID to owner address
624     mapping(uint256 => address) private _owners;
625 
626     // Mapping owner address to token count
627     mapping(address => uint256) private _balances;
628 
629     // Mapping from token ID to approved address
630     mapping(uint256 => address) private _tokenApprovals;
631 
632     // Mapping from owner to operator approvals
633     mapping(address => mapping(address => bool)) private _operatorApprovals;
634 
635     /**
636      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
637      */
638     constructor(string memory name_, string memory symbol_) {
639         _name = name_;
640         _symbol = symbol_;
641     }
642 
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId)
647         public
648         view
649         virtual
650         override(ERC165, IERC165)
651         returns (bool)
652     {
653         return
654             interfaceId == type(IERC721).interfaceId ||
655             interfaceId == type(IERC721Metadata).interfaceId ||
656             super.supportsInterface(interfaceId);
657     }
658 
659     /**
660      * @dev See {IERC721-balanceOf}.
661      */
662     function balanceOf(address owner)
663         public
664         view
665         virtual
666         override
667         returns (uint256)
668     {
669         require(
670             owner != address(0),
671             "ERC721: balance query for the zero address"
672         );
673         return _balances[owner];
674     }
675 
676     /**
677      * @dev See {IERC721-ownerOf}.
678      */
679     function ownerOf(uint256 tokenId)
680         public
681         view
682         virtual
683         override
684         returns (address)
685     {
686         address owner = _owners[tokenId];
687         require(
688             owner != address(0),
689             "ERC721: owner query for nonexistent token"
690         );
691         return owner;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-name}.
696      */
697     function name() public view virtual override returns (string memory) {
698         return _name;
699     }
700 
701     /**
702      * @dev See {IERC721Metadata-symbol}.
703      */
704     function symbol() public view virtual override returns (string memory) {
705         return _symbol;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-tokenURI}.
710      */
711     function tokenURI(uint256 tokenId)
712         public
713         view
714         virtual
715         override
716         returns (string memory)
717     {
718         require(
719             _exists(tokenId),
720             "ERC721Metadata: URI query for nonexistent token"
721         );
722 
723         string memory baseURI = _baseURI();
724         return
725             bytes(baseURI).length > 0
726                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
727                 : "";
728     }
729 
730     /**
731      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
732      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
733      * by default, can be overriden in child contracts.
734      */
735     function _baseURI() internal view virtual returns (string memory) {
736         return "";
737     }
738 
739     /**
740      * @dev See {IERC721-approve}.
741      */
742     function approve(address to, uint256 tokenId) public virtual override {
743         address owner = ERC721.ownerOf(tokenId);
744         require(to != owner, "ERC721: approval to current owner");
745 
746         require(
747             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
748             "ERC721: approve caller is not owner nor approved for all"
749         );
750 
751         _approve(to, tokenId);
752     }
753 
754     /**
755      * @dev See {IERC721-getApproved}.
756      */
757     function getApproved(uint256 tokenId)
758         public
759         view
760         virtual
761         override
762         returns (address)
763     {
764         require(
765             _exists(tokenId),
766             "ERC721: approved query for nonexistent token"
767         );
768 
769         return _tokenApprovals[tokenId];
770     }
771 
772     /**
773      * @dev See {IERC721-setApprovalForAll}.
774      */
775     function setApprovalForAll(address operator, bool approved)
776         public
777         virtual
778         override
779     {
780         require(operator != _msgSender(), "ERC721: approve to caller");
781 
782         _operatorApprovals[_msgSender()][operator] = approved;
783         emit ApprovalForAll(_msgSender(), operator, approved);
784     }
785 
786     /**
787      * @dev See {IERC721-isApprovedForAll}.
788      */
789     function isApprovedForAll(address owner, address operator)
790         public
791         view
792         virtual
793         override
794         returns (bool)
795     {
796         return _operatorApprovals[owner][operator];
797     }
798 
799     /**
800      * @dev See {IERC721-transferFrom}.
801      */
802     function transferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) public virtual override {
807         //solhint-disable-next-line max-line-length
808         require(
809             _isApprovedOrOwner(_msgSender(), tokenId),
810             "ERC721: transfer caller is not owner nor approved"
811         );
812 
813         _transfer(from, to, tokenId);
814     }
815 
816     /**
817      * @dev See {IERC721-safeTransferFrom}.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) public virtual override {
824         safeTransferFrom(from, to, tokenId, "");
825     }
826 
827     /**
828      * @dev See {IERC721-safeTransferFrom}.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) public virtual override {
836         require(
837             _isApprovedOrOwner(_msgSender(), tokenId),
838             "ERC721: transfer caller is not owner nor approved"
839         );
840         _safeTransfer(from, to, tokenId, _data);
841     }
842 
843     /**
844      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
845      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
846      *
847      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
848      *
849      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
850      * implement alternative mechanisms to perform token transfer, such as signature-based.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must exist and be owned by `from`.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _safeTransfer(
862         address from,
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) internal virtual {
867         _transfer(from, to, tokenId);
868         require(
869             _checkOnERC721Received(from, to, tokenId, _data),
870             "ERC721: transfer to non ERC721Receiver implementer"
871         );
872     }
873 
874     /**
875      * @dev Returns whether `tokenId` exists.
876      *
877      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
878      *
879      * Tokens start existing when they are minted (`_mint`),
880      * and stop existing when they are burned (`_burn`).
881      */
882     function _exists(uint256 tokenId) internal view virtual returns (bool) {
883         return _owners[tokenId] != address(0);
884     }
885 
886     /**
887      * @dev Returns whether `spender` is allowed to manage `tokenId`.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must exist.
892      */
893     function _isApprovedOrOwner(address spender, uint256 tokenId)
894         internal
895         view
896         virtual
897         returns (bool)
898     {
899         require(
900             _exists(tokenId),
901             "ERC721: operator query for nonexistent token"
902         );
903         address owner = ERC721.ownerOf(tokenId);
904         return (spender == owner ||
905             getApproved(tokenId) == spender ||
906             isApprovedForAll(owner, spender));
907     }
908 
909     /**
910      * @dev Safely mints `tokenId` and transfers it to `to`.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must not exist.
915      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeMint(address to, uint256 tokenId) internal virtual {
920         _safeMint(to, tokenId, "");
921     }
922 
923     /**
924      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
925      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
926      */
927     function _safeMint(
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) internal virtual {
932         _mint(to, tokenId);
933         require(
934             _checkOnERC721Received(address(0), to, tokenId, _data),
935             "ERC721: transfer to non ERC721Receiver implementer"
936         );
937     }
938 
939     /**
940      * @dev Mints `tokenId` and transfers it to `to`.
941      *
942      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
943      *
944      * Requirements:
945      *
946      * - `tokenId` must not exist.
947      * - `to` cannot be the zero address.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _mint(address to, uint256 tokenId) internal virtual {
952         require(to != address(0), "ERC721: mint to the zero address");
953         require(!_exists(tokenId), "ERC721: token already minted");
954 
955         _beforeTokenTransfer(address(0), to, tokenId);
956 
957         _balances[to] += 1;
958         _owners[tokenId] = to;
959 
960         emit Transfer(address(0), to, tokenId);
961     }
962 
963     /**
964      * @dev Destroys `tokenId`.
965      * The approval is cleared when the token is burned.
966      *
967      * Requirements:
968      *
969      * - `tokenId` must exist.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _burn(uint256 tokenId) internal virtual {
974         address owner = ERC721.ownerOf(tokenId);
975 
976         _beforeTokenTransfer(owner, address(0), tokenId);
977 
978         // Clear approvals
979         _approve(address(0), tokenId);
980 
981         _balances[owner] -= 1;
982         delete _owners[tokenId];
983 
984         emit Transfer(owner, address(0), tokenId);
985     }
986 
987     /**
988      * @dev Transfers `tokenId` from `from` to `to`.
989      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
990      *
991      * Requirements:
992      *
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must be owned by `from`.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _transfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) internal virtual {
1003         require(
1004             ERC721.ownerOf(tokenId) == from,
1005             "ERC721: transfer of token that is not own"
1006         );
1007         require(to != address(0), "ERC721: transfer to the zero address");
1008 
1009         _beforeTokenTransfer(from, to, tokenId);
1010 
1011         // Clear approvals from the previous owner
1012         _approve(address(0), tokenId);
1013 
1014         _balances[from] -= 1;
1015         _balances[to] += 1;
1016         _owners[tokenId] = to;
1017 
1018         emit Transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Approve `to` to operate on `tokenId`
1023      *
1024      * Emits a {Approval} event.
1025      */
1026     function _approve(address to, uint256 tokenId) internal virtual {
1027         _tokenApprovals[tokenId] = to;
1028         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1033      * The call is not executed if the target address is not a contract.
1034      *
1035      * @param from address representing the previous owner of the given token ID
1036      * @param to target address that will receive the tokens
1037      * @param tokenId uint256 ID of the token to be transferred
1038      * @param _data bytes optional data to send along with the call
1039      * @return bool whether the call correctly returned the expected magic value
1040      */
1041     function _checkOnERC721Received(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) private returns (bool) {
1047         if (to.isContract()) {
1048             try
1049                 IERC721Receiver(to).onERC721Received(
1050                     _msgSender(),
1051                     from,
1052                     tokenId,
1053                     _data
1054                 )
1055             returns (bytes4 retval) {
1056                 return retval == IERC721Receiver.onERC721Received.selector;
1057             } catch (bytes memory reason) {
1058                 if (reason.length == 0) {
1059                     revert(
1060                         "ERC721: transfer to non ERC721Receiver implementer"
1061                     );
1062                 } else {
1063                     assembly {
1064                         revert(add(32, reason), mload(reason))
1065                     }
1066                 }
1067             }
1068         } else {
1069             return true;
1070         }
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before any token transfer. This includes minting
1075      * and burning.
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` will be minted for `to`.
1082      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1083      * - `from` and `to` are never both zero.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual {}
1092 }
1093 
1094 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1095 
1096 /**
1097  * @dev Contract module which provides a basic access control mechanism, where
1098  * there is an account (an owner) that can be granted exclusive access to
1099  * specific functions.
1100  *
1101  * By default, the owner account will be the one that deploys the contract. This
1102  * can later be changed with {transferOwnership}.
1103  *
1104  * This module is used through inheritance. It will make available the modifier
1105  * `onlyOwner`, which can be applied to your functions to restrict their use to
1106  * the owner.
1107  */
1108 abstract contract Ownable is Context {
1109     address private _owner;
1110 
1111     event OwnershipTransferred(
1112         address indexed previousOwner,
1113         address indexed newOwner
1114     );
1115 
1116     /**
1117      * @dev Initializes the contract setting the deployer as the initial owner.
1118      */
1119     constructor() {
1120         _setOwner(_msgSender());
1121     }
1122 
1123     /**
1124      * @dev Returns the address of the current owner.
1125      */
1126     function owner() public view virtual returns (address) {
1127         return _owner;
1128     }
1129 
1130     /**
1131      * @dev Throws if called by any account other than the owner.
1132      */
1133     modifier onlyOwner() {
1134         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1135         _;
1136     }
1137 
1138     /**
1139      * @dev Leaves the contract without owner. It will not be possible to call
1140      * `onlyOwner` functions anymore. Can only be called by the current owner.
1141      *
1142      * NOTE: Renouncing ownership will leave the contract without an owner,
1143      * thereby removing any functionality that is only available to the owner.
1144      */
1145     function renounceOwnership() public virtual onlyOwner {
1146         _setOwner(address(0));
1147     }
1148 
1149     /**
1150      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1151      * Can only be called by the current owner.
1152      */
1153     function transferOwnership(address newOwner) public virtual onlyOwner {
1154         require(
1155             newOwner != address(0),
1156             "Ownable: new owner is the zero address"
1157         );
1158         _setOwner(newOwner);
1159     }
1160 
1161     function _setOwner(address newOwner) private {
1162         address oldOwner = _owner;
1163         _owner = newOwner;
1164         emit OwnershipTransferred(oldOwner, newOwner);
1165     }
1166 }
1167 
1168 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
1169 
1170 /**
1171  * @dev Contract module that helps prevent reentrant calls to a function.
1172  *
1173  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1174  * available, which can be applied to functions to make sure there are no nested
1175  * (reentrant) calls to them.
1176  *
1177  * Note that because there is a single `nonReentrant` guard, functions marked as
1178  * `nonReentrant` may not call one another. This can be worked around by making
1179  * those functions `private`, and then adding `external` `nonReentrant` entry
1180  * points to them.
1181  *
1182  * TIP: If you would like to learn more about reentrancy and alternative ways
1183  * to protect against it, check out our blog post
1184  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1185  */
1186 abstract contract ReentrancyGuard {
1187     // Booleans are more expensive than uint256 or any type that takes up a full
1188     // word because each write operation emits an extra SLOAD to first read the
1189     // slot's contents, replace the bits taken up by the boolean, and then write
1190     // back. This is the compiler's defense against contract upgrades and
1191     // pointer aliasing, and it cannot be disabled.
1192 
1193     // The values being non-zero value makes deployment a bit more expensive,
1194     // but in exchange the refund on every call to nonReentrant will be lower in
1195     // amount. Since refunds are capped to a percentage of the total
1196     // transaction's gas, it is best to keep them low in cases like this one, to
1197     // increase the likelihood of the full refund coming into effect.
1198     uint256 private constant _NOT_ENTERED = 1;
1199     uint256 private constant _ENTERED = 2;
1200 
1201     uint256 private _status;
1202 
1203     constructor() {
1204         _status = _NOT_ENTERED;
1205     }
1206 
1207     /**
1208      * @dev Prevents a contract from calling itself, directly or indirectly.
1209      * Calling a `nonReentrant` function from another `nonReentrant`
1210      * function is not supported. It is possible to prevent this from happening
1211      * by making the `nonReentrant` function external, and make it call a
1212      * `private` function that does the actual work.
1213      */
1214     modifier nonReentrant() {
1215         // On the first call to nonReentrant, _notEntered will be true
1216         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1217 
1218         // Any calls to nonReentrant after this point will fail
1219         _status = _ENTERED;
1220 
1221         _;
1222 
1223         // By storing the original value once again, a refund is triggered (see
1224         // https://eips.ethereum.org/EIPS/eip-2200)
1225         _status = _NOT_ENTERED;
1226     }
1227 }
1228 
1229 
1230 
1231 
1232 contract DoodPunks is ERC721, Ownable, ReentrancyGuard {
1233     using Strings for uint256;
1234 
1235     string public baseURI;
1236     string public baseExtension = ".json";
1237     uint256 public PRICE = 0.024 ether;
1238     uint256 public MAX_SUPPLY = 6666;
1239     uint256 public constant OWNER_AMOUNT = 20;
1240     uint256 public minted;
1241 
1242     constructor(
1243         string memory name_,
1244         string memory symbol_,
1245         string memory baseURI_
1246     ) ERC721(name_, symbol_) {
1247         baseURI = baseURI_;
1248         for (uint256 i = 0; i < OWNER_AMOUNT; i++) {
1249             _safeMint(msg.sender, ++minted);
1250         }
1251     }
1252 
1253     function PRICEupdate(uint _minted) internal view returns (uint _PRICE){
1254         if(_minted < 1000){
1255             return 0 ether;
1256         }   
1257         if(_minted <= MAX_SUPPLY){
1258             return PRICE;
1259         }   
1260     }
1261 
1262     function mint(uint8 amount) public payable nonReentrant {
1263         require(amount > 0, "Amount must be more than 0");
1264         require(amount <= 20, "Amount must be 20 or less");
1265         require(minted + amount <= MAX_SUPPLY, "Sold out");
1266         require(msg.value >= PRICEupdate(minted) * amount, "Ether value sent is not correct");
1267         
1268 
1269         for (uint256 i = 0; i < amount; i++) {
1270             _safeMint(msg.sender, ++minted);
1271         }
1272     }
1273     function tokenURI(uint256 tokenId)
1274         public
1275         view
1276         virtual
1277         override
1278         returns (string memory)
1279     {
1280         require(
1281             _exists(tokenId),
1282             "ERC721Metadata: URI query for nonexistent token"
1283         );
1284 
1285         string memory currentBaseURI = _baseURI();
1286         return bytes(currentBaseURI).length > 0
1287             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1288             : "";
1289     }
1290 
1291 
1292 	function setPRICE(uint256 _newPRICE) public onlyOwner {
1293 	    PRICE = _newPRICE;
1294 	}
1295 
1296 	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1297 	    MAX_SUPPLY = _newMaxSupply;
1298     }
1299 
1300     function setBaseURI(string memory baseURI_) public onlyOwner {
1301         baseURI = baseURI_;
1302     }
1303 
1304     function _baseURI() internal view virtual override returns (string memory) {
1305         return baseURI;
1306     }
1307 
1308     function withdraw(address payable recipient) public onlyOwner {
1309         require(address(this).balance > 0, "No contract balance");
1310         recipient.transfer(address(this).balance);
1311     }
1312 }