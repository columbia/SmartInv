1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
8 /**
9 Where am i?.......                                   
10                                                                            
11 */
12 
13 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Contract module that helps prevent reentrant calls to a function.
19  *
20  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
21  * available, which can be applied to functions to make sure there are no nested
22  * (reentrant) calls to them.
23  *
24  * Note that because there is a single `nonReentrant` guard, functions marked as
25  * `nonReentrant` may not call one another. This can be worked around by making
26  * those functions `private`, and then adding `external` `nonReentrant` entry
27  * points to them.
28  *
29  * TIP: If you would like to learn more about reentrancy and alternative ways
30  * to protect against it, check out our blog post
31  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
32  */
33 abstract contract ReentrancyGuard {
34     // Booleans are more expensive than uint256 or any type that takes up a full
35     // word because each write operation emits an extra SLOAD to first read the
36     // slot's contents, replace the bits taken up by the boolean, and then write
37     // back. This is the compiler's defense against contract upgrades and
38     // pointer aliasing, and it cannot be disabled.
39 
40     // The values being non-zero value makes deployment a bit more expensive,
41     // but in exchange the refund on every call to nonReentrant will be lower in
42     // amount. Since refunds are capped to a percentage of the total
43     // transaction's gas, it is best to keep them low in cases like this one, to
44     // increase the likelihood of the full refund coming into effect.
45     uint256 private constant _NOT_ENTERED = 1;
46     uint256 private constant _ENTERED = 2;
47 
48     uint256 private _status;
49 
50     constructor() {
51         _status = _NOT_ENTERED;
52     }
53 
54     /**
55      * @dev Prevents a contract from calling itself, directly or indirectly.
56      * Calling a `nonReentrant` function from another `nonReentrant`
57      * function is not supported. It is possible to prevent this from happening
58      * by making the `nonReentrant` function external, and making it call a
59      * `private` function that does the actual work.
60      */
61     modifier nonReentrant() {
62         // On the first call to nonReentrant, _notEntered will be true
63         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
64 
65         // Any calls to nonReentrant after this point will fail
66         _status = _ENTERED;
67 
68         _;
69 
70         // By storing the original value once again, a refund is triggered (see
71         // https://eips.ethereum.org/EIPS/eip-2200)
72         _status = _NOT_ENTERED;
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Strings.sol
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev String operations.
84  */
85 library Strings {
86     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
90      */
91     function toString(uint256 value) internal pure returns (string memory) {
92         // Inspired by OraclizeAPI's implementation - MIT licence
93         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
115      */
116     function toHexString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0x00";
119         }
120         uint256 temp = value;
121         uint256 length = 0;
122         while (temp != 0) {
123             length++;
124             temp >>= 8;
125         }
126         return toHexString(value, length);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
131      */
132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
133         bytes memory buffer = new bytes(2 * length + 2);
134         buffer[0] = "0";
135         buffer[1] = "x";
136         for (uint256 i = 2 * length + 1; i > 1; --i) {
137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
138             value >>= 4;
139         }
140         require(value == 0, "Strings: hex length insufficient");
141         return string(buffer);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Address.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
176 
177 pragma solidity ^0.8.1;
178 
179 /**
180  * @dev Collection of functions related to the address type
181  */
182 library Address {
183     /**
184      * @dev Returns true if `account` is a contract.
185      *
186      * [IMPORTANT]
187      * ====
188      * It is unsafe to assume that an address for which this function returns
189      * false is an externally-owned account (EOA) and not a contract.
190      *
191      * Among others, `isContract` will return false for the following
192      * types of addresses:
193      *
194      *  - an externally-owned account
195      *  - a contract in construction
196      *  - an address where a contract will be created
197      *  - an address where a contract lived, but was destroyed
198      * ====
199      *
200      * [IMPORTANT]
201      * ====
202      * You shouldn't rely on `isContract` to protect against flash loan attacks!
203      *
204      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
205      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
206      * constructor.
207      * ====
208      */
209     function isContract(address account) internal view returns (bool) {
210         // This method relies on extcodesize/address.code.length, which returns 0
211         // for contracts in construction, since the code is only stored at the end
212         // of the constructor execution.
213 
214         return account.code.length > 0;
215     }
216 
217     /**
218      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
219      * `recipient`, forwarding all available gas and reverting on errors.
220      *
221      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
222      * of certain opcodes, possibly making contracts go over the 2300 gas limit
223      * imposed by `transfer`, making them unable to receive funds via
224      * `transfer`. {sendValue} removes this limitation.
225      *
226      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
227      *
228      * IMPORTANT: because control is transferred to `recipient`, care must be
229      * taken to not create reentrancy vulnerabilities. Consider using
230      * {ReentrancyGuard} or the
231      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
232      */
233     function sendValue(address payable recipient, uint256 amount) internal {
234         require(address(this).balance >= amount, "Address: insufficient balance");
235 
236         (bool success, ) = recipient.call{value: amount}("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240     /**
241      * @dev Performs a Solidity function call using a low level `call`. A
242      * plain `call` is an unsafe replacement for a function call: use this
243      * function instead.
244      *
245      * If `target` reverts with a revert reason, it is bubbled up by this
246      * function (like regular Solidity function calls).
247      *
248      * Returns the raw returned data. To convert to the expected return value,
249      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
250      *
251      * Requirements:
252      *
253      * - `target` must be a contract.
254      * - calling `target` with `data` must not revert.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionCall(target, data, "Address: low-level call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
264      * `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, 0, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but also transferring `value` wei to `target`.
279      *
280      * Requirements:
281      *
282      * - the calling contract must have an ETH balance of at least `value`.
283      * - the called Solidity function must be `payable`.
284      *
285      * _Available since v3.1._
286      */
287     function functionCallWithValue(
288         address target,
289         bytes memory data,
290         uint256 value
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
297      * with `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(address(this).balance >= value, "Address: insufficient balance for call");
308         require(isContract(target), "Address: call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.call{value: value}(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
321         return functionStaticCall(target, data, "Address: low-level static call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal view returns (bytes memory) {
335         require(isContract(target), "Address: static call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.staticcall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(isContract(target), "Address: delegate call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.delegatecall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
370      * revert reason using the provided one.
371      *
372      * _Available since v4.3._
373      */
374     function verifyCallResult(
375         bool success,
376         bytes memory returndata,
377         string memory errorMessage
378     ) internal pure returns (bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @title ERC721 token receiver interface
406  * @dev Interface for any contract that wants to support safeTransfers
407  * from ERC721 asset contracts.
408  */
409 interface IERC721Receiver {
410     /**
411      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
412      * by `operator` from `from`, this function is called.
413      *
414      * It must return its Solidity selector to confirm the token transfer.
415      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
416      *
417      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
418      */
419     function onERC721Received(
420         address operator,
421         address from,
422         uint256 tokenId,
423         bytes calldata data
424     ) external returns (bytes4);
425 }
426 
427 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
428 
429 
430 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @dev Interface of the ERC165 standard, as defined in the
436  * https://eips.ethereum.org/EIPS/eip-165[EIP].
437  *
438  * Implementers can declare support of contract interfaces, which can then be
439  * queried by others ({ERC165Checker}).
440  *
441  * For an implementation, see {ERC165}.
442  */
443 interface IERC165 {
444     /**
445      * @dev Returns true if this contract implements the interface defined by
446      * `interfaceId`. See the corresponding
447      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
448      * to learn more about how these ids are created.
449      *
450      * This function call must use less than 30 000 gas.
451      */
452     function supportsInterface(bytes4 interfaceId) external view returns (bool);
453 }
454 
455 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 
463 /**
464  * @dev Implementation of the {IERC165} interface.
465  *
466  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
467  * for the additional interface id that will be supported. For example:
468  *
469  * ```solidity
470  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
472  * }
473  * ```
474  *
475  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
476  */
477 abstract contract ERC165 is IERC165 {
478     /**
479      * @dev See {IERC165-supportsInterface}.
480      */
481     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482         return interfaceId == type(IERC165).interfaceId;
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @dev Required interface of an ERC721 compliant contract.
496  */
497 interface IERC721 is IERC165 {
498     /**
499      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
500      */
501     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
502 
503     /**
504      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
505      */
506     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
510      */
511     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
512 
513     /**
514      * @dev Returns the number of tokens in ``owner``'s account.
515      */
516     function balanceOf(address owner) external view returns (uint256 balance);
517 
518     /**
519      * @dev Returns the owner of the `tokenId` token.
520      *
521      * Requirements:
522      *
523      * - `tokenId` must exist.
524      */
525     function ownerOf(uint256 tokenId) external view returns (address owner);
526 
527     /**
528      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
529      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external;
546 
547     /**
548      * @dev Transfers `tokenId` token from `from` to `to`.
549      *
550      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external;
566 
567     /**
568      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
569      * The approval is cleared when the token is transferred.
570      *
571      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
572      *
573      * Requirements:
574      *
575      * - The caller must own the token or be an approved operator.
576      * - `tokenId` must exist.
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address to, uint256 tokenId) external;
581 
582     /**
583      * @dev Returns the account approved for `tokenId` token.
584      *
585      * Requirements:
586      *
587      * - `tokenId` must exist.
588      */
589     function getApproved(uint256 tokenId) external view returns (address operator);
590 
591     /**
592      * @dev Approve or remove `operator` as an operator for the caller.
593      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
594      *
595      * Requirements:
596      *
597      * - The `operator` cannot be the caller.
598      *
599      * Emits an {ApprovalForAll} event.
600      */
601     function setApprovalForAll(address operator, bool _approved) external;
602 
603     /**
604      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
605      *
606      * See {setApprovalForAll}
607      */
608     function isApprovedForAll(address owner, address operator) external view returns (bool);
609 
610     /**
611      * @dev Safely transfers `tokenId` token from `from` to `to`.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId,
627         bytes calldata data
628     ) external;
629 }
630 
631 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
641  * @dev See https://eips.ethereum.org/EIPS/eip-721
642  */
643 interface IERC721Metadata is IERC721 {
644     /**
645      * @dev Returns the token collection name.
646      */
647     function name() external view returns (string memory);
648 
649     /**
650      * @dev Returns the token collection symbol.
651      */
652     function symbol() external view returns (string memory);
653 
654     /**
655      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
656      */
657     function tokenURI(uint256 tokenId) external view returns (string memory);
658 }
659 
660 // File: contracts/new.sol
661 
662 
663 
664 
665 pragma solidity ^0.8.4;
666 
667 
668 
669 
670 
671 
672 
673 
674 error ApprovalCallerNotOwnerNorApproved();
675 error ApprovalQueryForNonexistentToken();
676 error ApproveToCaller();
677 error ApprovalToCurrentOwner();
678 error BalanceQueryForZeroAddress();
679 error MintToZeroAddress();
680 error MintZeroQuantity();
681 error OwnerQueryForNonexistentToken();
682 error TransferCallerNotOwnerNorApproved();
683 error TransferFromIncorrectOwner();
684 error TransferToNonERC721ReceiverImplementer();
685 error TransferToZeroAddress();
686 error URIQueryForNonexistentToken();
687 
688 /**
689  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
690  * the Metadata extension. Built to optimize for lower gas during batch mints.
691  *
692  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
693  *
694  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
695  *
696  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
697  */
698 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
699     using Address for address;
700     using Strings for uint256;
701 
702     // Compiler will pack this into a single 256bit word.
703     struct TokenOwnership {
704         // The address of the owner.
705         address addr;
706         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
707         uint64 startTimestamp;
708         // Whether the token has been burned.
709         bool burned;
710     }
711 
712     // Compiler will pack this into a single 256bit word.
713     struct AddressData {
714         // Realistically, 2**64-1 is more than enough.
715         uint64 balance;
716         // Keeps track of mint count with minimal overhead for tokenomics.
717         uint64 numberMinted;
718         // Keeps track of burn count with minimal overhead for tokenomics.
719         uint64 numberBurned;
720         // For miscellaneous variable(s) pertaining to the address
721         // (e.g. number of whitelist mint slots used).
722         // If there are multiple variables, please pack them into a uint64.
723         uint64 aux;
724     }
725 
726     // The tokenId of the next token to be minted.
727     uint256 internal _currentIndex;
728 
729     // The number of tokens burned.
730     uint256 internal _burnCounter;
731 
732     // Token name
733     string private _name;
734 
735     // Token symbol
736     string private _symbol;
737 
738     // Mapping from token ID to ownership details
739     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
740     mapping(uint256 => TokenOwnership) internal _ownerships;
741 
742     // Mapping owner address to address data
743     mapping(address => AddressData) private _addressData;
744 
745     // Mapping from token ID to approved address
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     // Mapping from owner to operator approvals
749     mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751     constructor(string memory name_, string memory symbol_) {
752         _name = name_;
753         _symbol = symbol_;
754         _currentIndex = _startTokenId();
755     }
756 
757     /**
758      * To change the starting tokenId, please override this function.
759      */
760     function _startTokenId() internal view virtual returns (uint256) {
761         return 0;
762     }
763 
764     /**
765      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
766      */
767     function totalSupply() public view returns (uint256) {
768         // Counter underflow is impossible as _burnCounter cannot be incremented
769         // more than _currentIndex - _startTokenId() times
770         unchecked {
771             return _currentIndex - _burnCounter - _startTokenId();
772         }
773     }
774 
775     /**
776      * Returns the total amount of tokens minted in the contract.
777      */
778     function _totalMinted() internal view returns (uint256) {
779         // Counter underflow is impossible as _currentIndex does not decrement,
780         // and it is initialized to _startTokenId()
781         unchecked {
782             return _currentIndex - _startTokenId();
783         }
784     }
785 
786     /**
787      * @dev See {IERC165-supportsInterface}.
788      */
789     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
790         return
791             interfaceId == type(IERC721).interfaceId ||
792             interfaceId == type(IERC721Metadata).interfaceId ||
793             super.supportsInterface(interfaceId);
794     }
795 
796     /**
797      * @dev See {IERC721-balanceOf}.
798      */
799     function balanceOf(address owner) public view override returns (uint256) {
800         if (owner == address(0)) revert BalanceQueryForZeroAddress();
801         return uint256(_addressData[owner].balance);
802     }
803 
804     /**
805      * Returns the number of tokens minted by `owner`.
806      */
807     function _numberMinted(address owner) internal view returns (uint256) {
808         return uint256(_addressData[owner].numberMinted);
809     }
810 
811     /**
812      * Returns the number of tokens burned by or on behalf of `owner`.
813      */
814     function _numberBurned(address owner) internal view returns (uint256) {
815         return uint256(_addressData[owner].numberBurned);
816     }
817 
818     /**
819      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
820      */
821     function _getAux(address owner) internal view returns (uint64) {
822         return _addressData[owner].aux;
823     }
824 
825     /**
826      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
827      * If there are multiple variables, please pack them into a uint64.
828      */
829     function _setAux(address owner, uint64 aux) internal {
830         _addressData[owner].aux = aux;
831     }
832 
833     /**
834      * Gas spent here starts off proportional to the maximum mint batch size.
835      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
836      */
837     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
838         uint256 curr = tokenId;
839 
840         unchecked {
841             if (_startTokenId() <= curr && curr < _currentIndex) {
842                 TokenOwnership memory ownership = _ownerships[curr];
843                 if (!ownership.burned) {
844                     if (ownership.addr != address(0)) {
845                         return ownership;
846                     }
847                     // Invariant:
848                     // There will always be an ownership that has an address and is not burned
849                     // before an ownership that does not have an address and is not burned.
850                     // Hence, curr will not underflow.
851                     while (true) {
852                         curr--;
853                         ownership = _ownerships[curr];
854                         if (ownership.addr != address(0)) {
855                             return ownership;
856                         }
857                     }
858                 }
859             }
860         }
861         revert OwnerQueryForNonexistentToken();
862     }
863 
864     /**
865      * @dev See {IERC721-ownerOf}.
866      */
867     function ownerOf(uint256 tokenId) public view override returns (address) {
868         return _ownershipOf(tokenId).addr;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-name}.
873      */
874     function name() public view virtual override returns (string memory) {
875         return _name;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-symbol}.
880      */
881     function symbol() public view virtual override returns (string memory) {
882         return _symbol;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-tokenURI}.
887      */
888     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
889         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
890 
891         string memory baseURI = _baseURI();
892         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
893     }
894 
895     /**
896      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
897      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
898      * by default, can be overriden in child contracts.
899      */
900     function _baseURI() internal view virtual returns (string memory) {
901         return '';
902     }
903 
904     /**
905      * @dev See {IERC721-approve}.
906      */
907     function approve(address to, uint256 tokenId) public override {
908         address owner = ERC721A.ownerOf(tokenId);
909         if (to == owner) revert ApprovalToCurrentOwner();
910 
911         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
912             revert ApprovalCallerNotOwnerNorApproved();
913         }
914 
915         _approve(to, tokenId, owner);
916     }
917 
918     /**
919      * @dev See {IERC721-getApproved}.
920      */
921     function getApproved(uint256 tokenId) public view override returns (address) {
922         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
923 
924         return _tokenApprovals[tokenId];
925     }
926 
927     /**
928      * @dev See {IERC721-setApprovalForAll}.
929      */
930     function setApprovalForAll(address operator, bool approved) public virtual override {
931         if (operator == _msgSender()) revert ApproveToCaller();
932 
933         _operatorApprovals[_msgSender()][operator] = approved;
934         emit ApprovalForAll(_msgSender(), operator, approved);
935     }
936 
937     /**
938      * @dev See {IERC721-isApprovedForAll}.
939      */
940     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
941         return _operatorApprovals[owner][operator];
942     }
943 
944     /**
945      * @dev See {IERC721-transferFrom}.
946      */
947     function transferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         _transfer(from, to, tokenId);
953     }
954 
955     /**
956      * @dev See {IERC721-safeTransferFrom}.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId
962     ) public virtual override {
963         safeTransferFrom(from, to, tokenId, '');
964     }
965 
966     /**
967      * @dev See {IERC721-safeTransferFrom}.
968      */
969     function safeTransferFrom(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) public virtual override {
975         _transfer(from, to, tokenId);
976         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
977             revert TransferToNonERC721ReceiverImplementer();
978         }
979     }
980 
981     /**
982      * @dev Returns whether `tokenId` exists.
983      *
984      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
985      *
986      * Tokens start existing when they are minted (`_mint`),
987      */
988     function _exists(uint256 tokenId) internal view returns (bool) {
989         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
990             !_ownerships[tokenId].burned;
991     }
992 
993     function _safeMint(address to, uint256 quantity) internal {
994         _safeMint(to, quantity, '');
995     }
996 
997     /**
998      * @dev Safely mints `quantity` tokens and transfers them to `to`.
999      *
1000      * Requirements:
1001      *
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1003      * - `quantity` must be greater than 0.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _safeMint(
1008         address to,
1009         uint256 quantity,
1010         bytes memory _data
1011     ) internal {
1012         _mint(to, quantity, _data, true);
1013     }
1014 
1015     /**
1016      * @dev Mints `quantity` tokens and transfers them to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `quantity` must be greater than 0.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _mint(
1026         address to,
1027         uint256 quantity,
1028         bytes memory _data,
1029         bool safe
1030     ) internal {
1031         uint256 startTokenId = _currentIndex;
1032         if (to == address(0)) revert MintToZeroAddress();
1033         if (quantity == 0) revert MintZeroQuantity();
1034 
1035         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1036 
1037         // Overflows are incredibly unrealistic.
1038         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1039         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1040         unchecked {
1041             _addressData[to].balance += uint64(quantity);
1042             _addressData[to].numberMinted += uint64(quantity);
1043 
1044             _ownerships[startTokenId].addr = to;
1045             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1046 
1047             uint256 updatedIndex = startTokenId;
1048             uint256 end = updatedIndex + quantity;
1049 
1050             if (safe && to.isContract()) {
1051                 do {
1052                     emit Transfer(address(0), to, updatedIndex);
1053                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1054                         revert TransferToNonERC721ReceiverImplementer();
1055                     }
1056                 } while (updatedIndex != end);
1057                 // Reentrancy protection
1058                 if (_currentIndex != startTokenId) revert();
1059             } else {
1060                 do {
1061                     emit Transfer(address(0), to, updatedIndex++);
1062                 } while (updatedIndex != end);
1063             }
1064             _currentIndex = updatedIndex;
1065         }
1066         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1067     }
1068 
1069     /**
1070      * @dev Transfers `tokenId` from `from` to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must be owned by `from`.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _transfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) private {
1084         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1085 
1086         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1087 
1088         bool isApprovedOrOwner = (_msgSender() == from ||
1089             isApprovedForAll(from, _msgSender()) ||
1090             getApproved(tokenId) == _msgSender());
1091 
1092         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1093         if (to == address(0)) revert TransferToZeroAddress();
1094 
1095         _beforeTokenTransfers(from, to, tokenId, 1);
1096 
1097         // Clear approvals from the previous owner
1098         _approve(address(0), tokenId, from);
1099 
1100         // Underflow of the sender's balance is impossible because we check for
1101         // ownership above and the recipient's balance can't realistically overflow.
1102         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1103         unchecked {
1104             _addressData[from].balance -= 1;
1105             _addressData[to].balance += 1;
1106 
1107             TokenOwnership storage currSlot = _ownerships[tokenId];
1108             currSlot.addr = to;
1109             currSlot.startTimestamp = uint64(block.timestamp);
1110 
1111             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1112             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1113             uint256 nextTokenId = tokenId + 1;
1114             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1115             if (nextSlot.addr == address(0)) {
1116                 // This will suffice for checking _exists(nextTokenId),
1117                 // as a burned slot cannot contain the zero address.
1118                 if (nextTokenId != _currentIndex) {
1119                     nextSlot.addr = from;
1120                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1121                 }
1122             }
1123         }
1124 
1125         emit Transfer(from, to, tokenId);
1126         _afterTokenTransfers(from, to, tokenId, 1);
1127     }
1128 
1129     /**
1130      * @dev This is equivalent to _burn(tokenId, false)
1131      */
1132     function _burn(uint256 tokenId) internal virtual {
1133         _burn(tokenId, false);
1134     }
1135 
1136     /**
1137      * @dev Destroys `tokenId`.
1138      * The approval is cleared when the token is burned.
1139      *
1140      * Requirements:
1141      *
1142      * - `tokenId` must exist.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1147         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1148 
1149         address from = prevOwnership.addr;
1150 
1151         if (approvalCheck) {
1152             bool isApprovedOrOwner = (_msgSender() == from ||
1153                 isApprovedForAll(from, _msgSender()) ||
1154                 getApproved(tokenId) == _msgSender());
1155 
1156             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1157         }
1158 
1159         _beforeTokenTransfers(from, address(0), tokenId, 1);
1160 
1161         // Clear approvals from the previous owner
1162         _approve(address(0), tokenId, from);
1163 
1164         // Underflow of the sender's balance is impossible because we check for
1165         // ownership above and the recipient's balance can't realistically overflow.
1166         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1167         unchecked {
1168             AddressData storage addressData = _addressData[from];
1169             addressData.balance -= 1;
1170             addressData.numberBurned += 1;
1171 
1172             // Keep track of who burned the token, and the timestamp of burning.
1173             TokenOwnership storage currSlot = _ownerships[tokenId];
1174             currSlot.addr = from;
1175             currSlot.startTimestamp = uint64(block.timestamp);
1176             currSlot.burned = true;
1177 
1178             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1179             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1180             uint256 nextTokenId = tokenId + 1;
1181             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1182             if (nextSlot.addr == address(0)) {
1183                 // This will suffice for checking _exists(nextTokenId),
1184                 // as a burned slot cannot contain the zero address.
1185                 if (nextTokenId != _currentIndex) {
1186                     nextSlot.addr = from;
1187                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1188                 }
1189             }
1190         }
1191 
1192         emit Transfer(from, address(0), tokenId);
1193         _afterTokenTransfers(from, address(0), tokenId, 1);
1194 
1195         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1196         unchecked {
1197             _burnCounter++;
1198         }
1199     }
1200 
1201     /**
1202      * @dev Approve `to` to operate on `tokenId`
1203      *
1204      * Emits a {Approval} event.
1205      */
1206     function _approve(
1207         address to,
1208         uint256 tokenId,
1209         address owner
1210     ) private {
1211         _tokenApprovals[tokenId] = to;
1212         emit Approval(owner, to, tokenId);
1213     }
1214 
1215     /**
1216      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1217      *
1218      * @param from address representing the previous owner of the given token ID
1219      * @param to target address that will receive the tokens
1220      * @param tokenId uint256 ID of the token to be transferred
1221      * @param _data bytes optional data to send along with the call
1222      * @return bool whether the call correctly returned the expected magic value
1223      */
1224     function _checkContractOnERC721Received(
1225         address from,
1226         address to,
1227         uint256 tokenId,
1228         bytes memory _data
1229     ) private returns (bool) {
1230         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1231             return retval == IERC721Receiver(to).onERC721Received.selector;
1232         } catch (bytes memory reason) {
1233             if (reason.length == 0) {
1234                 revert TransferToNonERC721ReceiverImplementer();
1235             } else {
1236                 assembly {
1237                     revert(add(32, reason), mload(reason))
1238                 }
1239             }
1240         }
1241     }
1242 
1243     /**
1244      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1245      * And also called before burning one token.
1246      *
1247      * startTokenId - the first token id to be transferred
1248      * quantity - the amount to be transferred
1249      *
1250      * Calling conditions:
1251      *
1252      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1253      * transferred to `to`.
1254      * - When `from` is zero, `tokenId` will be minted for `to`.
1255      * - When `to` is zero, `tokenId` will be burned by `from`.
1256      * - `from` and `to` are never both zero.
1257      */
1258     function _beforeTokenTransfers(
1259         address from,
1260         address to,
1261         uint256 startTokenId,
1262         uint256 quantity
1263     ) internal virtual {}
1264 
1265     /**
1266      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1267      * minting.
1268      * And also called after one token has been burned.
1269      *
1270      * startTokenId - the first token id to be transferred
1271      * quantity - the amount to be transferred
1272      *
1273      * Calling conditions:
1274      *
1275      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1276      * transferred to `to`.
1277      * - When `from` is zero, `tokenId` has been minted for `to`.
1278      * - When `to` is zero, `tokenId` has been burned by `from`.
1279      * - `from` and `to` are never both zero.
1280      */
1281     function _afterTokenTransfers(
1282         address from,
1283         address to,
1284         uint256 startTokenId,
1285         uint256 quantity
1286     ) internal virtual {}
1287 }
1288 
1289 abstract contract Ownable is Context {
1290     address private _owner;
1291 
1292     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1293 
1294     /**
1295      * @dev Initializes the contract setting the deployer as the initial owner.
1296      */
1297     constructor() {
1298         _transferOwnership(_msgSender());
1299     }
1300 
1301     /**
1302      * @dev Returns the address of the current owner.
1303      */
1304     function owner() public view virtual returns (address) {
1305         return _owner;
1306     }
1307 
1308     /**
1309      * @dev Throws if called by any account other than the owner.
1310      */
1311     modifier onlyOwner() {
1312         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1313         _;
1314     }
1315 
1316     /**
1317      * @dev Leaves the contract without owner. It will not be possible to call
1318      * `onlyOwner` functions anymore. Can only be called by the current owner.
1319      *
1320      * NOTE: Renouncing ownership will leave the contract without an owner,
1321      * thereby removing any functionality that is only available to the owner.
1322      */
1323     function renounceOwnership() public virtual onlyOwner {
1324         _transferOwnership(address(0));
1325     }
1326 
1327     /**
1328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1329      * Can only be called by the current owner.
1330      */
1331     function transferOwnership(address newOwner) public virtual onlyOwner {
1332         require(newOwner != address(0), "Ownable: new owner is the zero address");
1333         _transferOwnership(newOwner);
1334     }
1335 
1336     /**
1337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1338      * Internal function without access restriction.
1339      */
1340     function _transferOwnership(address newOwner) internal virtual {
1341         address oldOwner = _owner;
1342         _owner = newOwner;
1343         emit OwnershipTransferred(oldOwner, newOwner);
1344     }
1345 }
1346     pragma solidity ^0.8.7;
1347     
1348     contract PepePunkYC is ERC721A, Ownable, ReentrancyGuard {
1349     using Strings for uint256;
1350 
1351 
1352   string private uriPrefix ;
1353   string private uriSuffix = ".json";
1354   string public hiddenURL;
1355 
1356   
1357   
1358 
1359   uint256 public cost = 0.00099 ether;
1360   uint256 public whiteListCost = 0.00099 ether ;
1361   
1362 
1363   uint16 public maxSupply = 4999;
1364   uint8 public maxMintAmountPerTx = 20;
1365     uint8 public maxFreeMintAmountPerWallet = 1;
1366     uint256 public freeNFTAlreadyMinted = 0;
1367      uint256 public  NUM_FREE_MINTS = 4899;
1368                                                              
1369   bool public WLpaused = false;
1370   bool public paused = true;
1371   bool public reveal =true;
1372   mapping (address => uint8) public NFTPerWLAddress;
1373    mapping (address => uint8) public NFTPerPublicAddress;
1374   mapping (address => bool) public isWhitelisted;
1375  
1376   
1377   
1378  
1379   
1380 
1381     constructor(
1382     string memory _tokenName,
1383     string memory _tokenSymbol,
1384     string memory _hiddenMetadataUri
1385   ) ERC721A(_tokenName, _tokenSymbol) {
1386     
1387   }
1388 
1389   
1390  
1391  
1392   function mint(uint256 _mintAmount)
1393       external
1394       payable
1395   {
1396     require(!paused, "The contract is paused!");
1397     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1398 
1399     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1400         require(
1401             (cost * _mintAmount) <= msg.value,
1402             "Incorrect ETH value sent"
1403         );
1404     }
1405      else {
1406         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1407         require(
1408             (cost * _mintAmount) <= msg.value,
1409             "Incorrect ETH value sent"
1410         );
1411         require(
1412             _mintAmount <= maxMintAmountPerTx,
1413             "Max mints per transaction exceeded"
1414         );
1415         } else {
1416             require(
1417                 _mintAmount <= maxFreeMintAmountPerWallet,
1418                 "Max mints per transaction exceeded"
1419             );
1420             freeNFTAlreadyMinted += _mintAmount;
1421         }
1422     }
1423     _safeMint(msg.sender, _mintAmount);
1424   }
1425 
1426   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1427      uint16 totalSupply = uint16(totalSupply());
1428     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1429      _safeMint(_receiver , _mintAmount);
1430      delete _mintAmount;
1431      delete _receiver;
1432      delete totalSupply;
1433   }
1434 
1435   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1436      uint16 totalSupply = uint16(totalSupply());
1437      uint totalAmount =   _amountPerAddress * addresses.length;
1438     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1439      for (uint256 i = 0; i < addresses.length; i++) {
1440             _safeMint(addresses[i], _amountPerAddress);
1441         }
1442 
1443      delete _amountPerAddress;
1444      delete totalSupply;
1445   }
1446 
1447  
1448 
1449   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1450       maxSupply = _maxSupply;
1451   }
1452 
1453 
1454 
1455    
1456   function tokenURI(uint256 _tokenId)
1457     public
1458     view
1459     virtual
1460     override
1461     returns (string memory)
1462   {
1463     require(
1464       _exists(_tokenId),
1465       "ERC721Metadata: URI query for nonexistent token"
1466     );
1467     
1468   
1469 if ( reveal == false)
1470 {
1471     return hiddenURL;
1472 }
1473     
1474 
1475     string memory currentBaseURI = _baseURI();
1476     return bytes(currentBaseURI).length > 0
1477         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1478         : "";
1479   }
1480  
1481    function setWLPaused() external onlyOwner {
1482     WLpaused = !WLpaused;
1483   }
1484   function setWLCost(uint256 _cost) external onlyOwner {
1485     whiteListCost = _cost;
1486     delete _cost;
1487   }
1488 
1489 
1490 
1491  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1492     maxFreeMintAmountPerWallet = _limit;
1493    delete _limit;
1494 
1495 }
1496 
1497     
1498   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1499         for(uint8 i = 0; i < entries.length; i++) {
1500             isWhitelisted[entries[i]] = true;
1501         }   
1502     }
1503 
1504     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1505         for(uint8 i = 0; i < entries.length; i++) {
1506              isWhitelisted[entries[i]] = false;
1507         }
1508     }
1509 
1510 
1511 
1512     function whitelistMint(uint256 _mintAmount)
1513       external
1514       payable
1515   {
1516     require(!WLpaused, "Whitelist minting is over!");
1517      require(isWhitelisted[msg.sender],  "You are not whitelisted");
1518 
1519     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1520 
1521     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1522         require(
1523             (whiteListCost * _mintAmount) <= msg.value,
1524             "Incorrect ETH value sent"
1525         );
1526     }
1527      else {
1528         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1529         require(
1530             (whiteListCost * _mintAmount) <= msg.value,
1531             "Incorrect ETH value sent"
1532         );
1533         require(
1534             _mintAmount <= maxMintAmountPerTx,
1535             "Max mints per transaction exceeded"
1536         );
1537         } else {
1538             require(
1539                 _mintAmount <= maxFreeMintAmountPerWallet,
1540                 "Max mints per transaction exceeded"
1541             );
1542             freeNFTAlreadyMinted += _mintAmount;
1543         }
1544     }
1545     _safeMint(msg.sender, _mintAmount);
1546   }
1547 
1548   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1549     uriPrefix = _uriPrefix;
1550   }
1551    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1552     hiddenURL = _uriPrefix;
1553   }
1554 
1555 
1556   function setPaused() external onlyOwner {
1557     paused = !paused;
1558     WLpaused = true;
1559   }
1560 
1561   function setCost(uint _cost) external onlyOwner{
1562       cost = _cost;
1563 
1564   }
1565 
1566  function setRevealed() external onlyOwner{
1567      reveal = !reveal;
1568  }
1569 
1570   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1571       maxMintAmountPerTx = _maxtx;
1572 
1573   }
1574 
1575  
1576 
1577   function withdraw() public onlyOwner nonReentrant {
1578     // This will transfer the remaining contract balance to the owner.
1579     // Do not remove this otherwise you will not be able to withdraw the funds.
1580     // =============================================================================
1581     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1582     require(os);
1583     // =============================================================================
1584   }
1585 
1586 
1587   function _baseURI() internal view  override returns (string memory) {
1588     return uriPrefix;
1589   }
1590 }