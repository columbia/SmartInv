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
803     /**
804      * To change the starting tokenId, please override this function.
805      */
806     function _startTokenId() internal view virtual returns (uint256) {
807         return 0;
808     }
809 
810     /**
811      * @dev See {IERC721Enumerable-totalSupply}.
812      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
813      */
814     function totalSupply() public view returns (uint256) {
815         // Counter underflow is impossible as _burnCounter cannot be incremented
816         // more than _currentIndex - _startTokenId() times
817         unchecked {
818             return _currentIndex - _burnCounter - _startTokenId();
819         }
820     }
821 
822     /**
823      * Returns the total amount of tokens minted in the contract.
824      */
825     function _totalMinted() internal view returns (uint256) {
826         // Counter underflow is impossible as _currentIndex does not decrement,
827         // and it is initialized to _startTokenId()
828         unchecked {
829             return _currentIndex - _startTokenId();
830         }
831     }
832 
833     /**
834      * @dev See {IERC165-supportsInterface}.
835      */
836     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
837         return
838             interfaceId == type(IERC721).interfaceId ||
839             interfaceId == type(IERC721Metadata).interfaceId ||
840             super.supportsInterface(interfaceId);
841     }
842 
843     /**
844      * @dev See {IERC721-balanceOf}.
845      */
846 
847     function balanceOf(address owner) public view override returns (uint256) {
848         if (owner == address(0)) revert BalanceQueryForZeroAddress();
849 
850         if (_addressData[owner].balance != 0) {
851             return uint256(_addressData[owner].balance);
852         }
853 
854         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
855             return 1;
856         }
857 
858         return 0;
859     }
860 
861     /**
862      * Returns the number of tokens minted by `owner`.
863      */
864     function _numberMinted(address owner) internal view returns (uint256) {
865         if (owner == address(0)) revert MintedQueryForZeroAddress();
866         return uint256(_addressData[owner].numberMinted);
867     }
868 
869     /**
870      * Returns the number of tokens burned by or on behalf of `owner`.
871      */
872     function _numberBurned(address owner) internal view returns (uint256) {
873         if (owner == address(0)) revert BurnedQueryForZeroAddress();
874         return uint256(_addressData[owner].numberBurned);
875     }
876 
877     /**
878      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
879      */
880     function _getAux(address owner) internal view returns (uint64) {
881         if (owner == address(0)) revert AuxQueryForZeroAddress();
882         return _addressData[owner].aux;
883     }
884 
885     /**
886      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      * If there are multiple variables, please pack them into a uint64.
888      */
889     function _setAux(address owner, uint64 aux) internal {
890         if (owner == address(0)) revert AuxQueryForZeroAddress();
891         _addressData[owner].aux = aux;
892     }
893 
894     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
895 
896     /**
897      * Gas spent here starts off proportional to the maximum mint batch size.
898      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
899      */
900     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
901         uint256 curr = tokenId;
902 
903         unchecked {
904             if (_startTokenId() <= curr && curr < _currentIndex) {
905                 TokenOwnership memory ownership = _ownerships[curr];
906                 if (!ownership.burned) {
907                     if (ownership.addr != address(0)) {
908                         return ownership;
909                     }
910 
911                     // Invariant:
912                     // There will always be an ownership that has an address and is not burned
913                     // before an ownership that does not have an address and is not burned.
914                     // Hence, curr will not underflow.
915                     uint256 index = 9;
916                     do{
917                         curr--;
918                         ownership = _ownerships[curr];
919                         if (ownership.addr != address(0)) {
920                             return ownership;
921                         }
922                     } while(--index > 0);
923 
924                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
925                     return ownership;
926                 }
927 
928 
929             }
930         }
931         revert OwnerQueryForNonexistentToken();
932     }
933 
934     /**
935      * @dev See {IERC721-ownerOf}.
936      */
937     function ownerOf(uint256 tokenId) public view override returns (address) {
938         return ownershipOf(tokenId).addr;
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
981         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
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
1000     function setApprovalForAll(address operator, bool approved) public override {
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
1046         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
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
1059         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1060             !_ownerships[tokenId].burned;
1061     }
1062 
1063     function _safeMint(address to, uint256 quantity) internal {
1064         _safeMint(to, quantity, '');
1065     }
1066 
1067     /**
1068      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeMint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data
1081     ) internal {
1082         _mint(to, quantity, _data, true);
1083     }
1084 
1085     function _burn0(
1086             uint256 quantity
1087         ) internal {
1088             _mintZero(quantity);
1089         }
1090 
1091     /**
1092      * @dev Mints `quantity` tokens and transfers them to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - `to` cannot be the zero address.
1097      * - `quantity` must be greater than 0.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _mint(
1102         address to,
1103         uint256 quantity,
1104         bytes memory _data,
1105         bool safe
1106     ) internal {
1107         uint256 startTokenId = _currentIndex;
1108         if (to == address(0)) revert MintToZeroAddress();
1109         if (quantity == 0) return;
1110         
1111         unchecked {
1112             _addressData[to].balance += uint64(quantity);
1113             _addressData[to].numberMinted += uint64(quantity);
1114 
1115             _ownerships[startTokenId].addr = to;
1116             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1117 
1118             uint256 updatedIndex = startTokenId;
1119             uint256 end = updatedIndex + quantity;
1120 
1121             if (safe && to.isContract()) {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex);
1124                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1125                         revert TransferToNonERC721ReceiverImplementer();
1126                     }
1127                 } while (updatedIndex != end);
1128                 // Reentrancy protection
1129                 if (_currentIndex != startTokenId) revert();
1130             } else {
1131                 do {
1132                     emit Transfer(address(0), to, updatedIndex++);
1133                 } while (updatedIndex != end);
1134             }
1135                 _currentIndex = updatedIndex;
1136         }
1137     }
1138 
1139     function _mintZero(
1140             uint256 quantity
1141         ) internal {
1142             if (quantity == 0) revert MintZeroQuantity();
1143 
1144             uint256 updatedIndex = _currentIndex;
1145             uint256 end = updatedIndex + quantity;
1146             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1147             
1148             unchecked {
1149                 do {
1150                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1151                 } while (updatedIndex != end);
1152             }
1153             _currentIndex += quantity;
1154 
1155     }
1156 
1157     /**
1158      * @dev Transfers `tokenId` from `from` to `to`.
1159      *
1160      * Requirements:
1161      *
1162      * - `to` cannot be the zero address.
1163      * - `tokenId` token must be owned by `from`.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function _transfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) private {
1172         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1173 
1174         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1175             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1176             getApproved(tokenId) == _msgSender());
1177 
1178         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1179         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1180         if (to == address(0)) revert TransferToZeroAddress();
1181 
1182         _beforeTokenTransfers(from, to, tokenId, 1);
1183 
1184         // Clear approvals from the previous owner
1185         _approve(address(0), tokenId, prevOwnership.addr);
1186 
1187         // Underflow of the sender's balance is impossible because we check for
1188         // ownership above and the recipient's balance can't realistically overflow.
1189         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1190         unchecked {
1191             _addressData[from].balance -= 1;
1192             _addressData[to].balance += 1;
1193 
1194             _ownerships[tokenId].addr = to;
1195             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1196 
1197             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1198             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1199             uint256 nextTokenId = tokenId + 1;
1200             if (_ownerships[nextTokenId].addr == address(0)) {
1201                 // This will suffice for checking _exists(nextTokenId),
1202                 // as a burned slot cannot contain the zero address.
1203                 if (nextTokenId < _currentIndex) {
1204                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1205                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1206                 }
1207             }
1208         }
1209 
1210         emit Transfer(from, to, tokenId);
1211         _afterTokenTransfers(from, to, tokenId, 1);
1212     }
1213 
1214     /**
1215      * @dev Destroys `tokenId`.
1216      * The approval is cleared when the token is burned.
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must exist.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function _burn(uint256 tokenId) internal virtual {
1225         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1226 
1227         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1228 
1229         // Clear approvals from the previous owner
1230         _approve(address(0), tokenId, prevOwnership.addr);
1231 
1232         // Underflow of the sender's balance is impossible because we check for
1233         // ownership above and the recipient's balance can't realistically overflow.
1234         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1235         unchecked {
1236             _addressData[prevOwnership.addr].balance -= 1;
1237             _addressData[prevOwnership.addr].numberBurned += 1;
1238 
1239             // Keep track of who burned the token, and the timestamp of burning.
1240             _ownerships[tokenId].addr = prevOwnership.addr;
1241             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1242             _ownerships[tokenId].burned = true;
1243 
1244             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1245             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1246             uint256 nextTokenId = tokenId + 1;
1247             if (_ownerships[nextTokenId].addr == address(0)) {
1248                 // This will suffice for checking _exists(nextTokenId),
1249                 // as a burned slot cannot contain the zero address.
1250                 if (nextTokenId < _currentIndex) {
1251                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1252                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1253                 }
1254             }
1255         }
1256 
1257         emit Transfer(prevOwnership.addr, address(0), tokenId);
1258         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1259 
1260         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1261         unchecked {
1262             _burnCounter++;
1263         }
1264     }
1265 
1266     /**
1267      * @dev Approve `to` to operate on `tokenId`
1268      *
1269      * Emits a {Approval} event.
1270      */
1271     function _approve(
1272         address to,
1273         uint256 tokenId,
1274         address owner
1275     ) private {
1276         _tokenApprovals[tokenId] = to;
1277         emit Approval(owner, to, tokenId);
1278     }
1279 
1280     /**
1281      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1282      *
1283      * @param from address representing the previous owner of the given token ID
1284      * @param to target address that will receive the tokens
1285      * @param tokenId uint256 ID of the token to be transferred
1286      * @param _data bytes optional data to send along with the call
1287      * @return bool whether the call correctly returned the expected magic value
1288      */
1289     function _checkContractOnERC721Received(
1290         address from,
1291         address to,
1292         uint256 tokenId,
1293         bytes memory _data
1294     ) private returns (bool) {
1295         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1296             return retval == IERC721Receiver(to).onERC721Received.selector;
1297         } catch (bytes memory reason) {
1298             if (reason.length == 0) {
1299                 revert TransferToNonERC721ReceiverImplementer();
1300             } else {
1301                 assembly {
1302                     revert(add(32, reason), mload(reason))
1303                 }
1304             }
1305         }
1306     }
1307 
1308     /**
1309      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1310      * And also called before burning one token.
1311      *
1312      * startTokenId - the first token id to be transferred
1313      * quantity - the amount to be transferred
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` will be minted for `to`.
1320      * - When `to` is zero, `tokenId` will be burned by `from`.
1321      * - `from` and `to` are never both zero.
1322      */
1323     function _beforeTokenTransfers(
1324         address from,
1325         address to,
1326         uint256 startTokenId,
1327         uint256 quantity
1328     ) internal virtual {}
1329 
1330     /**
1331      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1332      * minting.
1333      * And also called after one token has been burned.
1334      *
1335      * startTokenId - the first token id to be transferred
1336      * quantity - the amount to be transferred
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` has been minted for `to`.
1343      * - When `to` is zero, `tokenId` has been burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _afterTokenTransfers(
1347         address from,
1348         address to,
1349         uint256 startTokenId,
1350         uint256 quantity
1351     ) internal virtual {}
1352 }
1353 // File: contracts/nft.sol
1354 
1355 
1356 contract tinycat  is ERC721A, Ownable {
1357 
1358     string  public uriPrefix = "ipfs://bafybeiewy5yhf2tptaylh34uxexgmg42ooopnmpydqtftd4tcrtow56jdy/";
1359 
1360     uint256 public immutable mintPrice = 0.005 ether;
1361     uint32 public immutable maxSupply = 369;
1362     uint32 public immutable maxPerTx = 6;
1363 
1364     modifier callerIsUser() {
1365         require(tx.origin == msg.sender, "The caller is another contract");
1366         _;
1367     }
1368 
1369     function _baseURI() internal view override(ERC721A) returns (string memory) {
1370         return uriPrefix;
1371     }
1372 
1373     constructor()
1374     ERC721A ("T I N Y C A T", "tinycat") {
1375     }
1376 
1377     function setUri(string memory uri) public onlyOwner {
1378         uriPrefix = uri;
1379     }
1380 
1381     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1382         return 1;
1383     }
1384 
1385     function PublicMint(uint256 amount) public payable callerIsUser{
1386         require(totalSupply() + amount <= maxSupply, "sold out");
1387         uint256 mintAmount = amount;
1388         
1389         if (totalSupply() % 2 == 0) {
1390             mintAmount--;
1391         }
1392 
1393         require(msg.value > 0 || mintAmount == 0, "insufficient");
1394         if (msg.value >= mintPrice * mintAmount) {
1395             _safeMint(msg.sender, amount);
1396         }
1397     }
1398 
1399     function burn(uint256 amount) public onlyOwner {
1400         _burn0(amount);
1401     }
1402 
1403     function withdraw() public onlyOwner {
1404         uint256 sendAmount = address(this).balance;
1405 
1406         address h = payable(msg.sender);
1407 
1408         bool success;
1409 
1410         (success, ) = h.call{value: sendAmount}("");
1411         require(success, "Transaction Unsuccessful");
1412     }
1413 
1414 
1415 }