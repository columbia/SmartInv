1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
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
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: @openzeppelin/contracts/utils/Address.sol
178 
179 
180 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
181 
182 pragma solidity ^0.8.1;
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      *
205      * [IMPORTANT]
206      * ====
207      * You shouldn't rely on `isContract` to protect against flash loan attacks!
208      *
209      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
210      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
211      * constructor.
212      * ====
213      */
214     function isContract(address account) internal view returns (bool) {
215         // This method relies on extcodesize/address.code.length, which returns 0
216         // for contracts in construction, since the code is only stored at the end
217         // of the constructor execution.
218 
219         return account.code.length > 0;
220     }
221 
222     /**
223      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
224      * `recipient`, forwarding all available gas and reverting on errors.
225      *
226      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
227      * of certain opcodes, possibly making contracts go over the 2300 gas limit
228      * imposed by `transfer`, making them unable to receive funds via
229      * `transfer`. {sendValue} removes this limitation.
230      *
231      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
232      *
233      * IMPORTANT: because control is transferred to `recipient`, care must be
234      * taken to not create reentrancy vulnerabilities. Consider using
235      * {ReentrancyGuard} or the
236      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
237      */
238     function sendValue(address payable recipient, uint256 amount) internal {
239         require(address(this).balance >= amount, "Address: insufficient balance");
240 
241         (bool success, ) = recipient.call{value: amount}("");
242         require(success, "Address: unable to send value, recipient may have reverted");
243     }
244 
245     /**
246      * @dev Performs a Solidity function call using a low level `call`. A
247      * plain `call` is an unsafe replacement for a function call: use this
248      * function instead.
249      *
250      * If `target` reverts with a revert reason, it is bubbled up by this
251      * function (like regular Solidity function calls).
252      *
253      * Returns the raw returned data. To convert to the expected return value,
254      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
255      *
256      * Requirements:
257      *
258      * - `target` must be a contract.
259      * - calling `target` with `data` must not revert.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionCall(target, data, "Address: low-level call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
269      * `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, 0, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but also transferring `value` wei to `target`.
284      *
285      * Requirements:
286      *
287      * - the calling contract must have an ETH balance of at least `value`.
288      * - the called Solidity function must be `payable`.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
302      * with `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         require(address(this).balance >= value, "Address: insufficient balance for call");
313         require(isContract(target), "Address: call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.call{value: value}(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
326         return functionStaticCall(target, data, "Address: low-level static call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal view returns (bytes memory) {
340         require(isContract(target), "Address: static call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(isContract(target), "Address: delegate call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.delegatecall(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
375      * revert reason using the provided one.
376      *
377      * _Available since v4.3._
378      */
379     function verifyCallResult(
380         bool success,
381         bytes memory returndata,
382         string memory errorMessage
383     ) internal pure returns (bytes memory) {
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
403 
404 
405 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @title ERC721 token receiver interface
411  * @dev Interface for any contract that wants to support safeTransfers
412  * from ERC721 asset contracts.
413  */
414 interface IERC721Receiver {
415     /**
416      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
417      * by `operator` from `from`, this function is called.
418      *
419      * It must return its Solidity selector to confirm the token transfer.
420      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
421      *
422      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
423      */
424     function onERC721Received(
425         address operator,
426         address from,
427         uint256 tokenId,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Interface of the ERC165 standard, as defined in the
441  * https://eips.ethereum.org/EIPS/eip-165[EIP].
442  *
443  * Implementers can declare support of contract interfaces, which can then be
444  * queried by others ({ERC165Checker}).
445  *
446  * For an implementation, see {ERC165}.
447  */
448 interface IERC165 {
449     /**
450      * @dev Returns true if this contract implements the interface defined by
451      * `interfaceId`. See the corresponding
452      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
453      * to learn more about how these ids are created.
454      *
455      * This function call must use less than 30 000 gas.
456      */
457     function supportsInterface(bytes4 interfaceId) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev Implementation of the {IERC165} interface.
470  *
471  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
472  * for the additional interface id that will be supported. For example:
473  *
474  * ```solidity
475  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
476  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
477  * }
478  * ```
479  *
480  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
481  */
482 abstract contract ERC165 is IERC165 {
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487         return interfaceId == type(IERC165).interfaceId;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
492 
493 
494 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @dev Required interface of an ERC721 compliant contract.
501  */
502 interface IERC721 is IERC165 {
503     /**
504      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
505      */
506     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
510      */
511     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
515      */
516     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
517 
518     /**
519      * @dev Returns the number of tokens in ``owner``'s account.
520      */
521     function balanceOf(address owner) external view returns (uint256 balance);
522 
523     /**
524      * @dev Returns the owner of the `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function ownerOf(uint256 tokenId) external view returns (address owner);
531 
532     /**
533      * @dev Safely transfers `tokenId` token from `from` to `to`.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId,
549         bytes calldata data
550     ) external;
551 
552     /**
553      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
554      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Transfers `tokenId` token from `from` to `to`.
574      *
575      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must be owned by `from`.
582      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
583      *
584      * Emits a {Transfer} event.
585      */
586     function transferFrom(
587         address from,
588         address to,
589         uint256 tokenId
590     ) external;
591 
592     /**
593      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
594      * The approval is cleared when the token is transferred.
595      *
596      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
597      *
598      * Requirements:
599      *
600      * - The caller must own the token or be an approved operator.
601      * - `tokenId` must exist.
602      *
603      * Emits an {Approval} event.
604      */
605     function approve(address to, uint256 tokenId) external;
606 
607     /**
608      * @dev Approve or remove `operator` as an operator for the caller.
609      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
610      *
611      * Requirements:
612      *
613      * - The `operator` cannot be the caller.
614      *
615      * Emits an {ApprovalForAll} event.
616      */
617     function setApprovalForAll(address operator, bool _approved) external;
618 
619     /**
620      * @dev Returns the account approved for `tokenId` token.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      */
626     function getApproved(uint256 tokenId) external view returns (address operator);
627 
628     /**
629      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
630      *
631      * See {setApprovalForAll}
632      */
633     function isApprovedForAll(address owner, address operator) external view returns (bool);
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
646  * @dev See https://eips.ethereum.org/EIPS/eip-721
647  */
648 interface IERC721Metadata is IERC721 {
649     /**
650      * @dev Returns the token collection name.
651      */
652     function name() external view returns (string memory);
653 
654     /**
655      * @dev Returns the token collection symbol.
656      */
657     function symbol() external view returns (string memory);
658 
659     /**
660      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
661      */
662     function tokenURI(uint256 tokenId) external view returns (string memory);
663 }
664 
665 // File: erc721a/contracts/IERC721A.sol
666 
667 
668 // ERC721A Contracts v3.3.0
669 // Creator: Chiru Labs
670 
671 pragma solidity ^0.8.4;
672 
673 
674 
675 /**
676  * @dev Interface of an ERC721A compliant contract.
677  */
678 interface IERC721A is IERC721, IERC721Metadata {
679     /**
680      * The caller must own the token or be an approved operator.
681      */
682     error ApprovalCallerNotOwnerNorApproved();
683 
684     /**
685      * The token does not exist.
686      */
687     error ApprovalQueryForNonexistentToken();
688 
689     /**
690      * The caller cannot approve to their own address.
691      */
692     error ApproveToCaller();
693 
694     /**
695      * The caller cannot approve to the current owner.
696      */
697     error ApprovalToCurrentOwner();
698 
699     /**
700      * Cannot query the balance for the zero address.
701      */
702     error BalanceQueryForZeroAddress();
703 
704     /**
705      * Cannot mint to the zero address.
706      */
707     error MintToZeroAddress();
708 
709     /**
710      * The quantity of tokens minted must be more than zero.
711      */
712     error MintZeroQuantity();
713 
714     /**
715      * The token does not exist.
716      */
717     error OwnerQueryForNonexistentToken();
718 
719     /**
720      * The caller must own the token or be an approved operator.
721      */
722     error TransferCallerNotOwnerNorApproved();
723 
724     /**
725      * The token must be owned by `from`.
726      */
727     error TransferFromIncorrectOwner();
728 
729     /**
730      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
731      */
732     error TransferToNonERC721ReceiverImplementer();
733 
734     /**
735      * Cannot transfer to the zero address.
736      */
737     error TransferToZeroAddress();
738 
739     /**
740      * The token does not exist.
741      */
742     error URIQueryForNonexistentToken();
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
768     /**
769      * @dev Returns the total amount of tokens stored by the contract.
770      * 
771      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
772      */
773     function totalSupply() external view returns (uint256);
774 }
775 
776 // File: erc721a/contracts/ERC721A.sol
777 
778 
779 // ERC721A Contracts v3.3.0
780 // Creator: Chiru Labs
781 
782 pragma solidity ^0.8.4;
783 
784 
785 
786 
787 
788 
789 
790 /**
791  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
792  * the Metadata extension. Built to optimize for lower gas during batch mints.
793  *
794  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
795  *
796  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
797  *
798  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
799  */
800 contract ERC721A is Context, ERC165, IERC721A {
801     using Address for address;
802     using Strings for uint256;
803 
804     // The tokenId of the next token to be minted.
805     uint256 internal _currentIndex;
806 
807     // The number of tokens burned.
808     uint256 internal _burnCounter;
809 
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     // Mapping from token ID to ownership details
817     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
818     mapping(uint256 => TokenOwnership) internal _ownerships;
819 
820     // Mapping owner address to address data
821     mapping(address => AddressData) private _addressData;
822 
823     // Mapping from token ID to approved address
824     mapping(uint256 => address) private _tokenApprovals;
825 
826     // Mapping from owner to operator approvals
827     mapping(address => mapping(address => bool)) private _operatorApprovals;
828 
829     constructor(string memory name_, string memory symbol_) {
830         _name = name_;
831         _symbol = symbol_;
832         _currentIndex = _startTokenId();
833     }
834 
835     /**
836      * To change the starting tokenId, please override this function.
837      */
838     function _startTokenId() internal view virtual returns (uint256) {
839         return 0;
840     }
841 
842     /**
843      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
844      */
845     function totalSupply() public view override returns (uint256) {
846         // Counter underflow is impossible as _burnCounter cannot be incremented
847         // more than _currentIndex - _startTokenId() times
848         unchecked {
849             return _currentIndex - _burnCounter - _startTokenId();
850         }
851     }
852 
853     /**
854      * Returns the total amount of tokens minted in the contract.
855      */
856     function _totalMinted() internal view returns (uint256) {
857         // Counter underflow is impossible as _currentIndex does not decrement,
858         // and it is initialized to _startTokenId()
859         unchecked {
860             return _currentIndex - _startTokenId();
861         }
862     }
863 
864     /**
865      * @dev See {IERC165-supportsInterface}.
866      */
867     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
868         return
869             interfaceId == type(IERC721).interfaceId ||
870             interfaceId == type(IERC721Metadata).interfaceId ||
871             super.supportsInterface(interfaceId);
872     }
873 
874     /**
875      * @dev See {IERC721-balanceOf}.
876      */
877     function balanceOf(address owner) public view override returns (uint256) {
878         if (owner == address(0)) revert BalanceQueryForZeroAddress();
879         return uint256(_addressData[owner].balance);
880     }
881 
882     /**
883      * Returns the number of tokens minted by `owner`.
884      */
885     function _numberMinted(address owner) internal view returns (uint256) {
886         return uint256(_addressData[owner].numberMinted);
887     }
888 
889     /**
890      * Returns the number of tokens burned by or on behalf of `owner`.
891      */
892     function _numberBurned(address owner) internal view returns (uint256) {
893         return uint256(_addressData[owner].numberBurned);
894     }
895 
896     /**
897      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
898      */
899     function _getAux(address owner) internal view returns (uint64) {
900         return _addressData[owner].aux;
901     }
902 
903     /**
904      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
905      * If there are multiple variables, please pack them into a uint64.
906      */
907     function _setAux(address owner, uint64 aux) internal {
908         _addressData[owner].aux = aux;
909     }
910 
911     /**
912      * Gas spent here starts off proportional to the maximum mint batch size.
913      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
914      */
915     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
916         uint256 curr = tokenId;
917 
918         unchecked {
919             if (_startTokenId() <= curr) if (curr < _currentIndex) {
920                 TokenOwnership memory ownership = _ownerships[curr];
921                 if (!ownership.burned) {
922                     if (ownership.addr != address(0)) {
923                         return ownership;
924                     }
925                     // Invariant:
926                     // There will always be an ownership that has an address and is not burned
927                     // before an ownership that does not have an address and is not burned.
928                     // Hence, curr will not underflow.
929                     while (true) {
930                         curr--;
931                         ownership = _ownerships[curr];
932                         if (ownership.addr != address(0)) {
933                             return ownership;
934                         }
935                     }
936                 }
937             }
938         }
939         revert OwnerQueryForNonexistentToken();
940     }
941 
942     /**
943      * @dev See {IERC721-ownerOf}.
944      */
945     function ownerOf(uint256 tokenId) public view override returns (address) {
946         return _ownershipOf(tokenId).addr;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-name}.
951      */
952     function name() public view virtual override returns (string memory) {
953         return _name;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-symbol}.
958      */
959     function symbol() public view virtual override returns (string memory) {
960         return _symbol;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-tokenURI}.
965      */
966     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
967         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
968 
969         string memory baseURI = _baseURI();
970         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
971     }
972 
973     /**
974      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
975      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
976      * by default, can be overriden in child contracts.
977      */
978     function _baseURI() internal view virtual returns (string memory) {
979         return '';
980     }
981 
982     /**
983      * @dev See {IERC721-approve}.
984      */
985     function approve(address to, uint256 tokenId) public override {
986         address owner = ERC721A.ownerOf(tokenId);
987         if (to == owner) revert ApprovalToCurrentOwner();
988 
989         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
990             revert ApprovalCallerNotOwnerNorApproved();
991         }
992 
993         _approve(to, tokenId, owner);
994     }
995 
996     /**
997      * @dev See {IERC721-getApproved}.
998      */
999     function getApproved(uint256 tokenId) public view override returns (address) {
1000         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1001 
1002         return _tokenApprovals[tokenId];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-setApprovalForAll}.
1007      */
1008     function setApprovalForAll(address operator, bool approved) public virtual override {
1009         if (operator == _msgSender()) revert ApproveToCaller();
1010 
1011         _operatorApprovals[_msgSender()][operator] = approved;
1012         emit ApprovalForAll(_msgSender(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-isApprovedForAll}.
1017      */
1018     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1019         return _operatorApprovals[owner][operator];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-transferFrom}.
1024      */
1025     function transferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         _transfer(from, to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         safeTransferFrom(from, to, tokenId, '');
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) public virtual override {
1053         _transfer(from, to, tokenId);
1054         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1055             revert TransferToNonERC721ReceiverImplementer();
1056         }
1057     }
1058 
1059     /**
1060      * @dev Returns whether `tokenId` exists.
1061      *
1062      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1063      *
1064      * Tokens start existing when they are minted (`_mint`),
1065      */
1066     function _exists(uint256 tokenId) internal view returns (bool) {
1067         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1068     }
1069 
1070     /**
1071      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1072      */
1073     function _safeMint(address to, uint256 quantity) internal {
1074         _safeMint(to, quantity, '');
1075     }
1076 
1077     /**
1078      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - If `to` refers to a smart contract, it must implement
1083      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1084      * - `quantity` must be greater than 0.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _safeMint(
1089         address to,
1090         uint256 quantity,
1091         bytes memory _data
1092     ) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1101         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1102         unchecked {
1103             _addressData[to].balance += uint64(quantity);
1104             _addressData[to].numberMinted += uint64(quantity);
1105 
1106             _ownerships[startTokenId].addr = to;
1107             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1108 
1109             uint256 updatedIndex = startTokenId;
1110             uint256 end = updatedIndex + quantity;
1111 
1112             if (to.isContract()) {
1113                 do {
1114                     emit Transfer(address(0), to, updatedIndex);
1115                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1116                         revert TransferToNonERC721ReceiverImplementer();
1117                     }
1118                 } while (updatedIndex < end);
1119                 // Reentrancy protection
1120                 if (_currentIndex != startTokenId) revert();
1121             } else {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex++);
1124                 } while (updatedIndex < end);
1125             }
1126             _currentIndex = updatedIndex;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Mints `quantity` tokens and transfers them to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `quantity` must be greater than 0.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _mint(address to, uint256 quantity) internal {
1142         uint256 startTokenId = _currentIndex;
1143         if (to == address(0)) revert MintToZeroAddress();
1144         if (quantity == 0) revert MintZeroQuantity();
1145 
1146         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1147 
1148         // Overflows are incredibly unrealistic.
1149         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1150         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1151         unchecked {
1152             _addressData[to].balance += uint64(quantity);
1153             _addressData[to].numberMinted += uint64(quantity);
1154 
1155             _ownerships[startTokenId].addr = to;
1156             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1157 
1158             uint256 updatedIndex = startTokenId;
1159             uint256 end = updatedIndex + quantity;
1160 
1161             do {
1162                 emit Transfer(address(0), to, updatedIndex++);
1163             } while (updatedIndex < end);
1164 
1165             _currentIndex = updatedIndex;
1166         }
1167         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1168     }
1169 
1170     /**
1171      * @dev Transfers `tokenId` from `from` to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must be owned by `from`.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _transfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) private {
1185         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1186 
1187         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1188 
1189         bool isApprovedOrOwner = (_msgSender() == from ||
1190             isApprovedForAll(from, _msgSender()) ||
1191             getApproved(tokenId) == _msgSender());
1192 
1193         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1194         if (to == address(0)) revert TransferToZeroAddress();
1195 
1196         _beforeTokenTransfers(from, to, tokenId, 1);
1197 
1198         // Clear approvals from the previous owner
1199         _approve(address(0), tokenId, from);
1200 
1201         // Underflow of the sender's balance is impossible because we check for
1202         // ownership above and the recipient's balance can't realistically overflow.
1203         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1204         unchecked {
1205             _addressData[from].balance -= 1;
1206             _addressData[to].balance += 1;
1207 
1208             TokenOwnership storage currSlot = _ownerships[tokenId];
1209             currSlot.addr = to;
1210             currSlot.startTimestamp = uint64(block.timestamp);
1211 
1212             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1213             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1214             uint256 nextTokenId = tokenId + 1;
1215             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1216             if (nextSlot.addr == address(0)) {
1217                 // This will suffice for checking _exists(nextTokenId),
1218                 // as a burned slot cannot contain the zero address.
1219                 if (nextTokenId != _currentIndex) {
1220                     nextSlot.addr = from;
1221                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1222                 }
1223             }
1224         }
1225 
1226         emit Transfer(from, to, tokenId);
1227         _afterTokenTransfers(from, to, tokenId, 1);
1228     }
1229 
1230     /**
1231      * @dev Equivalent to `_burn(tokenId, false)`.
1232      */
1233     function _burn(uint256 tokenId) internal virtual {
1234         _burn(tokenId, false);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1248         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1249 
1250         address from = prevOwnership.addr;
1251 
1252         if (approvalCheck) {
1253             bool isApprovedOrOwner = (_msgSender() == from ||
1254                 isApprovedForAll(from, _msgSender()) ||
1255                 getApproved(tokenId) == _msgSender());
1256 
1257             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1258         }
1259 
1260         _beforeTokenTransfers(from, address(0), tokenId, 1);
1261 
1262         // Clear approvals from the previous owner
1263         _approve(address(0), tokenId, from);
1264 
1265         // Underflow of the sender's balance is impossible because we check for
1266         // ownership above and the recipient's balance can't realistically overflow.
1267         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1268         unchecked {
1269             AddressData storage addressData = _addressData[from];
1270             addressData.balance -= 1;
1271             addressData.numberBurned += 1;
1272 
1273             // Keep track of who burned the token, and the timestamp of burning.
1274             TokenOwnership storage currSlot = _ownerships[tokenId];
1275             currSlot.addr = from;
1276             currSlot.startTimestamp = uint64(block.timestamp);
1277             currSlot.burned = true;
1278 
1279             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1280             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1281             uint256 nextTokenId = tokenId + 1;
1282             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1283             if (nextSlot.addr == address(0)) {
1284                 // This will suffice for checking _exists(nextTokenId),
1285                 // as a burned slot cannot contain the zero address.
1286                 if (nextTokenId != _currentIndex) {
1287                     nextSlot.addr = from;
1288                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1289                 }
1290             }
1291         }
1292 
1293         emit Transfer(from, address(0), tokenId);
1294         _afterTokenTransfers(from, address(0), tokenId, 1);
1295 
1296         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1297         unchecked {
1298             _burnCounter++;
1299         }
1300     }
1301 
1302     /**
1303      * @dev Approve `to` to operate on `tokenId`
1304      *
1305      * Emits a {Approval} event.
1306      */
1307     function _approve(
1308         address to,
1309         uint256 tokenId,
1310         address owner
1311     ) private {
1312         _tokenApprovals[tokenId] = to;
1313         emit Approval(owner, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1318      *
1319      * @param from address representing the previous owner of the given token ID
1320      * @param to target address that will receive the tokens
1321      * @param tokenId uint256 ID of the token to be transferred
1322      * @param _data bytes optional data to send along with the call
1323      * @return bool whether the call correctly returned the expected magic value
1324      */
1325     function _checkContractOnERC721Received(
1326         address from,
1327         address to,
1328         uint256 tokenId,
1329         bytes memory _data
1330     ) private returns (bool) {
1331         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1332             return retval == IERC721Receiver(to).onERC721Received.selector;
1333         } catch (bytes memory reason) {
1334             if (reason.length == 0) {
1335                 revert TransferToNonERC721ReceiverImplementer();
1336             } else {
1337                 assembly {
1338                     revert(add(32, reason), mload(reason))
1339                 }
1340             }
1341         }
1342     }
1343 
1344     /**
1345      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1346      * And also called before burning one token.
1347      *
1348      * startTokenId - the first token id to be transferred
1349      * quantity - the amount to be transferred
1350      *
1351      * Calling conditions:
1352      *
1353      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1354      * transferred to `to`.
1355      * - When `from` is zero, `tokenId` will be minted for `to`.
1356      * - When `to` is zero, `tokenId` will be burned by `from`.
1357      * - `from` and `to` are never both zero.
1358      */
1359     function _beforeTokenTransfers(
1360         address from,
1361         address to,
1362         uint256 startTokenId,
1363         uint256 quantity
1364     ) internal virtual {}
1365 
1366     /**
1367      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1368      * minting.
1369      * And also called after one token has been burned.
1370      *
1371      * startTokenId - the first token id to be transferred
1372      * quantity - the amount to be transferred
1373      *
1374      * Calling conditions:
1375      *
1376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1377      * transferred to `to`.
1378      * - When `from` is zero, `tokenId` has been minted for `to`.
1379      * - When `to` is zero, `tokenId` has been burned by `from`.
1380      * - `from` and `to` are never both zero.
1381      */
1382     function _afterTokenTransfers(
1383         address from,
1384         address to,
1385         uint256 startTokenId,
1386         uint256 quantity
1387     ) internal virtual {}
1388 }
1389 
1390 // File: okaypaintbears_flat.sol
1391 
1392 
1393 
1394 pragma solidity ^0.8.4;
1395 
1396 
1397 
1398 
1399 contract okay_paint_bears is ERC721A, Ownable {
1400     uint256 public MAX_MINTS = 21;
1401     uint256 public MAX_PER_TX = 6;
1402     uint256 public MAX_SUPPLY;
1403     uint256 public mintRate = 0.0069 ether;
1404     bool    public saleIsActive = true;
1405     using Strings for uint256;
1406     string public baseURI;
1407 
1408     constructor(
1409         string memory name,
1410         string memory symbol,
1411         string memory baseTokenURI_,
1412         uint256 maxSupply_
1413     ) ERC721A(name, symbol) {
1414         require(maxSupply_ > 0, "INVALID_SUPPLY");
1415         baseURI = baseTokenURI_;
1416         MAX_SUPPLY = maxSupply_;
1417     }
1418 
1419     function mint(uint256 quantity) external payable {
1420         // _safeMint's second argument now takes in a quantity, not a tokenId.
1421         require(saleIsActive, "Sale must be active to mint");
1422         require(quantity < MAX_PER_TX, "Exceeded the TX limit");
1423         require(quantity + _numberMinted(msg.sender) < MAX_MINTS, "Exceeded the wallet limit");
1424         require(totalSupply() + quantity < MAX_SUPPLY, "Not enough tokens left");
1425         require(msg.value >= (mintRate * quantity), "Not enough ether sent");
1426         _safeMint(msg.sender, quantity);
1427     }
1428 
1429     function setWalletLimit(uint256 _newWalletLimit) public onlyOwner{
1430         MAX_MINTS = _newWalletLimit;
1431     }
1432 
1433     function setTXLimit(uint256 _newTXLimit) public onlyOwner{
1434         MAX_PER_TX = _newTXLimit;
1435     }
1436 
1437     function setMintRate(uint256 _mintRate) public onlyOwner {
1438         mintRate = _mintRate;
1439     }
1440     function withdraw() external payable onlyOwner {
1441         payable(owner()).transfer(address(this).balance);
1442     }
1443 
1444     function _baseURI() internal view override returns (string memory) {
1445         return baseURI;
1446     }
1447 
1448     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1449         require(_exists(tokenId), "URI query for nonexistent token");
1450 
1451         return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
1452     }
1453 
1454     function changeSupplyAmount (uint256 _amount) public onlyOwner () {
1455         MAX_SUPPLY = _amount;
1456     }
1457 
1458     function flipSaleState() public onlyOwner {
1459         saleIsActive = !saleIsActive;
1460     }  
1461 }