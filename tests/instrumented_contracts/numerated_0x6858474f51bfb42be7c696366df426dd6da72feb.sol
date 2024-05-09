1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: contracts/2.sol
69 
70 
71 
72 pragma solidity >=0.8.6 <0.9.0;
73 
74 
75 
76 
77 // File: @openzeppelin/contracts/utils/Strings.sol
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev String operations.
85  */
86 library Strings {
87     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
91      */
92     function toString(uint256 value) internal pure returns (string memory) {
93         // Inspired by OraclizeAPI's implementation - MIT licence
94         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
95 
96         if (value == 0) {
97             return "0";
98         }
99         uint256 temp = value;
100         uint256 digits;
101         while (temp != 0) {
102             digits++;
103             temp /= 10;
104         }
105         bytes memory buffer = new bytes(digits);
106         while (value != 0) {
107             digits -= 1;
108             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
109             value /= 10;
110         }
111         return string(buffer);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
116      */
117     function toHexString(uint256 value) internal pure returns (string memory) {
118         if (value == 0) {
119             return "0x00";
120         }
121         uint256 temp = value;
122         uint256 length = 0;
123         while (temp != 0) {
124             length++;
125             temp >>= 8;
126         }
127         return toHexString(value, length);
128     }
129 
130     /**
131      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
132      */
133     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
134         bytes memory buffer = new bytes(2 * length + 2);
135         buffer[0] = "0";
136         buffer[1] = "x";
137         for (uint256 i = 2 * length + 1; i > 1; --i) {
138             buffer[i] = _HEX_SYMBOLS[value & 0xf];
139             value >>= 4;
140         }
141         require(value == 0, "Strings: hex length insufficient");
142         return string(buffer);
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/Context.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes calldata) {
169         return msg.data;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/utils/Address.sol
174 
175 
176 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
177 
178 pragma solidity ^0.8.1;
179 
180 /**
181  * @dev Collection of functions related to the address type
182  */
183 library Address {
184     /**
185      * @dev Returns true if `account` is a contract.
186      *
187      * [IMPORTANT]
188      * ====
189      * It is unsafe to assume that an address for which this function returns
190      * false is an externally-owned account (EOA) and not a contract.
191      *
192      * Among others, `isContract` will return false for the following
193      * types of addresses:
194      *
195      *  - an externally-owned account
196      *  - a contract in construction
197      *  - an address where a contract will be created
198      *  - an address where a contract lived, but was destroyed
199      * ====
200      *
201      * [IMPORTANT]
202      * ====
203      * You shouldn't rely on `isContract` to protect against flash loan attacks!
204      *
205      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
206      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
207      * constructor.
208      * ====
209      */
210     function isContract(address account) internal view returns (bool) {
211         // This method relies on extcodesize/address.code.length, which returns 0
212         // for contracts in construction, since the code is only stored at the end
213         // of the constructor execution.
214 
215         return account.code.length > 0;
216     }
217 
218     /**
219      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
220      * `recipient`, forwarding all available gas and reverting on errors.
221      *
222      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
223      * of certain opcodes, possibly making contracts go over the 2300 gas limit
224      * imposed by `transfer`, making them unable to receive funds via
225      * `transfer`. {sendValue} removes this limitation.
226      *
227      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
228      *
229      * IMPORTANT: because control is transferred to `recipient`, care must be
230      * taken to not create reentrancy vulnerabilities. Consider using
231      * {ReentrancyGuard} or the
232      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
233      */
234     function sendValue(address payable recipient, uint256 amount) internal {
235         require(address(this).balance >= amount, "Address: insufficient balance");
236 
237         (bool success, ) = recipient.call{value: amount}("");
238         require(success, "Address: unable to send value, recipient may have reverted");
239     }
240 
241     /**
242      * @dev Performs a Solidity function call using a low level `call`. A
243      * plain `call` is an unsafe replacement for a function call: use this
244      * function instead.
245      *
246      * If `target` reverts with a revert reason, it is bubbled up by this
247      * function (like regular Solidity function calls).
248      *
249      * Returns the raw returned data. To convert to the expected return value,
250      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
251      *
252      * Requirements:
253      *
254      * - `target` must be a contract.
255      * - calling `target` with `data` must not revert.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
260         return functionCall(target, data, "Address: low-level call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
265      * `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         return functionCallWithValue(target, data, 0, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but also transferring `value` wei to `target`.
280      *
281      * Requirements:
282      *
283      * - the calling contract must have an ETH balance of at least `value`.
284      * - the called Solidity function must be `payable`.
285      *
286      * _Available since v3.1._
287      */
288     function functionCallWithValue(
289         address target,
290         bytes memory data,
291         uint256 value
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
298      * with `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         require(address(this).balance >= value, "Address: insufficient balance for call");
309         require(isContract(target), "Address: call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.call{value: value}(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
322         return functionStaticCall(target, data, "Address: low-level static call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
327      * but performing a static call.
328      *
329      * _Available since v3.3._
330      */
331     function functionStaticCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal view returns (bytes memory) {
336         require(isContract(target), "Address: static call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.staticcall(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(isContract(target), "Address: delegate call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.delegatecall(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
371      * revert reason using the provided one.
372      *
373      * _Available since v4.3._
374      */
375     function verifyCallResult(
376         bool success,
377         bytes memory returndata,
378         string memory errorMessage
379     ) internal pure returns (bytes memory) {
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @title ERC721 token receiver interface
407  * @dev Interface for any contract that wants to support safeTransfers
408  * from ERC721 asset contracts.
409  */
410 interface IERC721Receiver {
411     /**
412      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
413      * by `operator` from `from`, this function is called.
414      *
415      * It must return its Solidity selector to confirm the token transfer.
416      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
417      *
418      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
419      */
420     function onERC721Received(
421         address operator,
422         address from,
423         uint256 tokenId,
424         bytes calldata data
425     ) external returns (bytes4);
426 }
427 
428 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Interface of the ERC165 standard, as defined in the
437  * https://eips.ethereum.org/EIPS/eip-165[EIP].
438  *
439  * Implementers can declare support of contract interfaces, which can then be
440  * queried by others ({ERC165Checker}).
441  *
442  * For an implementation, see {ERC165}.
443  */
444 interface IERC165 {
445     /**
446      * @dev Returns true if this contract implements the interface defined by
447      * `interfaceId`. See the corresponding
448      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
449      * to learn more about how these ids are created.
450      *
451      * This function call must use less than 30 000 gas.
452      */
453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
454 }
455 
456 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Implementation of the {IERC165} interface.
466  *
467  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
468  * for the additional interface id that will be supported. For example:
469  *
470  * ```solidity
471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
473  * }
474  * ```
475  *
476  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
477  */
478 abstract contract ERC165 is IERC165 {
479     /**
480      * @dev See {IERC165-supportsInterface}.
481      */
482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483         return interfaceId == type(IERC165).interfaceId;
484     }
485 }
486 
487 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @dev Required interface of an ERC721 compliant contract.
497  */
498 interface IERC721 is IERC165 {
499     /**
500      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
501      */
502     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
506      */
507     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
511      */
512     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
513 
514     /**
515      * @dev Returns the number of tokens in ``owner``'s account.
516      */
517     function balanceOf(address owner) external view returns (uint256 balance);
518 
519     /**
520      * @dev Returns the owner of the `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function ownerOf(uint256 tokenId) external view returns (address owner);
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
530      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must exist and be owned by `from`.
537      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
538      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
539      *
540      * Emits a {Transfer} event.
541      */
542     function safeTransferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external;
547 
548     /**
549      * @dev Transfers `tokenId` token from `from` to `to`.
550      *
551      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
559      *
560      * Emits a {Transfer} event.
561      */
562     function transferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
570      * The approval is cleared when the token is transferred.
571      *
572      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
573      *
574      * Requirements:
575      *
576      * - The caller must own the token or be an approved operator.
577      * - `tokenId` must exist.
578      *
579      * Emits an {Approval} event.
580      */
581     function approve(address to, uint256 tokenId) external;
582 
583     /**
584      * @dev Returns the account approved for `tokenId` token.
585      *
586      * Requirements:
587      *
588      * - `tokenId` must exist.
589      */
590     function getApproved(uint256 tokenId) external view returns (address operator);
591 
592     /**
593      * @dev Approve or remove `operator` as an operator for the caller.
594      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
595      *
596      * Requirements:
597      *
598      * - The `operator` cannot be the caller.
599      *
600      * Emits an {ApprovalForAll} event.
601      */
602     function setApprovalForAll(address operator, bool _approved) external;
603 
604     /**
605      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
606      *
607      * See {setApprovalForAll}
608      */
609     function isApprovedForAll(address owner, address operator) external view returns (bool);
610 
611     /**
612      * @dev Safely transfers `tokenId` token from `from` to `to`.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must exist and be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId,
628         bytes calldata data
629     ) external;
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
642  * @dev See https://eips.ethereum.org/EIPS/eip-721
643  */
644 interface IERC721Metadata is IERC721 {
645     /**
646      * @dev Returns the token collection name.
647      */
648     function name() external view returns (string memory);
649 
650     /**
651      * @dev Returns the token collection symbol.
652      */
653     function symbol() external view returns (string memory);
654 
655     /**
656      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
657      */
658     function tokenURI(uint256 tokenId) external view returns (string memory);
659 }
660 
661 // File: contracts/new.sol
662 
663 
664 
665 
666 pragma solidity ^0.8.4;
667 
668 
669 
670 
671 
672 
673 
674 
675 error ApprovalCallerNotOwnerNorApproved();
676 error ApprovalQueryForNonexistentToken();
677 error ApproveToCaller();
678 error ApprovalToCurrentOwner();
679 error BalanceQueryForZeroAddress();
680 error MintToZeroAddress();
681 error MintZeroQuantity();
682 error OwnerQueryForNonexistentToken();
683 error TransferCallerNotOwnerNorApproved();
684 error TransferFromIncorrectOwner();
685 error TransferToNonERC721ReceiverImplementer();
686 error TransferToZeroAddress();
687 error URIQueryForNonexistentToken();
688 
689 /**
690  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
691  * the Metadata extension. Built to optimize for lower gas during batch mints.
692  *
693  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
694  *
695  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
696  *
697  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
698  */
699 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
700     using Address for address;
701     using Strings for uint256;
702 
703     // Compiler will pack this into a single 256bit word.
704     struct TokenOwnership {
705         // The address of the owner.
706         address addr;
707         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
708         uint64 startTimestamp;
709         // Whether the token has been burned.
710         bool burned;
711     }
712 
713     // Compiler will pack this into a single 256bit word.
714     struct AddressData {
715         // Realistically, 2**64-1 is more than enough.
716         uint64 balance;
717         // Keeps track of mint count with minimal overhead for tokenomics.
718         uint64 numberMinted;
719         // Keeps track of burn count with minimal overhead for tokenomics.
720         uint64 numberBurned;
721         // For miscellaneous variable(s) pertaining to the address
722         // (e.g. number of whitelist mint slots used).
723         // If there are multiple variables, please pack them into a uint64.
724         uint64 aux;
725     }
726 
727     // The tokenId of the next token to be minted.
728     uint256 internal _currentIndex;
729 
730     // The number of tokens burned.
731     uint256 internal _burnCounter;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to ownership details
740     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
741     mapping(uint256 => TokenOwnership) internal _ownerships;
742 
743     // Mapping owner address to address data
744     mapping(address => AddressData) private _addressData;
745 
746     // Mapping from token ID to approved address
747     mapping(uint256 => address) private _tokenApprovals;
748 
749     // Mapping from owner to operator approvals
750     mapping(address => mapping(address => bool)) private _operatorApprovals;
751 
752     constructor(string memory name_, string memory symbol_) {
753         _name = name_;
754         _symbol = symbol_;
755         _currentIndex = _startTokenId();
756     }
757 
758     /**
759      * To change the starting tokenId, please override this function.
760      */
761     function _startTokenId() internal view virtual returns (uint256) {
762         return 0;
763     }
764 
765     /**
766      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
767      */
768     function totalSupply() public view returns (uint256) {
769         // Counter underflow is impossible as _burnCounter cannot be incremented
770         // more than _currentIndex - _startTokenId() times
771         unchecked {
772             return _currentIndex - _burnCounter - _startTokenId();
773         }
774     }
775 
776     /**
777      * Returns the total amount of tokens minted in the contract.
778      */
779     function _totalMinted() internal view returns (uint256) {
780         // Counter underflow is impossible as _currentIndex does not decrement,
781         // and it is initialized to _startTokenId()
782         unchecked {
783             return _currentIndex - _startTokenId();
784         }
785     }
786 
787     /**
788      * @dev See {IERC165-supportsInterface}.
789      */
790     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
791         return
792             interfaceId == type(IERC721).interfaceId ||
793             interfaceId == type(IERC721Metadata).interfaceId ||
794             super.supportsInterface(interfaceId);
795     }
796 
797     /**
798      * @dev See {IERC721-balanceOf}.
799      */
800     function balanceOf(address owner) public view override returns (uint256) {
801         if (owner == address(0)) revert BalanceQueryForZeroAddress();
802         return uint256(_addressData[owner].balance);
803     }
804 
805     /**
806      * Returns the number of tokens minted by `owner`.
807      */
808     function _numberMinted(address owner) internal view returns (uint256) {
809         return uint256(_addressData[owner].numberMinted);
810     }
811 
812     /**
813      * Returns the number of tokens burned by or on behalf of `owner`.
814      */
815     function _numberBurned(address owner) internal view returns (uint256) {
816         return uint256(_addressData[owner].numberBurned);
817     }
818 
819     /**
820      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
821      */
822     function _getAux(address owner) internal view returns (uint64) {
823         return _addressData[owner].aux;
824     }
825 
826     /**
827      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
828      * If there are multiple variables, please pack them into a uint64.
829      */
830     function _setAux(address owner, uint64 aux) internal {
831         _addressData[owner].aux = aux;
832     }
833 
834     /**
835      * Gas spent here starts off proportional to the maximum mint batch size.
836      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
837      */
838     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
839         uint256 curr = tokenId;
840 
841         unchecked {
842             if (_startTokenId() <= curr && curr < _currentIndex) {
843                 TokenOwnership memory ownership = _ownerships[curr];
844                 if (!ownership.burned) {
845                     if (ownership.addr != address(0)) {
846                         return ownership;
847                     }
848                     // Invariant:
849                     // There will always be an ownership that has an address and is not burned
850                     // before an ownership that does not have an address and is not burned.
851                     // Hence, curr will not underflow.
852                     while (true) {
853                         curr--;
854                         ownership = _ownerships[curr];
855                         if (ownership.addr != address(0)) {
856                             return ownership;
857                         }
858                     }
859                 }
860             }
861         }
862         revert OwnerQueryForNonexistentToken();
863     }
864 
865     /**
866      * @dev See {IERC721-ownerOf}.
867      */
868     function ownerOf(uint256 tokenId) public view override returns (address) {
869         return _ownershipOf(tokenId).addr;
870     }
871 
872     /**
873      * @dev See {IERC721Metadata-name}.
874      */
875     function name() public view virtual override returns (string memory) {
876         return _name;
877     }
878 
879     /**
880      * @dev See {IERC721Metadata-symbol}.
881      */
882     function symbol() public view virtual override returns (string memory) {
883         return _symbol;
884     }
885 
886     /**
887      * @dev See {IERC721Metadata-tokenURI}.
888      */
889     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
890         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
891 
892         string memory baseURI = _baseURI();
893         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
894     }
895 
896     /**
897      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
898      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
899      * by default, can be overriden in child contracts.
900      */
901     function _baseURI() internal view virtual returns (string memory) {
902         return '';
903     }
904 
905     /**
906      * @dev See {IERC721-approve}.
907      */
908     function approve(address to, uint256 tokenId) public override {
909         address owner = ERC721A.ownerOf(tokenId);
910         if (to == owner) revert ApprovalToCurrentOwner();
911 
912         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
913             revert ApprovalCallerNotOwnerNorApproved();
914         }
915 
916         _approve(to, tokenId, owner);
917     }
918 
919     /**
920      * @dev See {IERC721-getApproved}.
921      */
922     function getApproved(uint256 tokenId) public view override returns (address) {
923         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
924 
925         return _tokenApprovals[tokenId];
926     }
927 
928     /**
929      * @dev See {IERC721-setApprovalForAll}.
930      */
931     function setApprovalForAll(address operator, bool approved) public virtual override {
932         if (operator == _msgSender()) revert ApproveToCaller();
933 
934         _operatorApprovals[_msgSender()][operator] = approved;
935         emit ApprovalForAll(_msgSender(), operator, approved);
936     }
937 
938     /**
939      * @dev See {IERC721-isApprovedForAll}.
940      */
941     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
942         return _operatorApprovals[owner][operator];
943     }
944 
945     /**
946      * @dev See {IERC721-transferFrom}.
947      */
948     function transferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public virtual override {
953         _transfer(from, to, tokenId);
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId
963     ) public virtual override {
964         safeTransferFrom(from, to, tokenId, '');
965     }
966 
967     /**
968      * @dev See {IERC721-safeTransferFrom}.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) public virtual override {
976         _transfer(from, to, tokenId);
977         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
978             revert TransferToNonERC721ReceiverImplementer();
979         }
980     }
981 
982     /**
983      * @dev Returns whether `tokenId` exists.
984      *
985      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
986      *
987      * Tokens start existing when they are minted (`_mint`),
988      */
989     function _exists(uint256 tokenId) internal view returns (bool) {
990         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
991             !_ownerships[tokenId].burned;
992     }
993 
994     function _safeMint(address to, uint256 quantity) internal {
995         _safeMint(to, quantity, '');
996     }
997 
998     /**
999      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1004      * - `quantity` must be greater than 0.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _safeMint(
1009         address to,
1010         uint256 quantity,
1011         bytes memory _data
1012     ) internal {
1013         _mint(to, quantity, _data, true);
1014     }
1015 
1016     /**
1017      * @dev Mints `quantity` tokens and transfers them to `to`.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `quantity` must be greater than 0.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _mint(
1027         address to,
1028         uint256 quantity,
1029         bytes memory _data,
1030         bool safe
1031     ) internal {
1032         uint256 startTokenId = _currentIndex;
1033         if (to == address(0)) revert MintToZeroAddress();
1034         if (quantity == 0) revert MintZeroQuantity();
1035 
1036         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1037 
1038         // Overflows are incredibly unrealistic.
1039         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1040         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1041         unchecked {
1042             _addressData[to].balance += uint64(quantity);
1043             _addressData[to].numberMinted += uint64(quantity);
1044 
1045             _ownerships[startTokenId].addr = to;
1046             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1047 
1048             uint256 updatedIndex = startTokenId;
1049             uint256 end = updatedIndex + quantity;
1050 
1051             if (safe && to.isContract()) {
1052                 do {
1053                     emit Transfer(address(0), to, updatedIndex);
1054                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1055                         revert TransferToNonERC721ReceiverImplementer();
1056                     }
1057                 } while (updatedIndex != end);
1058                 // Reentrancy protection
1059                 if (_currentIndex != startTokenId) revert();
1060             } else {
1061                 do {
1062                     emit Transfer(address(0), to, updatedIndex++);
1063                 } while (updatedIndex != end);
1064             }
1065             _currentIndex = updatedIndex;
1066         }
1067         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1068     }
1069 
1070     /**
1071      * @dev Transfers `tokenId` from `from` to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - `tokenId` token must be owned by `from`.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _transfer(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) private {
1085         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1086 
1087         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1088 
1089         bool isApprovedOrOwner = (_msgSender() == from ||
1090             isApprovedForAll(from, _msgSender()) ||
1091             getApproved(tokenId) == _msgSender());
1092 
1093         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1094         if (to == address(0)) revert TransferToZeroAddress();
1095 
1096         _beforeTokenTransfers(from, to, tokenId, 1);
1097 
1098         // Clear approvals from the previous owner
1099         _approve(address(0), tokenId, from);
1100 
1101         // Underflow of the sender's balance is impossible because we check for
1102         // ownership above and the recipient's balance can't realistically overflow.
1103         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1104         unchecked {
1105             _addressData[from].balance -= 1;
1106             _addressData[to].balance += 1;
1107 
1108             TokenOwnership storage currSlot = _ownerships[tokenId];
1109             currSlot.addr = to;
1110             currSlot.startTimestamp = uint64(block.timestamp);
1111 
1112             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1113             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1114             uint256 nextTokenId = tokenId + 1;
1115             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1116             if (nextSlot.addr == address(0)) {
1117                 // This will suffice for checking _exists(nextTokenId),
1118                 // as a burned slot cannot contain the zero address.
1119                 if (nextTokenId != _currentIndex) {
1120                     nextSlot.addr = from;
1121                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1122                 }
1123             }
1124         }
1125 
1126         emit Transfer(from, to, tokenId);
1127         _afterTokenTransfers(from, to, tokenId, 1);
1128     }
1129 
1130     /**
1131      * @dev This is equivalent to _burn(tokenId, false)
1132      */
1133     function _burn(uint256 tokenId) internal virtual {
1134         _burn(tokenId, false);
1135     }
1136 
1137     /**
1138      * @dev Destroys `tokenId`.
1139      * The approval is cleared when the token is burned.
1140      *
1141      * Requirements:
1142      *
1143      * - `tokenId` must exist.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1148         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1149 
1150         address from = prevOwnership.addr;
1151 
1152         if (approvalCheck) {
1153             bool isApprovedOrOwner = (_msgSender() == from ||
1154                 isApprovedForAll(from, _msgSender()) ||
1155                 getApproved(tokenId) == _msgSender());
1156 
1157             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1158         }
1159 
1160         _beforeTokenTransfers(from, address(0), tokenId, 1);
1161 
1162         // Clear approvals from the previous owner
1163         _approve(address(0), tokenId, from);
1164 
1165         // Underflow of the sender's balance is impossible because we check for
1166         // ownership above and the recipient's balance can't realistically overflow.
1167         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1168         unchecked {
1169             AddressData storage addressData = _addressData[from];
1170             addressData.balance -= 1;
1171             addressData.numberBurned += 1;
1172 
1173             // Keep track of who burned the token, and the timestamp of burning.
1174             TokenOwnership storage currSlot = _ownerships[tokenId];
1175             currSlot.addr = from;
1176             currSlot.startTimestamp = uint64(block.timestamp);
1177             currSlot.burned = true;
1178 
1179             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1180             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1181             uint256 nextTokenId = tokenId + 1;
1182             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1183             if (nextSlot.addr == address(0)) {
1184                 // This will suffice for checking _exists(nextTokenId),
1185                 // as a burned slot cannot contain the zero address.
1186                 if (nextTokenId != _currentIndex) {
1187                     nextSlot.addr = from;
1188                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1189                 }
1190             }
1191         }
1192 
1193         emit Transfer(from, address(0), tokenId);
1194         _afterTokenTransfers(from, address(0), tokenId, 1);
1195 
1196         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1197         unchecked {
1198             _burnCounter++;
1199         }
1200     }
1201 
1202     /**
1203      * @dev Approve `to` to operate on `tokenId`
1204      *
1205      * Emits a {Approval} event.
1206      */
1207     function _approve(
1208         address to,
1209         uint256 tokenId,
1210         address owner
1211     ) private {
1212         _tokenApprovals[tokenId] = to;
1213         emit Approval(owner, to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1218      *
1219      * @param from address representing the previous owner of the given token ID
1220      * @param to target address that will receive the tokens
1221      * @param tokenId uint256 ID of the token to be transferred
1222      * @param _data bytes optional data to send along with the call
1223      * @return bool whether the call correctly returned the expected magic value
1224      */
1225     function _checkContractOnERC721Received(
1226         address from,
1227         address to,
1228         uint256 tokenId,
1229         bytes memory _data
1230     ) private returns (bool) {
1231         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1232             return retval == IERC721Receiver(to).onERC721Received.selector;
1233         } catch (bytes memory reason) {
1234             if (reason.length == 0) {
1235                 revert TransferToNonERC721ReceiverImplementer();
1236             } else {
1237                 assembly {
1238                     revert(add(32, reason), mload(reason))
1239                 }
1240             }
1241         }
1242     }
1243 
1244     /**
1245      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1246      * And also called before burning one token.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, `tokenId` will be burned by `from`.
1257      * - `from` and `to` are never both zero.
1258      */
1259     function _beforeTokenTransfers(
1260         address from,
1261         address to,
1262         uint256 startTokenId,
1263         uint256 quantity
1264     ) internal virtual {}
1265 
1266     /**
1267      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1268      * minting.
1269      * And also called after one token has been burned.
1270      *
1271      * startTokenId - the first token id to be transferred
1272      * quantity - the amount to be transferred
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` has been minted for `to`.
1279      * - When `to` is zero, `tokenId` has been burned by `from`.
1280      * - `from` and `to` are never both zero.
1281      */
1282     function _afterTokenTransfers(
1283         address from,
1284         address to,
1285         uint256 startTokenId,
1286         uint256 quantity
1287     ) internal virtual {}
1288 }
1289 
1290 abstract contract Ownable is Context {
1291     address private _owner;
1292 
1293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1294 
1295     /**
1296      * @dev Initializes the contract setting the deployer as the initial owner.
1297      */
1298     constructor() {
1299         _transferOwnership(_msgSender());
1300     }
1301 
1302     /**
1303      * @dev Returns the address of the current owner.
1304      */
1305     function owner() public view virtual returns (address) {
1306         return _owner;
1307     }
1308 
1309     /**
1310      * @dev Throws if called by any account other than the owner.
1311      */
1312     modifier onlyOwner() {
1313         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1314         _;
1315     }
1316 
1317     /**
1318      * @dev Leaves the contract without owner. It will not be possible to call
1319      * `onlyOwner` functions anymore. Can only be called by the current owner.
1320      *
1321      * NOTE: Renouncing ownership will leave the contract without an owner,
1322      * thereby removing any functionality that is only available to the owner.
1323      */
1324     function renounceOwnership() public virtual onlyOwner {
1325         _transferOwnership(address(0));
1326     }
1327 
1328     /**
1329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1330      * Can only be called by the current owner.
1331      */
1332     function transferOwnership(address newOwner) public virtual onlyOwner {
1333         require(newOwner != address(0), "Ownable: new owner is the zero address");
1334         _transferOwnership(newOwner);
1335     }
1336 
1337     /**
1338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1339      * Internal function without access restriction.
1340      */
1341     function _transferOwnership(address newOwner) internal virtual {
1342         address oldOwner = _owner;
1343         _owner = newOwner;
1344         emit OwnershipTransferred(oldOwner, newOwner);
1345     }
1346 }
1347  
1348 
1349 contract TheVisitors is ERC721A, Ownable, ReentrancyGuard {
1350 
1351   using Strings for uint256;
1352 
1353   
1354 
1355   string public uriPrefix = "ipfs://QmdzApMSJkjzsTVSzzy65pt7w2oLdWBH9odbJkoNYtpLeP/";
1356   string public uriSuffix = ".json";
1357   string public hiddenMetadataUri;
1358   
1359   uint256 public cost = 0.005 ether;
1360   uint256 public maxSupply = 1111;
1361   uint256 public freeSupply = 1000;
1362   uint256 public maxMintAmountPerTx = 2;
1363   uint256 public nftPerAddressLimit = 6;
1364 
1365   bool public paused = true;
1366 
1367   bool public revealed = true;
1368 
1369   mapping(address => uint256) public FreeaddressMintedBalance;
1370   mapping(address => uint256) public PaidaddressMintedBalance;
1371 
1372   constructor(
1373     string memory _tokenName,
1374     string memory _tokenSymbol
1375   ) ERC721A(_tokenName, _tokenSymbol) {
1376 
1377   }
1378 
1379   modifier mintCompliance(uint256 _mintAmount) {
1380     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1381     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1382    
1383     _;
1384   }
1385 
1386   
1387 
1388 
1389   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) nonReentrant  {
1390     require(!paused, "The contract is paused!");
1391     if(totalSupply() > freeSupply)
1392     {
1393          require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1394           require(PaidaddressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max mint amount per address exceeded!"); 
1395         PaidaddressMintedBalance[msg.sender] += _mintAmount;
1396     }
1397     else
1398     {
1399          require(FreeaddressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max mint amount per address exceeded!"); 
1400         FreeaddressMintedBalance[msg.sender] += _mintAmount;
1401     }
1402     
1403     _safeMint(_msgSender(), _mintAmount);
1404   }
1405   
1406   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1407     _safeMint(_receiver, _mintAmount);
1408   }
1409 
1410   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1411     uint256 ownerTokenCount = balanceOf(_owner);
1412     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1413     uint256 currentTokenId = _startTokenId();
1414     uint256 ownedTokenIndex = 0;
1415     address latestOwnerAddress;
1416 
1417     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1418       TokenOwnership memory ownership = _ownerships[currentTokenId];
1419 
1420       if (!ownership.burned && ownership.addr != address(0)) {
1421         latestOwnerAddress = ownership.addr;
1422       }
1423 
1424       if (latestOwnerAddress == _owner) {
1425         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1426 
1427         ownedTokenIndex++;
1428       }
1429 
1430       currentTokenId++;
1431     }
1432 
1433     return ownedTokenIds;
1434   }
1435 
1436   function _startTokenId() internal view virtual override returns (uint256) {
1437         return 1;
1438     }
1439 
1440   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1441     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1442 
1443     if (revealed == false) {
1444       return hiddenMetadataUri;
1445     }
1446 
1447     string memory currentBaseURI = _baseURI();
1448     return bytes(currentBaseURI).length > 0
1449         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1450         : '';
1451   }
1452 
1453   function setRevealed(bool _state) public onlyOwner {
1454     revealed = _state;
1455   }
1456 
1457   function setCost(uint256 _cost) public onlyOwner {
1458     cost = _cost;
1459   }
1460 
1461   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1462     maxMintAmountPerTx = _maxMintAmountPerTx;
1463   }
1464   function SetMaxNftPerAddressLimit(uint256 _nftPerAddressLimit) public onlyOwner {
1465     nftPerAddressLimit = _nftPerAddressLimit;
1466   }
1467 
1468    
1469 
1470 
1471   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1472     hiddenMetadataUri = _hiddenMetadataUri;
1473   }
1474 
1475   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1476     uriPrefix = _uriPrefix;
1477   }
1478 
1479   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1480     uriSuffix = _uriSuffix;
1481   }
1482 
1483   function setPaused(bool _state) public onlyOwner {
1484     paused = _state;
1485   }
1486 
1487 
1488  
1489 
1490   function withdraw() public onlyOwner nonReentrant {
1491     // This will transfer the remaining contract balance to the owner.
1492     // Do not remove this otherwise you will not be able to withdraw the funds.
1493     // =============================================================================
1494     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1495     require(os);
1496     // =============================================================================
1497   }
1498 
1499   function _baseURI() internal view virtual override returns (string memory) {
1500     return uriPrefix;
1501   }
1502 }