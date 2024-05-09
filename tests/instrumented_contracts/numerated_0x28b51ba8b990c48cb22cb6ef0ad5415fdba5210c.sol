1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(
40         address indexed from,
41         address indexed to,
42         uint256 indexed tokenId
43     );
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(
49         address indexed owner,
50         address indexed approved,
51         uint256 indexed tokenId
52     );
53 
54     /**
55      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
56      */
57     event ApprovalForAll(
58         address indexed owner,
59         address indexed operator,
60         bool approved
61     );
62 
63     /**
64      * @dev Returns the number of tokens in ``owner``'s account.
65      */
66     function balanceOf(address owner) external view returns (uint256 balance);
67 
68     /**
69      * @dev Returns the owner of the `tokenId` token.
70      *
71      * Requirements:
72      *
73      * - `tokenId` must exist.
74      */
75     function ownerOf(uint256 tokenId) external view returns (address owner);
76 
77     /**
78      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
79      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must exist and be owned by `from`.
86      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
87      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
88      *
89      * Emits a {Transfer} event.
90      */
91     function safeTransferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Transfers `tokenId` token from `from` to `to`.
99      *
100      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must be owned by `from`.
107      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address from,
113         address to,
114         uint256 tokenId
115     ) external;
116 
117     /**
118      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
119      * The approval is cleared when the token is transferred.
120      *
121      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
122      *
123      * Requirements:
124      *
125      * - The caller must own the token or be an approved operator.
126      * - `tokenId` must exist.
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Returns the account approved for `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function getApproved(uint256 tokenId)
140         external
141         view
142         returns (address operator);
143 
144     /**
145      * @dev Approve or remove `operator` as an operator for the caller.
146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147      *
148      * Requirements:
149      *
150      * - The `operator` cannot be the caller.
151      *
152      * Emits an {ApprovalForAll} event.
153      */
154     function setApprovalForAll(address operator, bool _approved) external;
155 
156     /**
157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158      *
159      * See {setApprovalForAll}
160      */
161     function isApprovedForAll(address owner, address operator)
162         external
163         view
164         returns (bool);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 }
186 
187 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @title ERC721 token receiver interface
193  * @dev Interface for any contract that wants to support safeTransfers
194  * from ERC721 asset contracts.
195  */
196 interface IERC721Receiver {
197     /**
198      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
199      * by `operator` from `from`, this function is called.
200      *
201      * It must return its Solidity selector to confirm the token transfer.
202      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
203      *
204      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
205      */
206     function onERC721Received(
207         address operator,
208         address from,
209         uint256 tokenId,
210         bytes calldata data
211     ) external returns (bytes4);
212 }
213 
214 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
220  * @dev See https://eips.ethereum.org/EIPS/eip-721
221  */
222 interface IERC721Metadata is IERC721 {
223     /**
224      * @dev Returns the token collection name.
225      */
226     function name() external view returns (string memory);
227 
228     /**
229      * @dev Returns the token collection symbol.
230      */
231     function symbol() external view returns (string memory);
232 
233     /**
234      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
235      */
236     function tokenURI(uint256 tokenId) external view returns (string memory);
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         assembly {
271             size := extcodesize(account)
272         }
273         return size > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(
294             address(this).balance >= amount,
295             "Address: insufficient balance"
296         );
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(
300             success,
301             "Address: unable to send value, recipient may have reverted"
302         );
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data)
324         internal
325         returns (bytes memory)
326     {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return
361             functionCallWithValue(
362                 target,
363                 data,
364                 value,
365                 "Address: low-level call with value failed"
366             );
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(
382             address(this).balance >= value,
383             "Address: insufficient balance for call"
384         );
385         require(isContract(target), "Address: call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.call{value: value}(
388             data
389         );
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(address target, bytes memory data)
400         internal
401         view
402         returns (bytes memory)
403     {
404         return
405             functionStaticCall(
406                 target,
407                 data,
408                 "Address: low-level static call failed"
409             );
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal view returns (bytes memory) {
423         require(isContract(target), "Address: static call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.staticcall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(address target, bytes memory data)
436         internal
437         returns (bytes memory)
438     {
439         return
440             functionDelegateCall(
441                 target,
442                 data,
443                 "Address: low-level delegate call failed"
444             );
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
466      * revert reason using the provided one.
467      *
468      * _Available since v4.3._
469      */
470     function verifyCallResult(
471         bool success,
472         bytes memory returndata,
473         string memory errorMessage
474     ) internal pure returns (bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 assembly {
483                     let returndata_size := mload(returndata)
484                     revert(add(32, returndata), returndata_size)
485                 }
486             } else {
487                 revert(errorMessage);
488             }
489         }
490     }
491 }
492 
493 // File: @openzeppelin/contracts/utils/Context.sol
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev Provides information about the current execution context, including the
499  * sender of the transaction and its data. While these are generally available
500  * via msg.sender and msg.data, they should not be accessed in such a direct
501  * manner, since when dealing with meta-transactions the account sending and
502  * paying for execution may not be the actual sender (as far as an application
503  * is concerned).
504  *
505  * This contract is only required for intermediate, library-like contracts.
506  */
507 abstract contract Context {
508     function _msgSender() internal view virtual returns (address) {
509         return msg.sender;
510     }
511 
512     function _msgData() internal view virtual returns (bytes calldata) {
513         return msg.data;
514     }
515 }
516 
517 // File: @openzeppelin/contracts/utils/Strings.sol
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev String operations.
523  */
524 library Strings {
525     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
529      */
530     function toString(uint256 value) internal pure returns (string memory) {
531         // Inspired by OraclizeAPI's implementation - MIT licence
532         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
533 
534         if (value == 0) {
535             return "0";
536         }
537         uint256 temp = value;
538         uint256 digits;
539         while (temp != 0) {
540             digits++;
541             temp /= 10;
542         }
543         bytes memory buffer = new bytes(digits);
544         while (value != 0) {
545             digits -= 1;
546             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
547             value /= 10;
548         }
549         return string(buffer);
550     }
551 
552     /**
553      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
554      */
555     function toHexString(uint256 value) internal pure returns (string memory) {
556         if (value == 0) {
557             return "0x00";
558         }
559         uint256 temp = value;
560         uint256 length = 0;
561         while (temp != 0) {
562             length++;
563             temp >>= 8;
564         }
565         return toHexString(value, length);
566     }
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
570      */
571     function toHexString(uint256 value, uint256 length)
572         internal
573         pure
574         returns (string memory)
575     {
576         bytes memory buffer = new bytes(2 * length + 2);
577         buffer[0] = "0";
578         buffer[1] = "x";
579         for (uint256 i = 2 * length + 1; i > 1; --i) {
580             buffer[i] = _HEX_SYMBOLS[value & 0xf];
581             value >>= 4;
582         }
583         require(value == 0, "Strings: hex length insufficient");
584         return string(buffer);
585     }
586 }
587 
588 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Implementation of the {IERC165} interface.
594  *
595  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
596  * for the additional interface id that will be supported. For example:
597  *
598  * ```solidity
599  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
601  * }
602  * ```
603  *
604  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
605  */
606 abstract contract ERC165 is IERC165 {
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId)
611         public
612         view
613         virtual
614         override
615         returns (bool)
616     {
617         return interfaceId == type(IERC165).interfaceId;
618     }
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
627  * the Metadata extension, but not including the Enumerable extension, which is available separately as
628  * {ERC721Enumerable}.
629  */
630 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
631     using Address for address;
632     using Strings for uint256;
633 
634     // Token name
635     string private _name;
636 
637     // Token symbol
638     string private _symbol;
639 
640     // Mapping from token ID to owner address
641     mapping(uint256 => address) private _owners;
642 
643     // Mapping owner address to token count
644     mapping(address => uint256) private _balances;
645 
646     // Mapping from token ID to approved address
647     mapping(uint256 => address) private _tokenApprovals;
648 
649     // Mapping from owner to operator approvals
650     mapping(address => mapping(address => bool)) private _operatorApprovals;
651 
652     /**
653      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
654      */
655     constructor(string memory name_, string memory symbol_) {
656         _name = name_;
657         _symbol = symbol_;
658     }
659 
660     /**
661      * @dev See {IERC165-supportsInterface}.
662      */
663     function supportsInterface(bytes4 interfaceId)
664         public
665         view
666         virtual
667         override(ERC165, IERC165)
668         returns (bool)
669     {
670         return
671             interfaceId == type(IERC721).interfaceId ||
672             interfaceId == type(IERC721Metadata).interfaceId ||
673             super.supportsInterface(interfaceId);
674     }
675 
676     /**
677      * @dev See {IERC721-balanceOf}.
678      */
679     function balanceOf(address owner)
680         public
681         view
682         virtual
683         override
684         returns (uint256)
685     {
686         require(
687             owner != address(0),
688             "ERC721: balance query for the zero address"
689         );
690         return _balances[owner];
691     }
692 
693     /**
694      * @dev See {IERC721-ownerOf}.
695      */
696     function ownerOf(uint256 tokenId)
697         public
698         view
699         virtual
700         override
701         returns (address)
702     {
703         address owner = _owners[tokenId];
704         require(
705             owner != address(0),
706             "ERC721: owner query for nonexistent token"
707         );
708         return owner;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-name}.
713      */
714     function name() public view virtual override returns (string memory) {
715         return _name;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-symbol}.
720      */
721     function symbol() public view virtual override returns (string memory) {
722         return _symbol;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-tokenURI}.
727      */
728     function tokenURI(uint256 tokenId)
729         public
730         view
731         virtual
732         override
733         returns (string memory)
734     {
735         require(
736             _exists(tokenId),
737             "ERC721Metadata: URI query for nonexistent token"
738         );
739 
740         string memory baseURI = _baseURI();
741         return
742             bytes(baseURI).length > 0
743                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
744                 : "";
745     }
746 
747     /**
748      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
749      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
750      * by default, can be overriden in child contracts.
751      */
752     function _baseURI() internal view virtual returns (string memory) {
753         return "";
754     }
755 
756     /**
757      * @dev See {IERC721-approve}.
758      */
759     function approve(address to, uint256 tokenId) public virtual override {
760         address owner = ERC721.ownerOf(tokenId);
761         require(to != owner, "ERC721: approval to current owner");
762 
763         require(
764             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
765             "ERC721: approve caller is not owner nor approved for all"
766         );
767 
768         _approve(to, tokenId);
769     }
770 
771     /**
772      * @dev See {IERC721-getApproved}.
773      */
774     function getApproved(uint256 tokenId)
775         public
776         view
777         virtual
778         override
779         returns (address)
780     {
781         require(
782             _exists(tokenId),
783             "ERC721: approved query for nonexistent token"
784         );
785 
786         return _tokenApprovals[tokenId];
787     }
788 
789     /**
790      * @dev See {IERC721-setApprovalForAll}.
791      */
792     function setApprovalForAll(address operator, bool approved)
793         public
794         virtual
795         override
796     {
797         require(operator != _msgSender(), "ERC721: approve to caller");
798 
799         _operatorApprovals[_msgSender()][operator] = approved;
800         emit ApprovalForAll(_msgSender(), operator, approved);
801     }
802 
803     /**
804      * @dev See {IERC721-isApprovedForAll}.
805      */
806     function isApprovedForAll(address owner, address operator)
807         public
808         view
809         virtual
810         override
811         returns (bool)
812     {
813         return _operatorApprovals[owner][operator];
814     }
815 
816     /**
817      * @dev See {IERC721-transferFrom}.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) public virtual override {
824         //solhint-disable-next-line max-line-length
825         require(
826             _isApprovedOrOwner(_msgSender(), tokenId),
827             "ERC721: transfer caller is not owner nor approved"
828         );
829 
830         _transfer(from, to, tokenId);
831     }
832 
833     /**
834      * @dev See {IERC721-safeTransferFrom}.
835      */
836     function safeTransferFrom(
837         address from,
838         address to,
839         uint256 tokenId
840     ) public virtual override {
841         safeTransferFrom(from, to, tokenId, "");
842     }
843 
844     /**
845      * @dev See {IERC721-safeTransferFrom}.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) public virtual override {
853         require(
854             _isApprovedOrOwner(_msgSender(), tokenId),
855             "ERC721: transfer caller is not owner nor approved"
856         );
857         _safeTransfer(from, to, tokenId, _data);
858     }
859 
860     /**
861      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
862      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
863      *
864      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
865      *
866      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
867      * implement alternative mechanisms to perform token transfer, such as signature-based.
868      *
869      * Requirements:
870      *
871      * - `from` cannot be the zero address.
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must exist and be owned by `from`.
874      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _safeTransfer(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) internal virtual {
884         _transfer(from, to, tokenId);
885         require(
886             _checkOnERC721Received(from, to, tokenId, _data),
887             "ERC721: transfer to non ERC721Receiver implementer"
888         );
889     }
890 
891     /**
892      * @dev Returns whether `tokenId` exists.
893      *
894      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
895      *
896      * Tokens start existing when they are minted (`_mint`),
897      * and stop existing when they are burned (`_burn`).
898      */
899     function _exists(uint256 tokenId) internal view virtual returns (bool) {
900         return _owners[tokenId] != address(0);
901     }
902 
903     /**
904      * @dev Returns whether `spender` is allowed to manage `tokenId`.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      */
910     function _isApprovedOrOwner(address spender, uint256 tokenId)
911         internal
912         view
913         virtual
914         returns (bool)
915     {
916         require(
917             _exists(tokenId),
918             "ERC721: operator query for nonexistent token"
919         );
920         address owner = ERC721.ownerOf(tokenId);
921         return (spender == owner ||
922             getApproved(tokenId) == spender ||
923             isApprovedForAll(owner, spender));
924     }
925 
926     /**
927      * @dev Safely mints `tokenId` and transfers it to `to`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(address to, uint256 tokenId) internal virtual {
937         _safeMint(to, tokenId, "");
938     }
939 
940     /**
941      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
942      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
943      */
944     function _safeMint(
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) internal virtual {
949         _mint(to, tokenId);
950         require(
951             _checkOnERC721Received(address(0), to, tokenId, _data),
952             "ERC721: transfer to non ERC721Receiver implementer"
953         );
954     }
955 
956     /**
957      * @dev Mints `tokenId` and transfers it to `to`.
958      *
959      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - `to` cannot be the zero address.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(address to, uint256 tokenId) internal virtual {
969         require(to != address(0), "ERC721: mint to the zero address");
970         require(!_exists(tokenId), "ERC721: token already minted");
971 
972         _beforeTokenTransfer(address(0), to, tokenId);
973 
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(address(0), to, tokenId);
978     }
979 
980     /**
981      * @dev Destroys `tokenId`.
982      * The approval is cleared when the token is burned.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _burn(uint256 tokenId) internal virtual {
991         address owner = ERC721.ownerOf(tokenId);
992 
993         _beforeTokenTransfer(owner, address(0), tokenId);
994 
995         // Clear approvals
996         _approve(address(0), tokenId);
997 
998         _balances[owner] -= 1;
999         delete _owners[tokenId];
1000 
1001         emit Transfer(owner, address(0), tokenId);
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _transfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {
1020         require(
1021             ERC721.ownerOf(tokenId) == from,
1022             "ERC721: transfer of token that is not own"
1023         );
1024         require(to != address(0), "ERC721: transfer to the zero address");
1025 
1026         _beforeTokenTransfer(from, to, tokenId);
1027 
1028         // Clear approvals from the previous owner
1029         _approve(address(0), tokenId);
1030 
1031         _balances[from] -= 1;
1032         _balances[to] += 1;
1033         _owners[tokenId] = to;
1034 
1035         emit Transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev Approve `to` to operate on `tokenId`
1040      *
1041      * Emits a {Approval} event.
1042      */
1043     function _approve(address to, uint256 tokenId) internal virtual {
1044         _tokenApprovals[tokenId] = to;
1045         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1050      * The call is not executed if the target address is not a contract.
1051      *
1052      * @param from address representing the previous owner of the given token ID
1053      * @param to target address that will receive the tokens
1054      * @param tokenId uint256 ID of the token to be transferred
1055      * @param _data bytes optional data to send along with the call
1056      * @return bool whether the call correctly returned the expected magic value
1057      */
1058     function _checkOnERC721Received(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) private returns (bool) {
1064         if (to.isContract()) {
1065             try
1066                 IERC721Receiver(to).onERC721Received(
1067                     _msgSender(),
1068                     from,
1069                     tokenId,
1070                     _data
1071                 )
1072             returns (bytes4 retval) {
1073                 return retval == IERC721Receiver.onERC721Received.selector;
1074             } catch (bytes memory reason) {
1075                 if (reason.length == 0) {
1076                     revert(
1077                         "ERC721: transfer to non ERC721Receiver implementer"
1078                     );
1079                 } else {
1080                     assembly {
1081                         revert(add(32, reason), mload(reason))
1082                     }
1083                 }
1084             }
1085         } else {
1086             return true;
1087         }
1088     }
1089 
1090     /**
1091      * @dev Hook that is called before any token transfer. This includes minting
1092      * and burning.
1093      *
1094      * Calling conditions:
1095      *
1096      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1097      * transferred to `to`.
1098      * - When `from` is zero, `tokenId` will be minted for `to`.
1099      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1100      * - `from` and `to` are never both zero.
1101      *
1102      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1103      */
1104     function _beforeTokenTransfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) internal virtual {}
1109 }
1110 
1111 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 /**
1116  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1117  * @dev See https://eips.ethereum.org/EIPS/eip-721
1118  */
1119 interface IERC721Enumerable is IERC721 {
1120     /**
1121      * @dev Returns the total amount of tokens stored by the contract.
1122      */
1123     function totalSupply() external view returns (uint256);
1124 
1125     /**
1126      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1127      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1128      */
1129     function tokenOfOwnerByIndex(address owner, uint256 index)
1130         external
1131         view
1132         returns (uint256 tokenId);
1133 
1134     /**
1135      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1136      * Use along with {totalSupply} to enumerate all tokens.
1137      */
1138     function tokenByIndex(uint256 index) external view returns (uint256);
1139 }
1140 
1141 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 /**
1146  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1147  * enumerability of all the token ids in the contract as well as all token ids owned by each
1148  * account.
1149  */
1150 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1151     // Mapping from owner to list of owned token IDs
1152     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1153 
1154     // Mapping from token ID to index of the owner tokens list
1155     mapping(uint256 => uint256) private _ownedTokensIndex;
1156 
1157     // Array with all token ids, used for enumeration
1158     uint256[] private _allTokens;
1159 
1160     // Mapping from token id to position in the allTokens array
1161     mapping(uint256 => uint256) private _allTokensIndex;
1162 
1163     /**
1164      * @dev See {IERC165-supportsInterface}.
1165      */
1166     function supportsInterface(bytes4 interfaceId)
1167         public
1168         view
1169         virtual
1170         override(IERC165, ERC721)
1171         returns (bool)
1172     {
1173         return
1174             interfaceId == type(IERC721Enumerable).interfaceId ||
1175             super.supportsInterface(interfaceId);
1176     }
1177 
1178     /**
1179      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1180      */
1181     function tokenOfOwnerByIndex(address owner, uint256 index)
1182         public
1183         view
1184         virtual
1185         override
1186         returns (uint256)
1187     {
1188         require(
1189             index < ERC721.balanceOf(owner),
1190             "ERC721Enumerable: owner index out of bounds"
1191         );
1192         return _ownedTokens[owner][index];
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Enumerable-totalSupply}.
1197      */
1198     function totalSupply() public view virtual override returns (uint256) {
1199         return _allTokens.length;
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Enumerable-tokenByIndex}.
1204      */
1205     function tokenByIndex(uint256 index)
1206         public
1207         view
1208         virtual
1209         override
1210         returns (uint256)
1211     {
1212         require(
1213             index < ERC721Enumerable.totalSupply(),
1214             "ERC721Enumerable: global index out of bounds"
1215         );
1216         return _allTokens[index];
1217     }
1218 
1219     /**
1220      * @dev Hook that is called before any token transfer. This includes minting
1221      * and burning.
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` will be minted for `to`.
1228      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1229      * - `from` cannot be the zero address.
1230      * - `to` cannot be the zero address.
1231      *
1232      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1233      */
1234     function _beforeTokenTransfer(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) internal virtual override {
1239         super._beforeTokenTransfer(from, to, tokenId);
1240 
1241         if (from == address(0)) {
1242             _addTokenToAllTokensEnumeration(tokenId);
1243         } else if (from != to) {
1244             _removeTokenFromOwnerEnumeration(from, tokenId);
1245         }
1246         if (to == address(0)) {
1247             _removeTokenFromAllTokensEnumeration(tokenId);
1248         } else if (to != from) {
1249             _addTokenToOwnerEnumeration(to, tokenId);
1250         }
1251     }
1252 
1253     /**
1254      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1255      * @param to address representing the new owner of the given token ID
1256      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1257      */
1258     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1259         uint256 length = ERC721.balanceOf(to);
1260         _ownedTokens[to][length] = tokenId;
1261         _ownedTokensIndex[tokenId] = length;
1262     }
1263 
1264     /**
1265      * @dev Private function to add a token to this extension's token tracking data structures.
1266      * @param tokenId uint256 ID of the token to be added to the tokens list
1267      */
1268     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1269         _allTokensIndex[tokenId] = _allTokens.length;
1270         _allTokens.push(tokenId);
1271     }
1272 
1273     /**
1274      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1275      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1276      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1277      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1278      * @param from address representing the previous owner of the given token ID
1279      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1280      */
1281     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1282         private
1283     {
1284         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1285         // then delete the last slot (swap and pop).
1286 
1287         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1288         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1289 
1290         // When the token to delete is the last token, the swap operation is unnecessary
1291         if (tokenIndex != lastTokenIndex) {
1292             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1293 
1294             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1295             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1296         }
1297 
1298         // This also deletes the contents at the last position of the array
1299         delete _ownedTokensIndex[tokenId];
1300         delete _ownedTokens[from][lastTokenIndex];
1301     }
1302 
1303     /**
1304      * @dev Private function to remove a token from this extension's token tracking data structures.
1305      * This has O(1) time complexity, but alters the order of the _allTokens array.
1306      * @param tokenId uint256 ID of the token to be removed from the tokens list
1307      */
1308     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1309         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1310         // then delete the last slot (swap and pop).
1311 
1312         uint256 lastTokenIndex = _allTokens.length - 1;
1313         uint256 tokenIndex = _allTokensIndex[tokenId];
1314 
1315         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1316         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1317         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1318         uint256 lastTokenId = _allTokens[lastTokenIndex];
1319 
1320         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1321         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1322 
1323         // This also deletes the contents at the last position of the array
1324         delete _allTokensIndex[tokenId];
1325         _allTokens.pop();
1326     }
1327 }
1328 
1329 // File: @openzeppelin/contracts/interfaces/IERC165.sol
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1334 
1335 pragma solidity ^0.8.0;
1336 
1337 /**
1338  * @dev Interface for the NFT Royalty Standard
1339  */
1340 interface IERC2981 is IERC165 {
1341     /**
1342      * @dev Called with the sale price to determine how much royalty is owed and to whom.
1343      * @param tokenId - the NFT asset queried for royalty information
1344      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
1345      * @return receiver - address of who should be sent the royalty payment
1346      * @return royaltyAmount - the royalty payment amount for `salePrice`
1347      */
1348     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1349         external
1350         view
1351         returns (address receiver, uint256 royaltyAmount);
1352 }
1353 
1354 // File: @openzeppelin/contracts/access/Ownable.sol
1355 
1356 pragma solidity ^0.8.0;
1357 
1358 /**
1359  * @dev Contract module which provides a basic access control mechanism, where
1360  * there is an account (an owner) that can be granted exclusive access to
1361  * specific functions.
1362  *
1363  * By default, the owner account will be the one that deploys the contract. This
1364  * can later be changed with {transferOwnership}.
1365  *
1366  * This module is used through inheritance. It will make available the modifier
1367  * `onlyOwner`, which can be applied to your functions to restrict their use to
1368  * the owner.
1369  */
1370 abstract contract Ownable is Context {
1371     address private _owner;
1372 
1373     event OwnershipTransferred(
1374         address indexed previousOwner,
1375         address indexed newOwner
1376     );
1377 
1378     /**
1379      * @dev Initializes the contract setting the deployer as the initial owner.
1380      */
1381     constructor() {
1382         _setOwner(_msgSender());
1383     }
1384 
1385     /**
1386      * @dev Returns the address of the current owner.
1387      */
1388     function owner() public view virtual returns (address) {
1389         return _owner;
1390     }
1391 
1392     /**
1393      * @dev Throws if called by any account other than the owner.
1394      */
1395     modifier onlyOwner() {
1396         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1397         _;
1398     }
1399 
1400     /**
1401      * @dev Leaves the contract without owner. It will not be possible to call
1402      * `onlyOwner` functions anymore. Can only be called by the current owner.
1403      *
1404      * NOTE: Renouncing ownership will leave the contract without an owner,
1405      * thereby removing any functionality that is only available to the owner.
1406      */
1407     function renounceOwnership() public virtual onlyOwner {
1408         _setOwner(address(0));
1409     }
1410 
1411     /**
1412      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1413      * Can only be called by the current owner.
1414      */
1415     function transferOwnership(address newOwner) public virtual onlyOwner {
1416         require(
1417             newOwner != address(0),
1418             "Ownable: new owner is the zero address"
1419         );
1420         _setOwner(newOwner);
1421     }
1422 
1423     function _setOwner(address newOwner) private {
1424         address oldOwner = _owner;
1425         _owner = newOwner;
1426         emit OwnershipTransferred(oldOwner, newOwner);
1427     }
1428 }
1429 
1430 // File: contracts/Authorizable.sol
1431 
1432 pragma solidity >=0.4.22 <0.9.0;
1433 
1434 contract Authorizable is Ownable {
1435     address public trustee;
1436 
1437     constructor() {
1438         trustee = address(0x0);
1439     }
1440 
1441     modifier onlyAuthorized() {
1442         require(msg.sender == trustee || msg.sender == owner());
1443         _;
1444     }
1445 
1446     function setTrustee(address _newTrustee) public onlyOwner {
1447         trustee = _newTrustee;
1448     }
1449 }
1450 
1451 // File: contracts/FeralfileArtworkV2.sol
1452 
1453 pragma solidity ^0.8.0;
1454 
1455 contract FeralfileExhibitionV2 is ERC721Enumerable, Authorizable, IERC2981 {
1456     using Strings for uint256;
1457 
1458     // royalty payout address
1459     address public royaltyPayoutAddress;
1460 
1461     // The maximum limit of edition size for each exhibitions
1462     uint256 public immutable maxEditionPerArtwork;
1463 
1464     // the basis points of royalty payments for each secondary sales
1465     uint256 public immutable secondarySaleRoyaltyBPS;
1466 
1467     // the maximum basis points of royalty payments
1468     uint256 public constant MAX_ROYALITY_BPS = 100_00;
1469 
1470     // token base URI
1471     string private _tokenBaseURI;
1472 
1473     // contract URI
1474     string private _contractURI;
1475 
1476     /// @notice A structure for Feral File artwork
1477     struct Artwork {
1478         string title;
1479         string artistName;
1480         string fingerprint;
1481         uint256 editionSize;
1482     }
1483 
1484     struct ArtworkEdition {
1485         uint256 editionID;
1486         string ipfsCID;
1487     }
1488 
1489     uint256[] private _allArtworks;
1490     mapping(uint256 => Artwork) public artworks; // artworkID => Artwork
1491     mapping(uint256 => ArtworkEdition) public artworkEditions; // artworkEditionID => ArtworkEdition
1492     mapping(uint256 => uint256[]) internal allArtworkEditions; // artworkID => []ArtworkEditionID
1493     mapping(uint256 => bool) internal registeredBitmarks; // bitmarkID => bool
1494     mapping(string => bool) internal registeredIPFSCIDs; // ipfsCID => bool
1495 
1496     constructor(
1497         string memory name_,
1498         string memory symbol_,
1499         uint256 maxEditionPerArtwork_,
1500         uint256 secondarySaleRoyaltyBPS_,
1501         address royaltyPayoutAddress_,
1502         string memory contractURI_,
1503         string memory tokenBaseURI_
1504     ) ERC721(name_, symbol_) {
1505         require(
1506             maxEditionPerArtwork_ > 0,
1507             "maxEdition of each artwork in an exhibition needs to be greater than zero"
1508         );
1509         require(
1510             secondarySaleRoyaltyBPS_ <= MAX_ROYALITY_BPS,
1511             "royalty BPS for secondary sales can not be greater than the maximum royalty BPS"
1512         );
1513         require(
1514             royaltyPayoutAddress_ != address(0),
1515             "invalid royalty payout address"
1516         );
1517 
1518         maxEditionPerArtwork = maxEditionPerArtwork_;
1519         secondarySaleRoyaltyBPS = secondarySaleRoyaltyBPS_;
1520         royaltyPayoutAddress = royaltyPayoutAddress_;
1521         _contractURI = contractURI_;
1522         _tokenBaseURI = tokenBaseURI_;
1523     }
1524 
1525     function supportsInterface(bytes4 interfaceId)
1526         public
1527         view
1528         virtual
1529         override(ERC721Enumerable, IERC165)
1530         returns (bool)
1531     {
1532         return
1533             interfaceId == type(IERC721Enumerable).interfaceId ||
1534             super.supportsInterface(interfaceId);
1535     }
1536 
1537     /// @notice Call to create an artwork in the exhibition
1538     /// @param fingerprint - the fingerprint of an artwork
1539     /// @param title - the title of an artwork
1540     /// @param artistName - the artist of an artwork
1541     /// @param editionSize - the maximum edition size of an artwork
1542     function createArtwork(
1543         string memory fingerprint,
1544         string memory title,
1545         string memory artistName,
1546         uint256 editionSize
1547     ) external onlyAuthorized {
1548         require(bytes(title).length != 0, "title can not be empty");
1549         require(bytes(artistName).length != 0, "artist can not be empty");
1550         require(bytes(fingerprint).length != 0, "fingerprint can not be empty");
1551         require(editionSize > 0, "edition size needs to be at least 1");
1552         require(
1553             editionSize <= maxEditionPerArtwork,
1554             "artwork edition size exceeds the maximum edition size of the exhibition"
1555         );
1556 
1557         uint256 artworkID = uint256(keccak256(abi.encode(fingerprint)));
1558 
1559         /// @notice make sure the artwork have not been registered
1560         require(
1561             bytes(artworks[artworkID].fingerprint).length == 0,
1562             "an artwork with the same fingerprint has already registered"
1563         );
1564 
1565         Artwork memory artwork = Artwork(
1566             fingerprint,
1567             title,
1568             artistName,
1569             editionSize
1570         );
1571 
1572         _allArtworks.push(artworkID);
1573         artworks[artworkID] = artwork;
1574 
1575         emit NewArtwork(artworkID);
1576     }
1577 
1578     /// @notice Return a count of artworks registered in this exhibition
1579     function totalArtworks() public view virtual returns (uint256) {
1580         return _allArtworks.length;
1581     }
1582 
1583     /// @notice Return the token identifier for the `index`th artwork
1584     function getArtworkByIndex(uint256 index)
1585         public
1586         view
1587         virtual
1588         returns (uint256)
1589     {
1590         require(
1591             index < totalArtworks(),
1592             "artworks: global index out of bounds"
1593         );
1594         return _allArtworks[index];
1595     }
1596 
1597     /// @notice Swap an existent artwork from bitmark to ERC721
1598     /// @param artworkID - the artwork id where the new edition is referenced to
1599     /// @param bitmarkID - the bitmark id of artwork edition before swapped
1600     /// @param editionNumber - the edition number of the artwork edition
1601     /// @param owner - the owner address of the new minted token
1602     /// @param ipfsCID - the IPFS cid for the new token
1603     function swapArtworkFromBitmark(
1604         uint256 artworkID,
1605         uint256 bitmarkID,
1606         uint256 editionNumber,
1607         address owner,
1608         string memory ipfsCID
1609     ) external onlyAuthorized {
1610         /// @notice the edition size is not set implies the artwork is not created
1611         require(artworks[artworkID].editionSize > 0, "artwork is not found");
1612         /// @notice The range of editionNumber should be between 0 (AP) ~ artwork.editionSize
1613         require(
1614             editionNumber <= artworks[artworkID].editionSize,
1615             "edition number exceed the edition size of the artwork"
1616         );
1617         require(owner != address(0), "invalid owner address");
1618         require(!registeredBitmarks[bitmarkID], "bitmark id has registered");
1619         require(!registeredIPFSCIDs[ipfsCID], "ipfs id has registered");
1620 
1621         uint256 editionID = artworkID + editionNumber;
1622         require(
1623             artworkEditions[editionID].editionID == 0,
1624             "the edition is existent"
1625         );
1626 
1627         ArtworkEdition memory edition = ArtworkEdition(editionID, ipfsCID);
1628 
1629         artworkEditions[editionID] = edition;
1630         allArtworkEditions[artworkID].push(editionID);
1631 
1632         registeredBitmarks[bitmarkID] = true;
1633         registeredIPFSCIDs[ipfsCID] = true;
1634 
1635         _safeMint(owner, editionID);
1636         emit NewArtworkEdition(owner, artworkID, editionID);
1637     }
1638 
1639     /// @notice Update the IPFS cid of an edition to a new value
1640     function updateArtworkEditionIPFSCid(uint256 tokenId, string memory ipfsCID)
1641         external
1642         onlyAuthorized
1643     {
1644         require(_exists(tokenId), "artwork edition is not found");
1645         require(!registeredIPFSCIDs[ipfsCID], "ipfs id has registered");
1646 
1647         ArtworkEdition storage edition = artworkEditions[tokenId];
1648         delete registeredIPFSCIDs[edition.ipfsCID];
1649         registeredIPFSCIDs[ipfsCID] = true;
1650         edition.ipfsCID = ipfsCID;
1651     }
1652 
1653     /// @notice setRoyaltyPayoutAddress assigns a payout address so
1654     //          that we can split the royalty.
1655     /// @param royaltyPayoutAddress_ - the new royalty payout address
1656     function setRoyaltyPayoutAddress(address royaltyPayoutAddress_)
1657         external
1658         onlyAuthorized
1659     {
1660         require(
1661             royaltyPayoutAddress_ != address(0),
1662             "invalid royalty payout address"
1663         );
1664         royaltyPayoutAddress = royaltyPayoutAddress_;
1665     }
1666 
1667     /// @notice Return the edition counts for an artwork
1668     function totalEditionOfArtwork(uint256 artworkID)
1669         public
1670         view
1671         returns (uint256)
1672     {
1673         return allArtworkEditions[artworkID].length;
1674     }
1675 
1676     /// @notice Return the edition id of an artwork by index
1677     function getArtworkEditionByIndex(uint256 artworkID, uint256 index)
1678         public
1679         view
1680         returns (uint256)
1681     {
1682         require(index < totalEditionOfArtwork(artworkID));
1683         return allArtworkEditions[artworkID][index];
1684     }
1685 
1686     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
1687     function tokenURI(uint256 tokenId)
1688         public
1689         view
1690         virtual
1691         override
1692         returns (string memory)
1693     {
1694         require(
1695             _exists(tokenId),
1696             "ERC721Metadata: URI query for nonexistent token"
1697         );
1698 
1699         string memory baseURI = _tokenBaseURI;
1700         if (bytes(baseURI).length == 0) {
1701             baseURI = "ipfs://";
1702         }
1703 
1704         return
1705             string(
1706                 abi.encodePacked(
1707                     baseURI,
1708                     artworkEditions[tokenId].ipfsCID,
1709                     "/metadata.json"
1710                 )
1711             );
1712     }
1713 
1714     /// @notice Update the base URI for all tokens
1715     function setTokenBaseURI(string memory baseURI_) external onlyAuthorized {
1716         _tokenBaseURI = baseURI_;
1717     }
1718 
1719     /// @notice A URL for the opensea storefront-level metadata
1720     function contractURI() public view returns (string memory) {
1721         return _contractURI;
1722     }
1723 
1724     /// @notice Called with the sale price to determine how much royalty
1725     //          is owed and to whom.
1726     /// @param tokenId - the NFT asset queried for royalty information
1727     /// @param salePrice - the sale price of the NFT asset specified by tokenId
1728     /// @return receiver - address of who should be sent the royalty payment
1729     /// @return royaltyAmount - the royalty payment amount for salePrice
1730     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1731         external
1732         view
1733         override
1734         returns (address receiver, uint256 royaltyAmount)
1735     {
1736         require(
1737             _exists(tokenId),
1738             "ERC2981: query royalty info for nonexistent token"
1739         );
1740 
1741         receiver = royaltyPayoutAddress;
1742 
1743         royaltyAmount =
1744             (salePrice * secondarySaleRoyaltyBPS) /
1745             MAX_ROYALITY_BPS;
1746     }
1747 
1748     event NewArtwork(uint256 indexed artworkID);
1749     event NewArtworkEdition(
1750         address indexed owner,
1751         uint256 indexed artworkID,
1752         uint256 indexed editionID
1753     );
1754 }