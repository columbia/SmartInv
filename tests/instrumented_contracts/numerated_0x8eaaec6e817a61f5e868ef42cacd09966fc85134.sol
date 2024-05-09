1 // SPDX-License-Identifier: MIT
2 // Creator: Hype Mansion Club x Ape Toshi
3 
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Context.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/access/Ownable.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Address.sol
181 
182 
183 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
184 
185 pragma solidity ^0.8.1;
186 
187 /**
188  * @dev Collection of functions related to the address type
189  */
190 library Address {
191     /**
192      * @dev Returns true if `account` is a contract.
193      *
194      * [IMPORTANT]
195      * ====
196      * It is unsafe to assume that an address for which this function returns
197      * false is an externally-owned account (EOA) and not a contract.
198      *
199      * Among others, `isContract` will return false for the following
200      * types of addresses:
201      *
202      *  - an externally-owned account
203      *  - a contract in construction
204      *  - an address where a contract will be created
205      *  - an address where a contract lived, but was destroyed
206      * ====
207      *
208      * [IMPORTANT]
209      * ====
210      * You shouldn't rely on `isContract` to protect against flash loan attacks!
211      *
212      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
213      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
214      * constructor.
215      * ====
216      */
217     function isContract(address account) internal view returns (bool) {
218         // This method relies on extcodesize/address.code.length, which returns 0
219         // for contracts in construction, since the code is only stored at the end
220         // of the constructor execution.
221 
222         return account.code.length > 0;
223     }
224 
225     /**
226      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
227      * `recipient`, forwarding all available gas and reverting on errors.
228      *
229      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
230      * of certain opcodes, possibly making contracts go over the 2300 gas limit
231      * imposed by `transfer`, making them unable to receive funds via
232      * `transfer`. {sendValue} removes this limitation.
233      *
234      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
235      *
236      * IMPORTANT: because control is transferred to `recipient`, care must be
237      * taken to not create reentrancy vulnerabilities. Consider using
238      * {ReentrancyGuard} or the
239      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
240      */
241     function sendValue(address payable recipient, uint256 amount) internal {
242         require(address(this).balance >= amount, "Address: insufficient balance");
243 
244         (bool success, ) = recipient.call{value: amount}("");
245         require(success, "Address: unable to send value, recipient may have reverted");
246     }
247 
248     /**
249      * @dev Performs a Solidity function call using a low level `call`. A
250      * plain `call` is an unsafe replacement for a function call: use this
251      * function instead.
252      *
253      * If `target` reverts with a revert reason, it is bubbled up by this
254      * function (like regular Solidity function calls).
255      *
256      * Returns the raw returned data. To convert to the expected return value,
257      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
258      *
259      * Requirements:
260      *
261      * - `target` must be a contract.
262      * - calling `target` with `data` must not revert.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionCall(target, data, "Address: low-level call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
272      * `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, 0, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but also transferring `value` wei to `target`.
287      *
288      * Requirements:
289      *
290      * - the calling contract must have an ETH balance of at least `value`.
291      * - the called Solidity function must be `payable`.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value
299     ) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
305      * with `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(address(this).balance >= value, "Address: insufficient balance for call");
316         require(isContract(target), "Address: call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.call{value: value}(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
329         return functionStaticCall(target, data, "Address: low-level static call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal view returns (bytes memory) {
343         require(isContract(target), "Address: static call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.staticcall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         require(isContract(target), "Address: delegate call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.delegatecall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
378      * revert reason using the provided one.
379      *
380      * _Available since v4.3._
381      */
382     function verifyCallResult(
383         bool success,
384         bytes memory returndata,
385         string memory errorMessage
386     ) internal pure returns (bytes memory) {
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @title ERC721 token receiver interface
414  * @dev Interface for any contract that wants to support safeTransfers
415  * from ERC721 asset contracts.
416  */
417 interface IERC721Receiver {
418     /**
419      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
420      * by `operator` from `from`, this function is called.
421      *
422      * It must return its Solidity selector to confirm the token transfer.
423      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
424      *
425      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
426      */
427     function onERC721Received(
428         address operator,
429         address from,
430         uint256 tokenId,
431         bytes calldata data
432     ) external returns (bytes4);
433 }
434 
435 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Interface of the ERC165 standard, as defined in the
444  * https://eips.ethereum.org/EIPS/eip-165[EIP].
445  *
446  * Implementers can declare support of contract interfaces, which can then be
447  * queried by others ({ERC165Checker}).
448  *
449  * For an implementation, see {ERC165}.
450  */
451 interface IERC165 {
452     /**
453      * @dev Returns true if this contract implements the interface defined by
454      * `interfaceId`. See the corresponding
455      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
456      * to learn more about how these ids are created.
457      *
458      * This function call must use less than 30 000 gas.
459      */
460     function supportsInterface(bytes4 interfaceId) external view returns (bool);
461 }
462 
463 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 
471 /**
472  * @dev Implementation of the {IERC165} interface.
473  *
474  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
475  * for the additional interface id that will be supported. For example:
476  *
477  * ```solidity
478  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
480  * }
481  * ```
482  *
483  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
484  */
485 abstract contract ERC165 is IERC165 {
486     /**
487      * @dev See {IERC165-supportsInterface}.
488      */
489     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490         return interfaceId == type(IERC165).interfaceId;
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 
502 /**
503  * @dev Required interface of an ERC721 compliant contract.
504  */
505 interface IERC721 is IERC165 {
506     /**
507      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
508      */
509     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
510 
511     /**
512      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
513      */
514     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
515 
516     /**
517      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
518      */
519     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
520 
521     /**
522      * @dev Returns the number of tokens in ``owner``'s account.
523      */
524     function balanceOf(address owner) external view returns (uint256 balance);
525 
526     /**
527      * @dev Returns the owner of the `tokenId` token.
528      *
529      * Requirements:
530      *
531      * - `tokenId` must exist.
532      */
533     function ownerOf(uint256 tokenId) external view returns (address owner);
534 
535     /**
536      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
537      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must exist and be owned by `from`.
544      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
546      *
547      * Emits a {Transfer} event.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 tokenId
553     ) external;
554 
555     /**
556      * @dev Transfers `tokenId` token from `from` to `to`.
557      *
558      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must be owned by `from`.
565      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
566      *
567      * Emits a {Transfer} event.
568      */
569     function transferFrom(
570         address from,
571         address to,
572         uint256 tokenId
573     ) external;
574 
575     /**
576      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
577      * The approval is cleared when the token is transferred.
578      *
579      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
580      *
581      * Requirements:
582      *
583      * - The caller must own the token or be an approved operator.
584      * - `tokenId` must exist.
585      *
586      * Emits an {Approval} event.
587      */
588     function approve(address to, uint256 tokenId) external;
589 
590     /**
591      * @dev Returns the account approved for `tokenId` token.
592      *
593      * Requirements:
594      *
595      * - `tokenId` must exist.
596      */
597     function getApproved(uint256 tokenId) external view returns (address operator);
598 
599     /**
600      * @dev Approve or remove `operator` as an operator for the caller.
601      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
602      *
603      * Requirements:
604      *
605      * - The `operator` cannot be the caller.
606      *
607      * Emits an {ApprovalForAll} event.
608      */
609     function setApprovalForAll(address operator, bool _approved) external;
610 
611     /**
612      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
613      *
614      * See {setApprovalForAll}
615      */
616     function isApprovedForAll(address owner, address operator) external view returns (bool);
617 
618     /**
619      * @dev Safely transfers `tokenId` token from `from` to `to`.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must exist and be owned by `from`.
626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 tokenId,
635         bytes calldata data
636     ) external;
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
668 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
669 
670 
671 // Creator: Chiru Labs
672 
673 pragma solidity ^0.8.4;
674 
675 
676 
677 
678 
679 
680 
681 
682 error ApprovalCallerNotOwnerNorApproved();
683 error ApprovalQueryForNonexistentToken();
684 error ApproveToCaller();
685 error ApprovalToCurrentOwner();
686 error BalanceQueryForZeroAddress();
687 error MintToZeroAddress();
688 error MintZeroQuantity();
689 error OwnerQueryForNonexistentToken();
690 error TransferCallerNotOwnerNorApproved();
691 error TransferFromIncorrectOwner();
692 error TransferToNonERC721ReceiverImplementer();
693 error TransferToZeroAddress();
694 error URIQueryForNonexistentToken();
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata extension. Built to optimize for lower gas during batch mints.
699  *
700  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
701  *
702  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
703  *
704  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
705  */
706 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
707     using Address for address;
708     using Strings for uint256;
709 
710     // Compiler will pack this into a single 256bit word.
711     struct TokenOwnership {
712         // The address of the owner.
713         address addr;
714         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
715         uint64 startTimestamp;
716         // Whether the token has been burned.
717         bool burned;
718     }
719 
720     // Compiler will pack this into a single 256bit word.
721     struct AddressData {
722         // Realistically, 2**64-1 is more than enough.
723         uint64 balance;
724         // Keeps track of mint count with minimal overhead for tokenomics.
725         uint64 numberMinted;
726         // Keeps track of burn count with minimal overhead for tokenomics.
727         uint64 numberBurned;
728         // For miscellaneous variable(s) pertaining to the address
729         // (e.g. number of whitelist mint slots used).
730         // If there are multiple variables, please pack them into a uint64.
731         uint64 aux;
732     }
733 
734     // The tokenId of the next token to be minted.
735     uint256 internal _currentIndex;
736 
737     // The number of tokens burned.
738     uint256 internal _burnCounter;
739 
740     // Token name
741     string private _name;
742 
743     // Token symbol
744     string private _symbol;
745 
746     // Mapping from token ID to ownership details
747     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
748     mapping(uint256 => TokenOwnership) internal _ownerships;
749 
750     // Mapping owner address to address data
751     mapping(address => AddressData) private _addressData;
752 
753     // Mapping from token ID to approved address
754     mapping(uint256 => address) private _tokenApprovals;
755 
756     // Mapping from owner to operator approvals
757     mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759     constructor(string memory name_, string memory symbol_) {
760         _name = name_;
761         _symbol = symbol_;
762         _currentIndex = _startTokenId();
763     }
764 
765     /**
766      * To change the starting tokenId, please override this function.
767      */
768     function _startTokenId() internal view virtual returns (uint256) {
769         return 0;
770     }
771 
772     /**
773      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
774      */
775     function totalSupply() public view returns (uint256) {
776         // Counter underflow is impossible as _burnCounter cannot be incremented
777         // more than _currentIndex - _startTokenId() times
778         unchecked {
779             return _currentIndex - _burnCounter - _startTokenId();
780         }
781     }
782 
783     /**
784      * Returns the total amount of tokens minted in the contract.
785      */
786     function _totalMinted() internal view returns (uint256) {
787         // Counter underflow is impossible as _currentIndex does not decrement,
788         // and it is initialized to _startTokenId()
789         unchecked {
790             return _currentIndex - _startTokenId();
791         }
792     }
793 
794     /**
795      * @dev See {IERC165-supportsInterface}.
796      */
797     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
798         return
799             interfaceId == type(IERC721).interfaceId ||
800             interfaceId == type(IERC721Metadata).interfaceId ||
801             super.supportsInterface(interfaceId);
802     }
803 
804     /**
805      * @dev See {IERC721-balanceOf}.
806      */
807     function balanceOf(address owner) public view override returns (uint256) {
808         if (owner == address(0)) revert BalanceQueryForZeroAddress();
809         return uint256(_addressData[owner].balance);
810     }
811 
812     /**
813      * Returns the number of tokens minted by `owner`.
814      */
815     function _numberMinted(address owner) internal view returns (uint256) {
816         return uint256(_addressData[owner].numberMinted);
817     }
818 
819     /**
820      * Returns the number of tokens burned by or on behalf of `owner`.
821      */
822     function _numberBurned(address owner) internal view returns (uint256) {
823         return uint256(_addressData[owner].numberBurned);
824     }
825 
826     /**
827      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
828      */
829     function _getAux(address owner) internal view returns (uint64) {
830         return _addressData[owner].aux;
831     }
832 
833     /**
834      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
835      * If there are multiple variables, please pack them into a uint64.
836      */
837     function _setAux(address owner, uint64 aux) internal {
838         _addressData[owner].aux = aux;
839     }
840 
841     /**
842      * Gas spent here starts off proportional to the maximum mint batch size.
843      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
844      */
845     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
846         uint256 curr = tokenId;
847 
848         unchecked {
849             if (_startTokenId() <= curr && curr < _currentIndex) {
850                 TokenOwnership memory ownership = _ownerships[curr];
851                 if (!ownership.burned) {
852                     if (ownership.addr != address(0)) {
853                         return ownership;
854                     }
855                     // Invariant:
856                     // There will always be an ownership that has an address and is not burned
857                     // before an ownership that does not have an address and is not burned.
858                     // Hence, curr will not underflow.
859                     while (true) {
860                         curr--;
861                         ownership = _ownerships[curr];
862                         if (ownership.addr != address(0)) {
863                             return ownership;
864                         }
865                     }
866                 }
867             }
868         }
869         revert OwnerQueryForNonexistentToken();
870     }
871 
872     /**
873      * @dev See {IERC721-ownerOf}.
874      */
875     function ownerOf(uint256 tokenId) public view override returns (address) {
876         return _ownershipOf(tokenId).addr;
877     }
878 
879     /**
880      * @dev See {IERC721Metadata-name}.
881      */
882     function name() public view virtual override returns (string memory) {
883         return _name;
884     }
885 
886     /**
887      * @dev See {IERC721Metadata-symbol}.
888      */
889     function symbol() public view virtual override returns (string memory) {
890         return _symbol;
891     }
892 
893     /**
894      * @dev See {IERC721Metadata-tokenURI}.
895      */
896     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
897         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
898 
899         string memory baseURI = _baseURI();
900         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
901     }
902 
903     /**
904      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
905      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
906      * by default, can be overriden in child contracts.
907      */
908     function _baseURI() internal view virtual returns (string memory) {
909         return '';
910     }
911 
912     /**
913      * @dev See {IERC721-approve}.
914      */
915     function approve(address to, uint256 tokenId) public override {
916         address owner = ERC721A.ownerOf(tokenId);
917         if (to == owner) revert ApprovalToCurrentOwner();
918 
919         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
920             revert ApprovalCallerNotOwnerNorApproved();
921         }
922 
923         _approve(to, tokenId, owner);
924     }
925 
926     /**
927      * @dev See {IERC721-getApproved}.
928      */
929     function getApproved(uint256 tokenId) public view override returns (address) {
930         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
931 
932         return _tokenApprovals[tokenId];
933     }
934 
935     /**
936      * @dev See {IERC721-setApprovalForAll}.
937      */
938     function setApprovalForAll(address operator, bool approved) public virtual override {
939         if (operator == _msgSender()) revert ApproveToCaller();
940 
941         _operatorApprovals[_msgSender()][operator] = approved;
942         emit ApprovalForAll(_msgSender(), operator, approved);
943     }
944 
945     /**
946      * @dev See {IERC721-isApprovedForAll}.
947      */
948     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
949         return _operatorApprovals[owner][operator];
950     }
951 
952     /**
953      * @dev See {IERC721-transferFrom}.
954      */
955     function transferFrom(
956         address from,
957         address to,
958         uint256 tokenId
959     ) public virtual override {
960         _transfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         safeTransferFrom(from, to, tokenId, '');
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) public virtual override {
983         _transfer(from, to, tokenId);
984         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
985             revert TransferToNonERC721ReceiverImplementer();
986         }
987     }
988 
989     /**
990      * @dev Returns whether `tokenId` exists.
991      *
992      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
993      *
994      * Tokens start existing when they are minted (`_mint`),
995      */
996     function _exists(uint256 tokenId) internal view returns (bool) {
997         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
998     }
999 
1000     /**
1001      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1002      */
1003     function _safeMint(address to, uint256 quantity) internal {
1004         _safeMint(to, quantity, '');
1005     }
1006 
1007     /**
1008      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - If `to` refers to a smart contract, it must implement 
1013      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1014      * - `quantity` must be greater than 0.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _safeMint(
1019         address to,
1020         uint256 quantity,
1021         bytes memory _data
1022     ) internal {
1023         uint256 startTokenId = _currentIndex;
1024         if (to == address(0)) revert MintToZeroAddress();
1025         if (quantity == 0) revert MintZeroQuantity();
1026 
1027         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1028 
1029         // Overflows are incredibly unrealistic.
1030         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1031         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1032         unchecked {
1033             _addressData[to].balance += uint64(quantity);
1034             _addressData[to].numberMinted += uint64(quantity);
1035 
1036             _ownerships[startTokenId].addr = to;
1037             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1038 
1039             uint256 updatedIndex = startTokenId;
1040             uint256 end = updatedIndex + quantity;
1041 
1042             if (to.isContract()) {
1043                 do {
1044                     emit Transfer(address(0), to, updatedIndex);
1045                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1046                         revert TransferToNonERC721ReceiverImplementer();
1047                     }
1048                 } while (updatedIndex != end);
1049                 // Reentrancy protection
1050                 if (_currentIndex != startTokenId) revert();
1051             } else {
1052                 do {
1053                     emit Transfer(address(0), to, updatedIndex++);
1054                 } while (updatedIndex != end);
1055             }
1056             _currentIndex = updatedIndex;
1057         }
1058         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1059     }
1060 
1061     /**
1062      * @dev Mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - `to` cannot be the zero address.
1067      * - `quantity` must be greater than 0.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _mint(address to, uint256 quantity) internal {
1072         uint256 startTokenId = _currentIndex;
1073         if (to == address(0)) revert MintToZeroAddress();
1074         if (quantity == 0) revert MintZeroQuantity();
1075 
1076         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1077 
1078         // Overflows are incredibly unrealistic.
1079         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1080         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1081         unchecked {
1082             _addressData[to].balance += uint64(quantity);
1083             _addressData[to].numberMinted += uint64(quantity);
1084 
1085             _ownerships[startTokenId].addr = to;
1086             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1087 
1088             uint256 updatedIndex = startTokenId;
1089             uint256 end = updatedIndex + quantity;
1090 
1091             do {
1092                 emit Transfer(address(0), to, updatedIndex++);
1093             } while (updatedIndex != end);
1094 
1095             _currentIndex = updatedIndex;
1096         }
1097         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1098     }
1099 
1100     /**
1101      * @dev Transfers `tokenId` from `from` to `to`.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must be owned by `from`.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) private {
1115         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1116 
1117         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1118 
1119         bool isApprovedOrOwner = (_msgSender() == from ||
1120             isApprovedForAll(from, _msgSender()) ||
1121             getApproved(tokenId) == _msgSender());
1122 
1123         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1124         if (to == address(0)) revert TransferToZeroAddress();
1125 
1126         _beforeTokenTransfers(from, to, tokenId, 1);
1127 
1128         // Clear approvals from the previous owner
1129         _approve(address(0), tokenId, from);
1130 
1131         // Underflow of the sender's balance is impossible because we check for
1132         // ownership above and the recipient's balance can't realistically overflow.
1133         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1134         unchecked {
1135             _addressData[from].balance -= 1;
1136             _addressData[to].balance += 1;
1137 
1138             TokenOwnership storage currSlot = _ownerships[tokenId];
1139             currSlot.addr = to;
1140             currSlot.startTimestamp = uint64(block.timestamp);
1141 
1142             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1143             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1144             uint256 nextTokenId = tokenId + 1;
1145             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1146             if (nextSlot.addr == address(0)) {
1147                 // This will suffice for checking _exists(nextTokenId),
1148                 // as a burned slot cannot contain the zero address.
1149                 if (nextTokenId != _currentIndex) {
1150                     nextSlot.addr = from;
1151                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1152                 }
1153             }
1154         }
1155 
1156         emit Transfer(from, to, tokenId);
1157         _afterTokenTransfers(from, to, tokenId, 1);
1158     }
1159 
1160     /**
1161      * @dev Equivalent to `_burn(tokenId, false)`.
1162      */
1163     function _burn(uint256 tokenId) internal virtual {
1164         _burn(tokenId, false);
1165     }
1166 
1167     /**
1168      * @dev Destroys `tokenId`.
1169      * The approval is cleared when the token is burned.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must exist.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1178         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1179 
1180         address from = prevOwnership.addr;
1181 
1182         if (approvalCheck) {
1183             bool isApprovedOrOwner = (_msgSender() == from ||
1184                 isApprovedForAll(from, _msgSender()) ||
1185                 getApproved(tokenId) == _msgSender());
1186 
1187             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1188         }
1189 
1190         _beforeTokenTransfers(from, address(0), tokenId, 1);
1191 
1192         // Clear approvals from the previous owner
1193         _approve(address(0), tokenId, from);
1194 
1195         // Underflow of the sender's balance is impossible because we check for
1196         // ownership above and the recipient's balance can't realistically overflow.
1197         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1198         unchecked {
1199             AddressData storage addressData = _addressData[from];
1200             addressData.balance -= 1;
1201             addressData.numberBurned += 1;
1202 
1203             // Keep track of who burned the token, and the timestamp of burning.
1204             TokenOwnership storage currSlot = _ownerships[tokenId];
1205             currSlot.addr = from;
1206             currSlot.startTimestamp = uint64(block.timestamp);
1207             currSlot.burned = true;
1208 
1209             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1210             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1211             uint256 nextTokenId = tokenId + 1;
1212             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1213             if (nextSlot.addr == address(0)) {
1214                 // This will suffice for checking _exists(nextTokenId),
1215                 // as a burned slot cannot contain the zero address.
1216                 if (nextTokenId != _currentIndex) {
1217                     nextSlot.addr = from;
1218                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(from, address(0), tokenId);
1224         _afterTokenTransfers(from, address(0), tokenId, 1);
1225 
1226         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1227         unchecked {
1228             _burnCounter++;
1229         }
1230     }
1231 
1232     /**
1233      * @dev Approve `to` to operate on `tokenId`
1234      *
1235      * Emits a {Approval} event.
1236      */
1237     function _approve(
1238         address to,
1239         uint256 tokenId,
1240         address owner
1241     ) private {
1242         _tokenApprovals[tokenId] = to;
1243         emit Approval(owner, to, tokenId);
1244     }
1245 
1246     /**
1247      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1248      *
1249      * @param from address representing the previous owner of the given token ID
1250      * @param to target address that will receive the tokens
1251      * @param tokenId uint256 ID of the token to be transferred
1252      * @param _data bytes optional data to send along with the call
1253      * @return bool whether the call correctly returned the expected magic value
1254      */
1255     function _checkContractOnERC721Received(
1256         address from,
1257         address to,
1258         uint256 tokenId,
1259         bytes memory _data
1260     ) private returns (bool) {
1261         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1262             return retval == IERC721Receiver(to).onERC721Received.selector;
1263         } catch (bytes memory reason) {
1264             if (reason.length == 0) {
1265                 revert TransferToNonERC721ReceiverImplementer();
1266             } else {
1267                 assembly {
1268                     revert(add(32, reason), mload(reason))
1269                 }
1270             }
1271         }
1272     }
1273 
1274     /**
1275      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1276      * And also called before burning one token.
1277      *
1278      * startTokenId - the first token id to be transferred
1279      * quantity - the amount to be transferred
1280      *
1281      * Calling conditions:
1282      *
1283      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1284      * transferred to `to`.
1285      * - When `from` is zero, `tokenId` will be minted for `to`.
1286      * - When `to` is zero, `tokenId` will be burned by `from`.
1287      * - `from` and `to` are never both zero.
1288      */
1289     function _beforeTokenTransfers(
1290         address from,
1291         address to,
1292         uint256 startTokenId,
1293         uint256 quantity
1294     ) internal virtual {}
1295 
1296     /**
1297      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1298      * minting.
1299      * And also called after one token has been burned.
1300      *
1301      * startTokenId - the first token id to be transferred
1302      * quantity - the amount to be transferred
1303      *
1304      * Calling conditions:
1305      *
1306      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1307      * transferred to `to`.
1308      * - When `from` is zero, `tokenId` has been minted for `to`.
1309      * - When `to` is zero, `tokenId` has been burned by `from`.
1310      * - `from` and `to` are never both zero.
1311      */
1312     function _afterTokenTransfers(
1313         address from,
1314         address to,
1315         uint256 startTokenId,
1316         uint256 quantity
1317     ) internal virtual {}
1318 }
1319 
1320 // File: contracts/mfrankr.sol
1321 
1322 
1323 // Creator: Hype Mansion Club x Ape Toshi
1324 
1325 pragma solidity 0.8.13;
1326 
1327 
1328 
1329 
1330 contract mfrankrz is ERC721A, Ownable {
1331 
1332     event PermanentURI(string _value, uint256 indexed _id);
1333     uint256 public MAX_SUPPLY = 1000;
1334     uint256 public MAX_PER_TXN = 3;
1335 
1336     constructor() ERC721A("mfrankrz", "MFRANKRZ") {
1337         // Claim collection on OpenSea
1338         _safeMint(msg.sender, 1);
1339         emit PermanentURI(tokenURI(1), 1);
1340     }
1341 
1342     function mint(uint256 amount) external {
1343         require(amount <= MAX_PER_TXN, ">maxTxn");
1344         uint256 currentSupply = totalSupply();
1345         require(currentSupply + amount <= MAX_SUPPLY, ">supply");
1346         _safeMint(msg.sender, amount);
1347         for (uint256 i; i < amount; i++) {
1348             currentSupply++;
1349             // Signal to OpenSea that mfrankrz is eternal (he is gift to humanity)
1350             emit PermanentURI(tokenURI(currentSupply), currentSupply);
1351         }
1352     }
1353 
1354     function _baseURI() internal pure override returns (string memory) {
1355         return "ar://wbYk3zHESewo1AtQKKw5dJ-qhQv0jotutHpbwM8Ye2k/";
1356     }
1357 
1358     function _startTokenId() internal pure override returns (uint256) {
1359         return 1;
1360     }
1361 }