1 // Sources flattened with hardhat v2.9.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
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
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
32 
33 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
83      * @dev Safely transfers `tokenId` token from `from` to `to`.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must exist and be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
92      *
93      * Emits a {Transfer} event.
94      */
95     function safeTransferFrom(
96         address from,
97         address to,
98         uint256 tokenId,
99         bytes calldata data
100     ) external;
101 
102     /**
103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must exist and be owned by `from`.
111      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
112      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
113      *
114      * Emits a {Transfer} event.
115      */
116     function safeTransferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Transfers `tokenId` token from `from` to `to`.
124      *
125      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must be owned by `from`.
132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(
137         address from,
138         address to,
139         uint256 tokenId
140     ) external;
141 
142     /**
143      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
144      * The approval is cleared when the token is transferred.
145      *
146      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
147      *
148      * Requirements:
149      *
150      * - The caller must own the token or be an approved operator.
151      * - `tokenId` must exist.
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address to, uint256 tokenId) external;
156 
157     /**
158      * @dev Approve or remove `operator` as an operator for the caller.
159      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
160      *
161      * Requirements:
162      *
163      * - The `operator` cannot be the caller.
164      *
165      * Emits an {ApprovalForAll} event.
166      */
167     function setApprovalForAll(address operator, bool _approved) external;
168 
169     /**
170      * @dev Returns the account approved for `tokenId` token.
171      *
172      * Requirements:
173      *
174      * - `tokenId` must exist.
175      */
176     function getApproved(uint256 tokenId)
177         external
178         view
179         returns (address operator);
180 
181     /**
182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
183      *
184      * See {setApprovalForAll}
185      */
186     function isApprovedForAll(address owner, address operator)
187         external
188         view
189         returns (bool);
190 }
191 
192 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
193 
194 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
211      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
212      */
213     function onERC721Received(
214         address operator,
215         address from,
216         uint256 tokenId,
217         bytes calldata data
218     ) external returns (bytes4);
219 }
220 
221 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
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
248 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
249 
250 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
251 
252 pragma solidity ^0.8.1;
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
274      *
275      * [IMPORTANT]
276      * ====
277      * You shouldn't rely on `isContract` to protect against flash loan attacks!
278      *
279      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
280      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
281      * constructor.
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies on extcodesize/address.code.length, which returns 0
286         // for contracts in construction, since the code is only stored at the end
287         // of the constructor execution.
288 
289         return account.code.length > 0;
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(
310             address(this).balance >= amount,
311             "Address: insufficient balance"
312         );
313 
314         (bool success, ) = recipient.call{value: amount}("");
315         require(
316             success,
317             "Address: unable to send value, recipient may have reverted"
318         );
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain `call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data)
340         internal
341         returns (bytes memory)
342     {
343         return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value
375     ) internal returns (bytes memory) {
376         return
377             functionCallWithValue(
378                 target,
379                 data,
380                 value,
381                 "Address: low-level call with value failed"
382             );
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(
398             address(this).balance >= value,
399             "Address: insufficient balance for call"
400         );
401         require(isContract(target), "Address: call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.call{value: value}(
404             data
405         );
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(address target, bytes memory data)
416         internal
417         view
418         returns (bytes memory)
419     {
420         return
421             functionStaticCall(
422                 target,
423                 data,
424                 "Address: low-level static call failed"
425             );
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
430      * but performing a static call.
431      *
432      * _Available since v3.3._
433      */
434     function functionStaticCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal view returns (bytes memory) {
439         require(isContract(target), "Address: static call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.staticcall(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a delegate call.
448      *
449      * _Available since v3.4._
450      */
451     function functionDelegateCall(address target, bytes memory data)
452         internal
453         returns (bytes memory)
454     {
455         return
456             functionDelegateCall(
457                 target,
458                 data,
459                 "Address: low-level delegate call failed"
460             );
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         require(isContract(target), "Address: delegate call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.delegatecall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
482      * revert reason using the provided one.
483      *
484      * _Available since v4.3._
485      */
486     function verifyCallResult(
487         bool success,
488         bytes memory returndata,
489         string memory errorMessage
490     ) internal pure returns (bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497 
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
510 
511 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Provides information about the current execution context, including the
517  * sender of the transaction and its data. While these are generally available
518  * via msg.sender and msg.data, they should not be accessed in such a direct
519  * manner, since when dealing with meta-transactions the account sending and
520  * paying for execution may not be the actual sender (as far as an application
521  * is concerned).
522  *
523  * This contract is only required for intermediate, library-like contracts.
524  */
525 abstract contract Context {
526     function _msgSender() internal view virtual returns (address) {
527         return msg.sender;
528     }
529 
530     function _msgData() internal view virtual returns (bytes calldata) {
531         return msg.data;
532     }
533 }
534 
535 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev String operations.
543  */
544 library Strings {
545     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
549      */
550     function toString(uint256 value) internal pure returns (string memory) {
551         // Inspired by OraclizeAPI's implementation - MIT licence
552         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
553 
554         if (value == 0) {
555             return "0";
556         }
557         uint256 temp = value;
558         uint256 digits;
559         while (temp != 0) {
560             digits++;
561             temp /= 10;
562         }
563         bytes memory buffer = new bytes(digits);
564         while (value != 0) {
565             digits -= 1;
566             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
567             value /= 10;
568         }
569         return string(buffer);
570     }
571 
572     /**
573      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
574      */
575     function toHexString(uint256 value) internal pure returns (string memory) {
576         if (value == 0) {
577             return "0x00";
578         }
579         uint256 temp = value;
580         uint256 length = 0;
581         while (temp != 0) {
582             length++;
583             temp >>= 8;
584         }
585         return toHexString(value, length);
586     }
587 
588     /**
589      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
590      */
591     function toHexString(uint256 value, uint256 length)
592         internal
593         pure
594         returns (string memory)
595     {
596         bytes memory buffer = new bytes(2 * length + 2);
597         buffer[0] = "0";
598         buffer[1] = "x";
599         for (uint256 i = 2 * length + 1; i > 1; --i) {
600             buffer[i] = _HEX_SYMBOLS[value & 0xf];
601             value >>= 4;
602         }
603         require(value == 0, "Strings: hex length insufficient");
604         return string(buffer);
605     }
606 }
607 
608 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
609 
610 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Implementation of the {IERC165} interface.
616  *
617  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
618  * for the additional interface id that will be supported. For example:
619  *
620  * ```solidity
621  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
623  * }
624  * ```
625  *
626  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
627  */
628 abstract contract ERC165 is IERC165 {
629     /**
630      * @dev See {IERC165-supportsInterface}.
631      */
632     function supportsInterface(bytes4 interfaceId)
633         public
634         view
635         virtual
636         override
637         returns (bool)
638     {
639         return interfaceId == type(IERC165).interfaceId;
640     }
641 }
642 
643 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.6.0
644 
645 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
646 
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
774      * by default, can be overridden in child contracts.
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
821         _setApprovalForAll(_msgSender(), operator, approved);
822     }
823 
824     /**
825      * @dev See {IERC721-isApprovedForAll}.
826      */
827     function isApprovedForAll(address owner, address operator)
828         public
829         view
830         virtual
831         override
832         returns (bool)
833     {
834         return _operatorApprovals[owner][operator];
835     }
836 
837     /**
838      * @dev See {IERC721-transferFrom}.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public virtual override {
845         //solhint-disable-next-line max-line-length
846         require(
847             _isApprovedOrOwner(_msgSender(), tokenId),
848             "ERC721: transfer caller is not owner nor approved"
849         );
850 
851         _transfer(from, to, tokenId);
852     }
853 
854     /**
855      * @dev See {IERC721-safeTransferFrom}.
856      */
857     function safeTransferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public virtual override {
862         safeTransferFrom(from, to, tokenId, "");
863     }
864 
865     /**
866      * @dev See {IERC721-safeTransferFrom}.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId,
872         bytes memory _data
873     ) public virtual override {
874         require(
875             _isApprovedOrOwner(_msgSender(), tokenId),
876             "ERC721: transfer caller is not owner nor approved"
877         );
878         _safeTransfer(from, to, tokenId, _data);
879     }
880 
881     /**
882      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
883      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
884      *
885      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
886      *
887      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
888      * implement alternative mechanisms to perform token transfer, such as signature-based.
889      *
890      * Requirements:
891      *
892      * - `from` cannot be the zero address.
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must exist and be owned by `from`.
895      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _safeTransfer(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) internal virtual {
905         _transfer(from, to, tokenId);
906         require(
907             _checkOnERC721Received(from, to, tokenId, _data),
908             "ERC721: transfer to non ERC721Receiver implementer"
909         );
910     }
911 
912     /**
913      * @dev Returns whether `tokenId` exists.
914      *
915      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
916      *
917      * Tokens start existing when they are minted (`_mint`),
918      * and stop existing when they are burned (`_burn`).
919      */
920     function _exists(uint256 tokenId) internal view virtual returns (bool) {
921         return _owners[tokenId] != address(0);
922     }
923 
924     /**
925      * @dev Returns whether `spender` is allowed to manage `tokenId`.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      */
931     function _isApprovedOrOwner(address spender, uint256 tokenId)
932         internal
933         view
934         virtual
935         returns (bool)
936     {
937         require(
938             _exists(tokenId),
939             "ERC721: operator query for nonexistent token"
940         );
941         address owner = ERC721.ownerOf(tokenId);
942         return (spender == owner ||
943             isApprovedForAll(owner, spender) ||
944             getApproved(tokenId) == spender);
945     }
946 
947     /**
948      * @dev Safely mints `tokenId` and transfers it to `to`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(address to, uint256 tokenId) internal virtual {
958         _safeMint(to, tokenId, "");
959     }
960 
961     /**
962      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
963      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
964      */
965     function _safeMint(
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) internal virtual {
970         _mint(to, tokenId);
971         require(
972             _checkOnERC721Received(address(0), to, tokenId, _data),
973             "ERC721: transfer to non ERC721Receiver implementer"
974         );
975     }
976 
977     /**
978      * @dev Mints `tokenId` and transfers it to `to`.
979      *
980      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
981      *
982      * Requirements:
983      *
984      * - `tokenId` must not exist.
985      * - `to` cannot be the zero address.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _mint(address to, uint256 tokenId) internal virtual {
990         require(to != address(0), "ERC721: mint to the zero address");
991         require(!_exists(tokenId), "ERC721: token already minted");
992 
993         _beforeTokenTransfer(address(0), to, tokenId);
994 
995         _balances[to] += 1;
996         _owners[tokenId] = to;
997 
998         emit Transfer(address(0), to, tokenId);
999 
1000         _afterTokenTransfer(address(0), to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Destroys `tokenId`.
1005      * The approval is cleared when the token is burned.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _burn(uint256 tokenId) internal virtual {
1014         address owner = ERC721.ownerOf(tokenId);
1015 
1016         _beforeTokenTransfer(owner, address(0), tokenId);
1017 
1018         // Clear approvals
1019         _approve(address(0), tokenId);
1020 
1021         _balances[owner] -= 1;
1022         delete _owners[tokenId];
1023 
1024         emit Transfer(owner, address(0), tokenId);
1025 
1026         _afterTokenTransfer(owner, address(0), tokenId);
1027     }
1028 
1029     /**
1030      * @dev Transfers `tokenId` from `from` to `to`.
1031      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1032      *
1033      * Requirements:
1034      *
1035      * - `to` cannot be the zero address.
1036      * - `tokenId` token must be owned by `from`.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _transfer(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) internal virtual {
1045         require(
1046             ERC721.ownerOf(tokenId) == from,
1047             "ERC721: transfer from incorrect owner"
1048         );
1049         require(to != address(0), "ERC721: transfer to the zero address");
1050 
1051         _beforeTokenTransfer(from, to, tokenId);
1052 
1053         // Clear approvals from the previous owner
1054         _approve(address(0), tokenId);
1055 
1056         _balances[from] -= 1;
1057         _balances[to] += 1;
1058         _owners[tokenId] = to;
1059 
1060         emit Transfer(from, to, tokenId);
1061 
1062         _afterTokenTransfer(from, to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev Approve `to` to operate on `tokenId`
1067      *
1068      * Emits a {Approval} event.
1069      */
1070     function _approve(address to, uint256 tokenId) internal virtual {
1071         _tokenApprovals[tokenId] = to;
1072         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Approve `operator` to operate on all of `owner` tokens
1077      *
1078      * Emits a {ApprovalForAll} event.
1079      */
1080     function _setApprovalForAll(
1081         address owner,
1082         address operator,
1083         bool approved
1084     ) internal virtual {
1085         require(owner != operator, "ERC721: approve to caller");
1086         _operatorApprovals[owner][operator] = approved;
1087         emit ApprovalForAll(owner, operator, approved);
1088     }
1089 
1090     /**
1091      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1092      * The call is not executed if the target address is not a contract.
1093      *
1094      * @param from address representing the previous owner of the given token ID
1095      * @param to target address that will receive the tokens
1096      * @param tokenId uint256 ID of the token to be transferred
1097      * @param _data bytes optional data to send along with the call
1098      * @return bool whether the call correctly returned the expected magic value
1099      */
1100     function _checkOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         if (to.isContract()) {
1107             try
1108                 IERC721Receiver(to).onERC721Received(
1109                     _msgSender(),
1110                     from,
1111                     tokenId,
1112                     _data
1113                 )
1114             returns (bytes4 retval) {
1115                 return retval == IERC721Receiver.onERC721Received.selector;
1116             } catch (bytes memory reason) {
1117                 if (reason.length == 0) {
1118                     revert(
1119                         "ERC721: transfer to non ERC721Receiver implementer"
1120                     );
1121                 } else {
1122                     assembly {
1123                         revert(add(32, reason), mload(reason))
1124                     }
1125                 }
1126             }
1127         } else {
1128             return true;
1129         }
1130     }
1131 
1132     /**
1133      * @dev Hook that is called before any token transfer. This includes minting
1134      * and burning.
1135      *
1136      * Calling conditions:
1137      *
1138      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1139      * transferred to `to`.
1140      * - When `from` is zero, `tokenId` will be minted for `to`.
1141      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1142      * - `from` and `to` are never both zero.
1143      *
1144      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1145      */
1146     function _beforeTokenTransfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) internal virtual {}
1151 
1152     /**
1153      * @dev Hook that is called after any transfer of tokens. This includes
1154      * minting and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - when `from` and `to` are both non-zero.
1159      * - `from` and `to` are never both zero.
1160      *
1161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1162      */
1163     function _afterTokenTransfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) internal virtual {}
1168 }
1169 
1170 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.6.0
1171 
1172 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 /**
1177  * @dev ERC721 token with storage based token URI management.
1178  */
1179 abstract contract ERC721URIStorage is ERC721 {
1180     using Strings for uint256;
1181 
1182     // Optional mapping for token URIs
1183     mapping(uint256 => string) private _tokenURIs;
1184 
1185     /**
1186      * @dev See {IERC721Metadata-tokenURI}.
1187      */
1188     function tokenURI(uint256 tokenId)
1189         public
1190         view
1191         virtual
1192         override
1193         returns (string memory)
1194     {
1195         require(
1196             _exists(tokenId),
1197             "ERC721URIStorage: URI query for nonexistent token"
1198         );
1199 
1200         string memory _tokenURI = _tokenURIs[tokenId];
1201         string memory base = _baseURI();
1202 
1203         // If there is no base URI, return the token URI.
1204         if (bytes(base).length == 0) {
1205             return _tokenURI;
1206         }
1207         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1208         if (bytes(_tokenURI).length > 0) {
1209             return string(abi.encodePacked(base, _tokenURI));
1210         }
1211 
1212         return super.tokenURI(tokenId);
1213     }
1214 
1215     /**
1216      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must exist.
1221      */
1222     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
1223         internal
1224         virtual
1225     {
1226         require(
1227             _exists(tokenId),
1228             "ERC721URIStorage: URI set of nonexistent token"
1229         );
1230         _tokenURIs[tokenId] = _tokenURI;
1231     }
1232 
1233     /**
1234      * @dev Destroys `tokenId`.
1235      * The approval is cleared when the token is burned.
1236      *
1237      * Requirements:
1238      *
1239      * - `tokenId` must exist.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _burn(uint256 tokenId) internal virtual override {
1244         super._burn(tokenId);
1245 
1246         if (bytes(_tokenURIs[tokenId]).length != 0) {
1247             delete _tokenURIs[tokenId];
1248         }
1249     }
1250 }
1251 
1252 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.6.0
1253 
1254 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 /**
1259  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1260  *
1261  * These functions can be used to verify that a message was signed by the holder
1262  * of the private keys of a given address.
1263  */
1264 library ECDSA {
1265     enum RecoverError {
1266         NoError,
1267         InvalidSignature,
1268         InvalidSignatureLength,
1269         InvalidSignatureS,
1270         InvalidSignatureV
1271     }
1272 
1273     function _throwError(RecoverError error) private pure {
1274         if (error == RecoverError.NoError) {
1275             return; // no error: do nothing
1276         } else if (error == RecoverError.InvalidSignature) {
1277             revert("ECDSA: invalid signature");
1278         } else if (error == RecoverError.InvalidSignatureLength) {
1279             revert("ECDSA: invalid signature length");
1280         } else if (error == RecoverError.InvalidSignatureS) {
1281             revert("ECDSA: invalid signature 's' value");
1282         } else if (error == RecoverError.InvalidSignatureV) {
1283             revert("ECDSA: invalid signature 'v' value");
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns the address that signed a hashed message (`hash`) with
1289      * `signature` or error string. This address can then be used for verification purposes.
1290      *
1291      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1292      * this function rejects them by requiring the `s` value to be in the lower
1293      * half order, and the `v` value to be either 27 or 28.
1294      *
1295      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1296      * verification to be secure: it is possible to craft signatures that
1297      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1298      * this is by receiving a hash of the original message (which may otherwise
1299      * be too long), and then calling {toEthSignedMessageHash} on it.
1300      *
1301      * Documentation for signature generation:
1302      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1303      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1304      *
1305      * _Available since v4.3._
1306      */
1307     function tryRecover(bytes32 hash, bytes memory signature)
1308         internal
1309         pure
1310         returns (address, RecoverError)
1311     {
1312         // Check the signature length
1313         // - case 65: r,s,v signature (standard)
1314         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1315         if (signature.length == 65) {
1316             bytes32 r;
1317             bytes32 s;
1318             uint8 v;
1319             // ecrecover takes the signature parameters, and the only way to get them
1320             // currently is to use assembly.
1321             assembly {
1322                 r := mload(add(signature, 0x20))
1323                 s := mload(add(signature, 0x40))
1324                 v := byte(0, mload(add(signature, 0x60)))
1325             }
1326             return tryRecover(hash, v, r, s);
1327         } else if (signature.length == 64) {
1328             bytes32 r;
1329             bytes32 vs;
1330             // ecrecover takes the signature parameters, and the only way to get them
1331             // currently is to use assembly.
1332             assembly {
1333                 r := mload(add(signature, 0x20))
1334                 vs := mload(add(signature, 0x40))
1335             }
1336             return tryRecover(hash, r, vs);
1337         } else {
1338             return (address(0), RecoverError.InvalidSignatureLength);
1339         }
1340     }
1341 
1342     /**
1343      * @dev Returns the address that signed a hashed message (`hash`) with
1344      * `signature`. This address can then be used for verification purposes.
1345      *
1346      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1347      * this function rejects them by requiring the `s` value to be in the lower
1348      * half order, and the `v` value to be either 27 or 28.
1349      *
1350      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1351      * verification to be secure: it is possible to craft signatures that
1352      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1353      * this is by receiving a hash of the original message (which may otherwise
1354      * be too long), and then calling {toEthSignedMessageHash} on it.
1355      */
1356     function recover(bytes32 hash, bytes memory signature)
1357         internal
1358         pure
1359         returns (address)
1360     {
1361         (address recovered, RecoverError error) = tryRecover(hash, signature);
1362         _throwError(error);
1363         return recovered;
1364     }
1365 
1366     /**
1367      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1368      *
1369      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1370      *
1371      * _Available since v4.3._
1372      */
1373     function tryRecover(
1374         bytes32 hash,
1375         bytes32 r,
1376         bytes32 vs
1377     ) internal pure returns (address, RecoverError) {
1378         bytes32 s = vs &
1379             bytes32(
1380                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1381             );
1382         uint8 v = uint8((uint256(vs) >> 255) + 27);
1383         return tryRecover(hash, v, r, s);
1384     }
1385 
1386     /**
1387      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1388      *
1389      * _Available since v4.2._
1390      */
1391     function recover(
1392         bytes32 hash,
1393         bytes32 r,
1394         bytes32 vs
1395     ) internal pure returns (address) {
1396         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1397         _throwError(error);
1398         return recovered;
1399     }
1400 
1401     /**
1402      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1403      * `r` and `s` signature fields separately.
1404      *
1405      * _Available since v4.3._
1406      */
1407     function tryRecover(
1408         bytes32 hash,
1409         uint8 v,
1410         bytes32 r,
1411         bytes32 s
1412     ) internal pure returns (address, RecoverError) {
1413         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1414         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1415         // the valid range for s in (301): 0 < s < secp256k1n ├À 2 + 1, and for v in (302): v Ôêê {27, 28}. Most
1416         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1417         //
1418         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1419         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1420         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1421         // these malleable signatures as well.
1422         if (
1423             uint256(s) >
1424             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
1425         ) {
1426             return (address(0), RecoverError.InvalidSignatureS);
1427         }
1428         if (v != 27 && v != 28) {
1429             return (address(0), RecoverError.InvalidSignatureV);
1430         }
1431 
1432         // If the signature is valid (and not malleable), return the signer address
1433         address signer = ecrecover(hash, v, r, s);
1434         if (signer == address(0)) {
1435             return (address(0), RecoverError.InvalidSignature);
1436         }
1437 
1438         return (signer, RecoverError.NoError);
1439     }
1440 
1441     /**
1442      * @dev Overload of {ECDSA-recover} that receives the `v`,
1443      * `r` and `s` signature fields separately.
1444      */
1445     function recover(
1446         bytes32 hash,
1447         uint8 v,
1448         bytes32 r,
1449         bytes32 s
1450     ) internal pure returns (address) {
1451         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1452         _throwError(error);
1453         return recovered;
1454     }
1455 
1456     /**
1457      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1458      * produces hash corresponding to the one signed with the
1459      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1460      * JSON-RPC method as part of EIP-191.
1461      *
1462      * See {recover}.
1463      */
1464     function toEthSignedMessageHash(bytes32 hash)
1465         internal
1466         pure
1467         returns (bytes32)
1468     {
1469         // 32 is the length in bytes of hash,
1470         // enforced by the type signature above
1471         return
1472             keccak256(
1473                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1474             );
1475     }
1476 
1477     /**
1478      * @dev Returns an Ethereum Signed Message, created from `s`. This
1479      * produces hash corresponding to the one signed with the
1480      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1481      * JSON-RPC method as part of EIP-191.
1482      *
1483      * See {recover}.
1484      */
1485     function toEthSignedMessageHash(bytes memory s)
1486         internal
1487         pure
1488         returns (bytes32)
1489     {
1490         return
1491             keccak256(
1492                 abi.encodePacked(
1493                     "\x19Ethereum Signed Message:\n",
1494                     Strings.toString(s.length),
1495                     s
1496                 )
1497             );
1498     }
1499 
1500     /**
1501      * @dev Returns an Ethereum Signed Typed Data, created from a
1502      * `domainSeparator` and a `structHash`. This produces hash corresponding
1503      * to the one signed with the
1504      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1505      * JSON-RPC method as part of EIP-712.
1506      *
1507      * See {recover}.
1508      */
1509     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
1510         internal
1511         pure
1512         returns (bytes32)
1513     {
1514         return
1515             keccak256(
1516                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
1517             );
1518     }
1519 }
1520 
1521 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1522 
1523 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1524 
1525 pragma solidity ^0.8.0;
1526 
1527 /**
1528  * @dev Contract module which provides a basic access control mechanism, where
1529  * there is an account (an owner) that can be granted exclusive access to
1530  * specific functions.
1531  *
1532  * By default, the owner account will be the one that deploys the contract. This
1533  * can later be changed with {transferOwnership}.
1534  *
1535  * This module is used through inheritance. It will make available the modifier
1536  * `onlyOwner`, which can be applied to your functions to restrict their use to
1537  * the owner.
1538  */
1539 abstract contract Ownable is Context {
1540     address private _owner;
1541 
1542     event OwnershipTransferred(
1543         address indexed previousOwner,
1544         address indexed newOwner
1545     );
1546 
1547     /**
1548      * @dev Initializes the contract setting the deployer as the initial owner.
1549      */
1550     constructor() {
1551         _transferOwnership(_msgSender());
1552     }
1553 
1554     /**
1555      * @dev Returns the address of the current owner.
1556      */
1557     function owner() public view virtual returns (address) {
1558         return _owner;
1559     }
1560 
1561     /**
1562      * @dev Throws if called by any account other than the owner.
1563      */
1564     modifier onlyOwner() {
1565         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1566         _;
1567     }
1568 
1569     /**
1570      * @dev Leaves the contract without owner. It will not be possible to call
1571      * `onlyOwner` functions anymore. Can only be called by the current owner.
1572      *
1573      * NOTE: Renouncing ownership will leave the contract without an owner,
1574      * thereby removing any functionality that is only available to the owner.
1575      */
1576     function renounceOwnership() public virtual onlyOwner {
1577         _transferOwnership(address(0));
1578     }
1579 
1580     /**
1581      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1582      * Can only be called by the current owner.
1583      */
1584     function transferOwnership(address newOwner) public virtual onlyOwner {
1585         require(
1586             newOwner != address(0),
1587             "Ownable: new owner is the zero address"
1588         );
1589         _transferOwnership(newOwner);
1590     }
1591 
1592     /**
1593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1594      * Internal function without access restriction.
1595      */
1596     function _transferOwnership(address newOwner) internal virtual {
1597         address oldOwner = _owner;
1598         _owner = newOwner;
1599         emit OwnershipTransferred(oldOwner, newOwner);
1600     }
1601 }
1602 
1603 // File hardhat/console.sol@v2.9.7
1604 
1605 pragma solidity >=0.4.22 <0.9.0;
1606 
1607 library console {
1608     address constant CONSOLE_ADDRESS =
1609         address(0x000000000000000000636F6e736F6c652e6c6f67);
1610 
1611     function _sendLogPayload(bytes memory payload) private view {
1612         uint256 payloadLength = payload.length;
1613         address consoleAddress = CONSOLE_ADDRESS;
1614         assembly {
1615             let payloadStart := add(payload, 32)
1616             let r := staticcall(
1617                 gas(),
1618                 consoleAddress,
1619                 payloadStart,
1620                 payloadLength,
1621                 0,
1622                 0
1623             )
1624         }
1625     }
1626 
1627     function log() internal view {
1628         _sendLogPayload(abi.encodeWithSignature("log()"));
1629     }
1630 
1631     function logInt(int256 p0) internal view {
1632         _sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1633     }
1634 
1635     function logUint(uint256 p0) internal view {
1636         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1637     }
1638 
1639     function logString(string memory p0) internal view {
1640         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1641     }
1642 
1643     function logBool(bool p0) internal view {
1644         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1645     }
1646 
1647     function logAddress(address p0) internal view {
1648         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1649     }
1650 
1651     function logBytes(bytes memory p0) internal view {
1652         _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1653     }
1654 
1655     function logBytes1(bytes1 p0) internal view {
1656         _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1657     }
1658 
1659     function logBytes2(bytes2 p0) internal view {
1660         _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1661     }
1662 
1663     function logBytes3(bytes3 p0) internal view {
1664         _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1665     }
1666 
1667     function logBytes4(bytes4 p0) internal view {
1668         _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1669     }
1670 
1671     function logBytes5(bytes5 p0) internal view {
1672         _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1673     }
1674 
1675     function logBytes6(bytes6 p0) internal view {
1676         _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1677     }
1678 
1679     function logBytes7(bytes7 p0) internal view {
1680         _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1681     }
1682 
1683     function logBytes8(bytes8 p0) internal view {
1684         _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1685     }
1686 
1687     function logBytes9(bytes9 p0) internal view {
1688         _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1689     }
1690 
1691     function logBytes10(bytes10 p0) internal view {
1692         _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1693     }
1694 
1695     function logBytes11(bytes11 p0) internal view {
1696         _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1697     }
1698 
1699     function logBytes12(bytes12 p0) internal view {
1700         _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1701     }
1702 
1703     function logBytes13(bytes13 p0) internal view {
1704         _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1705     }
1706 
1707     function logBytes14(bytes14 p0) internal view {
1708         _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1709     }
1710 
1711     function logBytes15(bytes15 p0) internal view {
1712         _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1713     }
1714 
1715     function logBytes16(bytes16 p0) internal view {
1716         _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1717     }
1718 
1719     function logBytes17(bytes17 p0) internal view {
1720         _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1721     }
1722 
1723     function logBytes18(bytes18 p0) internal view {
1724         _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1725     }
1726 
1727     function logBytes19(bytes19 p0) internal view {
1728         _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1729     }
1730 
1731     function logBytes20(bytes20 p0) internal view {
1732         _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1733     }
1734 
1735     function logBytes21(bytes21 p0) internal view {
1736         _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1737     }
1738 
1739     function logBytes22(bytes22 p0) internal view {
1740         _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1741     }
1742 
1743     function logBytes23(bytes23 p0) internal view {
1744         _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1745     }
1746 
1747     function logBytes24(bytes24 p0) internal view {
1748         _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1749     }
1750 
1751     function logBytes25(bytes25 p0) internal view {
1752         _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1753     }
1754 
1755     function logBytes26(bytes26 p0) internal view {
1756         _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1757     }
1758 
1759     function logBytes27(bytes27 p0) internal view {
1760         _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1761     }
1762 
1763     function logBytes28(bytes28 p0) internal view {
1764         _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1765     }
1766 
1767     function logBytes29(bytes29 p0) internal view {
1768         _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1769     }
1770 
1771     function logBytes30(bytes30 p0) internal view {
1772         _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1773     }
1774 
1775     function logBytes31(bytes31 p0) internal view {
1776         _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1777     }
1778 
1779     function logBytes32(bytes32 p0) internal view {
1780         _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1781     }
1782 
1783     function log(uint256 p0) internal view {
1784         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1785     }
1786 
1787     function log(string memory p0) internal view {
1788         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1789     }
1790 
1791     function log(bool p0) internal view {
1792         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1793     }
1794 
1795     function log(address p0) internal view {
1796         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1797     }
1798 
1799     function log(uint256 p0, uint256 p1) internal view {
1800         _sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1801     }
1802 
1803     function log(uint256 p0, string memory p1) internal view {
1804         _sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1805     }
1806 
1807     function log(uint256 p0, bool p1) internal view {
1808         _sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1809     }
1810 
1811     function log(uint256 p0, address p1) internal view {
1812         _sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1813     }
1814 
1815     function log(string memory p0, uint256 p1) internal view {
1816         _sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1817     }
1818 
1819     function log(string memory p0, string memory p1) internal view {
1820         _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1821     }
1822 
1823     function log(string memory p0, bool p1) internal view {
1824         _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1825     }
1826 
1827     function log(string memory p0, address p1) internal view {
1828         _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1829     }
1830 
1831     function log(bool p0, uint256 p1) internal view {
1832         _sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1833     }
1834 
1835     function log(bool p0, string memory p1) internal view {
1836         _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1837     }
1838 
1839     function log(bool p0, bool p1) internal view {
1840         _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1841     }
1842 
1843     function log(bool p0, address p1) internal view {
1844         _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1845     }
1846 
1847     function log(address p0, uint256 p1) internal view {
1848         _sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1849     }
1850 
1851     function log(address p0, string memory p1) internal view {
1852         _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1853     }
1854 
1855     function log(address p0, bool p1) internal view {
1856         _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1857     }
1858 
1859     function log(address p0, address p1) internal view {
1860         _sendLogPayload(
1861             abi.encodeWithSignature("log(address,address)", p0, p1)
1862         );
1863     }
1864 
1865     function log(
1866         uint256 p0,
1867         uint256 p1,
1868         uint256 p2
1869     ) internal view {
1870         _sendLogPayload(
1871             abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2)
1872         );
1873     }
1874 
1875     function log(
1876         uint256 p0,
1877         uint256 p1,
1878         string memory p2
1879     ) internal view {
1880         _sendLogPayload(
1881             abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2)
1882         );
1883     }
1884 
1885     function log(
1886         uint256 p0,
1887         uint256 p1,
1888         bool p2
1889     ) internal view {
1890         _sendLogPayload(
1891             abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2)
1892         );
1893     }
1894 
1895     function log(
1896         uint256 p0,
1897         uint256 p1,
1898         address p2
1899     ) internal view {
1900         _sendLogPayload(
1901             abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2)
1902         );
1903     }
1904 
1905     function log(
1906         uint256 p0,
1907         string memory p1,
1908         uint256 p2
1909     ) internal view {
1910         _sendLogPayload(
1911             abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2)
1912         );
1913     }
1914 
1915     function log(
1916         uint256 p0,
1917         string memory p1,
1918         string memory p2
1919     ) internal view {
1920         _sendLogPayload(
1921             abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2)
1922         );
1923     }
1924 
1925     function log(
1926         uint256 p0,
1927         string memory p1,
1928         bool p2
1929     ) internal view {
1930         _sendLogPayload(
1931             abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2)
1932         );
1933     }
1934 
1935     function log(
1936         uint256 p0,
1937         string memory p1,
1938         address p2
1939     ) internal view {
1940         _sendLogPayload(
1941             abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2)
1942         );
1943     }
1944 
1945     function log(
1946         uint256 p0,
1947         bool p1,
1948         uint256 p2
1949     ) internal view {
1950         _sendLogPayload(
1951             abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2)
1952         );
1953     }
1954 
1955     function log(
1956         uint256 p0,
1957         bool p1,
1958         string memory p2
1959     ) internal view {
1960         _sendLogPayload(
1961             abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2)
1962         );
1963     }
1964 
1965     function log(
1966         uint256 p0,
1967         bool p1,
1968         bool p2
1969     ) internal view {
1970         _sendLogPayload(
1971             abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2)
1972         );
1973     }
1974 
1975     function log(
1976         uint256 p0,
1977         bool p1,
1978         address p2
1979     ) internal view {
1980         _sendLogPayload(
1981             abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2)
1982         );
1983     }
1984 
1985     function log(
1986         uint256 p0,
1987         address p1,
1988         uint256 p2
1989     ) internal view {
1990         _sendLogPayload(
1991             abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2)
1992         );
1993     }
1994 
1995     function log(
1996         uint256 p0,
1997         address p1,
1998         string memory p2
1999     ) internal view {
2000         _sendLogPayload(
2001             abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2)
2002         );
2003     }
2004 
2005     function log(
2006         uint256 p0,
2007         address p1,
2008         bool p2
2009     ) internal view {
2010         _sendLogPayload(
2011             abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2)
2012         );
2013     }
2014 
2015     function log(
2016         uint256 p0,
2017         address p1,
2018         address p2
2019     ) internal view {
2020         _sendLogPayload(
2021             abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2)
2022         );
2023     }
2024 
2025     function log(
2026         string memory p0,
2027         uint256 p1,
2028         uint256 p2
2029     ) internal view {
2030         _sendLogPayload(
2031             abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2)
2032         );
2033     }
2034 
2035     function log(
2036         string memory p0,
2037         uint256 p1,
2038         string memory p2
2039     ) internal view {
2040         _sendLogPayload(
2041             abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2)
2042         );
2043     }
2044 
2045     function log(
2046         string memory p0,
2047         uint256 p1,
2048         bool p2
2049     ) internal view {
2050         _sendLogPayload(
2051             abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2)
2052         );
2053     }
2054 
2055     function log(
2056         string memory p0,
2057         uint256 p1,
2058         address p2
2059     ) internal view {
2060         _sendLogPayload(
2061             abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2)
2062         );
2063     }
2064 
2065     function log(
2066         string memory p0,
2067         string memory p1,
2068         uint256 p2
2069     ) internal view {
2070         _sendLogPayload(
2071             abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2)
2072         );
2073     }
2074 
2075     function log(
2076         string memory p0,
2077         string memory p1,
2078         string memory p2
2079     ) internal view {
2080         _sendLogPayload(
2081             abi.encodeWithSignature("log(string,string,string)", p0, p1, p2)
2082         );
2083     }
2084 
2085     function log(
2086         string memory p0,
2087         string memory p1,
2088         bool p2
2089     ) internal view {
2090         _sendLogPayload(
2091             abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2)
2092         );
2093     }
2094 
2095     function log(
2096         string memory p0,
2097         string memory p1,
2098         address p2
2099     ) internal view {
2100         _sendLogPayload(
2101             abi.encodeWithSignature("log(string,string,address)", p0, p1, p2)
2102         );
2103     }
2104 
2105     function log(
2106         string memory p0,
2107         bool p1,
2108         uint256 p2
2109     ) internal view {
2110         _sendLogPayload(
2111             abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2)
2112         );
2113     }
2114 
2115     function log(
2116         string memory p0,
2117         bool p1,
2118         string memory p2
2119     ) internal view {
2120         _sendLogPayload(
2121             abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2)
2122         );
2123     }
2124 
2125     function log(
2126         string memory p0,
2127         bool p1,
2128         bool p2
2129     ) internal view {
2130         _sendLogPayload(
2131             abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2)
2132         );
2133     }
2134 
2135     function log(
2136         string memory p0,
2137         bool p1,
2138         address p2
2139     ) internal view {
2140         _sendLogPayload(
2141             abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2)
2142         );
2143     }
2144 
2145     function log(
2146         string memory p0,
2147         address p1,
2148         uint256 p2
2149     ) internal view {
2150         _sendLogPayload(
2151             abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2)
2152         );
2153     }
2154 
2155     function log(
2156         string memory p0,
2157         address p1,
2158         string memory p2
2159     ) internal view {
2160         _sendLogPayload(
2161             abi.encodeWithSignature("log(string,address,string)", p0, p1, p2)
2162         );
2163     }
2164 
2165     function log(
2166         string memory p0,
2167         address p1,
2168         bool p2
2169     ) internal view {
2170         _sendLogPayload(
2171             abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2)
2172         );
2173     }
2174 
2175     function log(
2176         string memory p0,
2177         address p1,
2178         address p2
2179     ) internal view {
2180         _sendLogPayload(
2181             abi.encodeWithSignature("log(string,address,address)", p0, p1, p2)
2182         );
2183     }
2184 
2185     function log(
2186         bool p0,
2187         uint256 p1,
2188         uint256 p2
2189     ) internal view {
2190         _sendLogPayload(
2191             abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2)
2192         );
2193     }
2194 
2195     function log(
2196         bool p0,
2197         uint256 p1,
2198         string memory p2
2199     ) internal view {
2200         _sendLogPayload(
2201             abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2)
2202         );
2203     }
2204 
2205     function log(
2206         bool p0,
2207         uint256 p1,
2208         bool p2
2209     ) internal view {
2210         _sendLogPayload(
2211             abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2)
2212         );
2213     }
2214 
2215     function log(
2216         bool p0,
2217         uint256 p1,
2218         address p2
2219     ) internal view {
2220         _sendLogPayload(
2221             abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2)
2222         );
2223     }
2224 
2225     function log(
2226         bool p0,
2227         string memory p1,
2228         uint256 p2
2229     ) internal view {
2230         _sendLogPayload(
2231             abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2)
2232         );
2233     }
2234 
2235     function log(
2236         bool p0,
2237         string memory p1,
2238         string memory p2
2239     ) internal view {
2240         _sendLogPayload(
2241             abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2)
2242         );
2243     }
2244 
2245     function log(
2246         bool p0,
2247         string memory p1,
2248         bool p2
2249     ) internal view {
2250         _sendLogPayload(
2251             abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2)
2252         );
2253     }
2254 
2255     function log(
2256         bool p0,
2257         string memory p1,
2258         address p2
2259     ) internal view {
2260         _sendLogPayload(
2261             abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2)
2262         );
2263     }
2264 
2265     function log(
2266         bool p0,
2267         bool p1,
2268         uint256 p2
2269     ) internal view {
2270         _sendLogPayload(
2271             abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2)
2272         );
2273     }
2274 
2275     function log(
2276         bool p0,
2277         bool p1,
2278         string memory p2
2279     ) internal view {
2280         _sendLogPayload(
2281             abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2)
2282         );
2283     }
2284 
2285     function log(
2286         bool p0,
2287         bool p1,
2288         bool p2
2289     ) internal view {
2290         _sendLogPayload(
2291             abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2)
2292         );
2293     }
2294 
2295     function log(
2296         bool p0,
2297         bool p1,
2298         address p2
2299     ) internal view {
2300         _sendLogPayload(
2301             abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2)
2302         );
2303     }
2304 
2305     function log(
2306         bool p0,
2307         address p1,
2308         uint256 p2
2309     ) internal view {
2310         _sendLogPayload(
2311             abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2)
2312         );
2313     }
2314 
2315     function log(
2316         bool p0,
2317         address p1,
2318         string memory p2
2319     ) internal view {
2320         _sendLogPayload(
2321             abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2)
2322         );
2323     }
2324 
2325     function log(
2326         bool p0,
2327         address p1,
2328         bool p2
2329     ) internal view {
2330         _sendLogPayload(
2331             abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2)
2332         );
2333     }
2334 
2335     function log(
2336         bool p0,
2337         address p1,
2338         address p2
2339     ) internal view {
2340         _sendLogPayload(
2341             abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2)
2342         );
2343     }
2344 
2345     function log(
2346         address p0,
2347         uint256 p1,
2348         uint256 p2
2349     ) internal view {
2350         _sendLogPayload(
2351             abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2)
2352         );
2353     }
2354 
2355     function log(
2356         address p0,
2357         uint256 p1,
2358         string memory p2
2359     ) internal view {
2360         _sendLogPayload(
2361             abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2)
2362         );
2363     }
2364 
2365     function log(
2366         address p0,
2367         uint256 p1,
2368         bool p2
2369     ) internal view {
2370         _sendLogPayload(
2371             abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2)
2372         );
2373     }
2374 
2375     function log(
2376         address p0,
2377         uint256 p1,
2378         address p2
2379     ) internal view {
2380         _sendLogPayload(
2381             abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2)
2382         );
2383     }
2384 
2385     function log(
2386         address p0,
2387         string memory p1,
2388         uint256 p2
2389     ) internal view {
2390         _sendLogPayload(
2391             abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2)
2392         );
2393     }
2394 
2395     function log(
2396         address p0,
2397         string memory p1,
2398         string memory p2
2399     ) internal view {
2400         _sendLogPayload(
2401             abi.encodeWithSignature("log(address,string,string)", p0, p1, p2)
2402         );
2403     }
2404 
2405     function log(
2406         address p0,
2407         string memory p1,
2408         bool p2
2409     ) internal view {
2410         _sendLogPayload(
2411             abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2)
2412         );
2413     }
2414 
2415     function log(
2416         address p0,
2417         string memory p1,
2418         address p2
2419     ) internal view {
2420         _sendLogPayload(
2421             abi.encodeWithSignature("log(address,string,address)", p0, p1, p2)
2422         );
2423     }
2424 
2425     function log(
2426         address p0,
2427         bool p1,
2428         uint256 p2
2429     ) internal view {
2430         _sendLogPayload(
2431             abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2)
2432         );
2433     }
2434 
2435     function log(
2436         address p0,
2437         bool p1,
2438         string memory p2
2439     ) internal view {
2440         _sendLogPayload(
2441             abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2)
2442         );
2443     }
2444 
2445     function log(
2446         address p0,
2447         bool p1,
2448         bool p2
2449     ) internal view {
2450         _sendLogPayload(
2451             abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2)
2452         );
2453     }
2454 
2455     function log(
2456         address p0,
2457         bool p1,
2458         address p2
2459     ) internal view {
2460         _sendLogPayload(
2461             abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2)
2462         );
2463     }
2464 
2465     function log(
2466         address p0,
2467         address p1,
2468         uint256 p2
2469     ) internal view {
2470         _sendLogPayload(
2471             abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2)
2472         );
2473     }
2474 
2475     function log(
2476         address p0,
2477         address p1,
2478         string memory p2
2479     ) internal view {
2480         _sendLogPayload(
2481             abi.encodeWithSignature("log(address,address,string)", p0, p1, p2)
2482         );
2483     }
2484 
2485     function log(
2486         address p0,
2487         address p1,
2488         bool p2
2489     ) internal view {
2490         _sendLogPayload(
2491             abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2)
2492         );
2493     }
2494 
2495     function log(
2496         address p0,
2497         address p1,
2498         address p2
2499     ) internal view {
2500         _sendLogPayload(
2501             abi.encodeWithSignature("log(address,address,address)", p0, p1, p2)
2502         );
2503     }
2504 
2505     function log(
2506         uint256 p0,
2507         uint256 p1,
2508         uint256 p2,
2509         uint256 p3
2510     ) internal view {
2511         _sendLogPayload(
2512             abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3)
2513         );
2514     }
2515 
2516     function log(
2517         uint256 p0,
2518         uint256 p1,
2519         uint256 p2,
2520         string memory p3
2521     ) internal view {
2522         _sendLogPayload(
2523             abi.encodeWithSignature(
2524                 "log(uint,uint,uint,string)",
2525                 p0,
2526                 p1,
2527                 p2,
2528                 p3
2529             )
2530         );
2531     }
2532 
2533     function log(
2534         uint256 p0,
2535         uint256 p1,
2536         uint256 p2,
2537         bool p3
2538     ) internal view {
2539         _sendLogPayload(
2540             abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3)
2541         );
2542     }
2543 
2544     function log(
2545         uint256 p0,
2546         uint256 p1,
2547         uint256 p2,
2548         address p3
2549     ) internal view {
2550         _sendLogPayload(
2551             abi.encodeWithSignature(
2552                 "log(uint,uint,uint,address)",
2553                 p0,
2554                 p1,
2555                 p2,
2556                 p3
2557             )
2558         );
2559     }
2560 
2561     function log(
2562         uint256 p0,
2563         uint256 p1,
2564         string memory p2,
2565         uint256 p3
2566     ) internal view {
2567         _sendLogPayload(
2568             abi.encodeWithSignature(
2569                 "log(uint,uint,string,uint)",
2570                 p0,
2571                 p1,
2572                 p2,
2573                 p3
2574             )
2575         );
2576     }
2577 
2578     function log(
2579         uint256 p0,
2580         uint256 p1,
2581         string memory p2,
2582         string memory p3
2583     ) internal view {
2584         _sendLogPayload(
2585             abi.encodeWithSignature(
2586                 "log(uint,uint,string,string)",
2587                 p0,
2588                 p1,
2589                 p2,
2590                 p3
2591             )
2592         );
2593     }
2594 
2595     function log(
2596         uint256 p0,
2597         uint256 p1,
2598         string memory p2,
2599         bool p3
2600     ) internal view {
2601         _sendLogPayload(
2602             abi.encodeWithSignature(
2603                 "log(uint,uint,string,bool)",
2604                 p0,
2605                 p1,
2606                 p2,
2607                 p3
2608             )
2609         );
2610     }
2611 
2612     function log(
2613         uint256 p0,
2614         uint256 p1,
2615         string memory p2,
2616         address p3
2617     ) internal view {
2618         _sendLogPayload(
2619             abi.encodeWithSignature(
2620                 "log(uint,uint,string,address)",
2621                 p0,
2622                 p1,
2623                 p2,
2624                 p3
2625             )
2626         );
2627     }
2628 
2629     function log(
2630         uint256 p0,
2631         uint256 p1,
2632         bool p2,
2633         uint256 p3
2634     ) internal view {
2635         _sendLogPayload(
2636             abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3)
2637         );
2638     }
2639 
2640     function log(
2641         uint256 p0,
2642         uint256 p1,
2643         bool p2,
2644         string memory p3
2645     ) internal view {
2646         _sendLogPayload(
2647             abi.encodeWithSignature(
2648                 "log(uint,uint,bool,string)",
2649                 p0,
2650                 p1,
2651                 p2,
2652                 p3
2653             )
2654         );
2655     }
2656 
2657     function log(
2658         uint256 p0,
2659         uint256 p1,
2660         bool p2,
2661         bool p3
2662     ) internal view {
2663         _sendLogPayload(
2664             abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3)
2665         );
2666     }
2667 
2668     function log(
2669         uint256 p0,
2670         uint256 p1,
2671         bool p2,
2672         address p3
2673     ) internal view {
2674         _sendLogPayload(
2675             abi.encodeWithSignature(
2676                 "log(uint,uint,bool,address)",
2677                 p0,
2678                 p1,
2679                 p2,
2680                 p3
2681             )
2682         );
2683     }
2684 
2685     function log(
2686         uint256 p0,
2687         uint256 p1,
2688         address p2,
2689         uint256 p3
2690     ) internal view {
2691         _sendLogPayload(
2692             abi.encodeWithSignature(
2693                 "log(uint,uint,address,uint)",
2694                 p0,
2695                 p1,
2696                 p2,
2697                 p3
2698             )
2699         );
2700     }
2701 
2702     function log(
2703         uint256 p0,
2704         uint256 p1,
2705         address p2,
2706         string memory p3
2707     ) internal view {
2708         _sendLogPayload(
2709             abi.encodeWithSignature(
2710                 "log(uint,uint,address,string)",
2711                 p0,
2712                 p1,
2713                 p2,
2714                 p3
2715             )
2716         );
2717     }
2718 
2719     function log(
2720         uint256 p0,
2721         uint256 p1,
2722         address p2,
2723         bool p3
2724     ) internal view {
2725         _sendLogPayload(
2726             abi.encodeWithSignature(
2727                 "log(uint,uint,address,bool)",
2728                 p0,
2729                 p1,
2730                 p2,
2731                 p3
2732             )
2733         );
2734     }
2735 
2736     function log(
2737         uint256 p0,
2738         uint256 p1,
2739         address p2,
2740         address p3
2741     ) internal view {
2742         _sendLogPayload(
2743             abi.encodeWithSignature(
2744                 "log(uint,uint,address,address)",
2745                 p0,
2746                 p1,
2747                 p2,
2748                 p3
2749             )
2750         );
2751     }
2752 
2753     function log(
2754         uint256 p0,
2755         string memory p1,
2756         uint256 p2,
2757         uint256 p3
2758     ) internal view {
2759         _sendLogPayload(
2760             abi.encodeWithSignature(
2761                 "log(uint,string,uint,uint)",
2762                 p0,
2763                 p1,
2764                 p2,
2765                 p3
2766             )
2767         );
2768     }
2769 
2770     function log(
2771         uint256 p0,
2772         string memory p1,
2773         uint256 p2,
2774         string memory p3
2775     ) internal view {
2776         _sendLogPayload(
2777             abi.encodeWithSignature(
2778                 "log(uint,string,uint,string)",
2779                 p0,
2780                 p1,
2781                 p2,
2782                 p3
2783             )
2784         );
2785     }
2786 
2787     function log(
2788         uint256 p0,
2789         string memory p1,
2790         uint256 p2,
2791         bool p3
2792     ) internal view {
2793         _sendLogPayload(
2794             abi.encodeWithSignature(
2795                 "log(uint,string,uint,bool)",
2796                 p0,
2797                 p1,
2798                 p2,
2799                 p3
2800             )
2801         );
2802     }
2803 
2804     function log(
2805         uint256 p0,
2806         string memory p1,
2807         uint256 p2,
2808         address p3
2809     ) internal view {
2810         _sendLogPayload(
2811             abi.encodeWithSignature(
2812                 "log(uint,string,uint,address)",
2813                 p0,
2814                 p1,
2815                 p2,
2816                 p3
2817             )
2818         );
2819     }
2820 
2821     function log(
2822         uint256 p0,
2823         string memory p1,
2824         string memory p2,
2825         uint256 p3
2826     ) internal view {
2827         _sendLogPayload(
2828             abi.encodeWithSignature(
2829                 "log(uint,string,string,uint)",
2830                 p0,
2831                 p1,
2832                 p2,
2833                 p3
2834             )
2835         );
2836     }
2837 
2838     function log(
2839         uint256 p0,
2840         string memory p1,
2841         string memory p2,
2842         string memory p3
2843     ) internal view {
2844         _sendLogPayload(
2845             abi.encodeWithSignature(
2846                 "log(uint,string,string,string)",
2847                 p0,
2848                 p1,
2849                 p2,
2850                 p3
2851             )
2852         );
2853     }
2854 
2855     function log(
2856         uint256 p0,
2857         string memory p1,
2858         string memory p2,
2859         bool p3
2860     ) internal view {
2861         _sendLogPayload(
2862             abi.encodeWithSignature(
2863                 "log(uint,string,string,bool)",
2864                 p0,
2865                 p1,
2866                 p2,
2867                 p3
2868             )
2869         );
2870     }
2871 
2872     function log(
2873         uint256 p0,
2874         string memory p1,
2875         string memory p2,
2876         address p3
2877     ) internal view {
2878         _sendLogPayload(
2879             abi.encodeWithSignature(
2880                 "log(uint,string,string,address)",
2881                 p0,
2882                 p1,
2883                 p2,
2884                 p3
2885             )
2886         );
2887     }
2888 
2889     function log(
2890         uint256 p0,
2891         string memory p1,
2892         bool p2,
2893         uint256 p3
2894     ) internal view {
2895         _sendLogPayload(
2896             abi.encodeWithSignature(
2897                 "log(uint,string,bool,uint)",
2898                 p0,
2899                 p1,
2900                 p2,
2901                 p3
2902             )
2903         );
2904     }
2905 
2906     function log(
2907         uint256 p0,
2908         string memory p1,
2909         bool p2,
2910         string memory p3
2911     ) internal view {
2912         _sendLogPayload(
2913             abi.encodeWithSignature(
2914                 "log(uint,string,bool,string)",
2915                 p0,
2916                 p1,
2917                 p2,
2918                 p3
2919             )
2920         );
2921     }
2922 
2923     function log(
2924         uint256 p0,
2925         string memory p1,
2926         bool p2,
2927         bool p3
2928     ) internal view {
2929         _sendLogPayload(
2930             abi.encodeWithSignature(
2931                 "log(uint,string,bool,bool)",
2932                 p0,
2933                 p1,
2934                 p2,
2935                 p3
2936             )
2937         );
2938     }
2939 
2940     function log(
2941         uint256 p0,
2942         string memory p1,
2943         bool p2,
2944         address p3
2945     ) internal view {
2946         _sendLogPayload(
2947             abi.encodeWithSignature(
2948                 "log(uint,string,bool,address)",
2949                 p0,
2950                 p1,
2951                 p2,
2952                 p3
2953             )
2954         );
2955     }
2956 
2957     function log(
2958         uint256 p0,
2959         string memory p1,
2960         address p2,
2961         uint256 p3
2962     ) internal view {
2963         _sendLogPayload(
2964             abi.encodeWithSignature(
2965                 "log(uint,string,address,uint)",
2966                 p0,
2967                 p1,
2968                 p2,
2969                 p3
2970             )
2971         );
2972     }
2973 
2974     function log(
2975         uint256 p0,
2976         string memory p1,
2977         address p2,
2978         string memory p3
2979     ) internal view {
2980         _sendLogPayload(
2981             abi.encodeWithSignature(
2982                 "log(uint,string,address,string)",
2983                 p0,
2984                 p1,
2985                 p2,
2986                 p3
2987             )
2988         );
2989     }
2990 
2991     function log(
2992         uint256 p0,
2993         string memory p1,
2994         address p2,
2995         bool p3
2996     ) internal view {
2997         _sendLogPayload(
2998             abi.encodeWithSignature(
2999                 "log(uint,string,address,bool)",
3000                 p0,
3001                 p1,
3002                 p2,
3003                 p3
3004             )
3005         );
3006     }
3007 
3008     function log(
3009         uint256 p0,
3010         string memory p1,
3011         address p2,
3012         address p3
3013     ) internal view {
3014         _sendLogPayload(
3015             abi.encodeWithSignature(
3016                 "log(uint,string,address,address)",
3017                 p0,
3018                 p1,
3019                 p2,
3020                 p3
3021             )
3022         );
3023     }
3024 
3025     function log(
3026         uint256 p0,
3027         bool p1,
3028         uint256 p2,
3029         uint256 p3
3030     ) internal view {
3031         _sendLogPayload(
3032             abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3)
3033         );
3034     }
3035 
3036     function log(
3037         uint256 p0,
3038         bool p1,
3039         uint256 p2,
3040         string memory p3
3041     ) internal view {
3042         _sendLogPayload(
3043             abi.encodeWithSignature(
3044                 "log(uint,bool,uint,string)",
3045                 p0,
3046                 p1,
3047                 p2,
3048                 p3
3049             )
3050         );
3051     }
3052 
3053     function log(
3054         uint256 p0,
3055         bool p1,
3056         uint256 p2,
3057         bool p3
3058     ) internal view {
3059         _sendLogPayload(
3060             abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3)
3061         );
3062     }
3063 
3064     function log(
3065         uint256 p0,
3066         bool p1,
3067         uint256 p2,
3068         address p3
3069     ) internal view {
3070         _sendLogPayload(
3071             abi.encodeWithSignature(
3072                 "log(uint,bool,uint,address)",
3073                 p0,
3074                 p1,
3075                 p2,
3076                 p3
3077             )
3078         );
3079     }
3080 
3081     function log(
3082         uint256 p0,
3083         bool p1,
3084         string memory p2,
3085         uint256 p3
3086     ) internal view {
3087         _sendLogPayload(
3088             abi.encodeWithSignature(
3089                 "log(uint,bool,string,uint)",
3090                 p0,
3091                 p1,
3092                 p2,
3093                 p3
3094             )
3095         );
3096     }
3097 
3098     function log(
3099         uint256 p0,
3100         bool p1,
3101         string memory p2,
3102         string memory p3
3103     ) internal view {
3104         _sendLogPayload(
3105             abi.encodeWithSignature(
3106                 "log(uint,bool,string,string)",
3107                 p0,
3108                 p1,
3109                 p2,
3110                 p3
3111             )
3112         );
3113     }
3114 
3115     function log(
3116         uint256 p0,
3117         bool p1,
3118         string memory p2,
3119         bool p3
3120     ) internal view {
3121         _sendLogPayload(
3122             abi.encodeWithSignature(
3123                 "log(uint,bool,string,bool)",
3124                 p0,
3125                 p1,
3126                 p2,
3127                 p3
3128             )
3129         );
3130     }
3131 
3132     function log(
3133         uint256 p0,
3134         bool p1,
3135         string memory p2,
3136         address p3
3137     ) internal view {
3138         _sendLogPayload(
3139             abi.encodeWithSignature(
3140                 "log(uint,bool,string,address)",
3141                 p0,
3142                 p1,
3143                 p2,
3144                 p3
3145             )
3146         );
3147     }
3148 
3149     function log(
3150         uint256 p0,
3151         bool p1,
3152         bool p2,
3153         uint256 p3
3154     ) internal view {
3155         _sendLogPayload(
3156             abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3)
3157         );
3158     }
3159 
3160     function log(
3161         uint256 p0,
3162         bool p1,
3163         bool p2,
3164         string memory p3
3165     ) internal view {
3166         _sendLogPayload(
3167             abi.encodeWithSignature(
3168                 "log(uint,bool,bool,string)",
3169                 p0,
3170                 p1,
3171                 p2,
3172                 p3
3173             )
3174         );
3175     }
3176 
3177     function log(
3178         uint256 p0,
3179         bool p1,
3180         bool p2,
3181         bool p3
3182     ) internal view {
3183         _sendLogPayload(
3184             abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3)
3185         );
3186     }
3187 
3188     function log(
3189         uint256 p0,
3190         bool p1,
3191         bool p2,
3192         address p3
3193     ) internal view {
3194         _sendLogPayload(
3195             abi.encodeWithSignature(
3196                 "log(uint,bool,bool,address)",
3197                 p0,
3198                 p1,
3199                 p2,
3200                 p3
3201             )
3202         );
3203     }
3204 
3205     function log(
3206         uint256 p0,
3207         bool p1,
3208         address p2,
3209         uint256 p3
3210     ) internal view {
3211         _sendLogPayload(
3212             abi.encodeWithSignature(
3213                 "log(uint,bool,address,uint)",
3214                 p0,
3215                 p1,
3216                 p2,
3217                 p3
3218             )
3219         );
3220     }
3221 
3222     function log(
3223         uint256 p0,
3224         bool p1,
3225         address p2,
3226         string memory p3
3227     ) internal view {
3228         _sendLogPayload(
3229             abi.encodeWithSignature(
3230                 "log(uint,bool,address,string)",
3231                 p0,
3232                 p1,
3233                 p2,
3234                 p3
3235             )
3236         );
3237     }
3238 
3239     function log(
3240         uint256 p0,
3241         bool p1,
3242         address p2,
3243         bool p3
3244     ) internal view {
3245         _sendLogPayload(
3246             abi.encodeWithSignature(
3247                 "log(uint,bool,address,bool)",
3248                 p0,
3249                 p1,
3250                 p2,
3251                 p3
3252             )
3253         );
3254     }
3255 
3256     function log(
3257         uint256 p0,
3258         bool p1,
3259         address p2,
3260         address p3
3261     ) internal view {
3262         _sendLogPayload(
3263             abi.encodeWithSignature(
3264                 "log(uint,bool,address,address)",
3265                 p0,
3266                 p1,
3267                 p2,
3268                 p3
3269             )
3270         );
3271     }
3272 
3273     function log(
3274         uint256 p0,
3275         address p1,
3276         uint256 p2,
3277         uint256 p3
3278     ) internal view {
3279         _sendLogPayload(
3280             abi.encodeWithSignature(
3281                 "log(uint,address,uint,uint)",
3282                 p0,
3283                 p1,
3284                 p2,
3285                 p3
3286             )
3287         );
3288     }
3289 
3290     function log(
3291         uint256 p0,
3292         address p1,
3293         uint256 p2,
3294         string memory p3
3295     ) internal view {
3296         _sendLogPayload(
3297             abi.encodeWithSignature(
3298                 "log(uint,address,uint,string)",
3299                 p0,
3300                 p1,
3301                 p2,
3302                 p3
3303             )
3304         );
3305     }
3306 
3307     function log(
3308         uint256 p0,
3309         address p1,
3310         uint256 p2,
3311         bool p3
3312     ) internal view {
3313         _sendLogPayload(
3314             abi.encodeWithSignature(
3315                 "log(uint,address,uint,bool)",
3316                 p0,
3317                 p1,
3318                 p2,
3319                 p3
3320             )
3321         );
3322     }
3323 
3324     function log(
3325         uint256 p0,
3326         address p1,
3327         uint256 p2,
3328         address p3
3329     ) internal view {
3330         _sendLogPayload(
3331             abi.encodeWithSignature(
3332                 "log(uint,address,uint,address)",
3333                 p0,
3334                 p1,
3335                 p2,
3336                 p3
3337             )
3338         );
3339     }
3340 
3341     function log(
3342         uint256 p0,
3343         address p1,
3344         string memory p2,
3345         uint256 p3
3346     ) internal view {
3347         _sendLogPayload(
3348             abi.encodeWithSignature(
3349                 "log(uint,address,string,uint)",
3350                 p0,
3351                 p1,
3352                 p2,
3353                 p3
3354             )
3355         );
3356     }
3357 
3358     function log(
3359         uint256 p0,
3360         address p1,
3361         string memory p2,
3362         string memory p3
3363     ) internal view {
3364         _sendLogPayload(
3365             abi.encodeWithSignature(
3366                 "log(uint,address,string,string)",
3367                 p0,
3368                 p1,
3369                 p2,
3370                 p3
3371             )
3372         );
3373     }
3374 
3375     function log(
3376         uint256 p0,
3377         address p1,
3378         string memory p2,
3379         bool p3
3380     ) internal view {
3381         _sendLogPayload(
3382             abi.encodeWithSignature(
3383                 "log(uint,address,string,bool)",
3384                 p0,
3385                 p1,
3386                 p2,
3387                 p3
3388             )
3389         );
3390     }
3391 
3392     function log(
3393         uint256 p0,
3394         address p1,
3395         string memory p2,
3396         address p3
3397     ) internal view {
3398         _sendLogPayload(
3399             abi.encodeWithSignature(
3400                 "log(uint,address,string,address)",
3401                 p0,
3402                 p1,
3403                 p2,
3404                 p3
3405             )
3406         );
3407     }
3408 
3409     function log(
3410         uint256 p0,
3411         address p1,
3412         bool p2,
3413         uint256 p3
3414     ) internal view {
3415         _sendLogPayload(
3416             abi.encodeWithSignature(
3417                 "log(uint,address,bool,uint)",
3418                 p0,
3419                 p1,
3420                 p2,
3421                 p3
3422             )
3423         );
3424     }
3425 
3426     function log(
3427         uint256 p0,
3428         address p1,
3429         bool p2,
3430         string memory p3
3431     ) internal view {
3432         _sendLogPayload(
3433             abi.encodeWithSignature(
3434                 "log(uint,address,bool,string)",
3435                 p0,
3436                 p1,
3437                 p2,
3438                 p3
3439             )
3440         );
3441     }
3442 
3443     function log(
3444         uint256 p0,
3445         address p1,
3446         bool p2,
3447         bool p3
3448     ) internal view {
3449         _sendLogPayload(
3450             abi.encodeWithSignature(
3451                 "log(uint,address,bool,bool)",
3452                 p0,
3453                 p1,
3454                 p2,
3455                 p3
3456             )
3457         );
3458     }
3459 
3460     function log(
3461         uint256 p0,
3462         address p1,
3463         bool p2,
3464         address p3
3465     ) internal view {
3466         _sendLogPayload(
3467             abi.encodeWithSignature(
3468                 "log(uint,address,bool,address)",
3469                 p0,
3470                 p1,
3471                 p2,
3472                 p3
3473             )
3474         );
3475     }
3476 
3477     function log(
3478         uint256 p0,
3479         address p1,
3480         address p2,
3481         uint256 p3
3482     ) internal view {
3483         _sendLogPayload(
3484             abi.encodeWithSignature(
3485                 "log(uint,address,address,uint)",
3486                 p0,
3487                 p1,
3488                 p2,
3489                 p3
3490             )
3491         );
3492     }
3493 
3494     function log(
3495         uint256 p0,
3496         address p1,
3497         address p2,
3498         string memory p3
3499     ) internal view {
3500         _sendLogPayload(
3501             abi.encodeWithSignature(
3502                 "log(uint,address,address,string)",
3503                 p0,
3504                 p1,
3505                 p2,
3506                 p3
3507             )
3508         );
3509     }
3510 
3511     function log(
3512         uint256 p0,
3513         address p1,
3514         address p2,
3515         bool p3
3516     ) internal view {
3517         _sendLogPayload(
3518             abi.encodeWithSignature(
3519                 "log(uint,address,address,bool)",
3520                 p0,
3521                 p1,
3522                 p2,
3523                 p3
3524             )
3525         );
3526     }
3527 
3528     function log(
3529         uint256 p0,
3530         address p1,
3531         address p2,
3532         address p3
3533     ) internal view {
3534         _sendLogPayload(
3535             abi.encodeWithSignature(
3536                 "log(uint,address,address,address)",
3537                 p0,
3538                 p1,
3539                 p2,
3540                 p3
3541             )
3542         );
3543     }
3544 
3545     function log(
3546         string memory p0,
3547         uint256 p1,
3548         uint256 p2,
3549         uint256 p3
3550     ) internal view {
3551         _sendLogPayload(
3552             abi.encodeWithSignature(
3553                 "log(string,uint,uint,uint)",
3554                 p0,
3555                 p1,
3556                 p2,
3557                 p3
3558             )
3559         );
3560     }
3561 
3562     function log(
3563         string memory p0,
3564         uint256 p1,
3565         uint256 p2,
3566         string memory p3
3567     ) internal view {
3568         _sendLogPayload(
3569             abi.encodeWithSignature(
3570                 "log(string,uint,uint,string)",
3571                 p0,
3572                 p1,
3573                 p2,
3574                 p3
3575             )
3576         );
3577     }
3578 
3579     function log(
3580         string memory p0,
3581         uint256 p1,
3582         uint256 p2,
3583         bool p3
3584     ) internal view {
3585         _sendLogPayload(
3586             abi.encodeWithSignature(
3587                 "log(string,uint,uint,bool)",
3588                 p0,
3589                 p1,
3590                 p2,
3591                 p3
3592             )
3593         );
3594     }
3595 
3596     function log(
3597         string memory p0,
3598         uint256 p1,
3599         uint256 p2,
3600         address p3
3601     ) internal view {
3602         _sendLogPayload(
3603             abi.encodeWithSignature(
3604                 "log(string,uint,uint,address)",
3605                 p0,
3606                 p1,
3607                 p2,
3608                 p3
3609             )
3610         );
3611     }
3612 
3613     function log(
3614         string memory p0,
3615         uint256 p1,
3616         string memory p2,
3617         uint256 p3
3618     ) internal view {
3619         _sendLogPayload(
3620             abi.encodeWithSignature(
3621                 "log(string,uint,string,uint)",
3622                 p0,
3623                 p1,
3624                 p2,
3625                 p3
3626             )
3627         );
3628     }
3629 
3630     function log(
3631         string memory p0,
3632         uint256 p1,
3633         string memory p2,
3634         string memory p3
3635     ) internal view {
3636         _sendLogPayload(
3637             abi.encodeWithSignature(
3638                 "log(string,uint,string,string)",
3639                 p0,
3640                 p1,
3641                 p2,
3642                 p3
3643             )
3644         );
3645     }
3646 
3647     function log(
3648         string memory p0,
3649         uint256 p1,
3650         string memory p2,
3651         bool p3
3652     ) internal view {
3653         _sendLogPayload(
3654             abi.encodeWithSignature(
3655                 "log(string,uint,string,bool)",
3656                 p0,
3657                 p1,
3658                 p2,
3659                 p3
3660             )
3661         );
3662     }
3663 
3664     function log(
3665         string memory p0,
3666         uint256 p1,
3667         string memory p2,
3668         address p3
3669     ) internal view {
3670         _sendLogPayload(
3671             abi.encodeWithSignature(
3672                 "log(string,uint,string,address)",
3673                 p0,
3674                 p1,
3675                 p2,
3676                 p3
3677             )
3678         );
3679     }
3680 
3681     function log(
3682         string memory p0,
3683         uint256 p1,
3684         bool p2,
3685         uint256 p3
3686     ) internal view {
3687         _sendLogPayload(
3688             abi.encodeWithSignature(
3689                 "log(string,uint,bool,uint)",
3690                 p0,
3691                 p1,
3692                 p2,
3693                 p3
3694             )
3695         );
3696     }
3697 
3698     function log(
3699         string memory p0,
3700         uint256 p1,
3701         bool p2,
3702         string memory p3
3703     ) internal view {
3704         _sendLogPayload(
3705             abi.encodeWithSignature(
3706                 "log(string,uint,bool,string)",
3707                 p0,
3708                 p1,
3709                 p2,
3710                 p3
3711             )
3712         );
3713     }
3714 
3715     function log(
3716         string memory p0,
3717         uint256 p1,
3718         bool p2,
3719         bool p3
3720     ) internal view {
3721         _sendLogPayload(
3722             abi.encodeWithSignature(
3723                 "log(string,uint,bool,bool)",
3724                 p0,
3725                 p1,
3726                 p2,
3727                 p3
3728             )
3729         );
3730     }
3731 
3732     function log(
3733         string memory p0,
3734         uint256 p1,
3735         bool p2,
3736         address p3
3737     ) internal view {
3738         _sendLogPayload(
3739             abi.encodeWithSignature(
3740                 "log(string,uint,bool,address)",
3741                 p0,
3742                 p1,
3743                 p2,
3744                 p3
3745             )
3746         );
3747     }
3748 
3749     function log(
3750         string memory p0,
3751         uint256 p1,
3752         address p2,
3753         uint256 p3
3754     ) internal view {
3755         _sendLogPayload(
3756             abi.encodeWithSignature(
3757                 "log(string,uint,address,uint)",
3758                 p0,
3759                 p1,
3760                 p2,
3761                 p3
3762             )
3763         );
3764     }
3765 
3766     function log(
3767         string memory p0,
3768         uint256 p1,
3769         address p2,
3770         string memory p3
3771     ) internal view {
3772         _sendLogPayload(
3773             abi.encodeWithSignature(
3774                 "log(string,uint,address,string)",
3775                 p0,
3776                 p1,
3777                 p2,
3778                 p3
3779             )
3780         );
3781     }
3782 
3783     function log(
3784         string memory p0,
3785         uint256 p1,
3786         address p2,
3787         bool p3
3788     ) internal view {
3789         _sendLogPayload(
3790             abi.encodeWithSignature(
3791                 "log(string,uint,address,bool)",
3792                 p0,
3793                 p1,
3794                 p2,
3795                 p3
3796             )
3797         );
3798     }
3799 
3800     function log(
3801         string memory p0,
3802         uint256 p1,
3803         address p2,
3804         address p3
3805     ) internal view {
3806         _sendLogPayload(
3807             abi.encodeWithSignature(
3808                 "log(string,uint,address,address)",
3809                 p0,
3810                 p1,
3811                 p2,
3812                 p3
3813             )
3814         );
3815     }
3816 
3817     function log(
3818         string memory p0,
3819         string memory p1,
3820         uint256 p2,
3821         uint256 p3
3822     ) internal view {
3823         _sendLogPayload(
3824             abi.encodeWithSignature(
3825                 "log(string,string,uint,uint)",
3826                 p0,
3827                 p1,
3828                 p2,
3829                 p3
3830             )
3831         );
3832     }
3833 
3834     function log(
3835         string memory p0,
3836         string memory p1,
3837         uint256 p2,
3838         string memory p3
3839     ) internal view {
3840         _sendLogPayload(
3841             abi.encodeWithSignature(
3842                 "log(string,string,uint,string)",
3843                 p0,
3844                 p1,
3845                 p2,
3846                 p3
3847             )
3848         );
3849     }
3850 
3851     function log(
3852         string memory p0,
3853         string memory p1,
3854         uint256 p2,
3855         bool p3
3856     ) internal view {
3857         _sendLogPayload(
3858             abi.encodeWithSignature(
3859                 "log(string,string,uint,bool)",
3860                 p0,
3861                 p1,
3862                 p2,
3863                 p3
3864             )
3865         );
3866     }
3867 
3868     function log(
3869         string memory p0,
3870         string memory p1,
3871         uint256 p2,
3872         address p3
3873     ) internal view {
3874         _sendLogPayload(
3875             abi.encodeWithSignature(
3876                 "log(string,string,uint,address)",
3877                 p0,
3878                 p1,
3879                 p2,
3880                 p3
3881             )
3882         );
3883     }
3884 
3885     function log(
3886         string memory p0,
3887         string memory p1,
3888         string memory p2,
3889         uint256 p3
3890     ) internal view {
3891         _sendLogPayload(
3892             abi.encodeWithSignature(
3893                 "log(string,string,string,uint)",
3894                 p0,
3895                 p1,
3896                 p2,
3897                 p3
3898             )
3899         );
3900     }
3901 
3902     function log(
3903         string memory p0,
3904         string memory p1,
3905         string memory p2,
3906         string memory p3
3907     ) internal view {
3908         _sendLogPayload(
3909             abi.encodeWithSignature(
3910                 "log(string,string,string,string)",
3911                 p0,
3912                 p1,
3913                 p2,
3914                 p3
3915             )
3916         );
3917     }
3918 
3919     function log(
3920         string memory p0,
3921         string memory p1,
3922         string memory p2,
3923         bool p3
3924     ) internal view {
3925         _sendLogPayload(
3926             abi.encodeWithSignature(
3927                 "log(string,string,string,bool)",
3928                 p0,
3929                 p1,
3930                 p2,
3931                 p3
3932             )
3933         );
3934     }
3935 
3936     function log(
3937         string memory p0,
3938         string memory p1,
3939         string memory p2,
3940         address p3
3941     ) internal view {
3942         _sendLogPayload(
3943             abi.encodeWithSignature(
3944                 "log(string,string,string,address)",
3945                 p0,
3946                 p1,
3947                 p2,
3948                 p3
3949             )
3950         );
3951     }
3952 
3953     function log(
3954         string memory p0,
3955         string memory p1,
3956         bool p2,
3957         uint256 p3
3958     ) internal view {
3959         _sendLogPayload(
3960             abi.encodeWithSignature(
3961                 "log(string,string,bool,uint)",
3962                 p0,
3963                 p1,
3964                 p2,
3965                 p3
3966             )
3967         );
3968     }
3969 
3970     function log(
3971         string memory p0,
3972         string memory p1,
3973         bool p2,
3974         string memory p3
3975     ) internal view {
3976         _sendLogPayload(
3977             abi.encodeWithSignature(
3978                 "log(string,string,bool,string)",
3979                 p0,
3980                 p1,
3981                 p2,
3982                 p3
3983             )
3984         );
3985     }
3986 
3987     function log(
3988         string memory p0,
3989         string memory p1,
3990         bool p2,
3991         bool p3
3992     ) internal view {
3993         _sendLogPayload(
3994             abi.encodeWithSignature(
3995                 "log(string,string,bool,bool)",
3996                 p0,
3997                 p1,
3998                 p2,
3999                 p3
4000             )
4001         );
4002     }
4003 
4004     function log(
4005         string memory p0,
4006         string memory p1,
4007         bool p2,
4008         address p3
4009     ) internal view {
4010         _sendLogPayload(
4011             abi.encodeWithSignature(
4012                 "log(string,string,bool,address)",
4013                 p0,
4014                 p1,
4015                 p2,
4016                 p3
4017             )
4018         );
4019     }
4020 
4021     function log(
4022         string memory p0,
4023         string memory p1,
4024         address p2,
4025         uint256 p3
4026     ) internal view {
4027         _sendLogPayload(
4028             abi.encodeWithSignature(
4029                 "log(string,string,address,uint)",
4030                 p0,
4031                 p1,
4032                 p2,
4033                 p3
4034             )
4035         );
4036     }
4037 
4038     function log(
4039         string memory p0,
4040         string memory p1,
4041         address p2,
4042         string memory p3
4043     ) internal view {
4044         _sendLogPayload(
4045             abi.encodeWithSignature(
4046                 "log(string,string,address,string)",
4047                 p0,
4048                 p1,
4049                 p2,
4050                 p3
4051             )
4052         );
4053     }
4054 
4055     function log(
4056         string memory p0,
4057         string memory p1,
4058         address p2,
4059         bool p3
4060     ) internal view {
4061         _sendLogPayload(
4062             abi.encodeWithSignature(
4063                 "log(string,string,address,bool)",
4064                 p0,
4065                 p1,
4066                 p2,
4067                 p3
4068             )
4069         );
4070     }
4071 
4072     function log(
4073         string memory p0,
4074         string memory p1,
4075         address p2,
4076         address p3
4077     ) internal view {
4078         _sendLogPayload(
4079             abi.encodeWithSignature(
4080                 "log(string,string,address,address)",
4081                 p0,
4082                 p1,
4083                 p2,
4084                 p3
4085             )
4086         );
4087     }
4088 
4089     function log(
4090         string memory p0,
4091         bool p1,
4092         uint256 p2,
4093         uint256 p3
4094     ) internal view {
4095         _sendLogPayload(
4096             abi.encodeWithSignature(
4097                 "log(string,bool,uint,uint)",
4098                 p0,
4099                 p1,
4100                 p2,
4101                 p3
4102             )
4103         );
4104     }
4105 
4106     function log(
4107         string memory p0,
4108         bool p1,
4109         uint256 p2,
4110         string memory p3
4111     ) internal view {
4112         _sendLogPayload(
4113             abi.encodeWithSignature(
4114                 "log(string,bool,uint,string)",
4115                 p0,
4116                 p1,
4117                 p2,
4118                 p3
4119             )
4120         );
4121     }
4122 
4123     function log(
4124         string memory p0,
4125         bool p1,
4126         uint256 p2,
4127         bool p3
4128     ) internal view {
4129         _sendLogPayload(
4130             abi.encodeWithSignature(
4131                 "log(string,bool,uint,bool)",
4132                 p0,
4133                 p1,
4134                 p2,
4135                 p3
4136             )
4137         );
4138     }
4139 
4140     function log(
4141         string memory p0,
4142         bool p1,
4143         uint256 p2,
4144         address p3
4145     ) internal view {
4146         _sendLogPayload(
4147             abi.encodeWithSignature(
4148                 "log(string,bool,uint,address)",
4149                 p0,
4150                 p1,
4151                 p2,
4152                 p3
4153             )
4154         );
4155     }
4156 
4157     function log(
4158         string memory p0,
4159         bool p1,
4160         string memory p2,
4161         uint256 p3
4162     ) internal view {
4163         _sendLogPayload(
4164             abi.encodeWithSignature(
4165                 "log(string,bool,string,uint)",
4166                 p0,
4167                 p1,
4168                 p2,
4169                 p3
4170             )
4171         );
4172     }
4173 
4174     function log(
4175         string memory p0,
4176         bool p1,
4177         string memory p2,
4178         string memory p3
4179     ) internal view {
4180         _sendLogPayload(
4181             abi.encodeWithSignature(
4182                 "log(string,bool,string,string)",
4183                 p0,
4184                 p1,
4185                 p2,
4186                 p3
4187             )
4188         );
4189     }
4190 
4191     function log(
4192         string memory p0,
4193         bool p1,
4194         string memory p2,
4195         bool p3
4196     ) internal view {
4197         _sendLogPayload(
4198             abi.encodeWithSignature(
4199                 "log(string,bool,string,bool)",
4200                 p0,
4201                 p1,
4202                 p2,
4203                 p3
4204             )
4205         );
4206     }
4207 
4208     function log(
4209         string memory p0,
4210         bool p1,
4211         string memory p2,
4212         address p3
4213     ) internal view {
4214         _sendLogPayload(
4215             abi.encodeWithSignature(
4216                 "log(string,bool,string,address)",
4217                 p0,
4218                 p1,
4219                 p2,
4220                 p3
4221             )
4222         );
4223     }
4224 
4225     function log(
4226         string memory p0,
4227         bool p1,
4228         bool p2,
4229         uint256 p3
4230     ) internal view {
4231         _sendLogPayload(
4232             abi.encodeWithSignature(
4233                 "log(string,bool,bool,uint)",
4234                 p0,
4235                 p1,
4236                 p2,
4237                 p3
4238             )
4239         );
4240     }
4241 
4242     function log(
4243         string memory p0,
4244         bool p1,
4245         bool p2,
4246         string memory p3
4247     ) internal view {
4248         _sendLogPayload(
4249             abi.encodeWithSignature(
4250                 "log(string,bool,bool,string)",
4251                 p0,
4252                 p1,
4253                 p2,
4254                 p3
4255             )
4256         );
4257     }
4258 
4259     function log(
4260         string memory p0,
4261         bool p1,
4262         bool p2,
4263         bool p3
4264     ) internal view {
4265         _sendLogPayload(
4266             abi.encodeWithSignature(
4267                 "log(string,bool,bool,bool)",
4268                 p0,
4269                 p1,
4270                 p2,
4271                 p3
4272             )
4273         );
4274     }
4275 
4276     function log(
4277         string memory p0,
4278         bool p1,
4279         bool p2,
4280         address p3
4281     ) internal view {
4282         _sendLogPayload(
4283             abi.encodeWithSignature(
4284                 "log(string,bool,bool,address)",
4285                 p0,
4286                 p1,
4287                 p2,
4288                 p3
4289             )
4290         );
4291     }
4292 
4293     function log(
4294         string memory p0,
4295         bool p1,
4296         address p2,
4297         uint256 p3
4298     ) internal view {
4299         _sendLogPayload(
4300             abi.encodeWithSignature(
4301                 "log(string,bool,address,uint)",
4302                 p0,
4303                 p1,
4304                 p2,
4305                 p3
4306             )
4307         );
4308     }
4309 
4310     function log(
4311         string memory p0,
4312         bool p1,
4313         address p2,
4314         string memory p3
4315     ) internal view {
4316         _sendLogPayload(
4317             abi.encodeWithSignature(
4318                 "log(string,bool,address,string)",
4319                 p0,
4320                 p1,
4321                 p2,
4322                 p3
4323             )
4324         );
4325     }
4326 
4327     function log(
4328         string memory p0,
4329         bool p1,
4330         address p2,
4331         bool p3
4332     ) internal view {
4333         _sendLogPayload(
4334             abi.encodeWithSignature(
4335                 "log(string,bool,address,bool)",
4336                 p0,
4337                 p1,
4338                 p2,
4339                 p3
4340             )
4341         );
4342     }
4343 
4344     function log(
4345         string memory p0,
4346         bool p1,
4347         address p2,
4348         address p3
4349     ) internal view {
4350         _sendLogPayload(
4351             abi.encodeWithSignature(
4352                 "log(string,bool,address,address)",
4353                 p0,
4354                 p1,
4355                 p2,
4356                 p3
4357             )
4358         );
4359     }
4360 
4361     function log(
4362         string memory p0,
4363         address p1,
4364         uint256 p2,
4365         uint256 p3
4366     ) internal view {
4367         _sendLogPayload(
4368             abi.encodeWithSignature(
4369                 "log(string,address,uint,uint)",
4370                 p0,
4371                 p1,
4372                 p2,
4373                 p3
4374             )
4375         );
4376     }
4377 
4378     function log(
4379         string memory p0,
4380         address p1,
4381         uint256 p2,
4382         string memory p3
4383     ) internal view {
4384         _sendLogPayload(
4385             abi.encodeWithSignature(
4386                 "log(string,address,uint,string)",
4387                 p0,
4388                 p1,
4389                 p2,
4390                 p3
4391             )
4392         );
4393     }
4394 
4395     function log(
4396         string memory p0,
4397         address p1,
4398         uint256 p2,
4399         bool p3
4400     ) internal view {
4401         _sendLogPayload(
4402             abi.encodeWithSignature(
4403                 "log(string,address,uint,bool)",
4404                 p0,
4405                 p1,
4406                 p2,
4407                 p3
4408             )
4409         );
4410     }
4411 
4412     function log(
4413         string memory p0,
4414         address p1,
4415         uint256 p2,
4416         address p3
4417     ) internal view {
4418         _sendLogPayload(
4419             abi.encodeWithSignature(
4420                 "log(string,address,uint,address)",
4421                 p0,
4422                 p1,
4423                 p2,
4424                 p3
4425             )
4426         );
4427     }
4428 
4429     function log(
4430         string memory p0,
4431         address p1,
4432         string memory p2,
4433         uint256 p3
4434     ) internal view {
4435         _sendLogPayload(
4436             abi.encodeWithSignature(
4437                 "log(string,address,string,uint)",
4438                 p0,
4439                 p1,
4440                 p2,
4441                 p3
4442             )
4443         );
4444     }
4445 
4446     function log(
4447         string memory p0,
4448         address p1,
4449         string memory p2,
4450         string memory p3
4451     ) internal view {
4452         _sendLogPayload(
4453             abi.encodeWithSignature(
4454                 "log(string,address,string,string)",
4455                 p0,
4456                 p1,
4457                 p2,
4458                 p3
4459             )
4460         );
4461     }
4462 
4463     function log(
4464         string memory p0,
4465         address p1,
4466         string memory p2,
4467         bool p3
4468     ) internal view {
4469         _sendLogPayload(
4470             abi.encodeWithSignature(
4471                 "log(string,address,string,bool)",
4472                 p0,
4473                 p1,
4474                 p2,
4475                 p3
4476             )
4477         );
4478     }
4479 
4480     function log(
4481         string memory p0,
4482         address p1,
4483         string memory p2,
4484         address p3
4485     ) internal view {
4486         _sendLogPayload(
4487             abi.encodeWithSignature(
4488                 "log(string,address,string,address)",
4489                 p0,
4490                 p1,
4491                 p2,
4492                 p3
4493             )
4494         );
4495     }
4496 
4497     function log(
4498         string memory p0,
4499         address p1,
4500         bool p2,
4501         uint256 p3
4502     ) internal view {
4503         _sendLogPayload(
4504             abi.encodeWithSignature(
4505                 "log(string,address,bool,uint)",
4506                 p0,
4507                 p1,
4508                 p2,
4509                 p3
4510             )
4511         );
4512     }
4513 
4514     function log(
4515         string memory p0,
4516         address p1,
4517         bool p2,
4518         string memory p3
4519     ) internal view {
4520         _sendLogPayload(
4521             abi.encodeWithSignature(
4522                 "log(string,address,bool,string)",
4523                 p0,
4524                 p1,
4525                 p2,
4526                 p3
4527             )
4528         );
4529     }
4530 
4531     function log(
4532         string memory p0,
4533         address p1,
4534         bool p2,
4535         bool p3
4536     ) internal view {
4537         _sendLogPayload(
4538             abi.encodeWithSignature(
4539                 "log(string,address,bool,bool)",
4540                 p0,
4541                 p1,
4542                 p2,
4543                 p3
4544             )
4545         );
4546     }
4547 
4548     function log(
4549         string memory p0,
4550         address p1,
4551         bool p2,
4552         address p3
4553     ) internal view {
4554         _sendLogPayload(
4555             abi.encodeWithSignature(
4556                 "log(string,address,bool,address)",
4557                 p0,
4558                 p1,
4559                 p2,
4560                 p3
4561             )
4562         );
4563     }
4564 
4565     function log(
4566         string memory p0,
4567         address p1,
4568         address p2,
4569         uint256 p3
4570     ) internal view {
4571         _sendLogPayload(
4572             abi.encodeWithSignature(
4573                 "log(string,address,address,uint)",
4574                 p0,
4575                 p1,
4576                 p2,
4577                 p3
4578             )
4579         );
4580     }
4581 
4582     function log(
4583         string memory p0,
4584         address p1,
4585         address p2,
4586         string memory p3
4587     ) internal view {
4588         _sendLogPayload(
4589             abi.encodeWithSignature(
4590                 "log(string,address,address,string)",
4591                 p0,
4592                 p1,
4593                 p2,
4594                 p3
4595             )
4596         );
4597     }
4598 
4599     function log(
4600         string memory p0,
4601         address p1,
4602         address p2,
4603         bool p3
4604     ) internal view {
4605         _sendLogPayload(
4606             abi.encodeWithSignature(
4607                 "log(string,address,address,bool)",
4608                 p0,
4609                 p1,
4610                 p2,
4611                 p3
4612             )
4613         );
4614     }
4615 
4616     function log(
4617         string memory p0,
4618         address p1,
4619         address p2,
4620         address p3
4621     ) internal view {
4622         _sendLogPayload(
4623             abi.encodeWithSignature(
4624                 "log(string,address,address,address)",
4625                 p0,
4626                 p1,
4627                 p2,
4628                 p3
4629             )
4630         );
4631     }
4632 
4633     function log(
4634         bool p0,
4635         uint256 p1,
4636         uint256 p2,
4637         uint256 p3
4638     ) internal view {
4639         _sendLogPayload(
4640             abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3)
4641         );
4642     }
4643 
4644     function log(
4645         bool p0,
4646         uint256 p1,
4647         uint256 p2,
4648         string memory p3
4649     ) internal view {
4650         _sendLogPayload(
4651             abi.encodeWithSignature(
4652                 "log(bool,uint,uint,string)",
4653                 p0,
4654                 p1,
4655                 p2,
4656                 p3
4657             )
4658         );
4659     }
4660 
4661     function log(
4662         bool p0,
4663         uint256 p1,
4664         uint256 p2,
4665         bool p3
4666     ) internal view {
4667         _sendLogPayload(
4668             abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3)
4669         );
4670     }
4671 
4672     function log(
4673         bool p0,
4674         uint256 p1,
4675         uint256 p2,
4676         address p3
4677     ) internal view {
4678         _sendLogPayload(
4679             abi.encodeWithSignature(
4680                 "log(bool,uint,uint,address)",
4681                 p0,
4682                 p1,
4683                 p2,
4684                 p3
4685             )
4686         );
4687     }
4688 
4689     function log(
4690         bool p0,
4691         uint256 p1,
4692         string memory p2,
4693         uint256 p3
4694     ) internal view {
4695         _sendLogPayload(
4696             abi.encodeWithSignature(
4697                 "log(bool,uint,string,uint)",
4698                 p0,
4699                 p1,
4700                 p2,
4701                 p3
4702             )
4703         );
4704     }
4705 
4706     function log(
4707         bool p0,
4708         uint256 p1,
4709         string memory p2,
4710         string memory p3
4711     ) internal view {
4712         _sendLogPayload(
4713             abi.encodeWithSignature(
4714                 "log(bool,uint,string,string)",
4715                 p0,
4716                 p1,
4717                 p2,
4718                 p3
4719             )
4720         );
4721     }
4722 
4723     function log(
4724         bool p0,
4725         uint256 p1,
4726         string memory p2,
4727         bool p3
4728     ) internal view {
4729         _sendLogPayload(
4730             abi.encodeWithSignature(
4731                 "log(bool,uint,string,bool)",
4732                 p0,
4733                 p1,
4734                 p2,
4735                 p3
4736             )
4737         );
4738     }
4739 
4740     function log(
4741         bool p0,
4742         uint256 p1,
4743         string memory p2,
4744         address p3
4745     ) internal view {
4746         _sendLogPayload(
4747             abi.encodeWithSignature(
4748                 "log(bool,uint,string,address)",
4749                 p0,
4750                 p1,
4751                 p2,
4752                 p3
4753             )
4754         );
4755     }
4756 
4757     function log(
4758         bool p0,
4759         uint256 p1,
4760         bool p2,
4761         uint256 p3
4762     ) internal view {
4763         _sendLogPayload(
4764             abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3)
4765         );
4766     }
4767 
4768     function log(
4769         bool p0,
4770         uint256 p1,
4771         bool p2,
4772         string memory p3
4773     ) internal view {
4774         _sendLogPayload(
4775             abi.encodeWithSignature(
4776                 "log(bool,uint,bool,string)",
4777                 p0,
4778                 p1,
4779                 p2,
4780                 p3
4781             )
4782         );
4783     }
4784 
4785     function log(
4786         bool p0,
4787         uint256 p1,
4788         bool p2,
4789         bool p3
4790     ) internal view {
4791         _sendLogPayload(
4792             abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3)
4793         );
4794     }
4795 
4796     function log(
4797         bool p0,
4798         uint256 p1,
4799         bool p2,
4800         address p3
4801     ) internal view {
4802         _sendLogPayload(
4803             abi.encodeWithSignature(
4804                 "log(bool,uint,bool,address)",
4805                 p0,
4806                 p1,
4807                 p2,
4808                 p3
4809             )
4810         );
4811     }
4812 
4813     function log(
4814         bool p0,
4815         uint256 p1,
4816         address p2,
4817         uint256 p3
4818     ) internal view {
4819         _sendLogPayload(
4820             abi.encodeWithSignature(
4821                 "log(bool,uint,address,uint)",
4822                 p0,
4823                 p1,
4824                 p2,
4825                 p3
4826             )
4827         );
4828     }
4829 
4830     function log(
4831         bool p0,
4832         uint256 p1,
4833         address p2,
4834         string memory p3
4835     ) internal view {
4836         _sendLogPayload(
4837             abi.encodeWithSignature(
4838                 "log(bool,uint,address,string)",
4839                 p0,
4840                 p1,
4841                 p2,
4842                 p3
4843             )
4844         );
4845     }
4846 
4847     function log(
4848         bool p0,
4849         uint256 p1,
4850         address p2,
4851         bool p3
4852     ) internal view {
4853         _sendLogPayload(
4854             abi.encodeWithSignature(
4855                 "log(bool,uint,address,bool)",
4856                 p0,
4857                 p1,
4858                 p2,
4859                 p3
4860             )
4861         );
4862     }
4863 
4864     function log(
4865         bool p0,
4866         uint256 p1,
4867         address p2,
4868         address p3
4869     ) internal view {
4870         _sendLogPayload(
4871             abi.encodeWithSignature(
4872                 "log(bool,uint,address,address)",
4873                 p0,
4874                 p1,
4875                 p2,
4876                 p3
4877             )
4878         );
4879     }
4880 
4881     function log(
4882         bool p0,
4883         string memory p1,
4884         uint256 p2,
4885         uint256 p3
4886     ) internal view {
4887         _sendLogPayload(
4888             abi.encodeWithSignature(
4889                 "log(bool,string,uint,uint)",
4890                 p0,
4891                 p1,
4892                 p2,
4893                 p3
4894             )
4895         );
4896     }
4897 
4898     function log(
4899         bool p0,
4900         string memory p1,
4901         uint256 p2,
4902         string memory p3
4903     ) internal view {
4904         _sendLogPayload(
4905             abi.encodeWithSignature(
4906                 "log(bool,string,uint,string)",
4907                 p0,
4908                 p1,
4909                 p2,
4910                 p3
4911             )
4912         );
4913     }
4914 
4915     function log(
4916         bool p0,
4917         string memory p1,
4918         uint256 p2,
4919         bool p3
4920     ) internal view {
4921         _sendLogPayload(
4922             abi.encodeWithSignature(
4923                 "log(bool,string,uint,bool)",
4924                 p0,
4925                 p1,
4926                 p2,
4927                 p3
4928             )
4929         );
4930     }
4931 
4932     function log(
4933         bool p0,
4934         string memory p1,
4935         uint256 p2,
4936         address p3
4937     ) internal view {
4938         _sendLogPayload(
4939             abi.encodeWithSignature(
4940                 "log(bool,string,uint,address)",
4941                 p0,
4942                 p1,
4943                 p2,
4944                 p3
4945             )
4946         );
4947     }
4948 
4949     function log(
4950         bool p0,
4951         string memory p1,
4952         string memory p2,
4953         uint256 p3
4954     ) internal view {
4955         _sendLogPayload(
4956             abi.encodeWithSignature(
4957                 "log(bool,string,string,uint)",
4958                 p0,
4959                 p1,
4960                 p2,
4961                 p3
4962             )
4963         );
4964     }
4965 
4966     function log(
4967         bool p0,
4968         string memory p1,
4969         string memory p2,
4970         string memory p3
4971     ) internal view {
4972         _sendLogPayload(
4973             abi.encodeWithSignature(
4974                 "log(bool,string,string,string)",
4975                 p0,
4976                 p1,
4977                 p2,
4978                 p3
4979             )
4980         );
4981     }
4982 
4983     function log(
4984         bool p0,
4985         string memory p1,
4986         string memory p2,
4987         bool p3
4988     ) internal view {
4989         _sendLogPayload(
4990             abi.encodeWithSignature(
4991                 "log(bool,string,string,bool)",
4992                 p0,
4993                 p1,
4994                 p2,
4995                 p3
4996             )
4997         );
4998     }
4999 
5000     function log(
5001         bool p0,
5002         string memory p1,
5003         string memory p2,
5004         address p3
5005     ) internal view {
5006         _sendLogPayload(
5007             abi.encodeWithSignature(
5008                 "log(bool,string,string,address)",
5009                 p0,
5010                 p1,
5011                 p2,
5012                 p3
5013             )
5014         );
5015     }
5016 
5017     function log(
5018         bool p0,
5019         string memory p1,
5020         bool p2,
5021         uint256 p3
5022     ) internal view {
5023         _sendLogPayload(
5024             abi.encodeWithSignature(
5025                 "log(bool,string,bool,uint)",
5026                 p0,
5027                 p1,
5028                 p2,
5029                 p3
5030             )
5031         );
5032     }
5033 
5034     function log(
5035         bool p0,
5036         string memory p1,
5037         bool p2,
5038         string memory p3
5039     ) internal view {
5040         _sendLogPayload(
5041             abi.encodeWithSignature(
5042                 "log(bool,string,bool,string)",
5043                 p0,
5044                 p1,
5045                 p2,
5046                 p3
5047             )
5048         );
5049     }
5050 
5051     function log(
5052         bool p0,
5053         string memory p1,
5054         bool p2,
5055         bool p3
5056     ) internal view {
5057         _sendLogPayload(
5058             abi.encodeWithSignature(
5059                 "log(bool,string,bool,bool)",
5060                 p0,
5061                 p1,
5062                 p2,
5063                 p3
5064             )
5065         );
5066     }
5067 
5068     function log(
5069         bool p0,
5070         string memory p1,
5071         bool p2,
5072         address p3
5073     ) internal view {
5074         _sendLogPayload(
5075             abi.encodeWithSignature(
5076                 "log(bool,string,bool,address)",
5077                 p0,
5078                 p1,
5079                 p2,
5080                 p3
5081             )
5082         );
5083     }
5084 
5085     function log(
5086         bool p0,
5087         string memory p1,
5088         address p2,
5089         uint256 p3
5090     ) internal view {
5091         _sendLogPayload(
5092             abi.encodeWithSignature(
5093                 "log(bool,string,address,uint)",
5094                 p0,
5095                 p1,
5096                 p2,
5097                 p3
5098             )
5099         );
5100     }
5101 
5102     function log(
5103         bool p0,
5104         string memory p1,
5105         address p2,
5106         string memory p3
5107     ) internal view {
5108         _sendLogPayload(
5109             abi.encodeWithSignature(
5110                 "log(bool,string,address,string)",
5111                 p0,
5112                 p1,
5113                 p2,
5114                 p3
5115             )
5116         );
5117     }
5118 
5119     function log(
5120         bool p0,
5121         string memory p1,
5122         address p2,
5123         bool p3
5124     ) internal view {
5125         _sendLogPayload(
5126             abi.encodeWithSignature(
5127                 "log(bool,string,address,bool)",
5128                 p0,
5129                 p1,
5130                 p2,
5131                 p3
5132             )
5133         );
5134     }
5135 
5136     function log(
5137         bool p0,
5138         string memory p1,
5139         address p2,
5140         address p3
5141     ) internal view {
5142         _sendLogPayload(
5143             abi.encodeWithSignature(
5144                 "log(bool,string,address,address)",
5145                 p0,
5146                 p1,
5147                 p2,
5148                 p3
5149             )
5150         );
5151     }
5152 
5153     function log(
5154         bool p0,
5155         bool p1,
5156         uint256 p2,
5157         uint256 p3
5158     ) internal view {
5159         _sendLogPayload(
5160             abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3)
5161         );
5162     }
5163 
5164     function log(
5165         bool p0,
5166         bool p1,
5167         uint256 p2,
5168         string memory p3
5169     ) internal view {
5170         _sendLogPayload(
5171             abi.encodeWithSignature(
5172                 "log(bool,bool,uint,string)",
5173                 p0,
5174                 p1,
5175                 p2,
5176                 p3
5177             )
5178         );
5179     }
5180 
5181     function log(
5182         bool p0,
5183         bool p1,
5184         uint256 p2,
5185         bool p3
5186     ) internal view {
5187         _sendLogPayload(
5188             abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3)
5189         );
5190     }
5191 
5192     function log(
5193         bool p0,
5194         bool p1,
5195         uint256 p2,
5196         address p3
5197     ) internal view {
5198         _sendLogPayload(
5199             abi.encodeWithSignature(
5200                 "log(bool,bool,uint,address)",
5201                 p0,
5202                 p1,
5203                 p2,
5204                 p3
5205             )
5206         );
5207     }
5208 
5209     function log(
5210         bool p0,
5211         bool p1,
5212         string memory p2,
5213         uint256 p3
5214     ) internal view {
5215         _sendLogPayload(
5216             abi.encodeWithSignature(
5217                 "log(bool,bool,string,uint)",
5218                 p0,
5219                 p1,
5220                 p2,
5221                 p3
5222             )
5223         );
5224     }
5225 
5226     function log(
5227         bool p0,
5228         bool p1,
5229         string memory p2,
5230         string memory p3
5231     ) internal view {
5232         _sendLogPayload(
5233             abi.encodeWithSignature(
5234                 "log(bool,bool,string,string)",
5235                 p0,
5236                 p1,
5237                 p2,
5238                 p3
5239             )
5240         );
5241     }
5242 
5243     function log(
5244         bool p0,
5245         bool p1,
5246         string memory p2,
5247         bool p3
5248     ) internal view {
5249         _sendLogPayload(
5250             abi.encodeWithSignature(
5251                 "log(bool,bool,string,bool)",
5252                 p0,
5253                 p1,
5254                 p2,
5255                 p3
5256             )
5257         );
5258     }
5259 
5260     function log(
5261         bool p0,
5262         bool p1,
5263         string memory p2,
5264         address p3
5265     ) internal view {
5266         _sendLogPayload(
5267             abi.encodeWithSignature(
5268                 "log(bool,bool,string,address)",
5269                 p0,
5270                 p1,
5271                 p2,
5272                 p3
5273             )
5274         );
5275     }
5276 
5277     function log(
5278         bool p0,
5279         bool p1,
5280         bool p2,
5281         uint256 p3
5282     ) internal view {
5283         _sendLogPayload(
5284             abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3)
5285         );
5286     }
5287 
5288     function log(
5289         bool p0,
5290         bool p1,
5291         bool p2,
5292         string memory p3
5293     ) internal view {
5294         _sendLogPayload(
5295             abi.encodeWithSignature(
5296                 "log(bool,bool,bool,string)",
5297                 p0,
5298                 p1,
5299                 p2,
5300                 p3
5301             )
5302         );
5303     }
5304 
5305     function log(
5306         bool p0,
5307         bool p1,
5308         bool p2,
5309         bool p3
5310     ) internal view {
5311         _sendLogPayload(
5312             abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3)
5313         );
5314     }
5315 
5316     function log(
5317         bool p0,
5318         bool p1,
5319         bool p2,
5320         address p3
5321     ) internal view {
5322         _sendLogPayload(
5323             abi.encodeWithSignature(
5324                 "log(bool,bool,bool,address)",
5325                 p0,
5326                 p1,
5327                 p2,
5328                 p3
5329             )
5330         );
5331     }
5332 
5333     function log(
5334         bool p0,
5335         bool p1,
5336         address p2,
5337         uint256 p3
5338     ) internal view {
5339         _sendLogPayload(
5340             abi.encodeWithSignature(
5341                 "log(bool,bool,address,uint)",
5342                 p0,
5343                 p1,
5344                 p2,
5345                 p3
5346             )
5347         );
5348     }
5349 
5350     function log(
5351         bool p0,
5352         bool p1,
5353         address p2,
5354         string memory p3
5355     ) internal view {
5356         _sendLogPayload(
5357             abi.encodeWithSignature(
5358                 "log(bool,bool,address,string)",
5359                 p0,
5360                 p1,
5361                 p2,
5362                 p3
5363             )
5364         );
5365     }
5366 
5367     function log(
5368         bool p0,
5369         bool p1,
5370         address p2,
5371         bool p3
5372     ) internal view {
5373         _sendLogPayload(
5374             abi.encodeWithSignature(
5375                 "log(bool,bool,address,bool)",
5376                 p0,
5377                 p1,
5378                 p2,
5379                 p3
5380             )
5381         );
5382     }
5383 
5384     function log(
5385         bool p0,
5386         bool p1,
5387         address p2,
5388         address p3
5389     ) internal view {
5390         _sendLogPayload(
5391             abi.encodeWithSignature(
5392                 "log(bool,bool,address,address)",
5393                 p0,
5394                 p1,
5395                 p2,
5396                 p3
5397             )
5398         );
5399     }
5400 
5401     function log(
5402         bool p0,
5403         address p1,
5404         uint256 p2,
5405         uint256 p3
5406     ) internal view {
5407         _sendLogPayload(
5408             abi.encodeWithSignature(
5409                 "log(bool,address,uint,uint)",
5410                 p0,
5411                 p1,
5412                 p2,
5413                 p3
5414             )
5415         );
5416     }
5417 
5418     function log(
5419         bool p0,
5420         address p1,
5421         uint256 p2,
5422         string memory p3
5423     ) internal view {
5424         _sendLogPayload(
5425             abi.encodeWithSignature(
5426                 "log(bool,address,uint,string)",
5427                 p0,
5428                 p1,
5429                 p2,
5430                 p3
5431             )
5432         );
5433     }
5434 
5435     function log(
5436         bool p0,
5437         address p1,
5438         uint256 p2,
5439         bool p3
5440     ) internal view {
5441         _sendLogPayload(
5442             abi.encodeWithSignature(
5443                 "log(bool,address,uint,bool)",
5444                 p0,
5445                 p1,
5446                 p2,
5447                 p3
5448             )
5449         );
5450     }
5451 
5452     function log(
5453         bool p0,
5454         address p1,
5455         uint256 p2,
5456         address p3
5457     ) internal view {
5458         _sendLogPayload(
5459             abi.encodeWithSignature(
5460                 "log(bool,address,uint,address)",
5461                 p0,
5462                 p1,
5463                 p2,
5464                 p3
5465             )
5466         );
5467     }
5468 
5469     function log(
5470         bool p0,
5471         address p1,
5472         string memory p2,
5473         uint256 p3
5474     ) internal view {
5475         _sendLogPayload(
5476             abi.encodeWithSignature(
5477                 "log(bool,address,string,uint)",
5478                 p0,
5479                 p1,
5480                 p2,
5481                 p3
5482             )
5483         );
5484     }
5485 
5486     function log(
5487         bool p0,
5488         address p1,
5489         string memory p2,
5490         string memory p3
5491     ) internal view {
5492         _sendLogPayload(
5493             abi.encodeWithSignature(
5494                 "log(bool,address,string,string)",
5495                 p0,
5496                 p1,
5497                 p2,
5498                 p3
5499             )
5500         );
5501     }
5502 
5503     function log(
5504         bool p0,
5505         address p1,
5506         string memory p2,
5507         bool p3
5508     ) internal view {
5509         _sendLogPayload(
5510             abi.encodeWithSignature(
5511                 "log(bool,address,string,bool)",
5512                 p0,
5513                 p1,
5514                 p2,
5515                 p3
5516             )
5517         );
5518     }
5519 
5520     function log(
5521         bool p0,
5522         address p1,
5523         string memory p2,
5524         address p3
5525     ) internal view {
5526         _sendLogPayload(
5527             abi.encodeWithSignature(
5528                 "log(bool,address,string,address)",
5529                 p0,
5530                 p1,
5531                 p2,
5532                 p3
5533             )
5534         );
5535     }
5536 
5537     function log(
5538         bool p0,
5539         address p1,
5540         bool p2,
5541         uint256 p3
5542     ) internal view {
5543         _sendLogPayload(
5544             abi.encodeWithSignature(
5545                 "log(bool,address,bool,uint)",
5546                 p0,
5547                 p1,
5548                 p2,
5549                 p3
5550             )
5551         );
5552     }
5553 
5554     function log(
5555         bool p0,
5556         address p1,
5557         bool p2,
5558         string memory p3
5559     ) internal view {
5560         _sendLogPayload(
5561             abi.encodeWithSignature(
5562                 "log(bool,address,bool,string)",
5563                 p0,
5564                 p1,
5565                 p2,
5566                 p3
5567             )
5568         );
5569     }
5570 
5571     function log(
5572         bool p0,
5573         address p1,
5574         bool p2,
5575         bool p3
5576     ) internal view {
5577         _sendLogPayload(
5578             abi.encodeWithSignature(
5579                 "log(bool,address,bool,bool)",
5580                 p0,
5581                 p1,
5582                 p2,
5583                 p3
5584             )
5585         );
5586     }
5587 
5588     function log(
5589         bool p0,
5590         address p1,
5591         bool p2,
5592         address p3
5593     ) internal view {
5594         _sendLogPayload(
5595             abi.encodeWithSignature(
5596                 "log(bool,address,bool,address)",
5597                 p0,
5598                 p1,
5599                 p2,
5600                 p3
5601             )
5602         );
5603     }
5604 
5605     function log(
5606         bool p0,
5607         address p1,
5608         address p2,
5609         uint256 p3
5610     ) internal view {
5611         _sendLogPayload(
5612             abi.encodeWithSignature(
5613                 "log(bool,address,address,uint)",
5614                 p0,
5615                 p1,
5616                 p2,
5617                 p3
5618             )
5619         );
5620     }
5621 
5622     function log(
5623         bool p0,
5624         address p1,
5625         address p2,
5626         string memory p3
5627     ) internal view {
5628         _sendLogPayload(
5629             abi.encodeWithSignature(
5630                 "log(bool,address,address,string)",
5631                 p0,
5632                 p1,
5633                 p2,
5634                 p3
5635             )
5636         );
5637     }
5638 
5639     function log(
5640         bool p0,
5641         address p1,
5642         address p2,
5643         bool p3
5644     ) internal view {
5645         _sendLogPayload(
5646             abi.encodeWithSignature(
5647                 "log(bool,address,address,bool)",
5648                 p0,
5649                 p1,
5650                 p2,
5651                 p3
5652             )
5653         );
5654     }
5655 
5656     function log(
5657         bool p0,
5658         address p1,
5659         address p2,
5660         address p3
5661     ) internal view {
5662         _sendLogPayload(
5663             abi.encodeWithSignature(
5664                 "log(bool,address,address,address)",
5665                 p0,
5666                 p1,
5667                 p2,
5668                 p3
5669             )
5670         );
5671     }
5672 
5673     function log(
5674         address p0,
5675         uint256 p1,
5676         uint256 p2,
5677         uint256 p3
5678     ) internal view {
5679         _sendLogPayload(
5680             abi.encodeWithSignature(
5681                 "log(address,uint,uint,uint)",
5682                 p0,
5683                 p1,
5684                 p2,
5685                 p3
5686             )
5687         );
5688     }
5689 
5690     function log(
5691         address p0,
5692         uint256 p1,
5693         uint256 p2,
5694         string memory p3
5695     ) internal view {
5696         _sendLogPayload(
5697             abi.encodeWithSignature(
5698                 "log(address,uint,uint,string)",
5699                 p0,
5700                 p1,
5701                 p2,
5702                 p3
5703             )
5704         );
5705     }
5706 
5707     function log(
5708         address p0,
5709         uint256 p1,
5710         uint256 p2,
5711         bool p3
5712     ) internal view {
5713         _sendLogPayload(
5714             abi.encodeWithSignature(
5715                 "log(address,uint,uint,bool)",
5716                 p0,
5717                 p1,
5718                 p2,
5719                 p3
5720             )
5721         );
5722     }
5723 
5724     function log(
5725         address p0,
5726         uint256 p1,
5727         uint256 p2,
5728         address p3
5729     ) internal view {
5730         _sendLogPayload(
5731             abi.encodeWithSignature(
5732                 "log(address,uint,uint,address)",
5733                 p0,
5734                 p1,
5735                 p2,
5736                 p3
5737             )
5738         );
5739     }
5740 
5741     function log(
5742         address p0,
5743         uint256 p1,
5744         string memory p2,
5745         uint256 p3
5746     ) internal view {
5747         _sendLogPayload(
5748             abi.encodeWithSignature(
5749                 "log(address,uint,string,uint)",
5750                 p0,
5751                 p1,
5752                 p2,
5753                 p3
5754             )
5755         );
5756     }
5757 
5758     function log(
5759         address p0,
5760         uint256 p1,
5761         string memory p2,
5762         string memory p3
5763     ) internal view {
5764         _sendLogPayload(
5765             abi.encodeWithSignature(
5766                 "log(address,uint,string,string)",
5767                 p0,
5768                 p1,
5769                 p2,
5770                 p3
5771             )
5772         );
5773     }
5774 
5775     function log(
5776         address p0,
5777         uint256 p1,
5778         string memory p2,
5779         bool p3
5780     ) internal view {
5781         _sendLogPayload(
5782             abi.encodeWithSignature(
5783                 "log(address,uint,string,bool)",
5784                 p0,
5785                 p1,
5786                 p2,
5787                 p3
5788             )
5789         );
5790     }
5791 
5792     function log(
5793         address p0,
5794         uint256 p1,
5795         string memory p2,
5796         address p3
5797     ) internal view {
5798         _sendLogPayload(
5799             abi.encodeWithSignature(
5800                 "log(address,uint,string,address)",
5801                 p0,
5802                 p1,
5803                 p2,
5804                 p3
5805             )
5806         );
5807     }
5808 
5809     function log(
5810         address p0,
5811         uint256 p1,
5812         bool p2,
5813         uint256 p3
5814     ) internal view {
5815         _sendLogPayload(
5816             abi.encodeWithSignature(
5817                 "log(address,uint,bool,uint)",
5818                 p0,
5819                 p1,
5820                 p2,
5821                 p3
5822             )
5823         );
5824     }
5825 
5826     function log(
5827         address p0,
5828         uint256 p1,
5829         bool p2,
5830         string memory p3
5831     ) internal view {
5832         _sendLogPayload(
5833             abi.encodeWithSignature(
5834                 "log(address,uint,bool,string)",
5835                 p0,
5836                 p1,
5837                 p2,
5838                 p3
5839             )
5840         );
5841     }
5842 
5843     function log(
5844         address p0,
5845         uint256 p1,
5846         bool p2,
5847         bool p3
5848     ) internal view {
5849         _sendLogPayload(
5850             abi.encodeWithSignature(
5851                 "log(address,uint,bool,bool)",
5852                 p0,
5853                 p1,
5854                 p2,
5855                 p3
5856             )
5857         );
5858     }
5859 
5860     function log(
5861         address p0,
5862         uint256 p1,
5863         bool p2,
5864         address p3
5865     ) internal view {
5866         _sendLogPayload(
5867             abi.encodeWithSignature(
5868                 "log(address,uint,bool,address)",
5869                 p0,
5870                 p1,
5871                 p2,
5872                 p3
5873             )
5874         );
5875     }
5876 
5877     function log(
5878         address p0,
5879         uint256 p1,
5880         address p2,
5881         uint256 p3
5882     ) internal view {
5883         _sendLogPayload(
5884             abi.encodeWithSignature(
5885                 "log(address,uint,address,uint)",
5886                 p0,
5887                 p1,
5888                 p2,
5889                 p3
5890             )
5891         );
5892     }
5893 
5894     function log(
5895         address p0,
5896         uint256 p1,
5897         address p2,
5898         string memory p3
5899     ) internal view {
5900         _sendLogPayload(
5901             abi.encodeWithSignature(
5902                 "log(address,uint,address,string)",
5903                 p0,
5904                 p1,
5905                 p2,
5906                 p3
5907             )
5908         );
5909     }
5910 
5911     function log(
5912         address p0,
5913         uint256 p1,
5914         address p2,
5915         bool p3
5916     ) internal view {
5917         _sendLogPayload(
5918             abi.encodeWithSignature(
5919                 "log(address,uint,address,bool)",
5920                 p0,
5921                 p1,
5922                 p2,
5923                 p3
5924             )
5925         );
5926     }
5927 
5928     function log(
5929         address p0,
5930         uint256 p1,
5931         address p2,
5932         address p3
5933     ) internal view {
5934         _sendLogPayload(
5935             abi.encodeWithSignature(
5936                 "log(address,uint,address,address)",
5937                 p0,
5938                 p1,
5939                 p2,
5940                 p3
5941             )
5942         );
5943     }
5944 
5945     function log(
5946         address p0,
5947         string memory p1,
5948         uint256 p2,
5949         uint256 p3
5950     ) internal view {
5951         _sendLogPayload(
5952             abi.encodeWithSignature(
5953                 "log(address,string,uint,uint)",
5954                 p0,
5955                 p1,
5956                 p2,
5957                 p3
5958             )
5959         );
5960     }
5961 
5962     function log(
5963         address p0,
5964         string memory p1,
5965         uint256 p2,
5966         string memory p3
5967     ) internal view {
5968         _sendLogPayload(
5969             abi.encodeWithSignature(
5970                 "log(address,string,uint,string)",
5971                 p0,
5972                 p1,
5973                 p2,
5974                 p3
5975             )
5976         );
5977     }
5978 
5979     function log(
5980         address p0,
5981         string memory p1,
5982         uint256 p2,
5983         bool p3
5984     ) internal view {
5985         _sendLogPayload(
5986             abi.encodeWithSignature(
5987                 "log(address,string,uint,bool)",
5988                 p0,
5989                 p1,
5990                 p2,
5991                 p3
5992             )
5993         );
5994     }
5995 
5996     function log(
5997         address p0,
5998         string memory p1,
5999         uint256 p2,
6000         address p3
6001     ) internal view {
6002         _sendLogPayload(
6003             abi.encodeWithSignature(
6004                 "log(address,string,uint,address)",
6005                 p0,
6006                 p1,
6007                 p2,
6008                 p3
6009             )
6010         );
6011     }
6012 
6013     function log(
6014         address p0,
6015         string memory p1,
6016         string memory p2,
6017         uint256 p3
6018     ) internal view {
6019         _sendLogPayload(
6020             abi.encodeWithSignature(
6021                 "log(address,string,string,uint)",
6022                 p0,
6023                 p1,
6024                 p2,
6025                 p3
6026             )
6027         );
6028     }
6029 
6030     function log(
6031         address p0,
6032         string memory p1,
6033         string memory p2,
6034         string memory p3
6035     ) internal view {
6036         _sendLogPayload(
6037             abi.encodeWithSignature(
6038                 "log(address,string,string,string)",
6039                 p0,
6040                 p1,
6041                 p2,
6042                 p3
6043             )
6044         );
6045     }
6046 
6047     function log(
6048         address p0,
6049         string memory p1,
6050         string memory p2,
6051         bool p3
6052     ) internal view {
6053         _sendLogPayload(
6054             abi.encodeWithSignature(
6055                 "log(address,string,string,bool)",
6056                 p0,
6057                 p1,
6058                 p2,
6059                 p3
6060             )
6061         );
6062     }
6063 
6064     function log(
6065         address p0,
6066         string memory p1,
6067         string memory p2,
6068         address p3
6069     ) internal view {
6070         _sendLogPayload(
6071             abi.encodeWithSignature(
6072                 "log(address,string,string,address)",
6073                 p0,
6074                 p1,
6075                 p2,
6076                 p3
6077             )
6078         );
6079     }
6080 
6081     function log(
6082         address p0,
6083         string memory p1,
6084         bool p2,
6085         uint256 p3
6086     ) internal view {
6087         _sendLogPayload(
6088             abi.encodeWithSignature(
6089                 "log(address,string,bool,uint)",
6090                 p0,
6091                 p1,
6092                 p2,
6093                 p3
6094             )
6095         );
6096     }
6097 
6098     function log(
6099         address p0,
6100         string memory p1,
6101         bool p2,
6102         string memory p3
6103     ) internal view {
6104         _sendLogPayload(
6105             abi.encodeWithSignature(
6106                 "log(address,string,bool,string)",
6107                 p0,
6108                 p1,
6109                 p2,
6110                 p3
6111             )
6112         );
6113     }
6114 
6115     function log(
6116         address p0,
6117         string memory p1,
6118         bool p2,
6119         bool p3
6120     ) internal view {
6121         _sendLogPayload(
6122             abi.encodeWithSignature(
6123                 "log(address,string,bool,bool)",
6124                 p0,
6125                 p1,
6126                 p2,
6127                 p3
6128             )
6129         );
6130     }
6131 
6132     function log(
6133         address p0,
6134         string memory p1,
6135         bool p2,
6136         address p3
6137     ) internal view {
6138         _sendLogPayload(
6139             abi.encodeWithSignature(
6140                 "log(address,string,bool,address)",
6141                 p0,
6142                 p1,
6143                 p2,
6144                 p3
6145             )
6146         );
6147     }
6148 
6149     function log(
6150         address p0,
6151         string memory p1,
6152         address p2,
6153         uint256 p3
6154     ) internal view {
6155         _sendLogPayload(
6156             abi.encodeWithSignature(
6157                 "log(address,string,address,uint)",
6158                 p0,
6159                 p1,
6160                 p2,
6161                 p3
6162             )
6163         );
6164     }
6165 
6166     function log(
6167         address p0,
6168         string memory p1,
6169         address p2,
6170         string memory p3
6171     ) internal view {
6172         _sendLogPayload(
6173             abi.encodeWithSignature(
6174                 "log(address,string,address,string)",
6175                 p0,
6176                 p1,
6177                 p2,
6178                 p3
6179             )
6180         );
6181     }
6182 
6183     function log(
6184         address p0,
6185         string memory p1,
6186         address p2,
6187         bool p3
6188     ) internal view {
6189         _sendLogPayload(
6190             abi.encodeWithSignature(
6191                 "log(address,string,address,bool)",
6192                 p0,
6193                 p1,
6194                 p2,
6195                 p3
6196             )
6197         );
6198     }
6199 
6200     function log(
6201         address p0,
6202         string memory p1,
6203         address p2,
6204         address p3
6205     ) internal view {
6206         _sendLogPayload(
6207             abi.encodeWithSignature(
6208                 "log(address,string,address,address)",
6209                 p0,
6210                 p1,
6211                 p2,
6212                 p3
6213             )
6214         );
6215     }
6216 
6217     function log(
6218         address p0,
6219         bool p1,
6220         uint256 p2,
6221         uint256 p3
6222     ) internal view {
6223         _sendLogPayload(
6224             abi.encodeWithSignature(
6225                 "log(address,bool,uint,uint)",
6226                 p0,
6227                 p1,
6228                 p2,
6229                 p3
6230             )
6231         );
6232     }
6233 
6234     function log(
6235         address p0,
6236         bool p1,
6237         uint256 p2,
6238         string memory p3
6239     ) internal view {
6240         _sendLogPayload(
6241             abi.encodeWithSignature(
6242                 "log(address,bool,uint,string)",
6243                 p0,
6244                 p1,
6245                 p2,
6246                 p3
6247             )
6248         );
6249     }
6250 
6251     function log(
6252         address p0,
6253         bool p1,
6254         uint256 p2,
6255         bool p3
6256     ) internal view {
6257         _sendLogPayload(
6258             abi.encodeWithSignature(
6259                 "log(address,bool,uint,bool)",
6260                 p0,
6261                 p1,
6262                 p2,
6263                 p3
6264             )
6265         );
6266     }
6267 
6268     function log(
6269         address p0,
6270         bool p1,
6271         uint256 p2,
6272         address p3
6273     ) internal view {
6274         _sendLogPayload(
6275             abi.encodeWithSignature(
6276                 "log(address,bool,uint,address)",
6277                 p0,
6278                 p1,
6279                 p2,
6280                 p3
6281             )
6282         );
6283     }
6284 
6285     function log(
6286         address p0,
6287         bool p1,
6288         string memory p2,
6289         uint256 p3
6290     ) internal view {
6291         _sendLogPayload(
6292             abi.encodeWithSignature(
6293                 "log(address,bool,string,uint)",
6294                 p0,
6295                 p1,
6296                 p2,
6297                 p3
6298             )
6299         );
6300     }
6301 
6302     function log(
6303         address p0,
6304         bool p1,
6305         string memory p2,
6306         string memory p3
6307     ) internal view {
6308         _sendLogPayload(
6309             abi.encodeWithSignature(
6310                 "log(address,bool,string,string)",
6311                 p0,
6312                 p1,
6313                 p2,
6314                 p3
6315             )
6316         );
6317     }
6318 
6319     function log(
6320         address p0,
6321         bool p1,
6322         string memory p2,
6323         bool p3
6324     ) internal view {
6325         _sendLogPayload(
6326             abi.encodeWithSignature(
6327                 "log(address,bool,string,bool)",
6328                 p0,
6329                 p1,
6330                 p2,
6331                 p3
6332             )
6333         );
6334     }
6335 
6336     function log(
6337         address p0,
6338         bool p1,
6339         string memory p2,
6340         address p3
6341     ) internal view {
6342         _sendLogPayload(
6343             abi.encodeWithSignature(
6344                 "log(address,bool,string,address)",
6345                 p0,
6346                 p1,
6347                 p2,
6348                 p3
6349             )
6350         );
6351     }
6352 
6353     function log(
6354         address p0,
6355         bool p1,
6356         bool p2,
6357         uint256 p3
6358     ) internal view {
6359         _sendLogPayload(
6360             abi.encodeWithSignature(
6361                 "log(address,bool,bool,uint)",
6362                 p0,
6363                 p1,
6364                 p2,
6365                 p3
6366             )
6367         );
6368     }
6369 
6370     function log(
6371         address p0,
6372         bool p1,
6373         bool p2,
6374         string memory p3
6375     ) internal view {
6376         _sendLogPayload(
6377             abi.encodeWithSignature(
6378                 "log(address,bool,bool,string)",
6379                 p0,
6380                 p1,
6381                 p2,
6382                 p3
6383             )
6384         );
6385     }
6386 
6387     function log(
6388         address p0,
6389         bool p1,
6390         bool p2,
6391         bool p3
6392     ) internal view {
6393         _sendLogPayload(
6394             abi.encodeWithSignature(
6395                 "log(address,bool,bool,bool)",
6396                 p0,
6397                 p1,
6398                 p2,
6399                 p3
6400             )
6401         );
6402     }
6403 
6404     function log(
6405         address p0,
6406         bool p1,
6407         bool p2,
6408         address p3
6409     ) internal view {
6410         _sendLogPayload(
6411             abi.encodeWithSignature(
6412                 "log(address,bool,bool,address)",
6413                 p0,
6414                 p1,
6415                 p2,
6416                 p3
6417             )
6418         );
6419     }
6420 
6421     function log(
6422         address p0,
6423         bool p1,
6424         address p2,
6425         uint256 p3
6426     ) internal view {
6427         _sendLogPayload(
6428             abi.encodeWithSignature(
6429                 "log(address,bool,address,uint)",
6430                 p0,
6431                 p1,
6432                 p2,
6433                 p3
6434             )
6435         );
6436     }
6437 
6438     function log(
6439         address p0,
6440         bool p1,
6441         address p2,
6442         string memory p3
6443     ) internal view {
6444         _sendLogPayload(
6445             abi.encodeWithSignature(
6446                 "log(address,bool,address,string)",
6447                 p0,
6448                 p1,
6449                 p2,
6450                 p3
6451             )
6452         );
6453     }
6454 
6455     function log(
6456         address p0,
6457         bool p1,
6458         address p2,
6459         bool p3
6460     ) internal view {
6461         _sendLogPayload(
6462             abi.encodeWithSignature(
6463                 "log(address,bool,address,bool)",
6464                 p0,
6465                 p1,
6466                 p2,
6467                 p3
6468             )
6469         );
6470     }
6471 
6472     function log(
6473         address p0,
6474         bool p1,
6475         address p2,
6476         address p3
6477     ) internal view {
6478         _sendLogPayload(
6479             abi.encodeWithSignature(
6480                 "log(address,bool,address,address)",
6481                 p0,
6482                 p1,
6483                 p2,
6484                 p3
6485             )
6486         );
6487     }
6488 
6489     function log(
6490         address p0,
6491         address p1,
6492         uint256 p2,
6493         uint256 p3
6494     ) internal view {
6495         _sendLogPayload(
6496             abi.encodeWithSignature(
6497                 "log(address,address,uint,uint)",
6498                 p0,
6499                 p1,
6500                 p2,
6501                 p3
6502             )
6503         );
6504     }
6505 
6506     function log(
6507         address p0,
6508         address p1,
6509         uint256 p2,
6510         string memory p3
6511     ) internal view {
6512         _sendLogPayload(
6513             abi.encodeWithSignature(
6514                 "log(address,address,uint,string)",
6515                 p0,
6516                 p1,
6517                 p2,
6518                 p3
6519             )
6520         );
6521     }
6522 
6523     function log(
6524         address p0,
6525         address p1,
6526         uint256 p2,
6527         bool p3
6528     ) internal view {
6529         _sendLogPayload(
6530             abi.encodeWithSignature(
6531                 "log(address,address,uint,bool)",
6532                 p0,
6533                 p1,
6534                 p2,
6535                 p3
6536             )
6537         );
6538     }
6539 
6540     function log(
6541         address p0,
6542         address p1,
6543         uint256 p2,
6544         address p3
6545     ) internal view {
6546         _sendLogPayload(
6547             abi.encodeWithSignature(
6548                 "log(address,address,uint,address)",
6549                 p0,
6550                 p1,
6551                 p2,
6552                 p3
6553             )
6554         );
6555     }
6556 
6557     function log(
6558         address p0,
6559         address p1,
6560         string memory p2,
6561         uint256 p3
6562     ) internal view {
6563         _sendLogPayload(
6564             abi.encodeWithSignature(
6565                 "log(address,address,string,uint)",
6566                 p0,
6567                 p1,
6568                 p2,
6569                 p3
6570             )
6571         );
6572     }
6573 
6574     function log(
6575         address p0,
6576         address p1,
6577         string memory p2,
6578         string memory p3
6579     ) internal view {
6580         _sendLogPayload(
6581             abi.encodeWithSignature(
6582                 "log(address,address,string,string)",
6583                 p0,
6584                 p1,
6585                 p2,
6586                 p3
6587             )
6588         );
6589     }
6590 
6591     function log(
6592         address p0,
6593         address p1,
6594         string memory p2,
6595         bool p3
6596     ) internal view {
6597         _sendLogPayload(
6598             abi.encodeWithSignature(
6599                 "log(address,address,string,bool)",
6600                 p0,
6601                 p1,
6602                 p2,
6603                 p3
6604             )
6605         );
6606     }
6607 
6608     function log(
6609         address p0,
6610         address p1,
6611         string memory p2,
6612         address p3
6613     ) internal view {
6614         _sendLogPayload(
6615             abi.encodeWithSignature(
6616                 "log(address,address,string,address)",
6617                 p0,
6618                 p1,
6619                 p2,
6620                 p3
6621             )
6622         );
6623     }
6624 
6625     function log(
6626         address p0,
6627         address p1,
6628         bool p2,
6629         uint256 p3
6630     ) internal view {
6631         _sendLogPayload(
6632             abi.encodeWithSignature(
6633                 "log(address,address,bool,uint)",
6634                 p0,
6635                 p1,
6636                 p2,
6637                 p3
6638             )
6639         );
6640     }
6641 
6642     function log(
6643         address p0,
6644         address p1,
6645         bool p2,
6646         string memory p3
6647     ) internal view {
6648         _sendLogPayload(
6649             abi.encodeWithSignature(
6650                 "log(address,address,bool,string)",
6651                 p0,
6652                 p1,
6653                 p2,
6654                 p3
6655             )
6656         );
6657     }
6658 
6659     function log(
6660         address p0,
6661         address p1,
6662         bool p2,
6663         bool p3
6664     ) internal view {
6665         _sendLogPayload(
6666             abi.encodeWithSignature(
6667                 "log(address,address,bool,bool)",
6668                 p0,
6669                 p1,
6670                 p2,
6671                 p3
6672             )
6673         );
6674     }
6675 
6676     function log(
6677         address p0,
6678         address p1,
6679         bool p2,
6680         address p3
6681     ) internal view {
6682         _sendLogPayload(
6683             abi.encodeWithSignature(
6684                 "log(address,address,bool,address)",
6685                 p0,
6686                 p1,
6687                 p2,
6688                 p3
6689             )
6690         );
6691     }
6692 
6693     function log(
6694         address p0,
6695         address p1,
6696         address p2,
6697         uint256 p3
6698     ) internal view {
6699         _sendLogPayload(
6700             abi.encodeWithSignature(
6701                 "log(address,address,address,uint)",
6702                 p0,
6703                 p1,
6704                 p2,
6705                 p3
6706             )
6707         );
6708     }
6709 
6710     function log(
6711         address p0,
6712         address p1,
6713         address p2,
6714         string memory p3
6715     ) internal view {
6716         _sendLogPayload(
6717             abi.encodeWithSignature(
6718                 "log(address,address,address,string)",
6719                 p0,
6720                 p1,
6721                 p2,
6722                 p3
6723             )
6724         );
6725     }
6726 
6727     function log(
6728         address p0,
6729         address p1,
6730         address p2,
6731         bool p3
6732     ) internal view {
6733         _sendLogPayload(
6734             abi.encodeWithSignature(
6735                 "log(address,address,address,bool)",
6736                 p0,
6737                 p1,
6738                 p2,
6739                 p3
6740             )
6741         );
6742     }
6743 
6744     function log(
6745         address p0,
6746         address p1,
6747         address p2,
6748         address p3
6749     ) internal view {
6750         _sendLogPayload(
6751             abi.encodeWithSignature(
6752                 "log(address,address,address,address)",
6753                 p0,
6754                 p1,
6755                 p2,
6756                 p3
6757             )
6758         );
6759     }
6760 }
6761 
6762 // File contracts/Davitar.sol
6763 
6764 pragma solidity ^0.8.0;
6765 
6766 //The following is only for debugging
6767 contract Davitar is ERC721URIStorage, Ownable {
6768     using Strings for uint32;
6769     using ECDSA for bytes32;
6770 
6771     string private _baseTokenURI;
6772     address private _signerAddress;
6773     uint256 _mintingPrice;
6774 
6775     event TokenMinted(
6776         address indexed owner,
6777         uint32 indexed tokenId,
6778         uint256 timestamp
6779     );
6780 
6781     constructor(
6782         string memory baseTokenURI,
6783         address signerAddress,
6784         uint256 mintingPrice
6785     ) ERC721("Davitar NFT", "DVT") {
6786         _baseTokenURI = baseTokenURI;
6787         _signerAddress = signerAddress;
6788         _mintingPrice = mintingPrice;
6789 
6790         _mintNewToken(0x94e9A5A128f7B4af0BEeFe32F411F61d244759cE, 915);
6791         _mintNewToken(0xa0b89e0466479A90164b6Ca6bB907da0195bd98F, 914);
6792         _mintNewToken(0xb9Cc86aa31c99a0123a9bf5453D5D022EcEbE106, 913);
6793         _mintNewToken(0x4F8DA0C32A5E7197d72D94FC3eb2D910B62670aF, 912);
6794         _mintNewToken(0x029c827053EfDe9C1e31D0680A586537fE9dAcfD, 911);
6795     }
6796 
6797     /*Function will be receiving a token id, a buyer address and a timestamp of the purchase petition.
6798     The backed server will provide a valid signature for the hash of the data provided, granted for a maximum of 15min.
6799     If the user takes more than expected to do the chase, the transaction will be rejected
6800     */
6801     function mintNewToken(
6802         uint32 tokenId,
6803         uint64 timestamp,
6804         bytes memory signature
6805     ) external payable {
6806         //Check payment and return excess
6807         require(msg.value >= _mintingPrice, "ERROR: Not enough ether sent");
6808         uint256 moneyToReturn = msg.value - _mintingPrice;
6809         if (moneyToReturn > 0) {
6810             payable(msg.sender).transfer(moneyToReturn);
6811         }
6812 
6813         //Check signature and generate NFT
6814         bytes32 dataHash = keccak256(
6815             abi.encodePacked(msg.sender, timestamp, tokenId)
6816         );
6817 
6818         console.logBytes32(dataHash);
6819         if (
6820             _checkValidSignature(dataHash, signature) &&
6821             block.timestamp < timestamp + 15 minutes
6822         ) {
6823             _mintNewToken(msg.sender, tokenId);
6824         } else revert("ERROR: Unauthorized minting requested");
6825     }
6826 
6827     function _checkValidSignature(bytes32 data, bytes memory signature)
6828         private
6829         view
6830         returns (bool isValid)
6831     {
6832         address signerAddress = data.toEthSignedMessageHash().recover(
6833             signature
6834         );
6835         return signerAddress == _signerAddress;
6836     }
6837 
6838     function _mintNewToken(address newOwner, uint32 tokenId) private {
6839         _mint(newOwner, tokenId);
6840         string memory uri = string(
6841             bytes.concat(
6842                 bytes(_baseTokenURI),
6843                 bytes(tokenId.toString()),
6844                 bytes(".json")
6845             )
6846         );
6847         _setTokenURI(tokenId, uri);
6848         emit TokenMinted(newOwner, tokenId, block.timestamp);
6849     }
6850 
6851     function withdrawFunds(address recipient) external onlyOwner {
6852         payable(recipient).transfer(address(this).balance);
6853     }
6854 }