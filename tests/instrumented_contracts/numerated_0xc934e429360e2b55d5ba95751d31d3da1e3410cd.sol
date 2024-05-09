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
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
185 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @title ERC721 token receiver interface
190  * @dev Interface for any contract that wants to support safeTransfers
191  * from ERC721 asset contracts.
192  */
193 interface IERC721Receiver {
194     /**
195      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
196      * by `operator` from `from`, this function is called.
197      *
198      * It must return its Solidity selector to confirm the token transfer.
199      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
200      *
201      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
202      */
203     function onERC721Received(
204         address operator,
205         address from,
206         uint256 tokenId,
207         bytes calldata data
208     ) external returns (bytes4);
209 }
210 
211 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Metadata is IERC721 {
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 // File: @openzeppelin/contracts/utils/Address.sol
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         // solhint-disable-next-line no-inline-assembly
266         assembly {
267             size := extcodesize(account)
268         }
269         return size > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(
290             address(this).balance >= amount,
291             "Address: insufficient balance"
292         );
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{value: amount}("");
296         require(
297             success,
298             "Address: unable to send value, recipient may have reverted"
299         );
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data)
321         internal
322         returns (bytes memory)
323     {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return
358             functionCallWithValue(
359                 target,
360                 data,
361                 value,
362                 "Address: low-level call with value failed"
363             );
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         require(
379             address(this).balance >= value,
380             "Address: insufficient balance for call"
381         );
382         require(isContract(target), "Address: call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.call{value: value}(
386             data
387         );
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data)
398         internal
399         view
400         returns (bytes memory)
401     {
402         return
403             functionStaticCall(
404                 target,
405                 data,
406                 "Address: low-level static call failed"
407             );
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         // solhint-disable-next-line avoid-low-level-calls
424         (bool success, bytes memory returndata) = target.staticcall(data);
425         return _verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(address target, bytes memory data)
435         internal
436         returns (bytes memory)
437     {
438         return
439             functionDelegateCall(
440                 target,
441                 data,
442                 "Address: low-level delegate call failed"
443             );
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         require(isContract(target), "Address: delegate call to non-contract");
458 
459         // solhint-disable-next-line avoid-low-level-calls
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return _verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     function _verifyCallResult(
465         bool success,
466         bytes memory returndata,
467         string memory errorMessage
468     ) private pure returns (bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 // solhint-disable-next-line no-inline-assembly
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 // File: @openzeppelin/contracts/utils/Context.sol
489 pragma solidity ^0.8.0;
490 
491 /*
492  * @dev Provides information about the current execution context, including the
493  * sender of the transaction and its data. While these are generally available
494  * via msg.sender and msg.data, they should not be accessed in such a direct
495  * manner, since when dealing with meta-transactions the account sending and
496  * paying for execution may not be the actual sender (as far as an application
497  * is concerned).
498  *
499  * This contract is only required for intermediate, library-like contracts.
500  */
501 abstract contract Context {
502     function _msgSender() internal view virtual returns (address) {
503         return msg.sender;
504     }
505 
506     function _msgData() internal view virtual returns (bytes calldata) {
507         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
508         return msg.data;
509     }
510 }
511 
512 // File: @openzeppelin/contracts/utils/Strings.sol
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev String operations.
517  */
518 library Strings {
519     bytes16 private constant alphabet = "0123456789abcdef";
520 
521     /**
522      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
523      */
524     function toString(uint256 value) internal pure returns (string memory) {
525         // Inspired by OraclizeAPI's implementation - MIT licence
526         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
527 
528         if (value == 0) {
529             return "0";
530         }
531         uint256 temp = value;
532         uint256 digits;
533         while (temp != 0) {
534             digits++;
535             temp /= 10;
536         }
537         bytes memory buffer = new bytes(digits);
538         while (value != 0) {
539             digits -= 1;
540             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
541             value /= 10;
542         }
543         return string(buffer);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
548      */
549     function toHexString(uint256 value) internal pure returns (string memory) {
550         if (value == 0) {
551             return "0x00";
552         }
553         uint256 temp = value;
554         uint256 length = 0;
555         while (temp != 0) {
556             length++;
557             temp >>= 8;
558         }
559         return toHexString(value, length);
560     }
561 
562     /**
563      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
564      */
565     function toHexString(uint256 value, uint256 length)
566         internal
567         pure
568         returns (string memory)
569     {
570         bytes memory buffer = new bytes(2 * length + 2);
571         buffer[0] = "0";
572         buffer[1] = "x";
573         for (uint256 i = 2 * length + 1; i > 1; --i) {
574             buffer[i] = alphabet[value & 0xf];
575             value >>= 4;
576         }
577         require(value == 0, "Strings: hex length insufficient");
578         return string(buffer);
579     }
580 }
581 
582 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Implementation of the {IERC165} interface.
587  *
588  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
589  * for the additional interface id that will be supported. For example:
590  *
591  * ```solidity
592  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
593  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
594  * }
595  * ```
596  *
597  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
598  */
599 abstract contract ERC165 is IERC165 {
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId)
604         public
605         view
606         virtual
607         override
608         returns (bool)
609     {
610         return interfaceId == type(IERC165).interfaceId;
611     }
612 }
613 
614 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
619  * the Metadata extension, but not including the Enumerable extension, which is available separately as
620  * {ERC721Enumerable}.
621  */
622 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
623     using Address for address;
624     using Strings for uint256;
625 
626     // Token name
627     string private _name;
628 
629     // Token symbol
630     string private _symbol;
631 
632     // Mapping from token ID to owner address
633     mapping(uint256 => address) private _owners;
634 
635     // Mapping owner address to token count
636     mapping(address => uint256) private _balances;
637 
638     // Mapping from token ID to approved address
639     mapping(uint256 => address) private _tokenApprovals;
640 
641     // Mapping from owner to operator approvals
642     mapping(address => mapping(address => bool)) private _operatorApprovals;
643 
644     /**
645      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
646      */
647     constructor(string memory name_, string memory symbol_) {
648         _name = name_;
649         _symbol = symbol_;
650     }
651 
652     /**
653      * @dev See {IERC165-supportsInterface}.
654      */
655     function supportsInterface(bytes4 interfaceId)
656         public
657         view
658         virtual
659         override(ERC165, IERC165)
660         returns (bool)
661     {
662         return
663             interfaceId == type(IERC721).interfaceId ||
664             interfaceId == type(IERC721Metadata).interfaceId ||
665             super.supportsInterface(interfaceId);
666     }
667 
668     /**
669      * @dev See {IERC721-balanceOf}.
670      */
671     function balanceOf(address owner)
672         public
673         view
674         virtual
675         override
676         returns (uint256)
677     {
678         require(
679             owner != address(0),
680             "ERC721: balance query for the zero address"
681         );
682         return _balances[owner];
683     }
684 
685     /**
686      * @dev See {IERC721-ownerOf}.
687      */
688     function ownerOf(uint256 tokenId)
689         public
690         view
691         virtual
692         override
693         returns (address)
694     {
695         address owner = _owners[tokenId];
696         require(
697             owner != address(0),
698             "ERC721: owner query for nonexistent token"
699         );
700         return owner;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-name}.
705      */
706     function name() public view virtual override returns (string memory) {
707         return _name;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-symbol}.
712      */
713     function symbol() public view virtual override returns (string memory) {
714         return _symbol;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-tokenURI}.
719      */
720     function tokenURI(uint256 tokenId)
721         public
722         view
723         virtual
724         override
725         returns (string memory)
726     {
727         require(
728             _exists(tokenId),
729             "ERC721Metadata: URI query for nonexistent token"
730         );
731 
732         string memory baseURI = _baseURI();
733         return
734             bytes(baseURI).length > 0
735                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
736                 : "";
737     }
738 
739     /**
740      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
741      * in child contracts.
742      */
743     function _baseURI() internal view virtual returns (string memory) {
744         return "";
745     }
746 
747     /**
748      * @dev See {IERC721-approve}.
749      */
750     function approve(address to, uint256 tokenId) public virtual override {
751         address owner = ERC721.ownerOf(tokenId);
752         require(to != owner, "ERC721: approval to current owner");
753 
754         require(
755             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
756             "ERC721: approve caller is not owner nor approved for all"
757         );
758 
759         _approve(to, tokenId);
760     }
761 
762     /**
763      * @dev See {IERC721-getApproved}.
764      */
765     function getApproved(uint256 tokenId)
766         public
767         view
768         virtual
769         override
770         returns (address)
771     {
772         require(
773             _exists(tokenId),
774             "ERC721: approved query for nonexistent token"
775         );
776 
777         return _tokenApprovals[tokenId];
778     }
779 
780     /**
781      * @dev See {IERC721-setApprovalForAll}.
782      */
783     function setApprovalForAll(address operator, bool approved)
784         public
785         virtual
786         override
787     {
788         require(operator != _msgSender(), "ERC721: approve to caller");
789 
790         _operatorApprovals[_msgSender()][operator] = approved;
791         emit ApprovalForAll(_msgSender(), operator, approved);
792     }
793 
794     /**
795      * @dev See {IERC721-isApprovedForAll}.
796      */
797     function isApprovedForAll(address owner, address operator)
798         public
799         view
800         virtual
801         override
802         returns (bool)
803     {
804         return _operatorApprovals[owner][operator];
805     }
806 
807     /**
808      * @dev See {IERC721-transferFrom}.
809      */
810     function transferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public virtual override {
815         //solhint-disable-next-line max-line-length
816         require(
817             _isApprovedOrOwner(_msgSender(), tokenId),
818             "ERC721: transfer caller is not owner nor approved"
819         );
820 
821         _transfer(from, to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-safeTransferFrom}.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) public virtual override {
832         safeTransferFrom(from, to, tokenId, "");
833     }
834 
835     /**
836      * @dev See {IERC721-safeTransferFrom}.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) public virtual override {
844         require(
845             _isApprovedOrOwner(_msgSender(), tokenId),
846             "ERC721: transfer caller is not owner nor approved"
847         );
848         _safeTransfer(from, to, tokenId, _data);
849     }
850 
851     /**
852      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
853      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
854      *
855      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
856      *
857      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
858      * implement alternative mechanisms to perform token transfer, such as signature-based.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must exist and be owned by `from`.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _safeTransfer(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes memory _data
874     ) internal virtual {
875         _transfer(from, to, tokenId);
876         require(
877             _checkOnERC721Received(from, to, tokenId, _data),
878             "ERC721: transfer to non ERC721Receiver implementer"
879         );
880     }
881 
882     /**
883      * @dev Returns whether `tokenId` exists.
884      *
885      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
886      *
887      * Tokens start existing when they are minted (`_mint`),
888      * and stop existing when they are burned (`_burn`).
889      */
890     function _exists(uint256 tokenId) internal view virtual returns (bool) {
891         return _owners[tokenId] != address(0);
892     }
893 
894     /**
895      * @dev Returns whether `spender` is allowed to manage `tokenId`.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function _isApprovedOrOwner(address spender, uint256 tokenId)
902         internal
903         view
904         virtual
905         returns (bool)
906     {
907         require(
908             _exists(tokenId),
909             "ERC721: operator query for nonexistent token"
910         );
911         address owner = ERC721.ownerOf(tokenId);
912         return (spender == owner ||
913             getApproved(tokenId) == spender ||
914             isApprovedForAll(owner, spender));
915     }
916 
917     /**
918      * @dev Safely mints `tokenId` and transfers it to `to`.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must not exist.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeMint(address to, uint256 tokenId) internal virtual {
928         _safeMint(to, tokenId, "");
929     }
930 
931     /**
932      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
933      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
934      */
935     function _safeMint(
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) internal virtual {
940         _mint(to, tokenId);
941         require(
942             _checkOnERC721Received(address(0), to, tokenId, _data),
943             "ERC721: transfer to non ERC721Receiver implementer"
944         );
945     }
946 
947     /**
948      * @dev Mints `tokenId` and transfers it to `to`.
949      *
950      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
951      *
952      * Requirements:
953      *
954      * - `tokenId` must not exist.
955      * - `to` cannot be the zero address.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _mint(address to, uint256 tokenId) internal virtual {
960         require(to != address(0), "ERC721: mint to the zero address");
961         require(!_exists(tokenId), "ERC721: token already minted");
962 
963         _beforeTokenTransfer(address(0), to, tokenId);
964 
965         _balances[to] += 1;
966         _owners[tokenId] = to;
967 
968         emit Transfer(address(0), to, tokenId);
969     }
970 
971     /**
972      * @dev Destroys `tokenId`.
973      * The approval is cleared when the token is burned.
974      *
975      * Requirements:
976      *
977      * - `tokenId` must exist.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _burn(uint256 tokenId) internal virtual {
982         address owner = ERC721.ownerOf(tokenId);
983 
984         _beforeTokenTransfer(owner, address(0), tokenId);
985 
986         // Clear approvals
987         _approve(address(0), tokenId);
988 
989         _balances[owner] -= 1;
990         delete _owners[tokenId];
991 
992         emit Transfer(owner, address(0), tokenId);
993     }
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) internal virtual {
1011         require(
1012             ERC721.ownerOf(tokenId) == from,
1013             "ERC721: transfer of token that is not own"
1014         );
1015         require(to != address(0), "ERC721: transfer to the zero address");
1016 
1017         _beforeTokenTransfer(from, to, tokenId);
1018 
1019         // Clear approvals from the previous owner
1020         _approve(address(0), tokenId);
1021 
1022         _balances[from] -= 1;
1023         _balances[to] += 1;
1024         _owners[tokenId] = to;
1025 
1026         emit Transfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev Approve `to` to operate on `tokenId`
1031      *
1032      * Emits a {Approval} event.
1033      */
1034     function _approve(address to, uint256 tokenId) internal virtual {
1035         _tokenApprovals[tokenId] = to;
1036         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1041      * The call is not executed if the target address is not a contract.
1042      *
1043      * @param from address representing the previous owner of the given token ID
1044      * @param to target address that will receive the tokens
1045      * @param tokenId uint256 ID of the token to be transferred
1046      * @param _data bytes optional data to send along with the call
1047      * @return bool whether the call correctly returned the expected magic value
1048      */
1049     function _checkOnERC721Received(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) private returns (bool) {
1055         if (to.isContract()) {
1056             try
1057                 IERC721Receiver(to).onERC721Received(
1058                     _msgSender(),
1059                     from,
1060                     tokenId,
1061                     _data
1062                 )
1063             returns (bytes4 retval) {
1064                 return retval == IERC721Receiver(to).onERC721Received.selector;
1065             } catch (bytes memory reason) {
1066                 if (reason.length == 0) {
1067                     revert(
1068                         "ERC721: transfer to non ERC721Receiver implementer"
1069                     );
1070                 } else {
1071                     // solhint-disable-next-line no-inline-assembly
1072                     assembly {
1073                         revert(add(32, reason), mload(reason))
1074                     }
1075                 }
1076             }
1077         } else {
1078             return true;
1079         }
1080     }
1081 
1082     /**
1083      * @dev Hook that is called before any token transfer. This includes minting
1084      * and burning.
1085      *
1086      * Calling conditions:
1087      *
1088      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1089      * transferred to `to`.
1090      * - When `from` is zero, `tokenId` will be minted for `to`.
1091      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1092      * - `from` cannot be the zero address.
1093      * - `to` cannot be the zero address.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _beforeTokenTransfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) internal virtual {}
1102 }
1103 
1104 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1105 pragma solidity ^0.8.0;
1106 
1107 /**
1108  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1109  * @dev See https://eips.ethereum.org/EIPS/eip-721
1110  */
1111 interface IERC721Enumerable is IERC721 {
1112     /**
1113      * @dev Returns the total amount of tokens stored by the contract.
1114      */
1115     function totalSupply() external view returns (uint256);
1116 
1117     /**
1118      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1119      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1120      */
1121     function tokenOfOwnerByIndex(address owner, uint256 index)
1122         external
1123         view
1124         returns (uint256 tokenId);
1125 
1126     /**
1127      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1128      * Use along with {totalSupply} to enumerate all tokens.
1129      */
1130     function tokenByIndex(uint256 index) external view returns (uint256);
1131 }
1132 
1133 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1134 pragma solidity ^0.8.0;
1135 
1136 /**
1137  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1138  * enumerability of all the token ids in the contract as well as all token ids owned by each
1139  * account.
1140  */
1141 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1142     // Mapping from owner to list of owned token IDs
1143     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1144 
1145     // Mapping from token ID to index of the owner tokens list
1146     mapping(uint256 => uint256) private _ownedTokensIndex;
1147 
1148     // Array with all token ids, used for enumeration
1149     uint256[] private _allTokens;
1150 
1151     // Mapping from token id to position in the allTokens array
1152     mapping(uint256 => uint256) private _allTokensIndex;
1153 
1154     /**
1155      * @dev See {IERC165-supportsInterface}.
1156      */
1157     function supportsInterface(bytes4 interfaceId)
1158         public
1159         view
1160         virtual
1161         override(IERC165, ERC721)
1162         returns (bool)
1163     {
1164         return
1165             interfaceId == type(IERC721Enumerable).interfaceId ||
1166             super.supportsInterface(interfaceId);
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1171      */
1172     function tokenOfOwnerByIndex(address owner, uint256 index)
1173         public
1174         view
1175         virtual
1176         override
1177         returns (uint256)
1178     {
1179         require(
1180             index < ERC721.balanceOf(owner),
1181             "ERC721Enumerable: owner index out of bounds"
1182         );
1183         return _ownedTokens[owner][index];
1184     }
1185 
1186     /**
1187      * @dev See {IERC721Enumerable-totalSupply}.
1188      */
1189     function totalSupply() public view virtual override returns (uint256) {
1190         return _allTokens.length;
1191     }
1192 
1193     /**
1194      * @dev See {IERC721Enumerable-tokenByIndex}.
1195      */
1196     function tokenByIndex(uint256 index)
1197         public
1198         view
1199         virtual
1200         override
1201         returns (uint256)
1202     {
1203         require(
1204             index < ERC721Enumerable.totalSupply(),
1205             "ERC721Enumerable: global index out of bounds"
1206         );
1207         return _allTokens[index];
1208     }
1209 
1210     /**
1211      * @dev Hook that is called before any token transfer. This includes minting
1212      * and burning.
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` will be minted for `to`.
1219      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1220      * - `from` cannot be the zero address.
1221      * - `to` cannot be the zero address.
1222      *
1223      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1224      */
1225     function _beforeTokenTransfer(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) internal virtual override {
1230         super._beforeTokenTransfer(from, to, tokenId);
1231 
1232         if (from == address(0)) {
1233             _addTokenToAllTokensEnumeration(tokenId);
1234         } else if (from != to) {
1235             _removeTokenFromOwnerEnumeration(from, tokenId);
1236         }
1237         if (to == address(0)) {
1238             _removeTokenFromAllTokensEnumeration(tokenId);
1239         } else if (to != from) {
1240             _addTokenToOwnerEnumeration(to, tokenId);
1241         }
1242     }
1243 
1244     /**
1245      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1246      * @param to address representing the new owner of the given token ID
1247      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1248      */
1249     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1250         uint256 length = ERC721.balanceOf(to);
1251         _ownedTokens[to][length] = tokenId;
1252         _ownedTokensIndex[tokenId] = length;
1253     }
1254 
1255     /**
1256      * @dev Private function to add a token to this extension's token tracking data structures.
1257      * @param tokenId uint256 ID of the token to be added to the tokens list
1258      */
1259     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1260         _allTokensIndex[tokenId] = _allTokens.length;
1261         _allTokens.push(tokenId);
1262     }
1263 
1264     /**
1265      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1266      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1267      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1268      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1269      * @param from address representing the previous owner of the given token ID
1270      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1271      */
1272     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1273         private
1274     {
1275         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1276         // then delete the last slot (swap and pop).
1277 
1278         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1279         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1280 
1281         // When the token to delete is the last token, the swap operation is unnecessary
1282         if (tokenIndex != lastTokenIndex) {
1283             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1284 
1285             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1286             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1287         }
1288 
1289         // This also deletes the contents at the last position of the array
1290         delete _ownedTokensIndex[tokenId];
1291         delete _ownedTokens[from][lastTokenIndex];
1292     }
1293 
1294     /**
1295      * @dev Private function to remove a token from this extension's token tracking data structures.
1296      * This has O(1) time complexity, but alters the order of the _allTokens array.
1297      * @param tokenId uint256 ID of the token to be removed from the tokens list
1298      */
1299     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1300         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1301         // then delete the last slot (swap and pop).
1302 
1303         uint256 lastTokenIndex = _allTokens.length - 1;
1304         uint256 tokenIndex = _allTokensIndex[tokenId];
1305 
1306         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1307         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1308         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1309         uint256 lastTokenId = _allTokens[lastTokenIndex];
1310 
1311         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1312         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1313 
1314         // This also deletes the contents at the last position of the array
1315         delete _allTokensIndex[tokenId];
1316         _allTokens.pop();
1317     }
1318 }
1319 
1320 // File: @openzeppelin/contracts/access/Ownable.sol
1321 pragma solidity ^0.8.0;
1322 
1323 /**
1324  * @dev Contract module which provides a basic access control mechanism, where
1325  * there is an account (an owner) that can be granted exclusive access to
1326  * specific functions.
1327  *
1328  * By default, the owner account will be the one that deploys the contract. This
1329  * can later be changed with {transferOwnership}.
1330  *
1331  * This module is used through inheritance. It will make available the modifier
1332  * `onlyOwner`, which can be applied to your functions to restrict their use to
1333  * the owner.
1334  */
1335 abstract contract Ownable is Context {
1336     address private _owner;
1337 
1338     event OwnershipTransferred(
1339         address indexed previousOwner,
1340         address indexed newOwner
1341     );
1342 
1343     /**
1344      * @dev Initializes the contract setting the deployer as the initial owner.
1345      */
1346     constructor() {
1347         address msgSender = _msgSender();
1348         _owner = msgSender;
1349         emit OwnershipTransferred(address(0), msgSender);
1350     }
1351 
1352     /**
1353      * @dev Returns the address of the current owner.
1354      */
1355     function owner() public view virtual returns (address) {
1356         return _owner;
1357     }
1358 
1359     /**
1360      * @dev Throws if called by any account other than the owner.
1361      */
1362     modifier onlyOwner() {
1363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1364         _;
1365     }
1366 
1367     /**
1368      * @dev Leaves the contract without owner. It will not be possible to call
1369      * `onlyOwner` functions anymore. Can only be called by the current owner.
1370      *
1371      * NOTE: Renouncing ownership will leave the contract without an owner,
1372      * thereby removing any functionality that is only available to the owner.
1373      */
1374     function renounceOwnership() public virtual onlyOwner {
1375         emit OwnershipTransferred(_owner, address(0));
1376         _owner = address(0);
1377     }
1378 
1379     /**
1380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1381      * Can only be called by the current owner.
1382      */
1383     function transferOwnership(address newOwner) public virtual onlyOwner {
1384         require(
1385             newOwner != address(0),
1386             "Ownable: new owner is the zero address"
1387         );
1388         emit OwnershipTransferred(_owner, newOwner);
1389         _owner = newOwner;
1390     }
1391 }
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 interface IParadise {
1396     function ownerOf(uint256 tokenId) external view returns (address);
1397     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1398     function balanceOf(address owner) external view returns (uint256 balance);
1399 }
1400 
1401 contract CosmicTrippies is ERC721Enumerable, Ownable {
1402     IParadise private TOKEN =
1403         IParadise(0x4cA4d3B5B01207FfCe9beA2Db9857d4804Aa89F3);
1404 
1405     uint256 public maxSupply = 10000;
1406     bool public claimingActive = false;
1407     string private baseURI;
1408 
1409     constructor() ERC721("CosmicTrippies", "CTRIPPY") {
1410     }
1411 
1412     function isMinted(uint256 tokenId) external view returns (bool) {
1413         return _exists(tokenId);
1414     }
1415 
1416     function _baseURI() internal view override returns (string memory) {
1417         return baseURI;
1418     }
1419 
1420     function setBaseURI(string memory uri) public onlyOwner {
1421         baseURI = uri;
1422     }
1423 
1424     function setClaimingActive(bool value) public onlyOwner {
1425         claimingActive = value;
1426     }
1427 
1428     function teamMint(address recipient, uint256 tokenId) public onlyOwner {
1429         require(!_exists(tokenId), "Token exists");
1430         require(totalSupply() + 1 <= maxSupply, "Max supply reached");
1431 
1432         _safeMint(recipient, tokenId);
1433     }
1434 
1435     function teamMintBatch(address[] memory targets, uint256[] memory tokenIds) public onlyOwner {
1436         require(targets.length == tokenIds.length, "Length mismatch");
1437         require(totalSupply() + tokenIds.length <= maxSupply, "Max supply reached");
1438 
1439         for (uint256 i = 0; i < tokenIds.length; i++) {
1440             require(!_exists(tokenIds[i]), "Token exists");
1441 
1442             _safeMint(targets[i], tokenIds[i]);
1443         }
1444     }
1445 
1446     function mint(uint256 tokenId) public {
1447         require(claimingActive, "Claiming is not currently active");
1448         require(totalSupply() + 1 <= maxSupply, "Exceeds max supply");
1449         require(!_exists(tokenId), "Token already exists");
1450         require(tokenId < maxSupply, "Requested tokenId is out of range");
1451         require(TOKEN.ownerOf(tokenId) == msg.sender, "You do not own the corresponding token");
1452 
1453         _safeMint(msg.sender, tokenId);
1454     }
1455 
1456     function mintBatch(uint256 quantity) public {
1457         require(claimingActive, "Claiming is not currently active");
1458         require(quantity > 0, "Must mint at least 1 token");
1459 
1460         uint256 balance = TOKEN.balanceOf(msg.sender);
1461         require(balance > 0, "Must hold at least 1 Trippy");
1462         require(balance >= quantity, "Quantity exceeds balance");
1463 
1464         for(uint256 i = 0; i < balance && i < quantity; i++) {
1465             require(totalSupply() < maxSupply, "Exceeds max supply");
1466             uint256 tokenId = TOKEN.tokenOfOwnerByIndex(msg.sender, i);
1467             if (!_exists(tokenId)) {
1468                 _safeMint(msg.sender, tokenId);
1469             }
1470         }
1471     }
1472 
1473     function mintBatch() public {
1474         require(claimingActive, "Claiming is not currently active");
1475 
1476         uint256 balance = TOKEN.balanceOf(msg.sender);
1477         require(balance > 0, "Must hold at least 1 Trippie");
1478 
1479         for(uint256 i = 0; i < balance; i++) {
1480             require(totalSupply() + 1 <= maxSupply, "Exceeds max supply");
1481             uint256 tokenId = TOKEN.tokenOfOwnerByIndex(msg.sender, i);
1482             if (!_exists(tokenId)) {
1483                 _safeMint(msg.sender, tokenId);
1484             }
1485         }
1486     }
1487 }