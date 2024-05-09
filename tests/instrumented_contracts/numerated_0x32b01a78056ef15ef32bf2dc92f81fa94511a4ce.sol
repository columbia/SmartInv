1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.9.3 https://hardhat.org
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
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
33 
34 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
177 
178 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 
204 // File erc721a/contracts/IERC721A.sol@v3.3.0
205 
206 // ERC721A Contracts v3.3.0
207 // Creator: Chiru Labs
208 
209 pragma solidity ^0.8.4;
210 
211 
212 /**
213  * @dev Interface of an ERC721A compliant contract.
214  */
215 interface IERC721A is IERC721, IERC721Metadata {
216     /**
217      * The caller must own the token or be an approved operator.
218      */
219     error ApprovalCallerNotOwnerNorApproved();
220 
221     /**
222      * The token does not exist.
223      */
224     error ApprovalQueryForNonexistentToken();
225 
226     /**
227      * The caller cannot approve to their own address.
228      */
229     error ApproveToCaller();
230 
231     /**
232      * The caller cannot approve to the current owner.
233      */
234     error ApprovalToCurrentOwner();
235 
236     /**
237      * Cannot query the balance for the zero address.
238      */
239     error BalanceQueryForZeroAddress();
240 
241     /**
242      * Cannot mint to the zero address.
243      */
244     error MintToZeroAddress();
245 
246     /**
247      * The quantity of tokens minted must be more than zero.
248      */
249     error MintZeroQuantity();
250 
251     /**
252      * The token does not exist.
253      */
254     error OwnerQueryForNonexistentToken();
255 
256     /**
257      * The caller must own the token or be an approved operator.
258      */
259     error TransferCallerNotOwnerNorApproved();
260 
261     /**
262      * The token must be owned by `from`.
263      */
264     error TransferFromIncorrectOwner();
265 
266     /**
267      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
268      */
269     error TransferToNonERC721ReceiverImplementer();
270 
271     /**
272      * Cannot transfer to the zero address.
273      */
274     error TransferToZeroAddress();
275 
276     /**
277      * The token does not exist.
278      */
279     error URIQueryForNonexistentToken();
280 
281     // Compiler will pack this into a single 256bit word.
282     struct TokenOwnership {
283         // The address of the owner.
284         address addr;
285         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
286         uint64 startTimestamp;
287         // Whether the token has been burned.
288         bool burned;
289     }
290 
291     // Compiler will pack this into a single 256bit word.
292     struct AddressData {
293         // Realistically, 2**64-1 is more than enough.
294         uint64 balance;
295         // Keeps track of mint count with minimal overhead for tokenomics.
296         uint64 numberMinted;
297         // Keeps track of burn count with minimal overhead for tokenomics.
298         uint64 numberBurned;
299         // For miscellaneous variable(s) pertaining to the address
300         // (e.g. number of whitelist mint slots used).
301         // If there are multiple variables, please pack them into a uint64.
302         uint64 aux;
303     }
304 
305     /**
306      * @dev Returns the total amount of tokens stored by the contract.
307      * 
308      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
309      */
310     function totalSupply() external view returns (uint256);
311 }
312 
313 
314 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v3.3.0
315 
316 // ERC721A Contracts v3.3.0
317 // Creator: Chiru Labs
318 
319 pragma solidity ^0.8.4;
320 
321 /**
322  * @dev Interface of an ERC721AQueryable compliant contract.
323  */
324 interface IERC721AQueryable is IERC721A {
325     /**
326      * Invalid query range (`start` >= `stop`).
327      */
328     error InvalidQueryRange();
329 
330     /**
331      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
332      *
333      * If the `tokenId` is out of bounds:
334      *   - `addr` = `address(0)`
335      *   - `startTimestamp` = `0`
336      *   - `burned` = `false`
337      *
338      * If the `tokenId` is burned:
339      *   - `addr` = `<Address of owner before token was burned>`
340      *   - `startTimestamp` = `<Timestamp when token was burned>`
341      *   - `burned = `true`
342      *
343      * Otherwise:
344      *   - `addr` = `<Address of owner>`
345      *   - `startTimestamp` = `<Timestamp of start of ownership>`
346      *   - `burned = `false`
347      */
348     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
349 
350     /**
351      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
352      * See {ERC721AQueryable-explicitOwnershipOf}
353      */
354     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
355 
356     /**
357      * @dev Returns an array of token IDs owned by `owner`,
358      * in the range [`start`, `stop`)
359      * (i.e. `start <= tokenId < stop`).
360      *
361      * This function allows for tokens to be queried if the collection
362      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
363      *
364      * Requirements:
365      *
366      * - `start` < `stop`
367      */
368     function tokensOfOwnerIn(
369         address owner,
370         uint256 start,
371         uint256 stop
372     ) external view returns (uint256[] memory);
373 
374     /**
375      * @dev Returns an array of token IDs owned by `owner`.
376      *
377      * This function scans the ownership mapping and is O(totalSupply) in complexity.
378      * It is meant to be called off-chain.
379      *
380      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
381      * multiple smaller scans if the collection is large enough to cause
382      * an out-of-gas error (10K pfp collections should be fine).
383      */
384     function tokensOfOwner(address owner) external view returns (uint256[] memory);
385 }
386 
387 
388 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
389 
390 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @title ERC721 token receiver interface
396  * @dev Interface for any contract that wants to support safeTransfers
397  * from ERC721 asset contracts.
398  */
399 interface IERC721Receiver {
400     /**
401      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
402      * by `operator` from `from`, this function is called.
403      *
404      * It must return its Solidity selector to confirm the token transfer.
405      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
406      *
407      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
408      */
409     function onERC721Received(
410         address operator,
411         address from,
412         uint256 tokenId,
413         bytes calldata data
414     ) external returns (bytes4);
415 }
416 
417 
418 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
419 
420 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
421 
422 pragma solidity ^0.8.1;
423 
424 /**
425  * @dev Collection of functions related to the address type
426  */
427 library Address {
428     /**
429      * @dev Returns true if `account` is a contract.
430      *
431      * [IMPORTANT]
432      * ====
433      * It is unsafe to assume that an address for which this function returns
434      * false is an externally-owned account (EOA) and not a contract.
435      *
436      * Among others, `isContract` will return false for the following
437      * types of addresses:
438      *
439      *  - an externally-owned account
440      *  - a contract in construction
441      *  - an address where a contract will be created
442      *  - an address where a contract lived, but was destroyed
443      * ====
444      *
445      * [IMPORTANT]
446      * ====
447      * You shouldn't rely on `isContract` to protect against flash loan attacks!
448      *
449      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
450      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
451      * constructor.
452      * ====
453      */
454     function isContract(address account) internal view returns (bool) {
455         // This method relies on extcodesize/address.code.length, which returns 0
456         // for contracts in construction, since the code is only stored at the end
457         // of the constructor execution.
458 
459         return account.code.length > 0;
460     }
461 
462     /**
463      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
464      * `recipient`, forwarding all available gas and reverting on errors.
465      *
466      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
467      * of certain opcodes, possibly making contracts go over the 2300 gas limit
468      * imposed by `transfer`, making them unable to receive funds via
469      * `transfer`. {sendValue} removes this limitation.
470      *
471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
472      *
473      * IMPORTANT: because control is transferred to `recipient`, care must be
474      * taken to not create reentrancy vulnerabilities. Consider using
475      * {ReentrancyGuard} or the
476      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
477      */
478     function sendValue(address payable recipient, uint256 amount) internal {
479         require(address(this).balance >= amount, "Address: insufficient balance");
480 
481         (bool success, ) = recipient.call{value: amount}("");
482         require(success, "Address: unable to send value, recipient may have reverted");
483     }
484 
485     /**
486      * @dev Performs a Solidity function call using a low level `call`. A
487      * plain `call` is an unsafe replacement for a function call: use this
488      * function instead.
489      *
490      * If `target` reverts with a revert reason, it is bubbled up by this
491      * function (like regular Solidity function calls).
492      *
493      * Returns the raw returned data. To convert to the expected return value,
494      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
495      *
496      * Requirements:
497      *
498      * - `target` must be a contract.
499      * - calling `target` with `data` must not revert.
500      *
501      * _Available since v3.1._
502      */
503     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
504         return functionCall(target, data, "Address: low-level call failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
509      * `errorMessage` as a fallback revert reason when `target` reverts.
510      *
511      * _Available since v3.1._
512      */
513     function functionCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         return functionCallWithValue(target, data, 0, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but also transferring `value` wei to `target`.
524      *
525      * Requirements:
526      *
527      * - the calling contract must have an ETH balance of at least `value`.
528      * - the called Solidity function must be `payable`.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value
536     ) internal returns (bytes memory) {
537         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
542      * with `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCallWithValue(
547         address target,
548         bytes memory data,
549         uint256 value,
550         string memory errorMessage
551     ) internal returns (bytes memory) {
552         require(address(this).balance >= value, "Address: insufficient balance for call");
553         require(isContract(target), "Address: call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.call{value: value}(data);
556         return verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
566         return functionStaticCall(target, data, "Address: low-level static call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
571      * but performing a static call.
572      *
573      * _Available since v3.3._
574      */
575     function functionStaticCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal view returns (bytes memory) {
580         require(isContract(target), "Address: static call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.staticcall(data);
583         return verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
593         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a delegate call.
599      *
600      * _Available since v3.4._
601      */
602     function functionDelegateCall(
603         address target,
604         bytes memory data,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(isContract(target), "Address: delegate call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.delegatecall(data);
610         return verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
615      * revert reason using the provided one.
616      *
617      * _Available since v4.3._
618      */
619     function verifyCallResult(
620         bool success,
621         bytes memory returndata,
622         string memory errorMessage
623     ) internal pure returns (bytes memory) {
624         if (success) {
625             return returndata;
626         } else {
627             // Look for revert reason and bubble it up if present
628             if (returndata.length > 0) {
629                 // The easiest way to bubble the revert reason is using memory via assembly
630 
631                 assembly {
632                     let returndata_size := mload(returndata)
633                     revert(add(32, returndata), returndata_size)
634                 }
635             } else {
636                 revert(errorMessage);
637             }
638         }
639     }
640 }
641 
642 
643 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
644 
645 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 /**
650  * @dev Provides information about the current execution context, including the
651  * sender of the transaction and its data. While these are generally available
652  * via msg.sender and msg.data, they should not be accessed in such a direct
653  * manner, since when dealing with meta-transactions the account sending and
654  * paying for execution may not be the actual sender (as far as an application
655  * is concerned).
656  *
657  * This contract is only required for intermediate, library-like contracts.
658  */
659 abstract contract Context {
660     function _msgSender() internal view virtual returns (address) {
661         return msg.sender;
662     }
663 
664     function _msgData() internal view virtual returns (bytes calldata) {
665         return msg.data;
666     }
667 }
668 
669 
670 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
671 
672 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev String operations.
678  */
679 library Strings {
680     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
681 
682     /**
683      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
684      */
685     function toString(uint256 value) internal pure returns (string memory) {
686         // Inspired by OraclizeAPI's implementation - MIT licence
687         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
688 
689         if (value == 0) {
690             return "0";
691         }
692         uint256 temp = value;
693         uint256 digits;
694         while (temp != 0) {
695             digits++;
696             temp /= 10;
697         }
698         bytes memory buffer = new bytes(digits);
699         while (value != 0) {
700             digits -= 1;
701             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
702             value /= 10;
703         }
704         return string(buffer);
705     }
706 
707     /**
708      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
709      */
710     function toHexString(uint256 value) internal pure returns (string memory) {
711         if (value == 0) {
712             return "0x00";
713         }
714         uint256 temp = value;
715         uint256 length = 0;
716         while (temp != 0) {
717             length++;
718             temp >>= 8;
719         }
720         return toHexString(value, length);
721     }
722 
723     /**
724      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
725      */
726     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
727         bytes memory buffer = new bytes(2 * length + 2);
728         buffer[0] = "0";
729         buffer[1] = "x";
730         for (uint256 i = 2 * length + 1; i > 1; --i) {
731             buffer[i] = _HEX_SYMBOLS[value & 0xf];
732             value >>= 4;
733         }
734         require(value == 0, "Strings: hex length insufficient");
735         return string(buffer);
736     }
737 }
738 
739 
740 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
741 
742 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
743 
744 pragma solidity ^0.8.0;
745 
746 /**
747  * @dev Implementation of the {IERC165} interface.
748  *
749  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
750  * for the additional interface id that will be supported. For example:
751  *
752  * ```solidity
753  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
754  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
755  * }
756  * ```
757  *
758  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
759  */
760 abstract contract ERC165 is IERC165 {
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
765         return interfaceId == type(IERC165).interfaceId;
766     }
767 }
768 
769 
770 // File erc721a/contracts/ERC721A.sol@v3.3.0
771 
772 // ERC721A Contracts v3.3.0
773 // Creator: Chiru Labs
774 
775 pragma solidity ^0.8.4;
776 
777 
778 
779 
780 
781 
782 /**
783  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
784  * the Metadata extension. Built to optimize for lower gas during batch mints.
785  *
786  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
787  *
788  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
789  *
790  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
791  */
792 contract ERC721A is Context, ERC165, IERC721A {
793     using Address for address;
794     using Strings for uint256;
795 
796     // The tokenId of the next token to be minted.
797     uint256 internal _currentIndex;
798 
799     // The number of tokens burned.
800     uint256 internal _burnCounter;
801 
802     // Token name
803     string private _name;
804 
805     // Token symbol
806     string private _symbol;
807 
808     // Mapping from token ID to ownership details
809     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
810     mapping(uint256 => TokenOwnership) internal _ownerships;
811 
812     // Mapping owner address to address data
813     mapping(address => AddressData) private _addressData;
814 
815     // Mapping from token ID to approved address
816     mapping(uint256 => address) private _tokenApprovals;
817 
818     // Mapping from owner to operator approvals
819     mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821     constructor(string memory name_, string memory symbol_) {
822         _name = name_;
823         _symbol = symbol_;
824         _currentIndex = _startTokenId();
825     }
826 
827     /**
828      * To change the starting tokenId, please override this function.
829      */
830     function _startTokenId() internal view virtual returns (uint256) {
831         return 0;
832     }
833 
834     /**
835      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
836      */
837     function totalSupply() public view override returns (uint256) {
838         // Counter underflow is impossible as _burnCounter cannot be incremented
839         // more than _currentIndex - _startTokenId() times
840         unchecked {
841             return _currentIndex - _burnCounter - _startTokenId();
842         }
843     }
844 
845     /**
846      * Returns the total amount of tokens minted in the contract.
847      */
848     function _totalMinted() internal view returns (uint256) {
849         // Counter underflow is impossible as _currentIndex does not decrement,
850         // and it is initialized to _startTokenId()
851         unchecked {
852             return _currentIndex - _startTokenId();
853         }
854     }
855 
856     /**
857      * @dev See {IERC165-supportsInterface}.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
860         return
861             interfaceId == type(IERC721).interfaceId ||
862             interfaceId == type(IERC721Metadata).interfaceId ||
863             super.supportsInterface(interfaceId);
864     }
865 
866     /**
867      * @dev See {IERC721-balanceOf}.
868      */
869     function balanceOf(address owner) public view override returns (uint256) {
870         if (owner == address(0)) revert BalanceQueryForZeroAddress();
871         return uint256(_addressData[owner].balance);
872     }
873 
874     /**
875      * Returns the number of tokens minted by `owner`.
876      */
877     function _numberMinted(address owner) internal view returns (uint256) {
878         return uint256(_addressData[owner].numberMinted);
879     }
880 
881     /**
882      * Returns the number of tokens burned by or on behalf of `owner`.
883      */
884     function _numberBurned(address owner) internal view returns (uint256) {
885         return uint256(_addressData[owner].numberBurned);
886     }
887 
888     /**
889      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
890      */
891     function _getAux(address owner) internal view returns (uint64) {
892         return _addressData[owner].aux;
893     }
894 
895     /**
896      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
897      * If there are multiple variables, please pack them into a uint64.
898      */
899     function _setAux(address owner, uint64 aux) internal {
900         _addressData[owner].aux = aux;
901     }
902 
903     /**
904      * Gas spent here starts off proportional to the maximum mint batch size.
905      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
906      */
907     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
908         uint256 curr = tokenId;
909 
910         unchecked {
911             if (_startTokenId() <= curr) if (curr < _currentIndex) {
912                 TokenOwnership memory ownership = _ownerships[curr];
913                 if (!ownership.burned) {
914                     if (ownership.addr != address(0)) {
915                         return ownership;
916                     }
917                     // Invariant:
918                     // There will always be an ownership that has an address and is not burned
919                     // before an ownership that does not have an address and is not burned.
920                     // Hence, curr will not underflow.
921                     while (true) {
922                         curr--;
923                         ownership = _ownerships[curr];
924                         if (ownership.addr != address(0)) {
925                             return ownership;
926                         }
927                     }
928                 }
929             }
930         }
931         revert OwnerQueryForNonexistentToken();
932     }
933 
934     /**
935      * @dev See {IERC721-ownerOf}.
936      */
937     function ownerOf(uint256 tokenId) public view override returns (address) {
938         return _ownershipOf(tokenId).addr;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-name}.
943      */
944     function name() public view virtual override returns (string memory) {
945         return _name;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-symbol}.
950      */
951     function symbol() public view virtual override returns (string memory) {
952         return _symbol;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-tokenURI}.
957      */
958     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
959         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
960 
961         string memory baseURI = _baseURI();
962         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
963     }
964 
965     /**
966      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
967      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
968      * by default, can be overriden in child contracts.
969      */
970     function _baseURI() internal view virtual returns (string memory) {
971         return '';
972     }
973 
974     /**
975      * @dev See {IERC721-approve}.
976      */
977     function approve(address to, uint256 tokenId) public override {
978         address owner = ERC721A.ownerOf(tokenId);
979         if (to == owner) revert ApprovalToCurrentOwner();
980 
981         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
982             revert ApprovalCallerNotOwnerNorApproved();
983         }
984 
985         _approve(to, tokenId, owner);
986     }
987 
988     /**
989      * @dev See {IERC721-getApproved}.
990      */
991     function getApproved(uint256 tokenId) public view override returns (address) {
992         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
993 
994         return _tokenApprovals[tokenId];
995     }
996 
997     /**
998      * @dev See {IERC721-setApprovalForAll}.
999      */
1000     function setApprovalForAll(address operator, bool approved) public virtual override {
1001         if (operator == _msgSender()) revert ApproveToCaller();
1002 
1003         _operatorApprovals[_msgSender()][operator] = approved;
1004         emit ApprovalForAll(_msgSender(), operator, approved);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-isApprovedForAll}.
1009      */
1010     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1011         return _operatorApprovals[owner][operator];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-transferFrom}.
1016      */
1017     function transferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         _transfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-safeTransferFrom}.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         safeTransferFrom(from, to, tokenId, '');
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) public virtual override {
1045         _transfer(from, to, tokenId);
1046         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1047             revert TransferToNonERC721ReceiverImplementer();
1048         }
1049     }
1050 
1051     /**
1052      * @dev Returns whether `tokenId` exists.
1053      *
1054      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1055      *
1056      * Tokens start existing when they are minted (`_mint`),
1057      */
1058     function _exists(uint256 tokenId) internal view returns (bool) {
1059         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1060     }
1061 
1062     /**
1063      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1064      */
1065     function _safeMint(address to, uint256 quantity) internal {
1066         _safeMint(to, quantity, '');
1067     }
1068 
1069     /**
1070      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - If `to` refers to a smart contract, it must implement
1075      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeMint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data
1084     ) internal {
1085         uint256 startTokenId = _currentIndex;
1086         if (to == address(0)) revert MintToZeroAddress();
1087         if (quantity == 0) revert MintZeroQuantity();
1088 
1089         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1090 
1091         // Overflows are incredibly unrealistic.
1092         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1093         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1094         unchecked {
1095             _addressData[to].balance += uint64(quantity);
1096             _addressData[to].numberMinted += uint64(quantity);
1097 
1098             _ownerships[startTokenId].addr = to;
1099             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1100 
1101             uint256 updatedIndex = startTokenId;
1102             uint256 end = updatedIndex + quantity;
1103 
1104             if (to.isContract()) {
1105                 do {
1106                     emit Transfer(address(0), to, updatedIndex);
1107                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1108                         revert TransferToNonERC721ReceiverImplementer();
1109                     }
1110                 } while (updatedIndex < end);
1111                 // Reentrancy protection
1112                 if (_currentIndex != startTokenId) revert();
1113             } else {
1114                 do {
1115                     emit Transfer(address(0), to, updatedIndex++);
1116                 } while (updatedIndex < end);
1117             }
1118             _currentIndex = updatedIndex;
1119         }
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Mints `quantity` tokens and transfers them to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `quantity` must be greater than 0.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _mint(address to, uint256 quantity) internal {
1134         uint256 startTokenId = _currentIndex;
1135         if (to == address(0)) revert MintToZeroAddress();
1136         if (quantity == 0) revert MintZeroQuantity();
1137 
1138         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1139 
1140         // Overflows are incredibly unrealistic.
1141         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1142         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1143         unchecked {
1144             _addressData[to].balance += uint64(quantity);
1145             _addressData[to].numberMinted += uint64(quantity);
1146 
1147             _ownerships[startTokenId].addr = to;
1148             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1149 
1150             uint256 updatedIndex = startTokenId;
1151             uint256 end = updatedIndex + quantity;
1152 
1153             do {
1154                 emit Transfer(address(0), to, updatedIndex++);
1155             } while (updatedIndex < end);
1156 
1157             _currentIndex = updatedIndex;
1158         }
1159         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1160     }
1161 
1162     /**
1163      * @dev Transfers `tokenId` from `from` to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `to` cannot be the zero address.
1168      * - `tokenId` token must be owned by `from`.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _transfer(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) private {
1177         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1178 
1179         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1180 
1181         bool isApprovedOrOwner = (_msgSender() == from ||
1182             isApprovedForAll(from, _msgSender()) ||
1183             getApproved(tokenId) == _msgSender());
1184 
1185         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1186         if (to == address(0)) revert TransferToZeroAddress();
1187 
1188         _beforeTokenTransfers(from, to, tokenId, 1);
1189 
1190         // Clear approvals from the previous owner
1191         _approve(address(0), tokenId, from);
1192 
1193         // Underflow of the sender's balance is impossible because we check for
1194         // ownership above and the recipient's balance can't realistically overflow.
1195         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1196         unchecked {
1197             _addressData[from].balance -= 1;
1198             _addressData[to].balance += 1;
1199 
1200             TokenOwnership storage currSlot = _ownerships[tokenId];
1201             currSlot.addr = to;
1202             currSlot.startTimestamp = uint64(block.timestamp);
1203 
1204             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1205             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1206             uint256 nextTokenId = tokenId + 1;
1207             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1208             if (nextSlot.addr == address(0)) {
1209                 // This will suffice for checking _exists(nextTokenId),
1210                 // as a burned slot cannot contain the zero address.
1211                 if (nextTokenId != _currentIndex) {
1212                     nextSlot.addr = from;
1213                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1214                 }
1215             }
1216         }
1217 
1218         emit Transfer(from, to, tokenId);
1219         _afterTokenTransfers(from, to, tokenId, 1);
1220     }
1221 
1222     /**
1223      * @dev Equivalent to `_burn(tokenId, false)`.
1224      */
1225     function _burn(uint256 tokenId) internal virtual {
1226         _burn(tokenId, false);
1227     }
1228 
1229     /**
1230      * @dev Destroys `tokenId`.
1231      * The approval is cleared when the token is burned.
1232      *
1233      * Requirements:
1234      *
1235      * - `tokenId` must exist.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1240         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1241 
1242         address from = prevOwnership.addr;
1243 
1244         if (approvalCheck) {
1245             bool isApprovedOrOwner = (_msgSender() == from ||
1246                 isApprovedForAll(from, _msgSender()) ||
1247                 getApproved(tokenId) == _msgSender());
1248 
1249             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1250         }
1251 
1252         _beforeTokenTransfers(from, address(0), tokenId, 1);
1253 
1254         // Clear approvals from the previous owner
1255         _approve(address(0), tokenId, from);
1256 
1257         // Underflow of the sender's balance is impossible because we check for
1258         // ownership above and the recipient's balance can't realistically overflow.
1259         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1260         unchecked {
1261             AddressData storage addressData = _addressData[from];
1262             addressData.balance -= 1;
1263             addressData.numberBurned += 1;
1264 
1265             // Keep track of who burned the token, and the timestamp of burning.
1266             TokenOwnership storage currSlot = _ownerships[tokenId];
1267             currSlot.addr = from;
1268             currSlot.startTimestamp = uint64(block.timestamp);
1269             currSlot.burned = true;
1270 
1271             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1272             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1273             uint256 nextTokenId = tokenId + 1;
1274             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1275             if (nextSlot.addr == address(0)) {
1276                 // This will suffice for checking _exists(nextTokenId),
1277                 // as a burned slot cannot contain the zero address.
1278                 if (nextTokenId != _currentIndex) {
1279                     nextSlot.addr = from;
1280                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1281                 }
1282             }
1283         }
1284 
1285         emit Transfer(from, address(0), tokenId);
1286         _afterTokenTransfers(from, address(0), tokenId, 1);
1287 
1288         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1289         unchecked {
1290             _burnCounter++;
1291         }
1292     }
1293 
1294     /**
1295      * @dev Approve `to` to operate on `tokenId`
1296      *
1297      * Emits a {Approval} event.
1298      */
1299     function _approve(
1300         address to,
1301         uint256 tokenId,
1302         address owner
1303     ) private {
1304         _tokenApprovals[tokenId] = to;
1305         emit Approval(owner, to, tokenId);
1306     }
1307 
1308     /**
1309      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1310      *
1311      * @param from address representing the previous owner of the given token ID
1312      * @param to target address that will receive the tokens
1313      * @param tokenId uint256 ID of the token to be transferred
1314      * @param _data bytes optional data to send along with the call
1315      * @return bool whether the call correctly returned the expected magic value
1316      */
1317     function _checkContractOnERC721Received(
1318         address from,
1319         address to,
1320         uint256 tokenId,
1321         bytes memory _data
1322     ) private returns (bool) {
1323         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1324             return retval == IERC721Receiver(to).onERC721Received.selector;
1325         } catch (bytes memory reason) {
1326             if (reason.length == 0) {
1327                 revert TransferToNonERC721ReceiverImplementer();
1328             } else {
1329                 assembly {
1330                     revert(add(32, reason), mload(reason))
1331                 }
1332             }
1333         }
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1338      * And also called before burning one token.
1339      *
1340      * startTokenId - the first token id to be transferred
1341      * quantity - the amount to be transferred
1342      *
1343      * Calling conditions:
1344      *
1345      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1346      * transferred to `to`.
1347      * - When `from` is zero, `tokenId` will be minted for `to`.
1348      * - When `to` is zero, `tokenId` will be burned by `from`.
1349      * - `from` and `to` are never both zero.
1350      */
1351     function _beforeTokenTransfers(
1352         address from,
1353         address to,
1354         uint256 startTokenId,
1355         uint256 quantity
1356     ) internal virtual {}
1357 
1358     /**
1359      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1360      * minting.
1361      * And also called after one token has been burned.
1362      *
1363      * startTokenId - the first token id to be transferred
1364      * quantity - the amount to be transferred
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` has been minted for `to`.
1371      * - When `to` is zero, `tokenId` has been burned by `from`.
1372      * - `from` and `to` are never both zero.
1373      */
1374     function _afterTokenTransfers(
1375         address from,
1376         address to,
1377         uint256 startTokenId,
1378         uint256 quantity
1379     ) internal virtual {}
1380 }
1381 
1382 
1383 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v3.3.0
1384 
1385 // ERC721A Contracts v3.3.0
1386 // Creator: Chiru Labs
1387 
1388 pragma solidity ^0.8.4;
1389 
1390 
1391 /**
1392  * @title ERC721A Queryable
1393  * @dev ERC721A subclass with convenience query functions.
1394  */
1395 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1396     /**
1397      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1398      *
1399      * If the `tokenId` is out of bounds:
1400      *   - `addr` = `address(0)`
1401      *   - `startTimestamp` = `0`
1402      *   - `burned` = `false`
1403      *
1404      * If the `tokenId` is burned:
1405      *   - `addr` = `<Address of owner before token was burned>`
1406      *   - `startTimestamp` = `<Timestamp when token was burned>`
1407      *   - `burned = `true`
1408      *
1409      * Otherwise:
1410      *   - `addr` = `<Address of owner>`
1411      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1412      *   - `burned = `false`
1413      */
1414     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1415         TokenOwnership memory ownership;
1416         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1417             return ownership;
1418         }
1419         ownership = _ownerships[tokenId];
1420         if (ownership.burned) {
1421             return ownership;
1422         }
1423         return _ownershipOf(tokenId);
1424     }
1425 
1426     /**
1427      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1428      * See {ERC721AQueryable-explicitOwnershipOf}
1429      */
1430     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1431         unchecked {
1432             uint256 tokenIdsLength = tokenIds.length;
1433             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1434             for (uint256 i; i != tokenIdsLength; ++i) {
1435                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1436             }
1437             return ownerships;
1438         }
1439     }
1440 
1441     /**
1442      * @dev Returns an array of token IDs owned by `owner`,
1443      * in the range [`start`, `stop`)
1444      * (i.e. `start <= tokenId < stop`).
1445      *
1446      * This function allows for tokens to be queried if the collection
1447      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1448      *
1449      * Requirements:
1450      *
1451      * - `start` < `stop`
1452      */
1453     function tokensOfOwnerIn(
1454         address owner,
1455         uint256 start,
1456         uint256 stop
1457     ) external view override returns (uint256[] memory) {
1458         unchecked {
1459             if (start >= stop) revert InvalidQueryRange();
1460             uint256 tokenIdsIdx;
1461             uint256 stopLimit = _currentIndex;
1462             // Set `start = max(start, _startTokenId())`.
1463             if (start < _startTokenId()) {
1464                 start = _startTokenId();
1465             }
1466             // Set `stop = min(stop, _currentIndex)`.
1467             if (stop > stopLimit) {
1468                 stop = stopLimit;
1469             }
1470             uint256 tokenIdsMaxLength = balanceOf(owner);
1471             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1472             // to cater for cases where `balanceOf(owner)` is too big.
1473             if (start < stop) {
1474                 uint256 rangeLength = stop - start;
1475                 if (rangeLength < tokenIdsMaxLength) {
1476                     tokenIdsMaxLength = rangeLength;
1477                 }
1478             } else {
1479                 tokenIdsMaxLength = 0;
1480             }
1481             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1482             if (tokenIdsMaxLength == 0) {
1483                 return tokenIds;
1484             }
1485             // We need to call `explicitOwnershipOf(start)`,
1486             // because the slot at `start` may not be initialized.
1487             TokenOwnership memory ownership = explicitOwnershipOf(start);
1488             address currOwnershipAddr;
1489             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1490             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1491             if (!ownership.burned) {
1492                 currOwnershipAddr = ownership.addr;
1493             }
1494             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1495                 ownership = _ownerships[i];
1496                 if (ownership.burned) {
1497                     continue;
1498                 }
1499                 if (ownership.addr != address(0)) {
1500                     currOwnershipAddr = ownership.addr;
1501                 }
1502                 if (currOwnershipAddr == owner) {
1503                     tokenIds[tokenIdsIdx++] = i;
1504                 }
1505             }
1506             // Downsize the array to fit.
1507             assembly {
1508                 mstore(tokenIds, tokenIdsIdx)
1509             }
1510             return tokenIds;
1511         }
1512     }
1513 
1514     /**
1515      * @dev Returns an array of token IDs owned by `owner`.
1516      *
1517      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1518      * It is meant to be called off-chain.
1519      *
1520      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1521      * multiple smaller scans if the collection is large enough to cause
1522      * an out-of-gas error (10K pfp collections should be fine).
1523      */
1524     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1525         unchecked {
1526             uint256 tokenIdsIdx;
1527             address currOwnershipAddr;
1528             uint256 tokenIdsLength = balanceOf(owner);
1529             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1530             TokenOwnership memory ownership;
1531             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1532                 ownership = _ownerships[i];
1533                 if (ownership.burned) {
1534                     continue;
1535                 }
1536                 if (ownership.addr != address(0)) {
1537                     currOwnershipAddr = ownership.addr;
1538                 }
1539                 if (currOwnershipAddr == owner) {
1540                     tokenIds[tokenIdsIdx++] = i;
1541                 }
1542             }
1543             return tokenIds;
1544         }
1545     }
1546 }
1547 
1548 
1549 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1550 
1551 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1552 
1553 pragma solidity ^0.8.0;
1554 
1555 /**
1556  * @dev Contract module which provides a basic access control mechanism, where
1557  * there is an account (an owner) that can be granted exclusive access to
1558  * specific functions.
1559  *
1560  * By default, the owner account will be the one that deploys the contract. This
1561  * can later be changed with {transferOwnership}.
1562  *
1563  * This module is used through inheritance. It will make available the modifier
1564  * `onlyOwner`, which can be applied to your functions to restrict their use to
1565  * the owner.
1566  */
1567 abstract contract Ownable is Context {
1568     address private _owner;
1569 
1570     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1571 
1572     /**
1573      * @dev Initializes the contract setting the deployer as the initial owner.
1574      */
1575     constructor() {
1576         _transferOwnership(_msgSender());
1577     }
1578 
1579     /**
1580      * @dev Returns the address of the current owner.
1581      */
1582     function owner() public view virtual returns (address) {
1583         return _owner;
1584     }
1585 
1586     /**
1587      * @dev Throws if called by any account other than the owner.
1588      */
1589     modifier onlyOwner() {
1590         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1591         _;
1592     }
1593 
1594     /**
1595      * @dev Leaves the contract without owner. It will not be possible to call
1596      * `onlyOwner` functions anymore. Can only be called by the current owner.
1597      *
1598      * NOTE: Renouncing ownership will leave the contract without an owner,
1599      * thereby removing any functionality that is only available to the owner.
1600      */
1601     function renounceOwnership() public virtual onlyOwner {
1602         _transferOwnership(address(0));
1603     }
1604 
1605     /**
1606      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1607      * Can only be called by the current owner.
1608      */
1609     function transferOwnership(address newOwner) public virtual onlyOwner {
1610         require(newOwner != address(0), "Ownable: new owner is the zero address");
1611         _transferOwnership(newOwner);
1612     }
1613 
1614     /**
1615      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1616      * Internal function without access restriction.
1617      */
1618     function _transferOwnership(address newOwner) internal virtual {
1619         address oldOwner = _owner;
1620         _owner = newOwner;
1621         emit OwnershipTransferred(oldOwner, newOwner);
1622     }
1623 }
1624 
1625 
1626 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1627 
1628 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1629 
1630 pragma solidity ^0.8.0;
1631 
1632 /**
1633  * @dev These functions deal with verification of Merkle Trees proofs.
1634  *
1635  * The proofs can be generated using the JavaScript library
1636  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1637  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1638  *
1639  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1640  */
1641 library MerkleProof {
1642     /**
1643      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1644      * defined by `root`. For this, a `proof` must be provided, containing
1645      * sibling hashes on the branch from the leaf to the root of the tree. Each
1646      * pair of leaves and each pair of pre-images are assumed to be sorted.
1647      */
1648     function verify(
1649         bytes32[] memory proof,
1650         bytes32 root,
1651         bytes32 leaf
1652     ) internal pure returns (bool) {
1653         return processProof(proof, leaf) == root;
1654     }
1655 
1656     /**
1657      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1658      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1659      * hash matches the root of the tree. When processing the proof, the pairs
1660      * of leafs & pre-images are assumed to be sorted.
1661      *
1662      * _Available since v4.4._
1663      */
1664     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1665         bytes32 computedHash = leaf;
1666         for (uint256 i = 0; i < proof.length; i++) {
1667             bytes32 proofElement = proof[i];
1668             if (computedHash <= proofElement) {
1669                 // Hash(current computed hash + current element of the proof)
1670                 computedHash = _efficientHash(computedHash, proofElement);
1671             } else {
1672                 // Hash(current element of the proof + current computed hash)
1673                 computedHash = _efficientHash(proofElement, computedHash);
1674             }
1675         }
1676         return computedHash;
1677     }
1678 
1679     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1680         assembly {
1681             mstore(0x00, a)
1682             mstore(0x20, b)
1683             value := keccak256(0x00, 0x40)
1684         }
1685     }
1686 }
1687 
1688 
1689 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1690 
1691 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1692 
1693 pragma solidity ^0.8.0;
1694 
1695 /**
1696  * @dev Contract module that helps prevent reentrant calls to a function.
1697  *
1698  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1699  * available, which can be applied to functions to make sure there are no nested
1700  * (reentrant) calls to them.
1701  *
1702  * Note that because there is a single `nonReentrant` guard, functions marked as
1703  * `nonReentrant` may not call one another. This can be worked around by making
1704  * those functions `private`, and then adding `external` `nonReentrant` entry
1705  * points to them.
1706  *
1707  * TIP: If you would like to learn more about reentrancy and alternative ways
1708  * to protect against it, check out our blog post
1709  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1710  */
1711 abstract contract ReentrancyGuard {
1712     // Booleans are more expensive than uint256 or any type that takes up a full
1713     // word because each write operation emits an extra SLOAD to first read the
1714     // slot's contents, replace the bits taken up by the boolean, and then write
1715     // back. This is the compiler's defense against contract upgrades and
1716     // pointer aliasing, and it cannot be disabled.
1717 
1718     // The values being non-zero value makes deployment a bit more expensive,
1719     // but in exchange the refund on every call to nonReentrant will be lower in
1720     // amount. Since refunds are capped to a percentage of the total
1721     // transaction's gas, it is best to keep them low in cases like this one, to
1722     // increase the likelihood of the full refund coming into effect.
1723     uint256 private constant _NOT_ENTERED = 1;
1724     uint256 private constant _ENTERED = 2;
1725 
1726     uint256 private _status;
1727 
1728     constructor() {
1729         _status = _NOT_ENTERED;
1730     }
1731 
1732     /**
1733      * @dev Prevents a contract from calling itself, directly or indirectly.
1734      * Calling a `nonReentrant` function from another `nonReentrant`
1735      * function is not supported. It is possible to prevent this from happening
1736      * by making the `nonReentrant` function external, and making it call a
1737      * `private` function that does the actual work.
1738      */
1739     modifier nonReentrant() {
1740         // On the first call to nonReentrant, _notEntered will be true
1741         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1742 
1743         // Any calls to nonReentrant after this point will fail
1744         _status = _ENTERED;
1745 
1746         _;
1747 
1748         // By storing the original value once again, a refund is triggered (see
1749         // https://eips.ethereum.org/EIPS/eip-2200)
1750         _status = _NOT_ENTERED;
1751     }
1752 }
1753 
1754 
1755 // File contracts/TsongLodiGang.sol
1756 
1757 pragma solidity >=0.8.9 <0.9.0;
1758 
1759 
1760 
1761 
1762 contract TsongLodiGang is ERC721AQueryable, Ownable, ReentrancyGuard {
1763 
1764   using Strings for uint256;
1765 
1766   bytes32 public merkleRoot;
1767   mapping(address => bool) public whitelistClaimed;
1768 
1769   string public uriPrefix = '';
1770   string public uriSuffix = '.json';
1771   string public hiddenMetadataUri;
1772   
1773   uint256 public cost;
1774   uint256 public maxSupply;
1775   uint256 public maxMintAmountPerTx;
1776 
1777   bool public paused = true;
1778   bool public whitelistMintEnabled = false;
1779   bool public revealed = false;
1780 
1781   constructor(
1782     string memory _tokenName,
1783     string memory _tokenSymbol,
1784     uint256 _cost,
1785     uint256 _maxSupply,
1786     uint256 _maxMintAmountPerTx,
1787     string memory _hiddenMetadataUri
1788   ) ERC721A(_tokenName, _tokenSymbol) {
1789     setCost(_cost);
1790     maxSupply = _maxSupply;
1791     setMaxMintAmountPerTx(_maxMintAmountPerTx);
1792     setHiddenMetadataUri(_hiddenMetadataUri);
1793   }
1794 
1795   modifier mintCompliance(uint256 _mintAmount) {
1796     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1797     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1798     _;
1799   }
1800 
1801   modifier mintPriceCompliance(uint256 _mintAmount) {
1802     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1803     _;
1804   }
1805 
1806   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1807     // Verify whitelist requirements
1808     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1809     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
1810     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1811     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1812 
1813     whitelistClaimed[_msgSender()] = true;
1814     _safeMint(_msgSender(), _mintAmount);
1815   }
1816 
1817   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1818     require(!paused, 'The contract is paused!');
1819 
1820     _safeMint(_msgSender(), _mintAmount);
1821   }
1822   
1823   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1824     _safeMint(_receiver, _mintAmount);
1825   }
1826 
1827   function _startTokenId() internal view virtual override returns (uint256) {
1828     return 1;
1829   }
1830 
1831   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1832     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1833 
1834     if (revealed == false) {
1835       return hiddenMetadataUri;
1836     }
1837 
1838     string memory currentBaseURI = _baseURI();
1839     return bytes(currentBaseURI).length > 0
1840         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1841         : '';
1842   }
1843 
1844   function setRevealed(bool _state) public onlyOwner {
1845     revealed = _state;
1846   }
1847 
1848   function setCost(uint256 _cost) public onlyOwner {
1849     cost = _cost;
1850   }
1851 
1852   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1853     maxMintAmountPerTx = _maxMintAmountPerTx;
1854   }
1855 
1856   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1857     hiddenMetadataUri = _hiddenMetadataUri;
1858   }
1859 
1860   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1861     uriPrefix = _uriPrefix;
1862   }
1863 
1864   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1865     uriSuffix = _uriSuffix;
1866   }
1867 
1868   function setPaused(bool _state) public onlyOwner {
1869     paused = _state;
1870   }
1871 
1872   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1873     merkleRoot = _merkleRoot;
1874   }
1875 
1876   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1877     whitelistMintEnabled = _state;
1878   }
1879 
1880   function withdraw() public onlyOwner nonReentrant {
1881     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1882     require(os);
1883   }
1884 
1885   function _baseURI() internal view virtual override returns (string memory) {
1886     return uriPrefix;
1887   }
1888 }