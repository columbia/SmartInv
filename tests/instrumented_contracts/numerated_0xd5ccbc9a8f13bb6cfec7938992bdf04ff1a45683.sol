1 //SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81     uint8 private constant _ADDRESS_LENGTH = 20;
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         // Inspired by OraclizeAPI's implementation - MIT licence
88         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
89 
90         if (value == 0) {
91             return "0";
92         }
93         uint256 temp = value;
94         uint256 digits;
95         while (temp != 0) {
96             digits++;
97             temp /= 10;
98         }
99         bytes memory buffer = new bytes(digits);
100         while (value != 0) {
101             digits -= 1;
102             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
103             value /= 10;
104         }
105         return string(buffer);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
110      */
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
126      */
127     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
128         bytes memory buffer = new bytes(2 * length + 2);
129         buffer[0] = "0";
130         buffer[1] = "x";
131         for (uint256 i = 2 * length + 1; i > 1; --i) {
132             buffer[i] = _HEX_SYMBOLS[value & 0xf];
133             value >>= 4;
134         }
135         require(value == 0, "Strings: hex length insufficient");
136         return string(buffer);
137     }
138 
139     /**
140      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
141      */
142     function toHexString(address addr) internal pure returns (string memory) {
143         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Address.sol
148 
149 
150 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
151 
152 pragma solidity ^0.8.1;
153 
154 /**
155  * @dev Collection of functions related to the address type
156  */
157 library Address {
158     /**
159      * @dev Returns true if `account` is a contract.
160      *
161      * [IMPORTANT]
162      * ====
163      * It is unsafe to assume that an address for which this function returns
164      * false is an externally-owned account (EOA) and not a contract.
165      *
166      * Among others, `isContract` will return false for the following
167      * types of addresses:
168      *
169      *  - an externally-owned account
170      *  - a contract in construction
171      *  - an address where a contract will be created
172      *  - an address where a contract lived, but was destroyed
173      * ====
174      *
175      * [IMPORTANT]
176      * ====
177      * You shouldn't rely on `isContract` to protect against flash loan attacks!
178      *
179      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
180      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
181      * constructor.
182      * ====
183      */
184     function isContract(address account) internal view returns (bool) {
185         // This method relies on extcodesize/address.code.length, which returns 0
186         // for contracts in construction, since the code is only stored at the end
187         // of the constructor execution.
188 
189         return account.code.length > 0;
190     }
191 
192     /**
193      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
194      * `recipient`, forwarding all available gas and reverting on errors.
195      *
196      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
197      * of certain opcodes, possibly making contracts go over the 2300 gas limit
198      * imposed by `transfer`, making them unable to receive funds via
199      * `transfer`. {sendValue} removes this limitation.
200      *
201      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
202      *
203      * IMPORTANT: because control is transferred to `recipient`, care must be
204      * taken to not create reentrancy vulnerabilities. Consider using
205      * {ReentrancyGuard} or the
206      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
207      */
208     function sendValue(address payable recipient, uint256 amount) internal {
209         require(address(this).balance >= amount, "Address: insufficient balance");
210 
211         (bool success, ) = recipient.call{value: amount}("");
212         require(success, "Address: unable to send value, recipient may have reverted");
213     }
214 
215     /**
216      * @dev Performs a Solidity function call using a low level `call`. A
217      * plain `call` is an unsafe replacement for a function call: use this
218      * function instead.
219      *
220      * If `target` reverts with a revert reason, it is bubbled up by this
221      * function (like regular Solidity function calls).
222      *
223      * Returns the raw returned data. To convert to the expected return value,
224      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
225      *
226      * Requirements:
227      *
228      * - `target` must be a contract.
229      * - calling `target` with `data` must not revert.
230      *
231      * _Available since v3.1._
232      */
233     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionCall(target, data, "Address: low-level call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
239      * `errorMessage` as a fallback revert reason when `target` reverts.
240      *
241      * _Available since v3.1._
242      */
243     function functionCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, 0, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but also transferring `value` wei to `target`.
254      *
255      * Requirements:
256      *
257      * - the calling contract must have an ETH balance of at least `value`.
258      * - the called Solidity function must be `payable`.
259      *
260      * _Available since v3.1._
261      */
262     function functionCallWithValue(
263         address target,
264         bytes memory data,
265         uint256 value
266     ) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
272      * with `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(
277         address target,
278         bytes memory data,
279         uint256 value,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(address(this).balance >= value, "Address: insufficient balance for call");
283         require(isContract(target), "Address: call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.call{value: value}(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
296         return functionStaticCall(target, data, "Address: low-level static call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
301      * but performing a static call.
302      *
303      * _Available since v3.3._
304      */
305     function functionStaticCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal view returns (bytes memory) {
310         require(isContract(target), "Address: static call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.staticcall(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but performing a delegate call.
319      *
320      * _Available since v3.4._
321      */
322     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
328      * but performing a delegate call.
329      *
330      * _Available since v3.4._
331      */
332     function functionDelegateCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         require(isContract(target), "Address: delegate call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.delegatecall(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
345      * revert reason using the provided one.
346      *
347      * _Available since v4.3._
348      */
349     function verifyCallResult(
350         bool success,
351         bytes memory returndata,
352         string memory errorMessage
353     ) internal pure returns (bytes memory) {
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360                 /// @solidity memory-safe-assembly
361                 assembly {
362                     let returndata_size := mload(returndata)
363                     revert(add(32, returndata), returndata_size)
364                 }
365             } else {
366                 revert(errorMessage);
367             }
368         }
369     }
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
373 
374 
375 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @title ERC721 token receiver interface
381  * @dev Interface for any contract that wants to support safeTransfers
382  * from ERC721 asset contracts.
383  */
384 interface IERC721Receiver {
385     /**
386      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
387      * by `operator` from `from`, this function is called.
388      *
389      * It must return its Solidity selector to confirm the token transfer.
390      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
391      *
392      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
393      */
394     function onERC721Received(
395         address operator,
396         address from,
397         uint256 tokenId,
398         bytes calldata data
399     ) external returns (bytes4);
400 }
401 
402 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Interface of the ERC165 standard, as defined in the
411  * https://eips.ethereum.org/EIPS/eip-165[EIP].
412  *
413  * Implementers can declare support of contract interfaces, which can then be
414  * queried by others ({ERC165Checker}).
415  *
416  * For an implementation, see {ERC165}.
417  */
418 interface IERC165 {
419     /**
420      * @dev Returns true if this contract implements the interface defined by
421      * `interfaceId`. See the corresponding
422      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
423      * to learn more about how these ids are created.
424      *
425      * This function call must use less than 30 000 gas.
426      */
427     function supportsInterface(bytes4 interfaceId) external view returns (bool);
428 }
429 
430 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 
438 /**
439  * @dev Implementation of the {IERC165} interface.
440  *
441  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
442  * for the additional interface id that will be supported. For example:
443  *
444  * ```solidity
445  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
446  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
447  * }
448  * ```
449  *
450  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
451  */
452 abstract contract ERC165 is IERC165 {
453     /**
454      * @dev See {IERC165-supportsInterface}.
455      */
456     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
457         return interfaceId == type(IERC165).interfaceId;
458     }
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Required interface of an ERC721 compliant contract.
471  */
472 interface IERC721 is IERC165 {
473     /**
474      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
477 
478     /**
479      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
480      */
481     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
485      */
486     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
487 
488     /**
489      * @dev Returns the number of tokens in ``owner``'s account.
490      */
491     function balanceOf(address owner) external view returns (uint256 balance);
492 
493     /**
494      * @dev Returns the owner of the `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function ownerOf(uint256 tokenId) external view returns (address owner);
501 
502     /**
503      * @dev Safely transfers `tokenId` token from `from` to `to`.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId,
519         bytes calldata data
520     ) external;
521 
522     /**
523      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
524      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must exist and be owned by `from`.
531      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
532      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
533      *
534      * Emits a {Transfer} event.
535      */
536     function safeTransferFrom(
537         address from,
538         address to,
539         uint256 tokenId
540     ) external;
541 
542     /**
543      * @dev Transfers `tokenId` token from `from` to `to`.
544      *
545      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      *
554      * Emits a {Transfer} event.
555      */
556     function transferFrom(
557         address from,
558         address to,
559         uint256 tokenId
560     ) external;
561 
562     /**
563      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
564      * The approval is cleared when the token is transferred.
565      *
566      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
567      *
568      * Requirements:
569      *
570      * - The caller must own the token or be an approved operator.
571      * - `tokenId` must exist.
572      *
573      * Emits an {Approval} event.
574      */
575     function approve(address to, uint256 tokenId) external;
576 
577     /**
578      * @dev Approve or remove `operator` as an operator for the caller.
579      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
580      *
581      * Requirements:
582      *
583      * - The `operator` cannot be the caller.
584      *
585      * Emits an {ApprovalForAll} event.
586      */
587     function setApprovalForAll(address operator, bool _approved) external;
588 
589     /**
590      * @dev Returns the account approved for `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function getApproved(uint256 tokenId) external view returns (address operator);
597 
598     /**
599      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
600      *
601      * See {setApprovalForAll}
602      */
603     function isApprovedForAll(address owner, address operator) external view returns (bool);
604 }
605 
606 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
607 
608 
609 
610 
611 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 
616 /**
617  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
618  * @dev See https://eips.ethereum.org/EIPS/eip-721
619  */
620 interface IERC721Enumerable is IERC721 {
621     /**
622      * @dev Returns the total amount of tokens stored by the contract.
623      */
624     function totalSupply() external view returns (uint256);
625 
626     /**
627      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
628      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
629      */
630     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
631 
632     /**
633      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
634      * Use along with {totalSupply} to enumerate all tokens.
635      */
636     function tokenByIndex(uint256 index) external view returns (uint256);
637 }
638 
639 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
640 
641 
642 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
649  * @dev See https://eips.ethereum.org/EIPS/eip-721
650  */
651 interface IERC721Metadata is IERC721 {
652     /**
653      * @dev Returns the token collection name.
654      */
655     function name() external view returns (string memory);
656 
657     /**
658      * @dev Returns the token collection symbol.
659      */
660     function symbol() external view returns (string memory);
661 
662     /**
663      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
664      */
665     function tokenURI(uint256 tokenId) external view returns (string memory);
666 }
667 
668 // File: @openzeppelin/contracts/utils/Context.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev Provides information about the current execution context, including the
677  * sender of the transaction and its data. While these are generally available
678  * via msg.sender and msg.data, they should not be accessed in such a direct
679  * manner, since when dealing with meta-transactions the account sending and
680  * paying for execution may not be the actual sender (as far as an application
681  * is concerned).
682  *
683  * This contract is only required for intermediate, library-like contracts.
684  */
685 abstract contract Context {
686     function _msgSender() internal view virtual returns (address) {
687         return msg.sender;
688     }
689 
690     function _msgData() internal view virtual returns (bytes calldata) {
691         return msg.data;
692     }
693 }
694 
695 // File: ERC721A.sol
696 
697 
698 
699 // Creator: Chiru Labs
700 
701 pragma solidity ^0.8.4;
702 
703 
704 
705 
706 
707 
708 
709 
710 
711 error ApprovalCallerNotOwnerNorApproved();
712 error ApprovalQueryForNonexistentToken();
713 error ApproveToCaller();
714 error ApprovalToCurrentOwner();
715 error BalanceQueryForZeroAddress();
716 error MintedQueryForZeroAddress();
717 error BurnedQueryForZeroAddress();
718 error AuxQueryForZeroAddress();
719 error MintToZeroAddress();
720 error MintZeroQuantity();
721 error OwnerIndexOutOfBounds();
722 error OwnerQueryForNonexistentToken();
723 error TokenIndexOutOfBounds();
724 error TransferCallerNotOwnerNorApproved();
725 error TransferFromIncorrectOwner();
726 error TransferToNonERC721ReceiverImplementer();
727 error TransferToZeroAddress();
728 error URIQueryForNonexistentToken();
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension. Built to optimize for lower gas during batch mints.
733  *
734  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
735  *
736  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
737  *
738  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
739  */
740 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
741     using Address for address;
742     using Strings for uint256;
743 
744     // Compiler will pack this into a single 256bit word.
745     struct TokenOwnership {
746         // The address of the owner.
747         address addr;
748         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
749         uint64 startTimestamp;
750         // Whether the token has been burned.
751         bool burned;
752     }
753 
754     // Compiler will pack this into a single 256bit word.
755     struct AddressData {
756         // Realistically, 2**64-1 is more than enough.
757         uint64 balance;
758         // Keeps track of mint count with minimal overhead for tokenomics.
759         uint64 numberMinted;
760         // Keeps track of burn count with minimal overhead for tokenomics.
761         uint64 numberBurned;
762         // For miscellaneous variable(s) pertaining to the address
763         // (e.g. number of whitelist mint slots used).
764         // If there are multiple variables, please pack them into a uint64.
765         uint64 aux;
766     }
767 
768     // The tokenId of the next token to be minted.
769     uint256 internal _currentIndex;
770 
771     // The number of tokens burned.
772     uint256 internal _burnCounter;
773 
774     // Token name
775     string private _name;
776 
777     // Token symbol
778     string private _symbol;
779 
780     // Mapping from token ID to ownership details
781     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
782     mapping(uint256 => TokenOwnership) internal _ownerships;
783 
784     // Mapping owner address to address data
785     mapping(address => AddressData) private _addressData;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     constructor(string memory name_, string memory symbol_) {
794         _name = name_;
795         _symbol = symbol_;
796         _currentIndex = _startTokenId();
797     }
798 
799     /**
800      * To change the starting tokenId, please override this function.
801      */
802     function _startTokenId() internal view virtual returns (uint256) {
803         return 0;
804     }
805 
806     /**
807      * @dev See {IERC721Enumerable-totalSupply}.
808      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
809      */
810     function totalSupply() public view returns (uint256) {
811         // Counter underflow is impossible as _burnCounter cannot be incremented
812         // more than _currentIndex - _startTokenId() times
813         unchecked {
814             return _currentIndex - _burnCounter - _startTokenId();
815         }
816     }
817 
818     /**
819      * Returns the total amount of tokens minted in the contract.
820      */
821     function _totalMinted() internal view returns (uint256) {
822         // Counter underflow is impossible as _currentIndex does not decrement,
823         // and it is initialized to _startTokenId()
824         unchecked {
825             return _currentIndex - _startTokenId();
826         }
827     }
828 
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
833         return
834             interfaceId == type(IERC721).interfaceId ||
835             interfaceId == type(IERC721Metadata).interfaceId ||
836             super.supportsInterface(interfaceId);
837     }
838 
839     /**
840      * @dev See {IERC721-balanceOf}.
841      */
842     function balanceOf(address owner) public view override returns (uint256) {
843         if (owner == address(0)) revert BalanceQueryForZeroAddress();
844         return uint256(_addressData[owner].balance);
845     }
846 
847     /**
848      * Returns the number of tokens minted by `owner`.
849      */
850     function _numberMinted(address owner) internal view returns (uint256) {
851         if (owner == address(0)) revert MintedQueryForZeroAddress();
852         return uint256(_addressData[owner].numberMinted);
853     }
854 
855     /**
856      * Returns the number of tokens burned by or on behalf of `owner`.
857      */
858     function _numberBurned(address owner) internal view returns (uint256) {
859         if (owner == address(0)) revert BurnedQueryForZeroAddress();
860         return uint256(_addressData[owner].numberBurned);
861     }
862 
863     /**
864      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
865      */
866     function _getAux(address owner) internal view returns (uint64) {
867         if (owner == address(0)) revert AuxQueryForZeroAddress();
868         return _addressData[owner].aux;
869     }
870 
871     /**
872      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
873      * If there are multiple variables, please pack them into a uint64.
874      */
875     function _setAux(address owner, uint64 aux) internal {
876         if (owner == address(0)) revert AuxQueryForZeroAddress();
877         _addressData[owner].aux = aux;
878     }
879 
880     /**
881      * Gas spent here starts off proportional to the maximum mint batch size.
882      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
883      */
884     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
885         uint256 curr = tokenId;
886 
887         unchecked {
888             if (_startTokenId() <= curr && curr < _currentIndex) {
889                 TokenOwnership memory ownership = _ownerships[curr];
890                 if (!ownership.burned) {
891                     if (ownership.addr != address(0)) {
892                         return ownership;
893                     }
894                     // Invariant:
895                     // There will always be an ownership that has an address and is not burned
896                     // before an ownership that does not have an address and is not burned.
897                     // Hence, curr will not underflow.
898                     while (true) {
899                         curr--;
900                         ownership = _ownerships[curr];
901                         if (ownership.addr != address(0)) {
902                             return ownership;
903                         }
904                     }
905                 }
906             }
907         }
908         revert OwnerQueryForNonexistentToken();
909     }
910 
911 
912     /**
913      * @dev See {IERC721-ownerOf}.
914      */
915     function ownerOf(uint256 tokenId) public view override returns (address) {
916         return ownershipOf(tokenId).addr;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-name}.
921      */
922     function name() public view virtual override returns (string memory) {
923         return _name;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-symbol}.
928      */
929     function symbol() public view virtual override returns (string memory) {
930         return _symbol;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-tokenURI}.
935      */
936     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
937         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
938 
939         string memory baseURI = _baseURI();
940         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
941     }
942 
943     /**
944      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
945      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
946      * by default, can be overriden in child contracts.
947      */
948     function _baseURI() internal view virtual returns (string memory) {
949         return '';
950     }
951 
952     /**
953      * @dev See {IERC721-approve}.
954      */
955     function approve(address to, uint256 tokenId) public override {
956         address owner = ERC721A.ownerOf(tokenId);
957         if (to == owner) revert ApprovalToCurrentOwner();
958 
959         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
960             revert ApprovalCallerNotOwnerNorApproved();
961         }
962 
963         _approve(to, tokenId, owner);
964     }
965 
966     /**
967      * @dev See {IERC721-getApproved}.
968      */
969     function getApproved(uint256 tokenId) public view override returns (address) {
970         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
971 
972         return _tokenApprovals[tokenId];
973     }
974 
975     /**
976      * @dev See {IERC721-setApprovalForAll}.
977      */
978     function setApprovalForAll(address operator, bool approved) public override {
979         if (operator == _msgSender()) revert ApproveToCaller();
980 
981         _operatorApprovals[_msgSender()][operator] = approved;
982         emit ApprovalForAll(_msgSender(), operator, approved);
983     }
984 
985     /**
986      * @dev See {IERC721-isApprovedForAll}.
987      */
988     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
989         return _operatorApprovals[owner][operator];
990     }
991 
992     /**
993      * @dev See {IERC721-transferFrom}.
994      */
995     function transferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) public virtual override {
1000         _transfer(from, to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-safeTransferFrom}.
1005      */
1006     function safeTransferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) public virtual override {
1011         safeTransferFrom(from, to, tokenId, '');
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-safeTransferFrom}.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) public virtual override {
1023         _transfer(from, to, tokenId);
1024         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1025             revert TransferToNonERC721ReceiverImplementer();
1026         }
1027     }
1028 
1029     /**
1030      * @dev Returns whether `tokenId` exists.
1031      *
1032      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1033      *
1034      * Tokens start existing when they are minted (`_mint`),
1035      */
1036     function _exists(uint256 tokenId) internal view returns (bool) {
1037         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1038             !_ownerships[tokenId].burned;
1039     }
1040 
1041     function _safeMint(address to, uint256 quantity) internal {
1042         _safeMint(to, quantity, '');
1043     }
1044 
1045     /**
1046      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1051      * - `quantity` must be greater than 0.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeMint(
1056         address to,
1057         uint256 quantity,
1058         bytes memory _data
1059     ) internal {
1060         _mint(to, quantity, _data, true);
1061     }
1062 
1063 
1064 
1065 
1066     /**
1067      * @dev Mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _mint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data,
1080         bool safe
1081     ) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             _addressData[to].balance += uint64(quantity);
1093             _addressData[to].numberMinted += uint64(quantity);
1094 
1095             _ownerships[startTokenId].addr = to;
1096             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1097 
1098             uint256 updatedIndex = startTokenId;
1099             uint256 end = updatedIndex + quantity;
1100 
1101             if (safe && to.isContract()) {
1102                 do {
1103                     emit Transfer(address(0), to, updatedIndex);
1104                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1105                         revert TransferToNonERC721ReceiverImplementer();
1106                     }
1107                 } while (updatedIndex != end);
1108                 // Reentrancy protection
1109                 if (_currentIndex != startTokenId) revert();
1110             } else {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex++);
1113                 } while (updatedIndex != end);
1114             }
1115             _currentIndex = updatedIndex;
1116         }
1117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118     }
1119 
1120     /**
1121      * @dev Transfers `tokenId` from `from` to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `tokenId` token must be owned by `from`.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _transfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) private {
1135         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1136 
1137         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1138             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1139             getApproved(tokenId) == _msgSender());
1140 
1141         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1142         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1143         if (to == address(0)) revert TransferToZeroAddress();
1144 
1145         _beforeTokenTransfers(from, to, tokenId, 1);
1146 
1147         // Clear approvals from the previous owner
1148         _approve(address(0), tokenId, prevOwnership.addr);
1149 
1150         // Underflow of the sender's balance is impossible because we check for
1151         // ownership above and the recipient's balance can't realistically overflow.
1152         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1153         unchecked {
1154             _addressData[from].balance -= 1;
1155             _addressData[to].balance += 1;
1156 
1157             _ownerships[tokenId].addr = to;
1158             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1159 
1160             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1161             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1162             uint256 nextTokenId = tokenId + 1;
1163             if (_ownerships[nextTokenId].addr == address(0)) {
1164                 // This will suffice for checking _exists(nextTokenId),
1165                 // as a burned slot cannot contain the zero address.
1166                 if (nextTokenId < _currentIndex) {
1167                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1168                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1169                 }
1170             }
1171         }
1172 
1173         emit Transfer(from, to, tokenId);
1174         _afterTokenTransfers(from, to, tokenId, 1);
1175     }
1176 
1177     /**
1178      * @dev Destroys `tokenId`.
1179      * The approval is cleared when the token is burned.
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must exist.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _burn(uint256 tokenId) internal virtual {
1188         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1189 
1190         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1191 
1192         // Clear approvals from the previous owner
1193         _approve(address(0), tokenId, prevOwnership.addr);
1194 
1195         // Underflow of the sender's balance is impossible because we check for
1196         // ownership above and the recipient's balance can't realistically overflow.
1197         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1198         unchecked {
1199             _addressData[prevOwnership.addr].balance -= 1;
1200             _addressData[prevOwnership.addr].numberBurned += 1;
1201 
1202             // Keep track of who burned the token, and the timestamp of burning.
1203             _ownerships[tokenId].addr = prevOwnership.addr;
1204             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1205             _ownerships[tokenId].burned = true;
1206 
1207             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1208             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1209             uint256 nextTokenId = tokenId + 1;
1210             if (_ownerships[nextTokenId].addr == address(0)) {
1211                 // This will suffice for checking _exists(nextTokenId),
1212                 // as a burned slot cannot contain the zero address.
1213                 if (nextTokenId < _currentIndex) {
1214                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1215                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1216                 }
1217             }
1218         }
1219 
1220         emit Transfer(prevOwnership.addr, address(0), tokenId);
1221         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1222 
1223         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1224         unchecked {
1225             _burnCounter++;
1226         }
1227     }
1228 
1229     /**
1230      * @dev Approve `to` to operate on `tokenId`
1231      *
1232      * Emits a {Approval} event.
1233      */
1234     function _approve(
1235         address to,
1236         uint256 tokenId,
1237         address owner
1238     ) private {
1239         _tokenApprovals[tokenId] = to;
1240         emit Approval(owner, to, tokenId);
1241     }
1242 
1243     /**
1244      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1245      *
1246      * @param from address representing the previous owner of the given token ID
1247      * @param to target address that will receive the tokens
1248      * @param tokenId uint256 ID of the token to be transferred
1249      * @param _data bytes optional data to send along with the call
1250      * @return bool whether the call correctly returned the expected magic value
1251      */
1252     function _checkContractOnERC721Received(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) private returns (bool) {
1258         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1259             return retval == IERC721Receiver(to).onERC721Received.selector;
1260         } catch (bytes memory reason) {
1261             if (reason.length == 0) {
1262                 revert TransferToNonERC721ReceiverImplementer();
1263             } else {
1264                 assembly {
1265                     revert(add(32, reason), mload(reason))
1266                 }
1267             }
1268         }
1269     }
1270 
1271     /**
1272      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1273      * And also called before burning one token.
1274      *
1275      * startTokenId - the first token id to be transferred
1276      * quantity - the amount to be transferred
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` will be minted for `to`.
1283      * - When `to` is zero, `tokenId` will be burned by `from`.
1284      * - `from` and `to` are never both zero.
1285      */
1286     function _beforeTokenTransfers(
1287         address from,
1288         address to,
1289         uint256 startTokenId,
1290         uint256 quantity
1291     ) internal virtual {}
1292 
1293     /**
1294      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1295      * minting.
1296      * And also called after one token has been burned.
1297      *
1298      * startTokenId - the first token id to be transferred
1299      * quantity - the amount to be transferred
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` has been minted for `to`.
1306      * - When `to` is zero, `tokenId` has been burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _afterTokenTransfers(
1310         address from,
1311         address to,
1312         uint256 startTokenId,
1313         uint256 quantity
1314     ) internal virtual {}
1315 }
1316 // File: @openzeppelin/contracts/access/Ownable.sol
1317 
1318 
1319 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 
1324 /**
1325  * @dev Contract module which provides a basic access control mechanism, where
1326  * there is an account (an owner) that can be granted exclusive access to
1327  * specific functions.
1328  *
1329  * By default, the owner account will be the one that deploys the contract. This
1330  * can later be changed with {transferOwnership}.
1331  *
1332  * This module is used through inheritance. It will make available the modifier
1333  * `onlyOwner`, which can be applied to your functions to restrict their use to
1334  * the owner.
1335  */
1336 abstract contract Ownable is Context {
1337     address private _owner;
1338 
1339     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1340 
1341     /**
1342      * @dev Initializes the contract setting the deployer as the initial owner.
1343      */
1344     constructor() {
1345         _transferOwnership(_msgSender());
1346     }
1347 
1348     /**
1349      * @dev Throws if called by any account other than the owner.
1350      */
1351     modifier onlyOwner() {
1352         _checkOwner();
1353         _;
1354     }
1355 
1356     /**
1357      * @dev Returns the address of the current owner.
1358      */
1359     function owner() public view virtual returns (address) {
1360         return _owner;
1361     }
1362 
1363     /**
1364      * @dev Throws if the sender is not the owner.
1365      */
1366     function _checkOwner() internal view virtual {
1367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1368     }
1369 
1370 
1371 
1372     /**
1373      * @dev Leaves the contract without owner. It will not be possible to call
1374      * `onlyOwner` functions anymore. Can only be called by the current owner.
1375      *
1376      * NOTE: Renouncing ownership will leave the contract without an owner,
1377      * thereby removing any functionality that is only available to the owner.
1378      */
1379     function renounceOwnership() public virtual onlyOwner {
1380         _transferOwnership(address(0));
1381     }
1382 
1383     /**
1384      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1385      * Can only be called by the current owner.
1386      */
1387     function transferOwnership(address newOwner) public virtual onlyOwner {
1388         require(newOwner != address(0), "Ownable: new owner is the zero address");
1389         _transferOwnership(newOwner);
1390     }
1391 
1392     /**
1393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1394      * Internal function without access restriction.
1395      */
1396     function _transferOwnership(address newOwner) internal virtual {
1397         address oldOwner = _owner;
1398         _owner = newOwner;
1399         emit OwnershipTransferred(oldOwner, newOwner);
1400     }
1401 }
1402 
1403 
1404 
1405 
1406 
1407 
1408 
1409 
1410 pragma solidity ^0.8.2;
1411 
1412 
1413 
1414 
1415 contract PepePunks is ERC721A, Ownable, ReentrancyGuard {
1416     enum Status {
1417         Waiting,
1418         Started,
1419         Finished
1420     }
1421     using Strings for uint256;
1422     bool public paused = false;
1423     string private revealedURI = "ipfs://QmbpNTkEEJ7e7xw5KLWb91njRiyhtcRTLBdcd7vXhuW8xP/";
1424     string private hiddenURI;
1425     uint256 public constant MAX_MINT_PER_ADDR = 4;
1426     uint256 public constant MAX_FREE_MINT_PER_ADDR = 2;
1427     uint256 public PUBLIC_PRICE = 0.0025 * 10**18;
1428     uint256 public constant MAX_SUPPLY = 6666;
1429     uint256 public constant FREE_MINT_SUPPLY = 3000;
1430     uint256 public INSTANT_FREE_MINTED = 1;
1431 
1432     bool public isPublicSaleActive = false;
1433 
1434 
1435     bool public revealed = true;
1436 
1437     event Minted(address minter, uint256 amount);
1438 
1439     constructor() ERC721A("Pepe Punks", "PPPKS") {}
1440 
1441     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1442         // Note: You don't REALLY need this require statement since nothing should be querying for non-existing tokens after reveal.
1443             // That said, it's a public view method so gas efficiency shouldn't come into play.
1444         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1445         
1446         if (revealed) {
1447             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1448         }
1449         else {
1450             return revealedURI;
1451         }
1452     }
1453 
1454     function setBaseURI(string memory _baseUri) public onlyOwner {
1455         revealedURI = _baseUri;
1456     }
1457 
1458     function setRevealed(bool _state) public onlyOwner {
1459         revealed = _state;
1460     }
1461 
1462     function revealCollection(bool _revealed, string memory _baseUri) public onlyOwner {
1463         revealed = _revealed;
1464         revealedURI = _baseUri;
1465     }
1466 
1467     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1468         hiddenURI = _hiddenMetadataUri;
1469     }
1470 
1471     function _startTokenId() internal view virtual override returns (uint256) {
1472         return 1;
1473     }
1474     
1475     function mint(uint256 quantity) external payable nonReentrant {
1476         require(isPublicSaleActive, "Public sale is not open");
1477         require(tx.origin == msg.sender, "-Contract call not allowed-");
1478         require(
1479             numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR,
1480             "-This is more than allowed-"
1481         );
1482         require(
1483             totalSupply() + quantity <= MAX_SUPPLY,
1484             "-Not enough quantity-"
1485         );
1486 
1487         uint256 _cost;
1488         if (INSTANT_FREE_MINTED < FREE_MINT_SUPPLY) {
1489             uint256 remainFreeAmont = (numberMinted(msg.sender) <
1490                 MAX_FREE_MINT_PER_ADDR)
1491                 ? (MAX_FREE_MINT_PER_ADDR - numberMinted(msg.sender))
1492                 : 0;
1493 
1494             _cost =
1495                 PUBLIC_PRICE *
1496                 (
1497                     (quantity <= remainFreeAmont)
1498                         ? 0
1499                         : (quantity - remainFreeAmont)
1500                 );
1501 
1502             INSTANT_FREE_MINTED += (
1503                 (quantity <= remainFreeAmont) ? quantity : remainFreeAmont
1504             );
1505         } else {
1506             _cost = PUBLIC_PRICE * quantity;
1507         }
1508         require(msg.value >= _cost, "-Not enough ETH-");
1509         _safeMint(msg.sender, quantity);
1510         emit Minted(msg.sender, quantity);
1511     }
1512 
1513     function numberMinted(address owner) public view returns (uint256) {
1514         return _numberMinted(owner);
1515     }
1516     
1517     
1518     
1519     function setIsPublicSaleActive(bool _isPublicSaleActive)
1520       external
1521       onlyOwner
1522   {
1523       isPublicSaleActive = _isPublicSaleActive;
1524   }
1525     
1526 
1527     function treasuryMint(uint quantity, address user)
1528     public
1529     onlyOwner
1530   {
1531     require(
1532       quantity > 0,
1533       "Invalid mint amount"
1534     );
1535     require(
1536       totalSupply() + quantity <= MAX_SUPPLY,
1537       "Maximum supply exceeded"
1538     );
1539     _safeMint(user, quantity);
1540   }
1541 
1542     function withdraw(address payable recipient)
1543         external
1544         onlyOwner
1545         nonReentrant
1546     {
1547         uint256 balance = address(this).balance;
1548         (bool success, ) = recipient.call{value: balance}("");
1549         require(success, "-Withdraw failed-");
1550     }
1551 
1552     function updatePrice(uint256 __price) external onlyOwner {
1553         PUBLIC_PRICE = __price;
1554     }
1555 }