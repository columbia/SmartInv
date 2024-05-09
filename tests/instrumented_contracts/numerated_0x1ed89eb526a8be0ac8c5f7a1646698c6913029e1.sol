1 //  ______  ___  ________   __   ___  ______ _____  ___  ____   _ _____ ___   _   _ _____   _____  _     _   _______ 
2 //  | ___ \/ _ \ | ___ \ \ / /  / _ \ | ___ \  ___| |  \/  | | | |_   _/ _ \ | \ | |_   _| /  __ \| |   | | | | ___ \
3 //  | |_/ / /_\ \| |_/ /\ V /  / /_\ \| |_/ / |__   | .  . | | | | | |/ /_\ \|  \| | | |   | /  \/| |   | | | | |_/ /
4 //  | ___ \  _  || ___ \ \ /   |  _  ||  __/|  __|  | |\/| | | | | | ||  _  || . ` | | |   | |    | |   | | | | ___ \
5 //  | |_/ / | | || |_/ / | |   | | | || |   | |___  | |  | | |_| | | || | | || |\  | | |   | \__/\| |___| |_| | |_/ /
6 //  \____/\_| |_/\____/  \_/   \_| |_/\_|   \____/  \_|  |_/\___/  \_/\_| |_/\_| \_/ \_/    \____/\_____/\___/\____/ 
7 //                                                                                                                   
8 //                                                                                                                   
9 //  
10 //  https://discord.com/invite/rngMmBdeKq
11 //  https://babyapemutantclub.com/
12 
13 
14 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.8.0;
19 
20 
21 
22 
23 /**
24  * @dev Interface of the ERC165 standard, as defined in the
25  * https://eips.ethereum.org/EIPS/eip-165[EIP].
26  *
27  * Implementers can declare support of contract interfaces, which can then be
28  * queried by others ({ERC165Checker}).
29  *
30  * For an implementation, see {ERC165}.
31  */
32 interface IERC165 {
33     /**
34      * @dev Returns true if this contract implements the interface defined by
35      * `interfaceId`. See the corresponding
36      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
37      * to learn more about how these ids are created.
38      *
39      * This function call must use less than 30 000 gas.
40      */
41     function supportsInterface(bytes4 interfaceId) external view returns (bool);
42 }
43 
44 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
45 
46 /**
47  * @dev Required interface of an ERC721 compliant contract.
48  */
49 interface IERC721 is IERC165 {
50     /**
51      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
52      */
53     event Transfer(
54         address indexed from,
55         address indexed to,
56         uint256 indexed tokenId
57     );
58 
59     /**
60      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
61      */
62     event Approval(
63         address indexed owner,
64         address indexed approved,
65         uint256 indexed tokenId
66     );
67 
68     /**
69      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
70      */
71     event ApprovalForAll(
72         address indexed owner,
73         address indexed operator,
74         bool approved
75     );
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId)
154         external
155         view
156         returns (address operator);
157 
158     /**
159      * @dev Approve or remove `operator` as an operator for the caller.
160      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
161      *
162      * Requirements:
163      *
164      * - The `operator` cannot be the caller.
165      *
166      * Emits an {ApprovalForAll} event.
167      */
168     function setApprovalForAll(address operator, bool _approved) external;
169 
170     /**
171      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
172      *
173      * See {setApprovalForAll}
174      */
175     function isApprovedForAll(address owner, address operator)
176         external
177         view
178         returns (bool);
179 
180     /**
181      * @dev Safely transfers `tokenId` token from `from` to `to`.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must exist and be owned by `from`.
188      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
190      *
191      * Emits a {Transfer} event.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId,
197         bytes calldata data
198     ) external;
199 }
200 
201 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
202 
203 /**
204  * @title ERC721 token receiver interface
205  * @dev Interface for any contract that wants to support safeTransfers
206  * from ERC721 asset contracts.
207  */
208 interface IERC721Receiver {
209     /**
210      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
211      * by `operator` from `from`, this function is called.
212      *
213      * It must return its Solidity selector to confirm the token transfer.
214      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
215      *
216      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
217      */
218     function onERC721Received(
219         address operator,
220         address from,
221         uint256 tokenId,
222         bytes calldata data
223     ) external returns (bytes4);
224 }
225 
226 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
227 
228 /**
229  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
230  * @dev See https://eips.ethereum.org/EIPS/eip-721
231  */
232 interface IERC721Metadata is IERC721 {
233     /**
234      * @dev Returns the token collection name.
235      */
236     function name() external view returns (string memory);
237 
238     /**
239      * @dev Returns the token collection symbol.
240      */
241     function symbol() external view returns (string memory);
242 
243     /**
244      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
245      */
246     function tokenURI(uint256 tokenId) external view returns (string memory);
247 }
248 
249 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // This method relies on extcodesize, which returns 0 for contracts in
274         // construction, since the code is only stored at the end of the
275         // constructor execution.
276 
277         uint256 size;
278         assembly {
279             size := extcodesize(account)
280         }
281         return size > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(
302             address(this).balance >= amount,
303             "Address: insufficient balance"
304         );
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(
308             success,
309             "Address: unable to send value, recipient may have reverted"
310         );
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain `call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data)
332         internal
333         returns (bytes memory)
334     {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value
367     ) internal returns (bytes memory) {
368         return
369             functionCallWithValue(
370                 target,
371                 data,
372                 value,
373                 "Address: low-level call with value failed"
374             );
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(
390             address(this).balance >= value,
391             "Address: insufficient balance for call"
392         );
393         require(isContract(target), "Address: call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.call{value: value}(
396             data
397         );
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data)
408         internal
409         view
410         returns (bytes memory)
411     {
412         return
413             functionStaticCall(
414                 target,
415                 data,
416                 "Address: low-level static call failed"
417             );
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data)
444         internal
445         returns (bytes memory)
446     {
447         return
448             functionDelegateCall(
449                 target,
450                 data,
451                 "Address: low-level delegate call failed"
452             );
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a delegate call.
458      *
459      * _Available since v3.4._
460      */
461     function functionDelegateCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         require(isContract(target), "Address: delegate call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.delegatecall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
474      * revert reason using the provided one.
475      *
476      * _Available since v4.3._
477      */
478     function verifyCallResult(
479         bool success,
480         bytes memory returndata,
481         string memory errorMessage
482     ) internal pure returns (bytes memory) {
483         if (success) {
484             return returndata;
485         } else {
486             // Look for revert reason and bubble it up if present
487             if (returndata.length > 0) {
488                 // The easiest way to bubble the revert reason is using memory via assembly
489 
490                 assembly {
491                     let returndata_size := mload(returndata)
492                     revert(add(32, returndata), returndata_size)
493                 }
494             } else {
495                 revert(errorMessage);
496             }
497         }
498     }
499 }
500 
501 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
502 
503 /**
504  * @dev Provides information about the current execution context, including the
505  * sender of the transaction and its data. While these are generally available
506  * via msg.sender and msg.data, they should not be accessed in such a direct
507  * manner, since when dealing with meta-transactions the account sending and
508  * paying for execution may not be the actual sender (as far as an application
509  * is concerned).
510  *
511  * This contract is only required for intermediate, library-like contracts.
512  */
513 abstract contract Context {
514     function _msgSender() internal view virtual returns (address) {
515         return msg.sender;
516     }
517 
518     function _msgData() internal view virtual returns (bytes calldata) {
519         return msg.data;
520     }
521 }
522 
523 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
524 
525 /**
526  * @dev String operations.
527  */
528 library Strings {
529     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
530 
531     /**
532      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
533      */
534     function toString(uint256 value) internal pure returns (string memory) {
535         // Inspired by OraclizeAPI's implementation - MIT licence
536         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
537 
538         if (value == 0) {
539             return "0";
540         }
541         uint256 temp = value;
542         uint256 digits;
543         while (temp != 0) {
544             digits++;
545             temp /= 10;
546         }
547         bytes memory buffer = new bytes(digits);
548         while (value != 0) {
549             digits -= 1;
550             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
551             value /= 10;
552         }
553         return string(buffer);
554     }
555 
556     /**
557      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
558      */
559     function toHexString(uint256 value) internal pure returns (string memory) {
560         if (value == 0) {
561             return "0x00";
562         }
563         uint256 temp = value;
564         uint256 length = 0;
565         while (temp != 0) {
566             length++;
567             temp >>= 8;
568         }
569         return toHexString(value, length);
570     }
571 
572     /**
573      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
574      */
575     function toHexString(uint256 value, uint256 length)
576         internal
577         pure
578         returns (string memory)
579     {
580         bytes memory buffer = new bytes(2 * length + 2);
581         buffer[0] = "0";
582         buffer[1] = "x";
583         for (uint256 i = 2 * length + 1; i > 1; --i) {
584             buffer[i] = _HEX_SYMBOLS[value & 0xf];
585             value >>= 4;
586         }
587         require(value == 0, "Strings: hex length insufficient");
588         return string(buffer);
589     }
590 }
591 
592 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId)
613         public
614         view
615         virtual
616         override
617         returns (bool)
618     {
619         return interfaceId == type(IERC165).interfaceId;
620     }
621 }
622 
623 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
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
1111 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1112 
1113 /**
1114  * @dev Contract module which provides a basic access control mechanism, where
1115  * there is an account (an owner) that can be granted exclusive access to
1116  * specific functions.
1117  *
1118  * By default, the owner account will be the one that deploys the contract. This
1119  * can later be changed with {transferOwnership}.
1120  *
1121  * This module is used through inheritance. It will make available the modifier
1122  * `onlyOwner`, which can be applied to your functions to restrict their use to
1123  * the owner.
1124  */
1125 abstract contract Ownable is Context {
1126     address private _owner;
1127 
1128     event OwnershipTransferred(
1129         address indexed previousOwner,
1130         address indexed newOwner
1131     );
1132 
1133     /**
1134      * @dev Initializes the contract setting the deployer as the initial owner.
1135      */
1136     constructor() {
1137         _setOwner(_msgSender());
1138     }
1139 
1140     /**
1141      * @dev Returns the address of the current owner.
1142      */
1143     function owner() public view virtual returns (address) {
1144         return _owner;
1145     }
1146 
1147     /**
1148      * @dev Throws if called by any account other than the owner.
1149      */
1150     modifier onlyOwner() {
1151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1152         _;
1153     }
1154 
1155     /**
1156      * @dev Leaves the contract without owner. It will not be possible to call
1157      * `onlyOwner` functions anymore. Can only be called by the current owner.
1158      *
1159      * NOTE: Renouncing ownership will leave the contract without an owner,
1160      * thereby removing any functionality that is only available to the owner.
1161      */
1162     function renounceOwnership() public virtual onlyOwner {
1163         _setOwner(address(0));
1164     }
1165 
1166     /**
1167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1168      * Can only be called by the current owner.
1169      */
1170     function transferOwnership(address newOwner) public virtual onlyOwner {
1171         require(
1172             newOwner != address(0),
1173             "Ownable: new owner is the zero address"
1174         );
1175         _setOwner(newOwner);
1176     }
1177 
1178     function _setOwner(address newOwner) private {
1179         address oldOwner = _owner;
1180         _owner = newOwner;
1181         emit OwnershipTransferred(oldOwner, newOwner);
1182     }
1183 }
1184 
1185 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.2
1186 
1187 /**
1188  * @dev Contract module that helps prevent reentrant calls to a function.
1189  *
1190  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1191  * available, which can be applied to functions to make sure there are no nested
1192  * (reentrant) calls to them.
1193  *
1194  * Note that because there is a single `nonReentrant` guard, functions marked as
1195  * `nonReentrant` may not call one another. This can be worked around by making
1196  * those functions `private`, and then adding `external` `nonReentrant` entry
1197  * points to them.
1198  *
1199  * TIP: If you would like to learn more about reentrancy and alternative ways
1200  * to protect against it, check out our blog post
1201  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1202  */
1203 abstract contract ReentrancyGuard {
1204     // Booleans are more expensive than uint256 or any type that takes up a full
1205     // word because each write operation emits an extra SLOAD to first read the
1206     // slot's contents, replace the bits taken up by the boolean, and then write
1207     // back. This is the compiler's defense against contract upgrades and
1208     // pointer aliasing, and it cannot be disabled.
1209 
1210     // The values being non-zero value makes deployment a bit more expensive,
1211     // but in exchange the refund on every call to nonReentrant will be lower in
1212     // amount. Since refunds are capped to a percentage of the total
1213     // transaction's gas, it is best to keep them low in cases like this one, to
1214     // increase the likelihood of the full refund coming into effect.
1215     uint256 private constant _NOT_ENTERED = 1;
1216     uint256 private constant _ENTERED = 2;
1217 uint256 public freecount;
1218 
1219     uint256 private _status;
1220 
1221     constructor() {
1222         _status = _NOT_ENTERED;
1223     }
1224 
1225     /**
1226      * @dev Prevents a contract from calling itself, directly or indirectly.
1227      * Calling a `nonReentrant` function from another `nonReentrant`
1228      * function is not supported. It is possible to prevent this from happening
1229      * by making the `nonReentrant` function external, and make it call a
1230      * `private` function that does the actual work.
1231      */
1232     modifier nonReentrant() {
1233         // On the first call to nonReentrant, _notEntered will be true
1234         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1235 
1236         // Any calls to nonReentrant after this point will fail
1237         _status = _ENTERED;
1238 
1239         _;
1240 
1241         // By storing the original value once again, a refund is triggered (see
1242         // https://eips.ethereum.org/EIPS/eip-2200)
1243         _status = _NOT_ENTERED;
1244     }
1245 }
1246 
1247 // File contracts/BAMC.sol
1248 
1249 
1250 
1251 contract BabyApeMutantClub is ERC721, Ownable, ReentrancyGuard {
1252     uint256 public PRICE = 0.01 * 1e18;
1253     uint256 public MAX_SUPPLY = 6666;
1254     uint256 public MAX_FREE = 1000;
1255     uint256 public nftPerAddressLimit = 10;
1256 
1257     uint256 public minted;
1258 
1259     string public baseURI;
1260     mapping(address => uint256) public addressMintedBalance;
1261 
1262     constructor(
1263         string memory name_,
1264         string memory symbol_,
1265         string memory baseURI_
1266     ) ERC721(name_, symbol_) {
1267         baseURI = baseURI_;
1268     }
1269 
1270 
1271 
1272     function mint(uint8 amount) public payable nonReentrant {
1273         require(amount > 0, "Amount must be more than 0");
1274         require(amount <= 10, "Amount must be 10 or less");
1275         require(msg.value == PRICE * amount, "Ether value sent is not correct");
1276         require(
1277             minted + amount <= MAX_SUPPLY,
1278             "Sold out!"
1279         );
1280 
1281         for (uint256 i = 0; i < amount; i++) {
1282             _safeMint(msg.sender, ++minted);
1283         }
1284     }
1285 
1286         function mintfree(uint8 amount) public payable nonReentrant {
1287             
1288         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1289         require(ownerMintedCount + amount <= nftPerAddressLimit, "max NFT per address exceeded");
1290         require(amount > 0, "Amount must be more than 0");
1291         require(amount <= 5, "Amount must be 5 or less");
1292         require(
1293             minted + amount <= MAX_FREE,
1294             "Free mints gone");
1295             freecount = msg.value;
1296     
1297         for (uint256 i = 0; i < amount; i++) {
1298       addressMintedBalance[msg.sender]++;
1299       _safeMint(msg.sender, ++minted);
1300     }
1301   }
1302 
1303 
1304 	function setPRICE(uint256 _newPRICE) public onlyOwner {
1305 	    PRICE = _newPRICE;
1306 	}
1307 
1308 	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1309 	    MAX_SUPPLY = _newMaxSupply;
1310     }
1311 
1312     	function setmaxFree(uint256 _newMaxFree) public onlyOwner {
1313 	    MAX_FREE = _newMaxFree;
1314     }
1315 
1316   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1317     nftPerAddressLimit = _limit;
1318   }
1319     function withdraw(address payable recipient) public onlyOwner {
1320         require(address(this).balance > 0, "No contract balance");
1321         recipient.transfer(address(this).balance);
1322     }
1323 
1324     function setBaseURI(string memory baseURI_) public onlyOwner {
1325         baseURI = baseURI_;
1326     }
1327 
1328     function _baseURI() internal view virtual override returns (string memory) {
1329         return baseURI;
1330     }
1331 }