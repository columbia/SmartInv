1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length)
55         internal
56         pure
57         returns (string memory)
58     {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev Provides information about the current execution context, including the
75  * sender of the transaction and its data. While these are generally available
76  * via msg.sender and msg.data, they should not be accessed in such a direct
77  * manner, since when dealing with meta-transactions the account sending and
78  * paying for execution may not be the actual sender (as far as an application
79  * is concerned).
80  *
81  * This contract is only required for intermediate, library-like contracts.
82  */
83 abstract contract Context {
84     function _msgSender() internal view virtual returns (address) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view virtual returns (bytes calldata) {
89         return msg.data;
90     }
91 }
92 
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Collection of functions related to the address type
98  */
99 library Address {
100     /**
101      * @dev Returns true if `account` is a contract.
102      *
103      * [IMPORTANT]
104      * ====
105      * It is unsafe to assume that an address for which this function returns
106      * false is an externally-owned account (EOA) and not a contract.
107      *
108      * Among others, `isContract` will return false for the following
109      * types of addresses:
110      *
111      *  - an externally-owned account
112      *  - a contract in construction
113      *  - an address where a contract will be created
114      *  - an address where a contract lived, but was destroyed
115      * ====
116      *
117      * [IMPORTANT]
118      * ====
119      * You shouldn't rely on `isContract` to protect against flash loan attacks!
120      *
121      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
122      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
123      * constructor.
124      * ====
125      */
126     function isContract(address account) internal view returns (bool) {
127         // This method relies on extcodesize/address.code.length, which returns 0
128         // for contracts in construction, since the code is only stored at the end
129         // of the constructor execution.
130 
131         return account.code.length > 0;
132     }
133 
134     /**
135      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
136      * `recipient`, forwarding all available gas and reverting on errors.
137      *
138      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
139      * of certain opcodes, possibly making contracts go over the 2300 gas limit
140      * imposed by `transfer`, making them unable to receive funds via
141      * `transfer`. {sendValue} removes this limitation.
142      *
143      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
144      *
145      * IMPORTANT: because control is transferred to `recipient`, care must be
146      * taken to not create reentrancy vulnerabilities. Consider using
147      * {ReentrancyGuard} or the
148      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
149      */
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(
152             address(this).balance >= amount,
153             "Address: insufficient balance"
154         );
155 
156         (bool success, ) = recipient.call{value: amount}("");
157         require(
158             success,
159             "Address: unable to send value, recipient may have reverted"
160         );
161     }
162 
163     /**
164      * @dev Performs a Solidity function call using a low level `call`. A
165      * plain `call` is an unsafe replacement for a function call: use this
166      * function instead.
167      *
168      * If `target` reverts with a revert reason, it is bubbled up by this
169      * function (like regular Solidity function calls).
170      *
171      * Returns the raw returned data. To convert to the expected return value,
172      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
173      *
174      * Requirements:
175      *
176      * - `target` must be a contract.
177      * - calling `target` with `data` must not revert.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(address target, bytes memory data)
182         internal
183         returns (bytes memory)
184     {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
190      * `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but also transferring `value` wei to `target`.
205      *
206      * Requirements:
207      *
208      * - the calling contract must have an ETH balance of at least `value`.
209      * - the called Solidity function must be `payable`.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value
217     ) internal returns (bytes memory) {
218         return
219             functionCallWithValue(
220                 target,
221                 data,
222                 value,
223                 "Address: low-level call with value failed"
224             );
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
229      * with `errorMessage` as a fallback revert reason when `target` reverts.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(
234         address target,
235         bytes memory data,
236         uint256 value,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         require(
240             address(this).balance >= value,
241             "Address: insufficient balance for call"
242         );
243         require(isContract(target), "Address: call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.call{value: value}(
246             data
247         );
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(address target, bytes memory data)
258         internal
259         view
260         returns (bytes memory)
261     {
262         return
263             functionStaticCall(
264                 target,
265                 data,
266                 "Address: low-level static call failed"
267             );
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal view returns (bytes memory) {
281         require(isContract(target), "Address: static call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.staticcall(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a delegate call.
290      *
291      * _Available since v3.4._
292      */
293     function functionDelegateCall(address target, bytes memory data)
294         internal
295         returns (bytes memory)
296     {
297         return
298             functionDelegateCall(
299                 target,
300                 data,
301                 "Address: low-level delegate call failed"
302             );
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
307      * but performing a delegate call.
308      *
309      * _Available since v3.4._
310      */
311     function functionDelegateCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(isContract(target), "Address: delegate call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.delegatecall(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
324      * revert reason using the provided one.
325      *
326      * _Available since v4.3._
327      */
328     function verifyCallResult(
329         bool success,
330         bytes memory returndata,
331         string memory errorMessage
332     ) internal pure returns (bytes memory) {
333         if (success) {
334             return returndata;
335         } else {
336             // Look for revert reason and bubble it up if present
337             if (returndata.length > 0) {
338                 // The easiest way to bubble the revert reason is using memory via assembly
339 
340                 assembly {
341                     let returndata_size := mload(returndata)
342                     revert(add(32, returndata), returndata_size)
343                 }
344             } else {
345                 revert(errorMessage);
346             }
347         }
348     }
349 }
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @title ERC721 token receiver interface
355  * @dev Interface for any contract that wants to support safeTransfers
356  * from ERC721 asset contracts.
357  */
358 interface IERC721Receiver {
359     /**
360      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
361      * by `operator` from `from`, this function is called.
362      *
363      * It must return its Solidity selector to confirm the token transfer.
364      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
365      *
366      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
367      */
368     function onERC721Received(
369         address operator,
370         address from,
371         uint256 tokenId,
372         bytes calldata data
373     ) external returns (bytes4);
374 }
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Interface of the ERC165 standard, as defined in the
380  * https://eips.ethereum.org/EIPS/eip-165[EIP].
381  *
382  * Implementers can declare support of contract interfaces, which can then be
383  * queried by others ({ERC165Checker}).
384  *
385  * For an implementation, see {ERC165}.
386  */
387 interface IERC165 {
388     /**
389      * @dev Returns true if this contract implements the interface defined by
390      * `interfaceId`. See the corresponding
391      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
392      * to learn more about how these ids are created.
393      *
394      * This function call must use less than 30 000 gas.
395      */
396     function supportsInterface(bytes4 interfaceId) external view returns (bool);
397 }
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Implementation of the {IERC165} interface.
403  *
404  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
405  * for the additional interface id that will be supported. For example:
406  *
407  * ```solidity
408  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
409  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
410  * }
411  * ```
412  *
413  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
414  */
415 abstract contract ERC165 is IERC165 {
416     /**
417      * @dev See {IERC165-supportsInterface}.
418      */
419     function supportsInterface(bytes4 interfaceId)
420         public
421         view
422         virtual
423         override
424         returns (bool)
425     {
426         return interfaceId == type(IERC165).interfaceId;
427     }
428 }
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Required interface of an ERC721 compliant contract.
434  */
435 interface IERC721 is IERC165 {
436     /**
437      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
438      */
439     event Transfer(
440         address indexed from,
441         address indexed to,
442         uint256 indexed tokenId
443     );
444 
445     /**
446      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
447      */
448     event Approval(
449         address indexed owner,
450         address indexed approved,
451         uint256 indexed tokenId
452     );
453 
454     /**
455      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
456      */
457     event ApprovalForAll(
458         address indexed owner,
459         address indexed operator,
460         bool approved
461     );
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Returns the account approved for `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function getApproved(uint256 tokenId)
540         external
541         view
542         returns (address operator);
543 
544     /**
545      * @dev Approve or remove `operator` as an operator for the caller.
546      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
547      *
548      * Requirements:
549      *
550      * - The `operator` cannot be the caller.
551      *
552      * Emits an {ApprovalForAll} event.
553      */
554     function setApprovalForAll(address operator, bool _approved) external;
555 
556     /**
557      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
558      *
559      * See {setApprovalForAll}
560      */
561     function isApprovedForAll(address owner, address operator)
562         external
563         view
564         returns (bool);
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`.
568      *
569      * Requirements:
570      *
571      * - `from` cannot be the zero address.
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must exist and be owned by `from`.
574      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
575      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
576      *
577      * Emits a {Transfer} event.
578      */
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId,
583         bytes calldata data
584     ) external;
585 }
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
591  * @dev See https://eips.ethereum.org/EIPS/eip-721
592  */
593 interface IERC721Enumerable is IERC721 {
594     /**
595      * @dev Returns the total amount of tokens stored by the contract.
596      */
597     function totalSupply() external view returns (uint256);
598 
599     /**
600      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
601      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
602      */
603     function tokenOfOwnerByIndex(address owner, uint256 index)
604         external
605         view
606         returns (uint256 tokenId);
607 
608     /**
609      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
610      * Use along with {totalSupply} to enumerate all tokens.
611      */
612     function tokenByIndex(uint256 index) external view returns (uint256);
613 }
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
619  * @dev See https://eips.ethereum.org/EIPS/eip-721
620  */
621 interface IERC721Metadata is IERC721 {
622     /**
623      * @dev Returns the token collection name.
624      */
625     function name() external view returns (string memory);
626 
627     /**
628      * @dev Returns the token collection symbol.
629      */
630     function symbol() external view returns (string memory);
631 
632     /**
633      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
634      */
635     function tokenURI(uint256 tokenId) external view returns (string memory);
636 }
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
642  * the Metadata extension, but not including the Enumerable extension, which is available separately as
643  * {ERC721Enumerable}.
644  */
645 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
646     using Address for address;
647     using Strings for uint256;
648 
649     // Token name
650     string private _name;
651 
652     // Token symbol
653     string private _symbol;
654 
655     // Mapping from token ID to owner address
656     mapping(uint256 => address) private _owners;
657 
658     // Mapping owner address to token count
659     mapping(address => uint256) private _balances;
660 
661     // Mapping from token ID to approved address
662     mapping(uint256 => address) private _tokenApprovals;
663 
664     // Mapping from owner to operator approvals
665     mapping(address => mapping(address => bool)) private _operatorApprovals;
666 
667     /**
668      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
669      */
670     constructor(string memory name_, string memory symbol_) {
671         _name = name_;
672         _symbol = symbol_;
673     }
674 
675     /**
676      * @dev See {IERC165-supportsInterface}.
677      */
678     function supportsInterface(bytes4 interfaceId)
679         public
680         view
681         virtual
682         override(ERC165, IERC165)
683         returns (bool)
684     {
685         return
686             interfaceId == type(IERC721).interfaceId ||
687             interfaceId == type(IERC721Metadata).interfaceId ||
688             super.supportsInterface(interfaceId);
689     }
690 
691     /**
692      * @dev See {IERC721-balanceOf}.
693      */
694     function balanceOf(address owner)
695         public
696         view
697         virtual
698         override
699         returns (uint256)
700     {
701         require(
702             owner != address(0),
703             "ERC721: balance query for the zero address"
704         );
705         return _balances[owner];
706     }
707 
708     /**
709      * @dev See {IERC721-ownerOf}.
710      */
711     function ownerOf(uint256 tokenId)
712         public
713         view
714         virtual
715         override
716         returns (address)
717     {
718         address owner = _owners[tokenId];
719         require(
720             owner != address(0),
721             "ERC721: owner query for nonexistent token"
722         );
723         return owner;
724     }
725 
726     /**
727      * @dev See {IERC721Metadata-name}.
728      */
729     function name() public view virtual override returns (string memory) {
730         return _name;
731     }
732 
733     /**
734      * @dev See {IERC721Metadata-symbol}.
735      */
736     function symbol() public view virtual override returns (string memory) {
737         return _symbol;
738     }
739 
740     /**
741      * @dev See {IERC721Metadata-tokenURI}.
742      */
743     function tokenURI(uint256 tokenId)
744         public
745         view
746         virtual
747         override
748         returns (string memory)
749     {
750         require(
751             _exists(tokenId),
752             "ERC721Metadata: URI query for nonexistent token"
753         );
754 
755         string memory baseURI = _baseURI();
756         return
757             bytes(baseURI).length > 0
758                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
759                 : "";
760     }
761 
762     /**
763      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
764      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
765      * by default, can be overriden in child contracts.
766      */
767     function _baseURI() internal view virtual returns (string memory) {
768         return "";
769     }
770 
771     /**
772      * @dev See {IERC721-approve}.
773      */
774     function approve(address to, uint256 tokenId) public virtual override {
775         address owner = ERC721.ownerOf(tokenId);
776         require(to != owner, "ERC721: approval to current owner");
777 
778         require(
779             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
780             "ERC721: approve caller is not owner nor approved for all"
781         );
782 
783         _approve(to, tokenId);
784     }
785 
786     /**
787      * @dev See {IERC721-getApproved}.
788      */
789     function getApproved(uint256 tokenId)
790         public
791         view
792         virtual
793         override
794         returns (address)
795     {
796         require(
797             _exists(tokenId),
798             "ERC721: approved query for nonexistent token"
799         );
800 
801         return _tokenApprovals[tokenId];
802     }
803 
804     /**
805      * @dev See {IERC721-setApprovalForAll}.
806      */
807     function setApprovalForAll(address operator, bool approved)
808         public
809         virtual
810         override
811     {
812         _setApprovalForAll(_msgSender(), operator, approved);
813     }
814 
815     /**
816      * @dev See {IERC721-isApprovedForAll}.
817      */
818     function isApprovedForAll(address owner, address operator)
819         public
820         view
821         virtual
822         override
823         returns (bool)
824     {
825         return _operatorApprovals[owner][operator];
826     }
827 
828     /**
829      * @dev See {IERC721-transferFrom}.
830      */
831     function transferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public virtual override {
836         //solhint-disable-next-line max-line-length
837         require(
838             _isApprovedOrOwner(_msgSender(), tokenId),
839             "ERC721: transfer caller is not owner nor approved"
840         );
841 
842         _transfer(from, to, tokenId);
843     }
844 
845     /**
846      * @dev See {IERC721-safeTransferFrom}.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         safeTransferFrom(from, to, tokenId, "");
854     }
855 
856     /**
857      * @dev See {IERC721-safeTransferFrom}.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) public virtual override {
865         require(
866             _isApprovedOrOwner(_msgSender(), tokenId),
867             "ERC721: transfer caller is not owner nor approved"
868         );
869         _safeTransfer(from, to, tokenId, _data);
870     }
871 
872     /**
873      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
874      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
875      *
876      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
877      *
878      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
879      * implement alternative mechanisms to perform token transfer, such as signature-based.
880      *
881      * Requirements:
882      *
883      * - `from` cannot be the zero address.
884      * - `to` cannot be the zero address.
885      * - `tokenId` token must exist and be owned by `from`.
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _safeTransfer(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) internal virtual {
896         _transfer(from, to, tokenId);
897         require(
898             _checkOnERC721Received(from, to, tokenId, _data),
899             "ERC721: transfer to non ERC721Receiver implementer"
900         );
901     }
902 
903     /**
904      * @dev Returns whether `tokenId` exists.
905      *
906      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
907      *
908      * Tokens start existing when they are minted (`_mint`),
909      * and stop existing when they are burned (`_burn`).
910      */
911     function _exists(uint256 tokenId) internal view virtual returns (bool) {
912         return _owners[tokenId] != address(0);
913     }
914 
915     /**
916      * @dev Returns whether `spender` is allowed to manage `tokenId`.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must exist.
921      */
922     function _isApprovedOrOwner(address spender, uint256 tokenId)
923         internal
924         view
925         virtual
926         returns (bool)
927     {
928         require(
929             _exists(tokenId),
930             "ERC721: operator query for nonexistent token"
931         );
932         address owner = ERC721.ownerOf(tokenId);
933         return (spender == owner ||
934             getApproved(tokenId) == spender ||
935             isApprovedForAll(owner, spender));
936     }
937 
938     /**
939      * @dev Safely mints `tokenId` and transfers it to `to`.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must not exist.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(address to, uint256 tokenId) internal virtual {
949         _safeMint(to, tokenId, "");
950     }
951 
952     /**
953      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
954      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
955      */
956     function _safeMint(
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) internal virtual {
961         _mint(to, tokenId);
962         require(
963             _checkOnERC721Received(address(0), to, tokenId, _data),
964             "ERC721: transfer to non ERC721Receiver implementer"
965         );
966     }
967 
968     /**
969      * @dev Mints `tokenId` and transfers it to `to`.
970      *
971      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - `to` cannot be the zero address.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _mint(address to, uint256 tokenId) internal virtual {
981         require(to != address(0), "ERC721: mint to the zero address");
982         require(!_exists(tokenId), "ERC721: token already minted");
983 
984         _beforeTokenTransfer(address(0), to, tokenId);
985 
986         _balances[to] += 1;
987         _owners[tokenId] = to;
988 
989         emit Transfer(address(0), to, tokenId);
990 
991         _afterTokenTransfer(address(0), to, tokenId);
992     }
993 
994     /**
995      * @dev Destroys `tokenId`.
996      * The approval is cleared when the token is burned.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _burn(uint256 tokenId) internal virtual {
1005         address owner = ERC721.ownerOf(tokenId);
1006 
1007         _beforeTokenTransfer(owner, address(0), tokenId);
1008 
1009         // Clear approvals
1010         _approve(address(0), tokenId);
1011 
1012         _balances[owner] -= 1;
1013         delete _owners[tokenId];
1014 
1015         emit Transfer(owner, address(0), tokenId);
1016 
1017         _afterTokenTransfer(owner, address(0), tokenId);
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
1038             "ERC721: transfer from incorrect owner"
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
1052 
1053         _afterTokenTransfer(from, to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Approve `to` to operate on `tokenId`
1058      *
1059      * Emits a {Approval} event.
1060      */
1061     function _approve(address to, uint256 tokenId) internal virtual {
1062         _tokenApprovals[tokenId] = to;
1063         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Approve `operator` to operate on all of `owner` tokens
1068      *
1069      * Emits a {ApprovalForAll} event.
1070      */
1071     function _setApprovalForAll(
1072         address owner,
1073         address operator,
1074         bool approved
1075     ) internal virtual {
1076         require(owner != operator, "ERC721: approve to caller");
1077         _operatorApprovals[owner][operator] = approved;
1078         emit ApprovalForAll(owner, operator, approved);
1079     }
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1083      * The call is not executed if the target address is not a contract.
1084      *
1085      * @param from address representing the previous owner of the given token ID
1086      * @param to target address that will receive the tokens
1087      * @param tokenId uint256 ID of the token to be transferred
1088      * @param _data bytes optional data to send along with the call
1089      * @return bool whether the call correctly returned the expected magic value
1090      */
1091     function _checkOnERC721Received(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) private returns (bool) {
1097         if (to.isContract()) {
1098             try
1099                 IERC721Receiver(to).onERC721Received(
1100                     _msgSender(),
1101                     from,
1102                     tokenId,
1103                     _data
1104                 )
1105             returns (bytes4 retval) {
1106                 return retval == IERC721Receiver.onERC721Received.selector;
1107             } catch (bytes memory reason) {
1108                 if (reason.length == 0) {
1109                     revert(
1110                         "ERC721: transfer to non ERC721Receiver implementer"
1111                     );
1112                 } else {
1113                     assembly {
1114                         revert(add(32, reason), mload(reason))
1115                     }
1116                 }
1117             }
1118         } else {
1119             return true;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before any token transfer. This includes minting
1125      * and burning.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1133      * - `from` and `to` are never both zero.
1134      *
1135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136      */
1137     function _beforeTokenTransfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) internal virtual {}
1142 
1143     /**
1144      * @dev Hook that is called after any transfer of tokens. This includes
1145      * minting and burning.
1146      *
1147      * Calling conditions:
1148      *
1149      * - when `from` and `to` are both non-zero.
1150      * - `from` and `to` are never both zero.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _afterTokenTransfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) internal virtual {}
1159 }
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 /**
1164  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1165  * enumerability of all the token ids in the contract as well as all token ids owned by each
1166  * account.
1167  */
1168 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1169     // Mapping from owner to list of owned token IDs
1170     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1171 
1172     // Mapping from token ID to index of the owner tokens list
1173     mapping(uint256 => uint256) private _ownedTokensIndex;
1174 
1175     // Array with all token ids, used for enumeration
1176     uint256[] private _allTokens;
1177 
1178     // Mapping from token id to position in the allTokens array
1179     mapping(uint256 => uint256) private _allTokensIndex;
1180 
1181     /**
1182      * @dev See {IERC165-supportsInterface}.
1183      */
1184     function supportsInterface(bytes4 interfaceId)
1185         public
1186         view
1187         virtual
1188         override(IERC165, ERC721)
1189         returns (bool)
1190     {
1191         return
1192             interfaceId == type(IERC721Enumerable).interfaceId ||
1193             super.supportsInterface(interfaceId);
1194     }
1195 
1196     /**
1197      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1198      */
1199     function tokenOfOwnerByIndex(address owner, uint256 index)
1200         public
1201         view
1202         virtual
1203         override
1204         returns (uint256)
1205     {
1206         require(
1207             index < ERC721.balanceOf(owner),
1208             "ERC721Enumerable: owner index out of bounds"
1209         );
1210         return _ownedTokens[owner][index];
1211     }
1212 
1213     /**
1214      * @dev See {IERC721Enumerable-totalSupply}.
1215      */
1216     function totalSupply() public view virtual override returns (uint256) {
1217         return _allTokens.length;
1218     }
1219 
1220     /**
1221      * @dev See {IERC721Enumerable-tokenByIndex}.
1222      */
1223     function tokenByIndex(uint256 index)
1224         public
1225         view
1226         virtual
1227         override
1228         returns (uint256)
1229     {
1230         require(
1231             index < ERC721Enumerable.totalSupply(),
1232             "ERC721Enumerable: global index out of bounds"
1233         );
1234         return _allTokens[index];
1235     }
1236 
1237     /**
1238      * @dev Hook that is called before any token transfer. This includes minting
1239      * and burning.
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` will be minted for `to`.
1246      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1247      * - `from` cannot be the zero address.
1248      * - `to` cannot be the zero address.
1249      *
1250      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1251      */
1252     function _beforeTokenTransfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) internal virtual override {
1257         super._beforeTokenTransfer(from, to, tokenId);
1258 
1259         if (from == address(0)) {
1260             _addTokenToAllTokensEnumeration(tokenId);
1261         } else if (from != to) {
1262             _removeTokenFromOwnerEnumeration(from, tokenId);
1263         }
1264         if (to == address(0)) {
1265             _removeTokenFromAllTokensEnumeration(tokenId);
1266         } else if (to != from) {
1267             _addTokenToOwnerEnumeration(to, tokenId);
1268         }
1269     }
1270 
1271     /**
1272      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1273      * @param to address representing the new owner of the given token ID
1274      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1275      */
1276     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1277         uint256 length = ERC721.balanceOf(to);
1278         _ownedTokens[to][length] = tokenId;
1279         _ownedTokensIndex[tokenId] = length;
1280     }
1281 
1282     /**
1283      * @dev Private function to add a token to this extension's token tracking data structures.
1284      * @param tokenId uint256 ID of the token to be added to the tokens list
1285      */
1286     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1287         _allTokensIndex[tokenId] = _allTokens.length;
1288         _allTokens.push(tokenId);
1289     }
1290 
1291     /**
1292      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1293      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1294      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1295      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1296      * @param from address representing the previous owner of the given token ID
1297      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1298      */
1299     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1300         private
1301     {
1302         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1303         // then delete the last slot (swap and pop).
1304 
1305         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1306         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1307 
1308         // When the token to delete is the last token, the swap operation is unnecessary
1309         if (tokenIndex != lastTokenIndex) {
1310             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1311 
1312             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1313             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1314         }
1315 
1316         // This also deletes the contents at the last position of the array
1317         delete _ownedTokensIndex[tokenId];
1318         delete _ownedTokens[from][lastTokenIndex];
1319     }
1320 
1321     /**
1322      * @dev Private function to remove a token from this extension's token tracking data structures.
1323      * This has O(1) time complexity, but alters the order of the _allTokens array.
1324      * @param tokenId uint256 ID of the token to be removed from the tokens list
1325      */
1326     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1327         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1328         // then delete the last slot (swap and pop).
1329 
1330         uint256 lastTokenIndex = _allTokens.length - 1;
1331         uint256 tokenIndex = _allTokensIndex[tokenId];
1332 
1333         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1334         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1335         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1336         uint256 lastTokenId = _allTokens[lastTokenIndex];
1337 
1338         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1339         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1340 
1341         // This also deletes the contents at the last position of the array
1342         delete _allTokensIndex[tokenId];
1343         _allTokens.pop();
1344     }
1345 }
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 library CatLib {
1350     string internal constant TABLE =
1351         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1352 
1353     function encode(bytes memory data) internal pure returns (string memory) {
1354         if (data.length == 0) return "";
1355 
1356         // load the table into memory
1357         string memory table = TABLE;
1358 
1359         // multiply by 4/3 rounded up
1360         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1361 
1362         // add some extra buffer at the end required for the writing
1363         string memory result = new string(encodedLen + 32);
1364 
1365         assembly {
1366             // set the actual output length
1367             mstore(result, encodedLen)
1368 
1369             // prepare the lookup table
1370             let tablePtr := add(table, 1)
1371 
1372             // input ptr
1373             let dataPtr := data
1374             let endPtr := add(dataPtr, mload(data))
1375 
1376             // result ptr, jump over length
1377             let resultPtr := add(result, 32)
1378 
1379             // run over the input, 3 bytes at a time
1380             for {
1381 
1382             } lt(dataPtr, endPtr) {
1383 
1384             } {
1385                 dataPtr := add(dataPtr, 3)
1386 
1387                 // read 3 bytes
1388                 let input := mload(dataPtr)
1389 
1390                 // write 4 characters
1391                 mstore(
1392                     resultPtr,
1393                     shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1394                 )
1395                 resultPtr := add(resultPtr, 1)
1396                 mstore(
1397                     resultPtr,
1398                     shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1399                 )
1400                 resultPtr := add(resultPtr, 1)
1401                 mstore(
1402                     resultPtr,
1403                     shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1404                 )
1405                 resultPtr := add(resultPtr, 1)
1406                 mstore(
1407                     resultPtr,
1408                     shl(248, mload(add(tablePtr, and(input, 0x3F))))
1409                 )
1410                 resultPtr := add(resultPtr, 1)
1411             }
1412 
1413             // padding with '='
1414             switch mod(mload(data), 3)
1415             case 1 {
1416                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1417             }
1418             case 2 {
1419                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1420             }
1421         }
1422 
1423         return result;
1424     }
1425 
1426     function toString(uint256 value) internal pure returns (string memory) {
1427         if (value == 0) {
1428             return "0";
1429         }
1430         uint256 temp = value;
1431         uint256 digits;
1432         while (temp != 0) {
1433             digits++;
1434             temp /= 10;
1435         }
1436         bytes memory buffer = new bytes(digits);
1437         while (value != 0) {
1438             digits -= 1;
1439             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1440             value /= 10;
1441         }
1442         return string(buffer);
1443     }
1444 
1445     function parseInt(string memory _a)
1446         internal
1447         pure
1448         returns (uint8 _parsedInt)
1449     {
1450         bytes memory bresult = bytes(_a);
1451         uint8 mint = 0;
1452         for (uint8 i = 0; i < bresult.length; i++) {
1453             if (
1454                 (uint8(uint8(bresult[i])) >= 48) &&
1455                 (uint8(uint8(bresult[i])) <= 57)
1456             ) {
1457                 mint *= 10;
1458                 mint += uint8(bresult[i]) - 48;
1459             }
1460         }
1461         return mint;
1462     }
1463 
1464     function parseInt16(string memory _a)
1465         internal
1466         pure
1467         returns (uint16 _parsedInt)
1468     {
1469         bytes memory bresult = bytes(_a);
1470         uint16 mint = 0;
1471         for (uint8 i = 0; i < bresult.length; i++) {
1472             if (
1473                 (uint8(uint8(bresult[i])) >= 48) &&
1474                 (uint8(uint8(bresult[i])) <= 57)
1475             ) {
1476                 mint *= 10;
1477                 mint += uint8(bresult[i]) - 48;
1478             }
1479         }
1480         return mint;
1481     }
1482 
1483     function substring(
1484         string memory str,
1485         uint256 startIndex,
1486         uint256 endIndex
1487     ) internal pure returns (string memory) {
1488         bytes memory strBytes = bytes(str);
1489         bytes memory result = new bytes(endIndex - startIndex);
1490         for (uint256 i = startIndex; i < endIndex; i++) {
1491             result[i - startIndex] = strBytes[i];
1492         }
1493         return string(result);
1494     }
1495 
1496     function letterToNumber(bytes1 _inputLetter) internal pure returns (uint8) {
1497         bytes memory tablebytes = bytes(TABLE);
1498         for (uint8 i = 0; i < tablebytes.length; i++) {
1499             if (
1500                 keccak256(abi.encodePacked((tablebytes[i]))) ==
1501                 keccak256(abi.encodePacked((_inputLetter)))
1502             ) return (i);
1503         }
1504         revert();
1505     }
1506 }
1507 
1508 pragma solidity ^0.8.0;
1509 
1510 // TODO Namechange
1511 contract CatsOnChain is ERC721Enumerable {
1512     using CatLib for uint8;
1513 
1514     struct Trait {
1515         string traitName;
1516         string traitType;
1517         string pixels;
1518     }
1519 
1520     mapping(uint256 => string) internal tokenIdToHash;
1521     mapping(uint256 => Trait[]) public traitTypes;
1522     mapping(string => bool) hashToMinted;
1523 
1524     uint256 public constant MINT_PRICE = 80000000000000000; // 0.08 ETH
1525     uint256 public constant MAX_SUPPLY = 11111;
1526 
1527     uint16[][7] TIERS;
1528     address _owner;
1529     uint256 SEED_NONCE = 0;
1530 
1531     constructor() ERC721("CatsOnChain", "COnC") {
1532         _owner = msg.sender;
1533 
1534         //Declare all the rarity tiers        
1535         //Hat
1536         TIERS[0] = [5556,333,667,1333,1000,1111,889,222];
1537         //Whiskers
1538         TIERS[1] = [1920,412,3978,3018,960,823];
1539         //Mouth
1540         TIERS[2] = [2564,2393,2051,1709,1026,855,342,171];
1541         //Eyes
1542         TIERS[3] = [1949,2242,1365,1754,975,877,780,487,390,292];
1543         //Eyebrows
1544         TIERS[4] = [2083,1736,2083,1389,2431,1042,347];
1545         //Neck
1546         TIERS[5] = [6286,2193,1170,585,292,585];
1547         //Type
1548         TIERS[6] = [92,3214,1837,3214,1377,459,918];  
1549 
1550 
1551         for(int i = 0; i<10; i++){
1552             mintCatOwner();
1553         }     
1554 
1555     }    
1556     /*
1557   __  __ _     _   _             ___             _   _             
1558  |  \/  (_)_ _| |_(_)_ _  __ _  | __|  _ _ _  __| |_(_)___ _ _  ___
1559  | |\/| | | ' \  _| | ' \/ _` | | _| || | ' \/ _|  _| / _ \ ' \(_-<
1560  |_|  |_|_|_||_\__|_|_||_\__, | |_| \_,_|_||_\__|\__|_\___/_||_/__/
1561                          |___/                                     
1562    */
1563 
1564     /**
1565      * @dev Converts a digit from 0 - 11110 into its corresponding rarity based on the given rarity tier.
1566      * @param _randinput The input from 0 - 11110 to use for rarity gen.
1567      * @param _rarityTier The tier to use.
1568      */
1569     function rarityGen(uint256 _randinput, uint8 _rarityTier)
1570         internal
1571         view
1572         returns (string memory)
1573     {
1574         uint16 currentLowerBound = 0;
1575         for (uint8 i = 0; i < TIERS[_rarityTier].length; i++) {
1576             uint16 thisPercentage = TIERS[_rarityTier][i];
1577             if (
1578                 _randinput >= currentLowerBound &&
1579                 _randinput < currentLowerBound + thisPercentage
1580             ) return i.toString();
1581             currentLowerBound = currentLowerBound + thisPercentage;
1582         }
1583 
1584         revert();
1585     }
1586 
1587     /**
1588      * @dev Generates a 7 digit hash from a tokenId, address, and random number.
1589      * @param _t The token id to be used within the hash.
1590      * @param _a The address to be used within the hash.
1591      * @param _c The custom nonce to be used within the hash.
1592      */
1593     function hash(
1594         uint256 _t,
1595         address _a,
1596         uint256 _c
1597     ) internal returns (string memory) {
1598         require(_c < 10);
1599 
1600         // This will generate a 7 random character string.
1601         string memory currentHash;
1602 
1603         for (uint8 i = 0; i < 7; i++) {
1604             SEED_NONCE++;
1605             uint16 _randinput = uint16(
1606                 uint256(
1607                     keccak256(
1608                         abi.encodePacked(
1609                             block.timestamp,
1610                             block.difficulty,
1611                             _t,
1612                             _a,
1613                             _c,
1614                             SEED_NONCE
1615                         )
1616                     )
1617                 ) % 11111
1618             );
1619 
1620             currentHash = string(
1621                 abi.encodePacked(currentHash, rarityGen(_randinput, i))
1622             );
1623         }
1624 
1625         if (hashToMinted[currentHash]) return hash(_t, _a, _c + 1);
1626 
1627         return currentHash;
1628     }
1629 
1630     /**
1631      * @dev Mints new cat. The first 1000 mints are free. Afterwards each mint costs 0.08 Eth. There is a maximum of 11111 cats. 
1632      */
1633     function mintCatPublic() public payable {
1634         require(msg.value  >= MINT_PRICE || totalSupply() < 1000,
1635             "Wrong Minting Price (0.08 Eth)"
1636         );
1637         mintCat();      
1638     }
1639 
1640     function mintCat() private{    
1641         uint256 _totalSupply = totalSupply();
1642         require(_totalSupply < MAX_SUPPLY, "All cats are already minted");
1643         uint256 thisTokenId = _totalSupply;
1644         tokenIdToHash[thisTokenId] = hash(thisTokenId, msg.sender, 0);
1645         hashToMinted[tokenIdToHash[thisTokenId]] = true;
1646         _mint(msg.sender, thisTokenId);
1647     }
1648 
1649     /*
1650  ____     ___   ____  ___        _____  __ __  ____     __ ______  ____  ___   ____   _____
1651 |    \   /  _] /    ||   \      |     ||  |  ||    \   /  ]      ||    |/   \ |    \ / ___/
1652 |  D  ) /  [_ |  o  ||    \     |   __||  |  ||  _  | /  /|      | |  ||     ||  _  (   \_ 
1653 |    / |    _]|     ||  D  |    |  |_  |  |  ||  |  |/  / |_|  |_| |  ||  O  ||  |  |\__  |
1654 |    \ |   [_ |  _  ||     |    |   _] |  :  ||  |  /   \_  |  |   |  ||     ||  |  |/  \ |
1655 |  .  \|     ||  |  ||     |    |  |   |     ||  |  \     | |  |   |  ||     ||  |  |\    |
1656 |__|\_||_____||__|__||_____|    |__|    \__,_||__|__|\____| |__|  |____|\___/ |__|__| \___|
1657                                                                                            
1658 */
1659 
1660     /**
1661      * @dev Returns the GIF and metadata for a token Id
1662      * @param _tokenId The tokenId to return the GIF and metadata for.
1663      */
1664     function tokenURI(uint256 _tokenId)
1665         public
1666         view
1667         override
1668         returns (string memory)
1669     {
1670         require(_exists(_tokenId));
1671         string memory tokenHash = tokenIdToHash[_tokenId];
1672       
1673 
1674         return
1675             string(
1676                 abi.encodePacked(
1677                     "data:application/json;base64,",
1678                     CatLib.encode(
1679                         bytes(
1680                             string(
1681                                 abi.encodePacked(
1682                                     '{"name": "Cat #',
1683                                     CatLib.toString(_tokenId),
1684                                     '", "description": "CatsOnChain is a collection of 11,111 unique animated cats. All metadata and GIFs are generated by an algorithm on the blockchain. No IPFS, no API. Just one smart contract on the Ethereum blockchain.", "image": "data:image/gif;base64,',
1685                                     hashToGifHex(tokenHash),
1686                                     '","attributes":',
1687                                     hashToMetadata(tokenHash),
1688                                     "}"
1689                                 )
1690                             )
1691                         )
1692                     )
1693                 )
1694             );
1695     }
1696 
1697     /**
1698      * @dev Hash to GIF-Hex function
1699      * @param _hash The Hash to generate the GIF
1700      */
1701     function hashToGifHex(string memory _hash)
1702         public
1703         view
1704         returns (string memory)
1705     {
1706         // 12 Frames. Each with 25x25 (625) colors
1707         bytes[12] memory colorBytes;
1708         for (uint256 i = 0; i < 12; i++) {
1709             colorBytes[i] = new bytes(625);
1710         }
1711         bool[625][12] memory placedPixels;
1712 
1713         //for each trait
1714         for (uint8 i = 0; i < 7; i++) {
1715             uint16 thisTraitIndex = CatLib.parseInt16(
1716                 CatLib.substring(_hash, i, i + 1)
1717             );
1718 
1719             //For each defined pixel within the trait
1720             for (
1721                 uint16 j = 0;
1722                 j < bytes(traitTypes[i][thisTraitIndex].pixels).length / 5;
1723                 j++
1724             ) {
1725                 // Get the pixel information
1726                 string memory thisPixel = CatLib.substring(
1727                     traitTypes[i][thisTraitIndex].pixels,
1728                     j * 5,
1729                     j * 5 + 5
1730                 );
1731                 bytes memory thisPixelBytes = bytes(thisPixel);
1732 
1733                 // Get the place of the pixel: 25*(Y-Coordinate) + X-Coordinate
1734                 uint16 place = CatLib.letterToNumber(thisPixelBytes[1]);
1735                 place = place * 25 + CatLib.letterToNumber(thisPixelBytes[0]);
1736 
1737                 // Get the Length of the Pixel
1738                 uint8 PixelLength = CatLib.letterToNumber(thisPixelBytes[2]);
1739 
1740                 // Get the color of the pixel
1741                 uint8 color = CatLib.letterToNumber(thisPixelBytes[3]);
1742 
1743                 // Get the movement of the Pixel
1744                 uint8 movement = CatLib.letterToNumber(thisPixelBytes[4]);
1745                
1746                 // Do it PixelLenghth-times
1747                 for (uint8 l = 0; l < PixelLength; l++) {
1748                     //For each GIF Frame
1749                     for (uint8 k = 0; k < 12; k++) {
1750                         //Place and color inside this frame
1751                         uint16 placeFrame = place;
1752                         uint8 colorFrame = color;
1753 
1754                         //Each Movement results in different output
1755                         if (movement == 0) {
1756                             // Do nothing
1757                         } else if (movement == 1) {
1758                             placeFrame = (place + k) % 625;
1759                         } else if (movement == 2) {
1760                             colorFrame = color + (k % 3);
1761                         } else if (movement == 3) {
1762                             colorFrame = (color - 1) + ((k + 1) % 3);
1763                         } else if (movement == 4) {
1764                             colorFrame = (color - 2) + ((k + 2) % 3);
1765                         } else if (movement == 5) {
1766                             placeFrame = placeFrame + ((k / 4) % 2);
1767                         } else if (movement == 6) {
1768                             if (0 >= k || k >= 11) {
1769                                 continue;
1770                             }
1771                         } else if (movement == 7) {
1772                             if (1 >= k || k >= 10) {
1773                                 continue;
1774                             }
1775                         } else if (movement == 8) {
1776                             if (2 >= k || k >= 9) {
1777                                 continue;
1778                             }
1779                         } else if (movement == 9) {
1780                             if (3 >= k || k >= 8) {
1781                                 continue;
1782                             }
1783                         } else if (movement == 10) {
1784                             if (4 >= k || k >= 7) {
1785                                 continue;
1786                             }
1787                         } else if (movement == 11) {
1788                             if (k > 5) {
1789                                 placeFrame = place - 25;
1790                             }
1791                         } else if (movement == 12) {
1792                             if (k == 3 || k == 5) {
1793                                 placeFrame = place - 25;
1794                             }
1795                         } else if (movement == 13) {
1796                             if ((k / 3) % 2 == 0) {
1797                                 continue;
1798                             }
1799                         } else if (movement == 14) {
1800                             if ((k / 3) % 2 != 0) {
1801                                 continue;
1802                             }
1803                         } else if (movement == 15) {
1804                             placeFrame = place + (k / 2) * 25;
1805                         } else if (movement == 16) {
1806                             if (k % 2 != 0) {
1807                                 continue;
1808                             }
1809                         } else if (movement == 17) {
1810                             placeFrame = place + (k / 2) * 26;
1811                             if (placeFrame >= 625) {
1812                                 continue;
1813                             }
1814                         } else if (movement == 18) {
1815                             if ((k/2) == 2 || (k/2) == 4) {
1816                                 placeFrame = place - 25;
1817                             }
1818                         } else if (movement == 19) {
1819                             if((k/2)%2 == 1){
1820                                 placeFrame = place - 1;                               
1821                            }
1822                         } else if (movement == 20) {
1823                             placeFrame = place + ((k+3) / 2) % 2;
1824                         } else if (movement == 21) {
1825                             if(k<6){
1826                                 placeFrame = place + k;
1827                             }else{
1828                                 placeFrame = place + (12-k);
1829                             }
1830                             if(placeFrame > 37) continue;
1831                             colorFrame = color + k/6;
1832                         }else if (movement == 22) {
1833                             if(k<6){
1834                                 if(placeFrame > 42 - k) continue;
1835                             }else{
1836                                 if(placeFrame > 42 - (12-k)) continue;
1837                             }                            
1838                             colorFrame = color - k/6;
1839                         }else if (movement == 23) {
1840                            if(k%2 == 0){
1841                                if(k%4 == 0){ 
1842                                    placeFrame = place + 1;
1843                                } else {
1844                                    placeFrame = place - 1;
1845                                }
1846                            }
1847                         } else if (movement == 24) {
1848                             placeFrame = placeFrame - ((k / 4) % 2);
1849                         } else if (movement == 24) {
1850                             placeFrame = placeFrame + ((k / 3) % 2);
1851                         }
1852 
1853                         // Only set the Pixel if not set before
1854                         if (placedPixels[k][placeFrame]) continue;
1855 
1856                         //Set the color
1857                         colorBytes[k][placeFrame] = abi.encodePacked(
1858                             colorFrame
1859                         )[0];
1860                         placedPixels[k][placeFrame] = true;
1861                     }
1862                     place += 1;
1863                 }
1864             }
1865         }
1866      
1867         
1868         /* Define the GIF         
1869             Header: \x47\x49\x46\x38\x39\x61
1870             Size (100px x 100px):  \x64\x00\x64\x00
1871             Define of length of Global Color Table (64 colors): \xF5
1872             Background color (not used): \x02 
1873             Default pixel ratio: \x00
1874             Color table with 64 colors (in RGB):    \x00\x00\x00
1875                                                     \x43\xF6\xEE
1876                                                     ...
1877                                                     \x00\x00\x00
1878             Application Extension: \x21\xFF
1879                 Size of block including application name and verification bytes (always 11): \x0B
1880                 8-byte application name plus 3 verification bytes: \x4E\x45\x54\x53\x43\x41\x50\x45\x32\x2E\x30
1881                 Number of bytes in the following sub block: \x03
1882                     Subblock: 
1883                         Index of subblock: \x01
1884                         Number of repetitions (never ends): \x00\x00
1885             End of Application extension: \x00
1886       */
1887         bytes
1888             memory gifHex = "\x47\x49\x46\x38\x39\x61\x64\x00\x64\x00\xF5\x02\x00\x00\x00\x00\xF6\x43\x7F\x43\xF6\xEE\x5D\xF6\x43\x4A\xC7\x35\xFF\xD7\x00\xFE\xE2\x4D\xFE\xDC\x25\xC0\xC0\xC0\xD0\xD0\xD0\xDF\xDF\xDF\x00\x00\x00\x00\x3A\x04\x00\x49\x05\x00\x5E\x07\x27\x07\x3E\x2E\xBD\xB7\x31\x25\x06\x3A\x05\x05\x3D\x0B\x60\x46\x16\x70\x48\x27\x60\x52\x48\x2D\x52\x4B\x35\x5A\x44\x0A\x5C\x1E\x92\x63\x59\x3D\x67\x59\x37\x6B\x20\xAC\x6B\x61\x44\x6D\x15\x15\x6D\x5D\x34\x6D\x6D\x6D\x80\x6B\x34\x82\x80\x79\x8B\x69\x11\x8D\x7E\x57\x92\x47\x47\x9A\x4E\x6E\xA9\xA9\xA9\xB1\x9D\x68\xBD\xAB\x79\xC5\x9F\x9F\xCA\xD4\x38\xCC\x73\x20\xDD\x7B\x1F\xE5\xBC\xBC\xE7\xE7\xE7\xEB\xF6\x43\xEF\x79\xAB\xF0\xD9\xE3\xFF\x00\x00\xFF\xF9\xF9\xFF\xFF\x00\xFF\xFF\xFF\x08\x26\x42\x11\x37\x5C\x22\x53\x81\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x21\xFF\x0B\x4E\x45\x54\x53\x43\x41\x50\x45\x32\x2E\x30\x03\x01\x00\x00\x00";
1889 
1890         //For each Frame add Hex value to the gifHex
1891         for (uint256 i = 0; i < 12; i++) {
1892             gifHex = abi.encodePacked(gifHex, hexByColors(colorBytes[i]));
1893         }
1894 
1895         //Add Last byte in the file: \x3B
1896         gifHex = abi.encodePacked(gifHex, "\x3B");
1897         return CatLib.encode(gifHex);
1898     }
1899 
1900     /**
1901      * @dev Get the Hex of the GIF by Color-Bytes
1902      * @param colorBytes Bytes of Colors for the GIF (625 Bytes)
1903      */
1904     function hexByColors(bytes memory colorBytes)
1905         public
1906         pure
1907         returns (bytes memory)
1908     {
1909         bytes memory returnHex;
1910         bytes memory tempBytes;
1911 
1912         // For each row in the gif (25x25 = 625 colors)
1913         for (uint256 i = 0; i < colorBytes.length / 25; i++) {
1914             // Get Hex of the row
1915             tempBytes = hexgetLine(colorBytes, i * 25);
1916 
1917             //Because we want a 100x100px Gif: Copy the line 4 times
1918             for (uint256 j = 0; j < 4; j++) {
1919                 returnHex = abi.encodePacked(returnHex, tempBytes);
1920             }
1921         }
1922 
1923         /*returnHex Explanation: 
1924             Graphic Control Extension: \x21\xF9
1925                 Amount of GCE bytes: \x04
1926                     Transparent color given (yes): \x09
1927                     Frame delay (0,16s): \x11\x00
1928                     Transparent color (The first color in the Global Color Table):\x00
1929             End of GCE extension: \x00
1930             Image Descriptor: \x2C
1931                 North-west corner position of frame: \x00\x00\x00\x00
1932                 Frame width (100x100px):\x64\x00\x64\x00
1933                 Local color table (not used):\x00
1934                 Minimum LZW (Lempel-Ziv-Welch) compression: \x07
1935 
1936                 Hex LZW
1937 
1938                 Last Bytes of LZW: \x01\x81
1939             End of Image Descriptor: \x00 
1940         */
1941         returnHex = abi.encodePacked(
1942             "\x21\xF9\x04\x09\x11\x00\x00\x00\x2C\x00\x00\x00\x00\x64\x00\x64\x00\x00\x07",
1943             returnHex,
1944             "\x01\x81\x00"
1945         );
1946         return returnHex;
1947     }
1948 
1949     /**
1950      * @dev Get Hex-value for one row of the GIF
1951      * @param colorBytes Bytes of Colors for the GIF
1952      * @param startindex The start index of the row
1953      */
1954     function hexgetLine(bytes memory colorBytes, uint256 startindex)
1955         public
1956         pure
1957         returns (bytes memory)
1958     {
1959         bytes memory returnHex;
1960         // For each color: add the byte 4 times
1961         for (uint256 i = startindex; i < startindex + 25; i++) {
1962             bytes1 tempByte = colorBytes[i];
1963             for (uint256 j = 0; j < 4; j++) {
1964                 returnHex = abi.encodePacked(returnHex, tempByte);
1965             }
1966         }
1967 
1968         /*
1969             Length of the Part (25*4 + 1): \x65
1970             Clear Code (relevant for LZW): \x80 
1971         */
1972         return abi.encodePacked("\x65\x80", returnHex);
1973     }
1974 
1975     /**
1976      * @dev Hash to metadata function
1977      * @param _hash The Hash to generate the Metadata
1978      */
1979     function hashToMetadata(string memory _hash)
1980         public
1981         view
1982         returns (string memory)
1983     {
1984         string memory metadataString;
1985 
1986         for (uint8 i = 0; i < 7; i++) {
1987             uint8 thisTraitIndex = CatLib.parseInt(
1988                 CatLib.substring(_hash, i, i + 1)
1989             );
1990 
1991             metadataString = string(
1992                 abi.encodePacked(
1993                     metadataString,
1994                     '{"trait_type":"',
1995                     traitTypes[i][thisTraitIndex].traitType,
1996                     '","value":"',
1997                     traitTypes[i][thisTraitIndex].traitName,
1998                     '"}'
1999                 )
2000             );
2001 
2002             if (i < 6)
2003                 metadataString = string(abi.encodePacked(metadataString, ","));
2004         }
2005 
2006         return string(abi.encodePacked("[", metadataString, "]"));
2007     }
2008 
2009     /**
2010      * @dev Get Has by TokenID
2011      * @param _tokenId Token ID 
2012      */
2013     function _tokenIdToHash(uint256 _tokenId)
2014         public
2015         view
2016         returns (string memory)
2017     {
2018         string memory tokenHash = tokenIdToHash[_tokenId];
2019         return tokenHash;
2020     }   
2021 
2022     /*
2023   ___   __    __  ____     ___  ____       _____  __ __  ____     __ ______  ____  ___   ____   _____
2024  /   \ |  |__|  ||    \   /  _]|    \     |     ||  |  ||    \   /  ]      ||    |/   \ |    \ / ___/
2025 |     ||  |  |  ||  _  | /  [_ |  D  )    |   __||  |  ||  _  | /  /|      | |  ||     ||  _  (   \_ 
2026 |  O  ||  |  |  ||  |  ||    _]|    /     |  |_  |  |  ||  |  |/  / |_|  |_| |  ||  O  ||  |  |\__  |
2027 |     ||  `  '  ||  |  ||   [_ |    \     |   _] |  :  ||  |  /   \_  |  |   |  ||     ||  |  |/  \ |
2028 |     | \      / |  |  ||     ||  .  \    |  |   |     ||  |  \     | |  |   |  ||     ||  |  |\    |
2029  \___/   \_/\_/  |__|__||_____||__|\_|    |__|    \__,_||__|__|\____| |__|  |____|\___/ |__|__| \___|
2030                                                                                                     
2031     */
2032 
2033     /**
2034      * @dev Modifier to only allow owner to call functions
2035      */
2036     modifier onlyOwner() {
2037         require(_owner == msg.sender);
2038         _;
2039     }
2040 
2041     /**
2042      * @dev Clears the traits.
2043      */
2044     function clearTraits() public onlyOwner {
2045         for (uint256 i = 0; i < 7; i++) {
2046             delete traitTypes[i];
2047         }
2048     }
2049 
2050     /**
2051      * @dev Add a trait type
2052      * @param _traitTypeIndex The trait type index
2053      * @param traits Array of traits to add
2054      */
2055 
2056     function addTraitType(uint256 _traitTypeIndex, Trait[] memory traits)
2057         public
2058         onlyOwner
2059     {
2060         for (uint256 i = 0; i < traits.length; i++) {
2061             traitTypes[_traitTypeIndex].push(
2062                 Trait(
2063                     traits[i].traitName,
2064                     traits[i].traitType,
2065                     traits[i].pixels
2066                 )
2067             );
2068         }
2069     }
2070 
2071     /**
2072      * @dev Transfers ownership
2073      * @param _newOwner The new owner
2074      */
2075     function transferOwnership(address _newOwner) public onlyOwner {
2076         _owner = _newOwner;
2077     }
2078 
2079     /**
2080      * @dev Withdraw Ether
2081      */
2082     function withdraw() public onlyOwner {
2083         uint256 balance = address(this).balance;
2084         require(balance > 0, "Balance is zero");
2085         payable(msg.sender).transfer(balance);
2086     }
2087 
2088     /**
2089      * @dev Owner Mint
2090      */
2091     function mintCatOwner() public onlyOwner {
2092         mintCat();      
2093     }
2094 }