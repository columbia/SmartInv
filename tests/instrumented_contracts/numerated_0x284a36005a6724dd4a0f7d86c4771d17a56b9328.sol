1 // SPDX-License-Identifier: MIT
2 
3 //....########..##....##..#######..########..########.....
4 //....##.....##..##..##..##.....##.##.....##.##.....##....
5 //....##.....##...####...##.....##.##.....##.##.....##....
6 //....########.....##....##.....##.########..##.....##....
7 //....##.....##....##....##.....##.##...##...##.....##....
8 //....##.....##....##....##.....##.##....##..##.....##....
9 //....########.....##.....#######..##.....##.########.....
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 
35 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
36 
37 // MIT
38 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Required interface of an ERC721 compliant contract.
44  */
45 interface IERC721 is IERC165 {
46     /**
47      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
48      */
49     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
53      */
54     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
55 
56     /**
57      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
58      */
59     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
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
137     function getApproved(uint256 tokenId) external view returns (address operator);
138 
139     /**
140      * @dev Approve or remove `operator` as an operator for the caller.
141      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
142      *
143      * Requirements:
144      *
145      * - The `operator` cannot be the caller.
146      *
147      * Emits an {ApprovalForAll} event.
148      */
149     function setApprovalForAll(address operator, bool _approved) external;
150 
151     /**
152      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
153      *
154      * See {setApprovalForAll}
155      */
156     function isApprovedForAll(address owner, address operator) external view returns (bool);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external;
177 }
178 
179 
180 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
181 
182 // MIT
183 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192     /**
193      * @dev Returns the token collection name.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the token collection symbol.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
204      */
205     function tokenURI(uint256 tokenId) external view returns (string memory);
206 }
207 
208 
209 // File erc721a/contracts/IERC721A.sol@v3.3.0
210 
211 // MIT
212 // ERC721A Contracts v3.3.0
213 // Creator: Chiru Labs
214 
215 pragma solidity ^0.8.4;
216 
217 
218 /**
219  * @dev Interface of an ERC721A compliant contract.
220  */
221 interface IERC721A is IERC721, IERC721Metadata {
222     /**
223      * The caller must own the token or be an approved operator.
224      */
225     error ApprovalCallerNotOwnerNorApproved();
226 
227     /**
228      * The token does not exist.
229      */
230     error ApprovalQueryForNonexistentToken();
231 
232     /**
233      * The caller cannot approve to their own address.
234      */
235     error ApproveToCaller();
236 
237     /**
238      * The caller cannot approve to the current owner.
239      */
240     error ApprovalToCurrentOwner();
241 
242     /**
243      * Cannot query the balance for the zero address.
244      */
245     error BalanceQueryForZeroAddress();
246 
247     /**
248      * Cannot mint to the zero address.
249      */
250     error MintToZeroAddress();
251 
252     /**
253      * The quantity of tokens minted must be more than zero.
254      */
255     error MintZeroQuantity();
256 
257     /**
258      * The token does not exist.
259      */
260     error OwnerQueryForNonexistentToken();
261 
262     /**
263      * The caller must own the token or be an approved operator.
264      */
265     error TransferCallerNotOwnerNorApproved();
266 
267     /**
268      * The token must be owned by `from`.
269      */
270     error TransferFromIncorrectOwner();
271 
272     /**
273      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
274      */
275     error TransferToNonERC721ReceiverImplementer();
276 
277     /**
278      * Cannot transfer to the zero address.
279      */
280     error TransferToZeroAddress();
281 
282     /**
283      * The token does not exist.
284      */
285     error URIQueryForNonexistentToken();
286 
287     // Compiler will pack this into a single 256bit word.
288     struct TokenOwnership {
289         // The address of the owner.
290         address addr;
291         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
292         uint64 startTimestamp;
293         // Whether the token has been burned.
294         bool burned;
295     }
296 
297     // Compiler will pack this into a single 256bit word.
298     struct AddressData {
299         // Realistically, 2**64-1 is more than enough.
300         uint64 balance;
301         // Keeps track of mint count with minimal overhead for tokenomics.
302         uint64 numberMinted;
303         // Keeps track of burn count with minimal overhead for tokenomics.
304         uint64 numberBurned;
305         // For miscellaneous variable(s) pertaining to the address
306         // (e.g. number of whitelist mint slots used).
307         // If there are multiple variables, please pack them into a uint64.
308         uint64 aux;
309     }
310 
311     /**
312      * @dev Returns the total amount of tokens stored by the contract.
313      * 
314      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
315      */
316     function totalSupply() external view returns (uint256);
317 }
318 
319 
320 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v3.3.0
321 
322 // MIT
323 // ERC721A Contracts v3.3.0
324 // Creator: Chiru Labs
325 
326 pragma solidity ^0.8.4;
327 
328 /**
329  * @dev Interface of an ERC721AQueryable compliant contract.
330  */
331 interface IERC721AQueryable is IERC721A {
332     /**
333      * Invalid query range (`start` >= `stop`).
334      */
335     error InvalidQueryRange();
336 
337     /**
338      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
339      *
340      * If the `tokenId` is out of bounds:
341      *   - `addr` = `address(0)`
342      *   - `startTimestamp` = `0`
343      *   - `burned` = `false`
344      *
345      * If the `tokenId` is burned:
346      *   - `addr` = `<Address of owner before token was burned>`
347      *   - `startTimestamp` = `<Timestamp when token was burned>`
348      *   - `burned = `true`
349      *
350      * Otherwise:
351      *   - `addr` = `<Address of owner>`
352      *   - `startTimestamp` = `<Timestamp of start of ownership>`
353      *   - `burned = `false`
354      */
355     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
356 
357     /**
358      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
359      * See {ERC721AQueryable-explicitOwnershipOf}
360      */
361     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
362 
363     /**
364      * @dev Returns an array of token IDs owned by `owner`,
365      * in the range [`start`, `stop`)
366      * (i.e. `start <= tokenId < stop`).
367      *
368      * This function allows for tokens to be queried if the collection
369      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
370      *
371      * Requirements:
372      *
373      * - `start` < `stop`
374      */
375     function tokensOfOwnerIn(
376         address owner,
377         uint256 start,
378         uint256 stop
379     ) external view returns (uint256[] memory);
380 
381     /**
382      * @dev Returns an array of token IDs owned by `owner`.
383      *
384      * This function scans the ownership mapping and is O(totalSupply) in complexity.
385      * It is meant to be called off-chain.
386      *
387      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
388      * multiple smaller scans if the collection is large enough to cause
389      * an out-of-gas error (10K pfp collections should be fine).
390      */
391     function tokensOfOwner(address owner) external view returns (uint256[] memory);
392 }
393 
394 
395 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
396 
397 // MIT
398 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @title ERC721 token receiver interface
404  * @dev Interface for any contract that wants to support safeTransfers
405  * from ERC721 asset contracts.
406  */
407 interface IERC721Receiver {
408     /**
409      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
410      * by `operator` from `from`, this function is called.
411      *
412      * It must return its Solidity selector to confirm the token transfer.
413      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
414      *
415      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
416      */
417     function onERC721Received(
418         address operator,
419         address from,
420         uint256 tokenId,
421         bytes calldata data
422     ) external returns (bytes4);
423 }
424 
425 
426 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
427 
428 // MIT
429 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
430 
431 pragma solidity ^0.8.1;
432 
433 /**
434  * @dev Collection of functions related to the address type
435  */
436 library Address {
437     /**
438      * @dev Returns true if `account` is a contract.
439      *
440      * [IMPORTANT]
441      * ====
442      * It is unsafe to assume that an address for which this function returns
443      * false is an externally-owned account (EOA) and not a contract.
444      *
445      * Among others, `isContract` will return false for the following
446      * types of addresses:
447      *
448      *  - an externally-owned account
449      *  - a contract in construction
450      *  - an address where a contract will be created
451      *  - an address where a contract lived, but was destroyed
452      * ====
453      *
454      * [IMPORTANT]
455      * ====
456      * You shouldn't rely on `isContract` to protect against flash loan attacks!
457      *
458      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
459      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
460      * constructor.
461      * ====
462      */
463     function isContract(address account) internal view returns (bool) {
464         // This method relies on extcodesize/address.code.length, which returns 0
465         // for contracts in construction, since the code is only stored at the end
466         // of the constructor execution.
467 
468         return account.code.length > 0;
469     }
470 
471     /**
472      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
473      * `recipient`, forwarding all available gas and reverting on errors.
474      *
475      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
476      * of certain opcodes, possibly making contracts go over the 2300 gas limit
477      * imposed by `transfer`, making them unable to receive funds via
478      * `transfer`. {sendValue} removes this limitation.
479      *
480      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
481      *
482      * IMPORTANT: because control is transferred to `recipient`, care must be
483      * taken to not create reentrancy vulnerabilities. Consider using
484      * {ReentrancyGuard} or the
485      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
486      */
487     function sendValue(address payable recipient, uint256 amount) internal {
488         require(address(this).balance >= amount, "Address: insufficient balance");
489 
490         (bool success, ) = recipient.call{value: amount}("");
491         require(success, "Address: unable to send value, recipient may have reverted");
492     }
493 
494     /**
495      * @dev Performs a Solidity function call using a low level `call`. A
496      * plain `call` is an unsafe replacement for a function call: use this
497      * function instead.
498      *
499      * If `target` reverts with a revert reason, it is bubbled up by this
500      * function (like regular Solidity function calls).
501      *
502      * Returns the raw returned data. To convert to the expected return value,
503      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
504      *
505      * Requirements:
506      *
507      * - `target` must be a contract.
508      * - calling `target` with `data` must not revert.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
513         return functionCall(target, data, "Address: low-level call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
518      * `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, 0, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but also transferring `value` wei to `target`.
533      *
534      * Requirements:
535      *
536      * - the calling contract must have an ETH balance of at least `value`.
537      * - the called Solidity function must be `payable`.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
551      * with `errorMessage` as a fallback revert reason when `target` reverts.
552      *
553      * _Available since v3.1._
554      */
555     function functionCallWithValue(
556         address target,
557         bytes memory data,
558         uint256 value,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(address(this).balance >= value, "Address: insufficient balance for call");
562         require(isContract(target), "Address: call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.call{value: value}(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
570      * but performing a static call.
571      *
572      * _Available since v3.3._
573      */
574     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
575         return functionStaticCall(target, data, "Address: low-level static call failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
580      * but performing a static call.
581      *
582      * _Available since v3.3._
583      */
584     function functionStaticCall(
585         address target,
586         bytes memory data,
587         string memory errorMessage
588     ) internal view returns (bytes memory) {
589         require(isContract(target), "Address: static call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.staticcall(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a delegate call.
598      *
599      * _Available since v3.4._
600      */
601     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
602         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal returns (bytes memory) {
616         require(isContract(target), "Address: delegate call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.delegatecall(data);
619         return verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
624      * revert reason using the provided one.
625      *
626      * _Available since v4.3._
627      */
628     function verifyCallResult(
629         bool success,
630         bytes memory returndata,
631         string memory errorMessage
632     ) internal pure returns (bytes memory) {
633         if (success) {
634             return returndata;
635         } else {
636             // Look for revert reason and bubble it up if present
637             if (returndata.length > 0) {
638                 // The easiest way to bubble the revert reason is using memory via assembly
639 
640                 assembly {
641                     let returndata_size := mload(returndata)
642                     revert(add(32, returndata), returndata_size)
643                 }
644             } else {
645                 revert(errorMessage);
646             }
647         }
648     }
649 }
650 
651 
652 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
653 
654 // MIT
655 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @dev Provides information about the current execution context, including the
661  * sender of the transaction and its data. While these are generally available
662  * via msg.sender and msg.data, they should not be accessed in such a direct
663  * manner, since when dealing with meta-transactions the account sending and
664  * paying for execution may not be the actual sender (as far as an application
665  * is concerned).
666  *
667  * This contract is only required for intermediate, library-like contracts.
668  */
669 abstract contract Context {
670     function _msgSender() internal view virtual returns (address) {
671         return msg.sender;
672     }
673 
674     function _msgData() internal view virtual returns (bytes calldata) {
675         return msg.data;
676     }
677 }
678 
679 
680 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
681 
682 // MIT
683 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @dev String operations.
689  */
690 library Strings {
691     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
692 
693     /**
694      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
695      */
696     function toString(uint256 value) internal pure returns (string memory) {
697         // Inspired by OraclizeAPI's implementation - MIT licence
698         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
699 
700         if (value == 0) {
701             return "0";
702         }
703         uint256 temp = value;
704         uint256 digits;
705         while (temp != 0) {
706             digits++;
707             temp /= 10;
708         }
709         bytes memory buffer = new bytes(digits);
710         while (value != 0) {
711             digits -= 1;
712             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
713             value /= 10;
714         }
715         return string(buffer);
716     }
717 
718     /**
719      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
720      */
721     function toHexString(uint256 value) internal pure returns (string memory) {
722         if (value == 0) {
723             return "0x00";
724         }
725         uint256 temp = value;
726         uint256 length = 0;
727         while (temp != 0) {
728             length++;
729             temp >>= 8;
730         }
731         return toHexString(value, length);
732     }
733 
734     /**
735      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
736      */
737     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
738         bytes memory buffer = new bytes(2 * length + 2);
739         buffer[0] = "0";
740         buffer[1] = "x";
741         for (uint256 i = 2 * length + 1; i > 1; --i) {
742             buffer[i] = _HEX_SYMBOLS[value & 0xf];
743             value >>= 4;
744         }
745         require(value == 0, "Strings: hex length insufficient");
746         return string(buffer);
747     }
748 }
749 
750 
751 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
752 
753 // MIT
754 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 /**
759  * @dev Implementation of the {IERC165} interface.
760  *
761  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
762  * for the additional interface id that will be supported. For example:
763  *
764  * ```solidity
765  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
766  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
767  * }
768  * ```
769  *
770  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
771  */
772 abstract contract ERC165 is IERC165 {
773     /**
774      * @dev See {IERC165-supportsInterface}.
775      */
776     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
777         return interfaceId == type(IERC165).interfaceId;
778     }
779 }
780 
781 
782 // File erc721a/contracts/ERC721A.sol@v3.3.0
783 
784 // MIT
785 // ERC721A Contracts v3.3.0
786 // Creator: Chiru Labs
787 
788 pragma solidity ^0.8.4;
789 
790 
791 
792 
793 
794 
795 /**
796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
797  * the Metadata extension. Built to optimize for lower gas during batch mints.
798  *
799  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
800  *
801  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
802  *
803  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
804  */
805 contract ERC721A is Context, ERC165, IERC721A {
806     using Address for address;
807     using Strings for uint256;
808 
809     // The tokenId of the next token to be minted.
810     uint256 internal _currentIndex;
811 
812     // The number of tokens burned.
813     uint256 internal _burnCounter;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to ownership details
822     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
823     mapping(uint256 => TokenOwnership) internal _ownerships;
824 
825     // Mapping owner address to address data
826     mapping(address => AddressData) private _addressData;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837         _currentIndex = _startTokenId();
838     }
839 
840     /**
841      * To change the starting tokenId, please override this function.
842      */
843     function _startTokenId() internal view virtual returns (uint256) {
844         return 0;
845     }
846 
847     /**
848      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
849      */
850     function totalSupply() public view override returns (uint256) {
851         // Counter underflow is impossible as _burnCounter cannot be incremented
852         // more than _currentIndex - _startTokenId() times
853         unchecked {
854             return _currentIndex - _burnCounter - _startTokenId();
855         }
856     }
857 
858     /**
859      * Returns the total amount of tokens minted in the contract.
860      */
861     function _totalMinted() internal view returns (uint256) {
862         // Counter underflow is impossible as _currentIndex does not decrement,
863         // and it is initialized to _startTokenId()
864         unchecked {
865             return _currentIndex - _startTokenId();
866         }
867     }
868 
869     /**
870      * @dev See {IERC165-supportsInterface}.
871      */
872     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
873         return
874             interfaceId == type(IERC721).interfaceId ||
875             interfaceId == type(IERC721Metadata).interfaceId ||
876             super.supportsInterface(interfaceId);
877     }
878 
879     /**
880      * @dev See {IERC721-balanceOf}.
881      */
882     function balanceOf(address owner) public view override returns (uint256) {
883         if (owner == address(0)) revert BalanceQueryForZeroAddress();
884         return uint256(_addressData[owner].balance);
885     }
886 
887     /**
888      * Returns the number of tokens minted by `owner`.
889      */
890     function _numberMinted(address owner) internal view returns (uint256) {
891         return uint256(_addressData[owner].numberMinted);
892     }
893 
894     /**
895      * Returns the number of tokens burned by or on behalf of `owner`.
896      */
897     function _numberBurned(address owner) internal view returns (uint256) {
898         return uint256(_addressData[owner].numberBurned);
899     }
900 
901     /**
902      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
903      */
904     function _getAux(address owner) internal view returns (uint64) {
905         return _addressData[owner].aux;
906     }
907 
908     /**
909      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      * If there are multiple variables, please pack them into a uint64.
911      */
912     function _setAux(address owner, uint64 aux) internal {
913         _addressData[owner].aux = aux;
914     }
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         uint256 curr = tokenId;
922 
923         unchecked {
924             if (_startTokenId() <= curr) if (curr < _currentIndex) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (!ownership.burned) {
927                     if (ownership.addr != address(0)) {
928                         return ownership;
929                     }
930                     // Invariant:
931                     // There will always be an ownership that has an address and is not burned
932                     // before an ownership that does not have an address and is not burned.
933                     // Hence, curr will not underflow.
934                     while (true) {
935                         curr--;
936                         ownership = _ownerships[curr];
937                         if (ownership.addr != address(0)) {
938                             return ownership;
939                         }
940                     }
941                 }
942             }
943         }
944         revert OwnerQueryForNonexistentToken();
945     }
946 
947     /**
948      * @dev See {IERC721-ownerOf}.
949      */
950     function ownerOf(uint256 tokenId) public view override returns (address) {
951         return _ownershipOf(tokenId).addr;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-name}.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-symbol}.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-tokenURI}.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, can be overriden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return '';
985     }
986 
987     /**
988      * @dev See {IERC721-approve}.
989      */
990     function approve(address to, uint256 tokenId) public override {
991         address owner = ERC721A.ownerOf(tokenId);
992         if (to == owner) revert ApprovalToCurrentOwner();
993 
994         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
995             revert ApprovalCallerNotOwnerNorApproved();
996         }
997 
998         _approve(to, tokenId, owner);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId) public view override returns (address) {
1005         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1006 
1007         return _tokenApprovals[tokenId];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-setApprovalForAll}.
1012      */
1013     function setApprovalForAll(address operator, bool approved) public virtual override {
1014         if (operator == _msgSender()) revert ApproveToCaller();
1015 
1016         _operatorApprovals[_msgSender()][operator] = approved;
1017         emit ApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1024         return _operatorApprovals[owner][operator];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-transferFrom}.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         safeTransferFrom(from, to, tokenId, '');
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         _transfer(from, to, tokenId);
1059         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1060             revert TransferToNonERC721ReceiverImplementer();
1061         }
1062     }
1063 
1064     /**
1065      * @dev Returns whether `tokenId` exists.
1066      *
1067      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1068      *
1069      * Tokens start existing when they are minted (`_mint`),
1070      */
1071     function _exists(uint256 tokenId) internal view returns (bool) {
1072         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1073     }
1074 
1075     /**
1076      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1077      */
1078     function _safeMint(address to, uint256 quantity) internal {
1079         _safeMint(to, quantity, '');
1080     }
1081 
1082     /**
1083      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - If `to` refers to a smart contract, it must implement
1088      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _safeMint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data
1097     ) internal {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1106         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1107         unchecked {
1108             _addressData[to].balance += uint64(quantity);
1109             _addressData[to].numberMinted += uint64(quantity);
1110 
1111             _ownerships[startTokenId].addr = to;
1112             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1113 
1114             uint256 updatedIndex = startTokenId;
1115             uint256 end = updatedIndex + quantity;
1116 
1117             if (to.isContract()) {
1118                 do {
1119                     emit Transfer(address(0), to, updatedIndex);
1120                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1121                         revert TransferToNonERC721ReceiverImplementer();
1122                     }
1123                 } while (updatedIndex < end);
1124                 // Reentrancy protection
1125                 if (_currentIndex != startTokenId) revert();
1126             } else {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex++);
1129                 } while (updatedIndex < end);
1130             }
1131             _currentIndex = updatedIndex;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Mints `quantity` tokens and transfers them to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `quantity` must be greater than 0.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _mint(address to, uint256 quantity) internal {
1147         uint256 startTokenId = _currentIndex;
1148         if (to == address(0)) revert MintToZeroAddress();
1149         if (quantity == 0) revert MintZeroQuantity();
1150 
1151         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1152 
1153         // Overflows are incredibly unrealistic.
1154         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1155         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1156         unchecked {
1157             _addressData[to].balance += uint64(quantity);
1158             _addressData[to].numberMinted += uint64(quantity);
1159 
1160             _ownerships[startTokenId].addr = to;
1161             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             uint256 updatedIndex = startTokenId;
1164             uint256 end = updatedIndex + quantity;
1165 
1166             do {
1167                 emit Transfer(address(0), to, updatedIndex++);
1168             } while (updatedIndex < end);
1169 
1170             _currentIndex = updatedIndex;
1171         }
1172         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1173     }
1174 
1175     /**
1176      * @dev Transfers `tokenId` from `from` to `to`.
1177      *
1178      * Requirements:
1179      *
1180      * - `to` cannot be the zero address.
1181      * - `tokenId` token must be owned by `from`.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _transfer(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) private {
1190         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1191 
1192         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1193 
1194         bool isApprovedOrOwner = (_msgSender() == from ||
1195             isApprovedForAll(from, _msgSender()) ||
1196             getApproved(tokenId) == _msgSender());
1197 
1198         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1199         if (to == address(0)) revert TransferToZeroAddress();
1200 
1201         _beforeTokenTransfers(from, to, tokenId, 1);
1202 
1203         // Clear approvals from the previous owner
1204         _approve(address(0), tokenId, from);
1205 
1206         // Underflow of the sender's balance is impossible because we check for
1207         // ownership above and the recipient's balance can't realistically overflow.
1208         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1209         unchecked {
1210             _addressData[from].balance -= 1;
1211             _addressData[to].balance += 1;
1212 
1213             TokenOwnership storage currSlot = _ownerships[tokenId];
1214             currSlot.addr = to;
1215             currSlot.startTimestamp = uint64(block.timestamp);
1216 
1217             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1218             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1219             uint256 nextTokenId = tokenId + 1;
1220             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1221             if (nextSlot.addr == address(0)) {
1222                 // This will suffice for checking _exists(nextTokenId),
1223                 // as a burned slot cannot contain the zero address.
1224                 if (nextTokenId != _currentIndex) {
1225                     nextSlot.addr = from;
1226                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(from, to, tokenId);
1232         _afterTokenTransfers(from, to, tokenId, 1);
1233     }
1234 
1235     /**
1236      * @dev Equivalent to `_burn(tokenId, false)`.
1237      */
1238     function _burn(uint256 tokenId) internal virtual {
1239         _burn(tokenId, false);
1240     }
1241 
1242     /**
1243      * @dev Destroys `tokenId`.
1244      * The approval is cleared when the token is burned.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must exist.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1253         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1254 
1255         address from = prevOwnership.addr;
1256 
1257         if (approvalCheck) {
1258             bool isApprovedOrOwner = (_msgSender() == from ||
1259                 isApprovedForAll(from, _msgSender()) ||
1260                 getApproved(tokenId) == _msgSender());
1261 
1262             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1263         }
1264 
1265         _beforeTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Clear approvals from the previous owner
1268         _approve(address(0), tokenId, from);
1269 
1270         // Underflow of the sender's balance is impossible because we check for
1271         // ownership above and the recipient's balance can't realistically overflow.
1272         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1273         unchecked {
1274             AddressData storage addressData = _addressData[from];
1275             addressData.balance -= 1;
1276             addressData.numberBurned += 1;
1277 
1278             // Keep track of who burned the token, and the timestamp of burning.
1279             TokenOwnership storage currSlot = _ownerships[tokenId];
1280             currSlot.addr = from;
1281             currSlot.startTimestamp = uint64(block.timestamp);
1282             currSlot.burned = true;
1283 
1284             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1285             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1286             uint256 nextTokenId = tokenId + 1;
1287             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1288             if (nextSlot.addr == address(0)) {
1289                 // This will suffice for checking _exists(nextTokenId),
1290                 // as a burned slot cannot contain the zero address.
1291                 if (nextTokenId != _currentIndex) {
1292                     nextSlot.addr = from;
1293                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1294                 }
1295             }
1296         }
1297 
1298         emit Transfer(from, address(0), tokenId);
1299         _afterTokenTransfers(from, address(0), tokenId, 1);
1300 
1301         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1302         unchecked {
1303             _burnCounter++;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Approve `to` to operate on `tokenId`
1309      *
1310      * Emits a {Approval} event.
1311      */
1312     function _approve(
1313         address to,
1314         uint256 tokenId,
1315         address owner
1316     ) private {
1317         _tokenApprovals[tokenId] = to;
1318         emit Approval(owner, to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkContractOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1337             return retval == IERC721Receiver(to).onERC721Received.selector;
1338         } catch (bytes memory reason) {
1339             if (reason.length == 0) {
1340                 revert TransferToNonERC721ReceiverImplementer();
1341             } else {
1342                 assembly {
1343                     revert(add(32, reason), mload(reason))
1344                 }
1345             }
1346         }
1347     }
1348 
1349     /**
1350      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1351      * And also called before burning one token.
1352      *
1353      * startTokenId - the first token id to be transferred
1354      * quantity - the amount to be transferred
1355      *
1356      * Calling conditions:
1357      *
1358      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1359      * transferred to `to`.
1360      * - When `from` is zero, `tokenId` will be minted for `to`.
1361      * - When `to` is zero, `tokenId` will be burned by `from`.
1362      * - `from` and `to` are never both zero.
1363      */
1364     function _beforeTokenTransfers(
1365         address from,
1366         address to,
1367         uint256 startTokenId,
1368         uint256 quantity
1369     ) internal virtual {}
1370 
1371     /**
1372      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1373      * minting.
1374      * And also called after one token has been burned.
1375      *
1376      * startTokenId - the first token id to be transferred
1377      * quantity - the amount to be transferred
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` has been minted for `to`.
1384      * - When `to` is zero, `tokenId` has been burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _afterTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 }
1394 
1395 
1396 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v3.3.0
1397 
1398 // MIT
1399 // ERC721A Contracts v3.3.0
1400 // Creator: Chiru Labs
1401 
1402 pragma solidity ^0.8.4;
1403 
1404 
1405 /**
1406  * @title ERC721A Queryable
1407  * @dev ERC721A subclass with convenience query functions.
1408  */
1409 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1410     /**
1411      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1412      *
1413      * If the `tokenId` is out of bounds:
1414      *   - `addr` = `address(0)`
1415      *   - `startTimestamp` = `0`
1416      *   - `burned` = `false`
1417      *
1418      * If the `tokenId` is burned:
1419      *   - `addr` = `<Address of owner before token was burned>`
1420      *   - `startTimestamp` = `<Timestamp when token was burned>`
1421      *   - `burned = `true`
1422      *
1423      * Otherwise:
1424      *   - `addr` = `<Address of owner>`
1425      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1426      *   - `burned = `false`
1427      */
1428     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1429         TokenOwnership memory ownership;
1430         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1431             return ownership;
1432         }
1433         ownership = _ownerships[tokenId];
1434         if (ownership.burned) {
1435             return ownership;
1436         }
1437         return _ownershipOf(tokenId);
1438     }
1439 
1440     /**
1441      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1442      * See {ERC721AQueryable-explicitOwnershipOf}
1443      */
1444     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1445         unchecked {
1446             uint256 tokenIdsLength = tokenIds.length;
1447             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1448             for (uint256 i; i != tokenIdsLength; ++i) {
1449                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1450             }
1451             return ownerships;
1452         }
1453     }
1454 
1455     /**
1456      * @dev Returns an array of token IDs owned by `owner`,
1457      * in the range [`start`, `stop`)
1458      * (i.e. `start <= tokenId < stop`).
1459      *
1460      * This function allows for tokens to be queried if the collection
1461      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1462      *
1463      * Requirements:
1464      *
1465      * - `start` < `stop`
1466      */
1467     function tokensOfOwnerIn(
1468         address owner,
1469         uint256 start,
1470         uint256 stop
1471     ) external view override returns (uint256[] memory) {
1472         unchecked {
1473             if (start >= stop) revert InvalidQueryRange();
1474             uint256 tokenIdsIdx;
1475             uint256 stopLimit = _currentIndex;
1476             // Set `start = max(start, _startTokenId())`.
1477             if (start < _startTokenId()) {
1478                 start = _startTokenId();
1479             }
1480             // Set `stop = min(stop, _currentIndex)`.
1481             if (stop > stopLimit) {
1482                 stop = stopLimit;
1483             }
1484             uint256 tokenIdsMaxLength = balanceOf(owner);
1485             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1486             // to cater for cases where `balanceOf(owner)` is too big.
1487             if (start < stop) {
1488                 uint256 rangeLength = stop - start;
1489                 if (rangeLength < tokenIdsMaxLength) {
1490                     tokenIdsMaxLength = rangeLength;
1491                 }
1492             } else {
1493                 tokenIdsMaxLength = 0;
1494             }
1495             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1496             if (tokenIdsMaxLength == 0) {
1497                 return tokenIds;
1498             }
1499             // We need to call `explicitOwnershipOf(start)`,
1500             // because the slot at `start` may not be initialized.
1501             TokenOwnership memory ownership = explicitOwnershipOf(start);
1502             address currOwnershipAddr;
1503             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1504             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1505             if (!ownership.burned) {
1506                 currOwnershipAddr = ownership.addr;
1507             }
1508             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1509                 ownership = _ownerships[i];
1510                 if (ownership.burned) {
1511                     continue;
1512                 }
1513                 if (ownership.addr != address(0)) {
1514                     currOwnershipAddr = ownership.addr;
1515                 }
1516                 if (currOwnershipAddr == owner) {
1517                     tokenIds[tokenIdsIdx++] = i;
1518                 }
1519             }
1520             // Downsize the array to fit.
1521             assembly {
1522                 mstore(tokenIds, tokenIdsIdx)
1523             }
1524             return tokenIds;
1525         }
1526     }
1527 
1528     /**
1529      * @dev Returns an array of token IDs owned by `owner`.
1530      *
1531      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1532      * It is meant to be called off-chain.
1533      *
1534      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1535      * multiple smaller scans if the collection is large enough to cause
1536      * an out-of-gas error (10K pfp collections should be fine).
1537      */
1538     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1539         unchecked {
1540             uint256 tokenIdsIdx;
1541             address currOwnershipAddr;
1542             uint256 tokenIdsLength = balanceOf(owner);
1543             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1544             TokenOwnership memory ownership;
1545             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1546                 ownership = _ownerships[i];
1547                 if (ownership.burned) {
1548                     continue;
1549                 }
1550                 if (ownership.addr != address(0)) {
1551                     currOwnershipAddr = ownership.addr;
1552                 }
1553                 if (currOwnershipAddr == owner) {
1554                     tokenIds[tokenIdsIdx++] = i;
1555                 }
1556             }
1557             return tokenIds;
1558         }
1559     }
1560 }
1561 
1562 
1563 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1564 
1565 // MIT
1566 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1567 
1568 pragma solidity ^0.8.0;
1569 
1570 /**
1571  * @dev Contract module which provides a basic access control mechanism, where
1572  * there is an account (an owner) that can be granted exclusive access to
1573  * specific functions.
1574  *
1575  * By default, the owner account will be the one that deploys the contract. This
1576  * can later be changed with {transferOwnership}.
1577  *
1578  * This module is used through inheritance. It will make available the modifier
1579  * `onlyOwner`, which can be applied to your functions to restrict their use to
1580  * the owner.
1581  */
1582 abstract contract Ownable is Context {
1583     address private _owner;
1584 
1585     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1586 
1587     /**
1588      * @dev Initializes the contract setting the deployer as the initial owner.
1589      */
1590     constructor() {
1591         _transferOwnership(_msgSender());
1592     }
1593 
1594     /**
1595      * @dev Returns the address of the current owner.
1596      */
1597     function owner() public view virtual returns (address) {
1598         return _owner;
1599     }
1600 
1601     /**
1602      * @dev Throws if called by any account other than the owner.
1603      */
1604     modifier onlyOwner() {
1605         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1606         _;
1607     }
1608 
1609     /**
1610      * @dev Leaves the contract without owner. It will not be possible to call
1611      * `onlyOwner` functions anymore. Can only be called by the current owner.
1612      *
1613      * NOTE: Renouncing ownership will leave the contract without an owner,
1614      * thereby removing any functionality that is only available to the owner.
1615      */
1616     function renounceOwnership() public virtual onlyOwner {
1617         _transferOwnership(address(0));
1618     }
1619 
1620     /**
1621      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1622      * Can only be called by the current owner.
1623      */
1624     function transferOwnership(address newOwner) public virtual onlyOwner {
1625         require(newOwner != address(0), "Ownable: new owner is the zero address");
1626         _transferOwnership(newOwner);
1627     }
1628 
1629     /**
1630      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1631      * Internal function without access restriction.
1632      */
1633     function _transferOwnership(address newOwner) internal virtual {
1634         address oldOwner = _owner;
1635         _owner = newOwner;
1636         emit OwnershipTransferred(oldOwner, newOwner);
1637     }
1638 }
1639 
1640 
1641 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1642 
1643 // MIT
1644 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1645 
1646 pragma solidity ^0.8.0;
1647 
1648 /**
1649  * @dev These functions deal with verification of Merkle Trees proofs.
1650  *
1651  * The proofs can be generated using the JavaScript library
1652  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1653  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1654  *
1655  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1656  */
1657 library MerkleProof {
1658     /**
1659      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1660      * defined by `root`. For this, a `proof` must be provided, containing
1661      * sibling hashes on the branch from the leaf to the root of the tree. Each
1662      * pair of leaves and each pair of pre-images are assumed to be sorted.
1663      */
1664     function verify(
1665         bytes32[] memory proof,
1666         bytes32 root,
1667         bytes32 leaf
1668     ) internal pure returns (bool) {
1669         return processProof(proof, leaf) == root;
1670     }
1671 
1672     /**
1673      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1674      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1675      * hash matches the root of the tree. When processing the proof, the pairs
1676      * of leafs & pre-images are assumed to be sorted.
1677      *
1678      * _Available since v4.4._
1679      */
1680     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1681         bytes32 computedHash = leaf;
1682         for (uint256 i = 0; i < proof.length; i++) {
1683             bytes32 proofElement = proof[i];
1684             if (computedHash <= proofElement) {
1685                 // Hash(current computed hash + current element of the proof)
1686                 computedHash = _efficientHash(computedHash, proofElement);
1687             } else {
1688                 // Hash(current element of the proof + current computed hash)
1689                 computedHash = _efficientHash(proofElement, computedHash);
1690             }
1691         }
1692         return computedHash;
1693     }
1694 
1695     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1696         assembly {
1697             mstore(0x00, a)
1698             mstore(0x20, b)
1699             value := keccak256(0x00, 0x40)
1700         }
1701     }
1702 }
1703 
1704 
1705 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1706 
1707 // MIT
1708 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1709 
1710 pragma solidity ^0.8.0;
1711 
1712 /**
1713  * @dev Contract module that helps prevent reentrant calls to a function.
1714  *
1715  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1716  * available, which can be applied to functions to make sure there are no nested
1717  * (reentrant) calls to them.
1718  *
1719  * Note that because there is a single `nonReentrant` guard, functions marked as
1720  * `nonReentrant` may not call one another. This can be worked around by making
1721  * those functions `private`, and then adding `external` `nonReentrant` entry
1722  * points to them.
1723  *
1724  * TIP: If you would like to learn more about reentrancy and alternative ways
1725  * to protect against it, check out our blog post
1726  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1727  */
1728 abstract contract ReentrancyGuard {
1729     // Booleans are more expensive than uint256 or any type that takes up a full
1730     // word because each write operation emits an extra SLOAD to first read the
1731     // slot's contents, replace the bits taken up by the boolean, and then write
1732     // back. This is the compiler's defense against contract upgrades and
1733     // pointer aliasing, and it cannot be disabled.
1734 
1735     // The values being non-zero value makes deployment a bit more expensive,
1736     // but in exchange the refund on every call to nonReentrant will be lower in
1737     // amount. Since refunds are capped to a percentage of the total
1738     // transaction's gas, it is best to keep them low in cases like this one, to
1739     // increase the likelihood of the full refund coming into effect.
1740     uint256 private constant _NOT_ENTERED = 1;
1741     uint256 private constant _ENTERED = 2;
1742 
1743     uint256 private _status;
1744 
1745     constructor() {
1746         _status = _NOT_ENTERED;
1747     }
1748 
1749     /**
1750      * @dev Prevents a contract from calling itself, directly or indirectly.
1751      * Calling a `nonReentrant` function from another `nonReentrant`
1752      * function is not supported. It is possible to prevent this from happening
1753      * by making the `nonReentrant` function external, and making it call a
1754      * `private` function that does the actual work.
1755      */
1756     modifier nonReentrant() {
1757         // On the first call to nonReentrant, _notEntered will be true
1758         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1759 
1760         // Any calls to nonReentrant after this point will fail
1761         _status = _ENTERED;
1762 
1763         _;
1764 
1765         // By storing the original value once again, a refund is triggered (see
1766         // https://eips.ethereum.org/EIPS/eip-2200)
1767         _status = _NOT_ENTERED;
1768     }
1769 }
1770 
1771 
1772 // File contracts/Byord.sol
1773 
1774 // MIT
1775 
1776 pragma solidity >=0.8.9 <0.9.0;
1777 
1778 
1779 
1780 
1781 interface RDIERC721  {
1782 
1783     event Transfer(
1784         address indexed from,
1785         address indexed to,
1786         uint256 indexed tokenId
1787     );
1788 
1789 
1790     event Approval(
1791         address indexed owner,
1792         address indexed approved,
1793         uint256 indexed tokenId
1794     );
1795 
1796 
1797     event ApprovalForAll(
1798         address indexed owner,
1799         address indexed operator,
1800         bool approved
1801     );
1802 
1803 
1804     function balanceOf(address owner) external view returns (uint256 balance);
1805 
1806 
1807     function ownerOf(uint256 tokenId) external view returns (address owner);
1808 
1809 
1810     function safeTransferFrom(
1811         address from,
1812         address to,
1813         uint256 tokenId
1814     ) external;
1815 
1816 
1817     function transferFrom(
1818         address from,
1819         address to,
1820         uint256 tokenId
1821     ) external;
1822 
1823 
1824     function approve(address to, uint256 tokenId) external;
1825 
1826 
1827     function getApproved(uint256 tokenId)
1828         external
1829         view
1830         returns (address operator);
1831 
1832 
1833     function setApprovalForAll(address operator, bool _approved) external;
1834 
1835 
1836     function isApprovedForAll(address owner, address operator)
1837         external
1838         view
1839         returns (bool);
1840 
1841 
1842     function safeTransferFrom(
1843         address from,
1844         address to,
1845         uint256 tokenId,
1846         bytes calldata data
1847     ) external;
1848 
1849     function walletOfOwner(address _owner)
1850         external
1851         view
1852         returns (uint256[] memory);
1853 }
1854 
1855 contract Byord is ERC721AQueryable, Ownable, ReentrancyGuard {
1856 
1857   using Strings for uint256;
1858   
1859   RDIERC721 public rdc;
1860   address public _signer;
1861   bytes32 public merkleRoot;
1862   bytes32 public honorariesMerkleRoot;
1863   bytes32 public waitListMerkleRoot;
1864   
1865   mapping(uint256 => bool) public genesisClaimed;
1866   mapping(address => uint256) public mintedForAddress;
1867   mapping(address => uint256) public honoraryAddressMinted;
1868 
1869   string public uriPrefix = '';
1870   string public uriSuffix = '.json';
1871 
1872   uint256 public cost=200000000000000000;
1873   uint256 public maxListSupply=2801;
1874   uint256 public maxClaimingSupply=2001;
1875   uint256 public maxHonorarySupply=201;
1876 
1877   uint256 public maxSupply=5001;
1878   
1879   uint256 public maxMintAmountPerTx=3;
1880   uint256 public maxMintAmountPerAddress=3;
1881   uint256 public honoraryIndex;
1882   uint256 public claimedIndex;
1883   uint256 public listIndex;
1884   uint256 public openIndex;
1885 
1886   bool public paused = true;
1887   bool public allowListMintEnabled = true;
1888   bool public waitListMintEnabled = false;
1889   bool public honoraryListMintEnabled = true;
1890   bool public openSaleEnabled = false;
1891   bool public claimingEnabled = false;
1892   constructor(
1893     address _genesisContract
1894   ) ERC721A("BYORD", "BYORD") {
1895     rdc=RDIERC721(_genesisContract);
1896   }
1897 
1898   modifier mintCompliance(uint256 _mintAmount) {
1899     require(_mintAmount > 0 && _mintAmount < maxMintAmountPerTx, 'Invalid mint amount!');
1900     require(totalSupply() + _mintAmount < maxSupply, 'Max supply exceeded!');
1901     _;
1902   }
1903 
1904   modifier mintPriceCompliance(uint256 _mintAmount) {
1905     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1906     _;
1907   }
1908 
1909 
1910 
1911   function merkleMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1912     require(!paused, 'The contract is paused!');
1913     require(allowListMintEnabled||waitListMintEnabled, 'The sale is not enabled!');
1914     // Verify whitelist requirements
1915 
1916     require(listIndex + _mintAmount < maxListSupply, 'Max supply exceeded!');
1917 
1918     uint256 alreadyMintedPlusMintAmount=mintedForAddress[_msgSender()]+_mintAmount;
1919     require(alreadyMintedPlusMintAmount<maxMintAmountPerAddress,'Max Amount per Address exceeded!!');
1920     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1921     bytes32 root=allowListMintEnabled?merkleRoot:waitListMerkleRoot;
1922     require(MerkleProof.verify(_merkleProof, root, leaf), 'Invalid proof!');
1923 
1924     mintedForAddress[_msgSender()]=alreadyMintedPlusMintAmount;
1925     listIndex= listIndex+_mintAmount;
1926     _safeMint(_msgSender(), _mintAmount);
1927   }
1928 
1929 
1930 
1931   function honoraryMint(uint256 _mintAmount, bytes calldata signature, uint256 maxAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1932     require(!paused, 'The contract is paused!');
1933     require(honoraryListMintEnabled, 'The honoraries sale is not enabled!');
1934 
1935     require(honoraryIndex+_mintAmount<maxHonorarySupply,'Max Honoraries reserved supply exceeded!');
1936     require(verifyQuant(_msgSender(), maxAmount, signature), 'Parameters not valid');
1937     uint256 minted=honoraryAddressMinted[_msgSender()];
1938     uint256 mintedPlusAmount=minted+_mintAmount;
1939     require(mintedPlusAmount<maxAmount,'max Amount For Honoraries exceeded');
1940     honoraryAddressMinted[_msgSender()]=mintedPlusAmount;
1941     honoraryIndex+=_mintAmount;
1942     _safeMint(_msgSender(), _mintAmount);
1943   }
1944 
1945 
1946   function claim(uint256[] calldata ownedGenesis) public {
1947     require(!paused, 'The contract is paused!');
1948 
1949     require(claimingEnabled, 'The claiming is not enabled!');
1950     uint ownedLength=ownedGenesis.length;
1951     require(ownedLength>0, 'No genesis tokens owned!');
1952     for (uint i = 0; i < ownedLength; i++) {
1953       uint256 tokenId=ownedGenesis[i];
1954       require(rdc.ownerOf(tokenId)==_msgSender(),'Not owned Token');
1955       require(genesisClaimed[tokenId]!=true,'Some tokens are already claimed');
1956       genesisClaimed[tokenId]=true;
1957     }
1958 
1959     require(claimedIndex + ownedLength < maxClaimingSupply, 'Max claiming supply exceeded!');
1960     claimedIndex= claimedIndex+ownedLength;
1961     _safeMint(_msgSender(), ownedLength);
1962   }
1963 
1964   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1965     require(!paused, 'The contract is paused!');
1966     require(openSaleEnabled, 'The open sale is not enabled!');
1967     //max for buy is 3000, 2800 are initially reserved for lists, 200 for honoraries.
1968     //whatever remain from list sales and honoraries become available for public
1969     uint256 maxOpenSupply=((2800-listIndex)+ (200-honoraryIndex))+1;
1970     require( openIndex+ _mintAmount < maxOpenSupply, 'Max opensale available supply exceeded!');
1971 
1972     uint256 alreadyMintedPlusMintAmount=mintedForAddress[_msgSender()]+_mintAmount;
1973     require(alreadyMintedPlusMintAmount<maxMintAmountPerAddress,'Max Amount per Address exceeded!!');
1974     mintedForAddress[_msgSender()]=alreadyMintedPlusMintAmount;
1975     openIndex= openIndex+_mintAmount;
1976     _safeMint(_msgSender(), _mintAmount);
1977   }
1978   
1979   function unclaimedToOwner() public onlyOwner {
1980       uint256 unclaimed=(maxClaimingSupply-1)-claimedIndex;
1981       if(unclaimed>0){
1982           claimedIndex=claimedIndex+unclaimed;
1983         _safeMint(_msgSender(), unclaimed);
1984       }
1985   }
1986 
1987   function _startTokenId() internal view virtual override returns (uint256) {
1988     return 1;
1989   }
1990 
1991   function isTokenAlreadyClaimed(uint tokenId) public view returns(bool){
1992     return genesisClaimed[tokenId];
1993   }
1994   
1995   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1996     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1997 
1998     string memory currentBaseURI = _baseURI();
1999     return bytes(currentBaseURI).length > 0
2000         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2001         : '';
2002   }
2003 
2004   function setCost(uint256 _cost) public onlyOwner {
2005     cost = _cost;
2006   }
2007 
2008   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2009     maxMintAmountPerTx = _maxMintAmountPerTx;
2010   }
2011 
2012   function setMaxMintAmountPerAddress(uint256 _maxMintAmountPerAddress) public onlyOwner {
2013     maxMintAmountPerAddress = _maxMintAmountPerAddress;
2014   }
2015 
2016 
2017   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2018     uriPrefix = _uriPrefix;
2019   }
2020 
2021   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2022     uriSuffix = _uriSuffix;
2023   }
2024 
2025   function setPaused(bool _state) public onlyOwner {
2026     paused = _state;
2027   }
2028 
2029   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2030     merkleRoot = _merkleRoot;
2031   }
2032 
2033   function setHonorariesMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2034     honorariesMerkleRoot = _merkleRoot;
2035   }
2036 
2037   function setWaitListMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2038     waitListMerkleRoot = _merkleRoot;
2039   }
2040 
2041   function setAllowListMintEnabled(bool _state) public onlyOwner {
2042     allowListMintEnabled = _state;
2043   }
2044 
2045   function setWaitListMintEnabled(bool _state) public onlyOwner {
2046     waitListMintEnabled = _state;
2047   }
2048   function setHonoraryListMintEnabled(bool _state) public onlyOwner {
2049     honoraryListMintEnabled = _state;
2050   }
2051   //
2052   function setOpenSaleMintEnabled(bool _state) public onlyOwner {
2053     openSaleEnabled = _state;
2054   }
2055 
2056   function setClaimingEnabled(bool _state) public onlyOwner {
2057     claimingEnabled = _state;
2058   }
2059 
2060   function setRdc(address _genesisContract) public onlyOwner {
2061     rdc=RDIERC721(_genesisContract);
2062   }
2063 
2064   function setSigner(address _newSigner) public onlyOwner {
2065     _signer=_newSigner;
2066   }
2067 
2068   function withdraw() public onlyOwner nonReentrant {
2069 
2070 
2071     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2072     require(os);
2073 
2074   }
2075 
2076   function _baseURI() internal view virtual override returns (string memory) {
2077     return uriPrefix;
2078   }
2079 //-------------------------- Signature verification --------------------------------------//
2080     function getMessageHashQuant(
2081         address _to,
2082         uint _amount
2083     ) public pure returns (bytes32) {
2084         return keccak256(abi.encodePacked(_to, _amount));
2085     }
2086 
2087 
2088 
2089     function getEthSignedMessageHash(bytes32 _messageHash)
2090         public
2091         pure
2092         returns (bytes32)
2093     {
2094 
2095         return
2096             keccak256(
2097                 abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
2098             );
2099     }
2100 
2101 
2102     function verifyQuant(
2103         address _to,
2104         uint _amount,
2105         bytes memory signature
2106     ) public view returns (bool) {
2107         bytes32 messageHash = getMessageHashQuant(_to, _amount);
2108         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
2109 
2110         return recoverSigner(ethSignedMessageHash, signature) == _signer;
2111     }
2112 
2113     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
2114         public
2115         pure
2116         returns (address)
2117     {
2118         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
2119 
2120         return ecrecover(_ethSignedMessageHash, v, r, s);
2121     }
2122 
2123     function splitSignature(bytes memory sig)
2124         public
2125         pure
2126         returns (
2127             bytes32 r,
2128             bytes32 s,
2129             uint8 v
2130         )
2131     {
2132         require(sig.length == 65, "invalid signature length");
2133 
2134         assembly {
2135 
2136             r := mload(add(sig, 32))
2137             s := mload(add(sig, 64))
2138             v := byte(0, mload(add(sig, 96)))
2139         }
2140 
2141     }
2142 
2143 }