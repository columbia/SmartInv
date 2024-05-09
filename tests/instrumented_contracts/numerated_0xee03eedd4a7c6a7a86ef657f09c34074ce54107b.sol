1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length)
77         internal
78         pure
79         returns (string memory)
80     {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 }
92 
93 /**
94  * @dev Required interface of an ERC721 compliant contract.
95  */
96 interface IERC721 is IERC165 {
97     /**
98      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
99      */
100     event Transfer(
101         address indexed from,
102         address indexed to,
103         uint256 indexed tokenId
104     );
105 
106     /**
107      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
108      */
109     event Approval(
110         address indexed owner,
111         address indexed approved,
112         uint256 indexed tokenId
113     );
114 
115     /**
116      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
117      */
118     event ApprovalForAll(
119         address indexed owner,
120         address indexed operator,
121         bool approved
122     );
123 
124     /**
125      * @dev Returns the number of tokens in ``owner``'s account.
126      */
127     function balanceOf(address owner) external view returns (uint256 balance);
128 
129     /**
130      * @dev Returns the owner of the `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function ownerOf(uint256 tokenId) external view returns (address owner);
137 
138     /**
139      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
140      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
141      *
142      * Requirements:
143      *
144      * - `from` cannot be the zero address.
145      * - `to` cannot be the zero address.
146      * - `tokenId` token must exist and be owned by `from`.
147      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
148      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
149      *
150      * Emits a {Transfer} event.
151      */
152     function safeTransferFrom(
153         address from,
154         address to,
155         uint256 tokenId
156     ) external;
157 
158     /**
159      * @dev Transfers `tokenId` token from `from` to `to`.
160      *
161      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must be owned by `from`.
168      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address from,
174         address to,
175         uint256 tokenId
176     ) external;
177 
178     /**
179      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
180      * The approval is cleared when the token is transferred.
181      *
182      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
183      *
184      * Requirements:
185      *
186      * - The caller must own the token or be an approved operator.
187      * - `tokenId` must exist.
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address to, uint256 tokenId) external;
192 
193     /**
194      * @dev Returns the account approved for `tokenId` token.
195      *
196      * Requirements:
197      *
198      * - `tokenId` must exist.
199      */
200     function getApproved(uint256 tokenId)
201         external
202         view
203         returns (address operator);
204 
205     /**
206      * @dev Approve or remove `operator` as an operator for the caller.
207      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
208      *
209      * Requirements:
210      *
211      * - The `operator` cannot be the caller.
212      *
213      * Emits an {ApprovalForAll} event.
214      */
215     function setApprovalForAll(address operator, bool _approved) external;
216 
217     /**
218      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
219      *
220      * See {setApprovalForAll}
221      */
222     function isApprovedForAll(address owner, address operator)
223         external
224         view
225         returns (bool);
226 
227     /**
228      * @dev Safely transfers `tokenId` token from `from` to `to`.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must exist and be owned by `from`.
235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
236      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
237      *
238      * Emits a {Transfer} event.
239      */
240     function safeTransferFrom(
241         address from,
242         address to,
243         uint256 tokenId,
244         bytes calldata data
245     ) external;
246 }
247 
248 /**
249  * @title ERC721 token receiver interface
250  * @dev Interface for any contract that wants to support safeTransfers
251  * from ERC721 asset contracts.
252  */
253 interface IERC721Receiver {
254     /**
255      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
256      * by `operator` from `from`, this function is called.
257      *
258      * It must return its Solidity selector to confirm the token transfer.
259      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
260      *
261      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
262      */
263     function onERC721Received(
264         address operator,
265         address from,
266         uint256 tokenId,
267         bytes calldata data
268     ) external returns (bytes4);
269 }
270 
271 /**
272  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
273  * @dev See https://eips.ethereum.org/EIPS/eip-721
274  */
275 interface IERC721Metadata is IERC721 {
276     /**
277      * @dev Returns the token collection name.
278      */
279     function name() external view returns (string memory);
280 
281     /**
282      * @dev Returns the token collection symbol.
283      */
284     function symbol() external view returns (string memory);
285 
286     /**
287      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
288      */
289     function tokenURI(uint256 tokenId) external view returns (string memory);
290 }
291 
292 /**
293  * @dev Collection of functions related to the address type
294  */
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      */
313     function isContract(address account) internal view returns (bool) {
314         // This method relies on extcodesize, which returns 0 for contracts in
315         // construction, since the code is only stored at the end of the
316         // constructor execution.
317 
318         uint256 size;
319         assembly {
320             size := extcodesize(account)
321         }
322         return size > 0;
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(
343             address(this).balance >= amount,
344             "Address: insufficient balance"
345         );
346 
347         (bool success, ) = recipient.call{value: amount}("");
348         require(
349             success,
350             "Address: unable to send value, recipient may have reverted"
351         );
352     }
353 
354     /**
355      * @dev Performs a Solidity function call using a low level `call`. A
356      * plain `call` is an unsafe replacement for a function call: use this
357      * function instead.
358      *
359      * If `target` reverts with a revert reason, it is bubbled up by this
360      * function (like regular Solidity function calls).
361      *
362      * Returns the raw returned data. To convert to the expected return value,
363      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
364      *
365      * Requirements:
366      *
367      * - `target` must be a contract.
368      * - calling `target` with `data` must not revert.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data)
373         internal
374         returns (bytes memory)
375     {
376         return functionCall(target, data, "Address: low-level call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value
408     ) internal returns (bytes memory) {
409         return
410             functionCallWithValue(
411                 target,
412                 data,
413                 value,
414                 "Address: low-level call with value failed"
415             );
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(
431             address(this).balance >= value,
432             "Address: insufficient balance for call"
433         );
434         require(isContract(target), "Address: call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.call{value: value}(
437             data
438         );
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(address target, bytes memory data)
449         internal
450         view
451         returns (bytes memory)
452     {
453         return
454             functionStaticCall(
455                 target,
456                 data,
457                 "Address: low-level static call failed"
458             );
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal view returns (bytes memory) {
472         require(isContract(target), "Address: static call to non-contract");
473 
474         (bool success, bytes memory returndata) = target.staticcall(data);
475         return verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(address target, bytes memory data)
485         internal
486         returns (bytes memory)
487     {
488         return
489             functionDelegateCall(
490                 target,
491                 data,
492                 "Address: low-level delegate call failed"
493             );
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         require(isContract(target), "Address: delegate call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.delegatecall(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
515      * revert reason using the provided one.
516      *
517      * _Available since v4.3._
518      */
519     function verifyCallResult(
520         bool success,
521         bytes memory returndata,
522         string memory errorMessage
523     ) internal pure returns (bytes memory) {
524         if (success) {
525             return returndata;
526         } else {
527             // Look for revert reason and bubble it up if present
528             if (returndata.length > 0) {
529                 // The easiest way to bubble the revert reason is using memory via assembly
530 
531                 assembly {
532                     let returndata_size := mload(returndata)
533                     revert(add(32, returndata), returndata_size)
534                 }
535             } else {
536                 revert(errorMessage);
537             }
538         }
539     }
540 }
541 
542 /**
543  * @dev Provides information about the current execution context, including the
544  * sender of the transaction and its data. While these are generally available
545  * via msg.sender and msg.data, they should not be accessed in such a direct
546  * manner, since when dealing with meta-transactions the account sending and
547  * paying for execution may not be the actual sender (as far as an application
548  * is concerned).
549  *
550  * This contract is only required for intermediate, library-like contracts.
551  */
552 abstract contract Context {
553     function _msgSender() internal view virtual returns (address) {
554         return msg.sender;
555     }
556 
557     function _msgData() internal view virtual returns (bytes calldata) {
558         return msg.data;
559     }
560 }
561 
562 /**
563  * @dev Implementation of the {IERC165} interface.
564  *
565  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
566  * for the additional interface id that will be supported. For example:
567  *
568  * ```solidity
569  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
571  * }
572  * ```
573  *
574  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
575  */
576 abstract contract ERC165 is IERC165 {
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId)
581         public
582         view
583         virtual
584         override
585         returns (bool)
586     {
587         return interfaceId == type(IERC165).interfaceId;
588     }
589 }
590 
591 /**
592  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
593  * the Metadata extension, but not including the Enumerable extension, which is available separately as
594  * {ERC721Enumerable}.
595  */
596 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
597     using Address for address;
598     using Strings for uint256;
599 
600     // Token name
601     string private _name;
602 
603     // Token symbol
604     string private _symbol;
605 
606     // Mapping from token ID to owner address
607     mapping(uint256 => address) private _owners;
608 
609     // Mapping owner address to token count
610     mapping(address => uint256) private _balances;
611 
612     // Mapping from token ID to approved address
613     mapping(uint256 => address) private _tokenApprovals;
614 
615     // Mapping from owner to operator approvals
616     mapping(address => mapping(address => bool)) private _operatorApprovals;
617 
618     /**
619      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
620      */
621     constructor(string memory name_, string memory symbol_) {
622         _name = name_;
623         _symbol = symbol_;
624     }
625 
626     /**
627      * @dev See {IERC165-supportsInterface}.
628      */
629     function supportsInterface(bytes4 interfaceId)
630         public
631         view
632         virtual
633         override(ERC165, IERC165)
634         returns (bool)
635     {
636         return
637             interfaceId == type(IERC721).interfaceId ||
638             interfaceId == type(IERC721Metadata).interfaceId ||
639             super.supportsInterface(interfaceId);
640     }
641 
642     /**
643      * @dev See {IERC721-balanceOf}.
644      */
645     function balanceOf(address owner)
646         public
647         view
648         virtual
649         override
650         returns (uint256)
651     {
652         require(
653             owner != address(0),
654             "ERC721: balance query for the zero address"
655         );
656         return _balances[owner];
657     }
658 
659     /**
660      * @dev See {IERC721-ownerOf}.
661      */
662     function ownerOf(uint256 tokenId)
663         public
664         view
665         virtual
666         override
667         returns (address)
668     {
669         address owner = _owners[tokenId];
670         require(
671             owner != address(0),
672             "ERC721: owner query for nonexistent token"
673         );
674         return owner;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-name}.
679      */
680     function name() public view virtual override returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-symbol}.
686      */
687     function symbol() public view virtual override returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-tokenURI}.
693      */
694     function tokenURI(uint256 tokenId)
695         public
696         view
697         virtual
698         override
699         returns (string memory)
700     {
701         require(
702             _exists(tokenId),
703             "ERC721Metadata: URI query for nonexistent token"
704         );
705 
706         string memory baseURI = _baseURI();
707         return
708             bytes(baseURI).length > 0
709                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
710                 : "";
711     }
712 
713     /**
714      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
715      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
716      * by default, can be overriden in child contracts.
717      */
718     function _baseURI() internal view virtual returns (string memory) {
719         return "";
720     }
721 
722     /**
723      * @dev See {IERC721-approve}.
724      */
725     function approve(address to, uint256 tokenId) public virtual override {
726         address owner = ERC721.ownerOf(tokenId);
727         require(to != owner, "ERC721: approval to current owner");
728 
729         require(
730             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
731             "ERC721: approve caller is not owner nor approved for all"
732         );
733 
734         _approve(to, tokenId);
735     }
736 
737     /**
738      * @dev See {IERC721-getApproved}.
739      */
740     function getApproved(uint256 tokenId)
741         public
742         view
743         virtual
744         override
745         returns (address)
746     {
747         require(
748             _exists(tokenId),
749             "ERC721: approved query for nonexistent token"
750         );
751 
752         return _tokenApprovals[tokenId];
753     }
754 
755     /**
756      * @dev See {IERC721-setApprovalForAll}.
757      */
758     function setApprovalForAll(address operator, bool approved)
759         public
760         virtual
761         override
762     {
763         require(operator != _msgSender(), "ERC721: approve to caller");
764 
765         _operatorApprovals[_msgSender()][operator] = approved;
766         emit ApprovalForAll(_msgSender(), operator, approved);
767     }
768 
769     /**
770      * @dev See {IERC721-isApprovedForAll}.
771      */
772     function isApprovedForAll(address owner, address operator)
773         public
774         view
775         virtual
776         override
777         returns (bool)
778     {
779         return _operatorApprovals[owner][operator];
780     }
781 
782     /**
783      * @dev See {IERC721-transferFrom}.
784      */
785     function transferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         //solhint-disable-next-line max-line-length
791         require(
792             _isApprovedOrOwner(_msgSender(), tokenId),
793             "ERC721: transfer caller is not owner nor approved"
794         );
795 
796         _transfer(from, to, tokenId);
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) public virtual override {
807         safeTransferFrom(from, to, tokenId, "");
808     }
809 
810     /**
811      * @dev See {IERC721-safeTransferFrom}.
812      */
813     function safeTransferFrom(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) public virtual override {
819         require(
820             _isApprovedOrOwner(_msgSender(), tokenId),
821             "ERC721: transfer caller is not owner nor approved"
822         );
823         _safeTransfer(from, to, tokenId, _data);
824     }
825 
826     /**
827      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
828      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
829      *
830      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
831      *
832      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
833      * implement alternative mechanisms to perform token transfer, such as signature-based.
834      *
835      * Requirements:
836      *
837      * - `from` cannot be the zero address.
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must exist and be owned by `from`.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _safeTransfer(
845         address from,
846         address to,
847         uint256 tokenId,
848         bytes memory _data
849     ) internal virtual {
850         _transfer(from, to, tokenId);
851         require(
852             _checkOnERC721Received(from, to, tokenId, _data),
853             "ERC721: transfer to non ERC721Receiver implementer"
854         );
855     }
856 
857     /**
858      * @dev Returns whether `tokenId` exists.
859      *
860      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
861      *
862      * Tokens start existing when they are minted (`_mint`),
863      * and stop existing when they are burned (`_burn`).
864      */
865     function _exists(uint256 tokenId) internal view virtual returns (bool) {
866         return _owners[tokenId] != address(0);
867     }
868 
869     /**
870      * @dev Returns whether `spender` is allowed to manage `tokenId`.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must exist.
875      */
876     function _isApprovedOrOwner(address spender, uint256 tokenId)
877         internal
878         view
879         virtual
880         returns (bool)
881     {
882         require(
883             _exists(tokenId),
884             "ERC721: operator query for nonexistent token"
885         );
886         address owner = ERC721.ownerOf(tokenId);
887         return (spender == owner ||
888             getApproved(tokenId) == spender ||
889             isApprovedForAll(owner, spender));
890     }
891 
892     /**
893      * @dev Safely mints `tokenId` and transfers it to `to`.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must not exist.
898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _safeMint(address to, uint256 tokenId) internal virtual {
903         _safeMint(to, tokenId, "");
904     }
905 
906     /**
907      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
908      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
909      */
910     function _safeMint(
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) internal virtual {
915         _mint(to, tokenId);
916         require(
917             _checkOnERC721Received(address(0), to, tokenId, _data),
918             "ERC721: transfer to non ERC721Receiver implementer"
919         );
920     }
921 
922     /**
923      * @dev Mints `tokenId` and transfers it to `to`.
924      *
925      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
926      *
927      * Requirements:
928      *
929      * - `tokenId` must not exist.
930      * - `to` cannot be the zero address.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _mint(address to, uint256 tokenId) internal virtual {
935         require(to != address(0), "ERC721: mint to the zero address");
936         require(!_exists(tokenId), "ERC721: token already minted");
937 
938         _beforeTokenTransfer(address(0), to, tokenId);
939 
940         _balances[to] += 1;
941         _owners[tokenId] = to;
942 
943         emit Transfer(address(0), to, tokenId);
944     }
945 
946     /**
947      * @dev Destroys `tokenId`.
948      * The approval is cleared when the token is burned.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _burn(uint256 tokenId) internal virtual {
957         address owner = ERC721.ownerOf(tokenId);
958 
959         _beforeTokenTransfer(owner, address(0), tokenId);
960 
961         // Clear approvals
962         _approve(address(0), tokenId);
963 
964         _balances[owner] -= 1;
965         delete _owners[tokenId];
966 
967         emit Transfer(owner, address(0), tokenId);
968     }
969 
970     /**
971      * @dev Transfers `tokenId` from `from` to `to`.
972      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
973      *
974      * Requirements:
975      *
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must be owned by `from`.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _transfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) internal virtual {
986         require(
987             ERC721.ownerOf(tokenId) == from,
988             "ERC721: transfer of token that is not own"
989         );
990         require(to != address(0), "ERC721: transfer to the zero address");
991 
992         _beforeTokenTransfer(from, to, tokenId);
993 
994         // Clear approvals from the previous owner
995         _approve(address(0), tokenId);
996 
997         _balances[from] -= 1;
998         _balances[to] += 1;
999         _owners[tokenId] = to;
1000 
1001         emit Transfer(from, to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Approve `to` to operate on `tokenId`
1006      *
1007      * Emits a {Approval} event.
1008      */
1009     function _approve(address to, uint256 tokenId) internal virtual {
1010         _tokenApprovals[tokenId] = to;
1011         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1012     }
1013 
1014     /**
1015      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1016      * The call is not executed if the target address is not a contract.
1017      *
1018      * @param from address representing the previous owner of the given token ID
1019      * @param to target address that will receive the tokens
1020      * @param tokenId uint256 ID of the token to be transferred
1021      * @param _data bytes optional data to send along with the call
1022      * @return bool whether the call correctly returned the expected magic value
1023      */
1024     function _checkOnERC721Received(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) private returns (bool) {
1030         if (to.isContract()) {
1031             try
1032                 IERC721Receiver(to).onERC721Received(
1033                     _msgSender(),
1034                     from,
1035                     tokenId,
1036                     _data
1037                 )
1038             returns (bytes4 retval) {
1039                 return retval == IERC721Receiver.onERC721Received.selector;
1040             } catch (bytes memory reason) {
1041                 if (reason.length == 0) {
1042                     revert(
1043                         "ERC721: transfer to non ERC721Receiver implementer"
1044                     );
1045                 } else {
1046                     assembly {
1047                         revert(add(32, reason), mload(reason))
1048                     }
1049                 }
1050             }
1051         } else {
1052             return true;
1053         }
1054     }
1055 
1056     /**
1057      * @dev Hook that is called before any token transfer. This includes minting
1058      * and burning.
1059      *
1060      * Calling conditions:
1061      *
1062      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1063      * transferred to `to`.
1064      * - When `from` is zero, `tokenId` will be minted for `to`.
1065      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1066      * - `from` and `to` are never both zero.
1067      *
1068      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1069      */
1070     function _beforeTokenTransfer(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) internal virtual {}
1075 }
1076 
1077 /**
1078  * @dev Contract module which provides a basic access control mechanism, where
1079  * there is an account (an owner) that can be granted exclusive access to
1080  * specific functions.
1081  *
1082  * By default, the owner account will be the one that deploys the contract. This
1083  * can later be changed with {transferOwnership}.
1084  *
1085  * This module is used through inheritance. It will make available the modifier
1086  * `onlyOwner`, which can be applied to your functions to restrict their use to
1087  * the owner.
1088  */
1089 abstract contract Ownable is Context {
1090     address private _owner;
1091 
1092     event OwnershipTransferred(
1093         address indexed previousOwner,
1094         address indexed newOwner
1095     );
1096 
1097     /**
1098      * @dev Initializes the contract setting the deployer as the initial owner.
1099      */
1100     constructor() {
1101         _setOwner(_msgSender());
1102     }
1103 
1104     /**
1105      * @dev Returns the address of the current owner.
1106      */
1107     function owner() public view virtual returns (address) {
1108         return _owner;
1109     }
1110 
1111     /**
1112      * @dev Throws if called by any account other than the owner.
1113      */
1114     modifier onlyOwner() {
1115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1116         _;
1117     }
1118 
1119     /**
1120      * @dev Leaves the contract without owner. It will not be possible to call
1121      * `onlyOwner` functions anymore. Can only be called by the current owner.
1122      *
1123      * NOTE: Renouncing ownership will leave the contract without an owner,
1124      * thereby removing any functionality that is only available to the owner.
1125      */
1126     function renounceOwnership() public virtual onlyOwner {
1127         _setOwner(address(0));
1128     }
1129 
1130     /**
1131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1132      * Can only be called by the current owner.
1133      */
1134     function transferOwnership(address newOwner) public virtual onlyOwner {
1135         require(
1136             newOwner != address(0),
1137             "Ownable: new owner is the zero address"
1138         );
1139         _setOwner(newOwner);
1140     }
1141 
1142     function _setOwner(address newOwner) private {
1143         address oldOwner = _owner;
1144         _owner = newOwner;
1145         emit OwnershipTransferred(oldOwner, newOwner);
1146     }
1147 }
1148 
1149 /**
1150  * @title Counters
1151  * @author Matt Condon (@shrugs)
1152  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1153  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1154  *
1155  * Include with `using Counters for Counters.Counter;`
1156  */
1157 library Counters {
1158     struct Counter {
1159         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1160         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1161         // this feature: see https://github.com/ethereum/solidity/issues/4637
1162         uint256 _value; // default: 0
1163     }
1164 
1165     function current(Counter storage counter) internal view returns (uint256) {
1166         return counter._value;
1167     }
1168 
1169     function increment(Counter storage counter) internal {
1170         unchecked {
1171             counter._value += 1;
1172         }
1173     }
1174 
1175     function decrement(Counter storage counter) internal {
1176         uint256 value = counter._value;
1177         require(value > 0, "Counter: decrement overflow");
1178         unchecked {
1179             counter._value = value - 1;
1180         }
1181     }
1182 
1183     function reset(Counter storage counter) internal {
1184         counter._value = 0;
1185     }
1186 }
1187 
1188 contract CloneApes is ERC721, Ownable {
1189     using Counters for Counters.Counter;
1190     Counters.Counter private _tokenIds;
1191 
1192     uint256 public constant MAX_SUPPLY = 8888;
1193 
1194     uint256 public constant MAX_MINT_PER_TX = 5;
1195 
1196     uint256 public constant MAX_MINT_PER_TX_PRESALE = 5;
1197 
1198     uint256 public constant PRICE = 0.15 ether;
1199 
1200     uint256 public constant PRESALE_PRICE = 0.13 ether;
1201 
1202     string public baseURI;
1203 
1204     uint256 public batchSize;
1205 
1206     uint256 public batchCount;
1207 
1208     bool public mintable = false;
1209 
1210     bool public preSaleMintable = false;
1211 
1212     uint256 public totalSupplyRemaining = MAX_SUPPLY;
1213 
1214     mapping(address => bool) public allowList;
1215 
1216     event Mintable(bool mintable);
1217 
1218     event PreSaleMintable(bool preSaleMintable);
1219 
1220     event BaseURI(string baseURI);
1221 
1222     event BatchSize(uint256 batchSize);
1223 
1224     event BatchCount(uint256 batchCount);
1225 
1226     event AddToAllowList(address[] accounts);
1227 
1228     event RemoveFromAllowList(address account);
1229 
1230     constructor() ERC721("Clone Apes", "CA") {
1231         _tokenIds.increment();
1232     }
1233 
1234     modifier isMintable() {
1235         require(mintable, "Clone Apes: NFT cannot be minted yet.");
1236         _;
1237     }
1238 
1239     modifier isPreSaleMintable() {
1240         require(preSaleMintable, "Clone Apes: NFT cannot be minted yet.");
1241         _;
1242     }
1243 
1244     modifier isNotExceedMaxMintPerTx(uint256 amount) {
1245         require(
1246             amount <= MAX_MINT_PER_TX,
1247             "Clone Apes: Mint amount exceeds max limit per tx."
1248         );
1249         _;
1250     }
1251 
1252     modifier isNotExceedMaxMintPerTxPresale(uint256 amount) {
1253         require(
1254             amount <= MAX_MINT_PER_TX_PRESALE,
1255             "Clone Apes: Mint amount exceeds max limit per tx."
1256         );
1257         _;
1258     }
1259 
1260     modifier isNotExceedAvailableSupply(uint256 amount) {
1261         require(
1262             batchCount + amount <= batchSize,
1263             "Clone Apes: There are no more remaining NFT's to mint."
1264         );
1265         _;
1266     }
1267 
1268     modifier isPaymentSufficient(uint256 amount) {
1269         require(
1270             msg.value == amount * PRICE,
1271             "Clone Apes: There was not enough/extra ETH transferred to mint an NFT."
1272         );
1273         _;
1274     }
1275 
1276     modifier isPreSalePaymentSufficient(uint256 amount) {
1277         require(
1278             msg.value == amount * PRESALE_PRICE,
1279             "Clone Apes: There was not enough/extra ETH transferred to mint an NFT."
1280         );
1281         _;
1282     }
1283 
1284     modifier isAllowList() {
1285         require(
1286             allowList[msg.sender],
1287             "Clone Apes: You're not on the list for the presale."
1288         );
1289         _;
1290     }
1291 
1292     function preSaleMint(uint256 amount)
1293         public
1294         payable
1295         isPreSaleMintable
1296         isNotExceedMaxMintPerTxPresale(amount)
1297         isAllowList
1298         isNotExceedAvailableSupply(amount)
1299         isPreSalePaymentSufficient(amount)
1300     {
1301         for (uint256 index = 0; index < amount; index++) {
1302             uint256 id = _tokenIds.current();
1303             _safeMint(msg.sender, id);
1304             _tokenIds.increment();
1305             totalSupplyRemaining--;
1306             batchCount++;
1307         }
1308         allowList[msg.sender] = false;
1309     }
1310 
1311     function mint(uint256 amount)
1312         public
1313         payable
1314         isMintable
1315         isNotExceedMaxMintPerTx(amount)
1316         isNotExceedAvailableSupply(amount)
1317         isPaymentSufficient(amount)
1318     {
1319         for (uint256 index = 0; index < amount; index++) {
1320             uint256 id = _tokenIds.current();
1321             _safeMint(msg.sender, id);
1322             _tokenIds.increment();
1323             totalSupplyRemaining--;
1324             batchCount++;
1325         }
1326     }
1327 
1328     function ownerMint(uint256 amount)
1329         public
1330         onlyOwner
1331         isNotExceedAvailableSupply(amount)
1332     {
1333         for (uint256 index = 0; index < amount; index++) {
1334             uint256 id = _tokenIds.current();
1335             _safeMint(msg.sender, id);
1336             _tokenIds.increment();
1337             totalSupplyRemaining--;
1338             batchCount++;
1339         }
1340     }
1341 
1342     function setBaseURI(string memory _URI) public onlyOwner {
1343         baseURI = _URI;
1344 
1345         emit BaseURI(baseURI);
1346     }
1347 
1348     function setMintable(bool _mintable) public onlyOwner {
1349         mintable = _mintable;
1350 
1351         emit Mintable(mintable);
1352     }
1353 
1354     function setPreSaleMintable(bool _preSaleMintable) public onlyOwner {
1355         preSaleMintable = _preSaleMintable;
1356 
1357         emit PreSaleMintable(preSaleMintable);
1358     }
1359 
1360     function setBatchSize(uint256 _batchSize) public onlyOwner {
1361         batchSize = _batchSize;
1362 
1363         emit BatchSize(batchSize);
1364     }
1365 
1366     function setBatchCount(uint256 _batchCount) public onlyOwner {
1367         batchCount = _batchCount;
1368 
1369         emit BatchCount(batchCount);
1370     }
1371 
1372     function _baseURI() internal view virtual override returns (string memory) {
1373         return baseURI;
1374     }
1375 
1376     function withdraw() external onlyOwner {
1377         payable(owner()).transfer(address(this).balance);
1378     }
1379 
1380     function setAddressesToAllowList(address[] memory _addresses)
1381         public
1382         onlyOwner
1383     {
1384         for (uint256 i = 0; i < _addresses.length; i++) {
1385             allowList[_addresses[i]] = true;
1386         }
1387 
1388         emit AddToAllowList(_addresses);
1389     }
1390 
1391     function removeAddressFromAllowList(address _address) public onlyOwner {
1392         allowList[_address] = false;
1393         emit RemoveFromAllowList(_address);
1394     }
1395 }