1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @title ERC721 token receiver interface
6  * @dev Interface for any contract that wants to support safeTransfers
7  * from ERC721 asset contracts.
8  */
9 interface IERC721Receiver {
10     /**
11      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
12      * by `operator` from `from`, this function is called.
13      *
14      * It must return its Solidity selector to confirm the token transfer.
15      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
16      *
17      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
18      */
19     function onERC721Received(
20         address operator,
21         address from,
22         uint256 tokenId,
23         bytes calldata data
24     ) external returns (bytes4);
25 }
26 
27 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
56 
57 
58 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
59 
60 pragma solidity ^0.8.0;
61 
62 
63 /**
64  * @dev Required interface of an ERC1155 compliant contract, as defined in the
65  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
66  *
67  * _Available since v3.1._
68  */
69 interface IERC1155 is IERC165 {
70     /**
71      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
72      */
73     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
74 
75     /**
76      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
77      * transfers.
78      */
79     event TransferBatch(
80         address indexed operator,
81         address indexed from,
82         address indexed to,
83         uint256[] ids,
84         uint256[] values
85     );
86 
87     /**
88      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
89      * `approved`.
90      */
91     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
92 
93     /**
94      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
95      *
96      * If an {URI} event was emitted for `id`, the standard
97      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
98      * returned by {IERC1155MetadataURI-uri}.
99      */
100     event URI(string value, uint256 indexed id);
101 
102     /**
103      * @dev Returns the amount of tokens of token type `id` owned by `account`.
104      *
105      * Requirements:
106      *
107      * - `account` cannot be the zero address.
108      */
109     function balanceOf(address account, uint256 id) external view returns (uint256);
110 
111     /**
112      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
113      *
114      * Requirements:
115      *
116      * - `accounts` and `ids` must have the same length.
117      */
118     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
119         external
120         view
121         returns (uint256[] memory);
122 
123     /**
124      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
125      *
126      * Emits an {ApprovalForAll} event.
127      *
128      * Requirements:
129      *
130      * - `operator` cannot be the caller.
131      */
132     function setApprovalForAll(address operator, bool approved) external;
133 
134     /**
135      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
136      *
137      * See {setApprovalForAll}.
138      */
139     function isApprovedForAll(address account, address operator) external view returns (bool);
140 
141     /**
142      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
143      *
144      * Emits a {TransferSingle} event.
145      *
146      * Requirements:
147      *
148      * - `to` cannot be the zero address.
149      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
150      * - `from` must have a balance of tokens of type `id` of at least `amount`.
151      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
152      * acceptance magic value.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 id,
158         uint256 amount,
159         bytes calldata data
160     ) external;
161 
162     /**
163      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
164      *
165      * Emits a {TransferBatch} event.
166      *
167      * Requirements:
168      *
169      * - `ids` and `amounts` must have the same length.
170      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
171      * acceptance magic value.
172      */
173     function safeBatchTransferFrom(
174         address from,
175         address to,
176         uint256[] calldata ids,
177         uint256[] calldata amounts,
178         bytes calldata data
179     ) external;
180 }
181 
182 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 
190 /**
191  * @dev Implementation of the {IERC165} interface.
192  *
193  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
194  * for the additional interface id that will be supported. For example:
195  *
196  * ```solidity
197  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
198  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
199  * }
200  * ```
201  *
202  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
203  */
204 abstract contract ERC165 is IERC165 {
205     /**
206      * @dev See {IERC165-supportsInterface}.
207      */
208     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
209         return interfaceId == type(IERC165).interfaceId;
210     }
211 }
212 
213 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
214 
215 
216 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
217 
218 pragma solidity ^0.8.0;
219 
220 
221 /**
222  * @dev Required interface of an ERC721 compliant contract.
223  */
224 interface IERC721 is IERC165 {
225     /**
226      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
227      */
228     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
229 
230     /**
231      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
232      */
233     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
234 
235     /**
236      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
237      */
238     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
239 
240     /**
241      * @dev Returns the number of tokens in ``owner``'s account.
242      */
243     function balanceOf(address owner) external view returns (uint256 balance);
244 
245     /**
246      * @dev Returns the owner of the `tokenId` token.
247      *
248      * Requirements:
249      *
250      * - `tokenId` must exist.
251      */
252     function ownerOf(uint256 tokenId) external view returns (address owner);
253 
254     /**
255      * @dev Safely transfers `tokenId` token from `from` to `to`.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must exist and be owned by `from`.
262      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
263      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
264      *
265      * Emits a {Transfer} event.
266      */
267     function safeTransferFrom(
268         address from,
269         address to,
270         uint256 tokenId,
271         bytes calldata data
272     ) external;
273 
274     /**
275      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
276      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must exist and be owned by `from`.
283      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
284      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
285      *
286      * Emits a {Transfer} event.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external;
293 
294     /**
295      * @dev Transfers `tokenId` token from `from` to `to`.
296      *
297      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must be owned by `from`.
304      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(
309         address from,
310         address to,
311         uint256 tokenId
312     ) external;
313 
314     /**
315      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
316      * The approval is cleared when the token is transferred.
317      *
318      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
319      *
320      * Requirements:
321      *
322      * - The caller must own the token or be an approved operator.
323      * - `tokenId` must exist.
324      *
325      * Emits an {Approval} event.
326      */
327     function approve(address to, uint256 tokenId) external;
328 
329     /**
330      * @dev Approve or remove `operator` as an operator for the caller.
331      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
332      *
333      * Requirements:
334      *
335      * - The `operator` cannot be the caller.
336      *
337      * Emits an {ApprovalForAll} event.
338      */
339     function setApprovalForAll(address operator, bool _approved) external;
340 
341     /**
342      * @dev Returns the account approved for `tokenId` token.
343      *
344      * Requirements:
345      *
346      * - `tokenId` must exist.
347      */
348     function getApproved(uint256 tokenId) external view returns (address operator);
349 
350     /**
351      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
352      *
353      * See {setApprovalForAll}
354      */
355     function isApprovedForAll(address owner, address operator) external view returns (bool);
356 }
357 
358 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 
366 /**
367  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
368  * @dev See https://eips.ethereum.org/EIPS/eip-721
369  */
370 interface IERC721Metadata is IERC721 {
371     /**
372      * @dev Returns the token collection name.
373      */
374     function name() external view returns (string memory);
375 
376     /**
377      * @dev Returns the token collection symbol.
378      */
379     function symbol() external view returns (string memory);
380 
381     /**
382      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
383      */
384     function tokenURI(uint256 tokenId) external view returns (string memory);
385 }
386 
387 // File: @openzeppelin/contracts/utils/Strings.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev String operations.
396  */
397 library Strings {
398     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
402      */
403     function toString(uint256 value) internal pure returns (string memory) {
404         // Inspired by OraclizeAPI's implementation - MIT licence
405         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
406 
407         if (value == 0) {
408             return "0";
409         }
410         uint256 temp = value;
411         uint256 digits;
412         while (temp != 0) {
413             digits++;
414             temp /= 10;
415         }
416         bytes memory buffer = new bytes(digits);
417         while (value != 0) {
418             digits -= 1;
419             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
420             value /= 10;
421         }
422         return string(buffer);
423     }
424 
425     /**
426      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
427      */
428     function toHexString(uint256 value) internal pure returns (string memory) {
429         if (value == 0) {
430             return "0x00";
431         }
432         uint256 temp = value;
433         uint256 length = 0;
434         while (temp != 0) {
435             length++;
436             temp >>= 8;
437         }
438         return toHexString(value, length);
439     }
440 
441     /**
442      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
443      */
444     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
445         bytes memory buffer = new bytes(2 * length + 2);
446         buffer[0] = "0";
447         buffer[1] = "x";
448         for (uint256 i = 2 * length + 1; i > 1; --i) {
449             buffer[i] = _HEX_SYMBOLS[value & 0xf];
450             value >>= 4;
451         }
452         require(value == 0, "Strings: hex length insufficient");
453         return string(buffer);
454     }
455 }
456 
457 // File: @openzeppelin/contracts/utils/Context.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Provides information about the current execution context, including the
466  * sender of the transaction and its data. While these are generally available
467  * via msg.sender and msg.data, they should not be accessed in such a direct
468  * manner, since when dealing with meta-transactions the account sending and
469  * paying for execution may not be the actual sender (as far as an application
470  * is concerned).
471  *
472  * This contract is only required for intermediate, library-like contracts.
473  */
474 abstract contract Context {
475     function _msgSender() internal view virtual returns (address) {
476         return msg.sender;
477     }
478 
479     function _msgData() internal view virtual returns (bytes calldata) {
480         return msg.data;
481     }
482 }
483 
484 // File: @openzeppelin/contracts/access/Ownable.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Contract module which provides a basic access control mechanism, where
494  * there is an account (an owner) that can be granted exclusive access to
495  * specific functions.
496  *
497  * By default, the owner account will be the one that deploys the contract. This
498  * can later be changed with {transferOwnership}.
499  *
500  * This module is used through inheritance. It will make available the modifier
501  * `onlyOwner`, which can be applied to your functions to restrict their use to
502  * the owner.
503  */
504 abstract contract Ownable is Context {
505     address private _owner;
506 
507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
508 
509     /**
510      * @dev Initializes the contract setting the deployer as the initial owner.
511      */
512     constructor() {
513         _transferOwnership(_msgSender());
514     }
515 
516     /**
517      * @dev Returns the address of the current owner.
518      */
519     function owner() public view virtual returns (address) {
520         return _owner;
521     }
522 
523     /**
524      * @dev Throws if called by any account other than the owner.
525      */
526     modifier onlyOwner() {
527         require(owner() == _msgSender(), "Ownable: caller is not the owner");
528         _;
529     }
530 
531     /**
532      * @dev Leaves the contract without owner. It will not be possible to call
533      * `onlyOwner` functions anymore. Can only be called by the current owner.
534      *
535      * NOTE: Renouncing ownership will leave the contract without an owner,
536      * thereby removing any functionality that is only available to the owner.
537      */
538     function renounceOwnership() public virtual onlyOwner {
539         _transferOwnership(address(0));
540     }
541 
542     /**
543      * @dev Transfers ownership of the contract to a new account (`newOwner`).
544      * Can only be called by the current owner.
545      */
546     function transferOwnership(address newOwner) public virtual onlyOwner {
547         require(newOwner != address(0), "Ownable: new owner is the zero address");
548         _transferOwnership(newOwner);
549     }
550 
551     /**
552      * @dev Transfers ownership of the contract to a new account (`newOwner`).
553      * Internal function without access restriction.
554      */
555     function _transferOwnership(address newOwner) internal virtual {
556         address oldOwner = _owner;
557         _owner = newOwner;
558         emit OwnershipTransferred(oldOwner, newOwner);
559     }
560 }
561 
562 // File: @openzeppelin/contracts/utils/Address.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
566 
567 pragma solidity ^0.8.1;
568 
569 /**
570  * @dev Collection of functions related to the address type
571  */
572 library Address {
573     /**
574      * @dev Returns true if `account` is a contract.
575      *
576      * [IMPORTANT]
577      * ====
578      * It is unsafe to assume that an address for which this function returns
579      * false is an externally-owned account (EOA) and not a contract.
580      *
581      * Among others, `isContract` will return false for the following
582      * types of addresses:
583      *
584      *  - an externally-owned account
585      *  - a contract in construction
586      *  - an address where a contract will be created
587      *  - an address where a contract lived, but was destroyed
588      * ====
589      *
590      * [IMPORTANT]
591      * ====
592      * You shouldn't rely on `isContract` to protect against flash loan attacks!
593      *
594      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
595      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
596      * constructor.
597      * ====
598      */
599     function isContract(address account) internal view returns (bool) {
600         // This method relies on extcodesize/address.code.length, which returns 0
601         // for contracts in construction, since the code is only stored at the end
602         // of the constructor execution.
603 
604         return account.code.length > 0;
605     }
606 
607     /**
608      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
609      * `recipient`, forwarding all available gas and reverting on errors.
610      *
611      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
612      * of certain opcodes, possibly making contracts go over the 2300 gas limit
613      * imposed by `transfer`, making them unable to receive funds via
614      * `transfer`. {sendValue} removes this limitation.
615      *
616      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
617      *
618      * IMPORTANT: because control is transferred to `recipient`, care must be
619      * taken to not create reentrancy vulnerabilities. Consider using
620      * {ReentrancyGuard} or the
621      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
622      */
623     function sendValue(address payable recipient, uint256 amount) internal {
624         require(address(this).balance >= amount, "Address: insufficient balance");
625 
626         (bool success, ) = recipient.call{value: amount}("");
627         require(success, "Address: unable to send value, recipient may have reverted");
628     }
629 
630     /**
631      * @dev Performs a Solidity function call using a low level `call`. A
632      * plain `call` is an unsafe replacement for a function call: use this
633      * function instead.
634      *
635      * If `target` reverts with a revert reason, it is bubbled up by this
636      * function (like regular Solidity function calls).
637      *
638      * Returns the raw returned data. To convert to the expected return value,
639      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
640      *
641      * Requirements:
642      *
643      * - `target` must be a contract.
644      * - calling `target` with `data` must not revert.
645      *
646      * _Available since v3.1._
647      */
648     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
649         return functionCall(target, data, "Address: low-level call failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
654      * `errorMessage` as a fallback revert reason when `target` reverts.
655      *
656      * _Available since v3.1._
657      */
658     function functionCall(
659         address target,
660         bytes memory data,
661         string memory errorMessage
662     ) internal returns (bytes memory) {
663         return functionCallWithValue(target, data, 0, errorMessage);
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
668      * but also transferring `value` wei to `target`.
669      *
670      * Requirements:
671      *
672      * - the calling contract must have an ETH balance of at least `value`.
673      * - the called Solidity function must be `payable`.
674      *
675      * _Available since v3.1._
676      */
677     function functionCallWithValue(
678         address target,
679         bytes memory data,
680         uint256 value
681     ) internal returns (bytes memory) {
682         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
687      * with `errorMessage` as a fallback revert reason when `target` reverts.
688      *
689      * _Available since v3.1._
690      */
691     function functionCallWithValue(
692         address target,
693         bytes memory data,
694         uint256 value,
695         string memory errorMessage
696     ) internal returns (bytes memory) {
697         require(address(this).balance >= value, "Address: insufficient balance for call");
698         require(isContract(target), "Address: call to non-contract");
699 
700         (bool success, bytes memory returndata) = target.call{value: value}(data);
701         return verifyCallResult(success, returndata, errorMessage);
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
706      * but performing a static call.
707      *
708      * _Available since v3.3._
709      */
710     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
711         return functionStaticCall(target, data, "Address: low-level static call failed");
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
716      * but performing a static call.
717      *
718      * _Available since v3.3._
719      */
720     function functionStaticCall(
721         address target,
722         bytes memory data,
723         string memory errorMessage
724     ) internal view returns (bytes memory) {
725         require(isContract(target), "Address: static call to non-contract");
726 
727         (bool success, bytes memory returndata) = target.staticcall(data);
728         return verifyCallResult(success, returndata, errorMessage);
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
733      * but performing a delegate call.
734      *
735      * _Available since v3.4._
736      */
737     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
738         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
743      * but performing a delegate call.
744      *
745      * _Available since v3.4._
746      */
747     function functionDelegateCall(
748         address target,
749         bytes memory data,
750         string memory errorMessage
751     ) internal returns (bytes memory) {
752         require(isContract(target), "Address: delegate call to non-contract");
753 
754         (bool success, bytes memory returndata) = target.delegatecall(data);
755         return verifyCallResult(success, returndata, errorMessage);
756     }
757 
758     /**
759      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
760      * revert reason using the provided one.
761      *
762      * _Available since v4.3._
763      */
764     function verifyCallResult(
765         bool success,
766         bytes memory returndata,
767         string memory errorMessage
768     ) internal pure returns (bytes memory) {
769         if (success) {
770             return returndata;
771         } else {
772             // Look for revert reason and bubble it up if present
773             if (returndata.length > 0) {
774                 // The easiest way to bubble the revert reason is using memory via assembly
775 
776                 assembly {
777                     let returndata_size := mload(returndata)
778                     revert(add(32, returndata), returndata_size)
779                 }
780             } else {
781                 revert(errorMessage);
782             }
783         }
784     }
785 }
786 
787 // File: contracts/ScaryMonsters.sol
788 
789 
790 pragma solidity ^0.8.0;
791 
792 
793 
794 
795 
796 
797 
798 
799 
800 
801 interface IERC721A is IERC721, IERC721Metadata {
802     /**
803      * The caller must own the token or be an approved operator.
804      */
805     error ApprovalCallerNotOwnerNorApproved();
806 
807     /**
808      * The token does not exist.
809      */
810     error ApprovalQueryForNonexistentToken();
811 
812     /**
813      * The caller cannot approve to their own address.
814      */
815     error ApproveToCaller();
816 
817     /**
818      * The caller cannot approve to the current owner.
819      */
820     error ApprovalToCurrentOwner();
821 
822     /**
823      * Cannot query the balance for the zero address.
824      */
825     error BalanceQueryForZeroAddress();
826 
827     /**
828      * Cannot mint to the zero address.
829      */
830     error MintToZeroAddress();
831 
832     /**
833      * The quantity of tokens minted must be more than zero.
834      */
835     error MintZeroQuantity();
836 
837     /**
838      * The token does not exist.
839      */
840     error OwnerQueryForNonexistentToken();
841 
842     /**
843      * The caller must own the token or be an approved operator.
844      */
845     error TransferCallerNotOwnerNorApproved();
846 
847     /**
848      * The token must be owned by `from`.
849      */
850     error TransferFromIncorrectOwner();
851 
852     /**
853      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
854      */
855     error TransferToNonERC721ReceiverImplementer();
856 
857     /**
858      * Cannot transfer to the zero address.
859      */
860     error TransferToZeroAddress();
861 
862     /**
863      * The token does not exist.
864      */
865     error URIQueryForNonexistentToken();
866 
867     // Compiler will pack this into a single 256bit word.
868     struct TokenOwnership {
869         // The address of the owner.
870         address addr;
871         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
872         uint64 startTimestamp;
873         // Whether the token has been burned.
874         bool burned;
875     }
876 
877     // Compiler will pack this into a single 256bit word.
878     struct AddressData {
879         // Realistically, 2**64-1 is more than enough.
880         uint64 balance;
881         // Keeps track of mint count with minimal overhead for tokenomics.
882         uint64 numberMinted;
883         // Keeps track of burn count with minimal overhead for tokenomics.
884         uint64 numberBurned;
885         // For miscellaneous variable(s) pertaining to the address
886         // (e.g. number of whitelist mint slots used).
887         // If there are multiple variables, please pack them into a uint64.
888         uint64 aux;
889     }
890 
891     /**
892      * @dev Returns the total amount of tokens stored by the contract.
893      * 
894      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
895      */
896     function totalSupply() external view returns (uint256);
897 }
898 
899 contract ERC721A is Context, ERC165, IERC721A {
900     using Address for address;
901     using Strings for uint256;
902 
903     // The tokenId of the next token to be minted.
904     uint256 internal _currentIndex;
905 
906     // The number of tokens burned.
907     uint256 internal _burnCounter;
908 
909     // Token name
910     string private _name;
911 
912     // Token symbol
913     string private _symbol;
914 
915     // Mapping from token ID to ownership details
916     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
917     mapping(uint256 => TokenOwnership) internal _ownerships;
918 
919     // Mapping owner address to address data
920     mapping(address => AddressData) private _addressData;
921 
922     // Mapping from token ID to approved address
923     mapping(uint256 => address) private _tokenApprovals;
924 
925     // Mapping from owner to operator approvals
926     mapping(address => mapping(address => bool)) private _operatorApprovals;
927 
928     constructor(string memory name_, string memory symbol_) {
929         _name = name_;
930         _symbol = symbol_;
931         _currentIndex = _startTokenId();
932     }
933 
934     /**
935      * To change the starting tokenId, please override this function.
936      */
937     function _startTokenId() internal view virtual returns (uint256) {
938         return 0;
939     }
940 
941     /**
942      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
943      */
944     function totalSupply() public view override returns (uint256) {
945         // Counter underflow is impossible as _burnCounter cannot be incremented
946         // more than _currentIndex - _startTokenId() times
947         unchecked {
948             return _currentIndex - _burnCounter - _startTokenId();
949         }
950     }
951 
952     /**
953      * Returns the total amount of tokens minted in the contract.
954      */
955     function _totalMinted() internal view returns (uint256) {
956         // Counter underflow is impossible as _currentIndex does not decrement,
957         // and it is initialized to _startTokenId()
958         unchecked {
959             return _currentIndex - _startTokenId();
960         }
961     }
962 
963     /**
964      * @dev See {IERC165-supportsInterface}.
965      */
966     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
967         return
968             interfaceId == type(IERC721).interfaceId ||
969             interfaceId == type(IERC721Metadata).interfaceId ||
970             super.supportsInterface(interfaceId);
971     }
972 
973     /**
974      * @dev See {IERC721-balanceOf}.
975      */
976     function balanceOf(address owner) public view override returns (uint256) {
977         if (owner == address(0)) revert BalanceQueryForZeroAddress();
978         return uint256(_addressData[owner].balance);
979     }
980 
981     /**
982      * Returns the number of tokens minted by `owner`.
983      */
984     function _numberMinted(address owner) internal view returns (uint256) {
985         return uint256(_addressData[owner].numberMinted);
986     }
987 
988     /**
989      * Returns the number of tokens burned by or on behalf of `owner`.
990      */
991     function _numberBurned(address owner) internal view returns (uint256) {
992         return uint256(_addressData[owner].numberBurned);
993     }
994 
995     /**
996      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
997      */
998     function _getAux(address owner) internal view returns (uint64) {
999         return _addressData[owner].aux;
1000     }
1001 
1002     /**
1003      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1004      * If there are multiple variables, please pack them into a uint64.
1005      */
1006     function _setAux(address owner, uint64 aux) internal {
1007         _addressData[owner].aux = aux;
1008     }
1009 
1010     /**
1011      * Gas spent here starts off proportional to the maximum mint batch size.
1012      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1013      */
1014     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1015         uint256 curr = tokenId;
1016 
1017         unchecked {
1018             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1019                 TokenOwnership memory ownership = _ownerships[curr];
1020                 if (!ownership.burned) {
1021                     if (ownership.addr != address(0)) {
1022                         return ownership;
1023                     }
1024                     // Invariant:
1025                     // There will always be an ownership that has an address and is not burned
1026                     // before an ownership that does not have an address and is not burned.
1027                     // Hence, curr will not underflow.
1028                     while (true) {
1029                         curr--;
1030                         ownership = _ownerships[curr];
1031                         if (ownership.addr != address(0)) {
1032                             return ownership;
1033                         }
1034                     }
1035                 }
1036             }
1037         }
1038         revert OwnerQueryForNonexistentToken();
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-ownerOf}.
1043      */
1044     function ownerOf(uint256 tokenId) public view override returns (address) {
1045         return _ownershipOf(tokenId).addr;
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Metadata-name}.
1050      */
1051     function name() public view virtual override returns (string memory) {
1052         return _name;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Metadata-symbol}.
1057      */
1058     function symbol() public view virtual override returns (string memory) {
1059         return _symbol;
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Metadata-tokenURI}.
1064      */
1065     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1066         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1067 
1068         string memory baseURI = _baseURI();
1069         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1070     }
1071 
1072     /**
1073      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1074      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1075      * by default, can be overriden in child contracts.
1076      */
1077     function _baseURI() internal view virtual returns (string memory) {
1078         return '';
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-approve}.
1083      */
1084     function approve(address to, uint256 tokenId) public override {
1085         address owner = ERC721A.ownerOf(tokenId);
1086         if (to == owner) revert ApprovalToCurrentOwner();
1087 
1088         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1089             revert ApprovalCallerNotOwnerNorApproved();
1090         }
1091 
1092         _approve(to, tokenId, owner);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-getApproved}.
1097      */
1098     function getApproved(uint256 tokenId) public view override returns (address) {
1099         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1100 
1101         return _tokenApprovals[tokenId];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-setApprovalForAll}.
1106      */
1107     function setApprovalForAll(address operator, bool approved) public virtual override {
1108         if (operator == _msgSender()) revert ApproveToCaller();
1109 
1110         _operatorApprovals[_msgSender()][operator] = approved;
1111         emit ApprovalForAll(_msgSender(), operator, approved);
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-isApprovedForAll}.
1116      */
1117     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1118         return _operatorApprovals[owner][operator];
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-transferFrom}.
1123      */
1124     function transferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) public virtual override {
1129         _transfer(from, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-safeTransferFrom}.
1134      */
1135     function safeTransferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) public virtual override {
1140         safeTransferFrom(from, to, tokenId, '');
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-safeTransferFrom}.
1145      */
1146     function safeTransferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) public virtual override {
1152         _transfer(from, to, tokenId);
1153         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1154             revert TransferToNonERC721ReceiverImplementer();
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns whether `tokenId` exists.
1160      *
1161      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1162      *
1163      * Tokens start existing when they are minted (`_mint`),
1164      */
1165     function _exists(uint256 tokenId) internal view returns (bool) {
1166         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1167     }
1168 
1169     /**
1170      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1171      */
1172     function _safeMint(address to, uint256 quantity) internal {
1173         _safeMint(to, quantity, '');
1174     }
1175 
1176     /**
1177      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1178      *
1179      * Requirements:
1180      *
1181      * - If `to` refers to a smart contract, it must implement
1182      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1183      * - `quantity` must be greater than 0.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _safeMint(
1188         address to,
1189         uint256 quantity,
1190         bytes memory _data
1191     ) internal {
1192         uint256 startTokenId = _currentIndex;
1193         if (to == address(0)) revert MintToZeroAddress();
1194         if (quantity == 0) revert MintZeroQuantity();
1195 
1196         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1197 
1198         // Overflows are incredibly unrealistic.
1199         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1200         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1201         unchecked {
1202             _addressData[to].balance += uint64(quantity);
1203             _addressData[to].numberMinted += uint64(quantity);
1204 
1205             _ownerships[startTokenId].addr = to;
1206             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1207 
1208             uint256 updatedIndex = startTokenId;
1209             uint256 end = updatedIndex + quantity;
1210 
1211             if (to.isContract()) {
1212                 do {
1213                     emit Transfer(address(0), to, updatedIndex);
1214                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1215                         revert TransferToNonERC721ReceiverImplementer();
1216                     }
1217                 } while (updatedIndex < end);
1218                 // Reentrancy protection
1219                 if (_currentIndex != startTokenId) revert();
1220             } else {
1221                 do {
1222                     emit Transfer(address(0), to, updatedIndex++);
1223                 } while (updatedIndex < end);
1224             }
1225             _currentIndex = updatedIndex;
1226         }
1227         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1228     }
1229 
1230     /**
1231      * @dev Mints `quantity` tokens and transfers them to `to`.
1232      *
1233      * Requirements:
1234      *
1235      * - `to` cannot be the zero address.
1236      * - `quantity` must be greater than 0.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _mint(address to, uint256 quantity) internal {
1241         uint256 startTokenId = _currentIndex;
1242         if (to == address(0)) revert MintToZeroAddress();
1243         if (quantity == 0) revert MintZeroQuantity();
1244 
1245         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1246 
1247         // Overflows are incredibly unrealistic.
1248         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1249         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1250         unchecked {
1251             _addressData[to].balance += uint64(quantity);
1252             _addressData[to].numberMinted += uint64(quantity);
1253 
1254             _ownerships[startTokenId].addr = to;
1255             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1256 
1257             uint256 updatedIndex = startTokenId;
1258             uint256 end = updatedIndex + quantity;
1259 
1260             do {
1261                 emit Transfer(address(0), to, updatedIndex++);
1262             } while (updatedIndex < end);
1263 
1264             _currentIndex = updatedIndex;
1265         }
1266         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1267     }
1268 
1269     /**
1270      * @dev Transfers `tokenId` from `from` to `to`.
1271      *
1272      * Requirements:
1273      *
1274      * - `to` cannot be the zero address.
1275      * - `tokenId` token must be owned by `from`.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _transfer(
1280         address from,
1281         address to,
1282         uint256 tokenId
1283     ) private {
1284         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1285 
1286         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1287 
1288         bool isApprovedOrOwner = (_msgSender() == from ||
1289             isApprovedForAll(from, _msgSender()) ||
1290             getApproved(tokenId) == _msgSender());
1291 
1292         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1293         if (to == address(0)) revert TransferToZeroAddress();
1294 
1295         _beforeTokenTransfers(from, to, tokenId, 1);
1296 
1297         // Clear approvals from the previous owner
1298         _approve(address(0), tokenId, from);
1299 
1300         // Underflow of the sender's balance is impossible because we check for
1301         // ownership above and the recipient's balance can't realistically overflow.
1302         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1303         unchecked {
1304             _addressData[from].balance -= 1;
1305             _addressData[to].balance += 1;
1306 
1307             TokenOwnership storage currSlot = _ownerships[tokenId];
1308             currSlot.addr = to;
1309             currSlot.startTimestamp = uint64(block.timestamp);
1310 
1311             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1312             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1313             uint256 nextTokenId = tokenId + 1;
1314             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1315             if (nextSlot.addr == address(0)) {
1316                 // This will suffice for checking _exists(nextTokenId),
1317                 // as a burned slot cannot contain the zero address.
1318                 if (nextTokenId != _currentIndex) {
1319                     nextSlot.addr = from;
1320                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1321                 }
1322             }
1323         }
1324 
1325         emit Transfer(from, to, tokenId);
1326         _afterTokenTransfers(from, to, tokenId, 1);
1327     }
1328 
1329     /**
1330      * @dev Equivalent to `_burn(tokenId, false)`.
1331      */
1332     function _burn(uint256 tokenId) internal virtual {
1333         _burn(tokenId, false);
1334     }
1335 
1336     /**
1337      * @dev Destroys `tokenId`.
1338      * The approval is cleared when the token is burned.
1339      *
1340      * Requirements:
1341      *
1342      * - `tokenId` must exist.
1343      *
1344      * Emits a {Transfer} event.
1345      */
1346     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1347         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1348 
1349         address from = prevOwnership.addr;
1350 
1351         if (approvalCheck) {
1352             bool isApprovedOrOwner = (_msgSender() == from ||
1353                 isApprovedForAll(from, _msgSender()) ||
1354                 getApproved(tokenId) == _msgSender());
1355 
1356             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1357         }
1358 
1359         _beforeTokenTransfers(from, address(0), tokenId, 1);
1360 
1361         // Clear approvals from the previous owner
1362         _approve(address(0), tokenId, from);
1363 
1364         // Underflow of the sender's balance is impossible because we check for
1365         // ownership above and the recipient's balance can't realistically overflow.
1366         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1367         unchecked {
1368             AddressData storage addressData = _addressData[from];
1369             addressData.balance -= 1;
1370             addressData.numberBurned += 1;
1371 
1372             // Keep track of who burned the token, and the timestamp of burning.
1373             TokenOwnership storage currSlot = _ownerships[tokenId];
1374             currSlot.addr = from;
1375             currSlot.startTimestamp = uint64(block.timestamp);
1376             currSlot.burned = true;
1377 
1378             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1379             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1380             uint256 nextTokenId = tokenId + 1;
1381             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1382             if (nextSlot.addr == address(0)) {
1383                 // This will suffice for checking _exists(nextTokenId),
1384                 // as a burned slot cannot contain the zero address.
1385                 if (nextTokenId != _currentIndex) {
1386                     nextSlot.addr = from;
1387                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1388                 }
1389             }
1390         }
1391 
1392         emit Transfer(from, address(0), tokenId);
1393         _afterTokenTransfers(from, address(0), tokenId, 1);
1394 
1395         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1396         unchecked {
1397             _burnCounter++;
1398         }
1399     }
1400 
1401     /**
1402      * @dev Approve `to` to operate on `tokenId`
1403      *
1404      * Emits a {Approval} event.
1405      */
1406     function _approve(
1407         address to,
1408         uint256 tokenId,
1409         address owner
1410     ) private {
1411         _tokenApprovals[tokenId] = to;
1412         emit Approval(owner, to, tokenId);
1413     }
1414 
1415     /**
1416      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1417      *
1418      * @param from address representing the previous owner of the given token ID
1419      * @param to target address that will receive the tokens
1420      * @param tokenId uint256 ID of the token to be transferred
1421      * @param _data bytes optional data to send along with the call
1422      * @return bool whether the call correctly returned the expected magic value
1423      */
1424     function _checkContractOnERC721Received(
1425         address from,
1426         address to,
1427         uint256 tokenId,
1428         bytes memory _data
1429     ) private returns (bool) {
1430         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1431             return retval == IERC721Receiver(to).onERC721Received.selector;
1432         } catch (bytes memory reason) {
1433             if (reason.length == 0) {
1434                 revert TransferToNonERC721ReceiverImplementer();
1435             } else {
1436                 assembly {
1437                     revert(add(32, reason), mload(reason))
1438                 }
1439             }
1440         }
1441     }
1442 
1443     /**
1444      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1445      * And also called before burning one token.
1446      *
1447      * startTokenId - the first token id to be transferred
1448      * quantity - the amount to be transferred
1449      *
1450      * Calling conditions:
1451      *
1452      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1453      * transferred to `to`.
1454      * - When `from` is zero, `tokenId` will be minted for `to`.
1455      * - When `to` is zero, `tokenId` will be burned by `from`.
1456      * - `from` and `to` are never both zero.
1457      */
1458     function _beforeTokenTransfers(
1459         address from,
1460         address to,
1461         uint256 startTokenId,
1462         uint256 quantity
1463     ) internal virtual {}
1464 
1465     /**
1466      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1467      * minting.
1468      * And also called after one token has been burned.
1469      *
1470      * startTokenId - the first token id to be transferred
1471      * quantity - the amount to be transferred
1472      *
1473      * Calling conditions:
1474      *
1475      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1476      * transferred to `to`.
1477      * - When `from` is zero, `tokenId` has been minted for `to`.
1478      * - When `to` is zero, `tokenId` has been burned by `from`.
1479      * - `from` and `to` are never both zero.
1480      */
1481     function _afterTokenTransfers(
1482         address from,
1483         address to,
1484         uint256 startTokenId,
1485         uint256 quantity
1486     ) internal virtual {}
1487 }
1488 
1489 error InvalidQueryRange();
1490 
1491 /**
1492  * @title ERC721A Queryable
1493  * @dev ERC721A subclass with convenience query functions.
1494  */
1495 abstract contract ERC721AQueryable is ERC721A {
1496     /**
1497      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1498      *
1499      * If the `tokenId` is out of bounds:
1500      *   - `addr` = `address(0)`
1501      *   - `startTimestamp` = `0`
1502      *   - `burned` = `false`
1503      *
1504      * If the `tokenId` is burned:
1505      *   - `addr` = `<Address of owner before token was burned>`
1506      *   - `startTimestamp` = `<Timestamp when token was burned>`
1507      *   - `burned = `true`
1508      *
1509      * Otherwise:
1510      *   - `addr` = `<Address of owner>`
1511      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1512      *   - `burned = `false`
1513      */
1514     function explicitOwnershipOf(uint256 tokenId)
1515         public
1516         view
1517         returns (TokenOwnership memory)
1518     {
1519         TokenOwnership memory ownership;
1520         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1521             return ownership;
1522         }
1523         ownership = _ownerships[tokenId];
1524         if (ownership.burned) {
1525             return ownership;
1526         }
1527         return _ownershipOf(tokenId);
1528     }
1529 
1530     /**
1531      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1532      * See {ERC721AQueryable-explicitOwnershipOf}
1533      */
1534     function explicitOwnershipsOf(uint256[] memory tokenIds)
1535         external
1536         view
1537         returns (TokenOwnership[] memory)
1538     {
1539         unchecked {
1540             uint256 tokenIdsLength = tokenIds.length;
1541             TokenOwnership[] memory ownerships = new TokenOwnership[](
1542                 tokenIdsLength
1543             );
1544             for (uint256 i; i != tokenIdsLength; ++i) {
1545                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1546             }
1547             return ownerships;
1548         }
1549     }
1550 
1551     /**
1552      * @dev Returns an array of token IDs owned by `owner`,
1553      * in the range [`start`, `stop`)
1554      * (i.e. `start <= tokenId < stop`).
1555      *
1556      * This function allows for tokens to be queried if the collection
1557      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1558      *
1559      * Requirements:
1560      *
1561      * - `start` < `stop`
1562      */
1563     function tokensOfOwnerIn(
1564         address owner,
1565         uint256 start,
1566         uint256 stop
1567     ) external view returns (uint256[] memory) {
1568         unchecked {
1569             if (start >= stop) revert InvalidQueryRange();
1570             uint256 tokenIdsIdx;
1571             uint256 stopLimit = _currentIndex;
1572             // Set `start = max(start, _startTokenId())`.
1573             if (start < _startTokenId()) {
1574                 start = _startTokenId();
1575             }
1576             // Set `stop = min(stop, _currentIndex)`.
1577             if (stop > stopLimit) {
1578                 stop = stopLimit;
1579             }
1580             uint256 tokenIdsMaxLength = balanceOf(owner);
1581             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1582             // to cater for cases where `balanceOf(owner)` is too big.
1583             if (start < stop) {
1584                 uint256 rangeLength = stop - start;
1585                 if (rangeLength < tokenIdsMaxLength) {
1586                     tokenIdsMaxLength = rangeLength;
1587                 }
1588             } else {
1589                 tokenIdsMaxLength = 0;
1590             }
1591             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1592             if (tokenIdsMaxLength == 0) {
1593                 return tokenIds;
1594             }
1595             // We need to call `explicitOwnershipOf(start)`,
1596             // because the slot at `start` may not be initialized.
1597             TokenOwnership memory ownership = explicitOwnershipOf(start);
1598             address currOwnershipAddr;
1599             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1600             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1601             if (!ownership.burned) {
1602                 currOwnershipAddr = ownership.addr;
1603             }
1604             for (
1605                 uint256 i = start;
1606                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1607                 ++i
1608             ) {
1609                 ownership = _ownerships[i];
1610                 if (ownership.burned) {
1611                     continue;
1612                 }
1613                 if (ownership.addr != address(0)) {
1614                     currOwnershipAddr = ownership.addr;
1615                 }
1616                 if (currOwnershipAddr == owner) {
1617                     tokenIds[tokenIdsIdx++] = i;
1618                 }
1619             }
1620             // Downsize the array to fit.
1621             assembly {
1622                 mstore(tokenIds, tokenIdsIdx)
1623             }
1624             return tokenIds;
1625         }
1626     }
1627 
1628     /**
1629      * @dev Returns an array of token IDs owned by `owner`.
1630      *
1631      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1632      * It is meant to be called off-chain.
1633      *
1634      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1635      * multiple smaller scans if the collection is large enough to cause
1636      * an out-of-gas error (10K pfp collections should be fine).
1637      */
1638     function tokensOfOwner(address owner)
1639         external
1640         view
1641         returns (uint256[] memory)
1642     {
1643         unchecked {
1644             uint256 tokenIdsIdx;
1645             address currOwnershipAddr;
1646             uint256 tokenIdsLength = balanceOf(owner);
1647             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1648             TokenOwnership memory ownership;
1649             for (
1650                 uint256 i = _startTokenId();
1651                 tokenIdsIdx != tokenIdsLength;
1652                 ++i
1653             ) {
1654                 ownership = _ownerships[i];
1655                 if (ownership.burned) {
1656                     continue;
1657                 }
1658                 if (ownership.addr != address(0)) {
1659                     currOwnershipAddr = ownership.addr;
1660                 }
1661                 if (currOwnershipAddr == owner) {
1662                     tokenIds[tokenIdsIdx++] = i;
1663                 }
1664             }
1665             return tokenIds;
1666         }
1667     }
1668 }
1669 
1670 contract ScaryMonsters is  Ownable, ERC721AQueryable {
1671     using Strings for uint256;
1672 
1673     IERC1155 private Jerky;
1674     uint256 public JerkyId = 1;
1675     address private Jerkyaddress =  0xa755c08a422434C480076c80692d9aEe67bCea2B;
1676 
1677     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
1678 
1679     bool public isActive = true; 
1680     bool public revealed = false;
1681 
1682     string baseURI; 
1683     string public notRevealedUri = "https://cdn.monstercave.wtf/ipfs/blindbox/monster.json";
1684     string public baseExtension = ".json"; 
1685 
1686     mapping(uint256 => string) private _tokenURIs;
1687 
1688     constructor() 
1689         ERC721A("Scary monsters", "")
1690     {
1691         Jerky = IERC1155(Jerkyaddress);
1692         setNotRevealedURI(notRevealedUri);
1693     } 
1694 
1695     function mintMonster(uint256 tokenQuantity) public payable{
1696         require(
1697             isActive,
1698             "Mint must be active"
1699         );
1700 
1701         require(
1702             tokenQuantity > 0,
1703             "Exchanged monster must be greater than 0"
1704         );
1705 
1706         require(
1707             tokenQuantity <= Jerky.balanceOf(msg.sender, JerkyId),
1708             "Not enough Jerky sent"
1709         );
1710 
1711         require(
1712             Jerky.isApprovedForAll(msg.sender, address(this)), 
1713             "Approved required"
1714         );
1715 
1716         Jerky.safeTransferFrom(msg.sender, DEAD, JerkyId, tokenQuantity, "0x00");
1717 
1718         _safeMint(msg.sender, tokenQuantity);
1719     }
1720 
1721     function mintByOwner(address to, uint256 tokenQuantity) public payable onlyOwner{
1722         require(
1723             tokenQuantity > 0,
1724             "Exchanged monster must be greater than 0"
1725         );
1726 
1727         _safeMint(to, tokenQuantity);
1728     }
1729 
1730 
1731     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1732     {
1733         require(
1734             _exists(tokenId),
1735             "ERC721Metadata: URI query for nonexistent token"
1736         );
1737        
1738         if (revealed == false) {
1739             return notRevealedUri;
1740         }
1741 
1742         string memory _tokenURI = _tokenURIs[tokenId];
1743         string memory base = _baseURI();
1744 
1745         // If there is no base URI, return the token URI.
1746         if (bytes(base).length == 0) {
1747             return _tokenURI;
1748         }
1749         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1750         if (bytes(_tokenURI).length > 0) {
1751             return string(abi.encodePacked(base, _tokenURI));
1752         }
1753         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1754         return
1755             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
1756     }
1757 
1758    
1759     function _baseURI() internal view virtual override returns (string memory) {
1760         return baseURI;
1761     }
1762 
1763     function flipActive() public onlyOwner {
1764         isActive = !isActive;
1765     }
1766     
1767     function flipReveal() public onlyOwner {
1768         revealed = !revealed;
1769     }
1770 
1771     
1772     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1773         notRevealedUri = _notRevealedURI;
1774     }
1775 
1776     
1777     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1778         baseURI = _newBaseURI;
1779     }
1780    
1781     function setBaseExtension(string memory _newBaseExtension) public onlyOwner
1782     {
1783         baseExtension = _newBaseExtension;
1784     }
1785 
1786     function setJerkyContract(address _address) public onlyOwner {
1787         Jerky = IERC1155(_address);
1788     }
1789    
1790 
1791     function setJerkyId(uint256 _id) public onlyOwner {
1792         JerkyId = _id;
1793     }
1794 
1795     
1796 
1797 }