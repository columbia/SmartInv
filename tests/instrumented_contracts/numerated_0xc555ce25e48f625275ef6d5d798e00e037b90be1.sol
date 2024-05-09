1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
5 
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(
38         address indexed from,
39         address indexed to,
40         uint256 indexed tokenId
41     );
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(
47         address indexed owner,
48         address indexed approved,
49         uint256 indexed tokenId
50     );
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(
56         address indexed owner,
57         address indexed operator,
58         bool approved
59     );
60 
61     /**
62      * @dev Returns the number of tokens in ``owner``'s account.
63      */
64     function balanceOf(address owner) external view returns (uint256 balance);
65 
66     /**
67      * @dev Returns the owner of the `tokenId` token.
68      *
69      * Requirements:
70      *
71      * - `tokenId` must exist.
72      */
73     function ownerOf(uint256 tokenId) external view returns (address owner);
74 
75     /**
76      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
77      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
78      *
79      * Requirements:
80      *
81      * - `from` cannot be the zero address.
82      * - `to` cannot be the zero address.
83      * - `tokenId` token must exist and be owned by `from`.
84      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
85      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
86      *
87      * Emits a {Transfer} event.
88      */
89     function safeTransferFrom(
90         address from,
91         address to,
92         uint256 tokenId
93     ) external;
94 
95     /**
96      * @dev Transfers `tokenId` token from `from` to `to`.
97      *
98      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must be owned by `from`.
105      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     /**
116      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
117      * The approval is cleared when the token is transferred.
118      *
119      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
120      *
121      * Requirements:
122      *
123      * - The caller must own the token or be an approved operator.
124      * - `tokenId` must exist.
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Returns the account approved for `tokenId` token.
132      *
133      * Requirements:
134      *
135      * - `tokenId` must exist.
136      */
137     function getApproved(uint256 tokenId)
138         external
139         view
140         returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator)
160         external
161         view
162         returns (bool);
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external;
183 }
184 
185 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
186 
187 /**
188  * @title ERC721 token receiver interface
189  * @dev Interface for any contract that wants to support safeTransfers
190  * from ERC721 asset contracts.
191  */
192 interface IERC721Receiver {
193     /**
194      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
195      * by `operator` from `from`, this function is called.
196      *
197      * It must return its Solidity selector to confirm the token transfer.
198      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
199      *
200      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
201      */
202     function onERC721Received(
203         address operator,
204         address from,
205         uint256 tokenId,
206         bytes calldata data
207     ) external returns (bytes4);
208 }
209 
210 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 // File: @openzeppelin/contracts/utils/Address.sol
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies on extcodesize, which returns 0 for contracts in
258         // construction, since the code is only stored at the end of the
259         // constructor execution.
260 
261         uint256 size;
262         assembly {
263             size := extcodesize(account)
264         }
265         return size > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(
286             address(this).balance >= amount,
287             "Address: insufficient balance"
288         );
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(
292             success,
293             "Address: unable to send value, recipient may have reverted"
294         );
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain `call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data)
316         internal
317         returns (bytes memory)
318     {
319         return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value
351     ) internal returns (bytes memory) {
352         return
353             functionCallWithValue(
354                 target,
355                 data,
356                 value,
357                 "Address: low-level call with value failed"
358             );
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(
374             address(this).balance >= value,
375             "Address: insufficient balance for call"
376         );
377         require(isContract(target), "Address: call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.call{value: value}(
380             data
381         );
382         return _verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(address target, bytes memory data)
392         internal
393         view
394         returns (bytes memory)
395     {
396         return
397             functionStaticCall(
398                 target,
399                 data,
400                 "Address: low-level static call failed"
401             );
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal view returns (bytes memory) {
415         require(isContract(target), "Address: static call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.staticcall(data);
418         return _verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(address target, bytes memory data)
428         internal
429         returns (bytes memory)
430     {
431         return
432             functionDelegateCall(
433                 target,
434                 data,
435                 "Address: low-level delegate call failed"
436             );
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(isContract(target), "Address: delegate call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.delegatecall(data);
453         return _verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     function _verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) private pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/utils/Context.sol
480 
481 pragma solidity ^0.8.0;
482 
483 /*
484  * @dev Provides information about the current execution context, including the
485  * sender of the transaction and its data. While these are generally available
486  * via msg.sender and msg.data, they should not be accessed in such a direct
487  * manner, since when dealing with meta-transactions the account sending and
488  * paying for execution may not be the actual sender (as far as an application
489  * is concerned).
490  *
491  * This contract is only required for intermediate, library-like contracts.
492  */
493 abstract contract Context {
494     function _msgSender() internal view virtual returns (address) {
495         return msg.sender;
496     }
497 
498     function _msgData() internal view virtual returns (bytes calldata) {
499         return msg.data;
500     }
501 }
502 
503 // File: @openzeppelin/contracts/utils/Strings.sol
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev String operations.
509  */
510 library Strings {
511     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
512 
513     /**
514      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
515      */
516     function toString(uint256 value) internal pure returns (string memory) {
517         // Inspired by OraclizeAPI's implementation - MIT licence
518         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
519 
520         if (value == 0) {
521             return "0";
522         }
523         uint256 temp = value;
524         uint256 digits;
525         while (temp != 0) {
526             digits++;
527             temp /= 10;
528         }
529         bytes memory buffer = new bytes(digits);
530         while (value != 0) {
531             digits -= 1;
532             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
533             value /= 10;
534         }
535         return string(buffer);
536     }
537 
538     /**
539      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
540      */
541     function toHexString(uint256 value) internal pure returns (string memory) {
542         if (value == 0) {
543             return "0x00";
544         }
545         uint256 temp = value;
546         uint256 length = 0;
547         while (temp != 0) {
548             length++;
549             temp >>= 8;
550         }
551         return toHexString(value, length);
552     }
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
556      */
557     function toHexString(uint256 value, uint256 length)
558         internal
559         pure
560         returns (string memory)
561     {
562         bytes memory buffer = new bytes(2 * length + 2);
563         buffer[0] = "0";
564         buffer[1] = "x";
565         for (uint256 i = 2 * length + 1; i > 1; --i) {
566             buffer[i] = _HEX_SYMBOLS[value & 0xf];
567             value >>= 4;
568         }
569         require(value == 0, "Strings: hex length insufficient");
570         return string(buffer);
571     }
572 }
573 
574 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
575 
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @dev Implementation of the {IERC165} interface.
580  *
581  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
582  * for the additional interface id that will be supported. For example:
583  *
584  * ```solidity
585  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
586  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
587  * }
588  * ```
589  *
590  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
591  */
592 abstract contract ERC165 is IERC165 {
593     /**
594      * @dev See {IERC165-supportsInterface}.
595      */
596     function supportsInterface(bytes4 interfaceId)
597         public
598         view
599         virtual
600         override
601         returns (bool)
602     {
603         return interfaceId == type(IERC165).interfaceId;
604     }
605 }
606 
607 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
613  * the Metadata extension, but not including the Enumerable extension, which is available separately as
614  * {ERC721Enumerable}.
615  */
616 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
617     using Address for address;
618     using Strings for uint256;
619 
620     // Token name
621     string private _name;
622 
623     // Token symbol
624     string private _symbol;
625 
626     // Mapping from token ID to owner address
627     mapping(uint256 => address) private _owners;
628 
629     // Mapping owner address to token count
630     mapping(address => uint256) private _balances;
631 
632     // Mapping from token ID to approved address
633     mapping(uint256 => address) private _tokenApprovals;
634 
635     // Mapping from owner to operator approvals
636     mapping(address => mapping(address => bool)) private _operatorApprovals;
637 
638     /**
639      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
640      */
641     constructor(string memory name_, string memory symbol_) {
642         _name = name_;
643         _symbol = symbol_;
644     }
645 
646     /**
647      * @dev See {IERC165-supportsInterface}.
648      */
649     function supportsInterface(bytes4 interfaceId)
650         public
651         view
652         virtual
653         override(ERC165, IERC165)
654         returns (bool)
655     {
656         return
657             interfaceId == type(IERC721).interfaceId ||
658             interfaceId == type(IERC721Metadata).interfaceId ||
659             super.supportsInterface(interfaceId);
660     }
661 
662     /**
663      * @dev See {IERC721-balanceOf}.
664      */
665     function balanceOf(address owner)
666         public
667         view
668         virtual
669         override
670         returns (uint256)
671     {
672         require(
673             owner != address(0),
674             "ERC721: balance query for the zero address"
675         );
676         return _balances[owner];
677     }
678 
679     /**
680      * @dev See {IERC721-ownerOf}.
681      */
682     function ownerOf(uint256 tokenId)
683         public
684         view
685         virtual
686         override
687         returns (address)
688     {
689         address owner = _owners[tokenId];
690         require(
691             owner != address(0),
692             "ERC721: owner query for nonexistent token"
693         );
694         return owner;
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-name}.
699      */
700     function name() public view virtual override returns (string memory) {
701         return _name;
702     }
703 
704     /**
705      * @dev See {IERC721Metadata-symbol}.
706      */
707     function symbol() public view virtual override returns (string memory) {
708         return _symbol;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-tokenURI}.
713      */
714     function tokenURI(uint256 tokenId)
715         public
716         view
717         virtual
718         override
719         returns (string memory)
720     {
721         require(
722             _exists(tokenId),
723             "ERC721Metadata: URI query for nonexistent token"
724         );
725 
726         string memory baseURI = _baseURI();
727         return
728             bytes(baseURI).length > 0
729                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
730                 : "";
731     }
732 
733     /**
734      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
735      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
736      * by default, can be overriden in child contracts.
737      */
738     function _baseURI() internal view virtual returns (string memory) {
739         return "";
740     }
741 
742     /**
743      * @dev See {IERC721-approve}.
744      */
745     function approve(address to, uint256 tokenId) public virtual override {
746         address owner = ERC721.ownerOf(tokenId);
747         require(to != owner, "ERC721: approval to current owner");
748 
749         require(
750             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
751             "ERC721: approve caller is not owner nor approved for all"
752         );
753 
754         _approve(to, tokenId);
755     }
756 
757     /**
758      * @dev See {IERC721-getApproved}.
759      */
760     function getApproved(uint256 tokenId)
761         public
762         view
763         virtual
764         override
765         returns (address)
766     {
767         require(
768             _exists(tokenId),
769             "ERC721: approved query for nonexistent token"
770         );
771 
772         return _tokenApprovals[tokenId];
773     }
774 
775     /**
776      * @dev See {IERC721-setApprovalForAll}.
777      */
778     function setApprovalForAll(address operator, bool approved)
779         public
780         virtual
781         override
782     {
783         require(operator != _msgSender(), "ERC721: approve to caller");
784 
785         _operatorApprovals[_msgSender()][operator] = approved;
786         emit ApprovalForAll(_msgSender(), operator, approved);
787     }
788 
789     /**
790      * @dev See {IERC721-isApprovedForAll}.
791      */
792     function isApprovedForAll(address owner, address operator)
793         public
794         view
795         virtual
796         override
797         returns (bool)
798     {
799         return _operatorApprovals[owner][operator];
800     }
801 
802     /**
803      * @dev See {IERC721-transferFrom}.
804      */
805     function transferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) public virtual override {
810         //solhint-disable-next-line max-line-length
811         require(
812             _isApprovedOrOwner(_msgSender(), tokenId),
813             "ERC721: transfer caller is not owner nor approved"
814         );
815 
816         _transfer(from, to, tokenId);
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) public virtual override {
827         safeTransferFrom(from, to, tokenId, "");
828     }
829 
830     /**
831      * @dev See {IERC721-safeTransferFrom}.
832      */
833     function safeTransferFrom(
834         address from,
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) public virtual override {
839         require(
840             _isApprovedOrOwner(_msgSender(), tokenId),
841             "ERC721: transfer caller is not owner nor approved"
842         );
843         _safeTransfer(from, to, tokenId, _data);
844     }
845 
846     /**
847      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
848      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
849      *
850      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
851      *
852      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
853      * implement alternative mechanisms to perform token transfer, such as signature-based.
854      *
855      * Requirements:
856      *
857      * - `from` cannot be the zero address.
858      * - `to` cannot be the zero address.
859      * - `tokenId` token must exist and be owned by `from`.
860      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _safeTransfer(
865         address from,
866         address to,
867         uint256 tokenId,
868         bytes memory _data
869     ) internal virtual {
870         _transfer(from, to, tokenId);
871         require(
872             _checkOnERC721Received(from, to, tokenId, _data),
873             "ERC721: transfer to non ERC721Receiver implementer"
874         );
875     }
876 
877     /**
878      * @dev Returns whether `tokenId` exists.
879      *
880      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
881      *
882      * Tokens start existing when they are minted (`_mint`),
883      * and stop existing when they are burned (`_burn`).
884      */
885     function _exists(uint256 tokenId) internal view virtual returns (bool) {
886         return _owners[tokenId] != address(0);
887     }
888 
889     /**
890      * @dev Returns whether `spender` is allowed to manage `tokenId`.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must exist.
895      */
896     function _isApprovedOrOwner(address spender, uint256 tokenId)
897         internal
898         view
899         virtual
900         returns (bool)
901     {
902         require(
903             _exists(tokenId),
904             "ERC721: operator query for nonexistent token"
905         );
906         address owner = ERC721.ownerOf(tokenId);
907         return (spender == owner ||
908             getApproved(tokenId) == spender ||
909             isApprovedForAll(owner, spender));
910     }
911 
912     /**
913      * @dev Safely mints `tokenId` and transfers it to `to`.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must not exist.
918      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _safeMint(address to, uint256 tokenId) internal virtual {
923         _safeMint(to, tokenId, "");
924     }
925 
926     /**
927      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
928      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
929      */
930     function _safeMint(
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) internal virtual {
935         _mint(to, tokenId);
936         require(
937             _checkOnERC721Received(address(0), to, tokenId, _data),
938             "ERC721: transfer to non ERC721Receiver implementer"
939         );
940     }
941 
942     /**
943      * @dev Mints `tokenId` and transfers it to `to`.
944      *
945      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
946      *
947      * Requirements:
948      *
949      * - `tokenId` must not exist.
950      * - `to` cannot be the zero address.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _mint(address to, uint256 tokenId) internal virtual {
955         require(to != address(0), "ERC721: mint to the zero address");
956         require(!_exists(tokenId), "ERC721: token already minted");
957 
958         _beforeTokenTransfer(address(0), to, tokenId);
959 
960         _balances[to] += 1;
961         _owners[tokenId] = to;
962 
963         emit Transfer(address(0), to, tokenId);
964     }
965 
966     /**
967      * @dev Destroys `tokenId`.
968      * The approval is cleared when the token is burned.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _burn(uint256 tokenId) internal virtual {
977         address owner = ERC721.ownerOf(tokenId);
978 
979         _beforeTokenTransfer(owner, address(0), tokenId);
980 
981         // Clear approvals
982         _approve(address(0), tokenId);
983 
984         _balances[owner] -= 1;
985         delete _owners[tokenId];
986 
987         emit Transfer(owner, address(0), tokenId);
988     }
989 
990     /**
991      * @dev Transfers `tokenId` from `from` to `to`.
992      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
993      *
994      * Requirements:
995      *
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must be owned by `from`.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _transfer(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) internal virtual {
1006         require(
1007             ERC721.ownerOf(tokenId) == from,
1008             "ERC721: transfer of token that is not own"
1009         );
1010         require(to != address(0), "ERC721: transfer to the zero address");
1011 
1012         _beforeTokenTransfer(from, to, tokenId);
1013 
1014         // Clear approvals from the previous owner
1015         _approve(address(0), tokenId);
1016 
1017         _balances[from] -= 1;
1018         _balances[to] += 1;
1019         _owners[tokenId] = to;
1020 
1021         emit Transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Approve `to` to operate on `tokenId`
1026      *
1027      * Emits a {Approval} event.
1028      */
1029     function _approve(address to, uint256 tokenId) internal virtual {
1030         _tokenApprovals[tokenId] = to;
1031         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1036      * The call is not executed if the target address is not a contract.
1037      *
1038      * @param from address representing the previous owner of the given token ID
1039      * @param to target address that will receive the tokens
1040      * @param tokenId uint256 ID of the token to be transferred
1041      * @param _data bytes optional data to send along with the call
1042      * @return bool whether the call correctly returned the expected magic value
1043      */
1044     function _checkOnERC721Received(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) private returns (bool) {
1050         if (to.isContract()) {
1051             try
1052                 IERC721Receiver(to).onERC721Received(
1053                     _msgSender(),
1054                     from,
1055                     tokenId,
1056                     _data
1057                 )
1058             returns (bytes4 retval) {
1059                 return retval == IERC721Receiver(to).onERC721Received.selector;
1060             } catch (bytes memory reason) {
1061                 if (reason.length == 0) {
1062                     revert(
1063                         "ERC721: transfer to non ERC721Receiver implementer"
1064                     );
1065                 } else {
1066                     assembly {
1067                         revert(add(32, reason), mload(reason))
1068                     }
1069                 }
1070             }
1071         } else {
1072             return true;
1073         }
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before any token transfer. This includes minting
1078      * and burning.
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1086      * - `from` and `to` are never both zero.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) internal virtual {}
1095 }
1096 
1097 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1098 
1099 pragma solidity ^0.8.0;
1100 
1101 /**
1102  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1103  * @dev See https://eips.ethereum.org/EIPS/eip-721
1104  */
1105 interface IERC721Enumerable is IERC721 {
1106     /**
1107      * @dev Returns the total amount of tokens stored by the contract.
1108      */
1109     function totalSupply() external view returns (uint256);
1110 
1111     /**
1112      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1113      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1114      */
1115     function tokenOfOwnerByIndex(address owner, uint256 index)
1116         external
1117         view
1118         returns (uint256 tokenId);
1119 
1120     /**
1121      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1122      * Use along with {totalSupply} to enumerate all tokens.
1123      */
1124     function tokenByIndex(uint256 index) external view returns (uint256);
1125 }
1126 
1127 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1128 
1129 pragma solidity ^0.8.0;
1130 
1131 /**
1132  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1133  * enumerability of all the token ids in the contract as well as all token ids owned by each
1134  * account.
1135  */
1136 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1137     // Mapping from owner to list of owned token IDs
1138     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1139 
1140     // Mapping from token ID to index of the owner tokens list
1141     mapping(uint256 => uint256) private _ownedTokensIndex;
1142 
1143     // Array with all token ids, used for enumeration
1144     uint256[] private _allTokens;
1145 
1146     // Mapping from token id to position in the allTokens array
1147     mapping(uint256 => uint256) private _allTokensIndex;
1148 
1149     /**
1150      * @dev See {IERC165-supportsInterface}.
1151      */
1152     function supportsInterface(bytes4 interfaceId)
1153         public
1154         view
1155         virtual
1156         override(IERC165, ERC721)
1157         returns (bool)
1158     {
1159         return
1160             interfaceId == type(IERC721Enumerable).interfaceId ||
1161             super.supportsInterface(interfaceId);
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1166      */
1167     function tokenOfOwnerByIndex(address owner, uint256 index)
1168         public
1169         view
1170         virtual
1171         override
1172         returns (uint256)
1173     {
1174         require(
1175             index < ERC721.balanceOf(owner),
1176             "ERC721Enumerable: owner index out of bounds"
1177         );
1178         return _ownedTokens[owner][index];
1179     }
1180 
1181     /**
1182      * @dev See {IERC721Enumerable-totalSupply}.
1183      */
1184     function totalSupply() public view virtual override returns (uint256) {
1185         return _allTokens.length;
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Enumerable-tokenByIndex}.
1190      */
1191     function tokenByIndex(uint256 index)
1192         public
1193         view
1194         virtual
1195         override
1196         returns (uint256)
1197     {
1198         require(
1199             index < ERC721Enumerable.totalSupply(),
1200             "ERC721Enumerable: global index out of bounds"
1201         );
1202         return _allTokens[index];
1203     }
1204 
1205     /**
1206      * @dev Hook that is called before any token transfer. This includes minting
1207      * and burning.
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` will be minted for `to`.
1214      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1215      * - `from` cannot be the zero address.
1216      * - `to` cannot be the zero address.
1217      *
1218      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1219      */
1220     function _beforeTokenTransfer(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) internal virtual override {
1225         super._beforeTokenTransfer(from, to, tokenId);
1226 
1227         if (from == address(0)) {
1228             _addTokenToAllTokensEnumeration(tokenId);
1229         } else if (from != to) {
1230             _removeTokenFromOwnerEnumeration(from, tokenId);
1231         }
1232         if (to == address(0)) {
1233             _removeTokenFromAllTokensEnumeration(tokenId);
1234         } else if (to != from) {
1235             _addTokenToOwnerEnumeration(to, tokenId);
1236         }
1237     }
1238 
1239     /**
1240      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1241      * @param to address representing the new owner of the given token ID
1242      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1243      */
1244     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1245         uint256 length = ERC721.balanceOf(to);
1246         _ownedTokens[to][length] = tokenId;
1247         _ownedTokensIndex[tokenId] = length;
1248     }
1249 
1250     /**
1251      * @dev Private function to add a token to this extension's token tracking data structures.
1252      * @param tokenId uint256 ID of the token to be added to the tokens list
1253      */
1254     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1255         _allTokensIndex[tokenId] = _allTokens.length;
1256         _allTokens.push(tokenId);
1257     }
1258 
1259     /**
1260      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1261      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1262      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1263      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1264      * @param from address representing the previous owner of the given token ID
1265      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1266      */
1267     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1268         private
1269     {
1270         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1271         // then delete the last slot (swap and pop).
1272 
1273         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1274         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1275 
1276         // When the token to delete is the last token, the swap operation is unnecessary
1277         if (tokenIndex != lastTokenIndex) {
1278             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1279 
1280             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1281             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1282         }
1283 
1284         // This also deletes the contents at the last position of the array
1285         delete _ownedTokensIndex[tokenId];
1286         delete _ownedTokens[from][lastTokenIndex];
1287     }
1288 
1289     /**
1290      * @dev Private function to remove a token from this extension's token tracking data structures.
1291      * This has O(1) time complexity, but alters the order of the _allTokens array.
1292      * @param tokenId uint256 ID of the token to be removed from the tokens list
1293      */
1294     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1295         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1296         // then delete the last slot (swap and pop).
1297 
1298         uint256 lastTokenIndex = _allTokens.length - 1;
1299         uint256 tokenIndex = _allTokensIndex[tokenId];
1300 
1301         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1302         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1303         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1304         uint256 lastTokenId = _allTokens[lastTokenIndex];
1305 
1306         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1307         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1308 
1309         // This also deletes the contents at the last position of the array
1310         delete _allTokensIndex[tokenId];
1311         _allTokens.pop();
1312     }
1313 }
1314 
1315 // File: @openzeppelin/contracts/access/Ownable.sol
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 /**
1320  * @dev Contract module which provides a basic access control mechanism, where
1321  * there is an account (an owner) that can be granted exclusive access to
1322  * specific functions.
1323  *
1324  * By default, the owner account will be the one that deploys the contract. This
1325  * can later be changed with {transferOwnership}.
1326  *
1327  * This module is used through inheritance. It will make available the modifier
1328  * `onlyOwner`, which can be applied to your functions to restrict their use to
1329  * the owner.
1330  */
1331 abstract contract Ownable is Context {
1332     address private _owner;
1333 
1334     event OwnershipTransferred(
1335         address indexed previousOwner,
1336         address indexed newOwner
1337     );
1338 
1339     /**
1340      * @dev Initializes the contract setting the deployer as the initial owner.
1341      */
1342     constructor() {
1343         _setOwner(_msgSender());
1344     }
1345 
1346     /**
1347      * @dev Returns the address of the current owner.
1348      */
1349     function owner() public view virtual returns (address) {
1350         return _owner;
1351     }
1352 
1353     /**
1354      * @dev Throws if called by any account other than the owner.
1355      */
1356     modifier onlyOwner() {
1357         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1358         _;
1359     }
1360 
1361     /**
1362      * @dev Leaves the contract without owner. It will not be possible to call
1363      * `onlyOwner` functions anymore. Can only be called by the current owner.
1364      *
1365      * NOTE: Renouncing ownership will leave the contract without an owner,
1366      * thereby removing any functionality that is only available to the owner.
1367      */
1368     function renounceOwnership() public virtual onlyOwner {
1369         _setOwner(address(0));
1370     }
1371 
1372     /**
1373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1374      * Can only be called by the current owner.
1375      */
1376     function transferOwnership(address newOwner) public virtual onlyOwner {
1377         require(
1378             newOwner != address(0),
1379             "Ownable: new owner is the zero address"
1380         );
1381         _setOwner(newOwner);
1382     }
1383 
1384     function _setOwner(address newOwner) private {
1385         address oldOwner = _owner;
1386         _owner = newOwner;
1387         emit OwnershipTransferred(oldOwner, newOwner);
1388     }
1389 }
1390 
1391 contract SeptembersMonsters is ERC721, Ownable {
1392     bool public saleActive = false;
1393     bool public presaleActive = false;
1394 
1395     string internal baseTokenURI = "https://nftmediabox.com/api/septembers-monsters/";
1396 
1397     uint256 public price = 0.03 ether;
1398     uint256 public presaleTotalSupply = 1000;
1399     uint256 public totalSupply = 3000;
1400     uint256 public nonce = 0;
1401     uint256 public maxTx = 20;
1402 
1403     address public a1 = 0x7D58e81CeCf7F1B0071580CAB07d53EDE7858B17;
1404     address public a2 = 0x70184259C8CbF0B85C96e2A84ad74EB097759aeE;
1405     address public a3 = 0xdeF4274dA60CEF85402731F0013E5C67fC3D5c2e;
1406     address public a4 = 0x4f95219f13dC43641645B5ebE5259b040e38b281;
1407     address public a5 = 0x2027e0fE56278f671D174CbE4BCd7A42D25cc6a3;
1408     address public a6 = 0x57ccEFe8fDD9F2B17B9dD148061ae9a5f3a7e767;
1409     address public a7 = 0x80f039085f78fFF512a1edE6d25eC64927392888;
1410     address public a8 = 0x79B4cfA593B7794a7F9e54911731101E7F0afd5f;
1411 
1412     constructor() ERC721("SeptembersMonsters", "SEP") {}
1413 
1414     function setPrice(uint256 newPrice) external onlyOwner {
1415         price = newPrice;
1416     }
1417 
1418     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1419         baseTokenURI = _uri;
1420     }
1421 
1422     function setTotalSupply(uint256 newSupply) external onlyOwner {
1423         totalSupply = newSupply;
1424     }
1425 
1426     function setPresaleTotalSupply(uint256 newSupply) external onlyOwner {
1427         presaleTotalSupply = newSupply;
1428     }
1429 
1430     function setPresaleActive(bool val) public onlyOwner {
1431         presaleActive = val;
1432     }
1433 
1434     function setSaleActive(bool val) public onlyOwner {
1435         saleActive = val;
1436     }
1437 
1438     function setMembersAddresses(address[] memory _a) public onlyOwner {
1439         a1 = _a[0];
1440         a2 = _a[1];
1441         a3 = _a[2];
1442         a4 = _a[3];
1443         a5 = _a[4];
1444         a6 = _a[5];
1445         a7 = _a[6];
1446         a8 = _a[7];
1447     }
1448 
1449     function setMaxTx(uint256 newMax) external onlyOwner {
1450         maxTx = newMax;
1451     }
1452 
1453     function _baseURI() internal view override returns (string memory) {
1454         return baseTokenURI;
1455     }
1456 
1457     function giveaway(address to, uint256 qty) external onlyOwner {
1458         require(qty + nonce <= totalSupply, "Value exceeds totalSupply");
1459         for (uint256 i = 0; i < qty; i++) {
1460             uint256 tokenId = nonce;
1461             _safeMint(to, tokenId);
1462             nonce++;
1463         }
1464     }
1465 
1466     function mint(uint256 qty) external payable {
1467         require(presaleActive || saleActive, "Neither sale is active");
1468         if (presaleActive) {
1469             require(nonce + qty <= presaleTotalSupply, "Minting too many for presale or presale is sold out");
1470         }
1471         require(qty <= maxTx && qty > 0, "Qty of mints not allowed");
1472         require(
1473             qty + nonce <= totalSupply,
1474             "Value exceeds totalSupply"
1475         );
1476         require(msg.value == price * qty, "Invalid value");
1477         for (uint256 i = 0; i < qty; i++) {
1478             uint256 tokenId = nonce;
1479             _safeMint(msg.sender, tokenId);
1480             nonce++;
1481         }
1482     }
1483 
1484     function withdrawTeam() public payable onlyOwner {
1485         uint256 balance = address(this).balance;
1486         require(payable(a1).send((balance * 25) / 1000));
1487         require(payable(a2).send((balance * 25) / 1000));
1488         require(payable(a3).send((balance * 25) / 1000));
1489         require(payable(a4).send((balance * 5) / 100));
1490         require(payable(a5).send((balance * 5) / 100));
1491         require(payable(a6).send((balance * 5) / 100));
1492         require(payable(a7).send((balance * 275) / 1000));
1493         require(payable(a8).send((balance * 50) / 100));
1494     }
1495 
1496     function withdrawOwner() external onlyOwner {
1497         payable(msg.sender).transfer(address(this).balance);
1498     }
1499 }