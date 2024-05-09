1 // SPDX-License-Identifier: MIT LICENSE
2 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length)
56         internal
57         pure
58         returns (string memory)
59     {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
73 pragma solidity ^0.8.1;
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      *
96      * [IMPORTANT]
97      * ====
98      * You shouldn't rely on `isContract` to protect against flash loan attacks!
99      *
100      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
101      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
102      * constructor.
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize/address.code.length, which returns 0
107         // for contracts in construction, since the code is only stored at the end
108         // of the constructor execution.
109 
110         return account.code.length > 0;
111     }
112 
113     /**
114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
115      * `recipient`, forwarding all available gas and reverting on errors.
116      *
117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
119      * imposed by `transfer`, making them unable to receive funds via
120      * `transfer`. {sendValue} removes this limitation.
121      *
122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
123      *
124      * IMPORTANT: because control is transferred to `recipient`, care must be
125      * taken to not create reentrancy vulnerabilities. Consider using
126      * {ReentrancyGuard} or the
127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
128      */
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(
131             address(this).balance >= amount,
132             "Address: insufficient balance"
133         );
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(
137             success,
138             "Address: unable to send value, recipient may have reverted"
139         );
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain `call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data)
161         internal
162         returns (bytes memory)
163     {
164         return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but also transferring `value` wei to `target`.
184      *
185      * Requirements:
186      *
187      * - the calling contract must have an ETH balance of at least `value`.
188      * - the called Solidity function must be `payable`.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value
196     ) internal returns (bytes memory) {
197         return
198             functionCallWithValue(
199                 target,
200                 data,
201                 value,
202                 "Address: low-level call with value failed"
203             );
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
208      * with `errorMessage` as a fallback revert reason when `target` reverts.
209      *
210      * _Available since v3.1._
211      */
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(
219             address(this).balance >= value,
220             "Address: insufficient balance for call"
221         );
222         require(isContract(target), "Address: call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.call{value: value}(
225             data
226         );
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(address target, bytes memory data)
237         internal
238         view
239         returns (bytes memory)
240     {
241         return
242             functionStaticCall(
243                 target,
244                 data,
245                 "Address: low-level static call failed"
246             );
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal view returns (bytes memory) {
260         require(isContract(target), "Address: static call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.staticcall(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(address target, bytes memory data)
273         internal
274         returns (bytes memory)
275     {
276         return
277             functionDelegateCall(
278                 target,
279                 data,
280                 "Address: low-level delegate call failed"
281             );
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a delegate call.
287      *
288      * _Available since v3.4._
289      */
290     function functionDelegateCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         require(isContract(target), "Address: delegate call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.delegatecall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
303      * revert reason using the provided one.
304      *
305      * _Available since v4.3._
306      */
307     function verifyCallResult(
308         bool success,
309         bytes memory returndata,
310         string memory errorMessage
311     ) internal pure returns (bytes memory) {
312         if (success) {
313             return returndata;
314         } else {
315             // Look for revert reason and bubble it up if present
316             if (returndata.length > 0) {
317                 // The easiest way to bubble the revert reason is using memory via assembly
318 
319                 assembly {
320                     let returndata_size := mload(returndata)
321                     revert(add(32, returndata), returndata_size)
322                 }
323             } else {
324                 revert(errorMessage);
325             }
326         }
327     }
328 }
329 
330 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @title ERC721 token receiver interface
335  * @dev Interface for any contract that wants to support safeTransfers
336  * from ERC721 asset contracts.
337  */
338 interface IERC721Receiver {
339     /**
340      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
341      * by `operator` from `from`, this function is called.
342      *
343      * It must return its Solidity selector to confirm the token transfer.
344      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
345      *
346      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
347      */
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @dev Interface of the ERC165 standard, as defined in the
361  * https://eips.ethereum.org/EIPS/eip-165[EIP].
362  *
363  * Implementers can declare support of contract interfaces, which can then be
364  * queried by others ({ERC165Checker}).
365  *
366  * For an implementation, see {ERC165}.
367  */
368 interface IERC165 {
369     /**
370      * @dev Returns true if this contract implements the interface defined by
371      * `interfaceId`. See the corresponding
372      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
373      * to learn more about how these ids are created.
374      *
375      * This function call must use less than 30 000 gas.
376      */
377     function supportsInterface(bytes4 interfaceId) external view returns (bool);
378 }
379 
380 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
381 pragma solidity ^0.8.0;
382 
383 /**
384  * @dev Implementation of the {IERC165} interface.
385  *
386  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
387  * for the additional interface id that will be supported. For example:
388  *
389  * ```solidity
390  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
391  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
392  * }
393  * ```
394  *
395  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
396  */
397 abstract contract ERC165 is IERC165 {
398     /**
399      * @dev See {IERC165-supportsInterface}.
400      */
401     function supportsInterface(bytes4 interfaceId)
402         public
403         view
404         virtual
405         override
406         returns (bool)
407     {
408         return interfaceId == type(IERC165).interfaceId;
409     }
410 }
411 
412 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @dev Required interface of an ERC721 compliant contract.
417  */
418 interface IERC721 is IERC165 {
419     /**
420      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
421      */
422     event Transfer(
423         address indexed from,
424         address indexed to,
425         uint256 indexed tokenId
426     );
427 
428     /**
429      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
430      */
431     event Approval(
432         address indexed owner,
433         address indexed approved,
434         uint256 indexed tokenId
435     );
436 
437     /**
438      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
439      */
440     event ApprovalForAll(
441         address indexed owner,
442         address indexed operator,
443         bool approved
444     );
445 
446     /**
447      * @dev Returns the number of tokens in ``owner``'s account.
448      */
449     function balanceOf(address owner) external view returns (uint256 balance);
450 
451     /**
452      * @dev Returns the owner of the `tokenId` token.
453      *
454      * Requirements:
455      *
456      * - `tokenId` must exist.
457      */
458     function ownerOf(uint256 tokenId) external view returns (address owner);
459 
460     /**
461      * @dev Safely transfers `tokenId` token from `from` to `to`.
462      *
463      * Requirements:
464      *
465      * - `from` cannot be the zero address.
466      * - `to` cannot be the zero address.
467      * - `tokenId` token must exist and be owned by `from`.
468      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
469      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
470      *
471      * Emits a {Transfer} event.
472      */
473     function safeTransferFrom(
474         address from,
475         address to,
476         uint256 tokenId,
477         bytes calldata data
478     ) external;
479 
480     /**
481      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
482      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must exist and be owned by `from`.
489      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
490      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491      *
492      * Emits a {Transfer} event.
493      */
494     function safeTransferFrom(
495         address from,
496         address to,
497         uint256 tokenId
498     ) external;
499 
500     /**
501      * @dev Transfers `tokenId` token from `from` to `to`.
502      *
503      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must be owned by `from`.
510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transferFrom(
515         address from,
516         address to,
517         uint256 tokenId
518     ) external;
519 
520     /**
521      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
522      * The approval is cleared when the token is transferred.
523      *
524      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
525      *
526      * Requirements:
527      *
528      * - The caller must own the token or be an approved operator.
529      * - `tokenId` must exist.
530      *
531      * Emits an {Approval} event.
532      */
533     function approve(address to, uint256 tokenId) external;
534 
535     /**
536      * @dev Approve or remove `operator` as an operator for the caller.
537      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
538      *
539      * Requirements:
540      *
541      * - The `operator` cannot be the caller.
542      *
543      * Emits an {ApprovalForAll} event.
544      */
545     function setApprovalForAll(address operator, bool _approved) external;
546 
547     /**
548      * @dev Returns the account approved for `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function getApproved(uint256 tokenId)
555         external
556         view
557         returns (address operator);
558 
559     /**
560      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
561      *
562      * See {setApprovalForAll}
563      */
564     function isApprovedForAll(address owner, address operator)
565         external
566         view
567         returns (bool);
568 }
569 
570 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
575  * @dev See https://eips.ethereum.org/EIPS/eip-721
576  */
577 interface IERC721Enumerable is IERC721 {
578     /**
579      * @dev Returns the total amount of tokens stored by the contract.
580      */
581     function totalSupply() external view returns (uint256);
582 
583     /**
584      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
585      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
586      */
587     function tokenOfOwnerByIndex(address owner, uint256 index)
588         external
589         view
590         returns (uint256);
591 
592     /**
593      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
594      * Use along with {totalSupply} to enumerate all tokens.
595      */
596     function tokenByIndex(uint256 index) external view returns (uint256);
597 }
598 
599 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
604  * @dev See https://eips.ethereum.org/EIPS/eip-721
605  */
606 interface IERC721Metadata is IERC721 {
607     /**
608      * @dev Returns the token collection name.
609      */
610     function name() external view returns (string memory);
611 
612     /**
613      * @dev Returns the token collection symbol.
614      */
615     function symbol() external view returns (string memory);
616 
617     /**
618      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
619      */
620     function tokenURI(uint256 tokenId) external view returns (string memory);
621 }
622 
623 // File: @openzeppelin/contracts/utils/Context.sol
624 
625 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Provides information about the current execution context, including the
631  * sender of the transaction and its data. While these are generally available
632  * via msg.sender and msg.data, they should not be accessed in such a direct
633  * manner, since when dealing with meta-transactions the account sending and
634  * paying for execution may not be the actual sender (as far as an application
635  * is concerned).
636  *
637  * This contract is only required for intermediate, library-like contracts.
638  */
639 abstract contract Context {
640     function _msgSender() internal view virtual returns (address) {
641         return msg.sender;
642     }
643 
644     function _msgData() internal view virtual returns (bytes calldata) {
645         return msg.data;
646     }
647 }
648 
649 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
654  * the Metadata extension, but not including the Enumerable extension, which is available separately as
655  * {ERC721Enumerable}.
656  */
657 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
658     using Address for address;
659     using Strings for uint256;
660 
661     // Token name
662     string private _name;
663 
664     // Token symbol
665     string private _symbol;
666 
667     // Mapping from token ID to owner address
668     mapping(uint256 => address) private _owners;
669 
670     // Mapping owner address to token count
671     mapping(address => uint256) private _balances;
672 
673     // Mapping from token ID to approved address
674     mapping(uint256 => address) private _tokenApprovals;
675 
676     // Mapping from owner to operator approvals
677     mapping(address => mapping(address => bool)) private _operatorApprovals;
678 
679     /**
680      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
681      */
682     constructor(string memory name_, string memory symbol_) {
683         _name = name_;
684         _symbol = symbol_;
685     }
686 
687     /**
688      * @dev See {IERC165-supportsInterface}.
689      */
690     function supportsInterface(bytes4 interfaceId)
691         public
692         view
693         virtual
694         override(ERC165, IERC165)
695         returns (bool)
696     {
697         return
698             interfaceId == type(IERC721).interfaceId ||
699             interfaceId == type(IERC721Metadata).interfaceId ||
700             super.supportsInterface(interfaceId);
701     }
702 
703     /**
704      * @dev See {IERC721-balanceOf}.
705      */
706     function balanceOf(address owner)
707         public
708         view
709         virtual
710         override
711         returns (uint256)
712     {
713         require(
714             owner != address(0),
715             "ERC721: balance query for the zero address"
716         );
717         return _balances[owner];
718     }
719 
720     /**
721      * @dev See {IERC721-ownerOf}.
722      */
723     function ownerOf(uint256 tokenId)
724         public
725         view
726         virtual
727         override
728         returns (address)
729     {
730         address owner = _owners[tokenId];
731         require(
732             owner != address(0),
733             "ERC721: owner query for nonexistent token"
734         );
735         return owner;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-name}.
740      */
741     function name() public view virtual override returns (string memory) {
742         return _name;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-symbol}.
747      */
748     function symbol() public view virtual override returns (string memory) {
749         return _symbol;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-tokenURI}.
754      */
755     function tokenURI(uint256 tokenId)
756         public
757         view
758         virtual
759         override
760         returns (string memory)
761     {
762         require(
763             _exists(tokenId),
764             "ERC721Metadata: URI query for nonexistent token"
765         );
766 
767         string memory baseURI = _baseURI();
768         return
769             bytes(baseURI).length > 0
770                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
771                 : "";
772     }
773 
774     /**
775      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
776      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
777      * by default, can be overridden in child contracts.
778      */
779     function _baseURI() internal view virtual returns (string memory) {
780         return "";
781     }
782 
783     /**
784      * @dev See {IERC721-approve}.
785      */
786     function approve(address to, uint256 tokenId) public virtual override {
787         address owner = ERC721.ownerOf(tokenId);
788         require(to != owner, "ERC721: approval to current owner");
789 
790         require(
791             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
792             "ERC721: approve caller is not owner nor approved for all"
793         );
794 
795         _approve(to, tokenId);
796     }
797 
798     /**
799      * @dev See {IERC721-getApproved}.
800      */
801     function getApproved(uint256 tokenId)
802         public
803         view
804         virtual
805         override
806         returns (address)
807     {
808         require(
809             _exists(tokenId),
810             "ERC721: approved query for nonexistent token"
811         );
812 
813         return _tokenApprovals[tokenId];
814     }
815 
816     /**
817      * @dev See {IERC721-setApprovalForAll}.
818      */
819     function setApprovalForAll(address operator, bool approved)
820         public
821         virtual
822         override
823     {
824         _setApprovalForAll(_msgSender(), operator, approved);
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
946             isApprovedForAll(owner, spender) ||
947             getApproved(tokenId) == spender);
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
1002 
1003         _afterTokenTransfer(address(0), to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev Destroys `tokenId`.
1008      * The approval is cleared when the token is burned.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must exist.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _burn(uint256 tokenId) internal virtual {
1017         address owner = ERC721.ownerOf(tokenId);
1018 
1019         _beforeTokenTransfer(owner, address(0), tokenId);
1020 
1021         // Clear approvals
1022         _approve(address(0), tokenId);
1023 
1024         _balances[owner] -= 1;
1025         delete _owners[tokenId];
1026 
1027         emit Transfer(owner, address(0), tokenId);
1028 
1029         _afterTokenTransfer(owner, address(0), tokenId);
1030     }
1031 
1032     /**
1033      * @dev Transfers `tokenId` from `from` to `to`.
1034      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `tokenId` token must be owned by `from`.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _transfer(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) internal virtual {
1048         require(
1049             ERC721.ownerOf(tokenId) == from,
1050             "ERC721: transfer from incorrect owner"
1051         );
1052         require(to != address(0), "ERC721: transfer to the zero address");
1053 
1054         _beforeTokenTransfer(from, to, tokenId);
1055 
1056         // Clear approvals from the previous owner
1057         _approve(address(0), tokenId);
1058 
1059         _balances[from] -= 1;
1060         _balances[to] += 1;
1061         _owners[tokenId] = to;
1062 
1063         emit Transfer(from, to, tokenId);
1064 
1065         _afterTokenTransfer(from, to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Approve `to` to operate on `tokenId`
1070      *
1071      * Emits a {Approval} event.
1072      */
1073     function _approve(address to, uint256 tokenId) internal virtual {
1074         _tokenApprovals[tokenId] = to;
1075         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Approve `operator` to operate on all of `owner` tokens
1080      *
1081      * Emits a {ApprovalForAll} event.
1082      */
1083     function _setApprovalForAll(
1084         address owner,
1085         address operator,
1086         bool approved
1087     ) internal virtual {
1088         require(owner != operator, "ERC721: approve to caller");
1089         _operatorApprovals[owner][operator] = approved;
1090         emit ApprovalForAll(owner, operator, approved);
1091     }
1092 
1093     /**
1094      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1095      * The call is not executed if the target address is not a contract.
1096      *
1097      * @param from address representing the previous owner of the given token ID
1098      * @param to target address that will receive the tokens
1099      * @param tokenId uint256 ID of the token to be transferred
1100      * @param _data bytes optional data to send along with the call
1101      * @return bool whether the call correctly returned the expected magic value
1102      */
1103     function _checkOnERC721Received(
1104         address from,
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) private returns (bool) {
1109         if (to.isContract()) {
1110             try
1111                 IERC721Receiver(to).onERC721Received(
1112                     _msgSender(),
1113                     from,
1114                     tokenId,
1115                     _data
1116                 )
1117             returns (bytes4 retval) {
1118                 return retval == IERC721Receiver.onERC721Received.selector;
1119             } catch (bytes memory reason) {
1120                 if (reason.length == 0) {
1121                     revert(
1122                         "ERC721: transfer to non ERC721Receiver implementer"
1123                     );
1124                 } else {
1125                     assembly {
1126                         revert(add(32, reason), mload(reason))
1127                     }
1128                 }
1129             }
1130         } else {
1131             return true;
1132         }
1133     }
1134 
1135     /**
1136      * @dev Hook that is called before any token transfer. This includes minting
1137      * and burning.
1138      *
1139      * Calling conditions:
1140      *
1141      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1142      * transferred to `to`.
1143      * - When `from` is zero, `tokenId` will be minted for `to`.
1144      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1145      * - `from` and `to` are never both zero.
1146      *
1147      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1148      */
1149     function _beforeTokenTransfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) internal virtual {}
1154 
1155     /**
1156      * @dev Hook that is called after any transfer of tokens. This includes
1157      * minting and burning.
1158      *
1159      * Calling conditions:
1160      *
1161      * - when `from` and `to` are both non-zero.
1162      * - `from` and `to` are never both zero.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _afterTokenTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) internal virtual {}
1171 }
1172 
1173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1174 pragma solidity ^0.8.0;
1175 
1176 /**
1177  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1178  * enumerability of all the token ids in the contract as well as all token ids owned by each
1179  * account.
1180  */
1181 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1182     // Mapping from owner to list of owned token IDs
1183     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1184 
1185     // Mapping from token ID to index of the owner tokens list
1186     mapping(uint256 => uint256) private _ownedTokensIndex;
1187 
1188     // Array with all token ids, used for enumeration
1189     uint256[] private _allTokens;
1190 
1191     // Mapping from token id to position in the allTokens array
1192     mapping(uint256 => uint256) private _allTokensIndex;
1193 
1194     /**
1195      * @dev See {IERC165-supportsInterface}.
1196      */
1197     function supportsInterface(bytes4 interfaceId)
1198         public
1199         view
1200         virtual
1201         override(IERC165, ERC721)
1202         returns (bool)
1203     {
1204         return
1205             interfaceId == type(IERC721Enumerable).interfaceId ||
1206             super.supportsInterface(interfaceId);
1207     }
1208 
1209     /**
1210      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1211      */
1212     function tokenOfOwnerByIndex(address owner, uint256 index)
1213         public
1214         view
1215         virtual
1216         override
1217         returns (uint256)
1218     {
1219         require(
1220             index < ERC721.balanceOf(owner),
1221             "ERC721Enumerable: owner index out of bounds"
1222         );
1223         return _ownedTokens[owner][index];
1224     }
1225 
1226     /**
1227      * @dev See {IERC721Enumerable-totalSupply}.
1228      */
1229     function totalSupply() public view virtual override returns (uint256) {
1230         return _allTokens.length;
1231     }
1232 
1233     /**
1234      * @dev See {IERC721Enumerable-tokenByIndex}.
1235      */
1236     function tokenByIndex(uint256 index)
1237         public
1238         view
1239         virtual
1240         override
1241         returns (uint256)
1242     {
1243         require(
1244             index < ERC721Enumerable.totalSupply(),
1245             "ERC721Enumerable: global index out of bounds"
1246         );
1247         return _allTokens[index];
1248     }
1249 
1250     /**
1251      * @dev Hook that is called before any token transfer. This includes minting
1252      * and burning.
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` will be minted for `to`.
1259      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1260      * - `from` cannot be the zero address.
1261      * - `to` cannot be the zero address.
1262      *
1263      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1264      */
1265     function _beforeTokenTransfer(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) internal virtual override {
1270         super._beforeTokenTransfer(from, to, tokenId);
1271 
1272         if (from == address(0)) {
1273             _addTokenToAllTokensEnumeration(tokenId);
1274         } else if (from != to) {
1275             _removeTokenFromOwnerEnumeration(from, tokenId);
1276         }
1277         if (to == address(0)) {
1278             _removeTokenFromAllTokensEnumeration(tokenId);
1279         } else if (to != from) {
1280             _addTokenToOwnerEnumeration(to, tokenId);
1281         }
1282     }
1283 
1284     /**
1285      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1286      * @param to address representing the new owner of the given token ID
1287      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1288      */
1289     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1290         uint256 length = ERC721.balanceOf(to);
1291         _ownedTokens[to][length] = tokenId;
1292         _ownedTokensIndex[tokenId] = length;
1293     }
1294 
1295     /**
1296      * @dev Private function to add a token to this extension's token tracking data structures.
1297      * @param tokenId uint256 ID of the token to be added to the tokens list
1298      */
1299     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1300         _allTokensIndex[tokenId] = _allTokens.length;
1301         _allTokens.push(tokenId);
1302     }
1303 
1304     /**
1305      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1306      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1307      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1308      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1309      * @param from address representing the previous owner of the given token ID
1310      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1311      */
1312     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1313         private
1314     {
1315         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1316         // then delete the last slot (swap and pop).
1317 
1318         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1319         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1320 
1321         // When the token to delete is the last token, the swap operation is unnecessary
1322         if (tokenIndex != lastTokenIndex) {
1323             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1324 
1325             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1326             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1327         }
1328 
1329         // This also deletes the contents at the last position of the array
1330         delete _ownedTokensIndex[tokenId];
1331         delete _ownedTokens[from][lastTokenIndex];
1332     }
1333 
1334     /**
1335      * @dev Private function to remove a token from this extension's token tracking data structures.
1336      * This has O(1) time complexity, but alters the order of the _allTokens array.
1337      * @param tokenId uint256 ID of the token to be removed from the tokens list
1338      */
1339     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1340         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1341         // then delete the last slot (swap and pop).
1342 
1343         uint256 lastTokenIndex = _allTokens.length - 1;
1344         uint256 tokenIndex = _allTokensIndex[tokenId];
1345 
1346         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1347         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1348         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1349         uint256 lastTokenId = _allTokens[lastTokenIndex];
1350 
1351         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1352         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1353 
1354         // This also deletes the contents at the last position of the array
1355         delete _allTokensIndex[tokenId];
1356         _allTokens.pop();
1357     }
1358 }
1359 
1360 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1361 pragma solidity ^0.8.0;
1362 
1363 /**
1364  * @dev Contract module which provides a basic access control mechanism, where
1365  * there is an account (an owner) that can be granted exclusive access to
1366  * specific functions.
1367  *
1368  * By default, the owner account will be the one that deploys the contract. This
1369  * can later be changed with {transferOwnership}.
1370  *
1371  * This module is used through inheritance. It will make available the modifier
1372  * `onlyOwner`, which can be applied to your functions to restrict their use to
1373  * the owner.
1374  */
1375 abstract contract Ownable is Context {
1376     address private _owner;
1377 
1378     event OwnershipTransferred(
1379         address indexed previousOwner,
1380         address indexed newOwner
1381     );
1382 
1383     /**
1384      * @dev Initializes the contract setting the deployer as the initial owner.
1385      */
1386     constructor() {
1387         _transferOwnership(_msgSender());
1388     }
1389 
1390     /**
1391      * @dev Returns the address of the current owner.
1392      */
1393     function owner() public view virtual returns (address) {
1394         return _owner;
1395     }
1396 
1397     /**
1398      * @dev Throws if called by any account other than the owner.
1399      */
1400     modifier onlyOwner() {
1401         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1402         _;
1403     }
1404 
1405     /**
1406      * @dev Leaves the contract without owner. It will not be possible to call
1407      * `onlyOwner` functions anymore. Can only be called by the current owner.
1408      *
1409      * NOTE: Renouncing ownership will leave the contract without an owner,
1410      * thereby removing any functionality that is only available to the owner.
1411      */
1412     function renounceOwnership() public virtual onlyOwner {
1413         _transferOwnership(address(0));
1414     }
1415 
1416     /**
1417      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1418      * Can only be called by the current owner.
1419      */
1420     function transferOwnership(address newOwner) public virtual onlyOwner {
1421         require(
1422             newOwner != address(0),
1423             "Ownable: new owner is the zero address"
1424         );
1425         _transferOwnership(newOwner);
1426     }
1427 
1428     /**
1429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1430      * Internal function without access restriction.
1431      */
1432     function _transferOwnership(address newOwner) internal virtual {
1433         address oldOwner = _owner;
1434         _owner = newOwner;
1435         emit OwnershipTransferred(oldOwner, newOwner);
1436     }
1437 }
1438 
1439 pragma solidity 0.8.4;
1440 
1441 contract BGFSTYX is Ownable, IERC721Receiver {
1442 
1443     address public familiars;
1444     address public towers;
1445     bool public claimingEnabled = true;
1446     bool public spendingEnabled = true;
1447     mapping(address => uint256) public bank;
1448 
1449     function getBankBalance(address _address) public view returns (uint256) {
1450         return bank[_address];
1451     }
1452 
1453     function spendBalanceFamiliars(address _address, uint256 _amount) public {
1454         require(spendingEnabled, "Balance spending functions are disabled.");
1455         require(msg.sender == familiars, "Not Allowed.");
1456         require(bank[_address] >= _amount, "Not Enough $STYX.");
1457         bank[_address] -= _amount;
1458     }
1459 
1460     function spendBalanceTowers(address _address, uint256 _amount) public {
1461         require(spendingEnabled, "Balance spending functions are disabled.");
1462         require(msg.sender == towers, "Not Allowed.");
1463         require(bank[_address] >= _amount, "Not Enough $STYX.");
1464         bank[_address] -= _amount;
1465     }
1466 
1467     function addStyxBalance(address _address, uint256 _amount)
1468         public
1469         onlyOwner
1470     {
1471         bank[_address] += _amount;
1472     }
1473 
1474     function decrStyxBalance(address _address, uint256 _amount)
1475         public
1476         onlyOwner
1477     {
1478         require(bank[_address] >= _amount, "Not Enough $STYX.");
1479         bank[_address] -= _amount;
1480     }
1481 
1482     function setStyxBalance(address _address, uint256 _amount)
1483         public
1484         onlyOwner
1485     {
1486         bank[_address] = _amount;
1487     }
1488 
1489     //Only Owner
1490     function setFamiliarsAddress(address _address) public onlyOwner {
1491         familiars = _address;
1492     }
1493 
1494     function setTowersAddress(address _address) public onlyOwner {
1495         towers = _address;
1496     }
1497 
1498     function toggleSpending(bool _state) public onlyOwner {
1499         spendingEnabled = _state;
1500     }
1501 
1502     function onERC721Received(
1503         address,
1504         address from,
1505         uint256,
1506         bytes calldata
1507     ) external pure override returns (bytes4) {
1508         require(from == address(0x0), "Cannot send Tokens to Vault directly");
1509 
1510         return IERC721Receiver.onERC721Received.selector;
1511     }
1512 }