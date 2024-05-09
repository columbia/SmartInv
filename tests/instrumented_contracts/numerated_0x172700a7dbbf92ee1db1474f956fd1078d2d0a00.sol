1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.4.22 <0.9.0;
4 
5 //
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
27 //
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(
36         address indexed from,
37         address indexed to,
38         uint256 indexed tokenId
39     );
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(
45         address indexed owner,
46         address indexed approved,
47         uint256 indexed tokenId
48     );
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(
54         address indexed owner,
55         address indexed operator,
56         bool approved
57     );
58 
59     /**
60      * @dev Returns the number of tokens in ``owner``'s account.
61      */
62     function balanceOf(address owner) external view returns (uint256 balance);
63 
64     /**
65      * @dev Returns the owner of the `tokenId` token.
66      *
67      * Requirements:
68      *
69      * - `tokenId` must exist.
70      */
71     function ownerOf(uint256 tokenId) external view returns (address owner);
72 
73     /**
74      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
75      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must exist and be owned by `from`.
82      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
83      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
84      *
85      * Emits a {Transfer} event.
86      */
87     function safeTransferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92 
93     /**
94      * @dev Transfers `tokenId` token from `from` to `to`.
95      *
96      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must be owned by `from`.
103      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 tokenId
111     ) external;
112 
113     /**
114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
115      * The approval is cleared when the token is transferred.
116      *
117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
118      *
119      * Requirements:
120      *
121      * - The caller must own the token or be an approved operator.
122      * - `tokenId` must exist.
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Returns the account approved for `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function getApproved(uint256 tokenId)
136         external
137         view
138         returns (address operator);
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator)
158         external
159         view
160         returns (bool);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 }
182 
183 //
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 //
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 //
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(
281             address(this).balance >= amount,
282             "Address: insufficient balance"
283         );
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(
287             success,
288             "Address: unable to send value, recipient may have reverted"
289         );
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data)
311         internal
312         returns (bytes memory)
313     {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return
348             functionCallWithValue(
349                 target,
350                 data,
351                 value,
352                 "Address: low-level call with value failed"
353             );
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(
369             address(this).balance >= value,
370             "Address: insufficient balance for call"
371         );
372         require(isContract(target), "Address: call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.call{value: value}(
375             data
376         );
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data)
387         internal
388         view
389         returns (bytes memory)
390     {
391         return
392             functionStaticCall(
393                 target,
394                 data,
395                 "Address: low-level static call failed"
396             );
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal view returns (bytes memory) {
410         require(isContract(target), "Address: static call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.staticcall(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(address target, bytes memory data)
423         internal
424         returns (bytes memory)
425     {
426         return
427             functionDelegateCall(
428                 target,
429                 data,
430                 "Address: low-level delegate call failed"
431             );
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 //
481 /**
482  * @dev Provides information about the current execution context, including the
483  * sender of the transaction and its data. While these are generally available
484  * via msg.sender and msg.data, they should not be accessed in such a direct
485  * manner, since when dealing with meta-transactions the account sending and
486  * paying for execution may not be the actual sender (as far as an application
487  * is concerned).
488  *
489  * This contract is only required for intermediate, library-like contracts.
490  */
491 abstract contract Context {
492     function _msgSender() internal view virtual returns (address) {
493         return msg.sender;
494     }
495 
496     function _msgData() internal view virtual returns (bytes calldata) {
497         return msg.data;
498     }
499 }
500 
501 //
502 /**
503  * @dev String operations.
504  */
505 library Strings {
506     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
510      */
511     function toString(uint256 value) internal pure returns (string memory) {
512         // Inspired by OraclizeAPI's implementation - MIT licence
513         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
514 
515         if (value == 0) {
516             return "0";
517         }
518         uint256 temp = value;
519         uint256 digits;
520         while (temp != 0) {
521             digits++;
522             temp /= 10;
523         }
524         bytes memory buffer = new bytes(digits);
525         while (value != 0) {
526             digits -= 1;
527             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
528             value /= 10;
529         }
530         return string(buffer);
531     }
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
535      */
536     function toHexString(uint256 value) internal pure returns (string memory) {
537         if (value == 0) {
538             return "0x00";
539         }
540         uint256 temp = value;
541         uint256 length = 0;
542         while (temp != 0) {
543             length++;
544             temp >>= 8;
545         }
546         return toHexString(value, length);
547     }
548 
549     /**
550      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
551      */
552     function toHexString(uint256 value, uint256 length)
553         internal
554         pure
555         returns (string memory)
556     {
557         bytes memory buffer = new bytes(2 * length + 2);
558         buffer[0] = "0";
559         buffer[1] = "x";
560         for (uint256 i = 2 * length + 1; i > 1; --i) {
561             buffer[i] = _HEX_SYMBOLS[value & 0xf];
562             value >>= 4;
563         }
564         require(value == 0, "Strings: hex length insufficient");
565         return string(buffer);
566     }
567 }
568 
569 //
570 /**
571  * @dev Implementation of the {IERC165} interface.
572  *
573  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
574  * for the additional interface id that will be supported. For example:
575  *
576  * ```solidity
577  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
579  * }
580  * ```
581  *
582  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
583  */
584 abstract contract ERC165 is IERC165 {
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId)
589         public
590         view
591         virtual
592         override
593         returns (bool)
594     {
595         return interfaceId == type(IERC165).interfaceId;
596     }
597 }
598 
599 //
600 /**
601  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
602  * the Metadata extension, but not including the Enumerable extension, which is available separately as
603  * {ERC721Enumerable}.
604  */
605 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
606     using Address for address;
607     using Strings for uint256;
608 
609     // Token name
610     string private _name;
611 
612     // Token symbol
613     string private _symbol;
614 
615     // Mapping from token ID to owner address
616     mapping(uint256 => address) private _owners;
617 
618     // Mapping owner address to token count
619     mapping(address => uint256) private _balances;
620 
621     // Mapping from token ID to approved address
622     mapping(uint256 => address) private _tokenApprovals;
623 
624     // Mapping from owner to operator approvals
625     mapping(address => mapping(address => bool)) private _operatorApprovals;
626 
627     /**
628      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
629      */
630     constructor(string memory name_, string memory symbol_) {
631         _name = name_;
632         _symbol = symbol_;
633     }
634 
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId)
639         public
640         view
641         virtual
642         override(ERC165, IERC165)
643         returns (bool)
644     {
645         return
646             interfaceId == type(IERC721).interfaceId ||
647             interfaceId == type(IERC721Metadata).interfaceId ||
648             super.supportsInterface(interfaceId);
649     }
650 
651     /**
652      * @dev See {IERC721-balanceOf}.
653      */
654     function balanceOf(address owner)
655         public
656         view
657         virtual
658         override
659         returns (uint256)
660     {
661         require(
662             owner != address(0),
663             "ERC721: balance query for the zero address"
664         );
665         return _balances[owner];
666     }
667 
668     /**
669      * @dev See {IERC721-ownerOf}.
670      */
671     function ownerOf(uint256 tokenId)
672         public
673         view
674         virtual
675         override
676         returns (address)
677     {
678         address owner = _owners[tokenId];
679         require(
680             owner != address(0),
681             "ERC721: owner query for nonexistent token"
682         );
683         return owner;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-name}.
688      */
689     function name() public view virtual override returns (string memory) {
690         return _name;
691     }
692 
693     /**
694      * @dev See {IERC721Metadata-symbol}.
695      */
696     function symbol() public view virtual override returns (string memory) {
697         return _symbol;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-tokenURI}.
702      */
703     function tokenURI(uint256 tokenId)
704         public
705         view
706         virtual
707         override
708         returns (string memory)
709     {
710         require(
711             _exists(tokenId),
712             "ERC721Metadata: URI query for nonexistent token"
713         );
714 
715         string memory baseURI = _baseURI();
716         return
717             bytes(baseURI).length > 0
718                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
719                 : "";
720     }
721 
722     /**
723      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
724      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
725      * by default, can be overriden in child contracts.
726      */
727     function _baseURI() internal view virtual returns (string memory) {
728         return "";
729     }
730 
731     /**
732      * @dev See {IERC721-approve}.
733      */
734     function approve(address to, uint256 tokenId) public virtual override {
735         address owner = ERC721.ownerOf(tokenId);
736         require(to != owner, "ERC721: approval to current owner");
737 
738         require(
739             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
740             "ERC721: approve caller is not owner nor approved for all"
741         );
742 
743         _approve(to, tokenId);
744     }
745 
746     /**
747      * @dev See {IERC721-getApproved}.
748      */
749     function getApproved(uint256 tokenId)
750         public
751         view
752         virtual
753         override
754         returns (address)
755     {
756         require(
757             _exists(tokenId),
758             "ERC721: approved query for nonexistent token"
759         );
760 
761         return _tokenApprovals[tokenId];
762     }
763 
764     /**
765      * @dev See {IERC721-setApprovalForAll}.
766      */
767     function setApprovalForAll(address operator, bool approved)
768         public
769         virtual
770         override
771     {
772         require(operator != _msgSender(), "ERC721: approve to caller");
773 
774         _operatorApprovals[_msgSender()][operator] = approved;
775         emit ApprovalForAll(_msgSender(), operator, approved);
776     }
777 
778     /**
779      * @dev See {IERC721-isApprovedForAll}.
780      */
781     function isApprovedForAll(address owner, address operator)
782         public
783         view
784         virtual
785         override
786         returns (bool)
787     {
788         return _operatorApprovals[owner][operator];
789     }
790 
791     /**
792      * @dev See {IERC721-transferFrom}.
793      */
794     function transferFrom(
795         address from,
796         address to,
797         uint256 tokenId
798     ) public virtual override {
799         //solhint-disable-next-line max-line-length
800         require(
801             _isApprovedOrOwner(_msgSender(), tokenId),
802             "ERC721: transfer caller is not owner nor approved"
803         );
804 
805         _transfer(from, to, tokenId);
806     }
807 
808     /**
809      * @dev See {IERC721-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) public virtual override {
816         safeTransferFrom(from, to, tokenId, "");
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) public virtual override {
828         require(
829             _isApprovedOrOwner(_msgSender(), tokenId),
830             "ERC721: transfer caller is not owner nor approved"
831         );
832         _safeTransfer(from, to, tokenId, _data);
833     }
834 
835     /**
836      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
837      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
838      *
839      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
840      *
841      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
842      * implement alternative mechanisms to perform token transfer, such as signature-based.
843      *
844      * Requirements:
845      *
846      * - `from` cannot be the zero address.
847      * - `to` cannot be the zero address.
848      * - `tokenId` token must exist and be owned by `from`.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _safeTransfer(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) internal virtual {
859         _transfer(from, to, tokenId);
860         require(
861             _checkOnERC721Received(from, to, tokenId, _data),
862             "ERC721: transfer to non ERC721Receiver implementer"
863         );
864     }
865 
866     /**
867      * @dev Returns whether `tokenId` exists.
868      *
869      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
870      *
871      * Tokens start existing when they are minted (`_mint`),
872      * and stop existing when they are burned (`_burn`).
873      */
874     function _exists(uint256 tokenId) internal view virtual returns (bool) {
875         return _owners[tokenId] != address(0);
876     }
877 
878     /**
879      * @dev Returns whether `spender` is allowed to manage `tokenId`.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      */
885     function _isApprovedOrOwner(address spender, uint256 tokenId)
886         internal
887         view
888         virtual
889         returns (bool)
890     {
891         require(
892             _exists(tokenId),
893             "ERC721: operator query for nonexistent token"
894         );
895         address owner = ERC721.ownerOf(tokenId);
896         return (spender == owner ||
897             getApproved(tokenId) == spender ||
898             isApprovedForAll(owner, spender));
899     }
900 
901     /**
902      * @dev Safely mints `tokenId` and transfers it to `to`.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must not exist.
907      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _safeMint(address to, uint256 tokenId) internal virtual {
912         _safeMint(to, tokenId, "");
913     }
914 
915     /**
916      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
917      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
918      */
919     function _safeMint(
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) internal virtual {
924         _mint(to, tokenId);
925         require(
926             _checkOnERC721Received(address(0), to, tokenId, _data),
927             "ERC721: transfer to non ERC721Receiver implementer"
928         );
929     }
930 
931     /**
932      * @dev Mints `tokenId` and transfers it to `to`.
933      *
934      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
935      *
936      * Requirements:
937      *
938      * - `tokenId` must not exist.
939      * - `to` cannot be the zero address.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _mint(address to, uint256 tokenId) internal virtual {
944         require(to != address(0), "ERC721: mint to the zero address");
945         require(!_exists(tokenId), "ERC721: token already minted");
946 
947         _beforeTokenTransfer(address(0), to, tokenId);
948 
949         _balances[to] += 1;
950         _owners[tokenId] = to;
951 
952         emit Transfer(address(0), to, tokenId);
953     }
954 
955     /**
956      * @dev Destroys `tokenId`.
957      * The approval is cleared when the token is burned.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _burn(uint256 tokenId) internal virtual {
966         address owner = ERC721.ownerOf(tokenId);
967 
968         _beforeTokenTransfer(owner, address(0), tokenId);
969 
970         // Clear approvals
971         _approve(address(0), tokenId);
972 
973         _balances[owner] -= 1;
974         delete _owners[tokenId];
975 
976         emit Transfer(owner, address(0), tokenId);
977     }
978 
979     /**
980      * @dev Transfers `tokenId` from `from` to `to`.
981      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _transfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) internal virtual {
995         require(
996             ERC721.ownerOf(tokenId) == from,
997             "ERC721: transfer of token that is not own"
998         );
999         require(to != address(0), "ERC721: transfer to the zero address");
1000 
1001         _beforeTokenTransfer(from, to, tokenId);
1002 
1003         // Clear approvals from the previous owner
1004         _approve(address(0), tokenId);
1005 
1006         _balances[from] -= 1;
1007         _balances[to] += 1;
1008         _owners[tokenId] = to;
1009 
1010         emit Transfer(from, to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev Approve `to` to operate on `tokenId`
1015      *
1016      * Emits a {Approval} event.
1017      */
1018     function _approve(address to, uint256 tokenId) internal virtual {
1019         _tokenApprovals[tokenId] = to;
1020         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1025      * The call is not executed if the target address is not a contract.
1026      *
1027      * @param from address representing the previous owner of the given token ID
1028      * @param to target address that will receive the tokens
1029      * @param tokenId uint256 ID of the token to be transferred
1030      * @param _data bytes optional data to send along with the call
1031      * @return bool whether the call correctly returned the expected magic value
1032      */
1033     function _checkOnERC721Received(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) private returns (bool) {
1039         if (to.isContract()) {
1040             try
1041                 IERC721Receiver(to).onERC721Received(
1042                     _msgSender(),
1043                     from,
1044                     tokenId,
1045                     _data
1046                 )
1047             returns (bytes4 retval) {
1048                 return retval == IERC721Receiver.onERC721Received.selector;
1049             } catch (bytes memory reason) {
1050                 if (reason.length == 0) {
1051                     revert(
1052                         "ERC721: transfer to non ERC721Receiver implementer"
1053                     );
1054                 } else {
1055                     assembly {
1056                         revert(add(32, reason), mload(reason))
1057                     }
1058                 }
1059             }
1060         } else {
1061             return true;
1062         }
1063     }
1064 
1065     /**
1066      * @dev Hook that is called before any token transfer. This includes minting
1067      * and burning.
1068      *
1069      * Calling conditions:
1070      *
1071      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1072      * transferred to `to`.
1073      * - When `from` is zero, `tokenId` will be minted for `to`.
1074      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1075      * - `from` and `to` are never both zero.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual {}
1084 }
1085 
1086 //
1087 /**
1088  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1089  * @dev See https://eips.ethereum.org/EIPS/eip-721
1090  */
1091 interface IERC721Enumerable is IERC721 {
1092     /**
1093      * @dev Returns the total amount of tokens stored by the contract.
1094      */
1095     function totalSupply() external view returns (uint256);
1096 
1097     /**
1098      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1099      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1100      */
1101     function tokenOfOwnerByIndex(address owner, uint256 index)
1102         external
1103         view
1104         returns (uint256 tokenId);
1105 
1106     /**
1107      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1108      * Use along with {totalSupply} to enumerate all tokens.
1109      */
1110     function tokenByIndex(uint256 index) external view returns (uint256);
1111 }
1112 
1113 //
1114 /**
1115  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1116  * enumerability of all the token ids in the contract as well as all token ids owned by each
1117  * account.
1118  */
1119 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1120     // Mapping from owner to list of owned token IDs
1121     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1122 
1123     // Mapping from token ID to index of the owner tokens list
1124     mapping(uint256 => uint256) private _ownedTokensIndex;
1125 
1126     // Array with all token ids, used for enumeration
1127     uint256[] private _allTokens;
1128 
1129     // Mapping from token id to position in the allTokens array
1130     mapping(uint256 => uint256) private _allTokensIndex;
1131 
1132     /**
1133      * @dev See {IERC165-supportsInterface}.
1134      */
1135     function supportsInterface(bytes4 interfaceId)
1136         public
1137         view
1138         virtual
1139         override(IERC165, ERC721)
1140         returns (bool)
1141     {
1142         return
1143             interfaceId == type(IERC721Enumerable).interfaceId ||
1144             super.supportsInterface(interfaceId);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1149      */
1150     function tokenOfOwnerByIndex(address owner, uint256 index)
1151         public
1152         view
1153         virtual
1154         override
1155         returns (uint256)
1156     {
1157         require(
1158             index < ERC721.balanceOf(owner),
1159             "ERC721Enumerable: owner index out of bounds"
1160         );
1161         return _ownedTokens[owner][index];
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Enumerable-totalSupply}.
1166      */
1167     function totalSupply() public view virtual override returns (uint256) {
1168         return _allTokens.length;
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Enumerable-tokenByIndex}.
1173      */
1174     function tokenByIndex(uint256 index)
1175         public
1176         view
1177         virtual
1178         override
1179         returns (uint256)
1180     {
1181         require(
1182             index < ERC721Enumerable.totalSupply(),
1183             "ERC721Enumerable: global index out of bounds"
1184         );
1185         return _allTokens[index];
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before any token transfer. This includes minting
1190      * and burning.
1191      *
1192      * Calling conditions:
1193      *
1194      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1195      * transferred to `to`.
1196      * - When `from` is zero, `tokenId` will be minted for `to`.
1197      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1198      * - `from` cannot be the zero address.
1199      * - `to` cannot be the zero address.
1200      *
1201      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1202      */
1203     function _beforeTokenTransfer(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) internal virtual override {
1208         super._beforeTokenTransfer(from, to, tokenId);
1209 
1210         if (from == address(0)) {
1211             _addTokenToAllTokensEnumeration(tokenId);
1212         } else if (from != to) {
1213             _removeTokenFromOwnerEnumeration(from, tokenId);
1214         }
1215         if (to == address(0)) {
1216             _removeTokenFromAllTokensEnumeration(tokenId);
1217         } else if (to != from) {
1218             _addTokenToOwnerEnumeration(to, tokenId);
1219         }
1220     }
1221 
1222     /**
1223      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1224      * @param to address representing the new owner of the given token ID
1225      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1226      */
1227     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1228         uint256 length = ERC721.balanceOf(to);
1229         _ownedTokens[to][length] = tokenId;
1230         _ownedTokensIndex[tokenId] = length;
1231     }
1232 
1233     /**
1234      * @dev Private function to add a token to this extension's token tracking data structures.
1235      * @param tokenId uint256 ID of the token to be added to the tokens list
1236      */
1237     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1238         _allTokensIndex[tokenId] = _allTokens.length;
1239         _allTokens.push(tokenId);
1240     }
1241 
1242     /**
1243      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1244      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1245      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1246      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1247      * @param from address representing the previous owner of the given token ID
1248      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1249      */
1250     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1251         private
1252     {
1253         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1254         // then delete the last slot (swap and pop).
1255 
1256         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1257         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1258 
1259         // When the token to delete is the last token, the swap operation is unnecessary
1260         if (tokenIndex != lastTokenIndex) {
1261             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1262 
1263             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1264             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1265         }
1266 
1267         // This also deletes the contents at the last position of the array
1268         delete _ownedTokensIndex[tokenId];
1269         delete _ownedTokens[from][lastTokenIndex];
1270     }
1271 
1272     /**
1273      * @dev Private function to remove a token from this extension's token tracking data structures.
1274      * This has O(1) time complexity, but alters the order of the _allTokens array.
1275      * @param tokenId uint256 ID of the token to be removed from the tokens list
1276      */
1277     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1278         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1279         // then delete the last slot (swap and pop).
1280 
1281         uint256 lastTokenIndex = _allTokens.length - 1;
1282         uint256 tokenIndex = _allTokensIndex[tokenId];
1283 
1284         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1285         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1286         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1287         uint256 lastTokenId = _allTokens[lastTokenIndex];
1288 
1289         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1290         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1291 
1292         // This also deletes the contents at the last position of the array
1293         delete _allTokensIndex[tokenId];
1294         _allTokens.pop();
1295     }
1296 }
1297 
1298 //
1299 /**
1300  * @dev Contract module which allows children to implement an emergency stop
1301  * mechanism that can be triggered by an authorized account.
1302  *
1303  * This module is used through inheritance. It will make available the
1304  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1305  * the functions of your contract. Note that they will not be pausable by
1306  * simply including this module, only once the modifiers are put in place.
1307  */
1308 abstract contract Pausable is Context {
1309     /**
1310      * @dev Emitted when the pause is triggered by `account`.
1311      */
1312     event Paused(address account);
1313 
1314     /**
1315      * @dev Emitted when the pause is lifted by `account`.
1316      */
1317     event Unpaused(address account);
1318 
1319     bool private _paused;
1320 
1321     /**
1322      * @dev Initializes the contract in unpaused state.
1323      */
1324     constructor() {
1325         _paused = false;
1326     }
1327 
1328     /**
1329      * @dev Returns true if the contract is paused, and false otherwise.
1330      */
1331     function paused() public view virtual returns (bool) {
1332         return _paused;
1333     }
1334 
1335     /**
1336      * @dev Modifier to make a function callable only when the contract is not paused.
1337      *
1338      * Requirements:
1339      *
1340      * - The contract must not be paused.
1341      */
1342     modifier whenNotPaused() {
1343         require(!paused(), "Pausable: paused");
1344         _;
1345     }
1346 
1347     /**
1348      * @dev Modifier to make a function callable only when the contract is paused.
1349      *
1350      * Requirements:
1351      *
1352      * - The contract must be paused.
1353      */
1354     modifier whenPaused() {
1355         require(paused(), "Pausable: not paused");
1356         _;
1357     }
1358 
1359     /**
1360      * @dev Triggers stopped state.
1361      *
1362      * Requirements:
1363      *
1364      * - The contract must not be paused.
1365      */
1366     function _pause() internal virtual whenNotPaused {
1367         _paused = true;
1368         emit Paused(_msgSender());
1369     }
1370 
1371     /**
1372      * @dev Returns to normal state.
1373      *
1374      * Requirements:
1375      *
1376      * - The contract must be paused.
1377      */
1378     function _unpause() internal virtual whenPaused {
1379         _paused = false;
1380         emit Unpaused(_msgSender());
1381     }
1382 }
1383 
1384 //
1385 /**
1386  * @dev ERC721 token with pausable token transfers, minting and burning.
1387  *
1388  * Useful for scenarios such as preventing trades until the end of an evaluation
1389  * period, or having an emergency switch for freezing all token transfers in the
1390  * event of a large bug.
1391  */
1392 abstract contract ERC721Pausable is ERC721, Pausable {
1393     /**
1394      * @dev See {ERC721-_beforeTokenTransfer}.
1395      *
1396      * Requirements:
1397      *
1398      * - the contract must not be paused.
1399      */
1400     function _beforeTokenTransfer(
1401         address from,
1402         address to,
1403         uint256 tokenId
1404     ) internal virtual override {
1405         super._beforeTokenTransfer(from, to, tokenId);
1406 
1407         require(!paused(), "ERC721Pausable: token transfer while paused");
1408     }
1409 }
1410 
1411 //
1412 /**
1413  * @dev ERC721 token with storage based token URI management.
1414  */
1415 abstract contract ERC721URIStorage is ERC721 {
1416     using Strings for uint256;
1417 
1418     // Optional mapping for token URIs
1419     mapping(uint256 => string) private _tokenURIs;
1420 
1421     /**
1422      * @dev See {IERC721Metadata-tokenURI}.
1423      */
1424     function tokenURI(uint256 tokenId)
1425         public
1426         view
1427         virtual
1428         override
1429         returns (string memory)
1430     {
1431         require(
1432             _exists(tokenId),
1433             "ERC721URIStorage: URI query for nonexistent token"
1434         );
1435 
1436         string memory _tokenURI = _tokenURIs[tokenId];
1437         string memory base = _baseURI();
1438 
1439         // If there is no base URI, return the token URI.
1440         if (bytes(base).length == 0) {
1441             return _tokenURI;
1442         }
1443         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1444         if (bytes(_tokenURI).length > 0) {
1445             return string(abi.encodePacked(base, _tokenURI));
1446         }
1447 
1448         return super.tokenURI(tokenId);
1449     }
1450 
1451     /**
1452      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1453      *
1454      * Requirements:
1455      *
1456      * - `tokenId` must exist.
1457      */
1458     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
1459         internal
1460         virtual
1461     {
1462         require(
1463             _exists(tokenId),
1464             "ERC721URIStorage: URI set of nonexistent token"
1465         );
1466         _tokenURIs[tokenId] = _tokenURI;
1467     }
1468 
1469     /**
1470      * @dev Destroys `tokenId`.
1471      * The approval is cleared when the token is burned.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function _burn(uint256 tokenId) internal virtual override {
1480         super._burn(tokenId);
1481 
1482         if (bytes(_tokenURIs[tokenId]).length != 0) {
1483             delete _tokenURIs[tokenId];
1484         }
1485     }
1486 }
1487 
1488 //
1489 /**
1490  * @dev Contract module which provides a basic access control mechanism, where
1491  * there is an account (an owner) that can be granted exclusive access to
1492  * specific functions.
1493  *
1494  * By default, the owner account will be the one that deploys the contract. This
1495  * can later be changed with {transferOwnership}.
1496  *
1497  * This module is used through inheritance. It will make available the modifier
1498  * `onlyOwner`, which can be applied to your functions to restrict their use to
1499  * the owner.
1500  */
1501 abstract contract Ownable is Context {
1502     address private _owner;
1503 
1504     event OwnershipTransferred(
1505         address indexed previousOwner,
1506         address indexed newOwner
1507     );
1508 
1509     /**
1510      * @dev Initializes the contract setting the deployer as the initial owner.
1511      */
1512     constructor() {
1513         _setOwner(_msgSender());
1514     }
1515 
1516     /**
1517      * @dev Returns the address of the current owner.
1518      */
1519     function owner() public view virtual returns (address) {
1520         return _owner;
1521     }
1522 
1523     /**
1524      * @dev Throws if called by any account other than the owner.
1525      */
1526     modifier onlyOwner() {
1527         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1528         _;
1529     }
1530 
1531     /**
1532      * @dev Leaves the contract without owner. It will not be possible to call
1533      * `onlyOwner` functions anymore. Can only be called by the current owner.
1534      *
1535      * NOTE: Renouncing ownership will leave the contract without an owner,
1536      * thereby removing any functionality that is only available to the owner.
1537      */
1538     function renounceOwnership() public virtual onlyOwner {
1539         _setOwner(address(0));
1540     }
1541 
1542     /**
1543      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1544      * Can only be called by the current owner.
1545      */
1546     function transferOwnership(address newOwner) public virtual onlyOwner {
1547         require(
1548             newOwner != address(0),
1549             "Ownable: new owner is the zero address"
1550         );
1551         _setOwner(newOwner);
1552     }
1553 
1554     function _setOwner(address newOwner) private {
1555         address oldOwner = _owner;
1556         _owner = newOwner;
1557         emit OwnershipTransferred(oldOwner, newOwner);
1558     }
1559 }
1560 
1561 //
1562 /**
1563  * @dev Contract module that helps prevent reentrant calls to a function.
1564  *
1565  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1566  * available, which can be applied to functions to make sure there are no nested
1567  * (reentrant) calls to them.
1568  *
1569  * Note that because there is a single `nonReentrant` guard, functions marked as
1570  * `nonReentrant` may not call one another. This can be worked around by making
1571  * those functions `private`, and then adding `external` `nonReentrant` entry
1572  * points to them.
1573  *
1574  * TIP: If you would like to learn more about reentrancy and alternative ways
1575  * to protect against it, check out our blog post
1576  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1577  */
1578 abstract contract ReentrancyGuard {
1579     // Booleans are more expensive than uint256 or any type that takes up a full
1580     // word because each write operation emits an extra SLOAD to first read the
1581     // slot's contents, replace the bits taken up by the boolean, and then write
1582     // back. This is the compiler's defense against contract upgrades and
1583     // pointer aliasing, and it cannot be disabled.
1584 
1585     // The values being non-zero value makes deployment a bit more expensive,
1586     // but in exchange the refund on every call to nonReentrant will be lower in
1587     // amount. Since refunds are capped to a percentage of the total
1588     // transaction's gas, it is best to keep them low in cases like this one, to
1589     // increase the likelihood of the full refund coming into effect.
1590     uint256 private constant _NOT_ENTERED = 1;
1591     uint256 private constant _ENTERED = 2;
1592 
1593     uint256 private _status;
1594 
1595     constructor() {
1596         _status = _NOT_ENTERED;
1597     }
1598 
1599     /**
1600      * @dev Prevents a contract from calling itself, directly or indirectly.
1601      * Calling a `nonReentrant` function from another `nonReentrant`
1602      * function is not supported. It is possible to prevent this from happening
1603      * by making the `nonReentrant` function external, and make it call a
1604      * `private` function that does the actual work.
1605      */
1606     modifier nonReentrant() {
1607         // On the first call to nonReentrant, _notEntered will be true
1608         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1609 
1610         // Any calls to nonReentrant after this point will fail
1611         _status = _ENTERED;
1612 
1613         _;
1614 
1615         // By storing the original value once again, a refund is triggered (see
1616         // https://eips.ethereum.org/EIPS/eip-2200)
1617         _status = _NOT_ENTERED;
1618     }
1619 }
1620 
1621 //
1622 contract OwnableDelegateProxy {
1623 
1624 }
1625 
1626 contract ProxyRegistry {
1627     mapping(address => OwnableDelegateProxy) public proxies;
1628 }
1629 
1630 interface Toadz {
1631     function ownerOf(uint256 tokenId) external view returns (address owner);
1632 }
1633 
1634 contract Choadz is
1635     ERC721,
1636     ERC721Enumerable,
1637     ERC721URIStorage,
1638     Ownable,
1639     Pausable,
1640     ReentrancyGuard
1641 {
1642     using Strings for string;
1643 
1644     bool public _mintingAllowed = false;
1645     bool public _onlyToadz = true;
1646     address _proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1647     address public _toadzContractAddress =
1648         0x1CB1A5e65610AEFF2551A50f76a87a7d3fB649C6;
1649     uint256 public _mintFee = 42000000000000000;
1650     uint256 public _maxSupply = 6969;
1651     string internal _baseTokenUri;
1652     mapping(uint256 => bool) public specialToadz;
1653 
1654     Toadz internal toadzContract = Toadz(_toadzContractAddress);
1655 
1656     event Minted(address indexed account, uint256 toadId);
1657     event Received(address indexed account, uint256 value);
1658 
1659     constructor() ERC721("Choadz", "CHOADZ") {}
1660 
1661     function mint(uint256 toadId, string memory code)
1662         public
1663         payable
1664         nonReentrant
1665     {
1666         require(isVibe(code), "Not So Secret Code Invalid");
1667         require(_mintingAllowed, "Minting Not Allowed");
1668         require(totalSupply() < _maxSupply, "All Choadz Claimed");
1669         require(toadId > 0, "Out of Range");
1670         require(toadId <= _maxSupply, "Out of Range");
1671         require(_mintFee <= msg.value, "Minimum ETH Not Met");
1672         if (_onlyToadz) {
1673             require(
1674                 toadzContract.ownerOf(toadId) == msg.sender,
1675                 "Not Your Toad"
1676             );
1677         }
1678         require(!_exists(toadId), "Choad already minted");
1679 
1680         _safeMint(_msgSender(), toadId);
1681         emit Minted(_msgSender(), toadId);
1682     }
1683 
1684     function mintMultiple(uint256[] memory toadIds, string memory code)
1685         public
1686         payable
1687         nonReentrant
1688     {
1689         require(isVibe(code), "Not So Secret Code Invalid");
1690         require(_mintingAllowed, "Minting Not Allowed");
1691         require(totalSupply() < _maxSupply, "All Choadz Claimed");
1692         require(
1693             (_mintFee * toadIds.length) <= msg.value,
1694             "Minimum ETH Not Met"
1695         );
1696 
1697         for (uint256 i = 0; i < toadIds.length; i++) {
1698             require(toadIds[i] > 0, "Out of Range");
1699             require(toadIds[i] <= _maxSupply, "Out of Range");
1700             if (_onlyToadz) {
1701                 require(
1702                     toadzContract.ownerOf(toadIds[i]) == msg.sender,
1703                     "Not Your Toad"
1704                 );
1705             }
1706             require(!_exists(toadIds[i]), "Choad already minted");
1707             _safeMint(_msgSender(), toadIds[i]);
1708             emit Minted(_msgSender(), toadIds[i]);
1709         }
1710     }
1711 
1712     function mintSpecial(uint256 toadId, string memory code)
1713         public
1714         payable
1715         nonReentrant
1716     {
1717         require(isVibe(code), "Code Invalid");
1718         require(_mintingAllowed, "Minting Not Allowed");
1719         require(specialToadz[toadId], "Not A Special Toad");
1720         require(_mintFee <= msg.value, "Minimum ETH Not Met");
1721         if (_onlyToadz) {
1722             require(
1723                 toadzContract.ownerOf(toadId) == msg.sender,
1724                 "Not Your Toad"
1725             );
1726         }
1727         require(!_exists(toadId), "Choad already minted");
1728 
1729         _safeMint(_msgSender(), toadId);
1730         emit Minted(_msgSender(), toadId);
1731     }
1732 
1733     function reserve(uint256 choadId) public onlyOwner {
1734         require(!_exists(choadId), "Choad already minted");
1735 
1736         _safeMint(_msgSender(), choadId);
1737         emit Minted(_msgSender(), choadId);
1738     }
1739 
1740     function isVibe(string memory _command) public pure returns (bool) {
1741         require(
1742             keccak256(abi.encodePacked(_command)) ==
1743                 keccak256(abi.encodePacked("!vibe")),
1744             "Ribbit"
1745         );
1746         return true;
1747     }
1748 
1749     receive() external payable {
1750         emit Received(_msgSender(), msg.value);
1751     }
1752 
1753     function setBaseURI(string memory baseUri) external onlyOwner {
1754         _baseTokenUri = baseUri;
1755     }
1756 
1757     function setMintFee(uint256 fee) external onlyOwner {
1758         _mintFee = fee;
1759     }
1760 
1761     function flipMintState() public onlyOwner {
1762         _mintingAllowed = !_mintingAllowed;
1763     }
1764 
1765     function flipPrivateSale() public onlyOwner {
1766         _onlyToadz = !_onlyToadz;
1767     }
1768 
1769     function pause() public virtual onlyOwner {
1770         _pause();
1771     }
1772 
1773     function unpause() public virtual onlyOwner {
1774         _unpause();
1775     }
1776 
1777     function withdraw() public payable onlyOwner {
1778         require(
1779             payable(_msgSender()).send(address(this).balance),
1780             "Unable to Withdraw ETH"
1781         );
1782     }
1783 
1784     function _addSpecialToad(uint256 toadId) internal returns (bool success) {
1785         if (!specialToadz[toadId]) {
1786             specialToadz[toadId] = true;
1787             return success = true;
1788         }
1789     }
1790 
1791     function addSpecialToadz(uint256[] memory toadIds)
1792         public
1793         onlyOwner
1794         returns (bool success)
1795     {
1796         for (uint256 i = 0; i < toadIds.length; i++) {
1797             if (_addSpecialToad(toadIds[i])) {
1798                 success = true;
1799             }
1800         }
1801     }
1802 
1803     function _removeSpecialToad(uint256 toadId)
1804         internal
1805         returns (bool success)
1806     {
1807         if (specialToadz[toadId]) {
1808             specialToadz[toadId] = false;
1809             success = true;
1810         }
1811     }
1812 
1813     function removeSpecialToadz(uint256[] memory toadIds)
1814         public
1815         onlyOwner
1816         returns (bool success)
1817     {
1818         for (uint256 i = 0; i < toadIds.length; i++) {
1819             if (_removeSpecialToad(toadIds[i])) {
1820                 success = true;
1821             }
1822         }
1823     }
1824 
1825     function ownersChoadz(address _owner)
1826         external
1827         view
1828         returns (uint256[] memory)
1829     {
1830         uint256 choads = balanceOf(_owner);
1831         if (choads == 0) {
1832             return new uint256[](0);
1833         } else {
1834             uint256[] memory result = new uint256[](choads);
1835             uint256 index;
1836             for (index = 0; index < choads; index++) {
1837                 result[index] = tokenOfOwnerByIndex(_owner, index);
1838             }
1839             return result;
1840         }
1841     }
1842 
1843     function _burn(uint256 tokenId)
1844         internal
1845         override(ERC721, ERC721URIStorage)
1846     {
1847         super._burn(tokenId);
1848     }
1849 
1850     function tokenURI(uint256 _choadId)
1851         public
1852         view
1853         override(ERC721, ERC721URIStorage)
1854         returns (string memory)
1855     {
1856         require(_exists(_choadId), "Choad Doesn't Exist");
1857         return string(abi.encodePacked(_baseTokenUri, "/", uint2str(_choadId)));
1858     }
1859 
1860     function _beforeTokenTransfer(
1861         address from,
1862         address to,
1863         uint256 tokenId
1864     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1865         super._beforeTokenTransfer(from, to, tokenId);
1866     }
1867 
1868     function supportsInterface(bytes4 interfaceId)
1869         public
1870         view
1871         override(ERC721, ERC721Enumerable)
1872         returns (bool)
1873     {
1874         return super.supportsInterface(interfaceId);
1875     }
1876 
1877     function isApprovedForAll(address owner, address operator)
1878         public
1879         view
1880         override
1881         returns (bool)
1882     {
1883         ProxyRegistry proxyRegistry = ProxyRegistry(_proxyRegistryAddress);
1884 
1885         if (address(proxyRegistry.proxies(owner)) == operator) {
1886             return true;
1887         }
1888         return super.isApprovedForAll(owner, operator);
1889     }
1890 
1891     function uint2str(uint256 _i)
1892         internal
1893         pure
1894         returns (string memory _uintAsString)
1895     {
1896         if (_i == 0) {
1897             return "0";
1898         }
1899         uint256 j = _i;
1900         uint256 len;
1901         while (j != 0) {
1902             len++;
1903             j /= 10;
1904         }
1905         bytes memory bstr = new bytes(len);
1906         uint256 k = len;
1907         while (_i != 0) {
1908             k = k - 1;
1909             uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
1910             bytes1 b1 = bytes1(temp);
1911             bstr[k] = b1;
1912             _i /= 10;
1913         }
1914         return string(bstr);
1915     }
1916 }