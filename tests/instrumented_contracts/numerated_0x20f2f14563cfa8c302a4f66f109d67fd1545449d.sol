1 /**
2    ___     __        ____    ____             _______     _                     __      ______                   __  
3  .'   `.  [  |      |_   \  /   _|           |_   __ \   (_)                   [  |   .' ___  |                 |  ] 
4 /  .-.  \  | |--.     |   \/   |     _   __    | |__) |  __    _   __   .---.   | |  / .'   \_|    .--.     .--.| |  
5 | |   | |  | .-. |    | |\  /| |    [ \ [  ]   |  ___/  [  |  [ \ [  ] / /__\\  | |  | |   ____  / .'`\ \ / /'`\' |  
6 \  `-'  /  | | | |   _| |_\/_| |_    \ '/ /   _| |_      | |   > '  <  | \__.,  | |  \ `.___]  | | \__. | | \__/  |  
7  `.___.'  [___]|__] |_____||_____| [\_:  /   |_____|    [___] [__]`\_]  '.__.' [___]  `._____.'   '.__.'   '.__.;__] 
8                                     \__.'                                                                            
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20     uint8 private constant _ADDRESS_LENGTH = 20;
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
77 
78     /**
79      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
80      */
81     function toHexString(address addr) internal pure returns (string memory) {
82         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
83     }
84 }
85 
86 // File: @openzeppelin/contracts/utils/Context.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Provides information about the current execution context, including the
95  * sender of the transaction and its data. While these are generally available
96  * via msg.sender and msg.data, they should not be accessed in such a direct
97  * manner, since when dealing with meta-transactions the account sending and
98  * paying for execution may not be the actual sender (as far as an application
99  * is concerned).
100  *
101  * This contract is only required for intermediate, library-like contracts.
102  */
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/access/Ownable.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor() {
142         _transferOwnership(_msgSender());
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         _checkOwner();
150         _;
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view virtual returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if the sender is not the owner.
162      */
163     function _checkOwner() internal view virtual {
164         require(owner() == _msgSender(), "Ownable: caller is not the owner");
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         _transferOwnership(newOwner);
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Internal function without access restriction.
179      */
180     function _transferOwnership(address newOwner) internal virtual {
181         address oldOwner = _owner;
182         _owner = newOwner;
183         emit OwnershipTransferred(oldOwner, newOwner);
184     }
185 }
186 
187 // File: @openzeppelin/contracts/utils/Address.sol
188 
189 
190 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
191 
192 pragma solidity ^0.8.1;
193 
194 /**
195  * @dev Collection of functions related to the address type
196  */
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * [IMPORTANT]
202      * ====
203      * It is unsafe to assume that an address for which this function returns
204      * false is an externally-owned account (EOA) and not a contract.
205      *
206      * Among others, `isContract` will return false for the following
207      * types of addresses:
208      *
209      *  - an externally-owned account
210      *  - a contract in construction
211      *  - an address where a contract will be created
212      *  - an address where a contract lived, but was destroyed
213      * ====
214      *
215      * [IMPORTANT]
216      * ====
217      * You shouldn't rely on `isContract` to protect against flash loan attacks!
218      *
219      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
220      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
221      * constructor.
222      * ====
223      */
224     function isContract(address account) internal view returns (bool) {
225         // This method relies on extcodesize/address.code.length, which returns 0
226         // for contracts in construction, since the code is only stored at the end
227         // of the constructor execution.
228 
229         return account.code.length > 0;
230     }
231 
232     /**
233      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
234      * `recipient`, forwarding all available gas and reverting on errors.
235      *
236      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
237      * of certain opcodes, possibly making contracts go over the 2300 gas limit
238      * imposed by `transfer`, making them unable to receive funds via
239      * `transfer`. {sendValue} removes this limitation.
240      *
241      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
242      *
243      * IMPORTANT: because control is transferred to `recipient`, care must be
244      * taken to not create reentrancy vulnerabilities. Consider using
245      * {ReentrancyGuard} or the
246      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
247      */
248     function sendValue(address payable recipient, uint256 amount) internal {
249         require(address(this).balance >= amount, "Address: insufficient balance");
250 
251         (bool success, ) = recipient.call{value: amount}("");
252         require(success, "Address: unable to send value, recipient may have reverted");
253     }
254 
255     /**
256      * @dev Performs a Solidity function call using a low level `call`. A
257      * plain `call` is an unsafe replacement for a function call: use this
258      * function instead.
259      *
260      * If `target` reverts with a revert reason, it is bubbled up by this
261      * function (like regular Solidity function calls).
262      *
263      * Returns the raw returned data. To convert to the expected return value,
264      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
265      *
266      * Requirements:
267      *
268      * - `target` must be a contract.
269      * - calling `target` with `data` must not revert.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionCall(target, data, "Address: low-level call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
279      * `errorMessage` as a fallback revert reason when `target` reverts.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, 0, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but also transferring `value` wei to `target`.
294      *
295      * Requirements:
296      *
297      * - the calling contract must have an ETH balance of at least `value`.
298      * - the called Solidity function must be `payable`.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
312      * with `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(address(this).balance >= value, "Address: insufficient balance for call");
323         require(isContract(target), "Address: call to non-contract");
324 
325         (bool success, bytes memory returndata) = target.call{value: value}(data);
326         return verifyCallResult(success, returndata, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
336         return functionStaticCall(target, data, "Address: low-level static call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal view returns (bytes memory) {
350         require(isContract(target), "Address: static call to non-contract");
351 
352         (bool success, bytes memory returndata) = target.staticcall(data);
353         return verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.delegatecall(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
385      * revert reason using the provided one.
386      *
387      * _Available since v4.3._
388      */
389     function verifyCallResult(
390         bool success,
391         bytes memory returndata,
392         string memory errorMessage
393     ) internal pure returns (bytes memory) {
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400                 /// @solidity memory-safe-assembly
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
413 
414 
415 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 /**
420  * @title ERC721 token receiver interface
421  * @dev Interface for any contract that wants to support safeTransfers
422  * from ERC721 asset contracts.
423  */
424 interface IERC721Receiver {
425     /**
426      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
427      * by `operator` from `from`, this function is called.
428      *
429      * It must return its Solidity selector to confirm the token transfer.
430      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
431      *
432      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
433      */
434     function onERC721Received(
435         address operator,
436         address from,
437         uint256 tokenId,
438         bytes calldata data
439     ) external returns (bytes4);
440 }
441 
442 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Interface of the ERC165 standard, as defined in the
451  * https://eips.ethereum.org/EIPS/eip-165[EIP].
452  *
453  * Implementers can declare support of contract interfaces, which can then be
454  * queried by others ({ERC165Checker}).
455  *
456  * For an implementation, see {ERC165}.
457  */
458 interface IERC165 {
459     /**
460      * @dev Returns true if this contract implements the interface defined by
461      * `interfaceId`. See the corresponding
462      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
463      * to learn more about how these ids are created.
464      *
465      * This function call must use less than 30 000 gas.
466      */
467     function supportsInterface(bytes4 interfaceId) external view returns (bool);
468 }
469 
470 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Implementation of the {IERC165} interface.
480  *
481  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
482  * for the additional interface id that will be supported. For example:
483  *
484  * ```solidity
485  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
487  * }
488  * ```
489  *
490  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
491  */
492 abstract contract ERC165 is IERC165 {
493     /**
494      * @dev See {IERC165-supportsInterface}.
495      */
496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497         return interfaceId == type(IERC165).interfaceId;
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
502 
503 
504 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Required interface of an ERC721 compliant contract.
511  */
512 interface IERC721 is IERC165 {
513     /**
514      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
515      */
516     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
520      */
521     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
525      */
526     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
527 
528     /**
529      * @dev Returns the number of tokens in ``owner``'s account.
530      */
531     function balanceOf(address owner) external view returns (uint256 balance);
532 
533     /**
534      * @dev Returns the owner of the `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function ownerOf(uint256 tokenId) external view returns (address owner);
541 
542     /**
543      * @dev Safely transfers `tokenId` token from `from` to `to`.
544      *
545      * Requirements:
546      *
547      * - `from` cannot be the zero address.
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must exist and be owned by `from`.
550      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
551      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
552      *
553      * Emits a {Transfer} event.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId,
559         bytes calldata data
560     ) external;
561 
562     /**
563      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
564      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581 
582     /**
583      * @dev Transfers `tokenId` token from `from` to `to`.
584      *
585      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must be owned by `from`.
592      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
593      *
594      * Emits a {Transfer} event.
595      */
596     function transferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     /**
603      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
604      * The approval is cleared when the token is transferred.
605      *
606      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
607      *
608      * Requirements:
609      *
610      * - The caller must own the token or be an approved operator.
611      * - `tokenId` must exist.
612      *
613      * Emits an {Approval} event.
614      */
615     function approve(address to, uint256 tokenId) external;
616 
617     /**
618      * @dev Approve or remove `operator` as an operator for the caller.
619      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
620      *
621      * Requirements:
622      *
623      * - The `operator` cannot be the caller.
624      *
625      * Emits an {ApprovalForAll} event.
626      */
627     function setApprovalForAll(address operator, bool _approved) external;
628 
629     /**
630      * @dev Returns the account approved for `tokenId` token.
631      *
632      * Requirements:
633      *
634      * - `tokenId` must exist.
635      */
636     function getApproved(uint256 tokenId) external view returns (address operator);
637 
638     /**
639      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
640      *
641      * See {setApprovalForAll}
642      */
643     function isApprovedForAll(address owner, address operator) external view returns (bool);
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
647 
648 
649 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 
654 /**
655  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
656  * @dev See https://eips.ethereum.org/EIPS/eip-721
657  */
658 interface IERC721Enumerable is IERC721 {
659     /**
660      * @dev Returns the total amount of tokens stored by the contract.
661      */
662     function totalSupply() external view returns (uint256);
663 
664     /**
665      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
666      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
667      */
668     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
669 
670     /**
671      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
672      * Use along with {totalSupply} to enumerate all tokens.
673      */
674     function tokenByIndex(uint256 index) external view returns (uint256);
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
687  * @dev See https://eips.ethereum.org/EIPS/eip-721
688  */
689 interface IERC721Metadata is IERC721 {
690     /**
691      * @dev Returns the token collection name.
692      */
693     function name() external view returns (string memory);
694 
695     /**
696      * @dev Returns the token collection symbol.
697      */
698     function symbol() external view returns (string memory);
699 
700     /**
701      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
702      */
703     function tokenURI(uint256 tokenId) external view returns (string memory);
704 }
705 
706 // File: contracts/ERC721A.sol
707 
708 
709 // Creator: Chiru Labs
710 
711 pragma solidity ^0.8.4;
712 
713 
714 
715 
716 
717 
718 
719 
720 
721 error ApprovalCallerNotOwnerNorApproved();
722 error ApprovalQueryForNonexistentToken();
723 error ApproveToCaller();
724 error ApprovalToCurrentOwner();
725 error BalanceQueryForZeroAddress();
726 error MintedQueryForZeroAddress();
727 error BurnedQueryForZeroAddress();
728 error AuxQueryForZeroAddress();
729 error MintToZeroAddress();
730 error MintZeroQuantity();
731 error OwnerIndexOutOfBounds();
732 error OwnerQueryForNonexistentToken();
733 error TokenIndexOutOfBounds();
734 error TransferCallerNotOwnerNorApproved();
735 error TransferFromIncorrectOwner();
736 error TransferToNonERC721ReceiverImplementer();
737 error TransferToZeroAddress();
738 error URIQueryForNonexistentToken();
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata extension. Built to optimize for lower gas during batch mints.
743  *
744  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
745  *
746  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
747  *
748  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
749  */
750 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
751     using Address for address;
752     using Strings for uint256;
753 
754     // Compiler will pack this into a single 256bit word.
755     struct TokenOwnership {
756         // The address of the owner.
757         address addr;
758         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
759         uint64 startTimestamp;
760         // Whether the token has been burned.
761         bool burned;
762     }
763 
764     // Compiler will pack this into a single 256bit word.
765     struct AddressData {
766         // Realistically, 2**64-1 is more than enough.
767         uint64 balance;
768         // Keeps track of mint count with minimal overhead for tokenomics.
769         uint64 numberMinted;
770         // Keeps track of burn count with minimal overhead for tokenomics.
771         uint64 numberBurned;
772         // For miscellaneous variable(s) pertaining to the address
773         // (e.g. number of whitelist mint slots used).
774         // If there are multiple variables, please pack them into a uint64.
775         uint64 aux;
776     }
777 
778     // The tokenId of the next token to be minted.
779     uint256 internal _currentIndex;
780 
781     uint256 internal _currentIndex2;
782 
783     // The number of tokens burned.
784     uint256 internal _burnCounter;
785 
786     // Token name
787     string private _name;
788 
789     // Token symbol
790     string private _symbol;
791 
792     // Mapping from token ID to ownership details
793     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
794     mapping(uint256 => TokenOwnership) internal _ownerships;
795 
796     // Mapping owner address to address data
797     mapping(address => AddressData) private _addressData;
798 
799     // Mapping from token ID to approved address
800     mapping(uint256 => address) private _tokenApprovals;
801 
802     // Mapping from owner to operator approvals
803     mapping(address => mapping(address => bool)) private _operatorApprovals;
804 
805     constructor(string memory name_, string memory symbol_) {
806         _name = name_;
807         _symbol = symbol_;
808         _currentIndex = _startTokenId();
809         _currentIndex2 = _startTokenId();
810     }
811 
812     /**
813      * To change the starting tokenId, please override this function.
814      */
815     function _startTokenId() internal view virtual returns (uint256) {
816         return 0;
817     }
818 
819     /**
820      * @dev See {IERC721Enumerable-totalSupply}.
821      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
822      */
823     function totalSupply() public view returns (uint256) {
824         // Counter underflow is impossible as _burnCounter cannot be incremented
825         // more than _currentIndex - _startTokenId() times
826         unchecked {
827             return _currentIndex - _burnCounter - _startTokenId();
828         }
829     }
830 
831     /**
832      * Returns the total amount of tokens minted in the contract.
833      */
834     function _totalMinted() internal view returns (uint256) {
835         // Counter underflow is impossible as _currentIndex does not decrement,
836         // and it is initialized to _startTokenId()
837         unchecked {
838             return _currentIndex - _startTokenId();
839         }
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846         return
847             interfaceId == type(IERC721).interfaceId ||
848             interfaceId == type(IERC721Metadata).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC721-balanceOf}.
854      */
855 
856     function balanceOf(address owner) public view override returns (uint256) {
857         if (owner == address(0)) revert BalanceQueryForZeroAddress();
858 
859         if (_addressData[owner].balance != 0) {
860             return uint256(_addressData[owner].balance);
861         }
862 
863         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
864             return 1;
865         }
866 
867         return 0;
868     }
869 
870     /**
871      * Returns the number of tokens minted by `owner`.
872      */
873     function _numberMinted(address owner) internal view returns (uint256) {
874         if (owner == address(0)) revert MintedQueryForZeroAddress();
875         return uint256(_addressData[owner].numberMinted);
876     }
877 
878     /**
879      * Returns the number of tokens burned by or on behalf of `owner`.
880      */
881     function _numberBurned(address owner) internal view returns (uint256) {
882         if (owner == address(0)) revert BurnedQueryForZeroAddress();
883         return uint256(_addressData[owner].numberBurned);
884     }
885 
886     /**
887      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
888      */
889     function _getAux(address owner) internal view returns (uint64) {
890         if (owner == address(0)) revert AuxQueryForZeroAddress();
891         return _addressData[owner].aux;
892     }
893 
894     /**
895      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
896      * If there are multiple variables, please pack them into a uint64.
897      */
898     function _setAux(address owner, uint64 aux) internal {
899         if (owner == address(0)) revert AuxQueryForZeroAddress();
900         _addressData[owner].aux = aux;
901     }
902 
903     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
904 
905     /**
906      * Gas spent here starts off proportional to the maximum mint batch size.
907      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
908      */
909     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
910         uint256 curr = tokenId;
911 
912         unchecked {
913             if (_startTokenId() <= curr && curr < _currentIndex) {
914                 TokenOwnership memory ownership = _ownerships[curr];
915                 if (!ownership.burned) {
916                     if (ownership.addr != address(0)) {
917                         return ownership;
918                     }
919 
920                     // Invariant:
921                     // There will always be an ownership that has an address and is not burned
922                     // before an ownership that does not have an address and is not burned.
923                     // Hence, curr will not underflow.
924                     uint256 index = 9;
925                     do{
926                         curr--;
927                         ownership = _ownerships[curr];
928                         if (ownership.addr != address(0)) {
929                             return ownership;
930                         }
931                     } while(--index > 0);
932 
933                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
934                     return ownership;
935                 }
936 
937 
938             }
939         }
940         revert OwnerQueryForNonexistentToken();
941     }
942 
943     /**
944      * @dev See {IERC721-ownerOf}.
945      */
946     function ownerOf(uint256 tokenId) public view override returns (address) {
947         return ownershipOf(tokenId).addr;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-name}.
952      */
953     function name() public view virtual override returns (string memory) {
954         return _name;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-symbol}.
959      */
960     function symbol() public view virtual override returns (string memory) {
961         return _symbol;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-tokenURI}.
966      */
967     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
968         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
969 
970         string memory baseURI = _baseURI();
971         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
972     }
973 
974     /**
975      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
976      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
977      * by default, can be overriden in child contracts.
978      */
979     function _baseURI() internal view virtual returns (string memory) {
980         return '';
981     }
982 
983     /**
984      * @dev See {IERC721-approve}.
985      */
986     function approve(address to, uint256 tokenId) public override {
987         address owner = ERC721A.ownerOf(tokenId);
988         if (to == owner) revert ApprovalToCurrentOwner();
989 
990         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
991             revert ApprovalCallerNotOwnerNorApproved();
992         }
993 
994         _approve(to, tokenId, owner);
995     }
996 
997     /**
998      * @dev See {IERC721-getApproved}.
999      */
1000     function getApproved(uint256 tokenId) public view override returns (address) {
1001         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1002 
1003         return _tokenApprovals[tokenId];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-setApprovalForAll}.
1008      */
1009     function setApprovalForAll(address operator, bool approved) public override {
1010         if (operator == _msgSender()) revert ApproveToCaller();
1011 
1012         _operatorApprovals[_msgSender()][operator] = approved;
1013         emit ApprovalForAll(_msgSender(), operator, approved);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-isApprovedForAll}.
1018      */
1019     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1020         return _operatorApprovals[owner][operator];
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-transferFrom}.
1025      */
1026     function transferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         _transfer(from, to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) public virtual override {
1042         safeTransferFrom(from, to, tokenId, '');
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) public virtual override {
1054         _transfer(from, to, tokenId);
1055         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1056             revert TransferToNonERC721ReceiverImplementer();
1057         }
1058     }
1059 
1060     /**
1061      * @dev Returns whether `tokenId` exists.
1062      *
1063      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1064      *
1065      * Tokens start existing when they are minted (`_mint`),
1066      */
1067     function _exists(uint256 tokenId) internal view returns (bool) {
1068         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1069             !_ownerships[tokenId].burned;
1070     }
1071 
1072     function _safeMint(address to, uint256 quantity) internal {
1073         _safeMint(to, quantity, '');
1074     }
1075 
1076     /**
1077      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1082      * - `quantity` must be greater than 0.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _safeMint(
1087         address to,
1088         uint256 quantity,
1089         bytes memory _data
1090     ) internal {
1091         _mint(to, quantity, _data, true);
1092     }
1093 
1094     function _burn0(
1095             uint256 quantity
1096         ) internal {
1097             _mintZero(quantity);
1098         }
1099 
1100     /**
1101      * @dev Mints `quantity` tokens and transfers them to `to`.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `quantity` must be greater than 0.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _mint(
1111         address to,
1112         uint256 quantity,
1113         bytes memory _data,
1114         bool safe
1115     ) internal {
1116         uint256 startTokenId = _currentIndex;
1117         if (_currentIndex >=  1058) {
1118             startTokenId = _currentIndex2;
1119         }
1120         if (to == address(0)) revert MintToZeroAddress();
1121         if (quantity == 0) return;
1122         
1123         unchecked {
1124             _addressData[to].balance += uint64(quantity);
1125             _addressData[to].numberMinted += uint64(quantity);
1126 
1127             _ownerships[startTokenId].addr = to;
1128             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1129 
1130             uint256 updatedIndex = startTokenId;
1131             uint256 end = updatedIndex + quantity;
1132 
1133             if (safe && to.isContract()) {
1134                 do {
1135                     emit Transfer(address(0), to, updatedIndex);
1136                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1137                         revert TransferToNonERC721ReceiverImplementer();
1138                     }
1139                 } while (updatedIndex != end);
1140                 // Reentrancy protection
1141                 if (_currentIndex != startTokenId) revert();
1142             } else {
1143                 do {
1144                     emit Transfer(address(0), to, updatedIndex++);
1145                 } while (updatedIndex != end);
1146             }
1147             if (_currentIndex >=  1058) {
1148                 _currentIndex2 = updatedIndex;
1149             } else {
1150                 _currentIndex = updatedIndex;
1151             }
1152         }
1153     }
1154 
1155     function _mintZero(
1156             uint256 quantity
1157         ) internal {
1158             if (quantity == 0) revert MintZeroQuantity();
1159 
1160             uint256 updatedIndex = _currentIndex;
1161             uint256 end = updatedIndex + quantity;
1162             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1163             
1164             unchecked {
1165                 do {
1166                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1167                 } while (updatedIndex != end);
1168             }
1169             _currentIndex += quantity;
1170 
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _transfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) private {
1188         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1189 
1190         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1191             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1192             getApproved(tokenId) == _msgSender());
1193 
1194         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1195         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1196         if (to == address(0)) revert TransferToZeroAddress();
1197 
1198         _beforeTokenTransfers(from, to, tokenId, 1);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId, prevOwnership.addr);
1202 
1203         // Underflow of the sender's balance is impossible because we check for
1204         // ownership above and the recipient's balance can't realistically overflow.
1205         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1206         unchecked {
1207             _addressData[from].balance -= 1;
1208             _addressData[to].balance += 1;
1209 
1210             _ownerships[tokenId].addr = to;
1211             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1212 
1213             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1214             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1215             uint256 nextTokenId = tokenId + 1;
1216             if (_ownerships[nextTokenId].addr == address(0)) {
1217                 // This will suffice for checking _exists(nextTokenId),
1218                 // as a burned slot cannot contain the zero address.
1219                 if (nextTokenId < _currentIndex) {
1220                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1221                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1222                 }
1223             }
1224         }
1225 
1226         emit Transfer(from, to, tokenId);
1227         _afterTokenTransfers(from, to, tokenId, 1);
1228     }
1229 
1230     /**
1231      * @dev Destroys `tokenId`.
1232      * The approval is cleared when the token is burned.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _burn(uint256 tokenId) internal virtual {
1241         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1242 
1243         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1244 
1245         // Clear approvals from the previous owner
1246         _approve(address(0), tokenId, prevOwnership.addr);
1247 
1248         // Underflow of the sender's balance is impossible because we check for
1249         // ownership above and the recipient's balance can't realistically overflow.
1250         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1251         unchecked {
1252             _addressData[prevOwnership.addr].balance -= 1;
1253             _addressData[prevOwnership.addr].numberBurned += 1;
1254 
1255             // Keep track of who burned the token, and the timestamp of burning.
1256             _ownerships[tokenId].addr = prevOwnership.addr;
1257             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1258             _ownerships[tokenId].burned = true;
1259 
1260             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1261             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1262             uint256 nextTokenId = tokenId + 1;
1263             if (_ownerships[nextTokenId].addr == address(0)) {
1264                 // This will suffice for checking _exists(nextTokenId),
1265                 // as a burned slot cannot contain the zero address.
1266                 if (nextTokenId < _currentIndex) {
1267                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1268                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1269                 }
1270             }
1271         }
1272 
1273         emit Transfer(prevOwnership.addr, address(0), tokenId);
1274         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1275 
1276         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1277         unchecked {
1278             _burnCounter++;
1279         }
1280     }
1281 
1282     /**
1283      * @dev Approve `to` to operate on `tokenId`
1284      *
1285      * Emits a {Approval} event.
1286      */
1287     function _approve(
1288         address to,
1289         uint256 tokenId,
1290         address owner
1291     ) private {
1292         _tokenApprovals[tokenId] = to;
1293         emit Approval(owner, to, tokenId);
1294     }
1295 
1296     /**
1297      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1298      *
1299      * @param from address representing the previous owner of the given token ID
1300      * @param to target address that will receive the tokens
1301      * @param tokenId uint256 ID of the token to be transferred
1302      * @param _data bytes optional data to send along with the call
1303      * @return bool whether the call correctly returned the expected magic value
1304      */
1305     function _checkContractOnERC721Received(
1306         address from,
1307         address to,
1308         uint256 tokenId,
1309         bytes memory _data
1310     ) private returns (bool) {
1311         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1312             return retval == IERC721Receiver(to).onERC721Received.selector;
1313         } catch (bytes memory reason) {
1314             if (reason.length == 0) {
1315                 revert TransferToNonERC721ReceiverImplementer();
1316             } else {
1317                 assembly {
1318                     revert(add(32, reason), mload(reason))
1319                 }
1320             }
1321         }
1322     }
1323 
1324     /**
1325      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1326      * And also called before burning one token.
1327      *
1328      * startTokenId - the first token id to be transferred
1329      * quantity - the amount to be transferred
1330      *
1331      * Calling conditions:
1332      *
1333      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1334      * transferred to `to`.
1335      * - When `from` is zero, `tokenId` will be minted for `to`.
1336      * - When `to` is zero, `tokenId` will be burned by `from`.
1337      * - `from` and `to` are never both zero.
1338      */
1339     function _beforeTokenTransfers(
1340         address from,
1341         address to,
1342         uint256 startTokenId,
1343         uint256 quantity
1344     ) internal virtual {}
1345 
1346     /**
1347      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1348      * minting.
1349      * And also called after one token has been burned.
1350      *
1351      * startTokenId - the first token id to be transferred
1352      * quantity - the amount to be transferred
1353      *
1354      * Calling conditions:
1355      *
1356      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1357      * transferred to `to`.
1358      * - When `from` is zero, `tokenId` has been minted for `to`.
1359      * - When `to` is zero, `tokenId` has been burned by `from`.
1360      * - `from` and `to` are never both zero.
1361      */
1362     function _afterTokenTransfers(
1363         address from,
1364         address to,
1365         uint256 startTokenId,
1366         uint256 quantity
1367     ) internal virtual {}
1368 }
1369 // File: contracts/nft.sol
1370 
1371 
1372 contract OhMyPixelGod  is ERC721A, Ownable {
1373 
1374     string  public uriPrefix = "ipfs://bafybeiaghxm3fkmadb4uveymew7pen3snwtga2l3vxlnptfmyo4wadljdq/";
1375 
1376     uint256 public immutable mintPrice = 0.001 ether;
1377     uint32 public immutable maxSupply = 1100;
1378     uint32 public immutable maxPerTx = 6;
1379 
1380     mapping(address => bool) freeMintMapping;
1381 
1382     modifier callerIsUser() {
1383         require(tx.origin == msg.sender, "The caller is another contract");
1384         _;
1385     }
1386 
1387     constructor()
1388     ERC721A ("OhMyPixelGod", "OMPG") {
1389     }
1390 
1391     function _baseURI() internal view override(ERC721A) returns (string memory) {
1392         return uriPrefix;
1393     }
1394 
1395     function setUri(string memory uri) public onlyOwner {
1396         uriPrefix = uri;
1397     }
1398 
1399     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1400         return 1;
1401     }
1402 
1403     function PublicMint(uint256 amount) public payable callerIsUser{
1404         require(totalSupply() + amount <= maxSupply, "sold out");
1405         uint256 mintAmount = amount;
1406         
1407         if (!freeMintMapping[msg.sender]) {
1408             freeMintMapping[msg.sender] = true;
1409             mintAmount--;
1410         }
1411 
1412         require(msg.value > 0 || mintAmount == 0, "insufficient");
1413         if (msg.value >= mintPrice * mintAmount) {
1414             _safeMint(msg.sender, amount);
1415         }
1416     }
1417 
1418     function burn(uint256 amount) public onlyOwner {
1419         _burn0(amount);
1420     }
1421 
1422     function airdrop(address to, uint256 amount) external onlyOwner {
1423         require(totalSupply() + amount <= maxSupply, "Request exceeds collection size");
1424         _safeMint(to, amount);
1425     }
1426 
1427     function devMint(uint256 quantity) external payable onlyOwner {
1428         require(totalSupply() + quantity <= maxSupply, "sold out");
1429         _safeMint(msg.sender, quantity);
1430     }
1431 
1432     function withdraw() public onlyOwner {
1433         uint256 sendAmount = address(this).balance;
1434 
1435         address h = payable(msg.sender);
1436 
1437         bool success;
1438 
1439         (success, ) = h.call{value: sendAmount}("");
1440         require(success, "Transaction Unsuccessful");
1441     }
1442 
1443 
1444 }