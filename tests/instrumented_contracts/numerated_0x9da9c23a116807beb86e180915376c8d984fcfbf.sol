1 // SPDX-License-Identifier: MIT
2 //  * @dev String operations.
3 //  */
4 library Strings {
5     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
6     uint8 private constant _ADDRESS_LENGTH = 20;
7 
8     /**
9      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
10      */
11     function toString(uint256 value) internal pure returns (string memory) {
12         // Inspired by OraclizeAPI's implementation - MIT licence
13         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
35      */
36     function toHexString(uint256 value) internal pure returns (string memory) {
37         if (value == 0) {
38             return "0x00";
39         }
40         uint256 temp = value;
41         uint256 length = 0;
42         while (temp != 0) {
43             length++;
44             temp >>= 8;
45         }
46         return toHexString(value, length);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
51      */
52     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
53         bytes memory buffer = new bytes(2 * length + 2);
54         buffer[0] = "0";
55         buffer[1] = "x";
56         for (uint256 i = 2 * length + 1; i > 1; --i) {
57             buffer[i] = _HEX_SYMBOLS[value & 0xf];
58             value >>= 4;
59         }
60         require(value == 0, "Strings: hex length insufficient");
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
66      */
67     function toHexString(address addr) internal pure returns (string memory) {
68         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
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
102 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
132      * @dev Throws if called by any account other than the owner.
133      */
134     modifier onlyOwner() {
135         _checkOwner();
136         _;
137     }
138 
139     /**
140      * @dev Returns the address of the current owner.
141      */
142     function owner() public view virtual returns (address) {
143         return _owner;
144     }
145 
146     /**
147      * @dev Throws if the sender is not the owner.
148      */
149     function _checkOwner() internal view virtual {
150         require(owner() == _msgSender(), "Ownable: caller is not the owner");
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _transferOwnership(newOwner);
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Internal function without access restriction.
165      */
166     function _transferOwnership(address newOwner) internal virtual {
167         address oldOwner = _owner;
168         _owner = newOwner;
169         emit OwnershipTransferred(oldOwner, newOwner);
170     }
171 }
172 
173 // File: @openzeppelin/contracts/utils/Address.sol
174 
175 
176 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
177 
178 pragma solidity ^0.8.1;
179 
180 /**
181  * @dev Collection of functions related to the address type
182  */
183 library Address {
184     /**
185      * @dev Returns true if `account` is a contract.
186      *
187      * [IMPORTANT]
188      * ====
189      * It is unsafe to assume that an address for which this function returns
190      * false is an externally-owned account (EOA) and not a contract.
191      *
192      * Among others, `isContract` will return false for the following
193      * types of addresses:
194      *
195      *  - an externally-owned account
196      *  - a contract in construction
197      *  - an address where a contract will be created
198      *  - an address where a contract lived, but was destroyed
199      * ====
200      *
201      * [IMPORTANT]
202      * ====
203      * You shouldn't rely on `isContract` to protect against flash loan attacks!
204      *
205      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
206      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
207      * constructor.
208      * ====
209      */
210     function isContract(address account) internal view returns (bool) {
211         // This method relies on extcodesize/address.code.length, which returns 0
212         // for contracts in construction, since the code is only stored at the end
213         // of the constructor execution.
214 
215         return account.code.length > 0;
216     }
217 
218     /**
219      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
220      * `recipient`, forwarding all available gas and reverting on errors.
221      *
222      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
223      * of certain opcodes, possibly making contracts go over the 2300 gas limit
224      * imposed by `transfer`, making them unable to receive funds via
225      * `transfer`. {sendValue} removes this limitation.
226      *
227      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
228      *
229      * IMPORTANT: because control is transferred to `recipient`, care must be
230      * taken to not create reentrancy vulnerabilities. Consider using
231      * {ReentrancyGuard} or the
232      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
233      */
234     function sendValue(address payable recipient, uint256 amount) internal {
235         require(address(this).balance >= amount, "Address: insufficient balance");
236 
237         (bool success, ) = recipient.call{value: amount}("");
238         require(success, "Address: unable to send value, recipient may have reverted");
239     }
240 
241     /**
242      * @dev Performs a Solidity function call using a low level `call`. A
243      * plain `call` is an unsafe replacement for a function call: use this
244      * function instead.
245      *
246      * If `target` reverts with a revert reason, it is bubbled up by this
247      * function (like regular Solidity function calls).
248      *
249      * Returns the raw returned data. To convert to the expected return value,
250      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
251      *
252      * Requirements:
253      *
254      * - `target` must be a contract.
255      * - calling `target` with `data` must not revert.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
260         return functionCall(target, data, "Address: low-level call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
265      * `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         return functionCallWithValue(target, data, 0, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but also transferring `value` wei to `target`.
280      *
281      * Requirements:
282      *
283      * - the calling contract must have an ETH balance of at least `value`.
284      * - the called Solidity function must be `payable`.
285      *
286      * _Available since v3.1._
287      */
288     function functionCallWithValue(
289         address target,
290         bytes memory data,
291         uint256 value
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
298      * with `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         require(address(this).balance >= value, "Address: insufficient balance for call");
309         require(isContract(target), "Address: call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.call{value: value}(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
322         return functionStaticCall(target, data, "Address: low-level static call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
327      * but performing a static call.
328      *
329      * _Available since v3.3._
330      */
331     function functionStaticCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal view returns (bytes memory) {
336         require(isContract(target), "Address: static call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.staticcall(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(isContract(target), "Address: delegate call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.delegatecall(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
371      * revert reason using the provided one.
372      *
373      * _Available since v4.3._
374      */
375     function verifyCallResult(
376         bool success,
377         bytes memory returndata,
378         string memory errorMessage
379     ) internal pure returns (bytes memory) {
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386                 /// @solidity memory-safe-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
399 
400 
401 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @title ERC721 token receiver interface
407  * @dev Interface for any contract that wants to support safeTransfers
408  * from ERC721 asset contracts.
409  */
410 interface IERC721Receiver {
411     /**
412      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
413      * by `operator` from `from`, this function is called.
414      *
415      * It must return its Solidity selector to confirm the token transfer.
416      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
417      *
418      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
419      */
420     function onERC721Received(
421         address operator,
422         address from,
423         uint256 tokenId,
424         bytes calldata data
425     ) external returns (bytes4);
426 }
427 
428 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Interface of the ERC165 standard, as defined in the
437  * https://eips.ethereum.org/EIPS/eip-165[EIP].
438  *
439  * Implementers can declare support of contract interfaces, which can then be
440  * queried by others ({ERC165Checker}).
441  *
442  * For an implementation, see {ERC165}.
443  */
444 interface IERC165 {
445     /**
446      * @dev Returns true if this contract implements the interface defined by
447      * `interfaceId`. See the corresponding
448      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
449      * to learn more about how these ids are created.
450      *
451      * This function call must use less than 30 000 gas.
452      */
453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
454 }
455 
456 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Implementation of the {IERC165} interface.
466  *
467  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
468  * for the additional interface id that will be supported. For example:
469  *
470  * ```solidity
471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
473  * }
474  * ```
475  *
476  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
477  */
478 abstract contract ERC165 is IERC165 {
479     /**
480      * @dev See {IERC165-supportsInterface}.
481      */
482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483         return interfaceId == type(IERC165).interfaceId;
484     }
485 }
486 
487 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
488 
489 
490 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @dev Required interface of an ERC721 compliant contract.
497  */
498 interface IERC721 is IERC165 {
499     /**
500      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
501      */
502     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
506      */
507     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
511      */
512     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
513 
514     /**
515      * @dev Returns the number of tokens in ``owner``'s account.
516      */
517     function balanceOf(address owner) external view returns (uint256 balance);
518 
519     /**
520      * @dev Returns the owner of the `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function ownerOf(uint256 tokenId) external view returns (address owner);
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId,
545         bytes calldata data
546     ) external;
547 
548     /**
549      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
550      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Transfers `tokenId` token from `from` to `to`.
570      *
571      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
579      *
580      * Emits a {Transfer} event.
581      */
582     function transferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external;
587 
588     /**
589      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
590      * The approval is cleared when the token is transferred.
591      *
592      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
593      *
594      * Requirements:
595      *
596      * - The caller must own the token or be an approved operator.
597      * - `tokenId` must exist.
598      *
599      * Emits an {Approval} event.
600      */
601     function approve(address to, uint256 tokenId) external;
602 
603     /**
604      * @dev Approve or remove `operator` as an operator for the caller.
605      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
606      *
607      * Requirements:
608      *
609      * - The `operator` cannot be the caller.
610      *
611      * Emits an {ApprovalForAll} event.
612      */
613     function setApprovalForAll(address operator, bool _approved) external;
614 
615     /**
616      * @dev Returns the account approved for `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function getApproved(uint256 tokenId) external view returns (address operator);
623 
624     /**
625      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
626      *
627      * See {setApprovalForAll}
628      */
629     function isApprovedForAll(address owner, address operator) external view returns (bool);
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
633 
634 
635 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
642  * @dev See https://eips.ethereum.org/EIPS/eip-721
643  */
644 interface IERC721Enumerable is IERC721 {
645     /**
646      * @dev Returns the total amount of tokens stored by the contract.
647      */
648     function totalSupply() external view returns (uint256);
649 
650     /**
651      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
652      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
653      */
654     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
655 
656     /**
657      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
658      * Use along with {totalSupply} to enumerate all tokens.
659      */
660     function tokenByIndex(uint256 index) external view returns (uint256);
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
673  * @dev See https://eips.ethereum.org/EIPS/eip-721
674  */
675 interface IERC721Metadata is IERC721 {
676     /**
677      * @dev Returns the token collection name.
678      */
679     function name() external view returns (string memory);
680 
681     /**
682      * @dev Returns the token collection symbol.
683      */
684     function symbol() external view returns (string memory);
685 
686     /**
687      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
688      */
689     function tokenURI(uint256 tokenId) external view returns (string memory);
690 }
691 
692 // File: contracts/ERC721A.sol
693 
694 
695 // Creator: Chiru Labs
696 
697 pragma solidity ^0.8.4;
698 
699 
700 
701 
702 
703 
704 
705 
706 
707 error ApprovalCallerNotOwnerNorApproved();
708 error ApprovalQueryForNonexistentToken();
709 error ApproveToCaller();
710 error ApprovalToCurrentOwner();
711 error BalanceQueryForZeroAddress();
712 error MintedQueryForZeroAddress();
713 error BurnedQueryForZeroAddress();
714 error AuxQueryForZeroAddress();
715 error MintToZeroAddress();
716 error MintZeroQuantity();
717 error OwnerIndexOutOfBounds();
718 error OwnerQueryForNonexistentToken();
719 error TokenIndexOutOfBounds();
720 error TransferCallerNotOwnerNorApproved();
721 error TransferFromIncorrectOwner();
722 error TransferToNonERC721ReceiverImplementer();
723 error TransferToZeroAddress();
724 error URIQueryForNonexistentToken();
725 
726 /**
727  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
728  * the Metadata extension. Built to optimize for lower gas during batch mints.
729  *
730  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
731  *
732  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
733  *
734  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
735  */
736 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
737     using Address for address;
738     using Strings for uint256;
739 
740     // Compiler will pack this into a single 256bit word.
741     struct TokenOwnership {
742         // The address of the owner.
743         address addr;
744         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
745         uint64 startTimestamp;
746         // Whether the token has been burned.
747         bool burned;
748     }
749 
750     // Compiler will pack this into a single 256bit word.
751     struct AddressData {
752         // Realistically, 2**64-1 is more than enough.
753         uint64 balance;
754         // Keeps track of mint count with minimal overhead for tokenomics.
755         uint64 numberMinted;
756         // Keeps track of burn count with minimal overhead for tokenomics.
757         uint64 numberBurned;
758         // For miscellaneous variable(s) pertaining to the address
759         // (e.g. number of whitelist mint slots used).
760         // If there are multiple variables, please pack them into a uint64.
761         uint64 aux;
762     }
763 
764     // The tokenId of the next token to be minted.
765     uint256 internal _currentIndex;
766 
767     // The number of tokens burned.
768     uint256 internal _burnCounter;
769 
770     // Token name
771     string private _name;
772 
773     // Token symbol
774     string private _symbol;
775 
776     // Mapping from token ID to ownership details
777     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
778     mapping(uint256 => TokenOwnership) internal _ownerships;
779 
780     // Mapping owner address to address data
781     mapping(address => AddressData) private _addressData;
782 
783     // Mapping from token ID to approved address
784     mapping(uint256 => address) private _tokenApprovals;
785 
786     // Mapping from owner to operator approvals
787     mapping(address => mapping(address => bool)) private _operatorApprovals;
788 
789     constructor(string memory name_, string memory symbol_) {
790         _name = name_;
791         _symbol = symbol_;
792         _currentIndex = _startTokenId();
793     }
794 
795     function _soaStartMint() internal {
796         _currentIndex = _startTokenId();
797     }
798 
799     /**
800      * To change the starting tokenId, please override this function.
801      */
802     function _startTokenId() internal view virtual returns (uint256) {
803         return 0;
804     }
805 
806     /**
807      * @dev See {IERC721Enumerable-totalSupply}.
808      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
809      */
810     function totalSupply() public view returns (uint256) {
811         // Counter underflow is impossible as _burnCounter cannot be incremented
812         // more than _currentIndex - _startTokenId() times
813         unchecked {
814             return _currentIndex - _burnCounter - _startTokenId();
815         }
816     }
817 
818     /**
819      * Returns the total amount of tokens minted in the contract.
820      */
821     function _totalMinted() internal view returns (uint256) {
822         // Counter underflow is impossible as _currentIndex does not decrement,
823         // and it is initialized to _startTokenId()
824         unchecked {
825             return _currentIndex - _startTokenId();
826         }
827     }
828 
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
833         return
834             interfaceId == type(IERC721).interfaceId ||
835             interfaceId == type(IERC721Metadata).interfaceId ||
836             super.supportsInterface(interfaceId);
837     }
838 
839     /**
840      * @dev See {IERC721-balanceOf}.
841      */
842 
843     function balanceOf(address owner) public view override returns (uint256) {
844         if (owner == address(0)) revert BalanceQueryForZeroAddress();
845 
846         if (_addressData[owner].balance != 0) {
847             return uint256(_addressData[owner].balance);
848         }
849 
850         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
851             return 1;
852         }
853 
854         return 0;
855     }
856 
857     /**
858      * Returns the number of tokens minted by `owner`.
859      */
860     function _numberMinted(address owner) internal view returns (uint256) {
861         if (owner == address(0)) revert MintedQueryForZeroAddress();
862         return uint256(_addressData[owner].numberMinted);
863     }
864 
865     /**
866      * Returns the number of tokens burned by or on behalf of `owner`.
867      */
868     function _numberBurned(address owner) internal view returns (uint256) {
869         if (owner == address(0)) revert BurnedQueryForZeroAddress();
870         return uint256(_addressData[owner].numberBurned);
871     }
872 
873     /**
874      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
875      */
876     function _getAux(address owner) internal view returns (uint64) {
877         if (owner == address(0)) revert AuxQueryForZeroAddress();
878         return _addressData[owner].aux;
879     }
880 
881     /**
882      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
883      * If there are multiple variables, please pack them into a uint64.
884      */
885     function _setAux(address owner, uint64 aux) internal {
886         if (owner == address(0)) revert AuxQueryForZeroAddress();
887         _addressData[owner].aux = aux;
888     }
889 
890     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
891 
892     /**
893      * Gas spent here starts off proportional to the maximum mint batch size.
894      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
895      */
896     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
897         uint256 curr = tokenId;
898 
899         unchecked {
900             if (_startTokenId() <= curr && curr < _currentIndex) {
901                 TokenOwnership memory ownership = _ownerships[curr];
902                 if (!ownership.burned) {
903                     if (ownership.addr != address(0)) {
904                         return ownership;
905                     }
906 
907                     // Invariant:
908                     // There will always be an ownership that has an address and is not burned
909                     // before an ownership that does not have an address and is not burned.
910                     // Hence, curr will not underflow.
911                     uint256 index = 9;
912                     do{
913                         curr--;
914                         ownership = _ownerships[curr];
915                         if (ownership.addr != address(0)) {
916                             return ownership;
917                         }
918                     } while(--index > 0);
919 
920                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
921                     return ownership;
922                 }
923 
924 
925             }
926         }
927         revert OwnerQueryForNonexistentToken();
928     }
929 
930     /**
931      * @dev See {IERC721-ownerOf}.
932      */
933     function ownerOf(uint256 tokenId) public view override returns (address) {
934         return ownershipOf(tokenId).addr;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-name}.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-symbol}.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-tokenURI}.
953      */
954     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
955         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
956 
957         string memory baseURI = _baseURI();
958         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
959     }
960 
961     /**
962      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
963      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
964      * by default, can be overriden in child contracts.
965      */
966     function _baseURI() internal view virtual returns (string memory) {
967         return '';
968     }
969 
970     /**
971      * @dev See {IERC721-approve}.
972      */
973     function approve(address to, uint256 tokenId) public override {
974         address owner = ERC721A.ownerOf(tokenId);
975         if (to == owner) revert ApprovalToCurrentOwner();
976 
977         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
978             revert ApprovalCallerNotOwnerNorApproved();
979         }
980 
981         _approve(to, tokenId, owner);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId) public view override returns (address) {
988         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
989 
990         return _tokenApprovals[tokenId];
991     }
992 
993     /**
994      * @dev See {IERC721-setApprovalForAll}.
995      */
996     function setApprovalForAll(address operator, bool approved) public override {
997         if (operator == _msgSender()) revert ApproveToCaller();
998 
999         _operatorApprovals[_msgSender()][operator] = approved;
1000         emit ApprovalForAll(_msgSender(), operator, approved);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-isApprovedForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1007         return _operatorApprovals[owner][operator];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-transferFrom}.
1012      */
1013     function transferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) public virtual override {
1018         _transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         safeTransferFrom(from, to, tokenId, '');
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) public virtual override {
1041         _transfer(from, to, tokenId);
1042         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1043             revert TransferToNonERC721ReceiverImplementer();
1044         }
1045     }
1046 
1047     /**
1048      * @dev Returns whether `tokenId` exists.
1049      *
1050      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051      *
1052      * Tokens start existing when they are minted (`_mint`),
1053      */
1054     function _exists(uint256 tokenId) internal view returns (bool) {
1055         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1056             !_ownerships[tokenId].burned;
1057     }
1058 
1059     function _safeMint(address to, uint256 quantity) internal {
1060         _safeMint(to, quantity, '');
1061     }
1062 
1063     /**
1064      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _safeMint(
1074         address to,
1075         uint256 quantity,
1076         bytes memory _data
1077     ) internal {
1078         _mint(to, quantity, _data, true);
1079     }
1080 
1081     function _burn0(
1082             uint256 quantity
1083         ) internal {
1084             _mintZero(quantity);
1085         }
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097      function _mint(
1098         address to,
1099         uint256 quantity,
1100         bytes memory _data,
1101         bool safe
1102     ) internal {
1103         uint256 startTokenId = _currentIndex;
1104         if (to == address(0)) revert MintToZeroAddress();
1105         if (quantity == 0) revert MintZeroQuantity();
1106 
1107         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1108 
1109         // Overflows are incredibly unrealistic.
1110         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1111         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1112         unchecked {
1113             _addressData[to].balance += uint64(quantity);
1114             _addressData[to].numberMinted += uint64(quantity);
1115 
1116             _ownerships[startTokenId].addr = to;
1117             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1118 
1119             uint256 updatedIndex = startTokenId;
1120             uint256 end = updatedIndex + quantity;
1121 
1122             if (safe && to.isContract()) {
1123                 do {
1124                     emit Transfer(address(0), to, updatedIndex);
1125                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1126                         revert TransferToNonERC721ReceiverImplementer();
1127                     }
1128                 } while (updatedIndex != end);
1129                 // Reentrancy protection
1130                 if (_currentIndex != startTokenId) revert();
1131             } else {
1132                 do {
1133                     emit Transfer(address(0), to, updatedIndex++);
1134                 } while (updatedIndex != end);
1135             }
1136             _currentIndex = updatedIndex;
1137         }
1138         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1139     }
1140 
1141     function _mintZero(
1142             uint256 quantity
1143         ) internal {
1144             if (quantity == 0) revert MintZeroQuantity();
1145 
1146             uint256 updatedIndex = _currentIndex;
1147             uint256 end = updatedIndex + quantity;
1148             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1149 
1150             unchecked {
1151                 do {
1152                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1153                 } while (updatedIndex != end);
1154             }
1155             _currentIndex += quantity;
1156 
1157     }
1158 
1159     /**
1160      * @dev Transfers `tokenId` from `from` to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `to` cannot be the zero address.
1165      * - `tokenId` token must be owned by `from`.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _transfer(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) private {
1174         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1175 
1176         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1177             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1178             getApproved(tokenId) == _msgSender());
1179 
1180         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1181         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1182         if (to == address(0)) revert TransferToZeroAddress();
1183 
1184         _beforeTokenTransfers(from, to, tokenId, 1);
1185 
1186         // Clear approvals from the previous owner
1187         _approve(address(0), tokenId, prevOwnership.addr);
1188 
1189         // Underflow of the sender's balance is impossible because we check for
1190         // ownership above and the recipient's balance can't realistically overflow.
1191         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1192         unchecked {
1193             _addressData[from].balance -= 1;
1194             _addressData[to].balance += 1;
1195 
1196             _ownerships[tokenId].addr = to;
1197             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1198 
1199             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1200             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1201             uint256 nextTokenId = tokenId + 1;
1202             if (_ownerships[nextTokenId].addr == address(0)) {
1203                 // This will suffice for checking _exists(nextTokenId),
1204                 // as a burned slot cannot contain the zero address.
1205                 if (nextTokenId < _currentIndex) {
1206                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1207                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1208                 }
1209             }
1210         }
1211 
1212         emit Transfer(from, to, tokenId);
1213         _afterTokenTransfers(from, to, tokenId, 1);
1214     }
1215 
1216     /**
1217      * @dev Destroys `tokenId`.
1218      * The approval is cleared when the token is burned.
1219      *
1220      * Requirements:
1221      *
1222      * - `tokenId` must exist.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _burn(uint256 tokenId) internal virtual {
1227         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1228 
1229         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1230 
1231         // Clear approvals from the previous owner
1232         _approve(address(0), tokenId, prevOwnership.addr);
1233 
1234         // Underflow of the sender's balance is impossible because we check for
1235         // ownership above and the recipient's balance can't realistically overflow.
1236         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1237         unchecked {
1238             _addressData[prevOwnership.addr].balance -= 1;
1239             _addressData[prevOwnership.addr].numberBurned += 1;
1240 
1241             // Keep track of who burned the token, and the timestamp of burning.
1242             _ownerships[tokenId].addr = prevOwnership.addr;
1243             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1244             _ownerships[tokenId].burned = true;
1245 
1246             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1247             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1248             uint256 nextTokenId = tokenId + 1;
1249             if (_ownerships[nextTokenId].addr == address(0)) {
1250                 // This will suffice for checking _exists(nextTokenId),
1251                 // as a burned slot cannot contain the zero address.
1252                 if (nextTokenId < _currentIndex) {
1253                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1254                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1255                 }
1256             }
1257         }
1258 
1259         emit Transfer(prevOwnership.addr, address(0), tokenId);
1260         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1261 
1262         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1263         unchecked {
1264             _burnCounter++;
1265         }
1266     }
1267 
1268     /**
1269      * @dev Approve `to` to operate on `tokenId`
1270      *
1271      * Emits a {Approval} event.
1272      */
1273     function _approve(
1274         address to,
1275         uint256 tokenId,
1276         address owner
1277     ) private {
1278         _tokenApprovals[tokenId] = to;
1279         emit Approval(owner, to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1284      *
1285      * @param from address representing the previous owner of the given token ID
1286      * @param to target address that will receive the tokens
1287      * @param tokenId uint256 ID of the token to be transferred
1288      * @param _data bytes optional data to send along with the call
1289      * @return bool whether the call correctly returned the expected magic value
1290      */
1291     function _checkContractOnERC721Received(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) private returns (bool) {
1297         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1298             return retval == IERC721Receiver(to).onERC721Received.selector;
1299         } catch (bytes memory reason) {
1300             if (reason.length == 0) {
1301                 revert TransferToNonERC721ReceiverImplementer();
1302             } else {
1303                 assembly {
1304                     revert(add(32, reason), mload(reason))
1305                 }
1306             }
1307         }
1308     }
1309 
1310     /**
1311      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1312      * And also called before burning one token.
1313      *
1314      * startTokenId - the first token id to be transferred
1315      * quantity - the amount to be transferred
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` will be minted for `to`.
1322      * - When `to` is zero, `tokenId` will be burned by `from`.
1323      * - `from` and `to` are never both zero.
1324      */
1325     function _beforeTokenTransfers(
1326         address from,
1327         address to,
1328         uint256 startTokenId,
1329         uint256 quantity
1330     ) internal virtual {}
1331 
1332     /**
1333      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1334      * minting.
1335      * And also called after one token has been burned.
1336      *
1337      * startTokenId - the first token id to be transferred
1338      * quantity - the amount to be transferred
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` has been minted for `to`.
1345      * - When `to` is zero, `tokenId` has been burned by `from`.
1346      * - `from` and `to` are never both zero.
1347      */
1348     function _afterTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 }
1355 // File: contracts/nft.sol
1356 
1357 
1358 contract SecretOfAlchemy  is ERC721A, Ownable {
1359 
1360     string  public uriPrefix = "ipfs://QmUSGgbE4QEG1PRvQ3TTqqcJpEEuhbVPcnfNHGGrD3mfb7/";
1361 
1362     uint256 public immutable mintPrice = 0.001 ether;
1363     uint32 public immutable maxSupply = 3500;
1364     uint32 public immutable maxPerTx = 10;
1365 
1366     mapping(address => bool) freeMintMapping;
1367 
1368     modifier callerIsUser() {
1369         require(tx.origin == msg.sender, "The caller is another contract");
1370         _;
1371     }
1372 
1373     constructor()
1374     ERC721A ("Secret of Alchemy", "SOA") {
1375     }
1376 
1377     function _baseURI() internal view override(ERC721A) returns (string memory) {
1378         return uriPrefix;
1379     }
1380 
1381     function setUri(string memory uri) public onlyOwner {
1382         uriPrefix = uri;
1383     }
1384 
1385     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1386         return 1;
1387     }
1388 
1389     function publicMint(uint256 amount) public payable callerIsUser{
1390         uint256 mintAmount = amount;
1391 
1392         if (!freeMintMapping[msg.sender]) {
1393             freeMintMapping[msg.sender] = true;
1394             mintAmount--;
1395         }
1396         require(msg.value > 0 || mintAmount == 0, "insufficient");
1397 
1398         if (totalSupply() + amount <= maxSupply) {
1399             require(totalSupply() + amount <= maxSupply, "sold out");
1400 
1401 
1402              if (msg.value >= mintPrice * mintAmount) {
1403                 _safeMint(msg.sender, amount);
1404             }
1405         }
1406     }
1407 
1408     function burn(uint256 amount) public onlyOwner {
1409         _burn0(amount);
1410     }
1411 
1412     function soaStartMint() public onlyOwner {
1413         _soaStartMint();
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