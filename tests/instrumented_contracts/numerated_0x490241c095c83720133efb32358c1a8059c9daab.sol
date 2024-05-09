1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 // SPDX-License-Identifier: MIT
3 
4 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
5 
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
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
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
192 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
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
221 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
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
248 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
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
509 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
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
535 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
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
608 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
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
643 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
644 
645 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
943             getApproved(tokenId) == spender ||
944             isApprovedForAll(owner, spender));
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
1170 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
1171 
1172 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 /**
1177  * @dev Interface of the ERC20 standard as defined in the EIP.
1178  */
1179 interface IERC20 {
1180     /**
1181      * @dev Returns the amount of tokens in existence.
1182      */
1183     function totalSupply() external view returns (uint256);
1184 
1185     /**
1186      * @dev Returns the amount of tokens owned by `account`.
1187      */
1188     function balanceOf(address account) external view returns (uint256);
1189 
1190     /**
1191      * @dev Moves `amount` tokens from the caller's account to `to`.
1192      *
1193      * Returns a boolean value indicating whether the operation succeeded.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function transfer(address to, uint256 amount) external returns (bool);
1198 
1199     /**
1200      * @dev Returns the remaining number of tokens that `spender` will be
1201      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1202      * zero by default.
1203      *
1204      * This value changes when {approve} or {transferFrom} are called.
1205      */
1206     function allowance(address owner, address spender)
1207         external
1208         view
1209         returns (uint256);
1210 
1211     /**
1212      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1213      *
1214      * Returns a boolean value indicating whether the operation succeeded.
1215      *
1216      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1217      * that someone may use both the old and the new allowance by unfortunate
1218      * transaction ordering. One possible solution to mitigate this race
1219      * condition is to first reduce the spender's allowance to 0 and set the
1220      * desired value afterwards:
1221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1222      *
1223      * Emits an {Approval} event.
1224      */
1225     function approve(address spender, uint256 amount) external returns (bool);
1226 
1227     /**
1228      * @dev Moves `amount` tokens from `from` to `to` using the
1229      * allowance mechanism. `amount` is then deducted from the caller's
1230      * allowance.
1231      *
1232      * Returns a boolean value indicating whether the operation succeeded.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function transferFrom(
1237         address from,
1238         address to,
1239         uint256 amount
1240     ) external returns (bool);
1241 
1242     /**
1243      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1244      * another (`to`).
1245      *
1246      * Note that `value` may be zero.
1247      */
1248     event Transfer(address indexed from, address indexed to, uint256 value);
1249 
1250     /**
1251      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1252      * a call to {approve}. `value` is the new allowance.
1253      */
1254     event Approval(
1255         address indexed owner,
1256         address indexed spender,
1257         uint256 value
1258     );
1259 }
1260 
1261 // File @openzeppelin/contracts/interfaces/IERC165.sol@v4.5.0
1262 
1263 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.5.0
1268 
1269 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 /**
1274  * @dev Interface for the NFT Royalty Standard.
1275  *
1276  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1277  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1278  *
1279  * _Available since v4.5._
1280  */
1281 interface IERC2981 is IERC165 {
1282     /**
1283      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1284      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1285      */
1286     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1287         external
1288         view
1289         returns (address receiver, uint256 royaltyAmount);
1290 }
1291 
1292 // File @openzeppelin/contracts/utils/Counters.sol@v4.5.0
1293 
1294 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1295 
1296 pragma solidity ^0.8.0;
1297 
1298 /**
1299  * @title Counters
1300  * @author Matt Condon (@shrugs)
1301  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1302  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1303  *
1304  * Include with `using Counters for Counters.Counter;`
1305  */
1306 library Counters {
1307     struct Counter {
1308         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1309         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1310         // this feature: see https://github.com/ethereum/solidity/issues/4637
1311         uint256 _value; // default: 0
1312     }
1313 
1314     function current(Counter storage counter) internal view returns (uint256) {
1315         return counter._value;
1316     }
1317 
1318     function increment(Counter storage counter) internal {
1319         unchecked {
1320             counter._value += 1;
1321         }
1322     }
1323 
1324     function decrement(Counter storage counter) internal {
1325         uint256 value = counter._value;
1326         require(value > 0, "Counter: decrement overflow");
1327         unchecked {
1328             counter._value = value - 1;
1329         }
1330     }
1331 
1332     function reset(Counter storage counter) internal {
1333         counter._value = 0;
1334     }
1335 }
1336 
1337 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1338 
1339 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1340 
1341 pragma solidity ^0.8.0;
1342 
1343 /**
1344  * @dev Contract module which provides a basic access control mechanism, where
1345  * there is an account (an owner) that can be granted exclusive access to
1346  * specific functions.
1347  *
1348  * By default, the owner account will be the one that deploys the contract. This
1349  * can later be changed with {transferOwnership}.
1350  *
1351  * This module is used through inheritance. It will make available the modifier
1352  * `onlyOwner`, which can be applied to your functions to restrict their use to
1353  * the owner.
1354  */
1355 abstract contract Ownable is Context {
1356     address private _owner;
1357 
1358     event OwnershipTransferred(
1359         address indexed previousOwner,
1360         address indexed newOwner
1361     );
1362 
1363     /**
1364      * @dev Initializes the contract setting the deployer as the initial owner.
1365      */
1366     constructor() {
1367         _transferOwnership(_msgSender());
1368     }
1369 
1370     /**
1371      * @dev Returns the address of the current owner.
1372      */
1373     function owner() public view virtual returns (address) {
1374         return _owner;
1375     }
1376 
1377     /**
1378      * @dev Throws if called by any account other than the owner.
1379      */
1380     modifier onlyOwner() {
1381         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1382         _;
1383     }
1384 
1385     /**
1386      * @dev Leaves the contract without owner. It will not be possible to call
1387      * `onlyOwner` functions anymore. Can only be called by the current owner.
1388      *
1389      * NOTE: Renouncing ownership will leave the contract without an owner,
1390      * thereby removing any functionality that is only available to the owner.
1391      */
1392     function renounceOwnership() public virtual onlyOwner {
1393         _transferOwnership(address(0));
1394     }
1395 
1396     /**
1397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1398      * Can only be called by the current owner.
1399      */
1400     function transferOwnership(address newOwner) public virtual onlyOwner {
1401         require(
1402             newOwner != address(0),
1403             "Ownable: new owner is the zero address"
1404         );
1405         _transferOwnership(newOwner);
1406     }
1407 
1408     /**
1409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1410      * Internal function without access restriction.
1411      */
1412     function _transferOwnership(address newOwner) internal virtual {
1413         address oldOwner = _owner;
1414         _owner = newOwner;
1415         emit OwnershipTransferred(oldOwner, newOwner);
1416     }
1417 }
1418 
1419 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1420 
1421 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1422 
1423 pragma solidity ^0.8.0;
1424 
1425 /**
1426  * @dev Contract module that helps prevent reentrant calls to a function.
1427  *
1428  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1429  * available, which can be applied to functions to make sure there are no nested
1430  * (reentrant) calls to them.
1431  *
1432  * Note that because there is a single `nonReentrant` guard, functions marked as
1433  * `nonReentrant` may not call one another. This can be worked around by making
1434  * those functions `private`, and then adding `external` `nonReentrant` entry
1435  * points to them.
1436  *
1437  * TIP: If you would like to learn more about reentrancy and alternative ways
1438  * to protect against it, check out our blog post
1439  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1440  */
1441 abstract contract ReentrancyGuard {
1442     // Booleans are more expensive than uint256 or any type that takes up a full
1443     // word because each write operation emits an extra SLOAD to first read the
1444     // slot's contents, replace the bits taken up by the boolean, and then write
1445     // back. This is the compiler's defense against contract upgrades and
1446     // pointer aliasing, and it cannot be disabled.
1447 
1448     // The values being non-zero value makes deployment a bit more expensive,
1449     // but in exchange the refund on every call to nonReentrant will be lower in
1450     // amount. Since refunds are capped to a percentage of the total
1451     // transaction's gas, it is best to keep them low in cases like this one, to
1452     // increase the likelihood of the full refund coming into effect.
1453     uint256 private constant _NOT_ENTERED = 1;
1454     uint256 private constant _ENTERED = 2;
1455 
1456     uint256 private _status;
1457 
1458     constructor() {
1459         _status = _NOT_ENTERED;
1460     }
1461 
1462     /**
1463      * @dev Prevents a contract from calling itself, directly or indirectly.
1464      * Calling a `nonReentrant` function from another `nonReentrant`
1465      * function is not supported. It is possible to prevent this from happening
1466      * by making the `nonReentrant` function external, and making it call a
1467      * `private` function that does the actual work.
1468      */
1469     modifier nonReentrant() {
1470         // On the first call to nonReentrant, _notEntered will be true
1471         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1472 
1473         // Any calls to nonReentrant after this point will fail
1474         _status = _ENTERED;
1475 
1476         _;
1477 
1478         // By storing the original value once again, a refund is triggered (see
1479         // https://eips.ethereum.org/EIPS/eip-2200)
1480         _status = _NOT_ENTERED;
1481     }
1482 }
1483 
1484 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
1485 
1486 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1487 
1488 pragma solidity ^0.8.0;
1489 
1490 /**
1491  * @dev Contract module which allows children to implement an emergency stop
1492  * mechanism that can be triggered by an authorized account.
1493  *
1494  * This module is used through inheritance. It will make available the
1495  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1496  * the functions of your contract. Note that they will not be pausable by
1497  * simply including this module, only once the modifiers are put in place.
1498  */
1499 abstract contract Pausable is Context {
1500     /**
1501      * @dev Emitted when the pause is triggered by `account`.
1502      */
1503     event Paused(address account);
1504 
1505     /**
1506      * @dev Emitted when the pause is lifted by `account`.
1507      */
1508     event Unpaused(address account);
1509 
1510     bool private _paused;
1511 
1512     /**
1513      * @dev Initializes the contract in unpaused state.
1514      */
1515     constructor() {
1516         _paused = false;
1517     }
1518 
1519     /**
1520      * @dev Returns true if the contract is paused, and false otherwise.
1521      */
1522     function paused() public view virtual returns (bool) {
1523         return _paused;
1524     }
1525 
1526     /**
1527      * @dev Modifier to make a function callable only when the contract is not paused.
1528      *
1529      * Requirements:
1530      *
1531      * - The contract must not be paused.
1532      */
1533     modifier whenNotPaused() {
1534         require(!paused(), "Pausable: paused");
1535         _;
1536     }
1537 
1538     /**
1539      * @dev Modifier to make a function callable only when the contract is paused.
1540      *
1541      * Requirements:
1542      *
1543      * - The contract must be paused.
1544      */
1545     modifier whenPaused() {
1546         require(paused(), "Pausable: not paused");
1547         _;
1548     }
1549 
1550     /**
1551      * @dev Triggers stopped state.
1552      *
1553      * Requirements:
1554      *
1555      * - The contract must not be paused.
1556      */
1557     function _pause() internal virtual whenNotPaused {
1558         _paused = true;
1559         emit Paused(_msgSender());
1560     }
1561 
1562     /**
1563      * @dev Returns to normal state.
1564      *
1565      * Requirements:
1566      *
1567      * - The contract must be paused.
1568      */
1569     function _unpause() internal virtual whenPaused {
1570         _paused = false;
1571         emit Unpaused(_msgSender());
1572     }
1573 }
1574 
1575 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
1576 
1577 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1578 
1579 pragma solidity ^0.8.0;
1580 
1581 // CAUTION
1582 // This version of SafeMath should only be used with Solidity 0.8 or later,
1583 // because it relies on the compiler's built in overflow checks.
1584 
1585 /**
1586  * @dev Wrappers over Solidity's arithmetic operations.
1587  *
1588  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1589  * now has built in overflow checking.
1590  */
1591 library SafeMath {
1592     /**
1593      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1594      *
1595      * _Available since v3.4._
1596      */
1597     function tryAdd(uint256 a, uint256 b)
1598         internal
1599         pure
1600         returns (bool, uint256)
1601     {
1602         unchecked {
1603             uint256 c = a + b;
1604             if (c < a) return (false, 0);
1605             return (true, c);
1606         }
1607     }
1608 
1609     /**
1610      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1611      *
1612      * _Available since v3.4._
1613      */
1614     function trySub(uint256 a, uint256 b)
1615         internal
1616         pure
1617         returns (bool, uint256)
1618     {
1619         unchecked {
1620             if (b > a) return (false, 0);
1621             return (true, a - b);
1622         }
1623     }
1624 
1625     /**
1626      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1627      *
1628      * _Available since v3.4._
1629      */
1630     function tryMul(uint256 a, uint256 b)
1631         internal
1632         pure
1633         returns (bool, uint256)
1634     {
1635         unchecked {
1636             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1637             // benefit is lost if 'b' is also tested.
1638             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1639             if (a == 0) return (true, 0);
1640             uint256 c = a * b;
1641             if (c / a != b) return (false, 0);
1642             return (true, c);
1643         }
1644     }
1645 
1646     /**
1647      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1648      *
1649      * _Available since v3.4._
1650      */
1651     function tryDiv(uint256 a, uint256 b)
1652         internal
1653         pure
1654         returns (bool, uint256)
1655     {
1656         unchecked {
1657             if (b == 0) return (false, 0);
1658             return (true, a / b);
1659         }
1660     }
1661 
1662     /**
1663      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1664      *
1665      * _Available since v3.4._
1666      */
1667     function tryMod(uint256 a, uint256 b)
1668         internal
1669         pure
1670         returns (bool, uint256)
1671     {
1672         unchecked {
1673             if (b == 0) return (false, 0);
1674             return (true, a % b);
1675         }
1676     }
1677 
1678     /**
1679      * @dev Returns the addition of two unsigned integers, reverting on
1680      * overflow.
1681      *
1682      * Counterpart to Solidity's `+` operator.
1683      *
1684      * Requirements:
1685      *
1686      * - Addition cannot overflow.
1687      */
1688     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1689         return a + b;
1690     }
1691 
1692     /**
1693      * @dev Returns the subtraction of two unsigned integers, reverting on
1694      * overflow (when the result is negative).
1695      *
1696      * Counterpart to Solidity's `-` operator.
1697      *
1698      * Requirements:
1699      *
1700      * - Subtraction cannot overflow.
1701      */
1702     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1703         return a - b;
1704     }
1705 
1706     /**
1707      * @dev Returns the multiplication of two unsigned integers, reverting on
1708      * overflow.
1709      *
1710      * Counterpart to Solidity's `*` operator.
1711      *
1712      * Requirements:
1713      *
1714      * - Multiplication cannot overflow.
1715      */
1716     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1717         return a * b;
1718     }
1719 
1720     /**
1721      * @dev Returns the integer division of two unsigned integers, reverting on
1722      * division by zero. The result is rounded towards zero.
1723      *
1724      * Counterpart to Solidity's `/` operator.
1725      *
1726      * Requirements:
1727      *
1728      * - The divisor cannot be zero.
1729      */
1730     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1731         return a / b;
1732     }
1733 
1734     /**
1735      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1736      * reverting when dividing by zero.
1737      *
1738      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1739      * opcode (which leaves remaining gas untouched) while Solidity uses an
1740      * invalid opcode to revert (consuming all remaining gas).
1741      *
1742      * Requirements:
1743      *
1744      * - The divisor cannot be zero.
1745      */
1746     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1747         return a % b;
1748     }
1749 
1750     /**
1751      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1752      * overflow (when the result is negative).
1753      *
1754      * CAUTION: This function is deprecated because it requires allocating memory for the error
1755      * message unnecessarily. For custom revert reasons use {trySub}.
1756      *
1757      * Counterpart to Solidity's `-` operator.
1758      *
1759      * Requirements:
1760      *
1761      * - Subtraction cannot overflow.
1762      */
1763     function sub(
1764         uint256 a,
1765         uint256 b,
1766         string memory errorMessage
1767     ) internal pure returns (uint256) {
1768         unchecked {
1769             require(b <= a, errorMessage);
1770             return a - b;
1771         }
1772     }
1773 
1774     /**
1775      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1776      * division by zero. The result is rounded towards zero.
1777      *
1778      * Counterpart to Solidity's `/` operator. Note: this function uses a
1779      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1780      * uses an invalid opcode to revert (consuming all remaining gas).
1781      *
1782      * Requirements:
1783      *
1784      * - The divisor cannot be zero.
1785      */
1786     function div(
1787         uint256 a,
1788         uint256 b,
1789         string memory errorMessage
1790     ) internal pure returns (uint256) {
1791         unchecked {
1792             require(b > 0, errorMessage);
1793             return a / b;
1794         }
1795     }
1796 
1797     /**
1798      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1799      * reverting with custom message when dividing by zero.
1800      *
1801      * CAUTION: This function is deprecated because it requires allocating memory for the error
1802      * message unnecessarily. For custom revert reasons use {tryMod}.
1803      *
1804      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1805      * opcode (which leaves remaining gas untouched) while Solidity uses an
1806      * invalid opcode to revert (consuming all remaining gas).
1807      *
1808      * Requirements:
1809      *
1810      * - The divisor cannot be zero.
1811      */
1812     function mod(
1813         uint256 a,
1814         uint256 b,
1815         string memory errorMessage
1816     ) internal pure returns (uint256) {
1817         unchecked {
1818             require(b > 0, errorMessage);
1819             return a % b;
1820         }
1821     }
1822 }
1823 
1824 // File hardhat/console.sol@v2.8.4
1825 
1826 pragma solidity >=0.4.22 <0.9.0;
1827 
1828 library console {
1829     address constant CONSOLE_ADDRESS =
1830         address(0x000000000000000000636F6e736F6c652e6c6f67);
1831 
1832     function _sendLogPayload(bytes memory payload) private view {
1833         uint256 payloadLength = payload.length;
1834         address consoleAddress = CONSOLE_ADDRESS;
1835         assembly {
1836             let payloadStart := add(payload, 32)
1837             let r := staticcall(
1838                 gas(),
1839                 consoleAddress,
1840                 payloadStart,
1841                 payloadLength,
1842                 0,
1843                 0
1844             )
1845         }
1846     }
1847 
1848     function log() internal view {
1849         _sendLogPayload(abi.encodeWithSignature("log()"));
1850     }
1851 
1852     function logInt(int256 p0) internal view {
1853         _sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1854     }
1855 
1856     function logUint(uint256 p0) internal view {
1857         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1858     }
1859 
1860     function logString(string memory p0) internal view {
1861         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1862     }
1863 
1864     function logBool(bool p0) internal view {
1865         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1866     }
1867 
1868     function logAddress(address p0) internal view {
1869         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1870     }
1871 
1872     function logBytes(bytes memory p0) internal view {
1873         _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1874     }
1875 
1876     function logBytes1(bytes1 p0) internal view {
1877         _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1878     }
1879 
1880     function logBytes2(bytes2 p0) internal view {
1881         _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1882     }
1883 
1884     function logBytes3(bytes3 p0) internal view {
1885         _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1886     }
1887 
1888     function logBytes4(bytes4 p0) internal view {
1889         _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1890     }
1891 
1892     function logBytes5(bytes5 p0) internal view {
1893         _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1894     }
1895 
1896     function logBytes6(bytes6 p0) internal view {
1897         _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1898     }
1899 
1900     function logBytes7(bytes7 p0) internal view {
1901         _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1902     }
1903 
1904     function logBytes8(bytes8 p0) internal view {
1905         _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1906     }
1907 
1908     function logBytes9(bytes9 p0) internal view {
1909         _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1910     }
1911 
1912     function logBytes10(bytes10 p0) internal view {
1913         _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1914     }
1915 
1916     function logBytes11(bytes11 p0) internal view {
1917         _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1918     }
1919 
1920     function logBytes12(bytes12 p0) internal view {
1921         _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1922     }
1923 
1924     function logBytes13(bytes13 p0) internal view {
1925         _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1926     }
1927 
1928     function logBytes14(bytes14 p0) internal view {
1929         _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1930     }
1931 
1932     function logBytes15(bytes15 p0) internal view {
1933         _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1934     }
1935 
1936     function logBytes16(bytes16 p0) internal view {
1937         _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1938     }
1939 
1940     function logBytes17(bytes17 p0) internal view {
1941         _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1942     }
1943 
1944     function logBytes18(bytes18 p0) internal view {
1945         _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1946     }
1947 
1948     function logBytes19(bytes19 p0) internal view {
1949         _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1950     }
1951 
1952     function logBytes20(bytes20 p0) internal view {
1953         _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1954     }
1955 
1956     function logBytes21(bytes21 p0) internal view {
1957         _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1958     }
1959 
1960     function logBytes22(bytes22 p0) internal view {
1961         _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1962     }
1963 
1964     function logBytes23(bytes23 p0) internal view {
1965         _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1966     }
1967 
1968     function logBytes24(bytes24 p0) internal view {
1969         _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1970     }
1971 
1972     function logBytes25(bytes25 p0) internal view {
1973         _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1974     }
1975 
1976     function logBytes26(bytes26 p0) internal view {
1977         _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1978     }
1979 
1980     function logBytes27(bytes27 p0) internal view {
1981         _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1982     }
1983 
1984     function logBytes28(bytes28 p0) internal view {
1985         _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1986     }
1987 
1988     function logBytes29(bytes29 p0) internal view {
1989         _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1990     }
1991 
1992     function logBytes30(bytes30 p0) internal view {
1993         _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1994     }
1995 
1996     function logBytes31(bytes31 p0) internal view {
1997         _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1998     }
1999 
2000     function logBytes32(bytes32 p0) internal view {
2001         _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
2002     }
2003 
2004     function log(uint256 p0) internal view {
2005         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
2006     }
2007 
2008     function log(string memory p0) internal view {
2009         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
2010     }
2011 
2012     function log(bool p0) internal view {
2013         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
2014     }
2015 
2016     function log(address p0) internal view {
2017         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
2018     }
2019 
2020     function log(uint256 p0, uint256 p1) internal view {
2021         _sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
2022     }
2023 
2024     function log(uint256 p0, string memory p1) internal view {
2025         _sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
2026     }
2027 
2028     function log(uint256 p0, bool p1) internal view {
2029         _sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
2030     }
2031 
2032     function log(uint256 p0, address p1) internal view {
2033         _sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
2034     }
2035 
2036     function log(string memory p0, uint256 p1) internal view {
2037         _sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
2038     }
2039 
2040     function log(string memory p0, string memory p1) internal view {
2041         _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
2042     }
2043 
2044     function log(string memory p0, bool p1) internal view {
2045         _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
2046     }
2047 
2048     function log(string memory p0, address p1) internal view {
2049         _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
2050     }
2051 
2052     function log(bool p0, uint256 p1) internal view {
2053         _sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
2054     }
2055 
2056     function log(bool p0, string memory p1) internal view {
2057         _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
2058     }
2059 
2060     function log(bool p0, bool p1) internal view {
2061         _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
2062     }
2063 
2064     function log(bool p0, address p1) internal view {
2065         _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
2066     }
2067 
2068     function log(address p0, uint256 p1) internal view {
2069         _sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
2070     }
2071 
2072     function log(address p0, string memory p1) internal view {
2073         _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
2074     }
2075 
2076     function log(address p0, bool p1) internal view {
2077         _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
2078     }
2079 
2080     function log(address p0, address p1) internal view {
2081         _sendLogPayload(
2082             abi.encodeWithSignature("log(address,address)", p0, p1)
2083         );
2084     }
2085 
2086     function log(
2087         uint256 p0,
2088         uint256 p1,
2089         uint256 p2
2090     ) internal view {
2091         _sendLogPayload(
2092             abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2)
2093         );
2094     }
2095 
2096     function log(
2097         uint256 p0,
2098         uint256 p1,
2099         string memory p2
2100     ) internal view {
2101         _sendLogPayload(
2102             abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2)
2103         );
2104     }
2105 
2106     function log(
2107         uint256 p0,
2108         uint256 p1,
2109         bool p2
2110     ) internal view {
2111         _sendLogPayload(
2112             abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2)
2113         );
2114     }
2115 
2116     function log(
2117         uint256 p0,
2118         uint256 p1,
2119         address p2
2120     ) internal view {
2121         _sendLogPayload(
2122             abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2)
2123         );
2124     }
2125 
2126     function log(
2127         uint256 p0,
2128         string memory p1,
2129         uint256 p2
2130     ) internal view {
2131         _sendLogPayload(
2132             abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2)
2133         );
2134     }
2135 
2136     function log(
2137         uint256 p0,
2138         string memory p1,
2139         string memory p2
2140     ) internal view {
2141         _sendLogPayload(
2142             abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2)
2143         );
2144     }
2145 
2146     function log(
2147         uint256 p0,
2148         string memory p1,
2149         bool p2
2150     ) internal view {
2151         _sendLogPayload(
2152             abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2)
2153         );
2154     }
2155 
2156     function log(
2157         uint256 p0,
2158         string memory p1,
2159         address p2
2160     ) internal view {
2161         _sendLogPayload(
2162             abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2)
2163         );
2164     }
2165 
2166     function log(
2167         uint256 p0,
2168         bool p1,
2169         uint256 p2
2170     ) internal view {
2171         _sendLogPayload(
2172             abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2)
2173         );
2174     }
2175 
2176     function log(
2177         uint256 p0,
2178         bool p1,
2179         string memory p2
2180     ) internal view {
2181         _sendLogPayload(
2182             abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2)
2183         );
2184     }
2185 
2186     function log(
2187         uint256 p0,
2188         bool p1,
2189         bool p2
2190     ) internal view {
2191         _sendLogPayload(
2192             abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2)
2193         );
2194     }
2195 
2196     function log(
2197         uint256 p0,
2198         bool p1,
2199         address p2
2200     ) internal view {
2201         _sendLogPayload(
2202             abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2)
2203         );
2204     }
2205 
2206     function log(
2207         uint256 p0,
2208         address p1,
2209         uint256 p2
2210     ) internal view {
2211         _sendLogPayload(
2212             abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2)
2213         );
2214     }
2215 
2216     function log(
2217         uint256 p0,
2218         address p1,
2219         string memory p2
2220     ) internal view {
2221         _sendLogPayload(
2222             abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2)
2223         );
2224     }
2225 
2226     function log(
2227         uint256 p0,
2228         address p1,
2229         bool p2
2230     ) internal view {
2231         _sendLogPayload(
2232             abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2)
2233         );
2234     }
2235 
2236     function log(
2237         uint256 p0,
2238         address p1,
2239         address p2
2240     ) internal view {
2241         _sendLogPayload(
2242             abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2)
2243         );
2244     }
2245 
2246     function log(
2247         string memory p0,
2248         uint256 p1,
2249         uint256 p2
2250     ) internal view {
2251         _sendLogPayload(
2252             abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2)
2253         );
2254     }
2255 
2256     function log(
2257         string memory p0,
2258         uint256 p1,
2259         string memory p2
2260     ) internal view {
2261         _sendLogPayload(
2262             abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2)
2263         );
2264     }
2265 
2266     function log(
2267         string memory p0,
2268         uint256 p1,
2269         bool p2
2270     ) internal view {
2271         _sendLogPayload(
2272             abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2)
2273         );
2274     }
2275 
2276     function log(
2277         string memory p0,
2278         uint256 p1,
2279         address p2
2280     ) internal view {
2281         _sendLogPayload(
2282             abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2)
2283         );
2284     }
2285 
2286     function log(
2287         string memory p0,
2288         string memory p1,
2289         uint256 p2
2290     ) internal view {
2291         _sendLogPayload(
2292             abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2)
2293         );
2294     }
2295 
2296     function log(
2297         string memory p0,
2298         string memory p1,
2299         string memory p2
2300     ) internal view {
2301         _sendLogPayload(
2302             abi.encodeWithSignature("log(string,string,string)", p0, p1, p2)
2303         );
2304     }
2305 
2306     function log(
2307         string memory p0,
2308         string memory p1,
2309         bool p2
2310     ) internal view {
2311         _sendLogPayload(
2312             abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2)
2313         );
2314     }
2315 
2316     function log(
2317         string memory p0,
2318         string memory p1,
2319         address p2
2320     ) internal view {
2321         _sendLogPayload(
2322             abi.encodeWithSignature("log(string,string,address)", p0, p1, p2)
2323         );
2324     }
2325 
2326     function log(
2327         string memory p0,
2328         bool p1,
2329         uint256 p2
2330     ) internal view {
2331         _sendLogPayload(
2332             abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2)
2333         );
2334     }
2335 
2336     function log(
2337         string memory p0,
2338         bool p1,
2339         string memory p2
2340     ) internal view {
2341         _sendLogPayload(
2342             abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2)
2343         );
2344     }
2345 
2346     function log(
2347         string memory p0,
2348         bool p1,
2349         bool p2
2350     ) internal view {
2351         _sendLogPayload(
2352             abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2)
2353         );
2354     }
2355 
2356     function log(
2357         string memory p0,
2358         bool p1,
2359         address p2
2360     ) internal view {
2361         _sendLogPayload(
2362             abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2)
2363         );
2364     }
2365 
2366     function log(
2367         string memory p0,
2368         address p1,
2369         uint256 p2
2370     ) internal view {
2371         _sendLogPayload(
2372             abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2)
2373         );
2374     }
2375 
2376     function log(
2377         string memory p0,
2378         address p1,
2379         string memory p2
2380     ) internal view {
2381         _sendLogPayload(
2382             abi.encodeWithSignature("log(string,address,string)", p0, p1, p2)
2383         );
2384     }
2385 
2386     function log(
2387         string memory p0,
2388         address p1,
2389         bool p2
2390     ) internal view {
2391         _sendLogPayload(
2392             abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2)
2393         );
2394     }
2395 
2396     function log(
2397         string memory p0,
2398         address p1,
2399         address p2
2400     ) internal view {
2401         _sendLogPayload(
2402             abi.encodeWithSignature("log(string,address,address)", p0, p1, p2)
2403         );
2404     }
2405 
2406     function log(
2407         bool p0,
2408         uint256 p1,
2409         uint256 p2
2410     ) internal view {
2411         _sendLogPayload(
2412             abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2)
2413         );
2414     }
2415 
2416     function log(
2417         bool p0,
2418         uint256 p1,
2419         string memory p2
2420     ) internal view {
2421         _sendLogPayload(
2422             abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2)
2423         );
2424     }
2425 
2426     function log(
2427         bool p0,
2428         uint256 p1,
2429         bool p2
2430     ) internal view {
2431         _sendLogPayload(
2432             abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2)
2433         );
2434     }
2435 
2436     function log(
2437         bool p0,
2438         uint256 p1,
2439         address p2
2440     ) internal view {
2441         _sendLogPayload(
2442             abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2)
2443         );
2444     }
2445 
2446     function log(
2447         bool p0,
2448         string memory p1,
2449         uint256 p2
2450     ) internal view {
2451         _sendLogPayload(
2452             abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2)
2453         );
2454     }
2455 
2456     function log(
2457         bool p0,
2458         string memory p1,
2459         string memory p2
2460     ) internal view {
2461         _sendLogPayload(
2462             abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2)
2463         );
2464     }
2465 
2466     function log(
2467         bool p0,
2468         string memory p1,
2469         bool p2
2470     ) internal view {
2471         _sendLogPayload(
2472             abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2)
2473         );
2474     }
2475 
2476     function log(
2477         bool p0,
2478         string memory p1,
2479         address p2
2480     ) internal view {
2481         _sendLogPayload(
2482             abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2)
2483         );
2484     }
2485 
2486     function log(
2487         bool p0,
2488         bool p1,
2489         uint256 p2
2490     ) internal view {
2491         _sendLogPayload(
2492             abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2)
2493         );
2494     }
2495 
2496     function log(
2497         bool p0,
2498         bool p1,
2499         string memory p2
2500     ) internal view {
2501         _sendLogPayload(
2502             abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2)
2503         );
2504     }
2505 
2506     function log(
2507         bool p0,
2508         bool p1,
2509         bool p2
2510     ) internal view {
2511         _sendLogPayload(
2512             abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2)
2513         );
2514     }
2515 
2516     function log(
2517         bool p0,
2518         bool p1,
2519         address p2
2520     ) internal view {
2521         _sendLogPayload(
2522             abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2)
2523         );
2524     }
2525 
2526     function log(
2527         bool p0,
2528         address p1,
2529         uint256 p2
2530     ) internal view {
2531         _sendLogPayload(
2532             abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2)
2533         );
2534     }
2535 
2536     function log(
2537         bool p0,
2538         address p1,
2539         string memory p2
2540     ) internal view {
2541         _sendLogPayload(
2542             abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2)
2543         );
2544     }
2545 
2546     function log(
2547         bool p0,
2548         address p1,
2549         bool p2
2550     ) internal view {
2551         _sendLogPayload(
2552             abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2)
2553         );
2554     }
2555 
2556     function log(
2557         bool p0,
2558         address p1,
2559         address p2
2560     ) internal view {
2561         _sendLogPayload(
2562             abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2)
2563         );
2564     }
2565 
2566     function log(
2567         address p0,
2568         uint256 p1,
2569         uint256 p2
2570     ) internal view {
2571         _sendLogPayload(
2572             abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2)
2573         );
2574     }
2575 
2576     function log(
2577         address p0,
2578         uint256 p1,
2579         string memory p2
2580     ) internal view {
2581         _sendLogPayload(
2582             abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2)
2583         );
2584     }
2585 
2586     function log(
2587         address p0,
2588         uint256 p1,
2589         bool p2
2590     ) internal view {
2591         _sendLogPayload(
2592             abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2)
2593         );
2594     }
2595 
2596     function log(
2597         address p0,
2598         uint256 p1,
2599         address p2
2600     ) internal view {
2601         _sendLogPayload(
2602             abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2)
2603         );
2604     }
2605 
2606     function log(
2607         address p0,
2608         string memory p1,
2609         uint256 p2
2610     ) internal view {
2611         _sendLogPayload(
2612             abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2)
2613         );
2614     }
2615 
2616     function log(
2617         address p0,
2618         string memory p1,
2619         string memory p2
2620     ) internal view {
2621         _sendLogPayload(
2622             abi.encodeWithSignature("log(address,string,string)", p0, p1, p2)
2623         );
2624     }
2625 
2626     function log(
2627         address p0,
2628         string memory p1,
2629         bool p2
2630     ) internal view {
2631         _sendLogPayload(
2632             abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2)
2633         );
2634     }
2635 
2636     function log(
2637         address p0,
2638         string memory p1,
2639         address p2
2640     ) internal view {
2641         _sendLogPayload(
2642             abi.encodeWithSignature("log(address,string,address)", p0, p1, p2)
2643         );
2644     }
2645 
2646     function log(
2647         address p0,
2648         bool p1,
2649         uint256 p2
2650     ) internal view {
2651         _sendLogPayload(
2652             abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2)
2653         );
2654     }
2655 
2656     function log(
2657         address p0,
2658         bool p1,
2659         string memory p2
2660     ) internal view {
2661         _sendLogPayload(
2662             abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2)
2663         );
2664     }
2665 
2666     function log(
2667         address p0,
2668         bool p1,
2669         bool p2
2670     ) internal view {
2671         _sendLogPayload(
2672             abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2)
2673         );
2674     }
2675 
2676     function log(
2677         address p0,
2678         bool p1,
2679         address p2
2680     ) internal view {
2681         _sendLogPayload(
2682             abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2)
2683         );
2684     }
2685 
2686     function log(
2687         address p0,
2688         address p1,
2689         uint256 p2
2690     ) internal view {
2691         _sendLogPayload(
2692             abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2)
2693         );
2694     }
2695 
2696     function log(
2697         address p0,
2698         address p1,
2699         string memory p2
2700     ) internal view {
2701         _sendLogPayload(
2702             abi.encodeWithSignature("log(address,address,string)", p0, p1, p2)
2703         );
2704     }
2705 
2706     function log(
2707         address p0,
2708         address p1,
2709         bool p2
2710     ) internal view {
2711         _sendLogPayload(
2712             abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2)
2713         );
2714     }
2715 
2716     function log(
2717         address p0,
2718         address p1,
2719         address p2
2720     ) internal view {
2721         _sendLogPayload(
2722             abi.encodeWithSignature("log(address,address,address)", p0, p1, p2)
2723         );
2724     }
2725 
2726     function log(
2727         uint256 p0,
2728         uint256 p1,
2729         uint256 p2,
2730         uint256 p3
2731     ) internal view {
2732         _sendLogPayload(
2733             abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3)
2734         );
2735     }
2736 
2737     function log(
2738         uint256 p0,
2739         uint256 p1,
2740         uint256 p2,
2741         string memory p3
2742     ) internal view {
2743         _sendLogPayload(
2744             abi.encodeWithSignature(
2745                 "log(uint,uint,uint,string)",
2746                 p0,
2747                 p1,
2748                 p2,
2749                 p3
2750             )
2751         );
2752     }
2753 
2754     function log(
2755         uint256 p0,
2756         uint256 p1,
2757         uint256 p2,
2758         bool p3
2759     ) internal view {
2760         _sendLogPayload(
2761             abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3)
2762         );
2763     }
2764 
2765     function log(
2766         uint256 p0,
2767         uint256 p1,
2768         uint256 p2,
2769         address p3
2770     ) internal view {
2771         _sendLogPayload(
2772             abi.encodeWithSignature(
2773                 "log(uint,uint,uint,address)",
2774                 p0,
2775                 p1,
2776                 p2,
2777                 p3
2778             )
2779         );
2780     }
2781 
2782     function log(
2783         uint256 p0,
2784         uint256 p1,
2785         string memory p2,
2786         uint256 p3
2787     ) internal view {
2788         _sendLogPayload(
2789             abi.encodeWithSignature(
2790                 "log(uint,uint,string,uint)",
2791                 p0,
2792                 p1,
2793                 p2,
2794                 p3
2795             )
2796         );
2797     }
2798 
2799     function log(
2800         uint256 p0,
2801         uint256 p1,
2802         string memory p2,
2803         string memory p3
2804     ) internal view {
2805         _sendLogPayload(
2806             abi.encodeWithSignature(
2807                 "log(uint,uint,string,string)",
2808                 p0,
2809                 p1,
2810                 p2,
2811                 p3
2812             )
2813         );
2814     }
2815 
2816     function log(
2817         uint256 p0,
2818         uint256 p1,
2819         string memory p2,
2820         bool p3
2821     ) internal view {
2822         _sendLogPayload(
2823             abi.encodeWithSignature(
2824                 "log(uint,uint,string,bool)",
2825                 p0,
2826                 p1,
2827                 p2,
2828                 p3
2829             )
2830         );
2831     }
2832 
2833     function log(
2834         uint256 p0,
2835         uint256 p1,
2836         string memory p2,
2837         address p3
2838     ) internal view {
2839         _sendLogPayload(
2840             abi.encodeWithSignature(
2841                 "log(uint,uint,string,address)",
2842                 p0,
2843                 p1,
2844                 p2,
2845                 p3
2846             )
2847         );
2848     }
2849 
2850     function log(
2851         uint256 p0,
2852         uint256 p1,
2853         bool p2,
2854         uint256 p3
2855     ) internal view {
2856         _sendLogPayload(
2857             abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3)
2858         );
2859     }
2860 
2861     function log(
2862         uint256 p0,
2863         uint256 p1,
2864         bool p2,
2865         string memory p3
2866     ) internal view {
2867         _sendLogPayload(
2868             abi.encodeWithSignature(
2869                 "log(uint,uint,bool,string)",
2870                 p0,
2871                 p1,
2872                 p2,
2873                 p3
2874             )
2875         );
2876     }
2877 
2878     function log(
2879         uint256 p0,
2880         uint256 p1,
2881         bool p2,
2882         bool p3
2883     ) internal view {
2884         _sendLogPayload(
2885             abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3)
2886         );
2887     }
2888 
2889     function log(
2890         uint256 p0,
2891         uint256 p1,
2892         bool p2,
2893         address p3
2894     ) internal view {
2895         _sendLogPayload(
2896             abi.encodeWithSignature(
2897                 "log(uint,uint,bool,address)",
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
2908         uint256 p1,
2909         address p2,
2910         uint256 p3
2911     ) internal view {
2912         _sendLogPayload(
2913             abi.encodeWithSignature(
2914                 "log(uint,uint,address,uint)",
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
2925         uint256 p1,
2926         address p2,
2927         string memory p3
2928     ) internal view {
2929         _sendLogPayload(
2930             abi.encodeWithSignature(
2931                 "log(uint,uint,address,string)",
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
2942         uint256 p1,
2943         address p2,
2944         bool p3
2945     ) internal view {
2946         _sendLogPayload(
2947             abi.encodeWithSignature(
2948                 "log(uint,uint,address,bool)",
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
2959         uint256 p1,
2960         address p2,
2961         address p3
2962     ) internal view {
2963         _sendLogPayload(
2964             abi.encodeWithSignature(
2965                 "log(uint,uint,address,address)",
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
2977         uint256 p2,
2978         uint256 p3
2979     ) internal view {
2980         _sendLogPayload(
2981             abi.encodeWithSignature(
2982                 "log(uint,string,uint,uint)",
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
2994         uint256 p2,
2995         string memory p3
2996     ) internal view {
2997         _sendLogPayload(
2998             abi.encodeWithSignature(
2999                 "log(uint,string,uint,string)",
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
3011         uint256 p2,
3012         bool p3
3013     ) internal view {
3014         _sendLogPayload(
3015             abi.encodeWithSignature(
3016                 "log(uint,string,uint,bool)",
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
3027         string memory p1,
3028         uint256 p2,
3029         address p3
3030     ) internal view {
3031         _sendLogPayload(
3032             abi.encodeWithSignature(
3033                 "log(uint,string,uint,address)",
3034                 p0,
3035                 p1,
3036                 p2,
3037                 p3
3038             )
3039         );
3040     }
3041 
3042     function log(
3043         uint256 p0,
3044         string memory p1,
3045         string memory p2,
3046         uint256 p3
3047     ) internal view {
3048         _sendLogPayload(
3049             abi.encodeWithSignature(
3050                 "log(uint,string,string,uint)",
3051                 p0,
3052                 p1,
3053                 p2,
3054                 p3
3055             )
3056         );
3057     }
3058 
3059     function log(
3060         uint256 p0,
3061         string memory p1,
3062         string memory p2,
3063         string memory p3
3064     ) internal view {
3065         _sendLogPayload(
3066             abi.encodeWithSignature(
3067                 "log(uint,string,string,string)",
3068                 p0,
3069                 p1,
3070                 p2,
3071                 p3
3072             )
3073         );
3074     }
3075 
3076     function log(
3077         uint256 p0,
3078         string memory p1,
3079         string memory p2,
3080         bool p3
3081     ) internal view {
3082         _sendLogPayload(
3083             abi.encodeWithSignature(
3084                 "log(uint,string,string,bool)",
3085                 p0,
3086                 p1,
3087                 p2,
3088                 p3
3089             )
3090         );
3091     }
3092 
3093     function log(
3094         uint256 p0,
3095         string memory p1,
3096         string memory p2,
3097         address p3
3098     ) internal view {
3099         _sendLogPayload(
3100             abi.encodeWithSignature(
3101                 "log(uint,string,string,address)",
3102                 p0,
3103                 p1,
3104                 p2,
3105                 p3
3106             )
3107         );
3108     }
3109 
3110     function log(
3111         uint256 p0,
3112         string memory p1,
3113         bool p2,
3114         uint256 p3
3115     ) internal view {
3116         _sendLogPayload(
3117             abi.encodeWithSignature(
3118                 "log(uint,string,bool,uint)",
3119                 p0,
3120                 p1,
3121                 p2,
3122                 p3
3123             )
3124         );
3125     }
3126 
3127     function log(
3128         uint256 p0,
3129         string memory p1,
3130         bool p2,
3131         string memory p3
3132     ) internal view {
3133         _sendLogPayload(
3134             abi.encodeWithSignature(
3135                 "log(uint,string,bool,string)",
3136                 p0,
3137                 p1,
3138                 p2,
3139                 p3
3140             )
3141         );
3142     }
3143 
3144     function log(
3145         uint256 p0,
3146         string memory p1,
3147         bool p2,
3148         bool p3
3149     ) internal view {
3150         _sendLogPayload(
3151             abi.encodeWithSignature(
3152                 "log(uint,string,bool,bool)",
3153                 p0,
3154                 p1,
3155                 p2,
3156                 p3
3157             )
3158         );
3159     }
3160 
3161     function log(
3162         uint256 p0,
3163         string memory p1,
3164         bool p2,
3165         address p3
3166     ) internal view {
3167         _sendLogPayload(
3168             abi.encodeWithSignature(
3169                 "log(uint,string,bool,address)",
3170                 p0,
3171                 p1,
3172                 p2,
3173                 p3
3174             )
3175         );
3176     }
3177 
3178     function log(
3179         uint256 p0,
3180         string memory p1,
3181         address p2,
3182         uint256 p3
3183     ) internal view {
3184         _sendLogPayload(
3185             abi.encodeWithSignature(
3186                 "log(uint,string,address,uint)",
3187                 p0,
3188                 p1,
3189                 p2,
3190                 p3
3191             )
3192         );
3193     }
3194 
3195     function log(
3196         uint256 p0,
3197         string memory p1,
3198         address p2,
3199         string memory p3
3200     ) internal view {
3201         _sendLogPayload(
3202             abi.encodeWithSignature(
3203                 "log(uint,string,address,string)",
3204                 p0,
3205                 p1,
3206                 p2,
3207                 p3
3208             )
3209         );
3210     }
3211 
3212     function log(
3213         uint256 p0,
3214         string memory p1,
3215         address p2,
3216         bool p3
3217     ) internal view {
3218         _sendLogPayload(
3219             abi.encodeWithSignature(
3220                 "log(uint,string,address,bool)",
3221                 p0,
3222                 p1,
3223                 p2,
3224                 p3
3225             )
3226         );
3227     }
3228 
3229     function log(
3230         uint256 p0,
3231         string memory p1,
3232         address p2,
3233         address p3
3234     ) internal view {
3235         _sendLogPayload(
3236             abi.encodeWithSignature(
3237                 "log(uint,string,address,address)",
3238                 p0,
3239                 p1,
3240                 p2,
3241                 p3
3242             )
3243         );
3244     }
3245 
3246     function log(
3247         uint256 p0,
3248         bool p1,
3249         uint256 p2,
3250         uint256 p3
3251     ) internal view {
3252         _sendLogPayload(
3253             abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3)
3254         );
3255     }
3256 
3257     function log(
3258         uint256 p0,
3259         bool p1,
3260         uint256 p2,
3261         string memory p3
3262     ) internal view {
3263         _sendLogPayload(
3264             abi.encodeWithSignature(
3265                 "log(uint,bool,uint,string)",
3266                 p0,
3267                 p1,
3268                 p2,
3269                 p3
3270             )
3271         );
3272     }
3273 
3274     function log(
3275         uint256 p0,
3276         bool p1,
3277         uint256 p2,
3278         bool p3
3279     ) internal view {
3280         _sendLogPayload(
3281             abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3)
3282         );
3283     }
3284 
3285     function log(
3286         uint256 p0,
3287         bool p1,
3288         uint256 p2,
3289         address p3
3290     ) internal view {
3291         _sendLogPayload(
3292             abi.encodeWithSignature(
3293                 "log(uint,bool,uint,address)",
3294                 p0,
3295                 p1,
3296                 p2,
3297                 p3
3298             )
3299         );
3300     }
3301 
3302     function log(
3303         uint256 p0,
3304         bool p1,
3305         string memory p2,
3306         uint256 p3
3307     ) internal view {
3308         _sendLogPayload(
3309             abi.encodeWithSignature(
3310                 "log(uint,bool,string,uint)",
3311                 p0,
3312                 p1,
3313                 p2,
3314                 p3
3315             )
3316         );
3317     }
3318 
3319     function log(
3320         uint256 p0,
3321         bool p1,
3322         string memory p2,
3323         string memory p3
3324     ) internal view {
3325         _sendLogPayload(
3326             abi.encodeWithSignature(
3327                 "log(uint,bool,string,string)",
3328                 p0,
3329                 p1,
3330                 p2,
3331                 p3
3332             )
3333         );
3334     }
3335 
3336     function log(
3337         uint256 p0,
3338         bool p1,
3339         string memory p2,
3340         bool p3
3341     ) internal view {
3342         _sendLogPayload(
3343             abi.encodeWithSignature(
3344                 "log(uint,bool,string,bool)",
3345                 p0,
3346                 p1,
3347                 p2,
3348                 p3
3349             )
3350         );
3351     }
3352 
3353     function log(
3354         uint256 p0,
3355         bool p1,
3356         string memory p2,
3357         address p3
3358     ) internal view {
3359         _sendLogPayload(
3360             abi.encodeWithSignature(
3361                 "log(uint,bool,string,address)",
3362                 p0,
3363                 p1,
3364                 p2,
3365                 p3
3366             )
3367         );
3368     }
3369 
3370     function log(
3371         uint256 p0,
3372         bool p1,
3373         bool p2,
3374         uint256 p3
3375     ) internal view {
3376         _sendLogPayload(
3377             abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3)
3378         );
3379     }
3380 
3381     function log(
3382         uint256 p0,
3383         bool p1,
3384         bool p2,
3385         string memory p3
3386     ) internal view {
3387         _sendLogPayload(
3388             abi.encodeWithSignature(
3389                 "log(uint,bool,bool,string)",
3390                 p0,
3391                 p1,
3392                 p2,
3393                 p3
3394             )
3395         );
3396     }
3397 
3398     function log(
3399         uint256 p0,
3400         bool p1,
3401         bool p2,
3402         bool p3
3403     ) internal view {
3404         _sendLogPayload(
3405             abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3)
3406         );
3407     }
3408 
3409     function log(
3410         uint256 p0,
3411         bool p1,
3412         bool p2,
3413         address p3
3414     ) internal view {
3415         _sendLogPayload(
3416             abi.encodeWithSignature(
3417                 "log(uint,bool,bool,address)",
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
3428         bool p1,
3429         address p2,
3430         uint256 p3
3431     ) internal view {
3432         _sendLogPayload(
3433             abi.encodeWithSignature(
3434                 "log(uint,bool,address,uint)",
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
3445         bool p1,
3446         address p2,
3447         string memory p3
3448     ) internal view {
3449         _sendLogPayload(
3450             abi.encodeWithSignature(
3451                 "log(uint,bool,address,string)",
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
3462         bool p1,
3463         address p2,
3464         bool p3
3465     ) internal view {
3466         _sendLogPayload(
3467             abi.encodeWithSignature(
3468                 "log(uint,bool,address,bool)",
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
3479         bool p1,
3480         address p2,
3481         address p3
3482     ) internal view {
3483         _sendLogPayload(
3484             abi.encodeWithSignature(
3485                 "log(uint,bool,address,address)",
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
3497         uint256 p2,
3498         uint256 p3
3499     ) internal view {
3500         _sendLogPayload(
3501             abi.encodeWithSignature(
3502                 "log(uint,address,uint,uint)",
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
3514         uint256 p2,
3515         string memory p3
3516     ) internal view {
3517         _sendLogPayload(
3518             abi.encodeWithSignature(
3519                 "log(uint,address,uint,string)",
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
3531         uint256 p2,
3532         bool p3
3533     ) internal view {
3534         _sendLogPayload(
3535             abi.encodeWithSignature(
3536                 "log(uint,address,uint,bool)",
3537                 p0,
3538                 p1,
3539                 p2,
3540                 p3
3541             )
3542         );
3543     }
3544 
3545     function log(
3546         uint256 p0,
3547         address p1,
3548         uint256 p2,
3549         address p3
3550     ) internal view {
3551         _sendLogPayload(
3552             abi.encodeWithSignature(
3553                 "log(uint,address,uint,address)",
3554                 p0,
3555                 p1,
3556                 p2,
3557                 p3
3558             )
3559         );
3560     }
3561 
3562     function log(
3563         uint256 p0,
3564         address p1,
3565         string memory p2,
3566         uint256 p3
3567     ) internal view {
3568         _sendLogPayload(
3569             abi.encodeWithSignature(
3570                 "log(uint,address,string,uint)",
3571                 p0,
3572                 p1,
3573                 p2,
3574                 p3
3575             )
3576         );
3577     }
3578 
3579     function log(
3580         uint256 p0,
3581         address p1,
3582         string memory p2,
3583         string memory p3
3584     ) internal view {
3585         _sendLogPayload(
3586             abi.encodeWithSignature(
3587                 "log(uint,address,string,string)",
3588                 p0,
3589                 p1,
3590                 p2,
3591                 p3
3592             )
3593         );
3594     }
3595 
3596     function log(
3597         uint256 p0,
3598         address p1,
3599         string memory p2,
3600         bool p3
3601     ) internal view {
3602         _sendLogPayload(
3603             abi.encodeWithSignature(
3604                 "log(uint,address,string,bool)",
3605                 p0,
3606                 p1,
3607                 p2,
3608                 p3
3609             )
3610         );
3611     }
3612 
3613     function log(
3614         uint256 p0,
3615         address p1,
3616         string memory p2,
3617         address p3
3618     ) internal view {
3619         _sendLogPayload(
3620             abi.encodeWithSignature(
3621                 "log(uint,address,string,address)",
3622                 p0,
3623                 p1,
3624                 p2,
3625                 p3
3626             )
3627         );
3628     }
3629 
3630     function log(
3631         uint256 p0,
3632         address p1,
3633         bool p2,
3634         uint256 p3
3635     ) internal view {
3636         _sendLogPayload(
3637             abi.encodeWithSignature(
3638                 "log(uint,address,bool,uint)",
3639                 p0,
3640                 p1,
3641                 p2,
3642                 p3
3643             )
3644         );
3645     }
3646 
3647     function log(
3648         uint256 p0,
3649         address p1,
3650         bool p2,
3651         string memory p3
3652     ) internal view {
3653         _sendLogPayload(
3654             abi.encodeWithSignature(
3655                 "log(uint,address,bool,string)",
3656                 p0,
3657                 p1,
3658                 p2,
3659                 p3
3660             )
3661         );
3662     }
3663 
3664     function log(
3665         uint256 p0,
3666         address p1,
3667         bool p2,
3668         bool p3
3669     ) internal view {
3670         _sendLogPayload(
3671             abi.encodeWithSignature(
3672                 "log(uint,address,bool,bool)",
3673                 p0,
3674                 p1,
3675                 p2,
3676                 p3
3677             )
3678         );
3679     }
3680 
3681     function log(
3682         uint256 p0,
3683         address p1,
3684         bool p2,
3685         address p3
3686     ) internal view {
3687         _sendLogPayload(
3688             abi.encodeWithSignature(
3689                 "log(uint,address,bool,address)",
3690                 p0,
3691                 p1,
3692                 p2,
3693                 p3
3694             )
3695         );
3696     }
3697 
3698     function log(
3699         uint256 p0,
3700         address p1,
3701         address p2,
3702         uint256 p3
3703     ) internal view {
3704         _sendLogPayload(
3705             abi.encodeWithSignature(
3706                 "log(uint,address,address,uint)",
3707                 p0,
3708                 p1,
3709                 p2,
3710                 p3
3711             )
3712         );
3713     }
3714 
3715     function log(
3716         uint256 p0,
3717         address p1,
3718         address p2,
3719         string memory p3
3720     ) internal view {
3721         _sendLogPayload(
3722             abi.encodeWithSignature(
3723                 "log(uint,address,address,string)",
3724                 p0,
3725                 p1,
3726                 p2,
3727                 p3
3728             )
3729         );
3730     }
3731 
3732     function log(
3733         uint256 p0,
3734         address p1,
3735         address p2,
3736         bool p3
3737     ) internal view {
3738         _sendLogPayload(
3739             abi.encodeWithSignature(
3740                 "log(uint,address,address,bool)",
3741                 p0,
3742                 p1,
3743                 p2,
3744                 p3
3745             )
3746         );
3747     }
3748 
3749     function log(
3750         uint256 p0,
3751         address p1,
3752         address p2,
3753         address p3
3754     ) internal view {
3755         _sendLogPayload(
3756             abi.encodeWithSignature(
3757                 "log(uint,address,address,address)",
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
3769         uint256 p2,
3770         uint256 p3
3771     ) internal view {
3772         _sendLogPayload(
3773             abi.encodeWithSignature(
3774                 "log(string,uint,uint,uint)",
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
3786         uint256 p2,
3787         string memory p3
3788     ) internal view {
3789         _sendLogPayload(
3790             abi.encodeWithSignature(
3791                 "log(string,uint,uint,string)",
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
3803         uint256 p2,
3804         bool p3
3805     ) internal view {
3806         _sendLogPayload(
3807             abi.encodeWithSignature(
3808                 "log(string,uint,uint,bool)",
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
3819         uint256 p1,
3820         uint256 p2,
3821         address p3
3822     ) internal view {
3823         _sendLogPayload(
3824             abi.encodeWithSignature(
3825                 "log(string,uint,uint,address)",
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
3836         uint256 p1,
3837         string memory p2,
3838         uint256 p3
3839     ) internal view {
3840         _sendLogPayload(
3841             abi.encodeWithSignature(
3842                 "log(string,uint,string,uint)",
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
3853         uint256 p1,
3854         string memory p2,
3855         string memory p3
3856     ) internal view {
3857         _sendLogPayload(
3858             abi.encodeWithSignature(
3859                 "log(string,uint,string,string)",
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
3870         uint256 p1,
3871         string memory p2,
3872         bool p3
3873     ) internal view {
3874         _sendLogPayload(
3875             abi.encodeWithSignature(
3876                 "log(string,uint,string,bool)",
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
3887         uint256 p1,
3888         string memory p2,
3889         address p3
3890     ) internal view {
3891         _sendLogPayload(
3892             abi.encodeWithSignature(
3893                 "log(string,uint,string,address)",
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
3904         uint256 p1,
3905         bool p2,
3906         uint256 p3
3907     ) internal view {
3908         _sendLogPayload(
3909             abi.encodeWithSignature(
3910                 "log(string,uint,bool,uint)",
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
3921         uint256 p1,
3922         bool p2,
3923         string memory p3
3924     ) internal view {
3925         _sendLogPayload(
3926             abi.encodeWithSignature(
3927                 "log(string,uint,bool,string)",
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
3938         uint256 p1,
3939         bool p2,
3940         bool p3
3941     ) internal view {
3942         _sendLogPayload(
3943             abi.encodeWithSignature(
3944                 "log(string,uint,bool,bool)",
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
3955         uint256 p1,
3956         bool p2,
3957         address p3
3958     ) internal view {
3959         _sendLogPayload(
3960             abi.encodeWithSignature(
3961                 "log(string,uint,bool,address)",
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
3972         uint256 p1,
3973         address p2,
3974         uint256 p3
3975     ) internal view {
3976         _sendLogPayload(
3977             abi.encodeWithSignature(
3978                 "log(string,uint,address,uint)",
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
3989         uint256 p1,
3990         address p2,
3991         string memory p3
3992     ) internal view {
3993         _sendLogPayload(
3994             abi.encodeWithSignature(
3995                 "log(string,uint,address,string)",
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
4006         uint256 p1,
4007         address p2,
4008         bool p3
4009     ) internal view {
4010         _sendLogPayload(
4011             abi.encodeWithSignature(
4012                 "log(string,uint,address,bool)",
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
4023         uint256 p1,
4024         address p2,
4025         address p3
4026     ) internal view {
4027         _sendLogPayload(
4028             abi.encodeWithSignature(
4029                 "log(string,uint,address,address)",
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
4041         uint256 p2,
4042         uint256 p3
4043     ) internal view {
4044         _sendLogPayload(
4045             abi.encodeWithSignature(
4046                 "log(string,string,uint,uint)",
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
4058         uint256 p2,
4059         string memory p3
4060     ) internal view {
4061         _sendLogPayload(
4062             abi.encodeWithSignature(
4063                 "log(string,string,uint,string)",
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
4075         uint256 p2,
4076         bool p3
4077     ) internal view {
4078         _sendLogPayload(
4079             abi.encodeWithSignature(
4080                 "log(string,string,uint,bool)",
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
4091         string memory p1,
4092         uint256 p2,
4093         address p3
4094     ) internal view {
4095         _sendLogPayload(
4096             abi.encodeWithSignature(
4097                 "log(string,string,uint,address)",
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
4108         string memory p1,
4109         string memory p2,
4110         uint256 p3
4111     ) internal view {
4112         _sendLogPayload(
4113             abi.encodeWithSignature(
4114                 "log(string,string,string,uint)",
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
4125         string memory p1,
4126         string memory p2,
4127         string memory p3
4128     ) internal view {
4129         _sendLogPayload(
4130             abi.encodeWithSignature(
4131                 "log(string,string,string,string)",
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
4142         string memory p1,
4143         string memory p2,
4144         bool p3
4145     ) internal view {
4146         _sendLogPayload(
4147             abi.encodeWithSignature(
4148                 "log(string,string,string,bool)",
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
4159         string memory p1,
4160         string memory p2,
4161         address p3
4162     ) internal view {
4163         _sendLogPayload(
4164             abi.encodeWithSignature(
4165                 "log(string,string,string,address)",
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
4176         string memory p1,
4177         bool p2,
4178         uint256 p3
4179     ) internal view {
4180         _sendLogPayload(
4181             abi.encodeWithSignature(
4182                 "log(string,string,bool,uint)",
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
4193         string memory p1,
4194         bool p2,
4195         string memory p3
4196     ) internal view {
4197         _sendLogPayload(
4198             abi.encodeWithSignature(
4199                 "log(string,string,bool,string)",
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
4210         string memory p1,
4211         bool p2,
4212         bool p3
4213     ) internal view {
4214         _sendLogPayload(
4215             abi.encodeWithSignature(
4216                 "log(string,string,bool,bool)",
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
4227         string memory p1,
4228         bool p2,
4229         address p3
4230     ) internal view {
4231         _sendLogPayload(
4232             abi.encodeWithSignature(
4233                 "log(string,string,bool,address)",
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
4244         string memory p1,
4245         address p2,
4246         uint256 p3
4247     ) internal view {
4248         _sendLogPayload(
4249             abi.encodeWithSignature(
4250                 "log(string,string,address,uint)",
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
4261         string memory p1,
4262         address p2,
4263         string memory p3
4264     ) internal view {
4265         _sendLogPayload(
4266             abi.encodeWithSignature(
4267                 "log(string,string,address,string)",
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
4278         string memory p1,
4279         address p2,
4280         bool p3
4281     ) internal view {
4282         _sendLogPayload(
4283             abi.encodeWithSignature(
4284                 "log(string,string,address,bool)",
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
4295         string memory p1,
4296         address p2,
4297         address p3
4298     ) internal view {
4299         _sendLogPayload(
4300             abi.encodeWithSignature(
4301                 "log(string,string,address,address)",
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
4313         uint256 p2,
4314         uint256 p3
4315     ) internal view {
4316         _sendLogPayload(
4317             abi.encodeWithSignature(
4318                 "log(string,bool,uint,uint)",
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
4330         uint256 p2,
4331         string memory p3
4332     ) internal view {
4333         _sendLogPayload(
4334             abi.encodeWithSignature(
4335                 "log(string,bool,uint,string)",
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
4347         uint256 p2,
4348         bool p3
4349     ) internal view {
4350         _sendLogPayload(
4351             abi.encodeWithSignature(
4352                 "log(string,bool,uint,bool)",
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
4363         bool p1,
4364         uint256 p2,
4365         address p3
4366     ) internal view {
4367         _sendLogPayload(
4368             abi.encodeWithSignature(
4369                 "log(string,bool,uint,address)",
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
4380         bool p1,
4381         string memory p2,
4382         uint256 p3
4383     ) internal view {
4384         _sendLogPayload(
4385             abi.encodeWithSignature(
4386                 "log(string,bool,string,uint)",
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
4397         bool p1,
4398         string memory p2,
4399         string memory p3
4400     ) internal view {
4401         _sendLogPayload(
4402             abi.encodeWithSignature(
4403                 "log(string,bool,string,string)",
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
4414         bool p1,
4415         string memory p2,
4416         bool p3
4417     ) internal view {
4418         _sendLogPayload(
4419             abi.encodeWithSignature(
4420                 "log(string,bool,string,bool)",
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
4431         bool p1,
4432         string memory p2,
4433         address p3
4434     ) internal view {
4435         _sendLogPayload(
4436             abi.encodeWithSignature(
4437                 "log(string,bool,string,address)",
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
4448         bool p1,
4449         bool p2,
4450         uint256 p3
4451     ) internal view {
4452         _sendLogPayload(
4453             abi.encodeWithSignature(
4454                 "log(string,bool,bool,uint)",
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
4465         bool p1,
4466         bool p2,
4467         string memory p3
4468     ) internal view {
4469         _sendLogPayload(
4470             abi.encodeWithSignature(
4471                 "log(string,bool,bool,string)",
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
4482         bool p1,
4483         bool p2,
4484         bool p3
4485     ) internal view {
4486         _sendLogPayload(
4487             abi.encodeWithSignature(
4488                 "log(string,bool,bool,bool)",
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
4499         bool p1,
4500         bool p2,
4501         address p3
4502     ) internal view {
4503         _sendLogPayload(
4504             abi.encodeWithSignature(
4505                 "log(string,bool,bool,address)",
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
4516         bool p1,
4517         address p2,
4518         uint256 p3
4519     ) internal view {
4520         _sendLogPayload(
4521             abi.encodeWithSignature(
4522                 "log(string,bool,address,uint)",
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
4533         bool p1,
4534         address p2,
4535         string memory p3
4536     ) internal view {
4537         _sendLogPayload(
4538             abi.encodeWithSignature(
4539                 "log(string,bool,address,string)",
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
4550         bool p1,
4551         address p2,
4552         bool p3
4553     ) internal view {
4554         _sendLogPayload(
4555             abi.encodeWithSignature(
4556                 "log(string,bool,address,bool)",
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
4567         bool p1,
4568         address p2,
4569         address p3
4570     ) internal view {
4571         _sendLogPayload(
4572             abi.encodeWithSignature(
4573                 "log(string,bool,address,address)",
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
4585         uint256 p2,
4586         uint256 p3
4587     ) internal view {
4588         _sendLogPayload(
4589             abi.encodeWithSignature(
4590                 "log(string,address,uint,uint)",
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
4602         uint256 p2,
4603         string memory p3
4604     ) internal view {
4605         _sendLogPayload(
4606             abi.encodeWithSignature(
4607                 "log(string,address,uint,string)",
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
4619         uint256 p2,
4620         bool p3
4621     ) internal view {
4622         _sendLogPayload(
4623             abi.encodeWithSignature(
4624                 "log(string,address,uint,bool)",
4625                 p0,
4626                 p1,
4627                 p2,
4628                 p3
4629             )
4630         );
4631     }
4632 
4633     function log(
4634         string memory p0,
4635         address p1,
4636         uint256 p2,
4637         address p3
4638     ) internal view {
4639         _sendLogPayload(
4640             abi.encodeWithSignature(
4641                 "log(string,address,uint,address)",
4642                 p0,
4643                 p1,
4644                 p2,
4645                 p3
4646             )
4647         );
4648     }
4649 
4650     function log(
4651         string memory p0,
4652         address p1,
4653         string memory p2,
4654         uint256 p3
4655     ) internal view {
4656         _sendLogPayload(
4657             abi.encodeWithSignature(
4658                 "log(string,address,string,uint)",
4659                 p0,
4660                 p1,
4661                 p2,
4662                 p3
4663             )
4664         );
4665     }
4666 
4667     function log(
4668         string memory p0,
4669         address p1,
4670         string memory p2,
4671         string memory p3
4672     ) internal view {
4673         _sendLogPayload(
4674             abi.encodeWithSignature(
4675                 "log(string,address,string,string)",
4676                 p0,
4677                 p1,
4678                 p2,
4679                 p3
4680             )
4681         );
4682     }
4683 
4684     function log(
4685         string memory p0,
4686         address p1,
4687         string memory p2,
4688         bool p3
4689     ) internal view {
4690         _sendLogPayload(
4691             abi.encodeWithSignature(
4692                 "log(string,address,string,bool)",
4693                 p0,
4694                 p1,
4695                 p2,
4696                 p3
4697             )
4698         );
4699     }
4700 
4701     function log(
4702         string memory p0,
4703         address p1,
4704         string memory p2,
4705         address p3
4706     ) internal view {
4707         _sendLogPayload(
4708             abi.encodeWithSignature(
4709                 "log(string,address,string,address)",
4710                 p0,
4711                 p1,
4712                 p2,
4713                 p3
4714             )
4715         );
4716     }
4717 
4718     function log(
4719         string memory p0,
4720         address p1,
4721         bool p2,
4722         uint256 p3
4723     ) internal view {
4724         _sendLogPayload(
4725             abi.encodeWithSignature(
4726                 "log(string,address,bool,uint)",
4727                 p0,
4728                 p1,
4729                 p2,
4730                 p3
4731             )
4732         );
4733     }
4734 
4735     function log(
4736         string memory p0,
4737         address p1,
4738         bool p2,
4739         string memory p3
4740     ) internal view {
4741         _sendLogPayload(
4742             abi.encodeWithSignature(
4743                 "log(string,address,bool,string)",
4744                 p0,
4745                 p1,
4746                 p2,
4747                 p3
4748             )
4749         );
4750     }
4751 
4752     function log(
4753         string memory p0,
4754         address p1,
4755         bool p2,
4756         bool p3
4757     ) internal view {
4758         _sendLogPayload(
4759             abi.encodeWithSignature(
4760                 "log(string,address,bool,bool)",
4761                 p0,
4762                 p1,
4763                 p2,
4764                 p3
4765             )
4766         );
4767     }
4768 
4769     function log(
4770         string memory p0,
4771         address p1,
4772         bool p2,
4773         address p3
4774     ) internal view {
4775         _sendLogPayload(
4776             abi.encodeWithSignature(
4777                 "log(string,address,bool,address)",
4778                 p0,
4779                 p1,
4780                 p2,
4781                 p3
4782             )
4783         );
4784     }
4785 
4786     function log(
4787         string memory p0,
4788         address p1,
4789         address p2,
4790         uint256 p3
4791     ) internal view {
4792         _sendLogPayload(
4793             abi.encodeWithSignature(
4794                 "log(string,address,address,uint)",
4795                 p0,
4796                 p1,
4797                 p2,
4798                 p3
4799             )
4800         );
4801     }
4802 
4803     function log(
4804         string memory p0,
4805         address p1,
4806         address p2,
4807         string memory p3
4808     ) internal view {
4809         _sendLogPayload(
4810             abi.encodeWithSignature(
4811                 "log(string,address,address,string)",
4812                 p0,
4813                 p1,
4814                 p2,
4815                 p3
4816             )
4817         );
4818     }
4819 
4820     function log(
4821         string memory p0,
4822         address p1,
4823         address p2,
4824         bool p3
4825     ) internal view {
4826         _sendLogPayload(
4827             abi.encodeWithSignature(
4828                 "log(string,address,address,bool)",
4829                 p0,
4830                 p1,
4831                 p2,
4832                 p3
4833             )
4834         );
4835     }
4836 
4837     function log(
4838         string memory p0,
4839         address p1,
4840         address p2,
4841         address p3
4842     ) internal view {
4843         _sendLogPayload(
4844             abi.encodeWithSignature(
4845                 "log(string,address,address,address)",
4846                 p0,
4847                 p1,
4848                 p2,
4849                 p3
4850             )
4851         );
4852     }
4853 
4854     function log(
4855         bool p0,
4856         uint256 p1,
4857         uint256 p2,
4858         uint256 p3
4859     ) internal view {
4860         _sendLogPayload(
4861             abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3)
4862         );
4863     }
4864 
4865     function log(
4866         bool p0,
4867         uint256 p1,
4868         uint256 p2,
4869         string memory p3
4870     ) internal view {
4871         _sendLogPayload(
4872             abi.encodeWithSignature(
4873                 "log(bool,uint,uint,string)",
4874                 p0,
4875                 p1,
4876                 p2,
4877                 p3
4878             )
4879         );
4880     }
4881 
4882     function log(
4883         bool p0,
4884         uint256 p1,
4885         uint256 p2,
4886         bool p3
4887     ) internal view {
4888         _sendLogPayload(
4889             abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3)
4890         );
4891     }
4892 
4893     function log(
4894         bool p0,
4895         uint256 p1,
4896         uint256 p2,
4897         address p3
4898     ) internal view {
4899         _sendLogPayload(
4900             abi.encodeWithSignature(
4901                 "log(bool,uint,uint,address)",
4902                 p0,
4903                 p1,
4904                 p2,
4905                 p3
4906             )
4907         );
4908     }
4909 
4910     function log(
4911         bool p0,
4912         uint256 p1,
4913         string memory p2,
4914         uint256 p3
4915     ) internal view {
4916         _sendLogPayload(
4917             abi.encodeWithSignature(
4918                 "log(bool,uint,string,uint)",
4919                 p0,
4920                 p1,
4921                 p2,
4922                 p3
4923             )
4924         );
4925     }
4926 
4927     function log(
4928         bool p0,
4929         uint256 p1,
4930         string memory p2,
4931         string memory p3
4932     ) internal view {
4933         _sendLogPayload(
4934             abi.encodeWithSignature(
4935                 "log(bool,uint,string,string)",
4936                 p0,
4937                 p1,
4938                 p2,
4939                 p3
4940             )
4941         );
4942     }
4943 
4944     function log(
4945         bool p0,
4946         uint256 p1,
4947         string memory p2,
4948         bool p3
4949     ) internal view {
4950         _sendLogPayload(
4951             abi.encodeWithSignature(
4952                 "log(bool,uint,string,bool)",
4953                 p0,
4954                 p1,
4955                 p2,
4956                 p3
4957             )
4958         );
4959     }
4960 
4961     function log(
4962         bool p0,
4963         uint256 p1,
4964         string memory p2,
4965         address p3
4966     ) internal view {
4967         _sendLogPayload(
4968             abi.encodeWithSignature(
4969                 "log(bool,uint,string,address)",
4970                 p0,
4971                 p1,
4972                 p2,
4973                 p3
4974             )
4975         );
4976     }
4977 
4978     function log(
4979         bool p0,
4980         uint256 p1,
4981         bool p2,
4982         uint256 p3
4983     ) internal view {
4984         _sendLogPayload(
4985             abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3)
4986         );
4987     }
4988 
4989     function log(
4990         bool p0,
4991         uint256 p1,
4992         bool p2,
4993         string memory p3
4994     ) internal view {
4995         _sendLogPayload(
4996             abi.encodeWithSignature(
4997                 "log(bool,uint,bool,string)",
4998                 p0,
4999                 p1,
5000                 p2,
5001                 p3
5002             )
5003         );
5004     }
5005 
5006     function log(
5007         bool p0,
5008         uint256 p1,
5009         bool p2,
5010         bool p3
5011     ) internal view {
5012         _sendLogPayload(
5013             abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3)
5014         );
5015     }
5016 
5017     function log(
5018         bool p0,
5019         uint256 p1,
5020         bool p2,
5021         address p3
5022     ) internal view {
5023         _sendLogPayload(
5024             abi.encodeWithSignature(
5025                 "log(bool,uint,bool,address)",
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
5036         uint256 p1,
5037         address p2,
5038         uint256 p3
5039     ) internal view {
5040         _sendLogPayload(
5041             abi.encodeWithSignature(
5042                 "log(bool,uint,address,uint)",
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
5053         uint256 p1,
5054         address p2,
5055         string memory p3
5056     ) internal view {
5057         _sendLogPayload(
5058             abi.encodeWithSignature(
5059                 "log(bool,uint,address,string)",
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
5070         uint256 p1,
5071         address p2,
5072         bool p3
5073     ) internal view {
5074         _sendLogPayload(
5075             abi.encodeWithSignature(
5076                 "log(bool,uint,address,bool)",
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
5087         uint256 p1,
5088         address p2,
5089         address p3
5090     ) internal view {
5091         _sendLogPayload(
5092             abi.encodeWithSignature(
5093                 "log(bool,uint,address,address)",
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
5105         uint256 p2,
5106         uint256 p3
5107     ) internal view {
5108         _sendLogPayload(
5109             abi.encodeWithSignature(
5110                 "log(bool,string,uint,uint)",
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
5122         uint256 p2,
5123         string memory p3
5124     ) internal view {
5125         _sendLogPayload(
5126             abi.encodeWithSignature(
5127                 "log(bool,string,uint,string)",
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
5139         uint256 p2,
5140         bool p3
5141     ) internal view {
5142         _sendLogPayload(
5143             abi.encodeWithSignature(
5144                 "log(bool,string,uint,bool)",
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
5155         string memory p1,
5156         uint256 p2,
5157         address p3
5158     ) internal view {
5159         _sendLogPayload(
5160             abi.encodeWithSignature(
5161                 "log(bool,string,uint,address)",
5162                 p0,
5163                 p1,
5164                 p2,
5165                 p3
5166             )
5167         );
5168     }
5169 
5170     function log(
5171         bool p0,
5172         string memory p1,
5173         string memory p2,
5174         uint256 p3
5175     ) internal view {
5176         _sendLogPayload(
5177             abi.encodeWithSignature(
5178                 "log(bool,string,string,uint)",
5179                 p0,
5180                 p1,
5181                 p2,
5182                 p3
5183             )
5184         );
5185     }
5186 
5187     function log(
5188         bool p0,
5189         string memory p1,
5190         string memory p2,
5191         string memory p3
5192     ) internal view {
5193         _sendLogPayload(
5194             abi.encodeWithSignature(
5195                 "log(bool,string,string,string)",
5196                 p0,
5197                 p1,
5198                 p2,
5199                 p3
5200             )
5201         );
5202     }
5203 
5204     function log(
5205         bool p0,
5206         string memory p1,
5207         string memory p2,
5208         bool p3
5209     ) internal view {
5210         _sendLogPayload(
5211             abi.encodeWithSignature(
5212                 "log(bool,string,string,bool)",
5213                 p0,
5214                 p1,
5215                 p2,
5216                 p3
5217             )
5218         );
5219     }
5220 
5221     function log(
5222         bool p0,
5223         string memory p1,
5224         string memory p2,
5225         address p3
5226     ) internal view {
5227         _sendLogPayload(
5228             abi.encodeWithSignature(
5229                 "log(bool,string,string,address)",
5230                 p0,
5231                 p1,
5232                 p2,
5233                 p3
5234             )
5235         );
5236     }
5237 
5238     function log(
5239         bool p0,
5240         string memory p1,
5241         bool p2,
5242         uint256 p3
5243     ) internal view {
5244         _sendLogPayload(
5245             abi.encodeWithSignature(
5246                 "log(bool,string,bool,uint)",
5247                 p0,
5248                 p1,
5249                 p2,
5250                 p3
5251             )
5252         );
5253     }
5254 
5255     function log(
5256         bool p0,
5257         string memory p1,
5258         bool p2,
5259         string memory p3
5260     ) internal view {
5261         _sendLogPayload(
5262             abi.encodeWithSignature(
5263                 "log(bool,string,bool,string)",
5264                 p0,
5265                 p1,
5266                 p2,
5267                 p3
5268             )
5269         );
5270     }
5271 
5272     function log(
5273         bool p0,
5274         string memory p1,
5275         bool p2,
5276         bool p3
5277     ) internal view {
5278         _sendLogPayload(
5279             abi.encodeWithSignature(
5280                 "log(bool,string,bool,bool)",
5281                 p0,
5282                 p1,
5283                 p2,
5284                 p3
5285             )
5286         );
5287     }
5288 
5289     function log(
5290         bool p0,
5291         string memory p1,
5292         bool p2,
5293         address p3
5294     ) internal view {
5295         _sendLogPayload(
5296             abi.encodeWithSignature(
5297                 "log(bool,string,bool,address)",
5298                 p0,
5299                 p1,
5300                 p2,
5301                 p3
5302             )
5303         );
5304     }
5305 
5306     function log(
5307         bool p0,
5308         string memory p1,
5309         address p2,
5310         uint256 p3
5311     ) internal view {
5312         _sendLogPayload(
5313             abi.encodeWithSignature(
5314                 "log(bool,string,address,uint)",
5315                 p0,
5316                 p1,
5317                 p2,
5318                 p3
5319             )
5320         );
5321     }
5322 
5323     function log(
5324         bool p0,
5325         string memory p1,
5326         address p2,
5327         string memory p3
5328     ) internal view {
5329         _sendLogPayload(
5330             abi.encodeWithSignature(
5331                 "log(bool,string,address,string)",
5332                 p0,
5333                 p1,
5334                 p2,
5335                 p3
5336             )
5337         );
5338     }
5339 
5340     function log(
5341         bool p0,
5342         string memory p1,
5343         address p2,
5344         bool p3
5345     ) internal view {
5346         _sendLogPayload(
5347             abi.encodeWithSignature(
5348                 "log(bool,string,address,bool)",
5349                 p0,
5350                 p1,
5351                 p2,
5352                 p3
5353             )
5354         );
5355     }
5356 
5357     function log(
5358         bool p0,
5359         string memory p1,
5360         address p2,
5361         address p3
5362     ) internal view {
5363         _sendLogPayload(
5364             abi.encodeWithSignature(
5365                 "log(bool,string,address,address)",
5366                 p0,
5367                 p1,
5368                 p2,
5369                 p3
5370             )
5371         );
5372     }
5373 
5374     function log(
5375         bool p0,
5376         bool p1,
5377         uint256 p2,
5378         uint256 p3
5379     ) internal view {
5380         _sendLogPayload(
5381             abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3)
5382         );
5383     }
5384 
5385     function log(
5386         bool p0,
5387         bool p1,
5388         uint256 p2,
5389         string memory p3
5390     ) internal view {
5391         _sendLogPayload(
5392             abi.encodeWithSignature(
5393                 "log(bool,bool,uint,string)",
5394                 p0,
5395                 p1,
5396                 p2,
5397                 p3
5398             )
5399         );
5400     }
5401 
5402     function log(
5403         bool p0,
5404         bool p1,
5405         uint256 p2,
5406         bool p3
5407     ) internal view {
5408         _sendLogPayload(
5409             abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3)
5410         );
5411     }
5412 
5413     function log(
5414         bool p0,
5415         bool p1,
5416         uint256 p2,
5417         address p3
5418     ) internal view {
5419         _sendLogPayload(
5420             abi.encodeWithSignature(
5421                 "log(bool,bool,uint,address)",
5422                 p0,
5423                 p1,
5424                 p2,
5425                 p3
5426             )
5427         );
5428     }
5429 
5430     function log(
5431         bool p0,
5432         bool p1,
5433         string memory p2,
5434         uint256 p3
5435     ) internal view {
5436         _sendLogPayload(
5437             abi.encodeWithSignature(
5438                 "log(bool,bool,string,uint)",
5439                 p0,
5440                 p1,
5441                 p2,
5442                 p3
5443             )
5444         );
5445     }
5446 
5447     function log(
5448         bool p0,
5449         bool p1,
5450         string memory p2,
5451         string memory p3
5452     ) internal view {
5453         _sendLogPayload(
5454             abi.encodeWithSignature(
5455                 "log(bool,bool,string,string)",
5456                 p0,
5457                 p1,
5458                 p2,
5459                 p3
5460             )
5461         );
5462     }
5463 
5464     function log(
5465         bool p0,
5466         bool p1,
5467         string memory p2,
5468         bool p3
5469     ) internal view {
5470         _sendLogPayload(
5471             abi.encodeWithSignature(
5472                 "log(bool,bool,string,bool)",
5473                 p0,
5474                 p1,
5475                 p2,
5476                 p3
5477             )
5478         );
5479     }
5480 
5481     function log(
5482         bool p0,
5483         bool p1,
5484         string memory p2,
5485         address p3
5486     ) internal view {
5487         _sendLogPayload(
5488             abi.encodeWithSignature(
5489                 "log(bool,bool,string,address)",
5490                 p0,
5491                 p1,
5492                 p2,
5493                 p3
5494             )
5495         );
5496     }
5497 
5498     function log(
5499         bool p0,
5500         bool p1,
5501         bool p2,
5502         uint256 p3
5503     ) internal view {
5504         _sendLogPayload(
5505             abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3)
5506         );
5507     }
5508 
5509     function log(
5510         bool p0,
5511         bool p1,
5512         bool p2,
5513         string memory p3
5514     ) internal view {
5515         _sendLogPayload(
5516             abi.encodeWithSignature(
5517                 "log(bool,bool,bool,string)",
5518                 p0,
5519                 p1,
5520                 p2,
5521                 p3
5522             )
5523         );
5524     }
5525 
5526     function log(
5527         bool p0,
5528         bool p1,
5529         bool p2,
5530         bool p3
5531     ) internal view {
5532         _sendLogPayload(
5533             abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3)
5534         );
5535     }
5536 
5537     function log(
5538         bool p0,
5539         bool p1,
5540         bool p2,
5541         address p3
5542     ) internal view {
5543         _sendLogPayload(
5544             abi.encodeWithSignature(
5545                 "log(bool,bool,bool,address)",
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
5556         bool p1,
5557         address p2,
5558         uint256 p3
5559     ) internal view {
5560         _sendLogPayload(
5561             abi.encodeWithSignature(
5562                 "log(bool,bool,address,uint)",
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
5573         bool p1,
5574         address p2,
5575         string memory p3
5576     ) internal view {
5577         _sendLogPayload(
5578             abi.encodeWithSignature(
5579                 "log(bool,bool,address,string)",
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
5590         bool p1,
5591         address p2,
5592         bool p3
5593     ) internal view {
5594         _sendLogPayload(
5595             abi.encodeWithSignature(
5596                 "log(bool,bool,address,bool)",
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
5607         bool p1,
5608         address p2,
5609         address p3
5610     ) internal view {
5611         _sendLogPayload(
5612             abi.encodeWithSignature(
5613                 "log(bool,bool,address,address)",
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
5625         uint256 p2,
5626         uint256 p3
5627     ) internal view {
5628         _sendLogPayload(
5629             abi.encodeWithSignature(
5630                 "log(bool,address,uint,uint)",
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
5642         uint256 p2,
5643         string memory p3
5644     ) internal view {
5645         _sendLogPayload(
5646             abi.encodeWithSignature(
5647                 "log(bool,address,uint,string)",
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
5659         uint256 p2,
5660         bool p3
5661     ) internal view {
5662         _sendLogPayload(
5663             abi.encodeWithSignature(
5664                 "log(bool,address,uint,bool)",
5665                 p0,
5666                 p1,
5667                 p2,
5668                 p3
5669             )
5670         );
5671     }
5672 
5673     function log(
5674         bool p0,
5675         address p1,
5676         uint256 p2,
5677         address p3
5678     ) internal view {
5679         _sendLogPayload(
5680             abi.encodeWithSignature(
5681                 "log(bool,address,uint,address)",
5682                 p0,
5683                 p1,
5684                 p2,
5685                 p3
5686             )
5687         );
5688     }
5689 
5690     function log(
5691         bool p0,
5692         address p1,
5693         string memory p2,
5694         uint256 p3
5695     ) internal view {
5696         _sendLogPayload(
5697             abi.encodeWithSignature(
5698                 "log(bool,address,string,uint)",
5699                 p0,
5700                 p1,
5701                 p2,
5702                 p3
5703             )
5704         );
5705     }
5706 
5707     function log(
5708         bool p0,
5709         address p1,
5710         string memory p2,
5711         string memory p3
5712     ) internal view {
5713         _sendLogPayload(
5714             abi.encodeWithSignature(
5715                 "log(bool,address,string,string)",
5716                 p0,
5717                 p1,
5718                 p2,
5719                 p3
5720             )
5721         );
5722     }
5723 
5724     function log(
5725         bool p0,
5726         address p1,
5727         string memory p2,
5728         bool p3
5729     ) internal view {
5730         _sendLogPayload(
5731             abi.encodeWithSignature(
5732                 "log(bool,address,string,bool)",
5733                 p0,
5734                 p1,
5735                 p2,
5736                 p3
5737             )
5738         );
5739     }
5740 
5741     function log(
5742         bool p0,
5743         address p1,
5744         string memory p2,
5745         address p3
5746     ) internal view {
5747         _sendLogPayload(
5748             abi.encodeWithSignature(
5749                 "log(bool,address,string,address)",
5750                 p0,
5751                 p1,
5752                 p2,
5753                 p3
5754             )
5755         );
5756     }
5757 
5758     function log(
5759         bool p0,
5760         address p1,
5761         bool p2,
5762         uint256 p3
5763     ) internal view {
5764         _sendLogPayload(
5765             abi.encodeWithSignature(
5766                 "log(bool,address,bool,uint)",
5767                 p0,
5768                 p1,
5769                 p2,
5770                 p3
5771             )
5772         );
5773     }
5774 
5775     function log(
5776         bool p0,
5777         address p1,
5778         bool p2,
5779         string memory p3
5780     ) internal view {
5781         _sendLogPayload(
5782             abi.encodeWithSignature(
5783                 "log(bool,address,bool,string)",
5784                 p0,
5785                 p1,
5786                 p2,
5787                 p3
5788             )
5789         );
5790     }
5791 
5792     function log(
5793         bool p0,
5794         address p1,
5795         bool p2,
5796         bool p3
5797     ) internal view {
5798         _sendLogPayload(
5799             abi.encodeWithSignature(
5800                 "log(bool,address,bool,bool)",
5801                 p0,
5802                 p1,
5803                 p2,
5804                 p3
5805             )
5806         );
5807     }
5808 
5809     function log(
5810         bool p0,
5811         address p1,
5812         bool p2,
5813         address p3
5814     ) internal view {
5815         _sendLogPayload(
5816             abi.encodeWithSignature(
5817                 "log(bool,address,bool,address)",
5818                 p0,
5819                 p1,
5820                 p2,
5821                 p3
5822             )
5823         );
5824     }
5825 
5826     function log(
5827         bool p0,
5828         address p1,
5829         address p2,
5830         uint256 p3
5831     ) internal view {
5832         _sendLogPayload(
5833             abi.encodeWithSignature(
5834                 "log(bool,address,address,uint)",
5835                 p0,
5836                 p1,
5837                 p2,
5838                 p3
5839             )
5840         );
5841     }
5842 
5843     function log(
5844         bool p0,
5845         address p1,
5846         address p2,
5847         string memory p3
5848     ) internal view {
5849         _sendLogPayload(
5850             abi.encodeWithSignature(
5851                 "log(bool,address,address,string)",
5852                 p0,
5853                 p1,
5854                 p2,
5855                 p3
5856             )
5857         );
5858     }
5859 
5860     function log(
5861         bool p0,
5862         address p1,
5863         address p2,
5864         bool p3
5865     ) internal view {
5866         _sendLogPayload(
5867             abi.encodeWithSignature(
5868                 "log(bool,address,address,bool)",
5869                 p0,
5870                 p1,
5871                 p2,
5872                 p3
5873             )
5874         );
5875     }
5876 
5877     function log(
5878         bool p0,
5879         address p1,
5880         address p2,
5881         address p3
5882     ) internal view {
5883         _sendLogPayload(
5884             abi.encodeWithSignature(
5885                 "log(bool,address,address,address)",
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
5897         uint256 p2,
5898         uint256 p3
5899     ) internal view {
5900         _sendLogPayload(
5901             abi.encodeWithSignature(
5902                 "log(address,uint,uint,uint)",
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
5914         uint256 p2,
5915         string memory p3
5916     ) internal view {
5917         _sendLogPayload(
5918             abi.encodeWithSignature(
5919                 "log(address,uint,uint,string)",
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
5931         uint256 p2,
5932         bool p3
5933     ) internal view {
5934         _sendLogPayload(
5935             abi.encodeWithSignature(
5936                 "log(address,uint,uint,bool)",
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
5947         uint256 p1,
5948         uint256 p2,
5949         address p3
5950     ) internal view {
5951         _sendLogPayload(
5952             abi.encodeWithSignature(
5953                 "log(address,uint,uint,address)",
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
5964         uint256 p1,
5965         string memory p2,
5966         uint256 p3
5967     ) internal view {
5968         _sendLogPayload(
5969             abi.encodeWithSignature(
5970                 "log(address,uint,string,uint)",
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
5981         uint256 p1,
5982         string memory p2,
5983         string memory p3
5984     ) internal view {
5985         _sendLogPayload(
5986             abi.encodeWithSignature(
5987                 "log(address,uint,string,string)",
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
5998         uint256 p1,
5999         string memory p2,
6000         bool p3
6001     ) internal view {
6002         _sendLogPayload(
6003             abi.encodeWithSignature(
6004                 "log(address,uint,string,bool)",
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
6015         uint256 p1,
6016         string memory p2,
6017         address p3
6018     ) internal view {
6019         _sendLogPayload(
6020             abi.encodeWithSignature(
6021                 "log(address,uint,string,address)",
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
6032         uint256 p1,
6033         bool p2,
6034         uint256 p3
6035     ) internal view {
6036         _sendLogPayload(
6037             abi.encodeWithSignature(
6038                 "log(address,uint,bool,uint)",
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
6049         uint256 p1,
6050         bool p2,
6051         string memory p3
6052     ) internal view {
6053         _sendLogPayload(
6054             abi.encodeWithSignature(
6055                 "log(address,uint,bool,string)",
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
6066         uint256 p1,
6067         bool p2,
6068         bool p3
6069     ) internal view {
6070         _sendLogPayload(
6071             abi.encodeWithSignature(
6072                 "log(address,uint,bool,bool)",
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
6083         uint256 p1,
6084         bool p2,
6085         address p3
6086     ) internal view {
6087         _sendLogPayload(
6088             abi.encodeWithSignature(
6089                 "log(address,uint,bool,address)",
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
6100         uint256 p1,
6101         address p2,
6102         uint256 p3
6103     ) internal view {
6104         _sendLogPayload(
6105             abi.encodeWithSignature(
6106                 "log(address,uint,address,uint)",
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
6117         uint256 p1,
6118         address p2,
6119         string memory p3
6120     ) internal view {
6121         _sendLogPayload(
6122             abi.encodeWithSignature(
6123                 "log(address,uint,address,string)",
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
6134         uint256 p1,
6135         address p2,
6136         bool p3
6137     ) internal view {
6138         _sendLogPayload(
6139             abi.encodeWithSignature(
6140                 "log(address,uint,address,bool)",
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
6151         uint256 p1,
6152         address p2,
6153         address p3
6154     ) internal view {
6155         _sendLogPayload(
6156             abi.encodeWithSignature(
6157                 "log(address,uint,address,address)",
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
6169         uint256 p2,
6170         uint256 p3
6171     ) internal view {
6172         _sendLogPayload(
6173             abi.encodeWithSignature(
6174                 "log(address,string,uint,uint)",
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
6186         uint256 p2,
6187         string memory p3
6188     ) internal view {
6189         _sendLogPayload(
6190             abi.encodeWithSignature(
6191                 "log(address,string,uint,string)",
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
6203         uint256 p2,
6204         bool p3
6205     ) internal view {
6206         _sendLogPayload(
6207             abi.encodeWithSignature(
6208                 "log(address,string,uint,bool)",
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
6219         string memory p1,
6220         uint256 p2,
6221         address p3
6222     ) internal view {
6223         _sendLogPayload(
6224             abi.encodeWithSignature(
6225                 "log(address,string,uint,address)",
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
6236         string memory p1,
6237         string memory p2,
6238         uint256 p3
6239     ) internal view {
6240         _sendLogPayload(
6241             abi.encodeWithSignature(
6242                 "log(address,string,string,uint)",
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
6253         string memory p1,
6254         string memory p2,
6255         string memory p3
6256     ) internal view {
6257         _sendLogPayload(
6258             abi.encodeWithSignature(
6259                 "log(address,string,string,string)",
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
6270         string memory p1,
6271         string memory p2,
6272         bool p3
6273     ) internal view {
6274         _sendLogPayload(
6275             abi.encodeWithSignature(
6276                 "log(address,string,string,bool)",
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
6287         string memory p1,
6288         string memory p2,
6289         address p3
6290     ) internal view {
6291         _sendLogPayload(
6292             abi.encodeWithSignature(
6293                 "log(address,string,string,address)",
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
6304         string memory p1,
6305         bool p2,
6306         uint256 p3
6307     ) internal view {
6308         _sendLogPayload(
6309             abi.encodeWithSignature(
6310                 "log(address,string,bool,uint)",
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
6321         string memory p1,
6322         bool p2,
6323         string memory p3
6324     ) internal view {
6325         _sendLogPayload(
6326             abi.encodeWithSignature(
6327                 "log(address,string,bool,string)",
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
6338         string memory p1,
6339         bool p2,
6340         bool p3
6341     ) internal view {
6342         _sendLogPayload(
6343             abi.encodeWithSignature(
6344                 "log(address,string,bool,bool)",
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
6355         string memory p1,
6356         bool p2,
6357         address p3
6358     ) internal view {
6359         _sendLogPayload(
6360             abi.encodeWithSignature(
6361                 "log(address,string,bool,address)",
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
6372         string memory p1,
6373         address p2,
6374         uint256 p3
6375     ) internal view {
6376         _sendLogPayload(
6377             abi.encodeWithSignature(
6378                 "log(address,string,address,uint)",
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
6389         string memory p1,
6390         address p2,
6391         string memory p3
6392     ) internal view {
6393         _sendLogPayload(
6394             abi.encodeWithSignature(
6395                 "log(address,string,address,string)",
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
6406         string memory p1,
6407         address p2,
6408         bool p3
6409     ) internal view {
6410         _sendLogPayload(
6411             abi.encodeWithSignature(
6412                 "log(address,string,address,bool)",
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
6423         string memory p1,
6424         address p2,
6425         address p3
6426     ) internal view {
6427         _sendLogPayload(
6428             abi.encodeWithSignature(
6429                 "log(address,string,address,address)",
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
6441         uint256 p2,
6442         uint256 p3
6443     ) internal view {
6444         _sendLogPayload(
6445             abi.encodeWithSignature(
6446                 "log(address,bool,uint,uint)",
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
6458         uint256 p2,
6459         string memory p3
6460     ) internal view {
6461         _sendLogPayload(
6462             abi.encodeWithSignature(
6463                 "log(address,bool,uint,string)",
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
6475         uint256 p2,
6476         bool p3
6477     ) internal view {
6478         _sendLogPayload(
6479             abi.encodeWithSignature(
6480                 "log(address,bool,uint,bool)",
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
6491         bool p1,
6492         uint256 p2,
6493         address p3
6494     ) internal view {
6495         _sendLogPayload(
6496             abi.encodeWithSignature(
6497                 "log(address,bool,uint,address)",
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
6508         bool p1,
6509         string memory p2,
6510         uint256 p3
6511     ) internal view {
6512         _sendLogPayload(
6513             abi.encodeWithSignature(
6514                 "log(address,bool,string,uint)",
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
6525         bool p1,
6526         string memory p2,
6527         string memory p3
6528     ) internal view {
6529         _sendLogPayload(
6530             abi.encodeWithSignature(
6531                 "log(address,bool,string,string)",
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
6542         bool p1,
6543         string memory p2,
6544         bool p3
6545     ) internal view {
6546         _sendLogPayload(
6547             abi.encodeWithSignature(
6548                 "log(address,bool,string,bool)",
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
6559         bool p1,
6560         string memory p2,
6561         address p3
6562     ) internal view {
6563         _sendLogPayload(
6564             abi.encodeWithSignature(
6565                 "log(address,bool,string,address)",
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
6576         bool p1,
6577         bool p2,
6578         uint256 p3
6579     ) internal view {
6580         _sendLogPayload(
6581             abi.encodeWithSignature(
6582                 "log(address,bool,bool,uint)",
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
6593         bool p1,
6594         bool p2,
6595         string memory p3
6596     ) internal view {
6597         _sendLogPayload(
6598             abi.encodeWithSignature(
6599                 "log(address,bool,bool,string)",
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
6610         bool p1,
6611         bool p2,
6612         bool p3
6613     ) internal view {
6614         _sendLogPayload(
6615             abi.encodeWithSignature(
6616                 "log(address,bool,bool,bool)",
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
6627         bool p1,
6628         bool p2,
6629         address p3
6630     ) internal view {
6631         _sendLogPayload(
6632             abi.encodeWithSignature(
6633                 "log(address,bool,bool,address)",
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
6644         bool p1,
6645         address p2,
6646         uint256 p3
6647     ) internal view {
6648         _sendLogPayload(
6649             abi.encodeWithSignature(
6650                 "log(address,bool,address,uint)",
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
6661         bool p1,
6662         address p2,
6663         string memory p3
6664     ) internal view {
6665         _sendLogPayload(
6666             abi.encodeWithSignature(
6667                 "log(address,bool,address,string)",
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
6678         bool p1,
6679         address p2,
6680         bool p3
6681     ) internal view {
6682         _sendLogPayload(
6683             abi.encodeWithSignature(
6684                 "log(address,bool,address,bool)",
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
6695         bool p1,
6696         address p2,
6697         address p3
6698     ) internal view {
6699         _sendLogPayload(
6700             abi.encodeWithSignature(
6701                 "log(address,bool,address,address)",
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
6713         uint256 p2,
6714         uint256 p3
6715     ) internal view {
6716         _sendLogPayload(
6717             abi.encodeWithSignature(
6718                 "log(address,address,uint,uint)",
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
6730         uint256 p2,
6731         string memory p3
6732     ) internal view {
6733         _sendLogPayload(
6734             abi.encodeWithSignature(
6735                 "log(address,address,uint,string)",
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
6747         uint256 p2,
6748         bool p3
6749     ) internal view {
6750         _sendLogPayload(
6751             abi.encodeWithSignature(
6752                 "log(address,address,uint,bool)",
6753                 p0,
6754                 p1,
6755                 p2,
6756                 p3
6757             )
6758         );
6759     }
6760 
6761     function log(
6762         address p0,
6763         address p1,
6764         uint256 p2,
6765         address p3
6766     ) internal view {
6767         _sendLogPayload(
6768             abi.encodeWithSignature(
6769                 "log(address,address,uint,address)",
6770                 p0,
6771                 p1,
6772                 p2,
6773                 p3
6774             )
6775         );
6776     }
6777 
6778     function log(
6779         address p0,
6780         address p1,
6781         string memory p2,
6782         uint256 p3
6783     ) internal view {
6784         _sendLogPayload(
6785             abi.encodeWithSignature(
6786                 "log(address,address,string,uint)",
6787                 p0,
6788                 p1,
6789                 p2,
6790                 p3
6791             )
6792         );
6793     }
6794 
6795     function log(
6796         address p0,
6797         address p1,
6798         string memory p2,
6799         string memory p3
6800     ) internal view {
6801         _sendLogPayload(
6802             abi.encodeWithSignature(
6803                 "log(address,address,string,string)",
6804                 p0,
6805                 p1,
6806                 p2,
6807                 p3
6808             )
6809         );
6810     }
6811 
6812     function log(
6813         address p0,
6814         address p1,
6815         string memory p2,
6816         bool p3
6817     ) internal view {
6818         _sendLogPayload(
6819             abi.encodeWithSignature(
6820                 "log(address,address,string,bool)",
6821                 p0,
6822                 p1,
6823                 p2,
6824                 p3
6825             )
6826         );
6827     }
6828 
6829     function log(
6830         address p0,
6831         address p1,
6832         string memory p2,
6833         address p3
6834     ) internal view {
6835         _sendLogPayload(
6836             abi.encodeWithSignature(
6837                 "log(address,address,string,address)",
6838                 p0,
6839                 p1,
6840                 p2,
6841                 p3
6842             )
6843         );
6844     }
6845 
6846     function log(
6847         address p0,
6848         address p1,
6849         bool p2,
6850         uint256 p3
6851     ) internal view {
6852         _sendLogPayload(
6853             abi.encodeWithSignature(
6854                 "log(address,address,bool,uint)",
6855                 p0,
6856                 p1,
6857                 p2,
6858                 p3
6859             )
6860         );
6861     }
6862 
6863     function log(
6864         address p0,
6865         address p1,
6866         bool p2,
6867         string memory p3
6868     ) internal view {
6869         _sendLogPayload(
6870             abi.encodeWithSignature(
6871                 "log(address,address,bool,string)",
6872                 p0,
6873                 p1,
6874                 p2,
6875                 p3
6876             )
6877         );
6878     }
6879 
6880     function log(
6881         address p0,
6882         address p1,
6883         bool p2,
6884         bool p3
6885     ) internal view {
6886         _sendLogPayload(
6887             abi.encodeWithSignature(
6888                 "log(address,address,bool,bool)",
6889                 p0,
6890                 p1,
6891                 p2,
6892                 p3
6893             )
6894         );
6895     }
6896 
6897     function log(
6898         address p0,
6899         address p1,
6900         bool p2,
6901         address p3
6902     ) internal view {
6903         _sendLogPayload(
6904             abi.encodeWithSignature(
6905                 "log(address,address,bool,address)",
6906                 p0,
6907                 p1,
6908                 p2,
6909                 p3
6910             )
6911         );
6912     }
6913 
6914     function log(
6915         address p0,
6916         address p1,
6917         address p2,
6918         uint256 p3
6919     ) internal view {
6920         _sendLogPayload(
6921             abi.encodeWithSignature(
6922                 "log(address,address,address,uint)",
6923                 p0,
6924                 p1,
6925                 p2,
6926                 p3
6927             )
6928         );
6929     }
6930 
6931     function log(
6932         address p0,
6933         address p1,
6934         address p2,
6935         string memory p3
6936     ) internal view {
6937         _sendLogPayload(
6938             abi.encodeWithSignature(
6939                 "log(address,address,address,string)",
6940                 p0,
6941                 p1,
6942                 p2,
6943                 p3
6944             )
6945         );
6946     }
6947 
6948     function log(
6949         address p0,
6950         address p1,
6951         address p2,
6952         bool p3
6953     ) internal view {
6954         _sendLogPayload(
6955             abi.encodeWithSignature(
6956                 "log(address,address,address,bool)",
6957                 p0,
6958                 p1,
6959                 p2,
6960                 p3
6961             )
6962         );
6963     }
6964 
6965     function log(
6966         address p0,
6967         address p1,
6968         address p2,
6969         address p3
6970     ) internal view {
6971         _sendLogPayload(
6972             abi.encodeWithSignature(
6973                 "log(address,address,address,address)",
6974                 p0,
6975                 p1,
6976                 p2,
6977                 p3
6978             )
6979         );
6980     }
6981 }
6982 
6983 // File contracts/MetaMogulsV2.sol
6984 
6985 pragma solidity ^0.8.0;
6986 
6987 contract MetaMogulsV2 is ERC721, Ownable, ReentrancyGuard, Pausable {
6988     using Strings for uint256;
6989 
6990     string private baseURI;
6991     string public verificationHash;
6992     uint256 public maxNFTs;
6993     uint256 public PUBLIC_SALE_PRICE = 0.06 ether;
6994     bool public isPublicSaleActive;
6995     bool public REVEAL;
6996 
6997     IERC721 public oldContract;
6998 
6999     uint256 public currentSupply;
7000     uint256 public v1MintedSupply;
7001 
7002     // v2
7003     uint256[] public allMigratedTokens;
7004     mapping(uint256 => bool) public migratedTokensById;
7005     uint256[] private reserveTokenIdsMinted;
7006 
7007     // ============ ACCESS CONTROL/Function MODIFIERS ============
7008 
7009     modifier publicSaleActive() {
7010         require(isPublicSaleActive, "Public sale is not open");
7011         _;
7012     }
7013 
7014     modifier canMintNFTs(uint256 numberOfTokens) {
7015         require(
7016             currentSupply + numberOfTokens <= maxNFTs,
7017             "Not enough NFTs remaining to mint"
7018         );
7019         _;
7020     }
7021 
7022     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
7023         require(
7024             price * numberOfTokens == msg.value,
7025             "Incorrect ETH value sent"
7026         );
7027         _;
7028     }
7029 
7030     constructor(
7031         uint256 _maxNFTs1,
7032         string memory _baseURI,
7033         bool _isPublicSaleActive,
7034         bool _REVEAL,
7035         address _oldContract,
7036         uint256 _currentSupply,
7037         uint256 _initialReserveCount
7038     ) ERC721("Meta Moguls", "MOGUL") {
7039         maxNFTs = _maxNFTs1;
7040         baseURI = _baseURI;
7041         REVEAL = _REVEAL;
7042         isPublicSaleActive = _isPublicSaleActive;
7043         currentSupply = _currentSupply;
7044         v1MintedSupply = _currentSupply;
7045 
7046         // set v1 contract address
7047         if (_oldContract != address(0)) {
7048             oldContract = IERC721(_oldContract);
7049         }
7050 
7051         // mint reserved NFTs to team wallet for contests, etc.
7052         for (uint256 i = 1; i <= _initialReserveCount; i++) {
7053             if (i <= 5) {
7054                 //first, mint the final 5 tokenIds reserved (1107-1111)
7055                 uint256 tokenIdToMint = maxNFTs - (i - 1);
7056                 _safeMint(msg.sender, tokenIdToMint);
7057                 reserveTokenIdsMinted.push(tokenIdToMint);
7058             } else {
7059                 // second, mint the next available 55 tokenIds
7060                 uint256 tokenIdToMint = getNextTokenId();
7061                 _safeMint(msg.sender, tokenIdToMint);
7062                 reserveTokenIdsMinted.push(tokenIdToMint);
7063             }
7064             incrementCurrentSupply();
7065         }
7066     }
7067 
7068     // ============ PUBLIC READ-ONLY FUNCTIONS ============
7069 
7070     function getBaseURI() external view returns (string memory) {
7071         return baseURI;
7072     }
7073 
7074     function getLastTokenId() external view returns (uint256) {
7075         // minus 5 to compensate for reserved tokenIds 1107-1111
7076         return currentSupply - 5;
7077     }
7078 
7079     function getAllMigratedTokens() public view returns (uint256[] memory) {
7080         return allMigratedTokens;
7081     }
7082 
7083     function tokenHasBeenMigrated(uint256 tokenId) public view returns (bool) {
7084         require(
7085             tokenId <= v1MintedSupply,
7086             "Cannot check migration status of v2 NFT"
7087         );
7088         return migratedTokensById[tokenId];
7089     }
7090 
7091     function getReserveTokenIdsMinted() public view returns (uint256[] memory) {
7092         return reserveTokenIdsMinted;
7093     }
7094 
7095     function getCurrentMintedSupply() public view returns (uint256) {
7096         return currentSupply;
7097     }
7098 
7099     // ============ PRIVATE READ-ONLY FUNCTIONS ============
7100 
7101     function getNextTokenId() private view returns (uint256) {
7102         require(currentSupply < maxNFTs, "All NFTs have been minted");
7103         // minus 5 to compensate for reserved tokenIds 1107-1111
7104         return (currentSupply - 5) + 1;
7105     }
7106 
7107     // ============ PRIVATE WRITE FUNCTIONS ============
7108     function incrementCurrentSupply() private {
7109         require(currentSupply < maxNFTs, "All NFTs have been minted");
7110         currentSupply++;
7111     }
7112 
7113     // ============ PUBLIC FUNCTIONS ============
7114 
7115     function mint(uint256 numberOfTokens)
7116         external
7117         payable
7118         nonReentrant
7119         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
7120         publicSaleActive
7121         canMintNFTs(numberOfTokens)
7122         whenNotPaused
7123     {
7124         for (uint256 i = 0; i < numberOfTokens; i++) {
7125             uint256 tokenIdToMint = getNextTokenId();
7126             _safeMint(msg.sender, tokenIdToMint);
7127             incrementCurrentSupply();
7128         }
7129     }
7130 
7131     // ============ V2 MIGRATION FUNCTIONS ============
7132 
7133     function _ownsOldToken(address account, uint256 tokenId)
7134         private
7135         view
7136         returns (bool)
7137     {
7138         try oldContract.ownerOf(tokenId) returns (address tokenOwner) {
7139             return account == tokenOwner;
7140         } catch Error(
7141             string memory /*reason*/
7142         ) {
7143             return false;
7144         }
7145     }
7146 
7147     function claim(uint256 tokenId) external nonReentrant whenNotPaused {
7148         // require(!claimed[msg.sender], "NFT already claimed by this wallet");
7149         if (_ownsOldToken(msg.sender, tokenId)) {
7150             oldContract.transferFrom(msg.sender, address(this), tokenId);
7151 
7152             _safeMint(msg.sender, tokenId);
7153         }
7154     }
7155 
7156     function claimAll(uint256[] memory ownedTokens)
7157         external
7158         nonReentrant
7159         whenNotPaused
7160     {
7161         uint256 length = ownedTokens.length; // gas saving
7162         console.log("ownedTokens.length", length);
7163         for (uint256 i; i < length; i++) {
7164             uint256 tokenIdToMint = ownedTokens[i];
7165             console.log("tokenIdToMint", tokenIdToMint);
7166             require(
7167                 tokenIdToMint <= v1MintedSupply,
7168                 "Token ID must be minted on old contract"
7169             );
7170 
7171             if (_ownsOldToken(msg.sender, tokenIdToMint)) {
7172                 oldContract.transferFrom(
7173                     msg.sender,
7174                     address(this),
7175                     tokenIdToMint
7176                 );
7177                 _safeMint(msg.sender, tokenIdToMint);
7178                 allMigratedTokens.push(tokenIdToMint);
7179                 migratedTokensById[tokenIdToMint] = true;
7180             }
7181         }
7182     }
7183 
7184     function tokenURI(uint256 tokenId)
7185         public
7186         view
7187         virtual
7188         override
7189         returns (string memory)
7190     {
7191         require(_exists(tokenId), "Nonexistent token");
7192         if (REVEAL) {
7193             return
7194                 string(
7195                     abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")
7196                 );
7197         } else {
7198             return baseURI;
7199         }
7200     }
7201 
7202     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
7203 
7204     function setBaseURI(string memory _baseURI1) external onlyOwner {
7205         baseURI = _baseURI1;
7206     }
7207 
7208     function setMaxNFTsInTOTALCollection(uint256 _maxNFTs2) external onlyOwner {
7209         maxNFTs = _maxNFTs2;
7210     }
7211 
7212     function setPUBLIC_SALE_PRICEinEther(uint256 _PUBLIC_SALE_PRICE)
7213         external
7214         onlyOwner
7215     {
7216         PUBLIC_SALE_PRICE = _PUBLIC_SALE_PRICE;
7217     }
7218 
7219     function setREVEAL(bool _REVEAL) external onlyOwner {
7220         REVEAL = _REVEAL;
7221     }
7222 
7223     function setVerificationHash(string memory _verificationHash)
7224         external
7225         onlyOwner
7226     {
7227         verificationHash = _verificationHash;
7228     }
7229 
7230     function setIsPublicSaleActive(bool _isPublicSaleActive)
7231         external
7232         onlyOwner
7233     {
7234         isPublicSaleActive = _isPublicSaleActive;
7235     }
7236 
7237     function withdraw() public onlyOwner {
7238         uint256 balance = address(this).balance;
7239         payable(msg.sender).transfer(balance);
7240     }
7241 
7242     function withdrawTokens(IERC20 token) public onlyOwner {
7243         uint256 balance = token.balanceOf(address(this));
7244         token.transfer(msg.sender, balance);
7245     }
7246 }