1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
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
28 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
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
185 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
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
210 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
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
233 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
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
382         return verifyCallResult(success, returndata, errorMessage);
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
418         return verifyCallResult(success, returndata, errorMessage);
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
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
458      * revert reason using the provided one.
459      *
460      * _Available since v4.3._
461      */
462     function verifyCallResult(
463         bool success,
464         bytes memory returndata,
465         string memory errorMessage
466     ) internal pure returns (bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
486 
487 /**
488  * @dev Provides information about the current execution context, including the
489  * sender of the transaction and its data. While these are generally available
490  * via msg.sender and msg.data, they should not be accessed in such a direct
491  * manner, since when dealing with meta-transactions the account sending and
492  * paying for execution may not be the actual sender (as far as an application
493  * is concerned).
494  *
495  * This contract is only required for intermediate, library-like contracts.
496  */
497 abstract contract Context {
498     function _msgSender() internal view virtual returns (address) {
499         return msg.sender;
500     }
501 
502     function _msgData() internal view virtual returns (bytes calldata) {
503         return msg.data;
504     }
505 }
506 
507 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
508 
509 /**
510  * @dev String operations.
511  */
512 library Strings {
513     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
514 
515     /**
516      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
517      */
518     function toString(uint256 value) internal pure returns (string memory) {
519         // Inspired by OraclizeAPI's implementation - MIT licence
520         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
521 
522         if (value == 0) {
523             return "0";
524         }
525         uint256 temp = value;
526         uint256 digits;
527         while (temp != 0) {
528             digits++;
529             temp /= 10;
530         }
531         bytes memory buffer = new bytes(digits);
532         while (value != 0) {
533             digits -= 1;
534             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
535             value /= 10;
536         }
537         return string(buffer);
538     }
539 
540     /**
541      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
542      */
543     function toHexString(uint256 value) internal pure returns (string memory) {
544         if (value == 0) {
545             return "0x00";
546         }
547         uint256 temp = value;
548         uint256 length = 0;
549         while (temp != 0) {
550             length++;
551             temp >>= 8;
552         }
553         return toHexString(value, length);
554     }
555 
556     /**
557      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
558      */
559     function toHexString(uint256 value, uint256 length)
560         internal
561         pure
562         returns (string memory)
563     {
564         bytes memory buffer = new bytes(2 * length + 2);
565         buffer[0] = "0";
566         buffer[1] = "x";
567         for (uint256 i = 2 * length + 1; i > 1; --i) {
568             buffer[i] = _HEX_SYMBOLS[value & 0xf];
569             value >>= 4;
570         }
571         require(value == 0, "Strings: hex length insufficient");
572         return string(buffer);
573     }
574 }
575 
576 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
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
607 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
608 
609 /**
610  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
611  * the Metadata extension, but not including the Enumerable extension, which is available separately as
612  * {ERC721Enumerable}.
613  */
614 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
615     using Address for address;
616     using Strings for uint256;
617 
618     // Token name
619     string private _name;
620 
621     // Token symbol
622     string private _symbol;
623 
624     // Mapping from token ID to owner address
625     mapping(uint256 => address) private _owners;
626 
627     // Mapping owner address to token count
628     mapping(address => uint256) private _balances;
629 
630     // Mapping from token ID to approved address
631     mapping(uint256 => address) private _tokenApprovals;
632 
633     // Mapping from owner to operator approvals
634     mapping(address => mapping(address => bool)) private _operatorApprovals;
635 
636     /**
637      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
638      */
639     constructor(string memory name_, string memory symbol_) {
640         _name = name_;
641         _symbol = symbol_;
642     }
643 
644     /**
645      * @dev See {IERC165-supportsInterface}.
646      */
647     function supportsInterface(bytes4 interfaceId)
648         public
649         view
650         virtual
651         override(ERC165, IERC165)
652         returns (bool)
653     {
654         return
655             interfaceId == type(IERC721).interfaceId ||
656             interfaceId == type(IERC721Metadata).interfaceId ||
657             super.supportsInterface(interfaceId);
658     }
659 
660     /**
661      * @dev See {IERC721-balanceOf}.
662      */
663     function balanceOf(address owner)
664         public
665         view
666         virtual
667         override
668         returns (uint256)
669     {
670         require(
671             owner != address(0),
672             "ERC721: balance query for the zero address"
673         );
674         return _balances[owner];
675     }
676 
677     /**
678      * @dev See {IERC721-ownerOf}.
679      */
680     function ownerOf(uint256 tokenId)
681         public
682         view
683         virtual
684         override
685         returns (address)
686     {
687         address owner = _owners[tokenId];
688         require(
689             owner != address(0),
690             "ERC721: owner query for nonexistent token"
691         );
692         return owner;
693     }
694 
695     /**
696      * @dev See {IERC721Metadata-name}.
697      */
698     function name() public view virtual override returns (string memory) {
699         return _name;
700     }
701 
702     /**
703      * @dev See {IERC721Metadata-symbol}.
704      */
705     function symbol() public view virtual override returns (string memory) {
706         return _symbol;
707     }
708 
709     /**
710      * @dev See {IERC721Metadata-tokenURI}.
711      */
712     function tokenURI(uint256 tokenId)
713         public
714         view
715         virtual
716         override
717         returns (string memory)
718     {
719         require(
720             _exists(tokenId),
721             "ERC721Metadata: URI query for nonexistent token"
722         );
723 
724         string memory baseURI = _baseURI();
725         return
726             bytes(baseURI).length > 0
727                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
728                 : "";
729     }
730 
731     /**
732      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
733      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
734      * by default, can be overriden in child contracts.
735      */
736     function _baseURI() internal view virtual returns (string memory) {
737         return "";
738     }
739 
740     /**
741      * @dev See {IERC721-approve}.
742      */
743     function approve(address to, uint256 tokenId) public virtual override {
744         address owner = ERC721.ownerOf(tokenId);
745         require(to != owner, "ERC721: approval to current owner");
746 
747         require(
748             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
749             "ERC721: approve caller is not owner nor approved for all"
750         );
751 
752         _approve(to, tokenId);
753     }
754 
755     /**
756      * @dev See {IERC721-getApproved}.
757      */
758     function getApproved(uint256 tokenId)
759         public
760         view
761         virtual
762         override
763         returns (address)
764     {
765         require(
766             _exists(tokenId),
767             "ERC721: approved query for nonexistent token"
768         );
769 
770         return _tokenApprovals[tokenId];
771     }
772 
773     /**
774      * @dev See {IERC721-setApprovalForAll}.
775      */
776     function setApprovalForAll(address operator, bool approved)
777         public
778         virtual
779         override
780     {
781         require(operator != _msgSender(), "ERC721: approve to caller");
782 
783         _operatorApprovals[_msgSender()][operator] = approved;
784         emit ApprovalForAll(_msgSender(), operator, approved);
785     }
786 
787     /**
788      * @dev See {IERC721-isApprovedForAll}.
789      */
790     function isApprovedForAll(address owner, address operator)
791         public
792         view
793         virtual
794         override
795         returns (bool)
796     {
797         return _operatorApprovals[owner][operator];
798     }
799 
800     /**
801      * @dev See {IERC721-transferFrom}.
802      */
803     function transferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) public virtual override {
808         //solhint-disable-next-line max-line-length
809         require(
810             _isApprovedOrOwner(_msgSender(), tokenId),
811             "ERC721: transfer caller is not owner nor approved"
812         );
813 
814         _transfer(from, to, tokenId);
815     }
816 
817     /**
818      * @dev See {IERC721-safeTransferFrom}.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public virtual override {
825         safeTransferFrom(from, to, tokenId, "");
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId,
835         bytes memory _data
836     ) public virtual override {
837         require(
838             _isApprovedOrOwner(_msgSender(), tokenId),
839             "ERC721: transfer caller is not owner nor approved"
840         );
841         _safeTransfer(from, to, tokenId, _data);
842     }
843 
844     /**
845      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
846      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
847      *
848      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
849      *
850      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
851      * implement alternative mechanisms to perform token transfer, such as signature-based.
852      *
853      * Requirements:
854      *
855      * - `from` cannot be the zero address.
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must exist and be owned by `from`.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _safeTransfer(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) internal virtual {
868         _transfer(from, to, tokenId);
869         require(
870             _checkOnERC721Received(from, to, tokenId, _data),
871             "ERC721: transfer to non ERC721Receiver implementer"
872         );
873     }
874 
875     /**
876      * @dev Returns whether `tokenId` exists.
877      *
878      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
879      *
880      * Tokens start existing when they are minted (`_mint`),
881      * and stop existing when they are burned (`_burn`).
882      */
883     function _exists(uint256 tokenId) internal view virtual returns (bool) {
884         return _owners[tokenId] != address(0);
885     }
886 
887     /**
888      * @dev Returns whether `spender` is allowed to manage `tokenId`.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function _isApprovedOrOwner(address spender, uint256 tokenId)
895         internal
896         view
897         virtual
898         returns (bool)
899     {
900         require(
901             _exists(tokenId),
902             "ERC721: operator query for nonexistent token"
903         );
904         address owner = ERC721.ownerOf(tokenId);
905         return (spender == owner ||
906             getApproved(tokenId) == spender ||
907             isApprovedForAll(owner, spender));
908     }
909 
910     /**
911      * @dev Safely mints `tokenId` and transfers it to `to`.
912      *
913      * Requirements:
914      *
915      * - `tokenId` must not exist.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _safeMint(address to, uint256 tokenId) internal virtual {
921         _safeMint(to, tokenId, "");
922     }
923 
924     /**
925      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
926      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
927      */
928     function _safeMint(
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _mint(to, tokenId);
934         require(
935             _checkOnERC721Received(address(0), to, tokenId, _data),
936             "ERC721: transfer to non ERC721Receiver implementer"
937         );
938     }
939 
940     /**
941      * @dev Mints `tokenId` and transfers it to `to`.
942      *
943      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
944      *
945      * Requirements:
946      *
947      * - `tokenId` must not exist.
948      * - `to` cannot be the zero address.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _mint(address to, uint256 tokenId) internal virtual {
953         require(to != address(0), "ERC721: mint to the zero address");
954         require(!_exists(tokenId), "ERC721: token already minted");
955 
956         _beforeTokenTransfer(address(0), to, tokenId);
957 
958         _balances[to] += 1;
959         _owners[tokenId] = to;
960 
961         emit Transfer(address(0), to, tokenId);
962     }
963 
964     /**
965      * @dev Destroys `tokenId`.
966      * The approval is cleared when the token is burned.
967      *
968      * Requirements:
969      *
970      * - `tokenId` must exist.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _burn(uint256 tokenId) internal virtual {
975         address owner = ERC721.ownerOf(tokenId);
976 
977         _beforeTokenTransfer(owner, address(0), tokenId);
978 
979         // Clear approvals
980         _approve(address(0), tokenId);
981 
982         _balances[owner] -= 1;
983         delete _owners[tokenId];
984 
985         emit Transfer(owner, address(0), tokenId);
986     }
987 
988     /**
989      * @dev Transfers `tokenId` from `from` to `to`.
990      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
991      *
992      * Requirements:
993      *
994      * - `to` cannot be the zero address.
995      * - `tokenId` token must be owned by `from`.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _transfer(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) internal virtual {
1004         require(
1005             ERC721.ownerOf(tokenId) == from,
1006             "ERC721: transfer of token that is not own"
1007         );
1008         require(to != address(0), "ERC721: transfer to the zero address");
1009 
1010         _beforeTokenTransfer(from, to, tokenId);
1011 
1012         // Clear approvals from the previous owner
1013         _approve(address(0), tokenId);
1014 
1015         _balances[from] -= 1;
1016         _balances[to] += 1;
1017         _owners[tokenId] = to;
1018 
1019         emit Transfer(from, to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Approve `to` to operate on `tokenId`
1024      *
1025      * Emits a {Approval} event.
1026      */
1027     function _approve(address to, uint256 tokenId) internal virtual {
1028         _tokenApprovals[tokenId] = to;
1029         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1034      * The call is not executed if the target address is not a contract.
1035      *
1036      * @param from address representing the previous owner of the given token ID
1037      * @param to target address that will receive the tokens
1038      * @param tokenId uint256 ID of the token to be transferred
1039      * @param _data bytes optional data to send along with the call
1040      * @return bool whether the call correctly returned the expected magic value
1041      */
1042     function _checkOnERC721Received(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) private returns (bool) {
1048         if (to.isContract()) {
1049             try
1050                 IERC721Receiver(to).onERC721Received(
1051                     _msgSender(),
1052                     from,
1053                     tokenId,
1054                     _data
1055                 )
1056             returns (bytes4 retval) {
1057                 return retval == IERC721Receiver.onERC721Received.selector;
1058             } catch (bytes memory reason) {
1059                 if (reason.length == 0) {
1060                     revert(
1061                         "ERC721: transfer to non ERC721Receiver implementer"
1062                     );
1063                 } else {
1064                     assembly {
1065                         revert(add(32, reason), mload(reason))
1066                     }
1067                 }
1068             }
1069         } else {
1070             return true;
1071         }
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before any token transfer. This includes minting
1076      * and burning.
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1084      * - `from` and `to` are never both zero.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _beforeTokenTransfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual {}
1093 }
1094 
1095 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1096 
1097 /**
1098  * @dev Contract module which provides a basic access control mechanism, where
1099  * there is an account (an owner) that can be granted exclusive access to
1100  * specific functions.
1101  *
1102  * By default, the owner account will be the one that deploys the contract. This
1103  * can later be changed with {transferOwnership}.
1104  *
1105  * This module is used through inheritance. It will make available the modifier
1106  * `onlyOwner`, which can be applied to your functions to restrict their use to
1107  * the owner.
1108  */
1109 abstract contract Ownable is Context {
1110     address private _owner;
1111 
1112     event OwnershipTransferred(
1113         address indexed previousOwner,
1114         address indexed newOwner
1115     );
1116 
1117     /**
1118      * @dev Initializes the contract setting the deployer as the initial owner.
1119      */
1120     constructor() {
1121         _setOwner(_msgSender());
1122     }
1123 
1124     /**
1125      * @dev Returns the address of the current owner.
1126      */
1127     function owner() public view virtual returns (address) {
1128         return _owner;
1129     }
1130 
1131     /**
1132      * @dev Throws if called by any account other than the owner.
1133      */
1134     modifier onlyOwner() {
1135         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1136         _;
1137     }
1138 
1139     /**
1140      * @dev Leaves the contract without owner. It will not be possible to call
1141      * `onlyOwner` functions anymore. Can only be called by the current owner.
1142      *
1143      * NOTE: Renouncing ownership will leave the contract without an owner,
1144      * thereby removing any functionality that is only available to the owner.
1145      */
1146     function renounceOwnership() public virtual onlyOwner {
1147         _setOwner(address(0));
1148     }
1149 
1150     /**
1151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1152      * Can only be called by the current owner.
1153      */
1154     function transferOwnership(address newOwner) public virtual onlyOwner {
1155         require(
1156             newOwner != address(0),
1157             "Ownable: new owner is the zero address"
1158         );
1159         _setOwner(newOwner);
1160     }
1161 
1162     function _setOwner(address newOwner) private {
1163         address oldOwner = _owner;
1164         _owner = newOwner;
1165         emit OwnershipTransferred(oldOwner, newOwner);
1166     }
1167 }
1168 
1169 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
1170 
1171 /**
1172  * @dev Contract module that helps prevent reentrant calls to a function.
1173  *
1174  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1175  * available, which can be applied to functions to make sure there are no nested
1176  * (reentrant) calls to them.
1177  *
1178  * Note that because there is a single `nonReentrant` guard, functions marked as
1179  * `nonReentrant` may not call one another. This can be worked around by making
1180  * those functions `private`, and then adding `external` `nonReentrant` entry
1181  * points to them.
1182  *
1183  * TIP: If you would like to learn more about reentrancy and alternative ways
1184  * to protect against it, check out our blog post
1185  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1186  */
1187 abstract contract ReentrancyGuard {
1188     // Booleans are more expensive than uint256 or any type that takes up a full
1189     // word because each write operation emits an extra SLOAD to first read the
1190     // slot's contents, replace the bits taken up by the boolean, and then write
1191     // back. This is the compiler's defense against contract upgrades and
1192     // pointer aliasing, and it cannot be disabled.
1193 
1194     // The values being non-zero value makes deployment a bit more expensive,
1195     // but in exchange the refund on every call to nonReentrant will be lower in
1196     // amount. Since refunds are capped to a percentage of the total
1197     // transaction's gas, it is best to keep them low in cases like this one, to
1198     // increase the likelihood of the full refund coming into effect.
1199     uint256 private constant _NOT_ENTERED = 1;
1200     uint256 private constant _ENTERED = 2;
1201 
1202     uint256 private _status;
1203 
1204     constructor() {
1205         _status = _NOT_ENTERED;
1206     }
1207 
1208     /**
1209      * @dev Prevents a contract from calling itself, directly or indirectly.
1210      * Calling a `nonReentrant` function from another `nonReentrant`
1211      * function is not supported. It is possible to prevent this from happening
1212      * by making the `nonReentrant` function external, and make it call a
1213      * `private` function that does the actual work.
1214      */
1215     modifier nonReentrant() {
1216         // On the first call to nonReentrant, _notEntered will be true
1217         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1218 
1219         // Any calls to nonReentrant after this point will fail
1220         _status = _ENTERED;
1221 
1222         _;
1223 
1224         // By storing the original value once again, a refund is triggered (see
1225         // https://eips.ethereum.org/EIPS/eip-2200)
1226         _status = _NOT_ENTERED;
1227     }
1228 }
1229 
1230 // File contracts/Billionaire.sol
1231 
1232 //                             (@@@@@@@@@@@@@@@@@@@@@@*
1233 //                             (@@@@@@@@@@@@@@@@@@@@@@*
1234 //                  /((((((((((((((((((((((((((((((((((((((((((((*
1235 //                 .&@@@@@@@@@@/                      #@@@@@@@@@@#
1236 //                 .&@@@@@@@@@@/                      #@@@@@@@@@@#
1237 //            #@@@@&.           ......................           *@@@@@/
1238 //            #@@@@&.           ......................           *@@@@@/
1239 //      (@@@@@*     ...........      ,****,     .*****,..........,/////%@@@@@,
1240 //      (@@@@@*     ...........      ,****,     .*****...........,/////%@@@@@,
1241 //      (@@@@@*     ......     .,,,,,******,,,,,,*****,..........,/////%@@@@@,
1242 //      (@@@@@*     ......     ,**********************,..........,/////%@@@@@,
1243 // ,,,,,(%%%%%,     ......     ,*****,,,,,,,,,,,,,,,,,,..........,*****#&&&&&/,,,,,
1244 // @@@@@(      ...........     ,*****...........      ,****,...........*/////&@@@@@
1245 // @@@@@(     ............     ,*****............     ,****,...........*/////&@@@@@
1246 // @@@@@(     ............     ,**********************,................*/////&@@@@@
1247 // @@@@@(     ............     ,**********************,................*/////&@@@@@
1248 // @@@@@(      ...........     ,*****...........      ,****,...........*/////&@@@@@
1249 // @@@@@(     ............     ,*****............     ,****,...........*/////&@@@@@
1250 // @@@@@(     ............     ,*****............     ,****,...........*/////&@@@@@
1251 // @@@@@(     ............     ,*****............     ,****,...........*/////&@@@@@
1252 // @@@@@(      ...........     ,*****...........      ,****,...........*/////&@@@@@
1253 //      (@@@@@*     ......     ,**********************,..........,/////%@@@@@,
1254 //      (@@@@@*     ......     ,**********************,..........,/////%@@@@@,
1255 //      (@@@@@*     ...........      ,****,     .*****,..........,/////%@@@@@,
1256 //      (@@@@@*     ...........      ,****,     .*****...........,/////%@@@@@,
1257 //      .,,,,,#%%%%#/**********,......................***********(&&&&&(,,,,,
1258 //            #@@@@&(//////////,......................*//////////#@@@@@/
1259 //            (%%%%%(((((((((((*,,,,,,,,,,,,,,,,,,,,,,/((((((((((#%%%%%*
1260 //                 .&@@@@@@@@@@#//////////////////////&@@@@@@@@@@#
1261 //                 .&@@@@@@@@@@#//////////////////////&@@@@@@@@@@#
1262 //                             (@@@@@@@@@@@@@@@@@@@@@@*
1263 //                             (@@@@@@@@@@@@@@@@@@@@@@*
1264 
1265 contract Billionaires is ERC721, Ownable, ReentrancyGuard {
1266     uint256 public constant PRICE = 0.09 * 1e18;
1267     uint256 public constant MAX_SUPPLY = 13337;
1268     uint256 public constant OWNER_AMOUNT = 337;
1269     uint8 public constant PRESALE_MAXMINT = 3;
1270 
1271     bool public live;
1272     uint256 public minted;
1273     mapping(address => uint8) public earlyAccess;
1274     string public baseURI;
1275 
1276     constructor(
1277         string memory name_,
1278         string memory symbol_,
1279         string memory baseURI_
1280     ) ERC721(name_, symbol_) {
1281         baseURI = baseURI_;
1282         for (uint256 i = 0; i < OWNER_AMOUNT; i++) {
1283             _safeMint(msg.sender, ++minted);
1284         }
1285     }
1286 
1287     function mint(uint8 amount) public payable nonReentrant {
1288         require(amount > 0, "Amount must be more than 0");
1289         require(amount <= 10, "Amount must be 10 or less");
1290         require(msg.value == PRICE * amount, "Ether value sent is not correct");
1291         require(
1292             minted + amount <= MAX_SUPPLY,
1293             "Sold out, check out OpenSea tho! <3"
1294         );
1295 
1296         if (!live) {
1297             uint8 earlyAccessbalance = earlyAccess[msg.sender];
1298             require(
1299                 earlyAccessbalance > 0,
1300                 "Invalid presale balance - Public sale not live"
1301             );
1302             require(
1303                 earlyAccessbalance >= amount,
1304                 "Amount more than your presale limit"
1305             );
1306             earlyAccess[msg.sender] -= amount;
1307         }
1308 
1309         for (uint256 i = 0; i < amount; i++) {
1310             _safeMint(msg.sender, ++minted);
1311         }
1312     }
1313 
1314     function setEarlyAccess(address[] calldata addresses) public onlyOwner {
1315         for (uint256 i = 0; i < addresses.length; i++) {
1316             earlyAccess[addresses[i]] = PRESALE_MAXMINT;
1317         }
1318     }
1319 
1320     function letsGoooooooo() public onlyOwner {
1321         require(!live, "Public sale is already live");
1322         live = true;
1323     }
1324 
1325     function withdraw(address payable recipient) public onlyOwner {
1326         require(address(this).balance > 0, "No contract balance");
1327         recipient.transfer(address(this).balance);
1328     }
1329 
1330     function setBaseURI(string memory baseURI_) public onlyOwner {
1331         baseURI = baseURI_;
1332     }
1333 
1334     function _baseURI() internal view virtual override returns (string memory) {
1335         return baseURI;
1336     }
1337 }