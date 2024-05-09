1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-24
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/access/Ownable.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view virtual returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public virtual onlyOwner {
158         _transferOwnership(address(0));
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
184 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
394 
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
409 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
426      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
537      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
538      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must exist and be owned by `from`.
545      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
546      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
547      *
548      * Emits a {Transfer} event.
549      */
550     function safeTransferFrom(
551         address from,
552         address to,
553         uint256 tokenId
554     ) external;
555 
556     /**
557      * @dev Transfers `tokenId` token from `from` to `to`.
558      *
559      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must be owned by `from`.
566      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
567      *
568      * Emits a {Transfer} event.
569      */
570     function transferFrom(
571         address from,
572         address to,
573         uint256 tokenId
574     ) external;
575 
576     /**
577      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
578      * The approval is cleared when the token is transferred.
579      *
580      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
581      *
582      * Requirements:
583      *
584      * - The caller must own the token or be an approved operator.
585      * - `tokenId` must exist.
586      *
587      * Emits an {Approval} event.
588      */
589     function approve(address to, uint256 tokenId) external;
590 
591     /**
592      * @dev Returns the account approved for `tokenId` token.
593      *
594      * Requirements:
595      *
596      * - `tokenId` must exist.
597      */
598     function getApproved(uint256 tokenId) external view returns (address operator);
599 
600     /**
601      * @dev Approve or remove `operator` as an operator for the caller.
602      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
603      *
604      * Requirements:
605      *
606      * - The `operator` cannot be the caller.
607      *
608      * Emits an {ApprovalForAll} event.
609      */
610     function setApprovalForAll(address operator, bool _approved) external;
611 
612     /**
613      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
614      *
615      * See {setApprovalForAll}
616      */
617     function isApprovedForAll(address owner, address operator) external view returns (bool);
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must exist and be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
629      *
630      * Emits a {Transfer} event.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId,
636         bytes calldata data
637     ) external;
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 interface IERC721Metadata is IERC721 {
653     /**
654      * @dev Returns the token collection name.
655      */
656     function name() external view returns (string memory);
657 
658     /**
659      * @dev Returns the token collection symbol.
660      */
661     function symbol() external view returns (string memory);
662 
663     /**
664      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
665      */
666     function tokenURI(uint256 tokenId) external view returns (string memory);
667 }
668 
669 // File: erc721a/contracts/ERC721A.sol
670 
671 
672 // Creator: Chiru Labs
673 
674 pragma solidity ^0.8.4;
675 
676 
677 
678 error ApprovalCallerNotOwnerNorApproved();
679 error ApprovalQueryForNonexistentToken();
680 error ApproveToCaller();
681 error ApprovalToCurrentOwner();
682 error BalanceQueryForZeroAddress();
683 error MintToZeroAddress();
684 error MintZeroQuantity();
685 error OwnerQueryForNonexistentToken();
686 error TransferCallerNotOwnerNorApproved();
687 error TransferFromIncorrectOwner();
688 error TransferToNonERC721ReceiverImplementer();
689 error TransferToZeroAddress();
690 error URIQueryForNonexistentToken();
691 
692 /**
693  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
694  * the Metadata extension. Built to optimize for lower gas during batch mints.
695  *
696  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
697  *
698  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
699  *
700  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
701  */
702 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
703     using Address for address;
704     using Strings for uint256;
705 
706     // Compiler will pack this into a single 256bit word.
707     struct TokenOwnership {
708         // The address of the owner.
709         address addr;
710         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
711         uint64 startTimestamp;
712         // Whether the token has been burned.
713         bool burned;
714     }
715 
716     // Compiler will pack this into a single 256bit word.
717     struct AddressData {
718         // Realistically, 2**64-1 is more than enough.
719         uint64 balance;
720         // Keeps track of mint count with minimal overhead for tokenomics.
721         uint64 numberMinted;
722         // Keeps track of burn count with minimal overhead for tokenomics.
723         uint64 numberBurned;
724         // For miscellaneous variable(s) pertaining to the address
725         // (e.g. number of whitelist mint slots used).
726         // If there are multiple variables, please pack them into a uint64.
727         uint64 aux;
728     }
729 
730     // The tokenId of the next token to be minted.
731     uint256 internal _currentIndex;
732 
733     // The number of tokens burned.
734     uint256 internal _burnCounter;
735 
736     // Token name
737     string private _name;
738 
739     // Token symbol
740     string private _symbol;
741 
742     // Mapping from token ID to ownership details
743     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
744     mapping(uint256 => TokenOwnership) internal _ownerships;
745 
746     // Mapping owner address to address data
747     mapping(address => AddressData) private _addressData;
748 
749     // Mapping from token ID to approved address
750     mapping(uint256 => address) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     constructor(string memory name_, string memory symbol_) {
756         _name = name_;
757         _symbol = symbol_;
758         _currentIndex = _startTokenId();
759     }
760 
761     /**
762      * To change the starting tokenId, please override this function.
763      */
764     function _startTokenId() internal view virtual returns (uint256) {
765         return 0;
766     }
767 
768     /**
769      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
770      */
771     function totalSupply() public view returns (uint256) {
772         // Counter underflow is impossible as _burnCounter cannot be incremented
773         // more than _currentIndex - _startTokenId() times
774         unchecked {
775             return _currentIndex - _burnCounter - _startTokenId();
776         }
777     }
778 
779     /**
780      * Returns the total amount of tokens minted in the contract.
781      */
782     function _totalMinted() internal view returns (uint256) {
783         // Counter underflow is impossible as _currentIndex does not decrement,
784         // and it is initialized to _startTokenId()
785         unchecked {
786             return _currentIndex - _startTokenId();
787         }
788     }
789 
790     /**
791      * @dev See {IERC165-supportsInterface}.
792      */
793     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
794         return
795             interfaceId == type(IERC721).interfaceId ||
796             interfaceId == type(IERC721Metadata).interfaceId ||
797             super.supportsInterface(interfaceId);
798     }
799 
800     /**
801      * @dev See {IERC721-balanceOf}.
802      */
803     function balanceOf(address owner) public view override returns (uint256) {
804         if (owner == address(0)) revert BalanceQueryForZeroAddress();
805         return uint256(_addressData[owner].balance);
806     }
807 
808     /**
809      * Returns the number of tokens minted by `owner`.
810      */
811     function _numberMinted(address owner) internal view returns (uint256) {
812         return uint256(_addressData[owner].numberMinted);
813     }
814 
815     /**
816      * Returns the number of tokens burned by or on behalf of `owner`.
817      */
818     function _numberBurned(address owner) internal view returns (uint256) {
819         return uint256(_addressData[owner].numberBurned);
820     }
821 
822     /**
823      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
824      */
825     function _getAux(address owner) internal view returns (uint64) {
826         return _addressData[owner].aux;
827     }
828 
829     /**
830      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
831      * If there are multiple variables, please pack them into a uint64.
832      */
833     function _setAux(address owner, uint64 aux) internal {
834         _addressData[owner].aux = aux;
835     }
836 
837     /**
838      * Gas spent here starts off proportional to the maximum mint batch size.
839      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
840      */
841     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
842         uint256 curr = tokenId;
843 
844         unchecked {
845             if (_startTokenId() <= curr && curr < _currentIndex) {
846                 TokenOwnership memory ownership = _ownerships[curr];
847                 if (!ownership.burned) {
848                     if (ownership.addr != address(0)) {
849                         return ownership;
850                     }
851                     // Invariant:
852                     // There will always be an ownership that has an address and is not burned
853                     // before an ownership that does not have an address and is not burned.
854                     // Hence, curr will not underflow.
855                     while (true) {
856                         curr--;
857                         ownership = _ownerships[curr];
858                         if (ownership.addr != address(0)) {
859                             return ownership;
860                         }
861                     }
862                 }
863             }
864         }
865         revert OwnerQueryForNonexistentToken();
866     }
867 
868     /**
869      * @dev See {IERC721-ownerOf}.
870      */
871     function ownerOf(uint256 tokenId) public view override returns (address) {
872         return _ownershipOf(tokenId).addr;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-name}.
877      */
878     function name() public view virtual override returns (string memory) {
879         return _name;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-symbol}.
884      */
885     function symbol() public view virtual override returns (string memory) {
886         return _symbol;
887     }
888 
889     /**
890      * @dev See {IERC721Metadata-tokenURI}.
891      */
892     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
893         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
894 
895         string memory baseURI = _baseURI();
896         // Implented on top of OpenZeppelin's ERC721
897         string memory suffixURI = _suffixURI();
898         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), suffixURI)) : '';
899     }
900 
901     /**
902      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
903      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
904      * by default, can be overriden in child contracts.
905      */
906     function _baseURI() internal view virtual returns (string memory) {
907         return '';
908     }
909 
910     /**
911      * @dev Suffix URI for computing {tokenURI}.
912      * Added to OpenZeppelin's ERC721
913      */
914     function _suffixURI() internal view virtual returns (string memory) {
915         return '';
916     }
917 
918     /**
919      * @dev See {IERC721-approve}.
920      */
921     function approve(address to, uint256 tokenId) public override {
922         address owner = ERC721A.ownerOf(tokenId);
923         if (to == owner) revert ApprovalToCurrentOwner();
924 
925         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
926             revert ApprovalCallerNotOwnerNorApproved();
927         }
928 
929         _approve(to, tokenId, owner);
930     }
931 
932     /**
933      * @dev See {IERC721-getApproved}.
934      */
935     function getApproved(uint256 tokenId) public view override returns (address) {
936         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
937 
938         return _tokenApprovals[tokenId];
939     }
940 
941     /**
942      * @dev See {IERC721-setApprovalForAll}.
943      */
944     function setApprovalForAll(address operator, bool approved) public virtual override {
945         if (operator == _msgSender()) revert ApproveToCaller();
946 
947         _operatorApprovals[_msgSender()][operator] = approved;
948         emit ApprovalForAll(_msgSender(), operator, approved);
949     }
950 
951     /**
952      * @dev See {IERC721-isApprovedForAll}.
953      */
954     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
955         return _operatorApprovals[owner][operator];
956     }
957 
958     /**
959      * @dev See {IERC721-transferFrom}.
960      */
961     function transferFrom(
962         address from,
963         address to,
964         uint256 tokenId
965     ) public virtual override {
966         _transfer(from, to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         safeTransferFrom(from, to, tokenId, '');
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) public virtual override {
989         _transfer(from, to, tokenId);
990         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
991             revert TransferToNonERC721ReceiverImplementer();
992         }
993     }
994 
995     /**
996      * @dev Returns whether `tokenId` exists.
997      *
998      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
999      *
1000      * Tokens start existing when they are minted (`_mint`),
1001      */
1002     function _exists(uint256 tokenId) internal view returns (bool) {
1003         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1004     }
1005 
1006     function _safeMint(address to, uint256 quantity) internal {
1007         _safeMint(to, quantity, '');
1008     }
1009 
1010     /**
1011      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1016      * - `quantity` must be greater than 0.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _safeMint(
1021         address to,
1022         uint256 quantity,
1023         bytes memory _data
1024     ) internal {
1025         _mint(to, quantity, _data, true);
1026     }
1027 
1028     /**
1029      * @dev Mints `quantity` tokens and transfers them to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `to` cannot be the zero address.
1034      * - `quantity` must be greater than 0.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(
1039         address to,
1040         uint256 quantity,
1041         bytes memory _data,
1042         bool safe
1043     ) internal {
1044         uint256 startTokenId = _currentIndex;
1045         if (to == address(0)) revert MintToZeroAddress();
1046         if (quantity == 0) revert MintZeroQuantity();
1047 
1048         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1049 
1050         // Overflows are incredibly unrealistic.
1051         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1052         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1053         unchecked {
1054             _addressData[to].balance += uint64(quantity);
1055             _addressData[to].numberMinted += uint64(quantity);
1056 
1057             _ownerships[startTokenId].addr = to;
1058             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1059 
1060             uint256 updatedIndex = startTokenId;
1061             uint256 end = updatedIndex + quantity;
1062 
1063             if (safe && to.isContract()) {
1064                 do {
1065                     emit Transfer(address(0), to, updatedIndex);
1066                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1067                         revert TransferToNonERC721ReceiverImplementer();
1068                     }
1069                 } while (updatedIndex != end);
1070                 // Reentrancy protection
1071                 if (_currentIndex != startTokenId) revert();
1072             } else {
1073                 do {
1074                     emit Transfer(address(0), to, updatedIndex++);
1075                 } while (updatedIndex != end);
1076             }
1077             _currentIndex = updatedIndex;
1078         }
1079         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1080     }
1081 
1082     /**
1083      * @dev Transfers `tokenId` from `from` to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must be owned by `from`.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _transfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) private {
1097         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1098 
1099         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1100 
1101         bool isApprovedOrOwner = (_msgSender() == from ||
1102             isApprovedForAll(from, _msgSender()) ||
1103             getApproved(tokenId) == _msgSender());
1104 
1105         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1106         if (to == address(0)) revert TransferToZeroAddress();
1107 
1108         _beforeTokenTransfers(from, to, tokenId, 1);
1109 
1110         // Clear approvals from the previous owner
1111         _approve(address(0), tokenId, from);
1112 
1113         // Underflow of the sender's balance is impossible because we check for
1114         // ownership above and the recipient's balance can't realistically overflow.
1115         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1116         unchecked {
1117             _addressData[from].balance -= 1;
1118             _addressData[to].balance += 1;
1119 
1120             TokenOwnership storage currSlot = _ownerships[tokenId];
1121             currSlot.addr = to;
1122             currSlot.startTimestamp = uint64(block.timestamp);
1123 
1124             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1125             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1126             uint256 nextTokenId = tokenId + 1;
1127             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1128             if (nextSlot.addr == address(0)) {
1129                 // This will suffice for checking _exists(nextTokenId),
1130                 // as a burned slot cannot contain the zero address.
1131                 if (nextTokenId != _currentIndex) {
1132                     nextSlot.addr = from;
1133                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1134                 }
1135             }
1136         }
1137 
1138         emit Transfer(from, to, tokenId);
1139         _afterTokenTransfers(from, to, tokenId, 1);
1140     }
1141 
1142     /**
1143      * @dev This is equivalent to _burn(tokenId, false)
1144      */
1145     function _burn(uint256 tokenId) internal virtual {
1146         _burn(tokenId, false);
1147     }
1148 
1149     /**
1150      * @dev Destroys `tokenId`.
1151      * The approval is cleared when the token is burned.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1160         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1161 
1162         address from = prevOwnership.addr;
1163 
1164         if (approvalCheck) {
1165             bool isApprovedOrOwner = (_msgSender() == from ||
1166                 isApprovedForAll(from, _msgSender()) ||
1167                 getApproved(tokenId) == _msgSender());
1168 
1169             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1170         }
1171 
1172         _beforeTokenTransfers(from, address(0), tokenId, 1);
1173 
1174         // Clear approvals from the previous owner
1175         _approve(address(0), tokenId, from);
1176 
1177         // Underflow of the sender's balance is impossible because we check for
1178         // ownership above and the recipient's balance can't realistically overflow.
1179         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1180         unchecked {
1181             AddressData storage addressData = _addressData[from];
1182             addressData.balance -= 1;
1183             addressData.numberBurned += 1;
1184 
1185             // Keep track of who burned the token, and the timestamp of burning.
1186             TokenOwnership storage currSlot = _ownerships[tokenId];
1187             currSlot.addr = from;
1188             currSlot.startTimestamp = uint64(block.timestamp);
1189             currSlot.burned = true;
1190 
1191             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1192             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1193             uint256 nextTokenId = tokenId + 1;
1194             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1195             if (nextSlot.addr == address(0)) {
1196                 // This will suffice for checking _exists(nextTokenId),
1197                 // as a burned slot cannot contain the zero address.
1198                 if (nextTokenId != _currentIndex) {
1199                     nextSlot.addr = from;
1200                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1201                 }
1202             }
1203         }
1204 
1205         emit Transfer(from, address(0), tokenId);
1206         _afterTokenTransfers(from, address(0), tokenId, 1);
1207 
1208         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1209         unchecked {
1210             _burnCounter++;
1211         }
1212     }
1213 
1214     /**
1215      * @dev Approve `to` to operate on `tokenId`
1216      *
1217      * Emits a {Approval} event.
1218      */
1219     function _approve(
1220         address to,
1221         uint256 tokenId,
1222         address owner
1223     ) private {
1224         _tokenApprovals[tokenId] = to;
1225         emit Approval(owner, to, tokenId);
1226     }
1227 
1228     /**
1229      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1230      *
1231      * @param from address representing the previous owner of the given token ID
1232      * @param to target address that will receive the tokens
1233      * @param tokenId uint256 ID of the token to be transferred
1234      * @param _data bytes optional data to send along with the call
1235      * @return bool whether the call correctly returned the expected magic value
1236      */
1237     function _checkContractOnERC721Received(
1238         address from,
1239         address to,
1240         uint256 tokenId,
1241         bytes memory _data
1242     ) private returns (bool) {
1243         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1244             return retval == IERC721Receiver(to).onERC721Received.selector;
1245         } catch (bytes memory reason) {
1246             if (reason.length == 0) {
1247                 revert TransferToNonERC721ReceiverImplementer();
1248             } else {
1249                 assembly {
1250                     revert(add(32, reason), mload(reason))
1251                 }
1252             }
1253         }
1254     }
1255 
1256     /**
1257      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1258      * And also called before burning one token.
1259      *
1260      * startTokenId - the first token id to be transferred
1261      * quantity - the amount to be transferred
1262      *
1263      * Calling conditions:
1264      *
1265      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1266      * transferred to `to`.
1267      * - When `from` is zero, `tokenId` will be minted for `to`.
1268      * - When `to` is zero, `tokenId` will be burned by `from`.
1269      * - `from` and `to` are never both zero.
1270      */
1271     function _beforeTokenTransfers(
1272         address from,
1273         address to,
1274         uint256 startTokenId,
1275         uint256 quantity
1276     ) internal virtual {}
1277 
1278     /**
1279      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1280      * minting.
1281      * And also called after one token has been burned.
1282      *
1283      * startTokenId - the first token id to be transferred
1284      * quantity - the amount to be transferred
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` has been minted for `to`.
1291      * - When `to` is zero, `tokenId` has been burned by `from`.
1292      * - `from` and `to` are never both zero.
1293      */
1294     function _afterTokenTransfers(
1295         address from,
1296         address to,
1297         uint256 startTokenId,
1298         uint256 quantity
1299     ) internal virtual {}
1300 }
1301 
1302 // maybeokaybears.sol
1303 
1304 pragma solidity ^0.8.4;
1305 
1306 
1307 
1308 contract MaybeOkayBears is ERC721A, Ownable{ 
1309     using Strings for uint256;
1310 
1311     uint256 public PRICE;
1312     uint256 public MAX_SUPPLY;
1313     string private BASE_URI;
1314     string private SUFFIX_URI;
1315     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1316     uint256 public MAX_MINT_PER_TX;
1317     bool public IS_SALE_ACTIVE;
1318     uint256 public FREE_MINT_SUPPLY; 
1319 
1320     mapping(address => uint256) private freeMintAdressData;
1321 
1322     constructor(uint256 price, uint256 maxSupply, string memory baseUri, uint256 freeMintLimitPerWallet, uint256 maxMintPerTX, bool isSaleActive, uint256 freeMintSupply) ERC721A("Maybe Okay Bears", "MAYBEOKAYBEARS"){
1323         PRICE = price;
1324         MAX_SUPPLY = maxSupply;
1325         BASE_URI = baseUri;
1326         SUFFIX_URI = ".json";
1327         FREE_MINT_LIMIT_PER_WALLET = freeMintLimitPerWallet;
1328         MAX_MINT_PER_TX = maxMintPerTX;
1329         IS_SALE_ACTIVE = isSaleActive;
1330         FREE_MINT_SUPPLY = freeMintSupply;
1331 
1332         mintOwner(msg.sender, 10);
1333     }
1334 
1335     function updateFreeMintsAdresses(address minter, uint256 count) private{
1336         freeMintAdressData[minter] += count;
1337     }
1338 
1339     function returnCurrentMinterFreeMint(address minter) public view returns (uint256){
1340         return freeMintAdressData[minter];
1341     }
1342 
1343 
1344     function _baseURI() internal view virtual override returns (string memory){
1345         return BASE_URI;
1346     }
1347 
1348     function _suffixURI() internal view virtual override returns (string memory){
1349         return SUFFIX_URI;
1350     } 
1351 
1352     function setPrice(uint256 price) external onlyOwner(){
1353         PRICE = price;
1354     }
1355 
1356     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner{
1357         require (newMaxSupply < MAX_SUPPLY, "MAX SUPPLY MORE THAN NEW MAX SUPPLY");
1358         require (newMaxSupply >= _currentIndex, "NEW MAX SUPPLY IS BIGGER OR EQUAL TO CURRENT INDEX");
1359         MAX_SUPPLY = newMaxSupply;
1360     }
1361 
1362     function setBaseURI(string memory baseUri) external onlyOwner {
1363         BASE_URI = baseUri;
1364     }
1365 
1366     function setSuffixURI(string memory suffixUri) external onlyOwner {
1367         SUFFIX_URI = suffixUri;
1368     }
1369 
1370     function setFreeMintLimitPerWallet(uint256 freeMintLimitPerWallet) external onlyOwner{
1371         FREE_MINT_LIMIT_PER_WALLET = freeMintLimitPerWallet;
1372     }
1373 
1374     function setSalesActive(bool isSaleActive) external onlyOwner{
1375         IS_SALE_ACTIVE = isSaleActive;
1376     }
1377 
1378     function setFreeMintSupply(uint256 freeMintSupply) external onlyOwner{
1379         FREE_MINT_SUPPLY = freeMintSupply;
1380     }
1381 
1382     // MINT
1383     modifier mintRegulation(uint256 _mintAmount){
1384         require(_mintAmount > 0 && _mintAmount <= MAX_MINT_PER_TX, "AMOUNT < 1 OR EXCEEDS MAX");
1385         require(_currentIndex + _mintAmount <= MAX_SUPPLY, "SOLD OUT");
1386         _;
1387     }
1388 
1389     function mint(uint256 _mintAmount) public payable mintRegulation(_mintAmount) {
1390         require(IS_SALE_ACTIVE, "Sale not active!");
1391 
1392         uint256 totalPayable = _mintAmount * PRICE ;
1393 
1394         if (_currentIndex < FREE_MINT_SUPPLY) {
1395             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET - freeMintAdressData[msg.sender];
1396             if (remainingFreeMint > 0) {
1397 
1398                 if (_mintAmount >= remainingFreeMint) {
1399                     totalPayable -= remainingFreeMint * PRICE;
1400                     updateFreeMintsAdresses(msg.sender, remainingFreeMint);
1401                 } else {
1402                     totalPayable -= _mintAmount * PRICE;
1403                     updateFreeMintsAdresses(msg.sender, _mintAmount);
1404                 }
1405             } 
1406         }
1407 
1408         require(msg.value >= totalPayable, "Insufficient funds!");
1409 
1410         _safeMint(msg.sender, _mintAmount);
1411     }
1412 
1413         function mintOwner(address _to, uint256 _mintAmount) public mintRegulation(_mintAmount) onlyOwner {
1414         _safeMint(_to, _mintAmount);
1415     }
1416 
1417         function withdraw() public onlyOwner{
1418         require(address(this).balance > 0, "You have zero balance");
1419         payable(owner()).transfer(address(this).balance);
1420     }
1421         
1422 }