1 // SPDX-License-Identifier: GPL-3.0
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
185 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
190  * @dev See https://eips.ethereum.org/EIPS/eip-721
191  */
192 interface IERC721Enumerable is IERC721 {
193     /**
194      * @dev Returns the total amount of tokens stored by the contract.
195      */
196     function totalSupply() external view returns (uint256);
197 
198     /**
199      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
200      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
201      */
202     function tokenOfOwnerByIndex(address owner, uint256 index)
203         external
204         view
205         returns (uint256 tokenId);
206 
207     /**
208      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
209      * Use along with {totalSupply} to enumerate all tokens.
210      */
211     function tokenByIndex(uint256 index) external view returns (uint256);
212 }
213 
214 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Implementation of the {IERC165} interface.
219  *
220  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
221  * for the additional interface id that will be supported. For example:
222  *
223  * ```solidity
224  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
225  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
226  * }
227  * ```
228  *
229  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
230  */
231 abstract contract ERC165 is IERC165 {
232     /**
233      * @dev See {IERC165-supportsInterface}.
234      */
235     function supportsInterface(bytes4 interfaceId)
236         public
237         view
238         virtual
239         override
240         returns (bool)
241     {
242         return interfaceId == type(IERC165).interfaceId;
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Strings.sol
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev String operations.
252  */
253 library Strings {
254     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
255 
256     /**
257      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
258      */
259     function toString(uint256 value) internal pure returns (string memory) {
260         // Inspired by OraclizeAPI's implementation - MIT licence
261         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
262 
263         if (value == 0) {
264             return "0";
265         }
266         uint256 temp = value;
267         uint256 digits;
268         while (temp != 0) {
269             digits++;
270             temp /= 10;
271         }
272         bytes memory buffer = new bytes(digits);
273         while (value != 0) {
274             digits -= 1;
275             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
276             value /= 10;
277         }
278         return string(buffer);
279     }
280 
281     /**
282      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
283      */
284     function toHexString(uint256 value) internal pure returns (string memory) {
285         if (value == 0) {
286             return "0x00";
287         }
288         uint256 temp = value;
289         uint256 length = 0;
290         while (temp != 0) {
291             length++;
292             temp >>= 8;
293         }
294         return toHexString(value, length);
295     }
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
299      */
300     function toHexString(uint256 value, uint256 length)
301         internal
302         pure
303         returns (string memory)
304     {
305         bytes memory buffer = new bytes(2 * length + 2);
306         buffer[0] = "0";
307         buffer[1] = "x";
308         for (uint256 i = 2 * length + 1; i > 1; --i) {
309             buffer[i] = _HEX_SYMBOLS[value & 0xf];
310             value >>= 4;
311         }
312         require(value == 0, "Strings: hex length insufficient");
313         return string(buffer);
314     }
315 }
316 
317 // File: @openzeppelin/contracts/utils/Address.sol
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Collection of functions related to the address type
323  */
324 library Address {
325     /**
326      * @dev Returns true if `account` is a contract.
327      *
328      * [IMPORTANT]
329      * ====
330      * It is unsafe to assume that an address for which this function returns
331      * false is an externally-owned account (EOA) and not a contract.
332      *
333      * Among others, `isContract` will return false for the following
334      * types of addresses:
335      *
336      *  - an externally-owned account
337      *  - a contract in construction
338      *  - an address where a contract will be created
339      *  - an address where a contract lived, but was destroyed
340      * ====
341      */
342     function isContract(address account) internal view returns (bool) {
343         // This method relies on extcodesize, which returns 0 for contracts in
344         // construction, since the code is only stored at the end of the
345         // constructor execution.
346 
347         uint256 size;
348         assembly {
349             size := extcodesize(account)
350         }
351         return size > 0;
352     }
353 
354     /**
355      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
356      * `recipient`, forwarding all available gas and reverting on errors.
357      *
358      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
359      * of certain opcodes, possibly making contracts go over the 2300 gas limit
360      * imposed by `transfer`, making them unable to receive funds via
361      * `transfer`. {sendValue} removes this limitation.
362      *
363      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
364      *
365      * IMPORTANT: because control is transferred to `recipient`, care must be
366      * taken to not create reentrancy vulnerabilities. Consider using
367      * {ReentrancyGuard} or the
368      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
369      */
370     function sendValue(address payable recipient, uint256 amount) internal {
371         require(
372             address(this).balance >= amount,
373             "Address: insufficient balance"
374         );
375 
376         (bool success, ) = recipient.call{value: amount}("");
377         require(
378             success,
379             "Address: unable to send value, recipient may have reverted"
380         );
381     }
382 
383     /**
384      * @dev Performs a Solidity function call using a low level `call`. A
385      * plain `call` is an unsafe replacement for a function call: use this
386      * function instead.
387      *
388      * If `target` reverts with a revert reason, it is bubbled up by this
389      * function (like regular Solidity function calls).
390      *
391      * Returns the raw returned data. To convert to the expected return value,
392      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
393      *
394      * Requirements:
395      *
396      * - `target` must be a contract.
397      * - calling `target` with `data` must not revert.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(address target, bytes memory data)
402         internal
403         returns (bytes memory)
404     {
405         return functionCall(target, data, "Address: low-level call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
410      * `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, 0, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but also transferring `value` wei to `target`.
425      *
426      * Requirements:
427      *
428      * - the calling contract must have an ETH balance of at least `value`.
429      * - the called Solidity function must be `payable`.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value
437     ) internal returns (bytes memory) {
438         return
439             functionCallWithValue(
440                 target,
441                 data,
442                 value,
443                 "Address: low-level call with value failed"
444             );
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
449      * with `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(
460             address(this).balance >= value,
461             "Address: insufficient balance for call"
462         );
463         require(isContract(target), "Address: call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.call{value: value}(
466             data
467         );
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data)
478         internal
479         view
480         returns (bytes memory)
481     {
482         return
483             functionStaticCall(
484                 target,
485                 data,
486                 "Address: low-level static call failed"
487             );
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(
497         address target,
498         bytes memory data,
499         string memory errorMessage
500     ) internal view returns (bytes memory) {
501         require(isContract(target), "Address: static call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.staticcall(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a delegate call.
510      *
511      * _Available since v3.4._
512      */
513     function functionDelegateCall(address target, bytes memory data)
514         internal
515         returns (bytes memory)
516     {
517         return
518             functionDelegateCall(
519                 target,
520                 data,
521                 "Address: low-level delegate call failed"
522             );
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a delegate call.
528      *
529      * _Available since v3.4._
530      */
531     function functionDelegateCall(
532         address target,
533         bytes memory data,
534         string memory errorMessage
535     ) internal returns (bytes memory) {
536         require(isContract(target), "Address: delegate call to non-contract");
537 
538         (bool success, bytes memory returndata) = target.delegatecall(data);
539         return verifyCallResult(success, returndata, errorMessage);
540     }
541 
542     /**
543      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
544      * revert reason using the provided one.
545      *
546      * _Available since v4.3._
547      */
548     function verifyCallResult(
549         bool success,
550         bytes memory returndata,
551         string memory errorMessage
552     ) internal pure returns (bytes memory) {
553         if (success) {
554             return returndata;
555         } else {
556             // Look for revert reason and bubble it up if present
557             if (returndata.length > 0) {
558                 // The easiest way to bubble the revert reason is using memory via assembly
559 
560                 assembly {
561                     let returndata_size := mload(returndata)
562                     revert(add(32, returndata), returndata_size)
563                 }
564             } else {
565                 revert(errorMessage);
566             }
567         }
568     }
569 }
570 
571 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
577  * @dev See https://eips.ethereum.org/EIPS/eip-721
578  */
579 interface IERC721Metadata is IERC721 {
580     /**
581      * @dev Returns the token collection name.
582      */
583     function name() external view returns (string memory);
584 
585     /**
586      * @dev Returns the token collection symbol.
587      */
588     function symbol() external view returns (string memory);
589 
590     /**
591      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
592      */
593     function tokenURI(uint256 tokenId) external view returns (string memory);
594 }
595 
596 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
597 
598 pragma solidity ^0.8.0;
599 
600 /**
601  * @title ERC721 token receiver interface
602  * @dev Interface for any contract that wants to support safeTransfers
603  * from ERC721 asset contracts.
604  */
605 interface IERC721Receiver {
606     /**
607      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
608      * by `operator` from `from`, this function is called.
609      *
610      * It must return its Solidity selector to confirm the token transfer.
611      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
612      *
613      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
614      */
615     function onERC721Received(
616         address operator,
617         address from,
618         uint256 tokenId,
619         bytes calldata data
620     ) external returns (bytes4);
621 }
622 
623 // File: @openzeppelin/contracts/utils/Context.sol
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev Provides information about the current execution context, including the
628  * sender of the transaction and its data. While these are generally available
629  * via msg.sender and msg.data, they should not be accessed in such a direct
630  * manner, since when dealing with meta-transactions the account sending and
631  * paying for execution may not be the actual sender (as far as an application
632  * is concerned).
633  *
634  * This contract is only required for intermediate, library-like contracts.
635  */
636 abstract contract Context {
637     function _msgSender() internal view virtual returns (address) {
638         return msg.sender;
639     }
640 
641     function _msgData() internal view virtual returns (bytes calldata) {
642         return msg.data;
643     }
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
647 pragma solidity ^0.8.0;
648 
649 /**
650  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
651  * the Metadata extension, but not including the Enumerable extension, which is available separately as
652  * {ERC721Enumerable}.
653  */
654 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
655     using Address for address;
656     using Strings for uint256;
657 
658     // Token name
659     string private _name;
660 
661     // Token symbol
662     string private _symbol;
663 
664     // Mapping from token ID to owner address
665     mapping(uint256 => address) private _owners;
666 
667     // Mapping owner address to token count
668     mapping(address => uint256) private _balances;
669 
670     // Mapping from token ID to approved address
671     mapping(uint256 => address) private _tokenApprovals;
672 
673     // Mapping from owner to operator approvals
674     mapping(address => mapping(address => bool)) private _operatorApprovals;
675 
676     /**
677      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
678      */
679     constructor(string memory name_, string memory symbol_) {
680         _name = name_;
681         _symbol = symbol_;
682     }
683 
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId)
688         public
689         view
690         virtual
691         override(ERC165, IERC165)
692         returns (bool)
693     {
694         return
695             interfaceId == type(IERC721).interfaceId ||
696             interfaceId == type(IERC721Metadata).interfaceId ||
697             super.supportsInterface(interfaceId);
698     }
699 
700     /**
701      * @dev See {IERC721-balanceOf}.
702      */
703     function balanceOf(address owner)
704         public
705         view
706         virtual
707         override
708         returns (uint256)
709     {
710         require(
711             owner != address(0),
712             "ERC721: balance query for the zero address"
713         );
714         return _balances[owner];
715     }
716 
717     /**
718      * @dev See {IERC721-ownerOf}.
719      */
720     function ownerOf(uint256 tokenId)
721         public
722         view
723         virtual
724         override
725         returns (address)
726     {
727         address owner = _owners[tokenId];
728         require(
729             owner != address(0),
730             "ERC721: owner query for nonexistent token"
731         );
732         return owner;
733     }
734 
735     /**
736      * @dev See {IERC721Metadata-name}.
737      */
738     function name() public view virtual override returns (string memory) {
739         return _name;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-symbol}.
744      */
745     function symbol() public view virtual override returns (string memory) {
746         return _symbol;
747     }
748 
749     /**
750      * @dev See {IERC721Metadata-tokenURI}.
751      */
752     function tokenURI(uint256 tokenId)
753         public
754         view
755         virtual
756         override
757         returns (string memory)
758     {
759         require(
760             _exists(tokenId),
761             "ERC721Metadata: URI query for nonexistent token"
762         );
763 
764         string memory baseURI = _baseURI();
765         return
766             bytes(baseURI).length > 0
767                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
768                 : "";
769     }
770 
771     /**
772      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
773      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
774      * by default, can be overriden in child contracts.
775      */
776     function _baseURI() internal view virtual returns (string memory) {
777         return "";
778     }
779 
780     /**
781      * @dev See {IERC721-approve}.
782      */
783     function approve(address to, uint256 tokenId) public virtual override {
784         address owner = ERC721.ownerOf(tokenId);
785         require(to != owner, "ERC721: approval to current owner");
786 
787         require(
788             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
789             "ERC721: approve caller is not owner nor approved for all"
790         );
791 
792         _approve(to, tokenId);
793     }
794 
795     /**
796      * @dev See {IERC721-getApproved}.
797      */
798     function getApproved(uint256 tokenId)
799         public
800         view
801         virtual
802         override
803         returns (address)
804     {
805         require(
806             _exists(tokenId),
807             "ERC721: approved query for nonexistent token"
808         );
809 
810         return _tokenApprovals[tokenId];
811     }
812 
813     /**
814      * @dev See {IERC721-setApprovalForAll}.
815      */
816     function setApprovalForAll(address operator, bool approved)
817         public
818         virtual
819         override
820     {
821         require(operator != _msgSender(), "ERC721: approve to caller");
822 
823         _operatorApprovals[_msgSender()][operator] = approved;
824         emit ApprovalForAll(_msgSender(), operator, approved);
825     }
826 
827     /**
828      * @dev See {IERC721-isApprovedForAll}.
829      */
830     function isApprovedForAll(address owner, address operator)
831         public
832         view
833         virtual
834         override
835         returns (bool)
836     {
837         return _operatorApprovals[owner][operator];
838     }
839 
840     /**
841      * @dev See {IERC721-transferFrom}.
842      */
843     function transferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         //solhint-disable-next-line max-line-length
849         require(
850             _isApprovedOrOwner(_msgSender(), tokenId),
851             "ERC721: transfer caller is not owner nor approved"
852         );
853 
854         _transfer(from, to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         safeTransferFrom(from, to, tokenId, "");
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) public virtual override {
877         require(
878             _isApprovedOrOwner(_msgSender(), tokenId),
879             "ERC721: transfer caller is not owner nor approved"
880         );
881         _safeTransfer(from, to, tokenId, _data);
882     }
883 
884     /**
885      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
886      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
887      *
888      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
889      *
890      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
891      * implement alternative mechanisms to perform token transfer, such as signature-based.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must exist and be owned by `from`.
898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _safeTransfer(
903         address from,
904         address to,
905         uint256 tokenId,
906         bytes memory _data
907     ) internal virtual {
908         _transfer(from, to, tokenId);
909         require(
910             _checkOnERC721Received(from, to, tokenId, _data),
911             "ERC721: transfer to non ERC721Receiver implementer"
912         );
913     }
914 
915     /**
916      * @dev Returns whether `tokenId` exists.
917      *
918      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
919      *
920      * Tokens start existing when they are minted (`_mint`),
921      * and stop existing when they are burned (`_burn`).
922      */
923     function _exists(uint256 tokenId) internal view virtual returns (bool) {
924         return _owners[tokenId] != address(0);
925     }
926 
927     /**
928      * @dev Returns whether `spender` is allowed to manage `tokenId`.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must exist.
933      */
934     function _isApprovedOrOwner(address spender, uint256 tokenId)
935         internal
936         view
937         virtual
938         returns (bool)
939     {
940         require(
941             _exists(tokenId),
942             "ERC721: operator query for nonexistent token"
943         );
944         address owner = ERC721.ownerOf(tokenId);
945         return (spender == owner ||
946             getApproved(tokenId) == spender ||
947             isApprovedForAll(owner, spender));
948     }
949 
950     /**
951      * @dev Safely mints `tokenId` and transfers it to `to`.
952      *
953      * Requirements:
954      *
955      * - `tokenId` must not exist.
956      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _safeMint(address to, uint256 tokenId) internal virtual {
961         _safeMint(to, tokenId, "");
962     }
963 
964     /**
965      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
966      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
967      */
968     function _safeMint(
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) internal virtual {
973         _mint(to, tokenId);
974         require(
975             _checkOnERC721Received(address(0), to, tokenId, _data),
976             "ERC721: transfer to non ERC721Receiver implementer"
977         );
978     }
979 
980     /**
981      * @dev Mints `tokenId` and transfers it to `to`.
982      *
983      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
984      *
985      * Requirements:
986      *
987      * - `tokenId` must not exist.
988      * - `to` cannot be the zero address.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _mint(address to, uint256 tokenId) internal virtual {
993         require(to != address(0), "ERC721: mint to the zero address");
994         require(!_exists(tokenId), "ERC721: token already minted");
995 
996         _beforeTokenTransfer(address(0), to, tokenId);
997 
998         _balances[to] += 1;
999         _owners[tokenId] = to;
1000 
1001         emit Transfer(address(0), to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Destroys `tokenId`.
1006      * The approval is cleared when the token is burned.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _burn(uint256 tokenId) internal virtual {
1015         address owner = ERC721.ownerOf(tokenId);
1016 
1017         _beforeTokenTransfer(owner, address(0), tokenId);
1018 
1019         // Clear approvals
1020         _approve(address(0), tokenId);
1021 
1022         _balances[owner] -= 1;
1023         delete _owners[tokenId];
1024 
1025         emit Transfer(owner, address(0), tokenId);
1026     }
1027 
1028     /**
1029      * @dev Transfers `tokenId` from `from` to `to`.
1030      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must be owned by `from`.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _transfer(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) internal virtual {
1044         require(
1045             ERC721.ownerOf(tokenId) == from,
1046             "ERC721: transfer of token that is not own"
1047         );
1048         require(to != address(0), "ERC721: transfer to the zero address");
1049 
1050         _beforeTokenTransfer(from, to, tokenId);
1051 
1052         // Clear approvals from the previous owner
1053         _approve(address(0), tokenId);
1054 
1055         _balances[from] -= 1;
1056         _balances[to] += 1;
1057         _owners[tokenId] = to;
1058 
1059         emit Transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev Approve `to` to operate on `tokenId`
1064      *
1065      * Emits a {Approval} event.
1066      */
1067     function _approve(address to, uint256 tokenId) internal virtual {
1068         _tokenApprovals[tokenId] = to;
1069         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1074      * The call is not executed if the target address is not a contract.
1075      *
1076      * @param from address representing the previous owner of the given token ID
1077      * @param to target address that will receive the tokens
1078      * @param tokenId uint256 ID of the token to be transferred
1079      * @param _data bytes optional data to send along with the call
1080      * @return bool whether the call correctly returned the expected magic value
1081      */
1082     function _checkOnERC721Received(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) private returns (bool) {
1088         if (to.isContract()) {
1089             try
1090                 IERC721Receiver(to).onERC721Received(
1091                     _msgSender(),
1092                     from,
1093                     tokenId,
1094                     _data
1095                 )
1096             returns (bytes4 retval) {
1097                 return retval == IERC721Receiver.onERC721Received.selector;
1098             } catch (bytes memory reason) {
1099                 if (reason.length == 0) {
1100                     revert(
1101                         "ERC721: transfer to non ERC721Receiver implementer"
1102                     );
1103                 } else {
1104                     assembly {
1105                         revert(add(32, reason), mload(reason))
1106                     }
1107                 }
1108             }
1109         } else {
1110             return true;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before any token transfer. This includes minting
1116      * and burning.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1124      * - `from` and `to` are never both zero.
1125      *
1126      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1127      */
1128     function _beforeTokenTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) internal virtual {}
1133 }
1134 
1135 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 /**
1140  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1141  * enumerability of all the token ids in the contract as well as all token ids owned by each
1142  * account.
1143  */
1144 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1145     // Mapping from owner to list of owned token IDs
1146     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1147 
1148     // Mapping from token ID to index of the owner tokens list
1149     mapping(uint256 => uint256) private _ownedTokensIndex;
1150 
1151     // Array with all token ids, used for enumeration
1152     uint256[] private _allTokens;
1153 
1154     // Mapping from token id to position in the allTokens array
1155     mapping(uint256 => uint256) private _allTokensIndex;
1156 
1157     /**
1158      * @dev See {IERC165-supportsInterface}.
1159      */
1160     function supportsInterface(bytes4 interfaceId)
1161         public
1162         view
1163         virtual
1164         override(IERC165, ERC721)
1165         returns (bool)
1166     {
1167         return
1168             interfaceId == type(IERC721Enumerable).interfaceId ||
1169             super.supportsInterface(interfaceId);
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1174      */
1175     function tokenOfOwnerByIndex(address owner, uint256 index)
1176         public
1177         view
1178         virtual
1179         override
1180         returns (uint256)
1181     {
1182         require(
1183             index < ERC721.balanceOf(owner),
1184             "ERC721Enumerable: owner index out of bounds"
1185         );
1186         return _ownedTokens[owner][index];
1187     }
1188 
1189     /**
1190      * @dev See {IERC721Enumerable-totalSupply}.
1191      */
1192     function totalSupply() public view virtual override returns (uint256) {
1193         return _allTokens.length;
1194     }
1195 
1196     /**
1197      * @dev See {IERC721Enumerable-tokenByIndex}.
1198      */
1199     function tokenByIndex(uint256 index)
1200         public
1201         view
1202         virtual
1203         override
1204         returns (uint256)
1205     {
1206         require(
1207             index < ERC721Enumerable.totalSupply(),
1208             "ERC721Enumerable: global index out of bounds"
1209         );
1210         return _allTokens[index];
1211     }
1212 
1213     /**
1214      * @dev Hook that is called before any token transfer. This includes minting
1215      * and burning.
1216      *
1217      * Calling conditions:
1218      *
1219      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1220      * transferred to `to`.
1221      * - When `from` is zero, `tokenId` will be minted for `to`.
1222      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1223      * - `from` cannot be the zero address.
1224      * - `to` cannot be the zero address.
1225      *
1226      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1227      */
1228     function _beforeTokenTransfer(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) internal virtual override {
1233         super._beforeTokenTransfer(from, to, tokenId);
1234 
1235         if (from == address(0)) {
1236             _addTokenToAllTokensEnumeration(tokenId);
1237         } else if (from != to) {
1238             _removeTokenFromOwnerEnumeration(from, tokenId);
1239         }
1240         if (to == address(0)) {
1241             _removeTokenFromAllTokensEnumeration(tokenId);
1242         } else if (to != from) {
1243             _addTokenToOwnerEnumeration(to, tokenId);
1244         }
1245     }
1246 
1247     /**
1248      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1249      * @param to address representing the new owner of the given token ID
1250      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1251      */
1252     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1253         uint256 length = ERC721.balanceOf(to);
1254         _ownedTokens[to][length] = tokenId;
1255         _ownedTokensIndex[tokenId] = length;
1256     }
1257 
1258     /**
1259      * @dev Private function to add a token to this extension's token tracking data structures.
1260      * @param tokenId uint256 ID of the token to be added to the tokens list
1261      */
1262     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1263         _allTokensIndex[tokenId] = _allTokens.length;
1264         _allTokens.push(tokenId);
1265     }
1266 
1267     /**
1268      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1269      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1270      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1271      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1272      * @param from address representing the previous owner of the given token ID
1273      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1274      */
1275     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1276         private
1277     {
1278         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1279         // then delete the last slot (swap and pop).
1280 
1281         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1282         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1283 
1284         // When the token to delete is the last token, the swap operation is unnecessary
1285         if (tokenIndex != lastTokenIndex) {
1286             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1287 
1288             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1289             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1290         }
1291 
1292         // This also deletes the contents at the last position of the array
1293         delete _ownedTokensIndex[tokenId];
1294         delete _ownedTokens[from][lastTokenIndex];
1295     }
1296 
1297     /**
1298      * @dev Private function to remove a token from this extension's token tracking data structures.
1299      * This has O(1) time complexity, but alters the order of the _allTokens array.
1300      * @param tokenId uint256 ID of the token to be removed from the tokens list
1301      */
1302     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1303         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1304         // then delete the last slot (swap and pop).
1305 
1306         uint256 lastTokenIndex = _allTokens.length - 1;
1307         uint256 tokenIndex = _allTokensIndex[tokenId];
1308 
1309         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1310         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1311         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1312         uint256 lastTokenId = _allTokens[lastTokenIndex];
1313 
1314         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1315         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1316 
1317         // This also deletes the contents at the last position of the array
1318         delete _allTokensIndex[tokenId];
1319         _allTokens.pop();
1320     }
1321 }
1322 
1323 // File: @openzeppelin/contracts/access/Ownable.sol
1324 pragma solidity ^0.8.0;
1325 
1326 /**
1327  * @dev Contract module which provides a basic access control mechanism, where
1328  * there is an account (an owner) that can be granted exclusive access to
1329  * specific functions.
1330  *
1331  * By default, the owner account will be the one that deploys the contract. This
1332  * can later be changed with {transferOwnership}.
1333  *
1334  * This module is used through inheritance. It will make available the modifier
1335  * `onlyOwner`, which can be applied to your functions to restrict their use to
1336  * the owner.
1337  */
1338 abstract contract Ownable is Context {
1339     address private _owner;
1340 
1341     event OwnershipTransferred(
1342         address indexed previousOwner,
1343         address indexed newOwner
1344     );
1345 
1346     /**
1347      * @dev Initializes the contract setting the deployer as the initial owner.
1348      */
1349     constructor() {
1350         _setOwner(_msgSender());
1351     }
1352 
1353     /**
1354      * @dev Returns the address of the current owner.
1355      */
1356     function owner() public view virtual returns (address) {
1357         return _owner;
1358     }
1359 
1360     /**
1361      * @dev Throws if called by any account other than the owner.
1362      */
1363     modifier onlyOwner() {
1364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1365         _;
1366     }
1367 
1368     /**
1369      * @dev Leaves the contract without owner. It will not be possible to call
1370      * `onlyOwner` functions anymore. Can only be called by the current owner.
1371      *
1372      * NOTE: Renouncing ownership will leave the contract without an owner,
1373      * thereby removing any functionality that is only available to the owner.
1374      */
1375     function renounceOwnership() public virtual onlyOwner {
1376         _setOwner(address(0));
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
1388         _setOwner(newOwner);
1389     }
1390 
1391     function _setOwner(address newOwner) private {
1392         address oldOwner = _owner;
1393         _owner = newOwner;
1394         emit OwnershipTransferred(oldOwner, newOwner);
1395     }
1396 }
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 contract MutantPunksNFT is ERC721Enumerable, Ownable {
1401     using Strings for uint256;
1402 
1403     string public baseURI;
1404     string public baseExtension = ".json";
1405     address private signerAddress;
1406     uint256 public cost = .0 ether;
1407     uint256 public maxSupply = 10000;
1408     uint256 public maxAmountPerMint = 2;
1409     uint256 public maxMintPerAddress = 2;
1410     bool public publicEnabled = false;
1411     bool public presaleEnabled = false;
1412     mapping(address => bool) public whitelisted;
1413     mapping(address => uint256) public addressMintCount;
1414 
1415     constructor(
1416         string memory _name,
1417         string memory _symbol,
1418         string memory _initBaseURI,
1419         address _initSignerAddress
1420     ) ERC721(_name, _symbol) {
1421         setBaseURI(_initBaseURI);
1422         signerAddress = _initSignerAddress;
1423         publicMint(msg.sender, 42);
1424     }
1425 
1426     // internal
1427     function _baseURI() internal view virtual override returns (string memory) {
1428         return baseURI;
1429     }
1430 
1431     modifier mintConditionsMet(address _to, uint256 _mintAmount) {
1432         uint256 supply = totalSupply();
1433         require(_mintAmount > 0, "mint amount must be greater than 0");
1434         require(supply + _mintAmount <= maxSupply, "mint amount cannot exceed max supply");
1435 
1436         if (msg.sender != owner()) {
1437             require(_mintAmount <= maxAmountPerMint, "mint amount cannot exceed max amount per mint");
1438             require((addressMintCount[_to] + _mintAmount) <= maxMintPerAddress, "cannot exceed max mint per wallet address");
1439             if (whitelisted[msg.sender] != true) {
1440                 require(msg.value >= cost * _mintAmount, "ether value must be greater or equal cost to mint");
1441             }
1442         }
1443         _;
1444     }
1445 
1446     // public sale
1447     function publicMint(address _to, uint256 _mintAmount) public payable mintConditionsMet(_to, _mintAmount)
1448     {
1449         uint256 supply = totalSupply();
1450         require(publicEnabled || msg.sender == owner(), "public sale is not enabled");
1451         for (uint256 i = 1; i <= _mintAmount; i++) {
1452             _safeMint(_to, supply + i);
1453             addressMintCount[_to] = (addressMintCount[_to] + _mintAmount);
1454         }
1455     }
1456 
1457     // pre-sale
1458     function presaleMint(address _to, uint256 _mintAmount, bytes memory sig) public payable mintConditionsMet(_to, _mintAmount) {
1459         uint256 supply = totalSupply();
1460         require(presaleEnabled, "pre-sale is not enabled");
1461         require(isValidSignedData(sig), "wallet was not signed by the official whitelisting signer");
1462         for (uint256 i = 1; i <= _mintAmount; i++) {
1463             _safeMint(_to, supply + i);
1464             addressMintCount[_to] = (addressMintCount[_to] + _mintAmount);
1465         }
1466     }
1467 
1468     // public methods
1469     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1470         uint256 ownerTokenCount = balanceOf(_owner);
1471         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1472         for (uint256 i; i < ownerTokenCount; i++) {
1473             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1474         }
1475         return tokenIds;
1476     }
1477 
1478     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1479         require(
1480             _exists(tokenId),
1481             "ERC721Metadata: URI query for nonexistent token"
1482         );
1483 
1484         string memory currentBaseURI = _baseURI();
1485         return
1486             bytes(currentBaseURI).length > 0
1487                 ? string(
1488                     abi.encodePacked(
1489                         currentBaseURI,
1490                         tokenId.toString(),
1491                         baseExtension
1492                     )
1493                 )
1494                 : "";
1495     }
1496 
1497     //only owner
1498     function setCost(uint256 _newCost) public onlyOwner {
1499         cost = _newCost;
1500     }
1501 
1502     function setMaxAmountPerMint(uint256 _newMaxAmountPerMint) public onlyOwner {
1503         maxAmountPerMint = _newMaxAmountPerMint;
1504     }
1505 
1506     function setMaxMintPerAddress(uint256 _newMaxMintPerAddress) public onlyOwner {
1507         maxMintPerAddress = _newMaxMintPerAddress;
1508     }
1509 
1510     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1511         baseURI = _newBaseURI;
1512     }
1513 
1514     function getSignerAddress() public view onlyOwner returns (address) {
1515         return signerAddress;
1516     }
1517 
1518     function setSignerAddress(address _newSignerAddress) public onlyOwner {
1519         signerAddress = _newSignerAddress;
1520     }
1521 
1522     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1523         baseExtension = _newBaseExtension;
1524     }
1525 
1526     function setPublicEnabled(bool _state) public onlyOwner {
1527         publicEnabled = _state;
1528     }
1529 
1530     function setPresaleEnabled(bool _state) public onlyOwner {
1531         presaleEnabled = _state;
1532     }
1533 
1534     function whitelistUser(address _user) public onlyOwner {
1535         whitelisted[_user] = true;
1536     }
1537 
1538     function removeWhitelistUser(address _user) public onlyOwner {
1539         whitelisted[_user] = false;
1540     }
1541 
1542     function setAddressMintCount(address _user, uint256 count) public onlyOwner {
1543         addressMintCount[_user] = count;
1544     }
1545 
1546     function withdraw() public payable onlyOwner {
1547         require(payable(msg.sender).send(address(this).balance));
1548     }
1549 
1550     /************
1551      * Security *
1552      ************/
1553 
1554     function isValidSignedData(bytes memory sig) public view returns (bool) {
1555         bytes32 message = keccak256(abi.encodePacked(_msgSender()));
1556         return (recoverSigner(message, sig) == signerAddress);
1557     }
1558 
1559     function recoverSigner(bytes32 message, bytes memory sig) public pure returns (address) {
1560         uint8 v;
1561         bytes32 r;
1562         bytes32 s;
1563         (v, r, s) = splitSignature(sig);
1564         return ecrecover(message, v, r, s);
1565     }
1566 
1567     function splitSignature(bytes memory sig) public pure returns (uint8, bytes32, bytes32) {
1568         require(sig.length == 65);
1569         bytes32 r;
1570         bytes32 s;
1571         uint8 v;
1572         assembly {
1573             // first 32 bytes, after the length prefix
1574             r := mload(add(sig, 32))
1575             // second 32 bytes
1576             s := mload(add(sig, 64))
1577             // final byte (first byte of the next 32 bytes)
1578             v := byte(0, mload(add(sig, 96)))
1579         }
1580 
1581         return (v, r, s);
1582     }
1583 }