1 // SPDX-License-Identifier: MIT
2 
3 
4 //  _____                 ______                            _____ _       _     
5 // |  ___|                |  _  \                          /  __ \ |     | |    
6 // | |__  ___ ___  _ __   | | | |___  __ _  ___ _ __  ___  | /  \/ |_   _| |__  
7 // |  __|/ __/ _ \| '_ \  | | | / _ \/ _` |/ _ \ '_ \/ __| | |   | | | | | '_ \ 
8 // | |__| (_| (_) | | | | | |/ /  __/ (_| |  __/ | | \__ \ | \__/\ | |_| | |_) |
9 // \____/\___\___/|_| |_| |___/ \___|\__, |\___|_| |_|___/  \____/_|\__,_|_.__/ 
10 //                                    __/ |                                     
11 //                                   |___/                                                                                                                                                                                                                                                                                                                                                                                                                              
12 
13 // File: @openzeppelin/contracts/utils/Strings.sol
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21 
22     /**
23      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
24      */
25     function toString(uint256 value) internal pure returns (string memory) {
26         // Inspired by OraclizeAPI's implementation - MIT licence
27         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
28 
29         if (value == 0) {
30             return "0";
31         }
32         uint256 temp = value;
33         uint256 digits;
34         while (temp != 0) {
35             digits++;
36             temp /= 10;
37         }
38         bytes memory buffer = new bytes(digits);
39         while (value != 0) {
40             digits -= 1;
41             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
42             value /= 10;
43         }
44         return string(buffer);
45     }
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
49      */
50     function toHexString(uint256 value) internal pure returns (string memory) {
51         if (value == 0) {
52             return "0x00";
53         }
54         uint256 temp = value;
55         uint256 length = 0;
56         while (temp != 0) {
57             length++;
58             temp >>= 8;
59         }
60         return toHexString(value, length);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
65      */
66     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/access/Ownable.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _transferOwnership(_msgSender());
136     }
137 
138     /**
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view virtual returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         _transferOwnership(address(0));
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Can only be called by the current owner.
167      */
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         _transferOwnership(newOwner);
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Internal function without access restriction.
176      */
177     function _transferOwnership(address newOwner) internal virtual {
178         address oldOwner = _owner;
179         _owner = newOwner;
180         emit OwnershipTransferred(oldOwner, newOwner);
181     }
182 }
183 
184 // File: @openzeppelin/contracts/utils/Address.sol
185 
186 
187 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
188 
189 pragma solidity ^0.8.1;
190 
191 /**
192  * @dev Collection of functions related to the address type
193  */
194 library Address {
195     /**
196      * @dev Returns true if `account` is a contract.
197      *
198      * [IMPORTANT]
199      * ====
200      * It is unsafe to assume that an address for which this function returns
201      * false is an externally-owned account (EOA) and not a contract.
202      *
203      * Among others, `isContract` will return false for the following
204      * types of addresses:
205      *
206      *  - an externally-owned account
207      *  - a contract in construction
208      *  - an address where a contract will be created
209      *  - an address where a contract lived, but was destroyed
210      * ====
211      *
212      * [IMPORTANT]
213      * ====
214      * You shouldn't rely on `isContract` to protect against flash loan attacks!
215      *
216      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
217      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
218      * constructor.
219      * ====
220      */
221     function isContract(address account) internal view returns (bool) {
222         // This method relies on extcodesize/address.code.length, which returns 0
223         // for contracts in construction, since the code is only stored at the end
224         // of the constructor execution.
225 
226         return account.code.length > 0;
227     }
228 
229     /**
230      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
231      * `recipient`, forwarding all available gas and reverting on errors.
232      *
233      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
234      * of certain opcodes, possibly making contracts go over the 2300 gas limit
235      * imposed by `transfer`, making them unable to receive funds via
236      * `transfer`. {sendValue} removes this limitation.
237      *
238      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
239      *
240      * IMPORTANT: because control is transferred to `recipient`, care must be
241      * taken to not create reentrancy vulnerabilities. Consider using
242      * {ReentrancyGuard} or the
243      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
244      */
245     function sendValue(address payable recipient, uint256 amount) internal {
246         require(address(this).balance >= amount, "Address: insufficient balance");
247 
248         (bool success, ) = recipient.call{value: amount}("");
249         require(success, "Address: unable to send value, recipient may have reverted");
250     }
251 
252     /**
253      * @dev Performs a Solidity function call using a low level `call`. A
254      * plain `call` is an unsafe replacement for a function call: use this
255      * function instead.
256      *
257      * If `target` reverts with a revert reason, it is bubbled up by this
258      * function (like regular Solidity function calls).
259      *
260      * Returns the raw returned data. To convert to the expected return value,
261      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
262      *
263      * Requirements:
264      *
265      * - `target` must be a contract.
266      * - calling `target` with `data` must not revert.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionCall(target, data, "Address: low-level call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
276      * `errorMessage` as a fallback revert reason when `target` reverts.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, 0, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but also transferring `value` wei to `target`.
291      *
292      * Requirements:
293      *
294      * - the calling contract must have an ETH balance of at least `value`.
295      * - the called Solidity function must be `payable`.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value
303     ) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
309      * with `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         require(address(this).balance >= value, "Address: insufficient balance for call");
320         require(isContract(target), "Address: call to non-contract");
321 
322         (bool success, bytes memory returndata) = target.call{value: value}(data);
323         return verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
333         return functionStaticCall(target, data, "Address: low-level static call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal view returns (bytes memory) {
347         require(isContract(target), "Address: static call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.staticcall(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(isContract(target), "Address: delegate call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
382      * revert reason using the provided one.
383      *
384      * _Available since v4.3._
385      */
386     function verifyCallResult(
387         bool success,
388         bytes memory returndata,
389         string memory errorMessage
390     ) internal pure returns (bytes memory) {
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
410 
411 
412 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 /**
417  * @title ERC721 token receiver interface
418  * @dev Interface for any contract that wants to support safeTransfers
419  * from ERC721 asset contracts.
420  */
421 interface IERC721Receiver {
422     /**
423      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
424      * by `operator` from `from`, this function is called.
425      *
426      * It must return its Solidity selector to confirm the token transfer.
427      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
428      *
429      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
430      */
431     function onERC721Received(
432         address operator,
433         address from,
434         uint256 tokenId,
435         bytes calldata data
436     ) external returns (bytes4);
437 }
438 
439 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Interface of the ERC165 standard, as defined in the
448  * https://eips.ethereum.org/EIPS/eip-165[EIP].
449  *
450  * Implementers can declare support of contract interfaces, which can then be
451  * queried by others ({ERC165Checker}).
452  *
453  * For an implementation, see {ERC165}.
454  */
455 interface IERC165 {
456     /**
457      * @dev Returns true if this contract implements the interface defined by
458      * `interfaceId`. See the corresponding
459      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
460      * to learn more about how these ids are created.
461      *
462      * This function call must use less than 30 000 gas.
463      */
464     function supportsInterface(bytes4 interfaceId) external view returns (bool);
465 }
466 
467 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 
475 /**
476  * @dev Implementation of the {IERC165} interface.
477  *
478  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
479  * for the additional interface id that will be supported. For example:
480  *
481  * ```solidity
482  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
484  * }
485  * ```
486  *
487  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
488  */
489 abstract contract ERC165 is IERC165 {
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494         return interfaceId == type(IERC165).interfaceId;
495     }
496 }
497 
498 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
499 
500 
501 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 
506 /**
507  * @dev Required interface of an ERC721 compliant contract.
508  */
509 interface IERC721 is IERC165 {
510     /**
511      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
512      */
513     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
514 
515     /**
516      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
517      */
518     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
519 
520     /**
521      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
522      */
523     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
524 
525     /**
526      * @dev Returns the number of tokens in ``owner``'s account.
527      */
528     function balanceOf(address owner) external view returns (uint256 balance);
529 
530     /**
531      * @dev Returns the owner of the `tokenId` token.
532      *
533      * Requirements:
534      *
535      * - `tokenId` must exist.
536      */
537     function ownerOf(uint256 tokenId) external view returns (address owner);
538 
539     /**
540      * @dev Safely transfers `tokenId` token from `from` to `to`.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must exist and be owned by `from`.
547      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
548      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
549      *
550      * Emits a {Transfer} event.
551      */
552     function safeTransferFrom(
553         address from,
554         address to,
555         uint256 tokenId,
556         bytes calldata data
557     ) external;
558 
559     /**
560      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
561      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570      *
571      * Emits a {Transfer} event.
572      */
573     function safeTransferFrom(
574         address from,
575         address to,
576         uint256 tokenId
577     ) external;
578 
579     /**
580      * @dev Transfers `tokenId` token from `from` to `to`.
581      *
582      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must be owned by `from`.
589      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
590      *
591      * Emits a {Transfer} event.
592      */
593     function transferFrom(
594         address from,
595         address to,
596         uint256 tokenId
597     ) external;
598 
599     /**
600      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
601      * The approval is cleared when the token is transferred.
602      *
603      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
604      *
605      * Requirements:
606      *
607      * - The caller must own the token or be an approved operator.
608      * - `tokenId` must exist.
609      *
610      * Emits an {Approval} event.
611      */
612     function approve(address to, uint256 tokenId) external;
613 
614     /**
615      * @dev Approve or remove `operator` as an operator for the caller.
616      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
617      *
618      * Requirements:
619      *
620      * - The `operator` cannot be the caller.
621      *
622      * Emits an {ApprovalForAll} event.
623      */
624     function setApprovalForAll(address operator, bool _approved) external;
625 
626     /**
627      * @dev Returns the account approved for `tokenId` token.
628      *
629      * Requirements:
630      *
631      * - `tokenId` must exist.
632      */
633     function getApproved(uint256 tokenId) external view returns (address operator);
634 
635     /**
636      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
637      *
638      * See {setApprovalForAll}
639      */
640     function isApprovedForAll(address owner, address operator) external view returns (bool);
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
644 
645 
646 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 
651 /**
652  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
653  * @dev See https://eips.ethereum.org/EIPS/eip-721
654  */
655 interface IERC721Metadata is IERC721 {
656     /**
657      * @dev Returns the token collection name.
658      */
659     function name() external view returns (string memory);
660 
661     /**
662      * @dev Returns the token collection symbol.
663      */
664     function symbol() external view returns (string memory);
665 
666     /**
667      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
668      */
669     function tokenURI(uint256 tokenId) external view returns (string memory);
670 }
671 
672 // File: erc721a/contracts/IERC721A.sol
673 
674 
675 // ERC721A Contracts v3.3.0
676 // Creator: Chiru Labs
677 
678 pragma solidity ^0.8.4;
679 
680 
681 
682 /**
683  * @dev Interface of an ERC721A compliant contract.
684  */
685 interface IERC721A is IERC721, IERC721Metadata {
686     /**
687      * The caller must own the token or be an approved operator.
688      */
689     error ApprovalCallerNotOwnerNorApproved();
690 
691     /**
692      * The token does not exist.
693      */
694     error ApprovalQueryForNonexistentToken();
695 
696     /**
697      * The caller cannot approve to their own address.
698      */
699     error ApproveToCaller();
700 
701     /**
702      * The caller cannot approve to the current owner.
703      */
704     error ApprovalToCurrentOwner();
705 
706     /**
707      * Cannot query the balance for the zero address.
708      */
709     error BalanceQueryForZeroAddress();
710 
711     /**
712      * Cannot mint to the zero address.
713      */
714     error MintToZeroAddress();
715 
716     /**
717      * The quantity of tokens minted must be more than zero.
718      */
719     error MintZeroQuantity();
720 
721     /**
722      * The token does not exist.
723      */
724     error OwnerQueryForNonexistentToken();
725 
726     /**
727      * The caller must own the token or be an approved operator.
728      */
729     error TransferCallerNotOwnerNorApproved();
730 
731     /**
732      * The token must be owned by `from`.
733      */
734     error TransferFromIncorrectOwner();
735 
736     /**
737      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
738      */
739     error TransferToNonERC721ReceiverImplementer();
740 
741     /**
742      * Cannot transfer to the zero address.
743      */
744     error TransferToZeroAddress();
745 
746     /**
747      * The token does not exist.
748      */
749     error URIQueryForNonexistentToken();
750 
751     // Compiler will pack this into a single 256bit word.
752     struct TokenOwnership {
753         // The address of the owner.
754         address addr;
755         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
756         uint64 startTimestamp;
757         // Whether the token has been burned.
758         bool burned;
759     }
760 
761     // Compiler will pack this into a single 256bit word.
762     struct AddressData {
763         // Realistically, 2**64-1 is more than enough.
764         uint64 balance;
765         // Keeps track of mint count with minimal overhead for tokenomics.
766         uint64 numberMinted;
767         // Keeps track of burn count with minimal overhead for tokenomics.
768         uint64 numberBurned;
769         // For miscellaneous variable(s) pertaining to the address
770         // (e.g. number of whitelist mint slots used).
771         // If there are multiple variables, please pack them into a uint64.
772         uint64 aux;
773     }
774 
775     /**
776      * @dev Returns the total amount of tokens stored by the contract.
777      * 
778      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
779      */
780     function totalSupply() external view returns (uint256);
781 }
782 
783 // File: erc721a/contracts/ERC721A.sol
784 
785 
786 // ERC721A Contracts v3.3.0
787 // Creator: Chiru Labs
788 
789 pragma solidity ^0.8.4;
790 
791 
792 
793 
794 
795 
796 
797 /**
798  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
799  * the Metadata extension. Built to optimize for lower gas during batch mints.
800  *
801  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
802  *
803  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
804  *
805  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
806  */
807 contract ERC721A is Context, ERC165, IERC721A {
808     using Address for address;
809     using Strings for uint256;
810 
811     // The tokenId of the next token to be minted.
812     uint256 internal _currentIndex;
813 
814     // The number of tokens burned.
815     uint256 internal _burnCounter;
816 
817     // Token name
818     string private _name;
819 
820     // Token symbol
821     string private _symbol;
822 
823     // Mapping from token ID to ownership details
824     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
825     mapping(uint256 => TokenOwnership) internal _ownerships;
826 
827     // Mapping owner address to address data
828     mapping(address => AddressData) private _addressData;
829 
830     // Mapping from token ID to approved address
831     mapping(uint256 => address) private _tokenApprovals;
832 
833     // Mapping from owner to operator approvals
834     mapping(address => mapping(address => bool)) private _operatorApprovals;
835 
836     constructor(string memory name_, string memory symbol_) {
837         _name = name_;
838         _symbol = symbol_;
839         _currentIndex = _startTokenId();
840     }
841 
842     /**
843      * To change the starting tokenId, please override this function.
844      */
845     function _startTokenId() internal view virtual returns (uint256) {
846         return 1;
847     }
848 
849     /**
850      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
851      */
852     function totalSupply() public view override returns (uint256) {
853         // Counter underflow is impossible as _burnCounter cannot be incremented
854         // more than _currentIndex - _startTokenId() times
855         unchecked {
856             return _currentIndex - _burnCounter - _startTokenId();
857         }
858     }
859 
860     /**
861      * Returns the total amount of tokens minted in the contract.
862      */
863     function _totalMinted() internal view returns (uint256) {
864         // Counter underflow is impossible as _currentIndex does not decrement,
865         // and it is initialized to _startTokenId()
866         unchecked {
867             return _currentIndex - _startTokenId();
868         }
869     }
870 
871     /**
872      * @dev See {IERC165-supportsInterface}.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
875         return
876             interfaceId == type(IERC721).interfaceId ||
877             interfaceId == type(IERC721Metadata).interfaceId ||
878             super.supportsInterface(interfaceId);
879     }
880 
881     /**
882      * @dev See {IERC721-balanceOf}.
883      */
884     function balanceOf(address owner) public view override returns (uint256) {
885         if (owner == address(0)) revert BalanceQueryForZeroAddress();
886         return uint256(_addressData[owner].balance);
887     }
888 
889     /**
890      * Returns the number of tokens minted by `owner`.
891      */
892     function _numberMinted(address owner) internal view returns (uint256) {
893         return uint256(_addressData[owner].numberMinted);
894     }
895 
896     /**
897      * Returns the number of tokens burned by or on behalf of `owner`.
898      */
899     function _numberBurned(address owner) internal view returns (uint256) {
900         return uint256(_addressData[owner].numberBurned);
901     }
902 
903     /**
904      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
905      */
906     function _getAux(address owner) internal view returns (uint64) {
907         return _addressData[owner].aux;
908     }
909 
910     /**
911      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      * If there are multiple variables, please pack them into a uint64.
913      */
914     function _setAux(address owner, uint64 aux) internal {
915         _addressData[owner].aux = aux;
916     }
917 
918     /**
919      * Gas spent here starts off proportional to the maximum mint batch size.
920      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
921      */
922     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
923         uint256 curr = tokenId;
924 
925         unchecked {
926             if (_startTokenId() <= curr) if (curr < _currentIndex) {
927                 TokenOwnership memory ownership = _ownerships[curr];
928                 if (!ownership.burned) {
929                     if (ownership.addr != address(0)) {
930                         return ownership;
931                     }
932                     // Invariant:
933                     // There will always be an ownership that has an address and is not burned
934                     // before an ownership that does not have an address and is not burned.
935                     // Hence, curr will not underflow.
936                     while (true) {
937                         curr--;
938                         ownership = _ownerships[curr];
939                         if (ownership.addr != address(0)) {
940                             return ownership;
941                         }
942                     }
943                 }
944             }
945         }
946         revert OwnerQueryForNonexistentToken();
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId) public view override returns (address) {
953         return _ownershipOf(tokenId).addr;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-name}.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-symbol}.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-tokenURI}.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, can be overriden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return '';
987     }
988 
989     /**
990      * @dev See {IERC721-approve}.
991      */
992     function approve(address to, uint256 tokenId) public override {
993         address owner = ERC721A.ownerOf(tokenId);
994         if (to == owner) revert ApprovalToCurrentOwner();
995 
996         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
997             revert ApprovalCallerNotOwnerNorApproved();
998         }
999 
1000         _approve(to, tokenId, owner);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-getApproved}.
1005      */
1006     function getApproved(uint256 tokenId) public view override returns (address) {
1007         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1008 
1009         return _tokenApprovals[tokenId];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-setApprovalForAll}.
1014      */
1015     function setApprovalForAll(address operator, bool approved) public virtual override {
1016         if (operator == _msgSender()) revert ApproveToCaller();
1017 
1018         _operatorApprovals[_msgSender()][operator] = approved;
1019         emit ApprovalForAll(_msgSender(), operator, approved);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-isApprovedForAll}.
1024      */
1025     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         safeTransferFrom(from, to, tokenId, '');
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) public virtual override {
1060         _transfer(from, to, tokenId);
1061         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1062             revert TransferToNonERC721ReceiverImplementer();
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns whether `tokenId` exists.
1068      *
1069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1070      *
1071      * Tokens start existing when they are minted (`_mint`),
1072      */
1073     function _exists(uint256 tokenId) internal view returns (bool) {
1074         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1075     }
1076 
1077     /**
1078      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1079      */
1080     function _safeMint(address to, uint256 quantity) internal {
1081         _safeMint(to, quantity, '');
1082     }
1083 
1084     /**
1085      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - If `to` refers to a smart contract, it must implement
1090      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1091      * - `quantity` must be greater than 0.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _safeMint(
1096         address to,
1097         uint256 quantity,
1098         bytes memory _data
1099     ) internal {
1100         uint256 startTokenId = _currentIndex;
1101         if (to == address(0)) revert MintToZeroAddress();
1102         if (quantity == 0) revert MintZeroQuantity();
1103 
1104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1105 
1106         // Overflows are incredibly unrealistic.
1107         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1108         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1109         unchecked {
1110             _addressData[to].balance += uint64(quantity);
1111             _addressData[to].numberMinted += uint64(quantity);
1112 
1113             _ownerships[startTokenId].addr = to;
1114             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1115 
1116             uint256 updatedIndex = startTokenId;
1117             uint256 end = updatedIndex + quantity;
1118 
1119             if (to.isContract()) {
1120                 do {
1121                     emit Transfer(address(0), to, updatedIndex);
1122                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1123                         revert TransferToNonERC721ReceiverImplementer();
1124                     }
1125                 } while (updatedIndex < end);
1126                 // Reentrancy protection
1127                 if (_currentIndex != startTokenId) revert();
1128             } else {
1129                 do {
1130                     emit Transfer(address(0), to, updatedIndex++);
1131                 } while (updatedIndex < end);
1132             }
1133             _currentIndex = updatedIndex;
1134         }
1135         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1136     }
1137 
1138     /**
1139      * @dev Mints `quantity` tokens and transfers them to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - `to` cannot be the zero address.
1144      * - `quantity` must be greater than 0.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _mint(address to, uint256 quantity) internal {
1149         uint256 startTokenId = _currentIndex;
1150         if (to == address(0)) revert MintToZeroAddress();
1151         if (quantity == 0) revert MintZeroQuantity();
1152 
1153         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1154 
1155         // Overflows are incredibly unrealistic.
1156         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1157         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1158         unchecked {
1159             _addressData[to].balance += uint64(quantity);
1160             _addressData[to].numberMinted += uint64(quantity);
1161 
1162             _ownerships[startTokenId].addr = to;
1163             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1164 
1165             uint256 updatedIndex = startTokenId;
1166             uint256 end = updatedIndex + quantity;
1167 
1168             do {
1169                 emit Transfer(address(0), to, updatedIndex++);
1170             } while (updatedIndex < end);
1171 
1172             _currentIndex = updatedIndex;
1173         }
1174         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1175     }
1176 
1177     /**
1178      * @dev Transfers `tokenId` from `from` to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must be owned by `from`.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _transfer(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) private {
1192         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1193 
1194         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1195 
1196         bool isApprovedOrOwner = (_msgSender() == from ||
1197             isApprovedForAll(from, _msgSender()) ||
1198             getApproved(tokenId) == _msgSender());
1199 
1200         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1201         if (to == address(0)) revert TransferToZeroAddress();
1202 
1203         _beforeTokenTransfers(from, to, tokenId, 1);
1204 
1205         // Clear approvals from the previous owner
1206         _approve(address(0), tokenId, from);
1207 
1208         // Underflow of the sender's balance is impossible because we check for
1209         // ownership above and the recipient's balance can't realistically overflow.
1210         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1211         unchecked {
1212             _addressData[from].balance -= 1;
1213             _addressData[to].balance += 1;
1214 
1215             TokenOwnership storage currSlot = _ownerships[tokenId];
1216             currSlot.addr = to;
1217             currSlot.startTimestamp = uint64(block.timestamp);
1218 
1219             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1220             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1221             uint256 nextTokenId = tokenId + 1;
1222             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1223             if (nextSlot.addr == address(0)) {
1224                 // This will suffice for checking _exists(nextTokenId),
1225                 // as a burned slot cannot contain the zero address.
1226                 if (nextTokenId != _currentIndex) {
1227                     nextSlot.addr = from;
1228                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(from, to, tokenId);
1234         _afterTokenTransfers(from, to, tokenId, 1);
1235     }
1236 
1237     /**
1238      * @dev Equivalent to `_burn(tokenId, false)`.
1239      */
1240     function _burn(uint256 tokenId) internal virtual {
1241         _burn(tokenId, false);
1242     }
1243 
1244     /**
1245      * @dev Destroys `tokenId`.
1246      * The approval is cleared when the token is burned.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1255         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1256 
1257         address from = prevOwnership.addr;
1258 
1259         if (approvalCheck) {
1260             bool isApprovedOrOwner = (_msgSender() == from ||
1261                 isApprovedForAll(from, _msgSender()) ||
1262                 getApproved(tokenId) == _msgSender());
1263 
1264             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1265         }
1266 
1267         _beforeTokenTransfers(from, address(0), tokenId, 1);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId, from);
1271 
1272         // Underflow of the sender's balance is impossible because we check for
1273         // ownership above and the recipient's balance can't realistically overflow.
1274         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1275         unchecked {
1276             AddressData storage addressData = _addressData[from];
1277             addressData.balance -= 1;
1278             addressData.numberBurned += 1;
1279 
1280             // Keep track of who burned the token, and the timestamp of burning.
1281             TokenOwnership storage currSlot = _ownerships[tokenId];
1282             currSlot.addr = from;
1283             currSlot.startTimestamp = uint64(block.timestamp);
1284             currSlot.burned = true;
1285 
1286             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1287             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1288             uint256 nextTokenId = tokenId + 1;
1289             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1290             if (nextSlot.addr == address(0)) {
1291                 // This will suffice for checking _exists(nextTokenId),
1292                 // as a burned slot cannot contain the zero address.
1293                 if (nextTokenId != _currentIndex) {
1294                     nextSlot.addr = from;
1295                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1296                 }
1297             }
1298         }
1299 
1300         emit Transfer(from, address(0), tokenId);
1301         _afterTokenTransfers(from, address(0), tokenId, 1);
1302 
1303         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1304         unchecked {
1305             _burnCounter++;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Approve `to` to operate on `tokenId`
1311      *
1312      * Emits a {Approval} event.
1313      */
1314     function _approve(
1315         address to,
1316         uint256 tokenId,
1317         address owner
1318     ) private {
1319         _tokenApprovals[tokenId] = to;
1320         emit Approval(owner, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1325      *
1326      * @param from address representing the previous owner of the given token ID
1327      * @param to target address that will receive the tokens
1328      * @param tokenId uint256 ID of the token to be transferred
1329      * @param _data bytes optional data to send along with the call
1330      * @return bool whether the call correctly returned the expected magic value
1331      */
1332     function _checkContractOnERC721Received(
1333         address from,
1334         address to,
1335         uint256 tokenId,
1336         bytes memory _data
1337     ) private returns (bool) {
1338         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1339             return retval == IERC721Receiver(to).onERC721Received.selector;
1340         } catch (bytes memory reason) {
1341             if (reason.length == 0) {
1342                 revert TransferToNonERC721ReceiverImplementer();
1343             } else {
1344                 assembly {
1345                     revert(add(32, reason), mload(reason))
1346                 }
1347             }
1348         }
1349     }
1350 
1351     /**
1352      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1353      * And also called before burning one token.
1354      *
1355      * startTokenId - the first token id to be transferred
1356      * quantity - the amount to be transferred
1357      *
1358      * Calling conditions:
1359      *
1360      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1361      * transferred to `to`.
1362      * - When `from` is zero, `tokenId` will be minted for `to`.
1363      * - When `to` is zero, `tokenId` will be burned by `from`.
1364      * - `from` and `to` are never both zero.
1365      */
1366     function _beforeTokenTransfers(
1367         address from,
1368         address to,
1369         uint256 startTokenId,
1370         uint256 quantity
1371     ) internal virtual {}
1372 
1373     /**
1374      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1375      * minting.
1376      * And also called after one token has been burned.
1377      *
1378      * startTokenId - the first token id to be transferred
1379      * quantity - the amount to be transferred
1380      *
1381      * Calling conditions:
1382      *
1383      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1384      * transferred to `to`.
1385      * - When `from` is zero, `tokenId` has been minted for `to`.
1386      * - When `to` is zero, `tokenId` has been burned by `from`.
1387      * - `from` and `to` are never both zero.
1388      */
1389     function _afterTokenTransfers(
1390         address from,
1391         address to,
1392         uint256 startTokenId,
1393         uint256 quantity
1394     ) internal virtual {}
1395 }
1396 
1397 // File: EconDegensClub.sol
1398 
1399 pragma solidity ^0.8.7;
1400 
1401 
1402 contract EconDegensClub is ERC721A, Ownable {
1403 
1404     using Strings for uint256;
1405     string public metaDataURI = "https://econdegensclub.xyz/metadata/";
1406     uint256 public totalMints = 4200;
1407     mapping(address => uint256) public degenMinters;
1408 
1409     constructor(string memory _name, string memory _symbol) ERC721A(_name, _symbol) {}
1410 
1411     function MintDegen(uint256 quantity) external payable {
1412         require(totalSupply() + quantity <= totalMints-200,"No tokens left");
1413         require(quantity <= 10, "limit exceeded");
1414 
1415         if (degenMinters[msg.sender]>0){
1416             require(msg.value >= (0.0420 ether * quantity), "not enough ETH sent");
1417         } else {
1418             if (quantity>1){
1419                 require(msg.value >= (0.0420 ether * (quantity-1)), "not enough ETH sent");
1420             }
1421         }
1422         degenMinters[msg.sender] +=quantity;
1423         _safeMint(msg.sender, quantity);
1424     }
1425 
1426  	function reserveMint(address lords, uint256 quantity) public onlyOwner {
1427 	    require(totalSupply() + quantity <= totalMints);
1428         _safeMint(lords, quantity);
1429     }
1430 
1431     function _baseURI() internal view virtual override returns (string memory) {
1432         return metaDataURI;
1433     }
1434 
1435     function setMetaDataURI(string memory newURI) external onlyOwner {
1436         metaDataURI = newURI;
1437     }
1438 
1439     function withdraw() external payable onlyOwner {
1440         payable(owner()).transfer(address(this).balance);
1441     }
1442 
1443     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1444         require(_exists(tokenId), "token not existed.");
1445         return bytes(metaDataURI).length > 0 ? string(abi.encodePacked(metaDataURI, Strings.toString(tokenId), ".json")) : ""; 
1446     }
1447 
1448 }