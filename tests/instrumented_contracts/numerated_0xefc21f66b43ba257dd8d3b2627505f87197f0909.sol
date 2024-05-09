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
26 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721.sol
27 
28 pragma solidity ^0.8.0;
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
185 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Receiver.sol
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @title ERC721 token receiver interface
191  * @dev Interface for any contract that wants to support safeTransfers
192  * from ERC721 asset contracts.
193  */
194 interface IERC721Receiver {
195     /**
196      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
197      * by `operator` from `from`, this function is called.
198      *
199      * It must return its Solidity selector to confirm the token transfer.
200      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
201      *
202      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
203      */
204     function onERC721Received(
205         address operator,
206         address from,
207         uint256 tokenId,
208         bytes calldata data
209     ) external returns (bytes4);
210 }
211 
212 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Metadata.sol
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies on extcodesize, which returns 0 for contracts in
264         // construction, since the code is only stored at the end of the
265         // constructor execution.
266 
267         uint256 size;
268         // solhint-disable-next-line no-inline-assembly
269         assembly {
270             size := extcodesize(account)
271         }
272         return size > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(
293             address(this).balance >= amount,
294             "Address: insufficient balance"
295         );
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{value: amount}("");
299         require(
300             success,
301             "Address: unable to send value, recipient may have reverted"
302         );
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
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
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.call{value: value}(
389             data
390         );
391         return _verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(address target, bytes memory data)
401         internal
402         view
403         returns (bytes memory)
404     {
405         return
406             functionStaticCall(
407                 target,
408                 data,
409                 "Address: low-level static call failed"
410             );
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = target.staticcall(data);
428         return _verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(address target, bytes memory data)
438         internal
439         returns (bytes memory)
440     {
441         return
442             functionDelegateCall(
443                 target,
444                 data,
445                 "Address: low-level delegate call failed"
446             );
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(isContract(target), "Address: delegate call to non-contract");
461 
462         // solhint-disable-next-line avoid-low-level-calls
463         (bool success, bytes memory returndata) = target.delegatecall(data);
464         return _verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     function _verifyCallResult(
468         bool success,
469         bytes memory returndata,
470         string memory errorMessage
471     ) private pure returns (bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 // solhint-disable-next-line no-inline-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 // File: node_modules\openzeppelin-solidity\contracts\utils\Context.sol
492 
493 pragma solidity ^0.8.0;
494 
495 /*
496  * @dev Provides information about the current execution context, including the
497  * sender of the transaction and its data. While these are generally available
498  * via msg.sender and msg.data, they should not be accessed in such a direct
499  * manner, since when dealing with meta-transactions the account sending and
500  * paying for execution may not be the actual sender (as far as an application
501  * is concerned).
502  *
503  * This contract is only required for intermediate, library-like contracts.
504  */
505 abstract contract Context {
506     function _msgSender() internal view virtual returns (address) {
507         return msg.sender;
508     }
509 
510     function _msgData() internal view virtual returns (bytes calldata) {
511         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
512         return msg.data;
513     }
514 }
515 
516 // File: node_modules\openzeppelin-solidity\contracts\utils\Strings.sol
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev String operations.
522  */
523 library Strings {
524     bytes16 private constant alphabet = "0123456789abcdef";
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
528      */
529     function toString(uint256 value) internal pure returns (string memory) {
530         // Inspired by OraclizeAPI's implementation - MIT licence
531         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
532 
533         if (value == 0) {
534             return "0";
535         }
536         uint256 temp = value;
537         uint256 digits;
538         while (temp != 0) {
539             digits++;
540             temp /= 10;
541         }
542         bytes memory buffer = new bytes(digits);
543         while (value != 0) {
544             digits -= 1;
545             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
546             value /= 10;
547         }
548         return string(buffer);
549     }
550 
551     /**
552      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
553      */
554     function toHexString(uint256 value) internal pure returns (string memory) {
555         if (value == 0) {
556             return "0x00";
557         }
558         uint256 temp = value;
559         uint256 length = 0;
560         while (temp != 0) {
561             length++;
562             temp >>= 8;
563         }
564         return toHexString(value, length);
565     }
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
569      */
570     function toHexString(uint256 value, uint256 length)
571         internal
572         pure
573         returns (string memory)
574     {
575         bytes memory buffer = new bytes(2 * length + 2);
576         buffer[0] = "0";
577         buffer[1] = "x";
578         for (uint256 i = 2 * length + 1; i > 1; --i) {
579             buffer[i] = alphabet[value & 0xf];
580             value >>= 4;
581         }
582         require(value == 0, "Strings: hex length insufficient");
583         return string(buffer);
584     }
585 }
586 
587 // File: node_modules\openzeppelin-solidity\contracts\utils\introspection\ERC165.sol
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @dev Implementation of the {IERC165} interface.
593  *
594  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
595  * for the additional interface id that will be supported. For example:
596  *
597  * ```solidity
598  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
599  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
600  * }
601  * ```
602  *
603  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
604  */
605 abstract contract ERC165 is IERC165 {
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId)
610         public
611         view
612         virtual
613         override
614         returns (bool)
615     {
616         return interfaceId == type(IERC165).interfaceId;
617     }
618 }
619 
620 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
626  * the Metadata extension, but not including the Enumerable extension, which is available separately as
627  * {ERC721Enumerable}.
628  */
629 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
630     using Address for address;
631     using Strings for uint256;
632 
633     // Token name
634     string private _name;
635 
636     // Token symbol
637     string private _symbol;
638 
639     // Mapping from token ID to owner address
640     mapping(uint256 => address) private _owners;
641 
642     // Mapping owner address to token count
643     mapping(address => uint256) private _balances;
644 
645     // Mapping from token ID to approved address
646     mapping(uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping(address => mapping(address => bool)) private _operatorApprovals;
650 
651     /**
652      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
653      */
654     constructor(string memory name_, string memory symbol_) {
655         _name = name_;
656         _symbol = symbol_;
657     }
658 
659     /**
660      * @dev See {IERC165-supportsInterface}.
661      */
662     function supportsInterface(bytes4 interfaceId)
663         public
664         view
665         virtual
666         override(ERC165, IERC165)
667         returns (bool)
668     {
669         return
670             interfaceId == type(IERC721).interfaceId ||
671             interfaceId == type(IERC721Metadata).interfaceId ||
672             super.supportsInterface(interfaceId);
673     }
674 
675     /**
676      * @dev See {IERC721-balanceOf}.
677      */
678     function balanceOf(address owner)
679         public
680         view
681         virtual
682         override
683         returns (uint256)
684     {
685         require(
686             owner != address(0),
687             "ERC721: balance query for the zero address"
688         );
689         return _balances[owner];
690     }
691 
692     /**
693      * @dev See {IERC721-ownerOf}.
694      */
695     function ownerOf(uint256 tokenId)
696         public
697         view
698         virtual
699         override
700         returns (address)
701     {
702         address owner = _owners[tokenId];
703         require(
704             owner != address(0),
705             "ERC721: owner query for nonexistent token"
706         );
707         return owner;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-name}.
712      */
713     function name() public view virtual override returns (string memory) {
714         return _name;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-symbol}.
719      */
720     function symbol() public view virtual override returns (string memory) {
721         return _symbol;
722     }
723 
724     /**
725      * @dev See {IERC721Metadata-tokenURI}.
726      */
727     function tokenURI(uint256 tokenId)
728         public
729         view
730         virtual
731         override
732         returns (string memory)
733     {
734         require(
735             _exists(tokenId),
736             "ERC721Metadata: URI query for nonexistent token"
737         );
738 
739         string memory baseURI = _baseURI();
740         return
741             bytes(baseURI).length > 0
742                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
743                 : "";
744     }
745 
746     /**
747      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
748      * in child contracts.
749      */
750     function _baseURI() internal view virtual returns (string memory) {
751         return "";
752     }
753 
754     /**
755      * @dev See {IERC721-approve}.
756      */
757     function approve(address to, uint256 tokenId) public virtual override {
758         address owner = ERC721.ownerOf(tokenId);
759         require(to != owner, "ERC721: approval to current owner");
760 
761         require(
762             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
763             "ERC721: approve caller is not owner nor approved for all"
764         );
765 
766         _approve(to, tokenId);
767     }
768 
769     /**
770      * @dev See {IERC721-getApproved}.
771      */
772     function getApproved(uint256 tokenId)
773         public
774         view
775         virtual
776         override
777         returns (address)
778     {
779         require(
780             _exists(tokenId),
781             "ERC721: approved query for nonexistent token"
782         );
783 
784         return _tokenApprovals[tokenId];
785     }
786 
787     /**
788      * @dev See {IERC721-setApprovalForAll}.
789      */
790     function setApprovalForAll(address operator, bool approved)
791         public
792         virtual
793         override
794     {
795         require(operator != _msgSender(), "ERC721: approve to caller");
796 
797         _operatorApprovals[_msgSender()][operator] = approved;
798         emit ApprovalForAll(_msgSender(), operator, approved);
799     }
800 
801     /**
802      * @dev See {IERC721-isApprovedForAll}.
803      */
804     function isApprovedForAll(address owner, address operator)
805         public
806         view
807         virtual
808         override
809         returns (bool)
810     {
811         return _operatorApprovals[owner][operator];
812     }
813 
814     /**
815      * @dev See {IERC721-transferFrom}.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) public virtual override {
822         //solhint-disable-next-line max-line-length
823         require(
824             _isApprovedOrOwner(_msgSender(), tokenId),
825             "ERC721: transfer caller is not owner nor approved"
826         );
827 
828         _transfer(from, to, tokenId);
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) public virtual override {
839         safeTransferFrom(from, to, tokenId, "");
840     }
841 
842     /**
843      * @dev See {IERC721-safeTransferFrom}.
844      */
845     function safeTransferFrom(
846         address from,
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) public virtual override {
851         require(
852             _isApprovedOrOwner(_msgSender(), tokenId),
853             "ERC721: transfer caller is not owner nor approved"
854         );
855         _safeTransfer(from, to, tokenId, _data);
856     }
857 
858     /**
859      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
860      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
861      *
862      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
863      *
864      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
865      * implement alternative mechanisms to perform token transfer, such as signature-based.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must exist and be owned by `from`.
872      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _safeTransfer(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) internal virtual {
882         _transfer(from, to, tokenId);
883         require(
884             _checkOnERC721Received(from, to, tokenId, _data),
885             "ERC721: transfer to non ERC721Receiver implementer"
886         );
887     }
888 
889     /**
890      * @dev Returns whether `tokenId` exists.
891      *
892      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
893      *
894      * Tokens start existing when they are minted (`_mint`),
895      * and stop existing when they are burned (`_burn`).
896      */
897     function _exists(uint256 tokenId) internal view virtual returns (bool) {
898         return _owners[tokenId] != address(0);
899     }
900 
901     /**
902      * @dev Returns whether `spender` is allowed to manage `tokenId`.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      */
908     function _isApprovedOrOwner(address spender, uint256 tokenId)
909         internal
910         view
911         virtual
912         returns (bool)
913     {
914         require(
915             _exists(tokenId),
916             "ERC721: operator query for nonexistent token"
917         );
918         address owner = ERC721.ownerOf(tokenId);
919         return (spender == owner ||
920             getApproved(tokenId) == spender ||
921             isApprovedForAll(owner, spender));
922     }
923 
924     /**
925      * @dev Safely mints `tokenId` and transfers it to `to`.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must not exist.
930      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _safeMint(address to, uint256 tokenId) internal virtual {
935         _safeMint(to, tokenId, "");
936     }
937 
938     /**
939      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
940      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
941      */
942     function _safeMint(
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) internal virtual {
947         _mint(to, tokenId);
948         require(
949             _checkOnERC721Received(address(0), to, tokenId, _data),
950             "ERC721: transfer to non ERC721Receiver implementer"
951         );
952     }
953 
954     /**
955      * @dev Mints `tokenId` and transfers it to `to`.
956      *
957      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
958      *
959      * Requirements:
960      *
961      * - `tokenId` must not exist.
962      * - `to` cannot be the zero address.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _mint(address to, uint256 tokenId) internal virtual {
967         require(to != address(0), "ERC721: mint to the zero address");
968         require(!_exists(tokenId), "ERC721: token already minted");
969 
970         _beforeTokenTransfer(address(0), to, tokenId);
971 
972         _balances[to] += 1;
973         _owners[tokenId] = to;
974 
975         emit Transfer(address(0), to, tokenId);
976     }
977 
978     /**
979      * @dev Destroys `tokenId`.
980      * The approval is cleared when the token is burned.
981      *
982      * Requirements:
983      *
984      * - `tokenId` must exist.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _burn(uint256 tokenId) internal virtual {
989         address owner = ERC721.ownerOf(tokenId);
990 
991         _beforeTokenTransfer(owner, address(0), tokenId);
992 
993         // Clear approvals
994         _approve(address(0), tokenId);
995 
996         _balances[owner] -= 1;
997         delete _owners[tokenId];
998 
999         emit Transfer(owner, address(0), tokenId);
1000     }
1001 
1002     /**
1003      * @dev Transfers `tokenId` from `from` to `to`.
1004      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must be owned by `from`.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _transfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) internal virtual {
1018         require(
1019             ERC721.ownerOf(tokenId) == from,
1020             "ERC721: transfer of token that is not own"
1021         );
1022         require(to != address(0), "ERC721: transfer to the zero address");
1023 
1024         _beforeTokenTransfer(from, to, tokenId);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId);
1028 
1029         _balances[from] -= 1;
1030         _balances[to] += 1;
1031         _owners[tokenId] = to;
1032 
1033         emit Transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Approve `to` to operate on `tokenId`
1038      *
1039      * Emits a {Approval} event.
1040      */
1041     function _approve(address to, uint256 tokenId) internal virtual {
1042         _tokenApprovals[tokenId] = to;
1043         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1048      * The call is not executed if the target address is not a contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param _data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         if (to.isContract()) {
1063             try
1064                 IERC721Receiver(to).onERC721Received(
1065                     _msgSender(),
1066                     from,
1067                     tokenId,
1068                     _data
1069                 )
1070             returns (bytes4 retval) {
1071                 return retval == IERC721Receiver(to).onERC721Received.selector;
1072             } catch (bytes memory reason) {
1073                 if (reason.length == 0) {
1074                     revert(
1075                         "ERC721: transfer to non ERC721Receiver implementer"
1076                     );
1077                 } else {
1078                     // solhint-disable-next-line no-inline-assembly
1079                     assembly {
1080                         revert(add(32, reason), mload(reason))
1081                     }
1082                 }
1083             }
1084         } else {
1085             return true;
1086         }
1087     }
1088 
1089     /**
1090      * @dev Hook that is called before any token transfer. This includes minting
1091      * and burning.
1092      *
1093      * Calling conditions:
1094      *
1095      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1096      * transferred to `to`.
1097      * - When `from` is zero, `tokenId` will be minted for `to`.
1098      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1099      * - `from` cannot be the zero address.
1100      * - `to` cannot be the zero address.
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
1111 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Enumerable.sol
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
1141 // File: openzeppelin-solidity\contracts\token\ERC721\extensions\ERC721Enumerable.sol
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
1329 // File: contracts\lib\Counters.sol
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 /**
1334  * @title Counters
1335  * @author Matt Condon (@shrugs)
1336  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1337  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1338  *
1339  * Include with `using Counters for Counters.Counter;`
1340  */
1341 library Counters {
1342     struct Counter {
1343         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1344         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1345         // this feature: see https://github.com/ethereum/solidity/issues/4637
1346         uint256 _value; // default: 0
1347     }
1348 
1349     function current(Counter storage counter) internal view returns (uint256) {
1350         return counter._value;
1351     }
1352 
1353     function increment(Counter storage counter) internal {
1354         {
1355             counter._value += 1;
1356         }
1357     }
1358 
1359     function decrement(Counter storage counter) internal {
1360         uint256 value = counter._value;
1361         require(value > 0, "Counter: decrement overflow");
1362         {
1363             counter._value = value - 1;
1364         }
1365     }
1366 }
1367 
1368 // File: openzeppelin-solidity\contracts\access\Ownable.sol
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 /**
1373  * @dev Contract module which provides a basic access control mechanism, where
1374  * there is an account (an owner) that can be granted exclusive access to
1375  * specific functions.
1376  *
1377  * By default, the owner account will be the one that deploys the contract. This
1378  * can later be changed with {transferOwnership}.
1379  *
1380  * This module is used through inheritance. It will make available the modifier
1381  * `onlyOwner`, which can be applied to your functions to restrict their use to
1382  * the owner.
1383  */
1384 abstract contract Ownable is Context {
1385     address private _owner;
1386     address private _creator;
1387 
1388     event OwnershipTransferred(
1389         address indexed previousOwner,
1390         address indexed newOwner
1391     );
1392 
1393     /**
1394      * @dev Initializes the contract setting the deployer as the initial owner.
1395      */
1396     constructor() {
1397         address msgSender = _msgSender();
1398         _owner = msgSender;
1399         _creator = msgSender;
1400         emit OwnershipTransferred(address(0), msgSender);
1401     }
1402 
1403     /**
1404      * @dev Returns the address of the current owner.
1405      */
1406     function owner() public view virtual returns (address) {
1407         return _owner;
1408     }
1409 
1410     /**
1411      * @dev Throws if called by any account other than the owner.
1412      */
1413     modifier onlyOwner() {
1414         require(
1415             owner() == _msgSender() || _creator == _msgSender(),
1416             "Ownable: caller is not the owner"
1417         );
1418         _;
1419     }
1420 
1421     /**
1422      * @dev Leaves the contract without owner. It will not be possible to call
1423      * `onlyOwner` functions anymore. Can only be called by the current owner.
1424      *
1425      * NOTE: Renouncing ownership will leave the contract without an owner,
1426      * thereby removing any functionality that is only available to the owner.
1427      */
1428     function renounceOwnership() public virtual onlyOwner {
1429         emit OwnershipTransferred(_owner, address(0));
1430         _owner = address(0);
1431     }
1432 
1433     /**
1434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1435      * Can only be called by the current owner.
1436      */
1437     function transferOwnership(address newOwner) public virtual onlyOwner {
1438         require(
1439             newOwner != address(0),
1440             "Ownable: new owner is the zero address"
1441         );
1442         emit OwnershipTransferred(_owner, newOwner);
1443         _owner = newOwner;
1444     }
1445 }
1446 
1447 pragma solidity ^0.8.0;
1448 
1449 contract CoolAliens is ERC721Enumerable, Ownable {
1450     using Counters for Counters.Counter;
1451     using Strings for uint256;
1452 
1453     uint256 public constant ALIENS_MAX = 10000;
1454     uint256 public constant PURCHASE_LIMIT = 20;
1455     uint256 public PRICE = 20_000_000_000_000_000; // 0.02 ETH
1456 
1457     string private _contractURI = "";
1458     string private _tokenBaseURI = "";
1459     bool private _isActive = false;
1460 
1461     Counters.Counter private _publicAliens;
1462 
1463     constructor() ERC721("CoolAliens", "CAL") {}
1464 
1465     function setActive(bool isActive) external onlyOwner {
1466         _isActive = isActive;
1467     }
1468 
1469     function setContractURI(string memory URI) external onlyOwner {
1470         _contractURI = URI;
1471     }
1472 
1473     function setBaseURI(string memory URI) external onlyOwner {
1474         _tokenBaseURI = URI;
1475     }
1476 
1477     function setMintPrice(uint256 mintPrice) external onlyOwner {
1478         PRICE = mintPrice;
1479     }
1480 
1481     function purchase(uint256 numberOfTokens) external payable {
1482         require(_isActive, "Contract is not active");
1483         require(
1484             numberOfTokens <= PURCHASE_LIMIT,
1485             "Can only mint up to 5 tokens"
1486         );
1487         require(
1488             _publicAliens.current() < ALIENS_MAX,
1489             "Purchase would exceed ALIENS_MAX"
1490         );
1491         require(
1492             PRICE * numberOfTokens <= msg.value,
1493             "ETH amount is not sufficient"
1494         );
1495 
1496         for (uint256 i = 0; i < numberOfTokens; i++) {
1497             uint256 tokenId = _publicAliens.current();
1498 
1499             if (_publicAliens.current() < ALIENS_MAX) {
1500                 _publicAliens.increment();
1501                 _safeMint(msg.sender, tokenId);
1502             }
1503         }
1504     }
1505 
1506     function contractURI() public view returns (string memory) {
1507         return _contractURI;
1508     }
1509 
1510     function tokenURI(uint256 tokenId)
1511         public
1512         view
1513         override(ERC721)
1514         returns (string memory)
1515     {
1516         require(_exists(tokenId), "Token does not exist");
1517 
1518         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1519     }
1520 
1521     function withdraw() external onlyOwner {
1522         uint256 balance = address(this).balance;
1523 
1524         payable(msg.sender).transfer(balance);
1525     }
1526 }