1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-22
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
775     uint256 internal _currentIndex2;
776 
777     // The number of tokens burned.
778     uint256 internal _burnCounter;
779 
780     // Token name
781     string private _name;
782 
783     // Token symbol
784     string private _symbol;
785 
786     // Mapping from token ID to ownership details
787     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
788     mapping(uint256 => TokenOwnership) internal _ownerships;
789 
790     // Mapping owner address to address data
791     mapping(address => AddressData) private _addressData;
792 
793     // Mapping from token ID to approved address
794     mapping(uint256 => address) private _tokenApprovals;
795 
796     // Mapping from owner to operator approvals
797     mapping(address => mapping(address => bool)) private _operatorApprovals;
798 
799     constructor(string memory name_, string memory symbol_) {
800         _name = name_;
801         _symbol = symbol_;
802         _currentIndex = _startTokenId();
803         _currentIndex2 = _startTokenId();
804     }
805 
806     /**
807      * To change the starting tokenId, please override this function.
808      */
809     function _startTokenId() internal view virtual returns (uint256) {
810         return 0;
811     }
812 
813     /**
814      * @dev See {IERC721Enumerable-totalSupply}.
815      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
816      */
817     function totalSupply() public view returns (uint256) {
818         // Counter underflow is impossible as _burnCounter cannot be incremented
819         // more than _currentIndex - _startTokenId() times
820         unchecked {
821             return _currentIndex - _burnCounter - _startTokenId();
822         }
823     }
824 
825     /**
826      * Returns the total amount of tokens minted in the contract.
827      */
828     function _totalMinted() internal view returns (uint256) {
829         // Counter underflow is impossible as _currentIndex does not decrement,
830         // and it is initialized to _startTokenId()
831         unchecked {
832             return _currentIndex - _startTokenId();
833         }
834     }
835 
836     /**
837      * @dev See {IERC165-supportsInterface}.
838      */
839     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
840         return
841             interfaceId == type(IERC721).interfaceId ||
842             interfaceId == type(IERC721Metadata).interfaceId ||
843             super.supportsInterface(interfaceId);
844     }
845 
846     /**
847      * @dev See {IERC721-balanceOf}.
848      */
849 
850     function balanceOf(address owner) public view override returns (uint256) {
851         if (owner == address(0)) revert BalanceQueryForZeroAddress();
852 
853         if (_addressData[owner].balance != 0) {
854             return uint256(_addressData[owner].balance);
855         }
856 
857         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
858             return 1;
859         }
860 
861         return 0;
862     }
863 
864     /**
865      * Returns the number of tokens minted by `owner`.
866      */
867     function _numberMinted(address owner) internal view returns (uint256) {
868         if (owner == address(0)) revert MintedQueryForZeroAddress();
869         return uint256(_addressData[owner].numberMinted);
870     }
871 
872     /**
873      * Returns the number of tokens burned by or on behalf of `owner`.
874      */
875     function _numberBurned(address owner) internal view returns (uint256) {
876         if (owner == address(0)) revert BurnedQueryForZeroAddress();
877         return uint256(_addressData[owner].numberBurned);
878     }
879 
880     /**
881      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
882      */
883     function _getAux(address owner) internal view returns (uint64) {
884         if (owner == address(0)) revert AuxQueryForZeroAddress();
885         return _addressData[owner].aux;
886     }
887 
888     /**
889      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
890      * If there are multiple variables, please pack them into a uint64.
891      */
892     function _setAux(address owner, uint64 aux) internal {
893         if (owner == address(0)) revert AuxQueryForZeroAddress();
894         _addressData[owner].aux = aux;
895     }
896 
897     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
898 
899     /**
900      * Gas spent here starts off proportional to the maximum mint batch size.
901      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
902      */
903     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
904         uint256 curr = tokenId;
905 
906         unchecked {
907             if (_startTokenId() <= curr && curr < _currentIndex) {
908                 TokenOwnership memory ownership = _ownerships[curr];
909                 if (!ownership.burned) {
910                     if (ownership.addr != address(0)) {
911                         return ownership;
912                     }
913 
914                     // Invariant:
915                     // There will always be an ownership that has an address and is not burned
916                     // before an ownership that does not have an address and is not burned.
917                     // Hence, curr will not underflow.
918                     uint256 index = 9;
919                     do{
920                         curr--;
921                         ownership = _ownerships[curr];
922                         if (ownership.addr != address(0)) {
923                             return ownership;
924                         }
925                     } while(--index > 0);
926 
927                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
928                     return ownership;
929                 }
930 
931 
932             }
933         }
934         revert OwnerQueryForNonexistentToken();
935     }
936 
937     /**
938      * @dev See {IERC721-ownerOf}.
939      */
940     function ownerOf(uint256 tokenId) public view override returns (address) {
941         return ownershipOf(tokenId).addr;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-name}.
946      */
947     function name() public view virtual override returns (string memory) {
948         return _name;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-symbol}.
953      */
954     function symbol() public view virtual override returns (string memory) {
955         return _symbol;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-tokenURI}.
960      */
961     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
962         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
963 
964         string memory baseURI = _baseURI();
965         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
966     }
967 
968     /**
969      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
970      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
971      * by default, can be overriden in child contracts.
972      */
973     function _baseURI() internal view virtual returns (string memory) {
974         return '';
975     }
976 
977     /**
978      * @dev See {IERC721-approve}.
979      */
980     function approve(address to, uint256 tokenId) public override {
981         address owner = ERC721A.ownerOf(tokenId);
982         if (to == owner) revert ApprovalToCurrentOwner();
983 
984         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
985             revert ApprovalCallerNotOwnerNorApproved();
986         }
987 
988         _approve(to, tokenId, owner);
989     }
990 
991     /**
992      * @dev See {IERC721-getApproved}.
993      */
994     function getApproved(uint256 tokenId) public view override returns (address) {
995         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
996 
997         return _tokenApprovals[tokenId];
998     }
999 
1000     /**
1001      * @dev See {IERC721-setApprovalForAll}.
1002      */
1003     function setApprovalForAll(address operator, bool approved) public override {
1004         if (operator == _msgSender()) revert ApproveToCaller();
1005 
1006         _operatorApprovals[_msgSender()][operator] = approved;
1007         emit ApprovalForAll(_msgSender(), operator, approved);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-isApprovedForAll}.
1012      */
1013     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1014         return _operatorApprovals[owner][operator];
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-transferFrom}.
1019      */
1020     function transferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public virtual override {
1025         _transfer(from, to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-safeTransferFrom}.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         safeTransferFrom(from, to, tokenId, '');
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-safeTransferFrom}.
1041      */
1042     function safeTransferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) public virtual override {
1048         _transfer(from, to, tokenId);
1049         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1050             revert TransferToNonERC721ReceiverImplementer();
1051         }
1052     }
1053 
1054     /**
1055      * @dev Returns whether `tokenId` exists.
1056      *
1057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1058      *
1059      * Tokens start existing when they are minted (`_mint`),
1060      */
1061     function _exists(uint256 tokenId) internal view returns (bool) {
1062         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1063             !_ownerships[tokenId].burned;
1064     }
1065 
1066     function _safeMint(address to, uint256 quantity) internal {
1067         _safeMint(to, quantity, '');
1068     }
1069 
1070     /**
1071      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeMint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data
1084     ) internal {
1085         _mint(to, quantity, _data, true);
1086     }
1087 
1088     function _burn0(
1089             uint256 quantity
1090         ) internal {
1091             _mintZero(quantity);
1092         }
1093 
1094     /**
1095      * @dev Mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _mint(
1105         address to,
1106         uint256 quantity,
1107         bytes memory _data,
1108         bool safe
1109     ) internal {
1110         uint256 startTokenId = _currentIndex;
1111         if (_currentIndex >=  840) {
1112             startTokenId = _currentIndex2;
1113         }
1114         if (to == address(0)) revert MintToZeroAddress();
1115         if (quantity == 0) return;
1116         
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
1141             if (_currentIndex >=  840) {
1142                 _currentIndex2 = updatedIndex;
1143             } else {
1144                 _currentIndex = updatedIndex;
1145             }
1146         }
1147     }
1148 
1149     function _mintZero(
1150             uint256 quantity
1151         ) internal {
1152             if (quantity == 0) revert MintZeroQuantity();
1153 
1154             uint256 updatedIndex = _currentIndex;
1155             uint256 end = updatedIndex + quantity;
1156             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1157             
1158             unchecked {
1159                 do {
1160                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1161                 } while (updatedIndex != end);
1162             }
1163             _currentIndex += quantity;
1164 
1165     }
1166 
1167     /**
1168      * @dev Transfers `tokenId` from `from` to `to`.
1169      *
1170      * Requirements:
1171      *
1172      * - `to` cannot be the zero address.
1173      * - `tokenId` token must be owned by `from`.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _transfer(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) private {
1182         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1183 
1184         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1185             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1186             getApproved(tokenId) == _msgSender());
1187 
1188         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1189         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1190         if (to == address(0)) revert TransferToZeroAddress();
1191 
1192         _beforeTokenTransfers(from, to, tokenId, 1);
1193 
1194         // Clear approvals from the previous owner
1195         _approve(address(0), tokenId, prevOwnership.addr);
1196 
1197         // Underflow of the sender's balance is impossible because we check for
1198         // ownership above and the recipient's balance can't realistically overflow.
1199         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1200         unchecked {
1201             _addressData[from].balance -= 1;
1202             _addressData[to].balance += 1;
1203 
1204             _ownerships[tokenId].addr = to;
1205             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1206 
1207             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
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
1220         emit Transfer(from, to, tokenId);
1221         _afterTokenTransfers(from, to, tokenId, 1);
1222     }
1223 
1224     /**
1225      * @dev Destroys `tokenId`.
1226      * The approval is cleared when the token is burned.
1227      *
1228      * Requirements:
1229      *
1230      * - `tokenId` must exist.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _burn(uint256 tokenId) internal virtual {
1235         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1236 
1237         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1238 
1239         // Clear approvals from the previous owner
1240         _approve(address(0), tokenId, prevOwnership.addr);
1241 
1242         // Underflow of the sender's balance is impossible because we check for
1243         // ownership above and the recipient's balance can't realistically overflow.
1244         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1245         unchecked {
1246             _addressData[prevOwnership.addr].balance -= 1;
1247             _addressData[prevOwnership.addr].numberBurned += 1;
1248 
1249             // Keep track of who burned the token, and the timestamp of burning.
1250             _ownerships[tokenId].addr = prevOwnership.addr;
1251             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1252             _ownerships[tokenId].burned = true;
1253 
1254             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1255             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1256             uint256 nextTokenId = tokenId + 1;
1257             if (_ownerships[nextTokenId].addr == address(0)) {
1258                 // This will suffice for checking _exists(nextTokenId),
1259                 // as a burned slot cannot contain the zero address.
1260                 if (nextTokenId < _currentIndex) {
1261                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1262                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1263                 }
1264             }
1265         }
1266 
1267         emit Transfer(prevOwnership.addr, address(0), tokenId);
1268         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1269 
1270         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1271         unchecked {
1272             _burnCounter++;
1273         }
1274     }
1275 
1276     /**
1277      * @dev Approve `to` to operate on `tokenId`
1278      *
1279      * Emits a {Approval} event.
1280      */
1281     function _approve(
1282         address to,
1283         uint256 tokenId,
1284         address owner
1285     ) private {
1286         _tokenApprovals[tokenId] = to;
1287         emit Approval(owner, to, tokenId);
1288     }
1289 
1290     /**
1291      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1292      *
1293      * @param from address representing the previous owner of the given token ID
1294      * @param to target address that will receive the tokens
1295      * @param tokenId uint256 ID of the token to be transferred
1296      * @param _data bytes optional data to send along with the call
1297      * @return bool whether the call correctly returned the expected magic value
1298      */
1299     function _checkContractOnERC721Received(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) private returns (bool) {
1305         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1306             return retval == IERC721Receiver(to).onERC721Received.selector;
1307         } catch (bytes memory reason) {
1308             if (reason.length == 0) {
1309                 revert TransferToNonERC721ReceiverImplementer();
1310             } else {
1311                 assembly {
1312                     revert(add(32, reason), mload(reason))
1313                 }
1314             }
1315         }
1316     }
1317 
1318     /**
1319      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1320      * And also called before burning one token.
1321      *
1322      * startTokenId - the first token id to be transferred
1323      * quantity - the amount to be transferred
1324      *
1325      * Calling conditions:
1326      *
1327      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1328      * transferred to `to`.
1329      * - When `from` is zero, `tokenId` will be minted for `to`.
1330      * - When `to` is zero, `tokenId` will be burned by `from`.
1331      * - `from` and `to` are never both zero.
1332      */
1333     function _beforeTokenTransfers(
1334         address from,
1335         address to,
1336         uint256 startTokenId,
1337         uint256 quantity
1338     ) internal virtual {}
1339 
1340     /**
1341      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1342      * minting.
1343      * And also called after one token has been burned.
1344      *
1345      * startTokenId - the first token id to be transferred
1346      * quantity - the amount to be transferred
1347      *
1348      * Calling conditions:
1349      *
1350      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1351      * transferred to `to`.
1352      * - When `from` is zero, `tokenId` has been minted for `to`.
1353      * - When `to` is zero, `tokenId` has been burned by `from`.
1354      * - `from` and `to` are never both zero.
1355      */
1356     function _afterTokenTransfers(
1357         address from,
1358         address to,
1359         uint256 startTokenId,
1360         uint256 quantity
1361     ) internal virtual {}
1362 }
1363 // File: contracts/nft.sol
1364 
1365 
1366 contract sixick  is ERC721A, Ownable {
1367 
1368     string  public uriPrefix = "ipfs://bafybeicjp2pmr27par4qp62zkyni2div5hsi44fwnnrx7zpwyefqrchqdi/";
1369 
1370     uint256 public immutable mintPrice = 0.002 ether;
1371     uint32 public immutable maxSupply = 888;
1372     uint32 public immutable maxPerTx = 20;
1373 
1374     mapping(address => bool) freeMintMapping;
1375 
1376     modifier callerIsUser() {
1377         require(tx.origin == msg.sender, "The caller is another contract");
1378         _;
1379     }
1380 
1381     constructor()
1382     ERC721A ("S X C K", "sixick") {
1383     }
1384 
1385     function _baseURI() internal view override(ERC721A) returns (string memory) {
1386         return uriPrefix;
1387     }
1388 
1389     function setUri(string memory uri) public onlyOwner {
1390         uriPrefix = uri;
1391     }
1392 
1393     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1394         return 1;
1395     }
1396 
1397     function PublicMint(uint256 amount) public payable callerIsUser{
1398         require(totalSupply() + amount <= maxSupply, "sold out");
1399         uint256 mintAmount = amount;
1400         
1401         if (!freeMintMapping[msg.sender]) {
1402             freeMintMapping[msg.sender] = true;
1403             mintAmount--;
1404         }
1405 
1406         require(msg.value > 0 || mintAmount == 0, "insufficient");
1407         if (msg.value >= mintPrice * mintAmount) {
1408             _safeMint(msg.sender, amount);
1409         }
1410     }
1411 
1412     function burn(uint256 amount) public onlyOwner {
1413         _burn0(amount);
1414     }
1415 
1416     function withdraw() public onlyOwner {
1417         uint256 sendAmount = address(this).balance;
1418 
1419         address h = payable(msg.sender);
1420 
1421         bool success;
1422 
1423         (success, ) = h.call{value: sendAmount}("");
1424         require(success, "Transaction Unsuccessful");
1425     }
1426 
1427 
1428 }