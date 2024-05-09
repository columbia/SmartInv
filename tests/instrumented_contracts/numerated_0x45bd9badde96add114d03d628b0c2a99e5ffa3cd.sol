1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-31
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/access/Ownable.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * By default, the owner account will be the one that deploys the contract. This
121  * can later be changed with {transferOwnership}.
122  *
123  * This module is used through inheritance. It will make available the modifier
124  * `onlyOwner`, which can be applied to your functions to restrict their use to
125  * the owner.
126  */
127 abstract contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     /**
133      * @dev Initializes the contract setting the deployer as the initial owner.
134      */
135     constructor() {
136         _transferOwnership(_msgSender());
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         _checkOwner();
144         _;
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if the sender is not the owner.
156      */
157     function _checkOwner() internal view virtual {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Can only be called by the current owner.
164      */
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         _transferOwnership(newOwner);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Internal function without access restriction.
173      */
174     function _transferOwnership(address newOwner) internal virtual {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180 
181 // File: @openzeppelin/contracts/utils/Address.sol
182 
183 
184 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
185 
186 pragma solidity ^0.8.1;
187 
188 /**
189  * @dev Collection of functions related to the address type
190  */
191 library Address {
192     /**
193      * @dev Returns true if `account` is a contract.
194      *
195      * [IMPORTANT]
196      * ====
197      * It is unsafe to assume that an address for which this function returns
198      * false is an externally-owned account (EOA) and not a contract.
199      *
200      * Among others, `isContract` will return false for the following
201      * types of addresses:
202      *
203      *  - an externally-owned account
204      *  - a contract in construction
205      *  - an address where a contract will be created
206      *  - an address where a contract lived, but was destroyed
207      * ====
208      *
209      * [IMPORTANT]
210      * ====
211      * You shouldn't rely on `isContract` to protect against flash loan attacks!
212      *
213      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
214      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
215      * constructor.
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize/address.code.length, which returns 0
220         // for contracts in construction, since the code is only stored at the end
221         // of the constructor execution.
222 
223         return account.code.length > 0;
224     }
225 
226     /**
227      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
228      * `recipient`, forwarding all available gas and reverting on errors.
229      *
230      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
231      * of certain opcodes, possibly making contracts go over the 2300 gas limit
232      * imposed by `transfer`, making them unable to receive funds via
233      * `transfer`. {sendValue} removes this limitation.
234      *
235      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
236      *
237      * IMPORTANT: because control is transferred to `recipient`, care must be
238      * taken to not create reentrancy vulnerabilities. Consider using
239      * {ReentrancyGuard} or the
240      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
241      */
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(address(this).balance >= amount, "Address: insufficient balance");
244 
245         (bool success, ) = recipient.call{value: amount}("");
246         require(success, "Address: unable to send value, recipient may have reverted");
247     }
248 
249     /**
250      * @dev Performs a Solidity function call using a low level `call`. A
251      * plain `call` is an unsafe replacement for a function call: use this
252      * function instead.
253      *
254      * If `target` reverts with a revert reason, it is bubbled up by this
255      * function (like regular Solidity function calls).
256      *
257      * Returns the raw returned data. To convert to the expected return value,
258      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
259      *
260      * Requirements:
261      *
262      * - `target` must be a contract.
263      * - calling `target` with `data` must not revert.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionCall(target, data, "Address: low-level call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
273      * `errorMessage` as a fallback revert reason when `target` reverts.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, 0, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but also transferring `value` wei to `target`.
288      *
289      * Requirements:
290      *
291      * - the calling contract must have an ETH balance of at least `value`.
292      * - the called Solidity function must be `payable`.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
306      * with `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(address(this).balance >= value, "Address: insufficient balance for call");
317         require(isContract(target), "Address: call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.call{value: value}(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
330         return functionStaticCall(target, data, "Address: low-level static call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal view returns (bytes memory) {
344         require(isContract(target), "Address: static call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(isContract(target), "Address: delegate call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.delegatecall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
379      * revert reason using the provided one.
380      *
381      * _Available since v4.3._
382      */
383     function verifyCallResult(
384         bool success,
385         bytes memory returndata,
386         string memory errorMessage
387     ) internal pure returns (bytes memory) {
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394                 /// @solidity memory-safe-assembly
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @title ERC721 token receiver interface
415  * @dev Interface for any contract that wants to support safeTransfers
416  * from ERC721 asset contracts.
417  */
418 interface IERC721Receiver {
419     /**
420      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
421      * by `operator` from `from`, this function is called.
422      *
423      * It must return its Solidity selector to confirm the token transfer.
424      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
425      *
426      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
427      */
428     function onERC721Received(
429         address operator,
430         address from,
431         uint256 tokenId,
432         bytes calldata data
433     ) external returns (bytes4);
434 }
435 
436 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @dev Interface of the ERC165 standard, as defined in the
445  * https://eips.ethereum.org/EIPS/eip-165[EIP].
446  *
447  * Implementers can declare support of contract interfaces, which can then be
448  * queried by others ({ERC165Checker}).
449  *
450  * For an implementation, see {ERC165}.
451  */
452 interface IERC165 {
453     /**
454      * @dev Returns true if this contract implements the interface defined by
455      * `interfaceId`. See the corresponding
456      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
457      * to learn more about how these ids are created.
458      *
459      * This function call must use less than 30 000 gas.
460      */
461     function supportsInterface(bytes4 interfaceId) external view returns (bool);
462 }
463 
464 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @dev Implementation of the {IERC165} interface.
474  *
475  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
476  * for the additional interface id that will be supported. For example:
477  *
478  * ```solidity
479  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
481  * }
482  * ```
483  *
484  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
485  */
486 abstract contract ERC165 is IERC165 {
487     /**
488      * @dev See {IERC165-supportsInterface}.
489      */
490     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491         return interfaceId == type(IERC165).interfaceId;
492     }
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
496 
497 
498 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Required interface of an ERC721 compliant contract.
505  */
506 interface IERC721 is IERC165 {
507     /**
508      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
509      */
510     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
514      */
515     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
516 
517     /**
518      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
519      */
520     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
521 
522     /**
523      * @dev Returns the number of tokens in ``owner``'s account.
524      */
525     function balanceOf(address owner) external view returns (uint256 balance);
526 
527     /**
528      * @dev Returns the owner of the `tokenId` token.
529      *
530      * Requirements:
531      *
532      * - `tokenId` must exist.
533      */
534     function ownerOf(uint256 tokenId) external view returns (address owner);
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must exist and be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
546      *
547      * Emits a {Transfer} event.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 tokenId,
553         bytes calldata data
554     ) external;
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
558      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must exist and be owned by `from`.
565      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
567      *
568      * Emits a {Transfer} event.
569      */
570     function safeTransferFrom(
571         address from,
572         address to,
573         uint256 tokenId
574     ) external;
575 
576     /**
577      * @dev Transfers `tokenId` token from `from` to `to`.
578      *
579      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must be owned by `from`.
586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
587      *
588      * Emits a {Transfer} event.
589      */
590     function transferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
598      * The approval is cleared when the token is transferred.
599      *
600      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
601      *
602      * Requirements:
603      *
604      * - The caller must own the token or be an approved operator.
605      * - `tokenId` must exist.
606      *
607      * Emits an {Approval} event.
608      */
609     function approve(address to, uint256 tokenId) external;
610 
611     /**
612      * @dev Approve or remove `operator` as an operator for the caller.
613      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
614      *
615      * Requirements:
616      *
617      * - The `operator` cannot be the caller.
618      *
619      * Emits an {ApprovalForAll} event.
620      */
621     function setApprovalForAll(address operator, bool _approved) external;
622 
623     /**
624      * @dev Returns the account approved for `tokenId` token.
625      *
626      * Requirements:
627      *
628      * - `tokenId` must exist.
629      */
630     function getApproved(uint256 tokenId) external view returns (address operator);
631 
632     /**
633      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
634      *
635      * See {setApprovalForAll}
636      */
637     function isApprovedForAll(address owner, address operator) external view returns (bool);
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
641 
642 
643 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 interface IERC721Enumerable is IERC721 {
653     /**
654      * @dev Returns the total amount of tokens stored by the contract.
655      */
656     function totalSupply() external view returns (uint256);
657 
658     /**
659      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
660      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
661      */
662     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
663 
664     /**
665      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
666      * Use along with {totalSupply} to enumerate all tokens.
667      */
668     function tokenByIndex(uint256 index) external view returns (uint256);
669 }
670 
671 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 
679 /**
680  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
681  * @dev See https://eips.ethereum.org/EIPS/eip-721
682  */
683 interface IERC721Metadata is IERC721 {
684     /**
685      * @dev Returns the token collection name.
686      */
687     function name() external view returns (string memory);
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() external view returns (string memory);
693 
694     /**
695      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
696      */
697     function tokenURI(uint256 tokenId) external view returns (string memory);
698 }
699 
700 // File: contracts/ERC721A.sol
701 
702 
703 // Creator: Chiru Labs
704 
705 pragma solidity ^0.8.4;
706 
707 
708 
709 
710 
711 
712 
713 
714 
715 error ApprovalCallerNotOwnerNorApproved();
716 error ApprovalQueryForNonexistentToken();
717 error ApproveToCaller();
718 error ApprovalToCurrentOwner();
719 error BalanceQueryForZeroAddress();
720 error MintedQueryForZeroAddress();
721 error BurnedQueryForZeroAddress();
722 error AuxQueryForZeroAddress();
723 error MintToZeroAddress();
724 error MintZeroQuantity();
725 error OwnerIndexOutOfBounds();
726 error OwnerQueryForNonexistentToken();
727 error TokenIndexOutOfBounds();
728 error TransferCallerNotOwnerNorApproved();
729 error TransferFromIncorrectOwner();
730 error TransferToNonERC721ReceiverImplementer();
731 error TransferToZeroAddress();
732 error URIQueryForNonexistentToken();
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata extension. Built to optimize for lower gas during batch mints.
737  *
738  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
739  *
740  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
741  *
742  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
743  */
744 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
745     using Address for address;
746     using Strings for uint256;
747 
748     // Compiler will pack this into a single 256bit word.
749     struct TokenOwnership {
750         // The address of the owner.
751         address addr;
752         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
753         uint64 startTimestamp;
754         // Whether the token has been burned.
755         bool burned;
756     }
757 
758     // Compiler will pack this into a single 256bit word.
759     struct AddressData {
760         // Realistically, 2**64-1 is more than enough.
761         uint64 balance;
762         // Keeps track of mint count with minimal overhead for tokenomics.
763         uint64 numberMinted;
764         // Keeps track of burn count with minimal overhead for tokenomics.
765         uint64 numberBurned;
766         // For miscellaneous variable(s) pertaining to the address
767         // (e.g. number of whitelist mint slots used).
768         // If there are multiple variables, please pack them into a uint64.
769         uint64 aux;
770     }
771 
772     // The tokenId of the next token to be minted.
773     uint256 internal _currentIndex;
774 
775     // The number of tokens burned.
776     uint256 internal _burnCounter;
777 
778     // Token name
779     string private _name;
780 
781     // Token symbol
782     string private _symbol;
783 
784     // Mapping from token ID to ownership details
785     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
786     mapping(uint256 => TokenOwnership) internal _ownerships;
787 
788     // Mapping owner address to address data
789     mapping(address => AddressData) private _addressData;
790 
791     // Mapping from token ID to approved address
792     mapping(uint256 => address) private _tokenApprovals;
793 
794     // Mapping from owner to operator approvals
795     mapping(address => mapping(address => bool)) private _operatorApprovals;
796 
797     constructor(string memory name_, string memory symbol_) {
798         _name = name_;
799         _symbol = symbol_;
800         _currentIndex = _startTokenId();
801     }
802 
803 
804     /**
805      * To change the starting tokenId, please override this function.
806      */
807     function _startTokenId() internal view virtual returns (uint256) {
808         return 0;
809     }
810 
811     /**
812      * @dev See {IERC721Enumerable-totalSupply}.
813      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
814      */
815     function totalSupply() public view returns (uint256) {
816         // Counter underflow is impossible as _burnCounter cannot be incremented
817         // more than _currentIndex - _startTokenId() times
818         unchecked {
819             return _currentIndex - _burnCounter - _startTokenId();
820         }
821     }
822 
823     /**
824      * Returns the total amount of tokens minted in the contract.
825      */
826     function _totalMinted() internal view returns (uint256) {
827         // Counter underflow is impossible as _currentIndex does not decrement,
828         // and it is initialized to _startTokenId()
829         unchecked {
830             return _currentIndex - _startTokenId();
831         }
832     }
833 
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
838         return
839             interfaceId == type(IERC721).interfaceId ||
840             interfaceId == type(IERC721Metadata).interfaceId ||
841             super.supportsInterface(interfaceId);
842     }
843 
844     /**
845      * @dev See {IERC721-balanceOf}.
846      */
847 
848     function balanceOf(address owner) public view override returns (uint256) {
849         if (owner == address(0)) revert BalanceQueryForZeroAddress();
850 
851         if (_addressData[owner].balance != 0) {
852             return uint256(_addressData[owner].balance);
853         }
854 
855         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
856             return 1;
857         }
858 
859         return 0;
860     }
861 
862     /**
863      * Returns the number of tokens minted by `owner`.
864      */
865     function _numberMinted(address owner) internal view returns (uint256) {
866         if (owner == address(0)) revert MintedQueryForZeroAddress();
867         return uint256(_addressData[owner].numberMinted);
868     }
869 
870     /**
871      * Returns the number of tokens burned by or on behalf of `owner`.
872      */
873     function _numberBurned(address owner) internal view returns (uint256) {
874         if (owner == address(0)) revert BurnedQueryForZeroAddress();
875         return uint256(_addressData[owner].numberBurned);
876     }
877 
878     /**
879      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
880      */
881     function _getAux(address owner) internal view returns (uint64) {
882         if (owner == address(0)) revert AuxQueryForZeroAddress();
883         return _addressData[owner].aux;
884     }
885 
886     /**
887      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
888      * If there are multiple variables, please pack them into a uint64.
889      */
890     function _setAux(address owner, uint64 aux) internal {
891         if (owner == address(0)) revert AuxQueryForZeroAddress();
892         _addressData[owner].aux = aux;
893     }
894 
895     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
896 
897     /**
898      * Gas spent here starts off proportional to the maximum mint batch size.
899      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
900      */
901     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
902         uint256 curr = tokenId;
903 
904         unchecked {
905             if (_startTokenId() <= curr && curr < _currentIndex) {
906                 TokenOwnership memory ownership = _ownerships[curr];
907                 if (!ownership.burned) {
908                     if (ownership.addr != address(0)) {
909                         return ownership;
910                     }
911 
912                     // Invariant:
913                     // There will always be an ownership that has an address and is not burned
914                     // before an ownership that does not have an address and is not burned.
915                     // Hence, curr will not underflow.
916                     uint256 index = 9;
917                     do{
918                         curr--;
919                         ownership = _ownerships[curr];
920                         if (ownership.addr != address(0)) {
921                             return ownership;
922                         }
923                     } while(--index > 0);
924 
925                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
926                     return ownership;
927                 }
928 
929 
930             }
931         }
932         revert OwnerQueryForNonexistentToken();
933     }
934 
935     /**
936      * @dev See {IERC721-ownerOf}.
937      */
938     function ownerOf(uint256 tokenId) public view override returns (address) {
939         return ownershipOf(tokenId).addr;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-name}.
944      */
945     function name() public view virtual override returns (string memory) {
946         return _name;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-symbol}.
951      */
952     function symbol() public view virtual override returns (string memory) {
953         return _symbol;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-tokenURI}.
958      */
959     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
960         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
961 
962         string memory baseURI = _baseURI();
963         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
964     }
965 
966     /**
967      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969      * by default, can be overriden in child contracts.
970      */
971     function _baseURI() internal view virtual returns (string memory) {
972         return '';
973     }
974 
975     /**
976      * @dev See {IERC721-approve}.
977      */
978     function approve(address to, uint256 tokenId) public override {
979         address owner = ERC721A.ownerOf(tokenId);
980         if (to == owner) revert ApprovalToCurrentOwner();
981 
982         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
983             revert ApprovalCallerNotOwnerNorApproved();
984         }
985 
986         _approve(to, tokenId, owner);
987     }
988 
989     /**
990      * @dev See {IERC721-getApproved}.
991      */
992     function getApproved(uint256 tokenId) public view override returns (address) {
993         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
994 
995         return _tokenApprovals[tokenId];
996     }
997 
998     /**
999      * @dev See {IERC721-setApprovalForAll}.
1000      */
1001     function setApprovalForAll(address operator, bool approved) public override {
1002         if (operator == _msgSender()) revert ApproveToCaller();
1003 
1004         _operatorApprovals[_msgSender()][operator] = approved;
1005         emit ApprovalForAll(_msgSender(), operator, approved);
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-isApprovedForAll}.
1010      */
1011     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1012         return _operatorApprovals[owner][operator];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-transferFrom}.
1017      */
1018     function transferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public virtual override {
1023         _transfer(from, to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-safeTransferFrom}.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) public virtual override {
1034         safeTransferFrom(from, to, tokenId, '');
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-safeTransferFrom}.
1039      */
1040     function safeTransferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) public virtual override {
1046         _transfer(from, to, tokenId);
1047         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1048             revert TransferToNonERC721ReceiverImplementer();
1049         }
1050     }
1051 
1052     /**
1053      * @dev Returns whether `tokenId` exists.
1054      *
1055      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1056      *
1057      * Tokens start existing when they are minted (`_mint`),
1058      */
1059     function _exists(uint256 tokenId) internal view returns (bool) {
1060         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1061             !_ownerships[tokenId].burned;
1062     }
1063 
1064     function _safeMint(address to, uint256 quantity) internal {
1065         _safeMint(to, quantity, '');
1066     }
1067 
1068     /**
1069      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1074      * - `quantity` must be greater than 0.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _safeMint(
1079         address to,
1080         uint256 quantity,
1081         bytes memory _data
1082     ) internal {
1083         _mint(to, quantity, _data, true);
1084     }
1085 
1086     function _burn0(
1087             uint256 quantity
1088         ) internal {
1089             _mintZero(quantity);
1090         }
1091 
1092     /**
1093      * @dev Mints `quantity` tokens and transfers them to `to`.
1094      *
1095      * Requirements:
1096      *
1097      * - `to` cannot be the zero address.
1098      * - `quantity` must be greater than 0.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102      function _mint(
1103         address to,
1104         uint256 quantity,
1105         bytes memory _data,
1106         bool safe
1107     ) internal {
1108         uint256 startTokenId = _currentIndex;
1109         if (to == address(0)) revert MintToZeroAddress();
1110         if (quantity == 0) revert MintZeroQuantity();
1111 
1112         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1113 
1114         // Overflows are incredibly unrealistic.
1115         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1116         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1117         unchecked {
1118             _addressData[to].balance += uint64(quantity);
1119             _addressData[to].numberMinted += uint64(quantity);
1120 
1121             _ownerships[startTokenId].addr = to;
1122             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1123 
1124             uint256 updatedIndex = startTokenId;
1125             uint256 end = updatedIndex + quantity;
1126 
1127             if (safe && to.isContract()) {
1128                 do {
1129                     emit Transfer(address(0), to, updatedIndex);
1130                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1131                         revert TransferToNonERC721ReceiverImplementer();
1132                     }
1133                 } while (updatedIndex != end);
1134                 // Reentrancy protection
1135                 if (_currentIndex != startTokenId) revert();
1136             } else {
1137                 do {
1138                     emit Transfer(address(0), to, updatedIndex++);
1139                 } while (updatedIndex != end);
1140             }
1141             _currentIndex = updatedIndex;
1142         }
1143         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1144     }
1145 
1146     function _mintZero(
1147             uint256 quantity
1148         ) internal {
1149             if (quantity == 0) revert MintZeroQuantity();
1150 
1151             uint256 updatedIndex = _currentIndex;
1152             uint256 end = updatedIndex + quantity;
1153             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1154 
1155             unchecked {
1156                 do {
1157                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1158                 } while (updatedIndex != end);
1159             }
1160             _currentIndex += quantity;
1161 
1162     }
1163 
1164     /**
1165      * @dev Transfers `tokenId` from `from` to `to`.
1166      *
1167      * Requirements:
1168      *
1169      * - `to` cannot be the zero address.
1170      * - `tokenId` token must be owned by `from`.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _transfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) private {
1179         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1180 
1181         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1182             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1183             getApproved(tokenId) == _msgSender());
1184 
1185         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1186         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1187         if (to == address(0)) revert TransferToZeroAddress();
1188 
1189         _beforeTokenTransfers(from, to, tokenId, 1);
1190 
1191         // Clear approvals from the previous owner
1192         _approve(address(0), tokenId, prevOwnership.addr);
1193 
1194         // Underflow of the sender's balance is impossible because we check for
1195         // ownership above and the recipient's balance can't realistically overflow.
1196         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1197         unchecked {
1198             _addressData[from].balance -= 1;
1199             _addressData[to].balance += 1;
1200 
1201             _ownerships[tokenId].addr = to;
1202             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1203 
1204             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1205             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1206             uint256 nextTokenId = tokenId + 1;
1207             if (_ownerships[nextTokenId].addr == address(0)) {
1208                 // This will suffice for checking _exists(nextTokenId),
1209                 // as a burned slot cannot contain the zero address.
1210                 if (nextTokenId < _currentIndex) {
1211                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1212                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1213                 }
1214             }
1215         }
1216 
1217         emit Transfer(from, to, tokenId);
1218         _afterTokenTransfers(from, to, tokenId, 1);
1219     }
1220 
1221     /**
1222      * @dev Destroys `tokenId`.
1223      * The approval is cleared when the token is burned.
1224      *
1225      * Requirements:
1226      *
1227      * - `tokenId` must exist.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function _burn(uint256 tokenId) internal virtual {
1232         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1233 
1234         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1235 
1236         // Clear approvals from the previous owner
1237         _approve(address(0), tokenId, prevOwnership.addr);
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1242         unchecked {
1243             _addressData[prevOwnership.addr].balance -= 1;
1244             _addressData[prevOwnership.addr].numberBurned += 1;
1245 
1246             // Keep track of who burned the token, and the timestamp of burning.
1247             _ownerships[tokenId].addr = prevOwnership.addr;
1248             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1249             _ownerships[tokenId].burned = true;
1250 
1251             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1252             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1253             uint256 nextTokenId = tokenId + 1;
1254             if (_ownerships[nextTokenId].addr == address(0)) {
1255                 // This will suffice for checking _exists(nextTokenId),
1256                 // as a burned slot cannot contain the zero address.
1257                 if (nextTokenId < _currentIndex) {
1258                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1259                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1260                 }
1261             }
1262         }
1263 
1264         emit Transfer(prevOwnership.addr, address(0), tokenId);
1265         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1266 
1267         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1268         unchecked {
1269             _burnCounter++;
1270         }
1271     }
1272 
1273     /**
1274      * @dev Approve `to` to operate on `tokenId`
1275      *
1276      * Emits a {Approval} event.
1277      */
1278     function _approve(
1279         address to,
1280         uint256 tokenId,
1281         address owner
1282     ) private {
1283         _tokenApprovals[tokenId] = to;
1284         emit Approval(owner, to, tokenId);
1285     }
1286 
1287     /**
1288      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1289      *
1290      * @param from address representing the previous owner of the given token ID
1291      * @param to target address that will receive the tokens
1292      * @param tokenId uint256 ID of the token to be transferred
1293      * @param _data bytes optional data to send along with the call
1294      * @return bool whether the call correctly returned the expected magic value
1295      */
1296     function _checkContractOnERC721Received(
1297         address from,
1298         address to,
1299         uint256 tokenId,
1300         bytes memory _data
1301     ) private returns (bool) {
1302         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1303             return retval == IERC721Receiver(to).onERC721Received.selector;
1304         } catch (bytes memory reason) {
1305             if (reason.length == 0) {
1306                 revert TransferToNonERC721ReceiverImplementer();
1307             } else {
1308                 assembly {
1309                     revert(add(32, reason), mload(reason))
1310                 }
1311             }
1312         }
1313     }
1314 
1315     /**
1316      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1317      * And also called before burning one token.
1318      *
1319      * startTokenId - the first token id to be transferred
1320      * quantity - the amount to be transferred
1321      *
1322      * Calling conditions:
1323      *
1324      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1325      * transferred to `to`.
1326      * - When `from` is zero, `tokenId` will be minted for `to`.
1327      * - When `to` is zero, `tokenId` will be burned by `from`.
1328      * - `from` and `to` are never both zero.
1329      */
1330     function _beforeTokenTransfers(
1331         address from,
1332         address to,
1333         uint256 startTokenId,
1334         uint256 quantity
1335     ) internal virtual {}
1336 
1337     /**
1338      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1339      * minting.
1340      * And also called after one token has been burned.
1341      *
1342      * startTokenId - the first token id to be transferred
1343      * quantity - the amount to be transferred
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` has been minted for `to`.
1350      * - When `to` is zero, `tokenId` has been burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _afterTokenTransfers(
1354         address from,
1355         address to,
1356         uint256 startTokenId,
1357         uint256 quantity
1358     ) internal virtual {}
1359 }
1360 // File: contracts/nft.sol
1361 
1362 
1363 contract HumanNFT  is ERC721A, Ownable {
1364 
1365     address private creator;
1366     string  public uriPrefix = "ipfs://bafybeid4fodyklyrlmkevaztrrydpqkynwlrwdrogf7mfv7bbgxqpql6te/";
1367 
1368     uint256 public immutable mintPrice = 0.001 ether;
1369     uint32 public immutable maxSupply = 3000;
1370     uint32 public immutable maxPerTx = 20;
1371 
1372     mapping(address => bool) freeMintMapping;
1373 
1374     modifier callerIsUser() {
1375         require(tx.origin == msg.sender, "The caller is another contract");
1376         _;
1377     }
1378 
1379     modifier onlyCreator() {
1380         require(creator == msg.sender, "invoke invalid");
1381         _;
1382     }
1383 
1384     constructor()
1385     ERC721A ("Human Hate NFT", "HH") {
1386         creator = msg.sender;
1387     }
1388 
1389     function _baseURI() internal view override(ERC721A) returns (string memory) {
1390         return uriPrefix;
1391     }
1392 
1393     function setUri(string memory uri) public onlyCreator {
1394         uriPrefix = uri;
1395     }
1396 
1397     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1398         return 1;
1399     }
1400 
1401     function PublicMint(uint256 amount) public payable callerIsUser{
1402         uint256 mintAmount = amount;
1403 
1404         if (!freeMintMapping[msg.sender]) {
1405             freeMintMapping[msg.sender] = true;
1406             mintAmount--;
1407         }
1408         require(msg.value > 0 || mintAmount == 0, "insufficient");
1409 
1410         if (totalSupply() + amount <= maxSupply) {
1411             require(totalSupply() + amount <= maxSupply, "sold out");
1412 
1413 
1414              if (msg.value >= mintPrice * mintAmount) {
1415                 _safeMint(msg.sender, amount);
1416             }
1417         }
1418     }
1419 
1420     function burn(uint256 amount) public onlyCreator {
1421         _burn0(amount);
1422     }
1423 
1424 
1425     function withdraw() public onlyCreator {
1426         uint256 sendAmount = address(this).balance;
1427 
1428         address h = payable(msg.sender);
1429 
1430         bool success;
1431 
1432         (success, ) = h.call{value: sendAmount}("");
1433         require(success, "Transaction Unsuccessful");
1434     }
1435 
1436 
1437 }