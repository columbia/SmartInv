1 // Sources flattened with hardhat v2.8.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
32 
33 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(
45         address indexed from,
46         address indexed to,
47         uint256 indexed tokenId
48     );
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(
54         address indexed owner,
55         address indexed approved,
56         uint256 indexed tokenId
57     );
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(
63         address indexed owner,
64         address indexed operator,
65         bool approved
66     );
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must be owned by `from`.
112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
124      * The approval is cleared when the token is transferred.
125      *
126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
127      *
128      * Requirements:
129      *
130      * - The caller must own the token or be an approved operator.
131      * - `tokenId` must exist.
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Returns the account approved for `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function getApproved(uint256 tokenId)
145         external
146         view
147         returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator)
167         external
168         view
169         returns (bool);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 }
191 
192 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title ERC721 token receiver interface
200  * @dev Interface for any contract that wants to support safeTransfers
201  * from ERC721 asset contracts.
202  */
203 interface IERC721Receiver {
204     /**
205      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
206      * by `operator` from `from`, this function is called.
207      *
208      * It must return its Solidity selector to confirm the token transfer.
209      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
210      *
211      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
212      */
213     function onERC721Received(
214         address operator,
215         address from,
216         uint256 tokenId,
217         bytes calldata data
218     ) external returns (bytes4);
219 }
220 
221 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
229  * @dev See https://eips.ethereum.org/EIPS/eip-721
230  */
231 interface IERC721Metadata is IERC721 {
232     /**
233      * @dev Returns the token collection name.
234      */
235     function name() external view returns (string memory);
236 
237     /**
238      * @dev Returns the token collection symbol.
239      */
240     function symbol() external view returns (string memory);
241 
242     /**
243      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
244      */
245     function tokenURI(uint256 tokenId) external view returns (string memory);
246 }
247 
248 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
249 
250 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize, which returns 0 for contracts in
277         // construction, since the code is only stored at the end of the
278         // constructor execution.
279 
280         uint256 size;
281         assembly {
282             size := extcodesize(account)
283         }
284         return size > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(
305             address(this).balance >= amount,
306             "Address: insufficient balance"
307         );
308 
309         (bool success, ) = recipient.call{value: amount}("");
310         require(
311             success,
312             "Address: unable to send value, recipient may have reverted"
313         );
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain `call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data)
335         internal
336         returns (bytes memory)
337     {
338         return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, 0, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but also transferring `value` wei to `target`.
358      *
359      * Requirements:
360      *
361      * - the calling contract must have an ETH balance of at least `value`.
362      * - the called Solidity function must be `payable`.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value
370     ) internal returns (bytes memory) {
371         return
372             functionCallWithValue(
373                 target,
374                 data,
375                 value,
376                 "Address: low-level call with value failed"
377             );
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(
387         address target,
388         bytes memory data,
389         uint256 value,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(
393             address(this).balance >= value,
394             "Address: insufficient balance for call"
395         );
396         require(isContract(target), "Address: call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.call{value: value}(
399             data
400         );
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(address target, bytes memory data)
411         internal
412         view
413         returns (bytes memory)
414     {
415         return
416             functionStaticCall(
417                 target,
418                 data,
419                 "Address: low-level static call failed"
420             );
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal view returns (bytes memory) {
434         require(isContract(target), "Address: static call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.staticcall(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(address target, bytes memory data)
447         internal
448         returns (bytes memory)
449     {
450         return
451             functionDelegateCall(
452                 target,
453                 data,
454                 "Address: low-level delegate call failed"
455             );
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         require(isContract(target), "Address: delegate call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.delegatecall(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
477      * revert reason using the provided one.
478      *
479      * _Available since v4.3._
480      */
481     function verifyCallResult(
482         bool success,
483         bytes memory returndata,
484         string memory errorMessage
485     ) internal pure returns (bytes memory) {
486         if (success) {
487             return returndata;
488         } else {
489             // Look for revert reason and bubble it up if present
490             if (returndata.length > 0) {
491                 // The easiest way to bubble the revert reason is using memory via assembly
492 
493                 assembly {
494                     let returndata_size := mload(returndata)
495                     revert(add(32, returndata), returndata_size)
496                 }
497             } else {
498                 revert(errorMessage);
499             }
500         }
501     }
502 }
503 
504 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Provides information about the current execution context, including the
512  * sender of the transaction and its data. While these are generally available
513  * via msg.sender and msg.data, they should not be accessed in such a direct
514  * manner, since when dealing with meta-transactions the account sending and
515  * paying for execution may not be the actual sender (as far as an application
516  * is concerned).
517  *
518  * This contract is only required for intermediate, library-like contracts.
519  */
520 abstract contract Context {
521     function _msgSender() internal view virtual returns (address) {
522         return msg.sender;
523     }
524 
525     function _msgData() internal view virtual returns (bytes calldata) {
526         return msg.data;
527     }
528 }
529 
530 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
531 
532 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev String operations.
538  */
539 library Strings {
540     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
541 
542     /**
543      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
544      */
545     function toString(uint256 value) internal pure returns (string memory) {
546         // Inspired by OraclizeAPI's implementation - MIT licence
547         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
548 
549         if (value == 0) {
550             return "0";
551         }
552         uint256 temp = value;
553         uint256 digits;
554         while (temp != 0) {
555             digits++;
556             temp /= 10;
557         }
558         bytes memory buffer = new bytes(digits);
559         while (value != 0) {
560             digits -= 1;
561             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
562             value /= 10;
563         }
564         return string(buffer);
565     }
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
569      */
570     function toHexString(uint256 value) internal pure returns (string memory) {
571         if (value == 0) {
572             return "0x00";
573         }
574         uint256 temp = value;
575         uint256 length = 0;
576         while (temp != 0) {
577             length++;
578             temp >>= 8;
579         }
580         return toHexString(value, length);
581     }
582 
583     /**
584      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
585      */
586     function toHexString(uint256 value, uint256 length)
587         internal
588         pure
589         returns (string memory)
590     {
591         bytes memory buffer = new bytes(2 * length + 2);
592         buffer[0] = "0";
593         buffer[1] = "x";
594         for (uint256 i = 2 * length + 1; i > 1; --i) {
595             buffer[i] = _HEX_SYMBOLS[value & 0xf];
596             value >>= 4;
597         }
598         require(value == 0, "Strings: hex length insufficient");
599         return string(buffer);
600     }
601 }
602 
603 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev Implementation of the {IERC165} interface.
611  *
612  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
613  * for the additional interface id that will be supported. For example:
614  *
615  * ```solidity
616  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
618  * }
619  * ```
620  *
621  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
622  */
623 abstract contract ERC165 is IERC165 {
624     /**
625      * @dev See {IERC165-supportsInterface}.
626      */
627     function supportsInterface(bytes4 interfaceId)
628         public
629         view
630         virtual
631         override
632         returns (bool)
633     {
634         return interfaceId == type(IERC165).interfaceId;
635     }
636 }
637 
638 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.1
639 
640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
646  * the Metadata extension, but not including the Enumerable extension, which is available separately as
647  * {ERC721Enumerable}.
648  */
649 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
650     using Address for address;
651     using Strings for uint256;
652 
653     // Token name
654     string private _name;
655 
656     // Token symbol
657     string private _symbol;
658 
659     // Mapping from token ID to owner address
660     mapping(uint256 => address) private _owners;
661 
662     // Mapping owner address to token count
663     mapping(address => uint256) private _balances;
664 
665     // Mapping from token ID to approved address
666     mapping(uint256 => address) private _tokenApprovals;
667 
668     // Mapping from owner to operator approvals
669     mapping(address => mapping(address => bool)) private _operatorApprovals;
670 
671     /**
672      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
673      */
674     constructor(string memory name_, string memory symbol_) {
675         _name = name_;
676         _symbol = symbol_;
677     }
678 
679     /**
680      * @dev See {IERC165-supportsInterface}.
681      */
682     function supportsInterface(bytes4 interfaceId)
683         public
684         view
685         virtual
686         override(ERC165, IERC165)
687         returns (bool)
688     {
689         return
690             interfaceId == type(IERC721).interfaceId ||
691             interfaceId == type(IERC721Metadata).interfaceId ||
692             super.supportsInterface(interfaceId);
693     }
694 
695     /**
696      * @dev See {IERC721-balanceOf}.
697      */
698     function balanceOf(address owner)
699         public
700         view
701         virtual
702         override
703         returns (uint256)
704     {
705         require(
706             owner != address(0),
707             "ERC721: balance query for the zero address"
708         );
709         return _balances[owner];
710     }
711 
712     /**
713      * @dev See {IERC721-ownerOf}.
714      */
715     function ownerOf(uint256 tokenId)
716         public
717         view
718         virtual
719         override
720         returns (address)
721     {
722         address owner = _owners[tokenId];
723         require(
724             owner != address(0),
725             "ERC721: owner query for nonexistent token"
726         );
727         return owner;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-name}.
732      */
733     function name() public view virtual override returns (string memory) {
734         return _name;
735     }
736 
737     /**
738      * @dev See {IERC721Metadata-symbol}.
739      */
740     function symbol() public view virtual override returns (string memory) {
741         return _symbol;
742     }
743 
744     /**
745      * @dev See {IERC721Metadata-tokenURI}.
746      */
747     function tokenURI(uint256 tokenId)
748         public
749         view
750         virtual
751         override
752         returns (string memory)
753     {
754         require(
755             _exists(tokenId),
756             "ERC721Metadata: URI query for nonexistent token"
757         );
758 
759         string memory baseURI = _baseURI();
760         return
761             bytes(baseURI).length > 0
762                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
763                 : "";
764     }
765 
766     /**
767      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
768      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
769      * by default, can be overriden in child contracts.
770      */
771     function _baseURI() internal view virtual returns (string memory) {
772         return "";
773     }
774 
775     /**
776      * @dev See {IERC721-approve}.
777      */
778     function approve(address to, uint256 tokenId) public virtual override {
779         address owner = ERC721.ownerOf(tokenId);
780         require(to != owner, "ERC721: approval to current owner");
781 
782         require(
783             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
784             "ERC721: approve caller is not owner nor approved for all"
785         );
786 
787         _approve(to, tokenId);
788     }
789 
790     /**
791      * @dev See {IERC721-getApproved}.
792      */
793     function getApproved(uint256 tokenId)
794         public
795         view
796         virtual
797         override
798         returns (address)
799     {
800         require(
801             _exists(tokenId),
802             "ERC721: approved query for nonexistent token"
803         );
804 
805         return _tokenApprovals[tokenId];
806     }
807 
808     /**
809      * @dev See {IERC721-setApprovalForAll}.
810      */
811     function setApprovalForAll(address operator, bool approved)
812         public
813         virtual
814         override
815     {
816         _setApprovalForAll(_msgSender(), operator, approved);
817     }
818 
819     /**
820      * @dev See {IERC721-isApprovedForAll}.
821      */
822     function isApprovedForAll(address owner, address operator)
823         public
824         view
825         virtual
826         override
827         returns (bool)
828     {
829         return _operatorApprovals[owner][operator];
830     }
831 
832     /**
833      * @dev See {IERC721-transferFrom}.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) public virtual override {
840         //solhint-disable-next-line max-line-length
841         require(
842             _isApprovedOrOwner(_msgSender(), tokenId),
843             "ERC721: transfer caller is not owner nor approved"
844         );
845 
846         _transfer(from, to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-safeTransferFrom}.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         safeTransferFrom(from, to, tokenId, "");
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) public virtual override {
869         require(
870             _isApprovedOrOwner(_msgSender(), tokenId),
871             "ERC721: transfer caller is not owner nor approved"
872         );
873         _safeTransfer(from, to, tokenId, _data);
874     }
875 
876     /**
877      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
878      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
879      *
880      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
881      *
882      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
883      * implement alternative mechanisms to perform token transfer, such as signature-based.
884      *
885      * Requirements:
886      *
887      * - `from` cannot be the zero address.
888      * - `to` cannot be the zero address.
889      * - `tokenId` token must exist and be owned by `from`.
890      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _safeTransfer(
895         address from,
896         address to,
897         uint256 tokenId,
898         bytes memory _data
899     ) internal virtual {
900         _transfer(from, to, tokenId);
901         require(
902             _checkOnERC721Received(from, to, tokenId, _data),
903             "ERC721: transfer to non ERC721Receiver implementer"
904         );
905     }
906 
907     /**
908      * @dev Returns whether `tokenId` exists.
909      *
910      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
911      *
912      * Tokens start existing when they are minted (`_mint`),
913      * and stop existing when they are burned (`_burn`).
914      */
915     function _exists(uint256 tokenId) internal view virtual returns (bool) {
916         return _owners[tokenId] != address(0);
917     }
918 
919     /**
920      * @dev Returns whether `spender` is allowed to manage `tokenId`.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      */
926     function _isApprovedOrOwner(address spender, uint256 tokenId)
927         internal
928         view
929         virtual
930         returns (bool)
931     {
932         require(
933             _exists(tokenId),
934             "ERC721: operator query for nonexistent token"
935         );
936         address owner = ERC721.ownerOf(tokenId);
937         return (spender == owner ||
938             getApproved(tokenId) == spender ||
939             isApprovedForAll(owner, spender));
940     }
941 
942     /**
943      * @dev Safely mints `tokenId` and transfers it to `to`.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must not exist.
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeMint(address to, uint256 tokenId) internal virtual {
953         _safeMint(to, tokenId, "");
954     }
955 
956     /**
957      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
958      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
959      */
960     function _safeMint(
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) internal virtual {
965         _mint(to, tokenId);
966         require(
967             _checkOnERC721Received(address(0), to, tokenId, _data),
968             "ERC721: transfer to non ERC721Receiver implementer"
969         );
970     }
971 
972     /**
973      * @dev Mints `tokenId` and transfers it to `to`.
974      *
975      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - `to` cannot be the zero address.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(address to, uint256 tokenId) internal virtual {
985         require(to != address(0), "ERC721: mint to the zero address");
986         require(!_exists(tokenId), "ERC721: token already minted");
987 
988         _beforeTokenTransfer(address(0), to, tokenId);
989 
990         _balances[to] += 1;
991         _owners[tokenId] = to;
992 
993         emit Transfer(address(0), to, tokenId);
994     }
995 
996     /**
997      * @dev Destroys `tokenId`.
998      * The approval is cleared when the token is burned.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _burn(uint256 tokenId) internal virtual {
1007         address owner = ERC721.ownerOf(tokenId);
1008 
1009         _beforeTokenTransfer(owner, address(0), tokenId);
1010 
1011         // Clear approvals
1012         _approve(address(0), tokenId);
1013 
1014         _balances[owner] -= 1;
1015         delete _owners[tokenId];
1016 
1017         emit Transfer(owner, address(0), tokenId);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual {
1036         require(
1037             ERC721.ownerOf(tokenId) == from,
1038             "ERC721: transfer of token that is not own"
1039         );
1040         require(to != address(0), "ERC721: transfer to the zero address");
1041 
1042         _beforeTokenTransfer(from, to, tokenId);
1043 
1044         // Clear approvals from the previous owner
1045         _approve(address(0), tokenId);
1046 
1047         _balances[from] -= 1;
1048         _balances[to] += 1;
1049         _owners[tokenId] = to;
1050 
1051         emit Transfer(from, to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev Approve `to` to operate on `tokenId`
1056      *
1057      * Emits a {Approval} event.
1058      */
1059     function _approve(address to, uint256 tokenId) internal virtual {
1060         _tokenApprovals[tokenId] = to;
1061         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev Approve `operator` to operate on all of `owner` tokens
1066      *
1067      * Emits a {ApprovalForAll} event.
1068      */
1069     function _setApprovalForAll(
1070         address owner,
1071         address operator,
1072         bool approved
1073     ) internal virtual {
1074         require(owner != operator, "ERC721: approve to caller");
1075         _operatorApprovals[owner][operator] = approved;
1076         emit ApprovalForAll(owner, operator, approved);
1077     }
1078 
1079     /**
1080      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1081      * The call is not executed if the target address is not a contract.
1082      *
1083      * @param from address representing the previous owner of the given token ID
1084      * @param to target address that will receive the tokens
1085      * @param tokenId uint256 ID of the token to be transferred
1086      * @param _data bytes optional data to send along with the call
1087      * @return bool whether the call correctly returned the expected magic value
1088      */
1089     function _checkOnERC721Received(
1090         address from,
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) private returns (bool) {
1095         if (to.isContract()) {
1096             try
1097                 IERC721Receiver(to).onERC721Received(
1098                     _msgSender(),
1099                     from,
1100                     tokenId,
1101                     _data
1102                 )
1103             returns (bytes4 retval) {
1104                 return retval == IERC721Receiver.onERC721Received.selector;
1105             } catch (bytes memory reason) {
1106                 if (reason.length == 0) {
1107                     revert(
1108                         "ERC721: transfer to non ERC721Receiver implementer"
1109                     );
1110                 } else {
1111                     assembly {
1112                         revert(add(32, reason), mload(reason))
1113                     }
1114                 }
1115             }
1116         } else {
1117             return true;
1118         }
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before any token transfer. This includes minting
1123      * and burning.
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` will be minted for `to`.
1130      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1131      * - `from` and `to` are never both zero.
1132      *
1133      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1134      */
1135     function _beforeTokenTransfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) internal virtual {}
1140 }
1141 
1142 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
1143 
1144 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1145 
1146 pragma solidity ^0.8.0;
1147 
1148 /**
1149  * @dev Contract module which provides a basic access control mechanism, where
1150  * there is an account (an owner) that can be granted exclusive access to
1151  * specific functions.
1152  *
1153  * By default, the owner account will be the one that deploys the contract. This
1154  * can later be changed with {transferOwnership}.
1155  *
1156  * This module is used through inheritance. It will make available the modifier
1157  * `onlyOwner`, which can be applied to your functions to restrict their use to
1158  * the owner.
1159  */
1160 abstract contract Ownable is Context {
1161     address private _owner;
1162 
1163     event OwnershipTransferred(
1164         address indexed previousOwner,
1165         address indexed newOwner
1166     );
1167 
1168     /**
1169      * @dev Initializes the contract setting the deployer as the initial owner.
1170      */
1171     constructor() {
1172         _transferOwnership(_msgSender());
1173     }
1174 
1175     /**
1176      * @dev Returns the address of the current owner.
1177      */
1178     function owner() public view virtual returns (address) {
1179         return _owner;
1180     }
1181 
1182     /**
1183      * @dev Throws if called by any account other than the owner.
1184      */
1185     modifier onlyOwner() {
1186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1187         _;
1188     }
1189 
1190     /**
1191      * @dev Leaves the contract without owner. It will not be possible to call
1192      * `onlyOwner` functions anymore. Can only be called by the current owner.
1193      *
1194      * NOTE: Renouncing ownership will leave the contract without an owner,
1195      * thereby removing any functionality that is only available to the owner.
1196      */
1197     function renounceOwnership() public virtual onlyOwner {
1198         _transferOwnership(address(0));
1199     }
1200 
1201     /**
1202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1203      * Can only be called by the current owner.
1204      */
1205     function transferOwnership(address newOwner) public virtual onlyOwner {
1206         require(
1207             newOwner != address(0),
1208             "Ownable: new owner is the zero address"
1209         );
1210         _transferOwnership(newOwner);
1211     }
1212 
1213     /**
1214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1215      * Internal function without access restriction.
1216      */
1217     function _transferOwnership(address newOwner) internal virtual {
1218         address oldOwner = _owner;
1219         _owner = newOwner;
1220         emit OwnershipTransferred(oldOwner, newOwner);
1221     }
1222 }
1223 
1224 // File @openzeppelin/contracts/utils/Counters.sol@v4.4.1
1225 
1226 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1227 
1228 pragma solidity ^0.8.0;
1229 
1230 /**
1231  * @title Counters
1232  * @author Matt Condon (@shrugs)
1233  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1234  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1235  *
1236  * Include with `using Counters for Counters.Counter;`
1237  */
1238 library Counters {
1239     struct Counter {
1240         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1241         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1242         // this feature: see https://github.com/ethereum/solidity/issues/4637
1243         uint256 _value; // default: 0
1244     }
1245 
1246     function current(Counter storage counter) internal view returns (uint256) {
1247         return counter._value;
1248     }
1249 
1250     function increment(Counter storage counter) internal {
1251         unchecked {
1252             counter._value += 1;
1253         }
1254     }
1255 
1256     function decrement(Counter storage counter) internal {
1257         uint256 value = counter._value;
1258         require(value > 0, "Counter: decrement overflow");
1259         unchecked {
1260             counter._value = value - 1;
1261         }
1262     }
1263 
1264     function reset(Counter storage counter) internal {
1265         counter._value = 0;
1266     }
1267 }
1268 
1269 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.4.1
1270 
1271 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 /**
1276  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1277  *
1278  * These functions can be used to verify that a message was signed by the holder
1279  * of the private keys of a given address.
1280  */
1281 library ECDSA {
1282     enum RecoverError {
1283         NoError,
1284         InvalidSignature,
1285         InvalidSignatureLength,
1286         InvalidSignatureS,
1287         InvalidSignatureV
1288     }
1289 
1290     function _throwError(RecoverError error) private pure {
1291         if (error == RecoverError.NoError) {
1292             return; // no error: do nothing
1293         } else if (error == RecoverError.InvalidSignature) {
1294             revert("ECDSA: invalid signature");
1295         } else if (error == RecoverError.InvalidSignatureLength) {
1296             revert("ECDSA: invalid signature length");
1297         } else if (error == RecoverError.InvalidSignatureS) {
1298             revert("ECDSA: invalid signature 's' value");
1299         } else if (error == RecoverError.InvalidSignatureV) {
1300             revert("ECDSA: invalid signature 'v' value");
1301         }
1302     }
1303 
1304     /**
1305      * @dev Returns the address that signed a hashed message (`hash`) with
1306      * `signature` or error string. This address can then be used for verification purposes.
1307      *
1308      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1309      * this function rejects them by requiring the `s` value to be in the lower
1310      * half order, and the `v` value to be either 27 or 28.
1311      *
1312      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1313      * verification to be secure: it is possible to craft signatures that
1314      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1315      * this is by receiving a hash of the original message (which may otherwise
1316      * be too long), and then calling {toEthSignedMessageHash} on it.
1317      *
1318      * Documentation for signature generation:
1319      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1320      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1321      *
1322      * _Available since v4.3._
1323      */
1324     function tryRecover(bytes32 hash, bytes memory signature)
1325         internal
1326         pure
1327         returns (address, RecoverError)
1328     {
1329         // Check the signature length
1330         // - case 65: r,s,v signature (standard)
1331         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1332         if (signature.length == 65) {
1333             bytes32 r;
1334             bytes32 s;
1335             uint8 v;
1336             // ecrecover takes the signature parameters, and the only way to get them
1337             // currently is to use assembly.
1338             assembly {
1339                 r := mload(add(signature, 0x20))
1340                 s := mload(add(signature, 0x40))
1341                 v := byte(0, mload(add(signature, 0x60)))
1342             }
1343             return tryRecover(hash, v, r, s);
1344         } else if (signature.length == 64) {
1345             bytes32 r;
1346             bytes32 vs;
1347             // ecrecover takes the signature parameters, and the only way to get them
1348             // currently is to use assembly.
1349             assembly {
1350                 r := mload(add(signature, 0x20))
1351                 vs := mload(add(signature, 0x40))
1352             }
1353             return tryRecover(hash, r, vs);
1354         } else {
1355             return (address(0), RecoverError.InvalidSignatureLength);
1356         }
1357     }
1358 
1359     /**
1360      * @dev Returns the address that signed a hashed message (`hash`) with
1361      * `signature`. This address can then be used for verification purposes.
1362      *
1363      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1364      * this function rejects them by requiring the `s` value to be in the lower
1365      * half order, and the `v` value to be either 27 or 28.
1366      *
1367      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1368      * verification to be secure: it is possible to craft signatures that
1369      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1370      * this is by receiving a hash of the original message (which may otherwise
1371      * be too long), and then calling {toEthSignedMessageHash} on it.
1372      */
1373     function recover(bytes32 hash, bytes memory signature)
1374         internal
1375         pure
1376         returns (address)
1377     {
1378         (address recovered, RecoverError error) = tryRecover(hash, signature);
1379         _throwError(error);
1380         return recovered;
1381     }
1382 
1383     /**
1384      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1385      *
1386      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1387      *
1388      * _Available since v4.3._
1389      */
1390     function tryRecover(
1391         bytes32 hash,
1392         bytes32 r,
1393         bytes32 vs
1394     ) internal pure returns (address, RecoverError) {
1395         bytes32 s;
1396         uint8 v;
1397         assembly {
1398             s := and(
1399                 vs,
1400                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1401             )
1402             v := add(shr(255, vs), 27)
1403         }
1404         return tryRecover(hash, v, r, s);
1405     }
1406 
1407     /**
1408      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1409      *
1410      * _Available since v4.2._
1411      */
1412     function recover(
1413         bytes32 hash,
1414         bytes32 r,
1415         bytes32 vs
1416     ) internal pure returns (address) {
1417         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1418         _throwError(error);
1419         return recovered;
1420     }
1421 
1422     /**
1423      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1424      * `r` and `s` signature fields separately.
1425      *
1426      * _Available since v4.3._
1427      */
1428     function tryRecover(
1429         bytes32 hash,
1430         uint8 v,
1431         bytes32 r,
1432         bytes32 s
1433     ) internal pure returns (address, RecoverError) {
1434         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1435         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1436         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1437         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1438         //
1439         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1440         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1441         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1442         // these malleable signatures as well.
1443         if (
1444             uint256(s) >
1445             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
1446         ) {
1447             return (address(0), RecoverError.InvalidSignatureS);
1448         }
1449         if (v != 27 && v != 28) {
1450             return (address(0), RecoverError.InvalidSignatureV);
1451         }
1452 
1453         // If the signature is valid (and not malleable), return the signer address
1454         address signer = ecrecover(hash, v, r, s);
1455         if (signer == address(0)) {
1456             return (address(0), RecoverError.InvalidSignature);
1457         }
1458 
1459         return (signer, RecoverError.NoError);
1460     }
1461 
1462     /**
1463      * @dev Overload of {ECDSA-recover} that receives the `v`,
1464      * `r` and `s` signature fields separately.
1465      */
1466     function recover(
1467         bytes32 hash,
1468         uint8 v,
1469         bytes32 r,
1470         bytes32 s
1471     ) internal pure returns (address) {
1472         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1473         _throwError(error);
1474         return recovered;
1475     }
1476 
1477     /**
1478      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1479      * produces hash corresponding to the one signed with the
1480      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1481      * JSON-RPC method as part of EIP-191.
1482      *
1483      * See {recover}.
1484      */
1485     function toEthSignedMessageHash(bytes32 hash)
1486         internal
1487         pure
1488         returns (bytes32)
1489     {
1490         // 32 is the length in bytes of hash,
1491         // enforced by the type signature above
1492         return
1493             keccak256(
1494                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1495             );
1496     }
1497 
1498     /**
1499      * @dev Returns an Ethereum Signed Message, created from `s`. This
1500      * produces hash corresponding to the one signed with the
1501      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1502      * JSON-RPC method as part of EIP-191.
1503      *
1504      * See {recover}.
1505      */
1506     function toEthSignedMessageHash(bytes memory s)
1507         internal
1508         pure
1509         returns (bytes32)
1510     {
1511         return
1512             keccak256(
1513                 abi.encodePacked(
1514                     "\x19Ethereum Signed Message:\n",
1515                     Strings.toString(s.length),
1516                     s
1517                 )
1518             );
1519     }
1520 
1521     /**
1522      * @dev Returns an Ethereum Signed Typed Data, created from a
1523      * `domainSeparator` and a `structHash`. This produces hash corresponding
1524      * to the one signed with the
1525      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1526      * JSON-RPC method as part of EIP-712.
1527      *
1528      * See {recover}.
1529      */
1530     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
1531         internal
1532         pure
1533         returns (bytes32)
1534     {
1535         return
1536             keccak256(
1537                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
1538             );
1539     }
1540 }
1541 
1542 // File contracts/ChillRx.sol
1543 
1544 pragma solidity ^0.8.4;
1545 
1546 contract ChillRx is ERC721, Ownable {
1547     using Counters for Counters.Counter;
1548     using Strings for uint256;
1549     using ECDSA for bytes32;
1550 
1551     string public PROVENANCE;
1552     string public chillRxUnrevealed;
1553     bool public isSaleActive = false;
1554     bool public isRevealed = false;
1555     bool public isPresaleActive = false;
1556     bool public isMintPassExchangeEnabled = true;
1557     Counters.Counter public tokenMintedFromOrigin;
1558     uint256 public STARTING_INDEX = 0;
1559 
1560     address private signerAddress;
1561     address private fundReceiver;
1562     address private mintPassContractAddress;
1563     string private crxCollectionBaseUri;
1564     mapping(address => uint256) public presaleMinters;
1565 
1566     uint256 public constant MAX_SUPPLY = 9848;
1567     uint256 public constant MINTPASS_AMOUNT = 151;
1568     uint256 public constant ALLOWED_TOKEN_PER_TX = 10;
1569     uint256 public constant PRICE_PER_TOKEN = 0.0808 ether;
1570 
1571     constructor(address _signerAddress, address _fundReceiver)
1572         ERC721("ChillRx", "CLRX")
1573     {
1574         signerAddress = _signerAddress;
1575         fundReceiver = _fundReceiver;
1576     }
1577 
1578     modifier onlyFundReceiver() {
1579         require(msg.sender == fundReceiver);
1580         _;
1581     }
1582 
1583     modifier onlyValidAccess(bytes memory _signature, string memory _saletype) {
1584         require(
1585             isValidAccessMessage(_signature, _saletype),
1586             "Invalid Access Signature"
1587         );
1588         _;
1589     }
1590 
1591     function setStartingIndex(uint256 _STARTING_INDEX) external onlyOwner {
1592         STARTING_INDEX = _STARTING_INDEX + MINTPASS_AMOUNT;
1593     }
1594 
1595     function setChillRxUnrevealed(string calldata _chillRxUnrevealed)
1596         external
1597         onlyOwner
1598     {
1599         chillRxUnrevealed = _chillRxUnrevealed;
1600     }
1601 
1602     function setMintPassContractAddress(address _newContractAddress)
1603         external
1604         onlyOwner
1605     {
1606         mintPassContractAddress = _newContractAddress;
1607     }
1608 
1609     function setCrxCollectionBaseUri(string calldata _crxCollectionBaseUri)
1610         external
1611         onlyOwner
1612     {
1613         crxCollectionBaseUri = _crxCollectionBaseUri;
1614     }
1615 
1616     function setProvenance(string calldata provenance) external onlyOwner {
1617         PROVENANCE = provenance;
1618     }
1619 
1620     function toggleIsMintPassExchangeEnabled() external onlyOwner {
1621         isMintPassExchangeEnabled = !isMintPassExchangeEnabled;
1622     }
1623 
1624     function toggleIsPresaleActive() external onlyOwner {
1625         isPresaleActive = !isPresaleActive;
1626     }
1627 
1628     function toggleIsSaleActive() external onlyOwner {
1629         isSaleActive = !isSaleActive;
1630     }
1631 
1632     function toggleIsRevealed() external onlyOwner {
1633         isRevealed = !isRevealed;
1634     }
1635 
1636     function isValidAccessMessage(
1637         bytes memory _signature,
1638         string memory _saletype
1639     ) private view returns (bool) {
1640         bytes32 messagehash = keccak256(
1641             abi.encodePacked(address(this), msg.sender, _saletype)
1642         );
1643 
1644         address revealedSignerAddress = messagehash
1645             .toEthSignedMessageHash()
1646             .recover(_signature);
1647 
1648         return signerAddress == revealedSignerAddress;
1649     }
1650 
1651     function getRealId(uint256 _originalId) private pure returns (uint256) {
1652         return _originalId % (MAX_SUPPLY + MINTPASS_AMOUNT);
1653     }
1654 
1655     function increaseNextTokenId() private returns (uint256) {
1656         tokenMintedFromOrigin.increment();
1657 
1658         return getRealId(tokenMintedFromOrigin.current() - 1 + STARTING_INDEX);
1659     }
1660 
1661     function reserve(address[] memory _recipients, uint256[] memory _amounts)
1662         external
1663         onlyOwner
1664     {
1665         require(
1666             _recipients.length == _amounts.length,
1667             "RESERVE: arrays have different lengths"
1668         );
1669 
1670         for (uint256 j = 0; j < _recipients.length; j++) {
1671             for (uint256 k = 0; k < _amounts[j]; k++) {
1672                 _safeMint(_recipients[j], increaseNextTokenId());
1673             }
1674         }
1675     }
1676 
1677     function compareStrings(string memory a, string memory b)
1678         private
1679         pure
1680         returns (bool)
1681     {
1682         return (keccak256(abi.encodePacked((a))) ==
1683             keccak256(abi.encodePacked((b))));
1684     }
1685 
1686     function checkAllowedTokenNumberAndAddToMap(
1687         string memory _saletype,
1688         uint256 _numberOfTokensToMint
1689     ) private {
1690         require(
1691             compareStrings(_saletype, "WL") || compareStrings(_saletype, "OG"),
1692             "Presale: Invalid presale type"
1693         );
1694 
1695         uint256 tokenMintLimit = (compareStrings(_saletype, "WL")) ? 2 : 3;
1696         require(
1697             presaleMinters[msg.sender] + _numberOfTokensToMint <=
1698                 tokenMintLimit,
1699             "Presale: Authorized limit exceeded"
1700         );
1701         presaleMinters[msg.sender] =
1702             presaleMinters[msg.sender] +
1703             _numberOfTokensToMint;
1704     }
1705 
1706     function presaleMint(
1707         uint256 _numberOfTokensToMint,
1708         bytes memory _signature,
1709         string memory _saletype
1710     ) external payable onlyValidAccess(_signature, _saletype) {
1711         require(isPresaleActive, "PRESALE: presale is inactive");
1712 
1713         require(
1714             tokenMintedFromOrigin.current() + _numberOfTokensToMint <=
1715                 MAX_SUPPLY,
1716             "Purchase would exceed max tokens"
1717         );
1718 
1719         require(
1720             PRICE_PER_TOKEN * _numberOfTokensToMint <= msg.value,
1721             "PRESALE: Ether value sent is incorrect"
1722         );
1723 
1724         checkAllowedTokenNumberAndAddToMap(_saletype, _numberOfTokensToMint);
1725 
1726         for (uint256 i = 0; i < _numberOfTokensToMint; i++) {
1727             _safeMint(msg.sender, increaseNextTokenId());
1728         }
1729     }
1730 
1731     function mint(uint256 _numberOfTokens, address _receiverAddress)
1732         external
1733         payable
1734     {
1735         require(isSaleActive, "MintError: Sale is inactive");
1736         require(
1737             _numberOfTokens <= ALLOWED_TOKEN_PER_TX,
1738             "MintError: Max tokens per transaction exceeded"
1739         );
1740         require(
1741             tokenMintedFromOrigin.current() + _numberOfTokens <= MAX_SUPPLY,
1742             "MintError: Purchase would exceed max tokens"
1743         );
1744         require(
1745             PRICE_PER_TOKEN * _numberOfTokens <= msg.value,
1746             "MintError: Ether value sent is incorrect"
1747         );
1748         for (uint256 i = 0; i < _numberOfTokens; i++) {
1749             _safeMint(_receiverAddress, increaseNextTokenId());
1750         }
1751     }
1752 
1753     function airdropTokenExchange(address _receiver, uint256 _passid)
1754         external
1755         returns (uint256)
1756     {
1757         require(
1758             msg.sender == mintPassContractAddress,
1759             "Token Exchange: Unauthorized"
1760         );
1761 
1762         require(
1763             isMintPassExchangeEnabled == true,
1764             "Token Exchange is inactive"
1765         );
1766 
1767         require(
1768             _passid > 0 && _passid <= MINTPASS_AMOUNT,
1769             "Token Exchange: pass id out of range"
1770         );
1771 
1772         uint256 mintedId = getRealId(
1773             STARTING_INDEX + _passid - MINTPASS_AMOUNT - 1
1774         );
1775         _safeMint(_receiver, mintedId);
1776 
1777         return mintedId;
1778     }
1779 
1780     function withdraw() external onlyFundReceiver {
1781         payable(fundReceiver).transfer(address(this).balance);
1782     }
1783 
1784     function _baseURI() internal view virtual override returns (string memory) {
1785         return crxCollectionBaseUri;
1786     }
1787 
1788     function tokenURI(uint256 tokenId)
1789         public
1790         view
1791         virtual
1792         override
1793         returns (string memory)
1794     {
1795         require(_exists(tokenId), "tokenURI: URI query for nonexistent token");
1796         string memory baseURI = _baseURI();
1797         if (isRevealed == false || bytes(baseURI).length == 0) {
1798             return chillRxUnrevealed;
1799         }
1800 
1801         return string(abi.encodePacked(baseURI, tokenId.toString()));
1802     }
1803 }