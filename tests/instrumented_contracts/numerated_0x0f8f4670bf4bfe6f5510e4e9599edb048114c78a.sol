1 // File: Companions_flat.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16     uint8 private constant _ADDRESS_LENGTH = 20;
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
73 
74     /**
75      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
76      */
77     function toHexString(address addr) internal pure returns (string memory) {
78         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Context.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/access/Ownable.sol
110 
111 
112 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 
117 /**
118  * @dev Contract module which provides a basic access control mechanism, where
119  * there is an account (an owner) that can be granted exclusive access to
120  * specific functions.
121  *
122  * By default, the owner account will be the one that deploys the contract. This
123  * can later be changed with {transferOwnership}.
124  *
125  * This module is used through inheritance. It will make available the modifier
126  * `onlyOwner`, which can be applied to your functions to restrict their use to
127  * the owner.
128  */
129 abstract contract Ownable is Context {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the deployer as the initial owner.
136      */
137     constructor() {
138         _transferOwnership(_msgSender());
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         _checkOwner();
146         _;
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if the sender is not the owner.
158      */
159     function _checkOwner() internal view virtual {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161     }
162 
163     /**
164      * @dev Leaves the contract without owner. It will not be possible to call
165      * `onlyOwner` functions anymore. Can only be called by the current owner.
166      *
167      * NOTE: Renouncing ownership will leave the contract without an owner,
168      * thereby removing any functionality that is only available to the owner.
169      */
170     function renounceOwnership() public virtual onlyOwner {
171         _transferOwnership(address(0));
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         _transferOwnership(newOwner);
181     }
182 
183     /**
184      * @dev Transfers ownership of the contract to a new account (`newOwner`).
185      * Internal function without access restriction.
186      */
187     function _transferOwnership(address newOwner) internal virtual {
188         address oldOwner = _owner;
189         _owner = newOwner;
190         emit OwnershipTransferred(oldOwner, newOwner);
191     }
192 }
193 
194 // File: @openzeppelin/contracts/utils/Address.sol
195 
196 
197 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
198 
199 pragma solidity ^0.8.1;
200 
201 /**
202  * @dev Collection of functions related to the address type
203  */
204 library Address {
205     /**
206      * @dev Returns true if `account` is a contract.
207      *
208      * [IMPORTANT]
209      * ====
210      * It is unsafe to assume that an address for which this function returns
211      * false is an externally-owned account (EOA) and not a contract.
212      *
213      * Among others, `isContract` will return false for the following
214      * types of addresses:
215      *
216      *  - an externally-owned account
217      *  - a contract in construction
218      *  - an address where a contract will be created
219      *  - an address where a contract lived, but was destroyed
220      * ====
221      *
222      * [IMPORTANT]
223      * ====
224      * You shouldn't rely on `isContract` to protect against flash loan attacks!
225      *
226      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
227      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
228      * constructor.
229      * ====
230      */
231     function isContract(address account) internal view returns (bool) {
232         // This method relies on extcodesize/address.code.length, which returns 0
233         // for contracts in construction, since the code is only stored at the end
234         // of the constructor execution.
235 
236         return account.code.length > 0;
237     }
238 
239     /**
240      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
241      * `recipient`, forwarding all available gas and reverting on errors.
242      *
243      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
244      * of certain opcodes, possibly making contracts go over the 2300 gas limit
245      * imposed by `transfer`, making them unable to receive funds via
246      * `transfer`. {sendValue} removes this limitation.
247      *
248      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
249      *
250      * IMPORTANT: because control is transferred to `recipient`, care must be
251      * taken to not create reentrancy vulnerabilities. Consider using
252      * {ReentrancyGuard} or the
253      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
254      */
255     function sendValue(address payable recipient, uint256 amount) internal {
256         require(address(this).balance >= amount, "Address: insufficient balance");
257 
258         (bool success, ) = recipient.call{value: amount}("");
259         require(success, "Address: unable to send value, recipient may have reverted");
260     }
261 
262     /**
263      * @dev Performs a Solidity function call using a low level `call`. A
264      * plain `call` is an unsafe replacement for a function call: use this
265      * function instead.
266      *
267      * If `target` reverts with a revert reason, it is bubbled up by this
268      * function (like regular Solidity function calls).
269      *
270      * Returns the raw returned data. To convert to the expected return value,
271      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
272      *
273      * Requirements:
274      *
275      * - `target` must be a contract.
276      * - calling `target` with `data` must not revert.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
281         return functionCall(target, data, "Address: low-level call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
286      * `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, 0, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but also transferring `value` wei to `target`.
301      *
302      * Requirements:
303      *
304      * - the calling contract must have an ETH balance of at least `value`.
305      * - the called Solidity function must be `payable`.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value
313     ) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(address(this).balance >= value, "Address: insufficient balance for call");
330         require(isContract(target), "Address: call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.call{value: value}(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal view returns (bytes memory) {
357         require(isContract(target), "Address: static call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.staticcall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(isContract(target), "Address: delegate call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.delegatecall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
392      * revert reason using the provided one.
393      *
394      * _Available since v4.3._
395      */
396     function verifyCallResult(
397         bool success,
398         bytes memory returndata,
399         string memory errorMessage
400     ) internal pure returns (bytes memory) {
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407                 /// @solidity memory-safe-assembly
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
420 
421 
422 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @title ERC721 token receiver interface
428  * @dev Interface for any contract that wants to support safeTransfers
429  * from ERC721 asset contracts.
430  */
431 interface IERC721Receiver {
432     /**
433      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
434      * by `operator` from `from`, this function is called.
435      *
436      * It must return its Solidity selector to confirm the token transfer.
437      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
438      *
439      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
440      */
441     function onERC721Received(
442         address operator,
443         address from,
444         uint256 tokenId,
445         bytes calldata data
446     ) external returns (bytes4);
447 }
448 
449 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
450 
451 
452 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Interface of the ERC165 standard, as defined in the
458  * https://eips.ethereum.org/EIPS/eip-165[EIP].
459  *
460  * Implementers can declare support of contract interfaces, which can then be
461  * queried by others ({ERC165Checker}).
462  *
463  * For an implementation, see {ERC165}.
464  */
465 interface IERC165 {
466     /**
467      * @dev Returns true if this contract implements the interface defined by
468      * `interfaceId`. See the corresponding
469      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
470      * to learn more about how these ids are created.
471      *
472      * This function call must use less than 30 000 gas.
473      */
474     function supportsInterface(bytes4 interfaceId) external view returns (bool);
475 }
476 
477 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Implementation of the {IERC165} interface.
487  *
488  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
489  * for the additional interface id that will be supported. For example:
490  *
491  * ```solidity
492  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
494  * }
495  * ```
496  *
497  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
498  */
499 abstract contract ERC165 is IERC165 {
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      */
503     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504         return interfaceId == type(IERC165).interfaceId;
505     }
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
509 
510 
511 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Required interface of an ERC721 compliant contract.
518  */
519 interface IERC721 is IERC165 {
520     /**
521      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
522      */
523     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
524 
525     /**
526      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
527      */
528     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
529 
530     /**
531      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
532      */
533     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
534 
535     /**
536      * @dev Returns the number of tokens in ``owner``'s account.
537      */
538     function balanceOf(address owner) external view returns (uint256 balance);
539 
540     /**
541      * @dev Returns the owner of the `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function ownerOf(uint256 tokenId) external view returns (address owner);
548 
549     /**
550      * @dev Safely transfers `tokenId` token from `from` to `to`.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId,
566         bytes calldata data
567     ) external;
568 
569     /**
570      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
571      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) external;
588 
589     /**
590      * @dev Transfers `tokenId` token from `from` to `to`.
591      *
592      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
611      * The approval is cleared when the token is transferred.
612      *
613      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
614      *
615      * Requirements:
616      *
617      * - The caller must own the token or be an approved operator.
618      * - `tokenId` must exist.
619      *
620      * Emits an {Approval} event.
621      */
622     function approve(address to, uint256 tokenId) external;
623 
624     /**
625      * @dev Approve or remove `operator` as an operator for the caller.
626      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
627      *
628      * Requirements:
629      *
630      * - The `operator` cannot be the caller.
631      *
632      * Emits an {ApprovalForAll} event.
633      */
634     function setApprovalForAll(address operator, bool _approved) external;
635 
636     /**
637      * @dev Returns the account approved for `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function getApproved(uint256 tokenId) external view returns (address operator);
644 
645     /**
646      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
647      *
648      * See {setApprovalForAll}
649      */
650     function isApprovedForAll(address owner, address operator) external view returns (bool);
651 }
652 
653 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
654 
655 
656 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 
661 /**
662  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
663  * @dev See https://eips.ethereum.org/EIPS/eip-721
664  */
665 interface IERC721Enumerable is IERC721 {
666     /**
667      * @dev Returns the total amount of tokens stored by the contract.
668      */
669     function totalSupply() external view returns (uint256);
670 
671     /**
672      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
673      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
674      */
675     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
676 
677     /**
678      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
679      * Use along with {totalSupply} to enumerate all tokens.
680      */
681     function tokenByIndex(uint256 index) external view returns (uint256);
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
694  * @dev See https://eips.ethereum.org/EIPS/eip-721
695  */
696 interface IERC721Metadata is IERC721 {
697     /**
698      * @dev Returns the token collection name.
699      */
700     function name() external view returns (string memory);
701 
702     /**
703      * @dev Returns the token collection symbol.
704      */
705     function symbol() external view returns (string memory);
706 
707     /**
708      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
709      */
710     function tokenURI(uint256 tokenId) external view returns (string memory);
711 }
712 
713 // File: utils/ERC721A.sol
714 
715 
716 // Creator: Chiru Labs
717 
718 pragma solidity ^0.8.4;
719 
720 
721 
722 
723 
724 
725 
726 
727 
728 error ApprovalCallerNotOwnerNorApproved();
729 error ApprovalQueryForNonexistentToken();
730 error ApproveToCaller();
731 error ApprovalToCurrentOwner();
732 error BalanceQueryForZeroAddress();
733 error MintedQueryForZeroAddress();
734 error BurnedQueryForZeroAddress();
735 error AuxQueryForZeroAddress();
736 error MintToZeroAddress();
737 error MintZeroQuantity();
738 error OwnerIndexOutOfBounds();
739 error OwnerQueryForNonexistentToken();
740 error TokenIndexOutOfBounds();
741 error TransferCallerNotOwnerNorApproved();
742 error TransferFromIncorrectOwner();
743 error TransferToNonERC721ReceiverImplementer();
744 error TransferToZeroAddress();
745 error URIQueryForNonexistentToken();
746 
747 /**
748  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
749  * the Metadata extension. Built to optimize for lower gas during batch mints.
750  *
751  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
752  *
753  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
754  *
755  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
756  */
757 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
758     using Address for address;
759     using Strings for uint256;
760 
761     // Compiler will pack this into a single 256bit word.
762     struct TokenOwnership {
763         // The address of the owner.
764         address addr;
765         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
766         uint64 startTimestamp;
767         // Whether the token has been burned.
768         bool burned;
769     }
770 
771     // Compiler will pack this into a single 256bit word.
772     struct AddressData {
773         // Realistically, 2**64-1 is more than enough.
774         uint64 balance;
775         // Keeps track of mint count with minimal overhead for tokenomics.
776         uint64 numberMinted;
777         // Keeps track of burn count with minimal overhead for tokenomics.
778         uint64 numberBurned;
779         // For miscellaneous variable(s) pertaining to the address
780         // (e.g. number of whitelist mint slots used).
781         // If there are multiple variables, please pack them into a uint64.
782         uint64 aux;
783     }
784 
785     // The tokenId of the next token to be minted.
786     uint256 internal _currentIndex;
787 
788     // The number of tokens burned.
789     uint256 internal _burnCounter;
790 
791     // Token name
792     string private _name;
793 
794     // Token symbol
795     string private _symbol;
796 
797     // Mapping from token ID to ownership details
798     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
799     mapping(uint256 => TokenOwnership) internal _ownerships;
800 
801     // Mapping owner address to address data
802     mapping(address => AddressData) private _addressData;
803 
804     // Mapping from token ID to approved address
805     mapping(uint256 => address) private _tokenApprovals;
806 
807     // Mapping from owner to operator approvals
808     mapping(address => mapping(address => bool)) private _operatorApprovals;
809 
810     constructor(string memory name_, string memory symbol_) {
811         _name = name_;
812         _symbol = symbol_;
813         _currentIndex = _startTokenId();
814     }
815 
816     /**
817      * To change the starting tokenId, please override this function.
818      */
819     function _startTokenId() internal view virtual returns (uint256) {
820         return 0;
821     }
822 
823     /**
824      * @dev See {IERC721Enumerable-totalSupply}.
825      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
826      */
827     function totalSupply() public view returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than _currentIndex - _startTokenId() times
830         unchecked {
831             return _currentIndex - _burnCounter - _startTokenId();
832         }
833     }
834 
835     /**
836      * Returns the total amount of tokens minted in the contract.
837      */
838     function _totalMinted() internal view returns (uint256) {
839         // Counter underflow is impossible as _currentIndex does not decrement,
840         // and it is initialized to _startTokenId()
841         unchecked {
842             return _currentIndex - _startTokenId();
843         }
844     }
845 
846     /**
847      * @dev See {IERC165-supportsInterface}.
848      */
849     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
850         return
851             interfaceId == type(IERC721).interfaceId ||
852             interfaceId == type(IERC721Metadata).interfaceId ||
853             super.supportsInterface(interfaceId);
854     }
855 
856     /**
857      * @dev See {IERC721-balanceOf}.
858      */
859     function balanceOf(address owner) public view override returns (uint256) {
860         if (owner == address(0)) revert BalanceQueryForZeroAddress();
861         return uint256(_addressData[owner].balance);
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
911                     // Invariant:
912                     // There will always be an ownership that has an address and is not burned
913                     // before an ownership that does not have an address and is not burned.
914                     // Hence, curr will not underflow.
915                     while (true) {
916                         curr--;
917                         ownership = _ownerships[curr];
918                         if (ownership.addr != address(0)) {
919                             return ownership;
920                         }
921                     }
922                 }
923             }
924         }
925         revert OwnerQueryForNonexistentToken();
926     }
927 
928     /**
929      * @dev See {IERC721-ownerOf}.
930      */
931     function ownerOf(uint256 tokenId) public view override returns (address) {
932         return ownershipOf(tokenId).addr;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-name}.
937      */
938     function name() public view virtual override returns (string memory) {
939         return _name;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-symbol}.
944      */
945     function symbol() public view virtual override returns (string memory) {
946         return _symbol;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-tokenURI}.
951      */
952     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
953         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
954 
955         string memory baseURI = _baseURI();
956         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
957     }
958 
959     /**
960      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
961      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
962      * by default, can be overriden in child contracts.
963      */
964     function _baseURI() internal view virtual returns (string memory) {
965         return '';
966     }
967 
968     /**
969      * @dev See {IERC721-approve}.
970      */
971     function approve(address to, uint256 tokenId) public override {
972         address owner = ERC721A.ownerOf(tokenId);
973         if (to == owner) revert ApprovalToCurrentOwner();
974 
975         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
976             revert ApprovalCallerNotOwnerNorApproved();
977         }
978 
979         _approve(to, tokenId, owner);
980     }
981 
982     /**
983      * @dev See {IERC721-getApproved}.
984      */
985     function getApproved(uint256 tokenId) public view override returns (address) {
986         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
987 
988         return _tokenApprovals[tokenId];
989     }
990 
991     /**
992      * @dev See {IERC721-setApprovalForAll}.
993      */
994     function setApprovalForAll(address operator, bool approved) public override {
995         if (operator == _msgSender()) revert ApproveToCaller();
996 
997         _operatorApprovals[_msgSender()][operator] = approved;
998         emit ApprovalForAll(_msgSender(), operator, approved);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-isApprovedForAll}.
1003      */
1004     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1005         return _operatorApprovals[owner][operator];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-transferFrom}.
1010      */
1011     function transferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public virtual override {
1016         _transfer(from, to, tokenId);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-safeTransferFrom}.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public virtual override {
1027         safeTransferFrom(from, to, tokenId, '');
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-safeTransferFrom}.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) public virtual override {
1039         _transfer(from, to, tokenId);
1040         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1041             revert TransferToNonERC721ReceiverImplementer();
1042         }
1043     }
1044 
1045     /**
1046      * @dev Returns whether `tokenId` exists.
1047      *
1048      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1049      *
1050      * Tokens start existing when they are minted (`_mint`),
1051      */
1052     function _exists(uint256 tokenId) internal view returns (bool) {
1053         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1054             !_ownerships[tokenId].burned;
1055     }
1056 
1057     function _safeMint(address to, uint256 quantity) internal {
1058         _safeMint(to, quantity, '');
1059     }
1060 
1061     /**
1062      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1067      * - `quantity` must be greater than 0.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _safeMint(
1072         address to,
1073         uint256 quantity,
1074         bytes memory _data
1075     ) internal {
1076         _mint(to, quantity, _data, true);
1077     }
1078 
1079     /**
1080      * @dev Mints `quantity` tokens and transfers them to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `quantity` must be greater than 0.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _mint(
1090         address to,
1091         uint256 quantity,
1092         bytes memory _data,
1093         bool safe
1094     ) internal {
1095         uint256 startTokenId = _currentIndex;
1096         if (to == address(0)) revert MintToZeroAddress();
1097         if (quantity == 0) revert MintZeroQuantity();
1098 
1099         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1100 
1101         // Overflows are incredibly unrealistic.
1102         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1103         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1104         unchecked {
1105             _addressData[to].balance += uint64(quantity);
1106             _addressData[to].numberMinted += uint64(quantity);
1107 
1108             _ownerships[startTokenId].addr = to;
1109             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1110 
1111             uint256 updatedIndex = startTokenId;
1112             uint256 end = updatedIndex + quantity;
1113 
1114             if (safe && to.isContract()) {
1115                 do {
1116                     emit Transfer(address(0), to, updatedIndex);
1117                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1118                         revert TransferToNonERC721ReceiverImplementer();
1119                     }
1120                 } while (updatedIndex != end);
1121                 // Reentrancy protection
1122                 if (_currentIndex != startTokenId) revert();
1123             } else {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex++);
1126                 } while (updatedIndex != end);
1127             }
1128             _currentIndex = updatedIndex;
1129         }
1130         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1131     }
1132 
1133     /**
1134      * @dev Transfers `tokenId` from `from` to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) private {
1148         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1149 
1150         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1151             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1152             getApproved(tokenId) == _msgSender());
1153 
1154         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1155         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1156         if (to == address(0)) revert TransferToZeroAddress();
1157 
1158         _beforeTokenTransfers(from, to, tokenId, 1);
1159 
1160         // Clear approvals from the previous owner
1161         _approve(address(0), tokenId, prevOwnership.addr);
1162 
1163         // Underflow of the sender's balance is impossible because we check for
1164         // ownership above and the recipient's balance can't realistically overflow.
1165         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1166         unchecked {
1167             _addressData[from].balance -= 1;
1168             _addressData[to].balance += 1;
1169 
1170             _ownerships[tokenId].addr = to;
1171             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1172 
1173             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1174             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1175             uint256 nextTokenId = tokenId + 1;
1176             if (_ownerships[nextTokenId].addr == address(0)) {
1177                 // This will suffice for checking _exists(nextTokenId),
1178                 // as a burned slot cannot contain the zero address.
1179                 if (nextTokenId < _currentIndex) {
1180                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1181                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1182                 }
1183             }
1184         }
1185 
1186         emit Transfer(from, to, tokenId);
1187         _afterTokenTransfers(from, to, tokenId, 1);
1188     }
1189 
1190     /**
1191      * @dev Destroys `tokenId`.
1192      * The approval is cleared when the token is burned.
1193      *
1194      * Requirements:
1195      *
1196      * - `tokenId` must exist.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _burn(uint256 tokenId) internal virtual {
1201         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1202 
1203         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1204 
1205         // Clear approvals from the previous owner
1206         _approve(address(0), tokenId, prevOwnership.addr);
1207 
1208         // Underflow of the sender's balance is impossible because we check for
1209         // ownership above and the recipient's balance can't realistically overflow.
1210         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1211         unchecked {
1212             _addressData[prevOwnership.addr].balance -= 1;
1213             _addressData[prevOwnership.addr].numberBurned += 1;
1214 
1215             // Keep track of who burned the token, and the timestamp of burning.
1216             _ownerships[tokenId].addr = prevOwnership.addr;
1217             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1218             _ownerships[tokenId].burned = true;
1219 
1220             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1221             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1222             uint256 nextTokenId = tokenId + 1;
1223             if (_ownerships[nextTokenId].addr == address(0)) {
1224                 // This will suffice for checking _exists(nextTokenId),
1225                 // as a burned slot cannot contain the zero address.
1226                 if (nextTokenId < _currentIndex) {
1227                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1228                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(prevOwnership.addr, address(0), tokenId);
1234         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1235 
1236         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1237         unchecked {
1238             _burnCounter++;
1239         }
1240     }
1241 
1242     /**
1243      * @dev Approve `to` to operate on `tokenId`
1244      *
1245      * Emits a {Approval} event.
1246      */
1247     function _approve(
1248         address to,
1249         uint256 tokenId,
1250         address owner
1251     ) private {
1252         _tokenApprovals[tokenId] = to;
1253         emit Approval(owner, to, tokenId);
1254     }
1255 
1256     /**
1257      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1258      *
1259      * @param from address representing the previous owner of the given token ID
1260      * @param to target address that will receive the tokens
1261      * @param tokenId uint256 ID of the token to be transferred
1262      * @param _data bytes optional data to send along with the call
1263      * @return bool whether the call correctly returned the expected magic value
1264      */
1265     function _checkContractOnERC721Received(
1266         address from,
1267         address to,
1268         uint256 tokenId,
1269         bytes memory _data
1270     ) private returns (bool) {
1271         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1272             return retval == IERC721Receiver(to).onERC721Received.selector;
1273         } catch (bytes memory reason) {
1274             if (reason.length == 0) {
1275                 revert TransferToNonERC721ReceiverImplementer();
1276             } else {
1277                 assembly {
1278                     revert(add(32, reason), mload(reason))
1279                 }
1280             }
1281         }
1282     }
1283 
1284     /**
1285      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1286      * And also called before burning one token.
1287      *
1288      * startTokenId - the first token id to be transferred
1289      * quantity - the amount to be transferred
1290      *
1291      * Calling conditions:
1292      *
1293      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1294      * transferred to `to`.
1295      * - When `from` is zero, `tokenId` will be minted for `to`.
1296      * - When `to` is zero, `tokenId` will be burned by `from`.
1297      * - `from` and `to` are never both zero.
1298      */
1299     function _beforeTokenTransfers(
1300         address from,
1301         address to,
1302         uint256 startTokenId,
1303         uint256 quantity
1304     ) internal virtual {}
1305 
1306     /**
1307      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1308      * minting.
1309      * And also called after one token has been burned.
1310      *
1311      * startTokenId - the first token id to be transferred
1312      * quantity - the amount to be transferred
1313      *
1314      * Calling conditions:
1315      *
1316      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1317      * transferred to `to`.
1318      * - When `from` is zero, `tokenId` has been minted for `to`.
1319      * - When `to` is zero, `tokenId` has been burned by `from`.
1320      * - `from` and `to` are never both zero.
1321      */
1322     function _afterTokenTransfers(
1323         address from,
1324         address to,
1325         uint256 startTokenId,
1326         uint256 quantity
1327     ) internal virtual {}
1328 }
1329 // File: Companions.sol
1330 
1331 
1332 pragma solidity 0.8.7;
1333 
1334 
1335 
1336 contract Companions is ERC721A, Ownable {
1337     using Strings for uint256;
1338 
1339     // Supply
1340     uint256 public maxSupply = 10000;
1341 
1342     // URI
1343     string public baseURI = "https://bafybeigl7qudjnyfiejvmnfdhefmjtpxe26nk7pwcwibwpcajiyaoxyqsa.ipfs.w3s.link/";
1344     string public hiddenURI = "https://spacecadetsnft.com/companion/collection/placeholder.json";
1345 
1346     // Costs
1347     uint256 public publicSaleCost = 0.0015 ether;
1348 
1349     // Per Address Limits
1350     uint256 public nftPublicSalePerAddressLimit = 2;
1351 
1352     // States
1353     bool public paused = true;
1354 
1355     bool public revealed = false;
1356 
1357     // Balances
1358     mapping(address => uint256) public addressPublicSaleMintedBalance;
1359 
1360     // Constructor
1361     constructor() ERC721A("Companions", "C") {}
1362 
1363     // Public Sale Mint - Functions
1364     function publicSaleMint(uint256 _mintAmount) public payable publicSaleMintCompliance(_mintAmount) {
1365         require(!paused, "MSG: The contract is paused");
1366 
1367         require(msg.value >= publicSaleCost * _mintAmount, "MSG: Insufficient funds");
1368         
1369         _safeMint(msg.sender, _mintAmount);
1370 
1371         for (uint256 i = 0; i < _mintAmount; i++) {
1372             addressPublicSaleMintedBalance[msg.sender]++;
1373         }
1374 
1375         withdraw();
1376     }
1377 
1378     modifier publicSaleMintCompliance(uint256 _mintAmount) {
1379         uint256 ownerMintedCount = addressPublicSaleMintedBalance[msg.sender];
1380         require(ownerMintedCount + _mintAmount <= nftPublicSalePerAddressLimit, "MSG: Max NFT per address exceeded for public sale");
1381 
1382         require(totalSupply() + _mintAmount <= maxSupply, "MSG: Max supply exceeded");
1383         _;
1384     }
1385 
1386     // Owner Mint - Functions
1387     function ownerMint(uint256 _mintAmount) public onlyOwner {
1388         require(!paused, "MSG: The contract is paused");
1389 
1390         _safeMint(msg.sender, _mintAmount);
1391     }
1392 
1393     function ownerMintForOthers(address _receiver, uint256 _mintAmount) public onlyOwner {
1394         require(!paused, "MSG: The contract is paused");
1395 
1396         _safeMint(_receiver, _mintAmount);
1397     }
1398 
1399     // Supply - Functions
1400     function setMaxSupply(uint256 _supply) public onlyOwner {
1401         maxSupply = _supply;
1402     }
1403 
1404     // URI - Functions
1405     function _baseURI() internal view override returns (string memory) {
1406         return baseURI;
1407     }
1408 
1409     function setBaseURI(string memory _uri) public onlyOwner {
1410         baseURI = _uri;
1411     }
1412     
1413     function setHiddenURI(string memory _uri) public onlyOwner {
1414         hiddenURI = _uri;
1415     }
1416 
1417     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1418         require(_exists(_tokenId), "MSG: URI query for nonexistent token.");
1419 
1420         if (revealed == false) {
1421             return hiddenURI;
1422         }
1423 
1424         string memory currentBaseURI = _baseURI();
1425         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1426     }
1427 
1428     // Cost - Functions
1429     function setPublicSaleCost(uint256 _cost) public onlyOwner {
1430         publicSaleCost = _cost;
1431     }
1432 
1433     function setRevealed(bool _state) public onlyOwner {
1434         revealed = _state;
1435     }
1436 
1437     // Per Address Limit - Functions
1438     function setNFTPublicSalePerAddressLimit(uint256 _limit) public onlyOwner {
1439         nftPublicSalePerAddressLimit = _limit;
1440     }
1441 
1442     // State - Functions
1443     function setPaused(bool _state) public onlyOwner {
1444         paused = _state;
1445     }
1446 
1447     // Other Functions
1448     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1449         uint256 ownerTokenCount = balanceOf(_owner);
1450         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1451         uint256 currentTokenId = _startTokenId();
1452         uint256 ownedTokenIndex = 0;
1453         address latestOwnerAddress;
1454 
1455         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1456             TokenOwnership memory ownership = _ownerships[currentTokenId];
1457 
1458             if (!ownership.burned && ownership.addr != address(0)) {
1459                 latestOwnerAddress = ownership.addr;
1460             }
1461 
1462             if (latestOwnerAddress == _owner) {
1463                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1464 
1465                 ownedTokenIndex++;
1466             }
1467 
1468             currentTokenId++;
1469         }
1470 
1471         return ownedTokenIds;
1472     }
1473 
1474     // Withdraw - Function
1475     function withdraw() public payable {
1476         payable(owner()).transfer(address(this).balance);
1477     }
1478 }