1 /**
2  *Submitted for verification at polygonscan.com on 2022-01-11
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
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
185 /**
186  * @title ERC721 token receiver interface
187  * @dev Interface for any contract that wants to support safeTransfers
188  * from ERC721 asset contracts.
189  */
190 interface IERC721Receiver {
191     /**
192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
193      * by `operator` from `from`, this function is called.
194      *
195      * It must return its Solidity selector to confirm the token transfer.
196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
197      *
198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
199      */
200     function onERC721Received(
201         address operator,
202         address from,
203         uint256 tokenId,
204         bytes calldata data
205     ) external returns (bytes4);
206 }
207 
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
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(
280             address(this).balance >= amount,
281             "Address: insufficient balance"
282         );
283 
284         (bool success, ) = recipient.call{value: amount}("");
285         require(
286             success,
287             "Address: unable to send value, recipient may have reverted"
288         );
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data)
310         internal
311         returns (bytes memory)
312     {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return
347             functionCallWithValue(
348                 target,
349                 data,
350                 value,
351                 "Address: low-level call with value failed"
352             );
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(
368             address(this).balance >= value,
369             "Address: insufficient balance for call"
370         );
371         require(isContract(target), "Address: call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.call{value: value}(
374             data
375         );
376         return _verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data)
386         internal
387         view
388         returns (bytes memory)
389     {
390         return
391             functionStaticCall(
392                 target,
393                 data,
394                 "Address: low-level static call failed"
395             );
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal view returns (bytes memory) {
409         require(isContract(target), "Address: static call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data)
422         internal
423         returns (bytes memory)
424     {
425         return
426             functionDelegateCall(
427                 target,
428                 data,
429                 "Address: low-level delegate call failed"
430             );
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return _verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     function _verifyCallResult(
451         bool success,
452         bytes memory returndata,
453         string memory errorMessage
454     ) private pure returns (bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 /*
474  * @dev Provides information about the current execution context, including the
475  * sender of the transaction and its data. While these are generally available
476  * via msg.sender and msg.data, they should not be accessed in such a direct
477  * manner, since when dealing with meta-transactions the account sending and
478  * paying for execution may not be the actual sender (as far as an application
479  * is concerned).
480  *
481  * This contract is only required for intermediate, library-like contracts.
482  */
483 abstract contract Context {
484     function _msgSender() internal view virtual returns (address) {
485         return msg.sender;
486     }
487 
488     function _msgData() internal view virtual returns (bytes calldata) {
489         return msg.data;
490     }
491 }
492 
493 /**
494  * @dev String operations.
495  */
496 library Strings {
497     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
501      */
502     function toString(uint256 value) internal pure returns (string memory) {
503         // Inspired by OraclizeAPI's implementation - MIT licence
504         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
505 
506         if (value == 0) {
507             return "0";
508         }
509         uint256 temp = value;
510         uint256 digits;
511         while (temp != 0) {
512             digits++;
513             temp /= 10;
514         }
515         bytes memory buffer = new bytes(digits);
516         while (value != 0) {
517             digits -= 1;
518             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
519             value /= 10;
520         }
521         return string(buffer);
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
526      */
527     function toHexString(uint256 value) internal pure returns (string memory) {
528         if (value == 0) {
529             return "0x00";
530         }
531         uint256 temp = value;
532         uint256 length = 0;
533         while (temp != 0) {
534             length++;
535             temp >>= 8;
536         }
537         return toHexString(value, length);
538     }
539 
540     /**
541      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
542      */
543     function toHexString(uint256 value, uint256 length)
544         internal
545         pure
546         returns (string memory)
547     {
548         bytes memory buffer = new bytes(2 * length + 2);
549         buffer[0] = "0";
550         buffer[1] = "x";
551         for (uint256 i = 2 * length + 1; i > 1; --i) {
552             buffer[i] = _HEX_SYMBOLS[value & 0xf];
553             value >>= 4;
554         }
555         require(value == 0, "Strings: hex length insufficient");
556         return string(buffer);
557     }
558 }
559 
560 /**
561  * @dev Implementation of the {IERC165} interface.
562  *
563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
564  * for the additional interface id that will be supported. For example:
565  *
566  * ```solidity
567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
569  * }
570  * ```
571  *
572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
573  */
574 abstract contract ERC165 is IERC165 {
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId)
579         public
580         view
581         virtual
582         override
583         returns (bool)
584     {
585         return interfaceId == type(IERC165).interfaceId;
586     }
587 }
588 
589 /**
590  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
591  * the Metadata extension, but not including the Enumerable extension, which is available separately as
592  * {ERC721Enumerable}.
593  */
594 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
595     using Address for address;
596     using Strings for uint256;
597 
598     // Token name
599     string private _name;
600 
601     // Token symbol
602     string private _symbol;
603 
604     // Mapping from token ID to owner address
605     mapping(uint256 => address) private _owners;
606 
607     // Mapping owner address to token count
608     mapping(address => uint256) private _balances;
609 
610     // Mapping from token ID to approved address
611     mapping(uint256 => address) private _tokenApprovals;
612 
613     // Mapping from owner to operator approvals
614     mapping(address => mapping(address => bool)) private _operatorApprovals;
615 
616     /**
617      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
618      */
619     constructor(string memory name_, string memory symbol_) {
620         _name = name_;
621         _symbol = symbol_;
622     }
623 
624     /**
625      * @dev See {IERC165-supportsInterface}.
626      */
627     function supportsInterface(bytes4 interfaceId)
628         public
629         view
630         virtual
631         override(ERC165, IERC165)
632         returns (bool)
633     {
634         return
635             interfaceId == type(IERC721).interfaceId ||
636             interfaceId == type(IERC721Metadata).interfaceId ||
637             super.supportsInterface(interfaceId);
638     }
639 
640     /**
641      * @dev See {IERC721-balanceOf}.
642      */
643     function balanceOf(address owner)
644         public
645         view
646         virtual
647         override
648         returns (uint256)
649     {
650         require(
651             owner != address(0),
652             "ERC721: balance query for the zero address"
653         );
654         return _balances[owner];
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId)
661         public
662         view
663         virtual
664         override
665         returns (address)
666     {
667         address owner = _owners[tokenId];
668         require(
669             owner != address(0),
670             "ERC721: owner query for nonexistent token"
671         );
672         return owner;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-name}.
677      */
678     function name() public view virtual override returns (string memory) {
679         return _name;
680     }
681 
682     /**
683      * @dev See {IERC721Metadata-symbol}.
684      */
685     function symbol() public view virtual override returns (string memory) {
686         return _symbol;
687     }
688 
689     /**
690      * @dev See {IERC721Metadata-tokenURI}.
691      */
692     function tokenURI(uint256 tokenId)
693         public
694         view
695         virtual
696         override
697         returns (string memory)
698     {
699         require(
700             _exists(tokenId),
701             "ERC721Metadata: URI query for nonexistent token"
702         );
703 
704         string memory baseURI = _baseURI();
705         return
706             bytes(baseURI).length > 0
707                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
708                 : "";
709     }
710 
711     /**
712      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
713      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
714      * by default, can be overriden in child contracts.
715      */
716     function _baseURI() internal view virtual returns (string memory) {
717         return "";
718     }
719 
720     /**
721      * @dev See {IERC721-approve}.
722      */
723     function approve(address to, uint256 tokenId) public virtual override {
724         address owner = ERC721.ownerOf(tokenId);
725         require(to != owner, "ERC721: approval to current owner");
726 
727         require(
728             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
729             "ERC721: approve caller is not owner nor approved for all"
730         );
731 
732         _approve(to, tokenId);
733     }
734 
735     /**
736      * @dev See {IERC721-getApproved}.
737      */
738     function getApproved(uint256 tokenId)
739         public
740         view
741         virtual
742         override
743         returns (address)
744     {
745         require(
746             _exists(tokenId),
747             "ERC721: approved query for nonexistent token"
748         );
749 
750         return _tokenApprovals[tokenId];
751     }
752 
753     /**
754      * @dev See {IERC721-setApprovalForAll}.
755      */
756     function setApprovalForAll(address operator, bool approved)
757         public
758         virtual
759         override
760     {
761         require(operator != _msgSender(), "ERC721: approve to caller");
762 
763         _operatorApprovals[_msgSender()][operator] = approved;
764         emit ApprovalForAll(_msgSender(), operator, approved);
765     }
766 
767     /**
768      * @dev See {IERC721-isApprovedForAll}.
769      */
770     function isApprovedForAll(address owner, address operator)
771         public
772         view
773         virtual
774         override
775         returns (bool)
776     {
777         return _operatorApprovals[owner][operator];
778     }
779 
780     /**
781      * @dev See {IERC721-transferFrom}.
782      */
783     function transferFrom(
784         address from,
785         address to,
786         uint256 tokenId
787     ) public virtual override {
788         //solhint-disable-next-line max-line-length
789         require(
790             _isApprovedOrOwner(_msgSender(), tokenId),
791             "ERC721: transfer caller is not owner nor approved"
792         );
793 
794         _transfer(from, to, tokenId);
795     }
796 
797     /**
798      * @dev See {IERC721-safeTransferFrom}.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) public virtual override {
805         safeTransferFrom(from, to, tokenId, "");
806     }
807 
808     /**
809      * @dev See {IERC721-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) public virtual override {
817         require(
818             _isApprovedOrOwner(_msgSender(), tokenId),
819             "ERC721: transfer caller is not owner nor approved"
820         );
821         _safeTransfer(from, to, tokenId, _data);
822     }
823 
824     /**
825      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
826      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
827      *
828      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
829      *
830      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
831      * implement alternative mechanisms to perform token transfer, such as signature-based.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must exist and be owned by `from`.
838      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _safeTransfer(
843         address from,
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) internal virtual {
848         _transfer(from, to, tokenId);
849         require(
850             _checkOnERC721Received(from, to, tokenId, _data),
851             "ERC721: transfer to non ERC721Receiver implementer"
852         );
853     }
854 
855     /**
856      * @dev Returns whether `tokenId` exists.
857      *
858      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
859      *
860      * Tokens start existing when they are minted (`_mint`),
861      * and stop existing when they are burned (`_burn`).
862      */
863     function _exists(uint256 tokenId) internal view virtual returns (bool) {
864         return _owners[tokenId] != address(0);
865     }
866 
867     /**
868      * @dev Returns whether `spender` is allowed to manage `tokenId`.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      */
874     function _isApprovedOrOwner(address spender, uint256 tokenId)
875         internal
876         view
877         virtual
878         returns (bool)
879     {
880         require(
881             _exists(tokenId),
882             "ERC721: operator query for nonexistent token"
883         );
884         address owner = ERC721.ownerOf(tokenId);
885         return (spender == owner ||
886             getApproved(tokenId) == spender ||
887             isApprovedForAll(owner, spender));
888     }
889 
890     /**
891      * @dev Safely mints `tokenId` and transfers it to `to`.
892      *
893      * Requirements:
894      *
895      * - `tokenId` must not exist.
896      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _safeMint(address to, uint256 tokenId) internal virtual {
901         _safeMint(to, tokenId, "");
902     }
903 
904     /**
905      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
906      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
907      */
908     function _safeMint(
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) internal virtual {
913         _mint(to, tokenId);
914         require(
915             _checkOnERC721Received(address(0), to, tokenId, _data),
916             "ERC721: transfer to non ERC721Receiver implementer"
917         );
918     }
919 
920     /**
921      * @dev Mints `tokenId` and transfers it to `to`.
922      *
923      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
924      *
925      * Requirements:
926      *
927      * - `tokenId` must not exist.
928      * - `to` cannot be the zero address.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _mint(address to, uint256 tokenId) internal virtual {
933         require(to != address(0), "ERC721: mint to the zero address");
934         require(!_exists(tokenId), "ERC721: token already minted");
935 
936         _beforeTokenTransfer(address(0), to, tokenId);
937 
938         _balances[to] += 1;
939         _owners[tokenId] = to;
940 
941         emit Transfer(address(0), to, tokenId);
942     }
943 
944     /**
945      * @dev Destroys `tokenId`.
946      * The approval is cleared when the token is burned.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _burn(uint256 tokenId) internal virtual {
955         address owner = ERC721.ownerOf(tokenId);
956 
957         _beforeTokenTransfer(owner, address(0), tokenId);
958 
959         // Clear approvals
960         _approve(address(0), tokenId);
961 
962         _balances[owner] -= 1;
963         delete _owners[tokenId];
964 
965         emit Transfer(owner, address(0), tokenId);
966     }
967 
968     /**
969      * @dev Transfers `tokenId` from `from` to `to`.
970      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
971      *
972      * Requirements:
973      *
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must be owned by `from`.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _transfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {
984         require(
985             ERC721.ownerOf(tokenId) == from,
986             "ERC721: transfer of token that is not own"
987         );
988         require(to != address(0), "ERC721: transfer to the zero address");
989 
990         _beforeTokenTransfer(from, to, tokenId);
991 
992         // Clear approvals from the previous owner
993         _approve(address(0), tokenId);
994 
995         _balances[from] -= 1;
996         _balances[to] += 1;
997         _owners[tokenId] = to;
998 
999         emit Transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Approve `to` to operate on `tokenId`
1004      *
1005      * Emits a {Approval} event.
1006      */
1007     function _approve(address to, uint256 tokenId) internal virtual {
1008         _tokenApprovals[tokenId] = to;
1009         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1014      * The call is not executed if the target address is not a contract.
1015      *
1016      * @param from address representing the previous owner of the given token ID
1017      * @param to target address that will receive the tokens
1018      * @param tokenId uint256 ID of the token to be transferred
1019      * @param _data bytes optional data to send along with the call
1020      * @return bool whether the call correctly returned the expected magic value
1021      */
1022     function _checkOnERC721Received(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) private returns (bool) {
1028         if (to.isContract()) {
1029             try
1030                 IERC721Receiver(to).onERC721Received(
1031                     _msgSender(),
1032                     from,
1033                     tokenId,
1034                     _data
1035                 )
1036             returns (bytes4 retval) {
1037                 return retval == IERC721Receiver(to).onERC721Received.selector;
1038             } catch (bytes memory reason) {
1039                 if (reason.length == 0) {
1040                     revert(
1041                         "ERC721: transfer to non ERC721Receiver implementer"
1042                     );
1043                 } else {
1044                     assembly {
1045                         revert(add(32, reason), mload(reason))
1046                     }
1047                 }
1048             }
1049         } else {
1050             return true;
1051         }
1052     }
1053 
1054     /**
1055      * @dev Hook that is called before any token transfer. This includes minting
1056      * and burning.
1057      *
1058      * Calling conditions:
1059      *
1060      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1061      * transferred to `to`.
1062      * - When `from` is zero, `tokenId` will be minted for `to`.
1063      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1064      * - `from` and `to` are never both zero.
1065      *
1066      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1067      */
1068     function _beforeTokenTransfer(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) internal virtual {}
1073 }
1074 
1075 /**
1076  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1077  * @dev See https://eips.ethereum.org/EIPS/eip-721
1078  */
1079 interface IERC721Enumerable is IERC721 {
1080     /**
1081      * @dev Returns the total amount of tokens stored by the contract.
1082      */
1083     function totalSupply() external view returns (uint256);
1084 
1085     /**
1086      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1087      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1088      */
1089     function tokenOfOwnerByIndex(address owner, uint256 index)
1090         external
1091         view
1092         returns (uint256 tokenId);
1093 
1094     /**
1095      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1096      * Use along with {totalSupply} to enumerate all tokens.
1097      */
1098     function tokenByIndex(uint256 index) external view returns (uint256);
1099 }
1100 
1101 /**
1102  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1103  * enumerability of all the token ids in the contract as well as all token ids owned by each
1104  * account.
1105  */
1106 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1107     // Mapping from owner to list of owned token IDs
1108     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1109 
1110     // Mapping from token ID to index of the owner tokens list
1111     mapping(uint256 => uint256) private _ownedTokensIndex;
1112 
1113     // Array with all token ids, used for enumeration
1114     uint256[] private _allTokens;
1115 
1116     // Mapping from token id to position in the allTokens array
1117     mapping(uint256 => uint256) private _allTokensIndex;
1118 
1119     /**
1120      * @dev See {IERC165-supportsInterface}.
1121      */
1122     function supportsInterface(bytes4 interfaceId)
1123         public
1124         view
1125         virtual
1126         override(IERC165, ERC721)
1127         returns (bool)
1128     {
1129         return
1130             interfaceId == type(IERC721Enumerable).interfaceId ||
1131             super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1136      */
1137     function tokenOfOwnerByIndex(address owner, uint256 index)
1138         public
1139         view
1140         virtual
1141         override
1142         returns (uint256)
1143     {
1144         require(
1145             index < ERC721.balanceOf(owner),
1146             "ERC721Enumerable: owner index out of bounds"
1147         );
1148         return _ownedTokens[owner][index];
1149     }
1150 
1151     /**
1152      * @dev See {IERC721Enumerable-totalSupply}.
1153      */
1154     function totalSupply() public view virtual override returns (uint256) {
1155         return _allTokens.length;
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Enumerable-tokenByIndex}.
1160      */
1161     function tokenByIndex(uint256 index)
1162         public
1163         view
1164         virtual
1165         override
1166         returns (uint256)
1167     {
1168         require(
1169             index < ERC721Enumerable.totalSupply(),
1170             "ERC721Enumerable: global index out of bounds"
1171         );
1172         return _allTokens[index];
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before any token transfer. This includes minting
1177      * and burning.
1178      *
1179      * Calling conditions:
1180      *
1181      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1182      * transferred to `to`.
1183      * - When `from` is zero, `tokenId` will be minted for `to`.
1184      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1185      * - `from` cannot be the zero address.
1186      * - `to` cannot be the zero address.
1187      *
1188      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1189      */
1190     function _beforeTokenTransfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) internal virtual override {
1195         super._beforeTokenTransfer(from, to, tokenId);
1196 
1197         if (from == address(0)) {
1198             _addTokenToAllTokensEnumeration(tokenId);
1199         } else if (from != to) {
1200             _removeTokenFromOwnerEnumeration(from, tokenId);
1201         }
1202         if (to == address(0)) {
1203             _removeTokenFromAllTokensEnumeration(tokenId);
1204         } else if (to != from) {
1205             _addTokenToOwnerEnumeration(to, tokenId);
1206         }
1207     }
1208 
1209     /**
1210      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1211      * @param to address representing the new owner of the given token ID
1212      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1213      */
1214     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1215         uint256 length = ERC721.balanceOf(to);
1216         _ownedTokens[to][length] = tokenId;
1217         _ownedTokensIndex[tokenId] = length;
1218     }
1219 
1220     /**
1221      * @dev Private function to add a token to this extension's token tracking data structures.
1222      * @param tokenId uint256 ID of the token to be added to the tokens list
1223      */
1224     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1225         _allTokensIndex[tokenId] = _allTokens.length;
1226         _allTokens.push(tokenId);
1227     }
1228 
1229     /**
1230      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1231      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1232      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1233      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1234      * @param from address representing the previous owner of the given token ID
1235      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1236      */
1237     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1238         private
1239     {
1240         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1241         // then delete the last slot (swap and pop).
1242 
1243         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1244         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1245 
1246         // When the token to delete is the last token, the swap operation is unnecessary
1247         if (tokenIndex != lastTokenIndex) {
1248             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1249 
1250             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1251             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1252         }
1253 
1254         // This also deletes the contents at the last position of the array
1255         delete _ownedTokensIndex[tokenId];
1256         delete _ownedTokens[from][lastTokenIndex];
1257     }
1258 
1259     /**
1260      * @dev Private function to remove a token from this extension's token tracking data structures.
1261      * This has O(1) time complexity, but alters the order of the _allTokens array.
1262      * @param tokenId uint256 ID of the token to be removed from the tokens list
1263      */
1264     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1265         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1266         // then delete the last slot (swap and pop).
1267 
1268         uint256 lastTokenIndex = _allTokens.length - 1;
1269         uint256 tokenIndex = _allTokensIndex[tokenId];
1270 
1271         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1272         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1273         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1274         uint256 lastTokenId = _allTokens[lastTokenIndex];
1275 
1276         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1277         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1278 
1279         // This also deletes the contents at the last position of the array
1280         delete _allTokensIndex[tokenId];
1281         _allTokens.pop();
1282     }
1283 }
1284 
1285 /**
1286  * @dev External interface of AccessControl declared to support ERC165 detection.
1287  */
1288 interface IAccessControl {
1289     function hasRole(bytes32 role, address account)
1290         external
1291         view
1292         returns (bool);
1293 
1294     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1295 
1296     function grantRole(bytes32 role, address account) external;
1297 
1298     function revokeRole(bytes32 role, address account) external;
1299 
1300     function renounceRole(bytes32 role, address account) external;
1301 }
1302 
1303 /**
1304  * @dev Contract module that allows children to implement role-based access
1305  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1306  * members except through off-chain means by accessing the contract event logs. Some
1307  * applications may benefit from on-chain enumerability, for those cases see
1308  * {AccessControlEnumerable}.
1309  *
1310  * Roles are referred to by their `bytes32` identifier. These should be exposed
1311  * in the external API and be unique. The best way to achieve this is by
1312  * using `public constant` hash digests:
1313  *
1314  * ```
1315  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1316  * ```
1317  *
1318  * Roles can be used to represent a set of permissions. To restrict access to a
1319  * function call, use {hasRole}:
1320  *
1321  * ```
1322  * function foo() public {
1323  *     require(hasRole(MY_ROLE, msg.sender));
1324  *     ...
1325  * }
1326  * ```
1327  *
1328  * Roles can be granted and revoked dynamically via the {grantRole} and
1329  * {revokeRole} functions. Each role has an associated admin role, and only
1330  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1331  *
1332  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1333  * that only accounts with this role will be able to grant or revoke other
1334  * roles. More complex role relationships can be created by using
1335  * {_setRoleAdmin}.
1336  *
1337  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1338  * grant and revoke this role. Extra precautions should be taken to secure
1339  * accounts that have been granted it.
1340  */
1341 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1342     struct RoleData {
1343         mapping(address => bool) members;
1344         bytes32 adminRole;
1345     }
1346 
1347     mapping(bytes32 => RoleData) private _roles;
1348 
1349     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1350 
1351     /**
1352      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1353      *
1354      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1355      * {RoleAdminChanged} not being emitted signaling this.
1356      *
1357      * _Available since v3.1._
1358      */
1359     event RoleAdminChanged(
1360         bytes32 indexed role,
1361         bytes32 indexed previousAdminRole,
1362         bytes32 indexed newAdminRole
1363     );
1364 
1365     /**
1366      * @dev Emitted when `account` is granted `role`.
1367      *
1368      * `sender` is the account that originated the contract call, an admin role
1369      * bearer except when using {_setupRole}.
1370      */
1371     event RoleGranted(
1372         bytes32 indexed role,
1373         address indexed account,
1374         address indexed sender
1375     );
1376 
1377     /**
1378      * @dev Emitted when `account` is revoked `role`.
1379      *
1380      * `sender` is the account that originated the contract call:
1381      *   - if using `revokeRole`, it is the admin role bearer
1382      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1383      */
1384     event RoleRevoked(
1385         bytes32 indexed role,
1386         address indexed account,
1387         address indexed sender
1388     );
1389 
1390     /**
1391      * @dev Modifier that checks that an account has a specific role. Reverts
1392      * with a standardized message including the required role.
1393      *
1394      * The format of the revert reason is given by the following regular expression:
1395      *
1396      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1397      *
1398      * _Available since v4.1._
1399      */
1400     modifier onlyRole(bytes32 role) {
1401         _checkRole(role, _msgSender());
1402         _;
1403     }
1404 
1405     /**
1406      * @dev See {IERC165-supportsInterface}.
1407      */
1408     function supportsInterface(bytes4 interfaceId)
1409         public
1410         view
1411         virtual
1412         override
1413         returns (bool)
1414     {
1415         return
1416             interfaceId == type(IAccessControl).interfaceId ||
1417             super.supportsInterface(interfaceId);
1418     }
1419 
1420     /**
1421      * @dev Returns `true` if `account` has been granted `role`.
1422      */
1423     function hasRole(bytes32 role, address account)
1424         public
1425         view
1426         override
1427         returns (bool)
1428     {
1429         return _roles[role].members[account];
1430     }
1431 
1432     /**
1433      * @dev Revert with a standard message if `account` is missing `role`.
1434      *
1435      * The format of the revert reason is given by the following regular expression:
1436      *
1437      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1438      */
1439     function _checkRole(bytes32 role, address account) internal view {
1440         if (!hasRole(role, account)) {
1441             revert(
1442                 string(
1443                     abi.encodePacked(
1444                         "AccessControl: account ",
1445                         Strings.toHexString(uint160(account), 20),
1446                         " is missing role ",
1447                         Strings.toHexString(uint256(role), 32)
1448                     )
1449                 )
1450             );
1451         }
1452     }
1453 
1454     /**
1455      * @dev Returns the admin role that controls `role`. See {grantRole} and
1456      * {revokeRole}.
1457      *
1458      * To change a role's admin, use {_setRoleAdmin}.
1459      */
1460     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1461         return _roles[role].adminRole;
1462     }
1463 
1464     /**
1465      * @dev Grants `role` to `account`.
1466      *
1467      * If `account` had not been already granted `role`, emits a {RoleGranted}
1468      * event.
1469      *
1470      * Requirements:
1471      *
1472      * - the caller must have ``role``'s admin role.
1473      */
1474     function grantRole(bytes32 role, address account)
1475         public
1476         virtual
1477         override
1478         onlyRole(getRoleAdmin(role))
1479     {
1480         _grantRole(role, account);
1481     }
1482 
1483     /**
1484      * @dev Revokes `role` from `account`.
1485      *
1486      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1487      *
1488      * Requirements:
1489      *
1490      * - the caller must have ``role``'s admin role.
1491      */
1492     function revokeRole(bytes32 role, address account)
1493         public
1494         virtual
1495         override
1496         onlyRole(getRoleAdmin(role))
1497     {
1498         _revokeRole(role, account);
1499     }
1500 
1501     /**
1502      * @dev Revokes `role` from the calling account.
1503      *
1504      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1505      * purpose is to provide a mechanism for accounts to lose their privileges
1506      * if they are compromised (such as when a trusted device is misplaced).
1507      *
1508      * If the calling account had been granted `role`, emits a {RoleRevoked}
1509      * event.
1510      *
1511      * Requirements:
1512      *
1513      * - the caller must be `account`.
1514      */
1515     function renounceRole(bytes32 role, address account)
1516         public
1517         virtual
1518         override
1519     {
1520         require(
1521             account == _msgSender(),
1522             "AccessControl: can only renounce roles for self"
1523         );
1524 
1525         _revokeRole(role, account);
1526     }
1527 
1528     /**
1529      * @dev Grants `role` to `account`.
1530      *
1531      * If `account` had not been already granted `role`, emits a {RoleGranted}
1532      * event. Note that unlike {grantRole}, this function doesn't perform any
1533      * checks on the calling account.
1534      *
1535      * [WARNING]
1536      * ====
1537      * This function should only be called from the constructor when setting
1538      * up the initial roles for the system.
1539      *
1540      * Using this function in any other way is effectively circumventing the admin
1541      * system imposed by {AccessControl}.
1542      * ====
1543      */
1544     function _setupRole(bytes32 role, address account) internal virtual {
1545         _grantRole(role, account);
1546     }
1547 
1548     /**
1549      * @dev Sets `adminRole` as ``role``'s admin role.
1550      *
1551      * Emits a {RoleAdminChanged} event.
1552      */
1553     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1554         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1555         _roles[role].adminRole = adminRole;
1556     }
1557 
1558     function _grantRole(bytes32 role, address account) private {
1559         if (!hasRole(role, account)) {
1560             _roles[role].members[account] = true;
1561             emit RoleGranted(role, account, _msgSender());
1562         }
1563     }
1564 
1565     function _revokeRole(bytes32 role, address account) private {
1566         if (hasRole(role, account)) {
1567             _roles[role].members[account] = false;
1568             emit RoleRevoked(role, account, _msgSender());
1569         }
1570     }
1571 }
1572 
1573 /**
1574  * @title Counters
1575  * @author Matt Condon (@shrugs)
1576  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1577  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1578  *
1579  * Include with `using Counters for Counters.Counter;`
1580  */
1581 library Counters {
1582     struct Counter {
1583         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1584         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1585         // this feature: see https://github.com/ethereum/solidity/issues/4637
1586         uint256 _value; // default: 0
1587     }
1588 
1589     function current(Counter storage counter) internal view returns (uint256) {
1590         return counter._value;
1591     }
1592 
1593     function increment(Counter storage counter) internal {
1594         //unchecked {
1595         counter._value += 1;
1596         //}
1597     }
1598 
1599     function decrement(Counter storage counter) internal {
1600         uint256 value = counter._value;
1601         require(value > 0, "Counter: decrement overflow");
1602         //unchecked {
1603         counter._value = value - 1;
1604         //}
1605     }
1606 
1607     function reset(Counter storage counter) internal {
1608         counter._value = 0;
1609     }
1610 }
1611 
1612 contract EthermonAvatar is ERC721Enumerable, AccessControl {
1613     using Counters for Counters.Counter;
1614     Counters.Counter private _tokenIds;
1615 
1616     string _baseTokenURI = "https://avatar.ethermon.io/api/v1/token/";
1617 
1618     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1619 
1620     address public upgradedToAddress = address(0);
1621     uint256 internal _cap = 10000;
1622 
1623     constructor() ERC721("EthermonAvatar", "EAVA") {
1624         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1625         _setupRole(MINTER_ROLE, _msgSender());
1626     }
1627 
1628     function upgrade(address _upgradedToAddress) public {
1629         require(
1630             hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
1631             "Caller is not a admin"
1632         );
1633 
1634         upgradedToAddress = _upgradedToAddress;
1635     }
1636 
1637     function getCurrentTokenId() public view returns (uint256) {
1638         return _tokenIds.current();
1639     }
1640 
1641     function cap() external view returns (uint256) {
1642         return _cap;
1643     }
1644 
1645     function supportsInterface(bytes4 interfaceId)
1646         public
1647         view
1648         virtual
1649         override(ERC721Enumerable, AccessControl)
1650         returns (bool)
1651     {
1652         return super.supportsInterface(interfaceId);
1653     }
1654 
1655     function _baseURI() internal view virtual override returns (string memory) {
1656         return _baseTokenURI;
1657     }
1658 
1659     function setBaseURI(string memory baseURI) public {
1660         require(
1661             hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
1662             "Caller is not a admin"
1663         );
1664         _baseTokenURI = baseURI;
1665     }
1666 
1667     function mintNextToken(address _mintTo) external returns (bool) {
1668         _tokenIds.increment();
1669 
1670         return mint(_mintTo, _tokenIds.current());
1671     }
1672 
1673     function mint(address _mintTo, uint256 _tokenId) public returns (bool) {
1674         require(
1675             address(0) == upgradedToAddress,
1676             "Contract has been upgraded to a new address"
1677         );
1678         require(hasRole(MINTER_ROLE, _msgSender()), "Caller is not a minter");
1679         require(_mintTo != address(0), "ERC721: mint to the zero address");
1680         require(!_exists(_tokenId), "ERC721: token already minted");
1681 
1682         require(_tokenId <= _cap, "Cap reached, maximum 10000 mints possible");
1683 
1684         _safeMint(_mintTo, _tokenId);
1685 
1686         return true;
1687     }
1688 }