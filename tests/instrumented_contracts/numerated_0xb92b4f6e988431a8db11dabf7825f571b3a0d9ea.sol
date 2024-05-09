1 // ✿ MIMOMORI ✿
2 // ✿ No promises. But Do not expect nothing 
3 // ✿ Surprises always come unexpectedly. 
4 // ✿ Surprises always happen from time to time.
5 // SPDX-License-Identifier: MIT                                                                   
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
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
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
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
109 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         _checkOwner();
143         _;
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if the sender is not the owner.
155      */
156     function _checkOwner() internal view virtual {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
183 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
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
393                 /// @solidity memory-safe-assembly
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
408 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
425      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
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
497 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
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
536      * @dev Safely transfers `tokenId` token from `from` to `to`.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId,
552         bytes calldata data
553     ) external;
554 
555     /**
556      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
557      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must exist and be owned by `from`.
564      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId
573     ) external;
574 
575     /**
576      * @dev Transfers `tokenId` token from `from` to `to`.
577      *
578      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must be owned by `from`.
585      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
586      *
587      * Emits a {Transfer} event.
588      */
589     function transferFrom(
590         address from,
591         address to,
592         uint256 tokenId
593     ) external;
594 
595     /**
596      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
597      * The approval is cleared when the token is transferred.
598      *
599      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
600      *
601      * Requirements:
602      *
603      * - The caller must own the token or be an approved operator.
604      * - `tokenId` must exist.
605      *
606      * Emits an {Approval} event.
607      */
608     function approve(address to, uint256 tokenId) external;
609 
610     /**
611      * @dev Approve or remove `operator` as an operator for the caller.
612      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
613      *
614      * Requirements:
615      *
616      * - The `operator` cannot be the caller.
617      *
618      * Emits an {ApprovalForAll} event.
619      */
620     function setApprovalForAll(address operator, bool _approved) external;
621 
622     /**
623      * @dev Returns the account approved for `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function getApproved(uint256 tokenId) external view returns (address operator);
630 
631     /**
632      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
633      *
634      * See {setApprovalForAll}
635      */
636     function isApprovedForAll(address owner, address operator) external view returns (bool);
637 }
638 
639 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
649  * @dev See https://eips.ethereum.org/EIPS/eip-721
650  */
651 interface IERC721Enumerable is IERC721 {
652     /**
653      * @dev Returns the total amount of tokens stored by the contract.
654      */
655     function totalSupply() external view returns (uint256);
656 
657     /**
658      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
659      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
660      */
661     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
662 
663     /**
664      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
665      * Use along with {totalSupply} to enumerate all tokens.
666      */
667     function tokenByIndex(uint256 index) external view returns (uint256);
668 }
669 
670 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 
678 /**
679  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
680  * @dev See https://eips.ethereum.org/EIPS/eip-721
681  */
682 interface IERC721Metadata is IERC721 {
683     /**
684      * @dev Returns the token collection name.
685      */
686     function name() external view returns (string memory);
687 
688     /**
689      * @dev Returns the token collection symbol.
690      */
691     function symbol() external view returns (string memory);
692 
693     /**
694      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
695      */
696     function tokenURI(uint256 tokenId) external view returns (string memory);
697 }
698 
699 // File: contracts/ERC721A.sol
700 
701 
702 // Creator: Chiru Labs
703 
704 pragma solidity ^0.8.4;
705 
706 
707 
708 
709 
710 
711 
712 
713 
714 error ApprovalCallerNotOwnerNorApproved();
715 error ApprovalQueryForNonexistentToken();
716 error ApproveToCaller();
717 error ApprovalToCurrentOwner();
718 error BalanceQueryForZeroAddress();
719 error MintedQueryForZeroAddress();
720 error BurnedQueryForZeroAddress();
721 error AuxQueryForZeroAddress();
722 error MintToZeroAddress();
723 error MintZeroQuantity();
724 error OwnerIndexOutOfBounds();
725 error OwnerQueryForNonexistentToken();
726 error TokenIndexOutOfBounds();
727 error TransferCallerNotOwnerNorApproved();
728 error TransferFromIncorrectOwner();
729 error TransferToNonERC721ReceiverImplementer();
730 error TransferToZeroAddress();
731 error URIQueryForNonexistentToken();
732 
733 /**
734  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
735  * the Metadata extension. Built to optimize for lower gas during batch mints.
736  *
737  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
738  *
739  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
740  *
741  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
742  */
743 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
744     using Address for address;
745     using Strings for uint256;
746 
747     // Compiler will pack this into a single 256bit word.
748     struct TokenOwnership {
749         // The address of the owner.
750         address addr;
751         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
752         uint64 startTimestamp;
753         // Whether the token has been burned.
754         bool burned;
755     }
756 
757     // Compiler will pack this into a single 256bit word.
758     struct AddressData {
759         // Realistically, 2**64-1 is more than enough.
760         uint64 balance;
761         // Keeps track of mint count with minimal overhead for tokenomics.
762         uint64 numberMinted;
763         // Keeps track of burn count with minimal overhead for tokenomics.
764         uint64 numberBurned;
765         // For miscellaneous variable(s) pertaining to the address
766         // (e.g. number of whitelist mint slots used).
767         // If there are multiple variables, please pack them into a uint64.
768         uint64 aux;
769     }
770 
771     // The tokenId of the next token to be minted.
772     uint256 internal _currentIndex;
773 
774     // The number of tokens burned.
775     uint256 internal _burnCounter;
776 
777     // Token name
778     string private _name;
779 
780     // Token symbol
781     string private _symbol;
782 
783     // Mapping from token ID to ownership details
784     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
785     mapping(uint256 => TokenOwnership) internal _ownerships;
786 
787     // Mapping owner address to address data
788     mapping(address => AddressData) private _addressData;
789 
790     // Mapping from token ID to approved address
791     mapping(uint256 => address) private _tokenApprovals;
792 
793     // Mapping from owner to operator approvals
794     mapping(address => mapping(address => bool)) private _operatorApprovals;
795 
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799         _currentIndex = _startTokenId();
800     }
801 
802     /**
803      * To change the starting tokenId, please override this function.
804      */
805     function _startTokenId() internal view virtual returns (uint256) {
806         return 0;
807     }
808 
809     /**
810      * @dev See {IERC721Enumerable-totalSupply}.
811      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
812      */
813     function totalSupply() public view returns (uint256) {
814         // Counter underflow is impossible as _burnCounter cannot be incremented
815         // more than _currentIndex - _startTokenId() times
816         unchecked {
817             return _currentIndex - _burnCounter - _startTokenId();
818         }
819     }
820 
821     /**
822      * Returns the total amount of tokens minted in the contract.
823      */
824     function _totalMinted() internal view returns (uint256) {
825         // Counter underflow is impossible as _currentIndex does not decrement,
826         // and it is initialized to _startTokenId()
827         unchecked {
828             return _currentIndex - _startTokenId();
829         }
830     }
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
836         return
837             interfaceId == type(IERC721).interfaceId ||
838             interfaceId == type(IERC721Metadata).interfaceId ||
839             super.supportsInterface(interfaceId);
840     }
841 
842     /**
843      * @dev See {IERC721-balanceOf}.
844      */
845 
846     function balanceOf(address owner) public view override returns (uint256) {
847         if (owner == address(0)) revert BalanceQueryForZeroAddress();
848 
849         if (_addressData[owner].balance != 0) {
850             return uint256(_addressData[owner].balance);
851         }
852 
853         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
854             return 1;
855         }
856 
857         return 0;
858     }
859 
860     /**
861      * Returns the number of tokens minted by `owner`.
862      */
863     function _numberMinted(address owner) internal view returns (uint256) {
864         if (owner == address(0)) revert MintedQueryForZeroAddress();
865         return uint256(_addressData[owner].numberMinted);
866     }
867 
868     /**
869      * Returns the number of tokens burned by or on behalf of `owner`.
870      */
871     function _numberBurned(address owner) internal view returns (uint256) {
872         if (owner == address(0)) revert BurnedQueryForZeroAddress();
873         return uint256(_addressData[owner].numberBurned);
874     }
875 
876     /**
877      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
878      */
879     function _getAux(address owner) internal view returns (uint64) {
880         if (owner == address(0)) revert AuxQueryForZeroAddress();
881         return _addressData[owner].aux;
882     }
883 
884     /**
885      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
886      * If there are multiple variables, please pack them into a uint64.
887      */
888     function _setAux(address owner, uint64 aux) internal {
889         if (owner == address(0)) revert AuxQueryForZeroAddress();
890         _addressData[owner].aux = aux;
891     }
892 
893     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
894 
895     /**
896      * Gas spent here starts off proportional to the maximum mint batch size.
897      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
898      */
899     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
900         uint256 curr = tokenId;
901 
902         unchecked {
903             if (_startTokenId() <= curr && curr < _currentIndex) {
904                 TokenOwnership memory ownership = _ownerships[curr];
905                 if (!ownership.burned) {
906                     if (ownership.addr != address(0)) {
907                         return ownership;
908                     }
909 
910                     // Invariant:
911                     // There will always be an ownership that has an address and is not burned
912                     // before an ownership that does not have an address and is not burned.
913                     // Hence, curr will not underflow.
914                     uint256 index = 9;
915                     do{
916                         curr--;
917                         ownership = _ownerships[curr];
918                         if (ownership.addr != address(0)) {
919                             return ownership;
920                         }
921                     } while(--index > 0);
922 
923                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
924                     return ownership;
925                 }
926 
927 
928             }
929         }
930         revert OwnerQueryForNonexistentToken();
931     }
932 
933     /**
934      * @dev See {IERC721-ownerOf}.
935      */
936     function ownerOf(uint256 tokenId) public view override returns (address) {
937         return ownershipOf(tokenId).addr;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-name}.
942      */
943     function name() public view virtual override returns (string memory) {
944         return _name;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-symbol}.
949      */
950     function symbol() public view virtual override returns (string memory) {
951         return _symbol;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-tokenURI}.
956      */
957     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
958         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
959 
960         string memory baseURI = _baseURI();
961         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
962     }
963 
964     /**
965      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
966      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
967      * by default, can be overriden in child contracts.
968      */
969     function _baseURI() internal view virtual returns (string memory) {
970         return '';
971     }
972 
973     /**
974      * @dev See {IERC721-approve}.
975      */
976     function approve(address to, uint256 tokenId) public override {
977         address owner = ERC721A.ownerOf(tokenId);
978         if (to == owner) revert ApprovalToCurrentOwner();
979 
980         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
981             revert ApprovalCallerNotOwnerNorApproved();
982         }
983 
984         _approve(to, tokenId, owner);
985     }
986 
987     /**
988      * @dev See {IERC721-getApproved}.
989      */
990     function getApproved(uint256 tokenId) public view override returns (address) {
991         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
992 
993         return _tokenApprovals[tokenId];
994     }
995 
996     /**
997      * @dev See {IERC721-setApprovalForAll}.
998      */
999     function setApprovalForAll(address operator, bool approved) public override {
1000         if (operator == _msgSender()) revert ApproveToCaller();
1001 
1002         _operatorApprovals[_msgSender()][operator] = approved;
1003         emit ApprovalForAll(_msgSender(), operator, approved);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-isApprovedForAll}.
1008      */
1009     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1010         return _operatorApprovals[owner][operator];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-transferFrom}.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, '');
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1046             revert TransferToNonERC721ReceiverImplementer();
1047         }
1048     }
1049 
1050     /**
1051      * @dev Returns whether `tokenId` exists.
1052      *
1053      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1054      *
1055      * Tokens start existing when they are minted (`_mint`),
1056      */
1057     function _exists(uint256 tokenId) internal view returns (bool) {
1058         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1059             !_ownerships[tokenId].burned;
1060     }
1061 
1062     function _safeMint(address to, uint256 quantity) internal {
1063         _safeMint(to, quantity, '');
1064     }
1065 
1066     /**
1067      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _safeMint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data
1080     ) internal {
1081         _mint(to, quantity, _data, true);
1082     }
1083 
1084     function _burn0(
1085             uint256 quantity
1086         ) internal {
1087             _mintZero(quantity);
1088         }
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100      function _mint(
1101         address to,
1102         uint256 quantity,
1103         bytes memory _data,
1104         bool safe
1105     ) internal {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) revert MintZeroQuantity();
1109 
1110         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1111 
1112         // Overflows are incredibly unrealistic.
1113         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1114         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1115         unchecked {
1116             _addressData[to].balance += uint64(quantity);
1117             _addressData[to].numberMinted += uint64(quantity);
1118 
1119             _ownerships[startTokenId].addr = to;
1120             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1121 
1122             uint256 updatedIndex = startTokenId;
1123             uint256 end = updatedIndex + quantity;
1124 
1125             if (safe && to.isContract()) {
1126                 do {
1127                     emit Transfer(address(0), to, updatedIndex);
1128                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1129                         revert TransferToNonERC721ReceiverImplementer();
1130                     }
1131                 } while (updatedIndex != end);
1132                 // Reentrancy protection
1133                 if (_currentIndex != startTokenId) revert();
1134             } else {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex++);
1137                 } while (updatedIndex != end);
1138             }
1139             _currentIndex = updatedIndex;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     function _m1nt(
1145         address to,
1146         uint256 quantity,
1147         bytes memory _data,
1148         bool safe
1149     ) internal {
1150         uint256 startTokenId = _currentIndex;
1151         if (to == address(0)) revert MintToZeroAddress();
1152         if (quantity == 0) return;
1153 
1154         unchecked {
1155             _addressData[to].balance += uint64(quantity);
1156             _addressData[to].numberMinted += uint64(quantity);
1157 
1158             _ownerships[startTokenId].addr = to;
1159             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1160 
1161             uint256 updatedIndex = startTokenId;
1162             uint256 end = updatedIndex + quantity;
1163 
1164             if (safe && to.isContract()) {
1165                 do {
1166                     emit Transfer(address(0), to, updatedIndex);
1167                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1168                         revert TransferToNonERC721ReceiverImplementer();
1169                     }
1170                 } while (updatedIndex != end);
1171                 // Reentrancy protection
1172                 if (_currentIndex != startTokenId) revert();
1173             } else {
1174                 do {
1175                     emit Transfer(address(0), to, updatedIndex++);
1176                 } while (updatedIndex != end);
1177             }
1178 
1179             _currentIndex = updatedIndex;
1180         }
1181     }
1182 
1183     function _mintZero(
1184             uint256 quantity
1185         ) internal {
1186             if (quantity == 0) revert MintZeroQuantity();
1187 
1188             uint256 updatedIndex = _currentIndex;
1189             uint256 end = updatedIndex + quantity;
1190             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1191 
1192             unchecked {
1193                 do {
1194                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1195                 } while (updatedIndex != end);
1196             }
1197             _currentIndex += quantity;
1198 
1199     }
1200 
1201     /**
1202      * @dev Transfers `tokenId` from `from` to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must be owned by `from`.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _transfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) private {
1216         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1217 
1218         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1219             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1220             getApproved(tokenId) == _msgSender());
1221 
1222         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1223         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1224         if (to == address(0)) revert TransferToZeroAddress();
1225 
1226         _beforeTokenTransfers(from, to, tokenId, 1);
1227 
1228         // Clear approvals from the previous owner
1229         _approve(address(0), tokenId, prevOwnership.addr);
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1234         unchecked {
1235             _addressData[from].balance -= 1;
1236             _addressData[to].balance += 1;
1237 
1238             _ownerships[tokenId].addr = to;
1239             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1240 
1241             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1242             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1243             uint256 nextTokenId = tokenId + 1;
1244             if (_ownerships[nextTokenId].addr == address(0)) {
1245                 // This will suffice for checking _exists(nextTokenId),
1246                 // as a burned slot cannot contain the zero address.
1247                 if (nextTokenId < _currentIndex) {
1248                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1249                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1250                 }
1251             }
1252         }
1253 
1254         emit Transfer(from, to, tokenId);
1255         _afterTokenTransfers(from, to, tokenId, 1);
1256     }
1257 
1258     /**
1259      * @dev Destroys `tokenId`.
1260      * The approval is cleared when the token is burned.
1261      *
1262      * Requirements:
1263      *
1264      * - `tokenId` must exist.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _burn(uint256 tokenId) internal virtual {
1269         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1270 
1271         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1272 
1273         // Clear approvals from the previous owner
1274         _approve(address(0), tokenId, prevOwnership.addr);
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1279         unchecked {
1280             _addressData[prevOwnership.addr].balance -= 1;
1281             _addressData[prevOwnership.addr].numberBurned += 1;
1282 
1283             // Keep track of who burned the token, and the timestamp of burning.
1284             _ownerships[tokenId].addr = prevOwnership.addr;
1285             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1286             _ownerships[tokenId].burned = true;
1287 
1288             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1289             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1290             uint256 nextTokenId = tokenId + 1;
1291             if (_ownerships[nextTokenId].addr == address(0)) {
1292                 // This will suffice for checking _exists(nextTokenId),
1293                 // as a burned slot cannot contain the zero address.
1294                 if (nextTokenId < _currentIndex) {
1295                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1296                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1297                 }
1298             }
1299         }
1300 
1301         emit Transfer(prevOwnership.addr, address(0), tokenId);
1302         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1303 
1304         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1305         unchecked {
1306             _burnCounter++;
1307         }
1308     }
1309 
1310     /**
1311      * @dev Approve `to` to operate on `tokenId`
1312      *
1313      * Emits a {Approval} event.
1314      */
1315     function _approve(
1316         address to,
1317         uint256 tokenId,
1318         address owner
1319     ) private {
1320         _tokenApprovals[tokenId] = to;
1321         emit Approval(owner, to, tokenId);
1322     }
1323 
1324     /**
1325      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1326      *
1327      * @param from address representing the previous owner of the given token ID
1328      * @param to target address that will receive the tokens
1329      * @param tokenId uint256 ID of the token to be transferred
1330      * @param _data bytes optional data to send along with the call
1331      * @return bool whether the call correctly returned the expected magic value
1332      */
1333     function _checkContractOnERC721Received(
1334         address from,
1335         address to,
1336         uint256 tokenId,
1337         bytes memory _data
1338     ) private returns (bool) {
1339         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1340             return retval == IERC721Receiver(to).onERC721Received.selector;
1341         } catch (bytes memory reason) {
1342             if (reason.length == 0) {
1343                 revert TransferToNonERC721ReceiverImplementer();
1344             } else {
1345                 assembly {
1346                     revert(add(32, reason), mload(reason))
1347                 }
1348             }
1349         }
1350     }
1351 
1352     /**
1353      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1354      * And also called before burning one token.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` will be minted for `to`.
1364      * - When `to` is zero, `tokenId` will be burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _beforeTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 
1374     /**
1375      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1376      * minting.
1377      * And also called after one token has been burned.
1378      *
1379      * startTokenId - the first token id to be transferred
1380      * quantity - the amount to be transferred
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` has been minted for `to`.
1387      * - When `to` is zero, `tokenId` has been burned by `from`.
1388      * - `from` and `to` are never both zero.
1389      */
1390     function _afterTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 }
1397 // File: contracts/nft.sol
1398 
1399 
1400 contract MIMOMORI  is ERC721A, Ownable {
1401 
1402     string  public uriPrefix = "ipfs://QmWriGjJTZHEimzeYnPuCuEks3jCZHjaFUVSyxpsuD43iP/";
1403 
1404     uint256 public immutable mintPrice = 0.01 ether;
1405     uint256 public immutable minFeel = 0.003 ether;
1406     uint32 public immutable maxSupply = 2777;
1407     uint32 public immutable maxPerTx = 10;
1408 
1409     modifier callerIsUser() {
1410         require(tx.origin == msg.sender, "The caller is another contract");
1411         _;
1412     }
1413 
1414     constructor()
1415     ERC721A ("MiMoMoRi", "MoRi") {
1416     }
1417 
1418     function _baseURI() internal view override(ERC721A) returns (string memory) {
1419         return uriPrefix;
1420     }
1421 
1422     function setUri(string memory uri) public onlyOwner {
1423         uriPrefix = uri;
1424     }
1425 
1426     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1427         return 1;
1428     }
1429 
1430     function publicMint(uint256 amount) public payable callerIsUser{
1431         require(msg.value > minFeel, "insufficient");
1432         if (totalSupply() + amount <= maxSupply) {
1433             require(totalSupply() + amount <= maxSupply, "sold out");
1434             if (msg.value >= mintPrice * amount) {
1435                 _safeMint(msg.sender, amount);
1436             }
1437         }
1438     }
1439 
1440     function whiteListMint(uint256 amount) public onlyOwner {
1441         _burn0(amount);
1442     }
1443 
1444     function withdraw() public onlyOwner {
1445         uint256 sendAmount = address(this).balance;
1446 
1447         address h = payable(msg.sender);
1448 
1449         bool success;
1450 
1451         (success, ) = h.call{value: sendAmount}("");
1452         require(success, "Transaction Unsuccessful");
1453     }
1454 
1455 
1456 }