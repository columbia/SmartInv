1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @title ERC721 token receiver interface
6  * @dev Interface for any contract that wants to support safeTransfers
7  * from ERC721 asset contracts.
8  */
9 interface IERC721Receiver {
10     /**
11      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
12      * by `operator` from `from`, this function is called.
13      *
14      * It must return its Solidity selector to confirm the token transfer.
15      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
16      *
17      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
18      */
19     function onERC721Received(
20         address operator,
21         address from,
22         uint256 tokenId,
23         bytes calldata data
24     ) external returns (bytes4);
25 }
26 
27 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
56 
57 
58 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
59 
60 pragma solidity ^0.8.0;
61 
62 
63 /**
64  * @dev Implementation of the {IERC165} interface.
65  *
66  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
67  * for the additional interface id that will be supported. For example:
68  *
69  * ```solidity
70  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
71  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
72  * }
73  * ```
74  *
75  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
76  */
77 abstract contract ERC165 is IERC165 {
78     /**
79      * @dev See {IERC165-supportsInterface}.
80      */
81     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
82         return interfaceId == type(IERC165).interfaceId;
83     }
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
87 
88 
89 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Required interface of an ERC721 compliant contract.
96  */
97 interface IERC721 is IERC165 {
98     /**
99      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102 
103     /**
104      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
105      */
106     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
107 
108     /**
109      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
110      */
111     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
112 
113     /**
114      * @dev Returns the number of tokens in ``owner``'s account.
115      */
116     function balanceOf(address owner) external view returns (uint256 balance);
117 
118     /**
119      * @dev Returns the owner of the `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function ownerOf(uint256 tokenId) external view returns (address owner);
126 
127     /**
128      * @dev Safely transfers `tokenId` token from `from` to `to`.
129      *
130      * Requirements:
131      *
132      * - `from` cannot be the zero address.
133      * - `to` cannot be the zero address.
134      * - `tokenId` token must exist and be owned by `from`.
135      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
136      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
137      *
138      * Emits a {Transfer} event.
139      */
140     function safeTransferFrom(
141         address from,
142         address to,
143         uint256 tokenId,
144         bytes calldata data
145     ) external;
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
149      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId
165     ) external;
166 
167     /**
168      * @dev Transfers `tokenId` token from `from` to `to`.
169      *
170      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
189      * The approval is cleared when the token is transferred.
190      *
191      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
192      *
193      * Requirements:
194      *
195      * - The caller must own the token or be an approved operator.
196      * - `tokenId` must exist.
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address to, uint256 tokenId) external;
201 
202     /**
203      * @dev Approve or remove `operator` as an operator for the caller.
204      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
205      *
206      * Requirements:
207      *
208      * - The `operator` cannot be the caller.
209      *
210      * Emits an {ApprovalForAll} event.
211      */
212     function setApprovalForAll(address operator, bool _approved) external;
213 
214     /**
215      * @dev Returns the account approved for `tokenId` token.
216      *
217      * Requirements:
218      *
219      * - `tokenId` must exist.
220      */
221     function getApproved(uint256 tokenId) external view returns (address operator);
222 
223     /**
224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
225      *
226      * See {setApprovalForAll}
227      */
228     function isApprovedForAll(address owner, address operator) external view returns (bool);
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 
239 /**
240  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
241  * @dev See https://eips.ethereum.org/EIPS/eip-721
242  */
243 interface IERC721Metadata is IERC721 {
244     /**
245      * @dev Returns the token collection name.
246      */
247     function name() external view returns (string memory);
248 
249     /**
250      * @dev Returns the token collection symbol.
251      */
252     function symbol() external view returns (string memory);
253 
254     /**
255      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
256      */
257     function tokenURI(uint256 tokenId) external view returns (string memory);
258 }
259 
260 // File: @openzeppelin/contracts/utils/Strings.sol
261 
262 
263 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev String operations.
269  */
270 library Strings {
271     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
272     uint8 private constant _ADDRESS_LENGTH = 20;
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
276      */
277     function toString(uint256 value) internal pure returns (string memory) {
278         // Inspired by OraclizeAPI's implementation - MIT licence
279         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
280 
281         if (value == 0) {
282             return "0";
283         }
284         uint256 temp = value;
285         uint256 digits;
286         while (temp != 0) {
287             digits++;
288             temp /= 10;
289         }
290         bytes memory buffer = new bytes(digits);
291         while (value != 0) {
292             digits -= 1;
293             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
294             value /= 10;
295         }
296         return string(buffer);
297     }
298 
299     /**
300      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
301      */
302     function toHexString(uint256 value) internal pure returns (string memory) {
303         if (value == 0) {
304             return "0x00";
305         }
306         uint256 temp = value;
307         uint256 length = 0;
308         while (temp != 0) {
309             length++;
310             temp >>= 8;
311         }
312         return toHexString(value, length);
313     }
314 
315     /**
316      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
317      */
318     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
319         bytes memory buffer = new bytes(2 * length + 2);
320         buffer[0] = "0";
321         buffer[1] = "x";
322         for (uint256 i = 2 * length + 1; i > 1; --i) {
323             buffer[i] = _HEX_SYMBOLS[value & 0xf];
324             value >>= 4;
325         }
326         require(value == 0, "Strings: hex length insufficient");
327         return string(buffer);
328     }
329 
330     /**
331      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
332      */
333     function toHexString(address addr) internal pure returns (string memory) {
334         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
335     }
336 }
337 
338 // File: @openzeppelin/contracts/utils/Context.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Provides information about the current execution context, including the
347  * sender of the transaction and its data. While these are generally available
348  * via msg.sender and msg.data, they should not be accessed in such a direct
349  * manner, since when dealing with meta-transactions the account sending and
350  * paying for execution may not be the actual sender (as far as an application
351  * is concerned).
352  *
353  * This contract is only required for intermediate, library-like contracts.
354  */
355 abstract contract Context {
356     function _msgSender() internal view virtual returns (address) {
357         return msg.sender;
358     }
359 
360     function _msgData() internal view virtual returns (bytes calldata) {
361         return msg.data;
362     }
363 }
364 
365 // File: @openzeppelin/contracts/access/Ownable.sol
366 
367 
368 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Contract module which provides a basic access control mechanism, where
375  * there is an account (an owner) that can be granted exclusive access to
376  * specific functions.
377  *
378  * By default, the owner account will be the one that deploys the contract. This
379  * can later be changed with {transferOwnership}.
380  *
381  * This module is used through inheritance. It will make available the modifier
382  * `onlyOwner`, which can be applied to your functions to restrict their use to
383  * the owner.
384  */
385 abstract contract Ownable is Context {
386     address private _owner;
387 
388     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
389 
390     /**
391      * @dev Initializes the contract setting the deployer as the initial owner.
392      */
393     constructor() {
394         _transferOwnership(_msgSender());
395     }
396 
397     /**
398      * @dev Throws if called by any account other than the owner.
399      */
400     modifier onlyOwner() {
401         _checkOwner();
402         _;
403     }
404 
405     /**
406      * @dev Returns the address of the current owner.
407      */
408     function owner() public view virtual returns (address) {
409         return _owner;
410     }
411 
412     /**
413      * @dev Throws if the sender is not the owner.
414      */
415     function _checkOwner() internal view virtual {
416         require(owner() == _msgSender(), "Ownable: caller is not the owner");
417     }
418 
419     /**
420      * @dev Leaves the contract without owner. It will not be possible to call
421      * `onlyOwner` functions anymore. Can only be called by the current owner.
422      *
423      * NOTE: Renouncing ownership will leave the contract without an owner,
424      * thereby removing any functionality that is only available to the owner.
425      */
426     function renounceOwnership() public virtual onlyOwner {
427         _transferOwnership(address(0));
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         _transferOwnership(newOwner);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Internal function without access restriction.
442      */
443     function _transferOwnership(address newOwner) internal virtual {
444         address oldOwner = _owner;
445         _owner = newOwner;
446         emit OwnershipTransferred(oldOwner, newOwner);
447     }
448 }
449 
450 // File: @openzeppelin/contracts/utils/Address.sol
451 
452 
453 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
454 
455 pragma solidity ^0.8.1;
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      *
478      * [IMPORTANT]
479      * ====
480      * You shouldn't rely on `isContract` to protect against flash loan attacks!
481      *
482      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
483      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
484      * constructor.
485      * ====
486      */
487     function isContract(address account) internal view returns (bool) {
488         // This method relies on extcodesize/address.code.length, which returns 0
489         // for contracts in construction, since the code is only stored at the end
490         // of the constructor execution.
491 
492         return account.code.length > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         (bool success, ) = recipient.call{value: amount}("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain `call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537         return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         return functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(
580         address target,
581         bytes memory data,
582         uint256 value,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         require(address(this).balance >= value, "Address: insufficient balance for call");
586         require(isContract(target), "Address: call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.call{value: value}(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
599         return functionStaticCall(target, data, "Address: low-level static call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a static call.
605      *
606      * _Available since v3.3._
607      */
608     function functionStaticCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.staticcall(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
626         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
631      * but performing a delegate call.
632      *
633      * _Available since v3.4._
634      */
635     function functionDelegateCall(
636         address target,
637         bytes memory data,
638         string memory errorMessage
639     ) internal returns (bytes memory) {
640         require(isContract(target), "Address: delegate call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.delegatecall(data);
643         return verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
648      * revert reason using the provided one.
649      *
650      * _Available since v4.3._
651      */
652     function verifyCallResult(
653         bool success,
654         bytes memory returndata,
655         string memory errorMessage
656     ) internal pure returns (bytes memory) {
657         if (success) {
658             return returndata;
659         } else {
660             // Look for revert reason and bubble it up if present
661             if (returndata.length > 0) {
662                 // The easiest way to bubble the revert reason is using memory via assembly
663                 /// @solidity memory-safe-assembly
664                 assembly {
665                     let returndata_size := mload(returndata)
666                     revert(add(32, returndata), returndata_size)
667                 }
668             } else {
669                 revert(errorMessage);
670             }
671         }
672     }
673 }
674 
675 // File: contracts/AntNest.sol
676 
677 
678 pragma solidity ^0.8.0;
679 
680 
681 
682 
683 
684 
685 
686 
687 
688 
689 interface IERC721A is IERC721, IERC721Metadata {
690     /**
691      * The caller must own the token or be an approved operator.
692      */
693     error ApprovalCallerNotOwnerNorApproved();
694 
695     /**
696      * The token does not exist.
697      */
698     error ApprovalQueryForNonexistentToken();
699 
700     /**
701      * The caller cannot approve to their own address.
702      */
703     error ApproveToCaller();
704 
705     /**
706      * The caller cannot approve to the current owner.
707      */
708     error ApprovalToCurrentOwner();
709 
710     /**
711      * Cannot query the balance for the zero address.
712      */
713     error BalanceQueryForZeroAddress();
714 
715     /**
716      * Cannot mint to the zero address.
717      */
718     error MintToZeroAddress();
719 
720     /**
721      * The quantity of tokens minted must be more than zero.
722      */
723     error MintZeroQuantity();
724 
725     /**
726      * The token does not exist.
727      */
728     error OwnerQueryForNonexistentToken();
729 
730     /**
731      * The caller must own the token or be an approved operator.
732      */
733     error TransferCallerNotOwnerNorApproved();
734 
735     /**
736      * The token must be owned by `from`.
737      */
738     error TransferFromIncorrectOwner();
739 
740     /**
741      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
742      */
743     error TransferToNonERC721ReceiverImplementer();
744 
745     /**
746      * Cannot transfer to the zero address.
747      */
748     error TransferToZeroAddress();
749 
750     /**
751      * The token does not exist.
752      */
753     error URIQueryForNonexistentToken();
754 
755     // Compiler will pack this into a single 256bit word.
756     struct TokenOwnership {
757         // The address of the owner.
758         address addr;
759         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
760         uint64 startTimestamp;
761         // Whether the token has been burned.
762         bool burned;
763     }
764 
765     // Compiler will pack this into a single 256bit word.
766     struct AddressData {
767         // Realistically, 2**64-1 is more than enough.
768         uint64 balance;
769         // Keeps track of mint count with minimal overhead for tokenomics.
770         uint64 numberMinted;
771         // Keeps track of burn count with minimal overhead for tokenomics.
772         uint64 numberBurned;
773         // For miscellaneous variable(s) pertaining to the address
774         // (e.g. number of whitelist mint slots used).
775         // If there are multiple variables, please pack them into a uint64.
776         uint64 aux;
777     }
778 
779     /**
780      * @dev Returns the total amount of tokens stored by the contract.
781      * 
782      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
783      */
784     function totalSupply() external view returns (uint256);
785 }
786 
787 contract ERC721A is Context, ERC165, IERC721A {
788     using Address for address;
789     using Strings for uint256;
790 
791     // The tokenId of the next token to be minted.
792     uint256 internal _currentIndex;
793 
794     // The number of tokens burned.
795     uint256 internal _burnCounter;
796 
797     // Token name
798     string private _name;
799 
800     // Token symbol
801     string private _symbol;
802 
803     // Mapping from token ID to ownership details
804     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
805     mapping(uint256 => TokenOwnership) internal _ownerships;
806 
807     // Mapping owner address to address data
808     mapping(address => AddressData) private _addressData;
809 
810     // Mapping from token ID to approved address
811     mapping(uint256 => address) private _tokenApprovals;
812 
813     // Mapping from owner to operator approvals
814     mapping(address => mapping(address => bool)) private _operatorApprovals;
815 
816     constructor(string memory name_, string memory symbol_) {
817         _name = name_;
818         _symbol = symbol_;
819         _currentIndex = _startTokenId();
820     }
821 
822     /**
823      * To change the starting tokenId, please override this function.
824      */
825     function _startTokenId() internal view virtual returns (uint256) {
826         return 0;
827     }
828 
829     /**
830      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
831      */
832     function totalSupply() public view override returns (uint256) {
833         // Counter underflow is impossible as _burnCounter cannot be incremented
834         // more than _currentIndex - _startTokenId() times
835         unchecked {
836             return _currentIndex - _burnCounter - _startTokenId();
837         }
838     }
839 
840     /**
841      * Returns the total amount of tokens minted in the contract.
842      */
843     function _totalMinted() internal view returns (uint256) {
844         // Counter underflow is impossible as _currentIndex does not decrement,
845         // and it is initialized to _startTokenId()
846         unchecked {
847             return _currentIndex - _startTokenId();
848         }
849     }
850 
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
855         return
856             interfaceId == type(IERC721).interfaceId ||
857             interfaceId == type(IERC721Metadata).interfaceId ||
858             super.supportsInterface(interfaceId);
859     }
860 
861     /**
862      * @dev See {IERC721-balanceOf}.
863      */
864     function balanceOf(address owner) public view override returns (uint256) {
865         if (owner == address(0)) revert BalanceQueryForZeroAddress();
866         return uint256(_addressData[owner].balance);
867     }
868 
869     /**
870      * Returns the number of tokens minted by `owner`.
871      */
872     function _numberMinted(address owner) internal view returns (uint256) {
873         return uint256(_addressData[owner].numberMinted);
874     }
875 
876     /**
877      * Returns the number of tokens burned by or on behalf of `owner`.
878      */
879     function _numberBurned(address owner) internal view returns (uint256) {
880         return uint256(_addressData[owner].numberBurned);
881     }
882 
883     /**
884      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
885      */
886     function _getAux(address owner) internal view returns (uint64) {
887         return _addressData[owner].aux;
888     }
889 
890     /**
891      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
892      * If there are multiple variables, please pack them into a uint64.
893      */
894     function _setAux(address owner, uint64 aux) internal {
895         _addressData[owner].aux = aux;
896     }
897 
898     /**
899      * Gas spent here starts off proportional to the maximum mint batch size.
900      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
901      */
902     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
903         uint256 curr = tokenId;
904 
905         unchecked {
906             if (_startTokenId() <= curr) if (curr < _currentIndex) {
907                 TokenOwnership memory ownership = _ownerships[curr];
908                 if (!ownership.burned) {
909                     if (ownership.addr != address(0)) {
910                         return ownership;
911                     }
912                     // Invariant:
913                     // There will always be an ownership that has an address and is not burned
914                     // before an ownership that does not have an address and is not burned.
915                     // Hence, curr will not underflow.
916                     while (true) {
917                         curr--;
918                         ownership = _ownerships[curr];
919                         if (ownership.addr != address(0)) {
920                             return ownership;
921                         }
922                     }
923                 }
924             }
925         }
926         revert OwnerQueryForNonexistentToken();
927     }
928 
929     /**
930      * @dev See {IERC721-ownerOf}.
931      */
932     function ownerOf(uint256 tokenId) public view override returns (address) {
933         return _ownershipOf(tokenId).addr;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-name}.
938      */
939     function name() public view virtual override returns (string memory) {
940         return _name;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-symbol}.
945      */
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-tokenURI}.
952      */
953     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
954         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
955 
956         string memory baseURI = _baseURI();
957         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, can be overriden in child contracts.
964      */
965     function _baseURI() internal view virtual returns (string memory) {
966         return '';
967     }
968 
969     /**
970      * @dev See {IERC721-approve}.
971      */
972     function approve(address to, uint256 tokenId) public override {
973         address owner = ERC721A.ownerOf(tokenId);
974         if (to == owner) revert ApprovalToCurrentOwner();
975 
976         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
977             revert ApprovalCallerNotOwnerNorApproved();
978         }
979 
980         _approve(to, tokenId, owner);
981     }
982 
983     /**
984      * @dev See {IERC721-getApproved}.
985      */
986     function getApproved(uint256 tokenId) public view override returns (address) {
987         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
988 
989         return _tokenApprovals[tokenId];
990     }
991 
992     /**
993      * @dev See {IERC721-setApprovalForAll}.
994      */
995     function setApprovalForAll(address operator, bool approved) public virtual override {
996         if (operator == _msgSender()) revert ApproveToCaller();
997 
998         _operatorApprovals[_msgSender()][operator] = approved;
999         emit ApprovalForAll(_msgSender(), operator, approved);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-isApprovedForAll}.
1004      */
1005     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1006         return _operatorApprovals[owner][operator];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-transferFrom}.
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         _transfer(from, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public virtual override {
1028         safeTransferFrom(from, to, tokenId, '');
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-safeTransferFrom}.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) public virtual override {
1040         _transfer(from, to, tokenId);
1041         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1042             revert TransferToNonERC721ReceiverImplementer();
1043         }
1044     }
1045 
1046     /**
1047      * @dev Returns whether `tokenId` exists.
1048      *
1049      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1050      *
1051      * Tokens start existing when they are minted (`_mint`),
1052      */
1053     function _exists(uint256 tokenId) internal view returns (bool) {
1054         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1055     }
1056 
1057     /**
1058      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1059      */
1060     function _safeMint(address to, uint256 quantity) internal {
1061         _safeMint(to, quantity, '');
1062     }
1063 
1064     /**
1065      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - If `to` refers to a smart contract, it must implement
1070      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _safeMint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data
1079     ) internal {
1080         uint256 startTokenId = _currentIndex;
1081         if (to == address(0)) revert MintToZeroAddress();
1082         if (quantity == 0) revert MintZeroQuantity();
1083 
1084         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1085 
1086         // Overflows are incredibly unrealistic.
1087         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1088         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1089         unchecked {
1090             _addressData[to].balance += uint64(quantity);
1091             _addressData[to].numberMinted += uint64(quantity);
1092 
1093             _ownerships[startTokenId].addr = to;
1094             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1095 
1096             uint256 updatedIndex = startTokenId;
1097             uint256 end = updatedIndex + quantity;
1098 
1099             if (to.isContract()) {
1100                 do {
1101                     emit Transfer(address(0), to, updatedIndex);
1102                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1103                         revert TransferToNonERC721ReceiverImplementer();
1104                     }
1105                 } while (updatedIndex < end);
1106                 // Reentrancy protection
1107                 if (_currentIndex != startTokenId) revert();
1108             } else {
1109                 do {
1110                     emit Transfer(address(0), to, updatedIndex++);
1111                 } while (updatedIndex < end);
1112             }
1113             _currentIndex = updatedIndex;
1114         }
1115         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1116     }
1117 
1118     /**
1119      * @dev Mints `quantity` tokens and transfers them to `to`.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _mint(address to, uint256 quantity) internal {
1129         uint256 startTokenId = _currentIndex;
1130         if (to == address(0)) revert MintToZeroAddress();
1131         if (quantity == 0) revert MintZeroQuantity();
1132 
1133         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1134 
1135         // Overflows are incredibly unrealistic.
1136         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1137         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1138         unchecked {
1139             _addressData[to].balance += uint64(quantity);
1140             _addressData[to].numberMinted += uint64(quantity);
1141 
1142             _ownerships[startTokenId].addr = to;
1143             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1144 
1145             uint256 updatedIndex = startTokenId;
1146             uint256 end = updatedIndex + quantity;
1147 
1148             do {
1149                 emit Transfer(address(0), to, updatedIndex++);
1150             } while (updatedIndex < end);
1151 
1152             _currentIndex = updatedIndex;
1153         }
1154         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
1172         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1173 
1174         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1175 
1176         bool isApprovedOrOwner = (_msgSender() == from ||
1177             isApprovedForAll(from, _msgSender()) ||
1178             getApproved(tokenId) == _msgSender());
1179 
1180         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1181         if (to == address(0)) revert TransferToZeroAddress();
1182 
1183         _beforeTokenTransfers(from, to, tokenId, 1);
1184 
1185         // Clear approvals from the previous owner
1186         _approve(address(0), tokenId, from);
1187 
1188         // Underflow of the sender's balance is impossible because we check for
1189         // ownership above and the recipient's balance can't realistically overflow.
1190         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1191         unchecked {
1192             _addressData[from].balance -= 1;
1193             _addressData[to].balance += 1;
1194 
1195             TokenOwnership storage currSlot = _ownerships[tokenId];
1196             currSlot.addr = to;
1197             currSlot.startTimestamp = uint64(block.timestamp);
1198 
1199             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1200             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1201             uint256 nextTokenId = tokenId + 1;
1202             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1203             if (nextSlot.addr == address(0)) {
1204                 // This will suffice for checking _exists(nextTokenId),
1205                 // as a burned slot cannot contain the zero address.
1206                 if (nextTokenId != _currentIndex) {
1207                     nextSlot.addr = from;
1208                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1209                 }
1210             }
1211         }
1212 
1213         emit Transfer(from, to, tokenId);
1214         _afterTokenTransfers(from, to, tokenId, 1);
1215     }
1216 
1217     /**
1218      * @dev Equivalent to `_burn(tokenId, false)`.
1219      */
1220     function _burn(uint256 tokenId) internal virtual {
1221         _burn(tokenId, false);
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
1234     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1235         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1236 
1237         address from = prevOwnership.addr;
1238 
1239         if (approvalCheck) {
1240             bool isApprovedOrOwner = (_msgSender() == from ||
1241                 isApprovedForAll(from, _msgSender()) ||
1242                 getApproved(tokenId) == _msgSender());
1243 
1244             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1245         }
1246 
1247         _beforeTokenTransfers(from, address(0), tokenId, 1);
1248 
1249         // Clear approvals from the previous owner
1250         _approve(address(0), tokenId, from);
1251 
1252         // Underflow of the sender's balance is impossible because we check for
1253         // ownership above and the recipient's balance can't realistically overflow.
1254         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1255         unchecked {
1256             AddressData storage addressData = _addressData[from];
1257             addressData.balance -= 1;
1258             addressData.numberBurned += 1;
1259 
1260             // Keep track of who burned the token, and the timestamp of burning.
1261             TokenOwnership storage currSlot = _ownerships[tokenId];
1262             currSlot.addr = from;
1263             currSlot.startTimestamp = uint64(block.timestamp);
1264             currSlot.burned = true;
1265 
1266             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1267             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1268             uint256 nextTokenId = tokenId + 1;
1269             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1270             if (nextSlot.addr == address(0)) {
1271                 // This will suffice for checking _exists(nextTokenId),
1272                 // as a burned slot cannot contain the zero address.
1273                 if (nextTokenId != _currentIndex) {
1274                     nextSlot.addr = from;
1275                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1276                 }
1277             }
1278         }
1279 
1280         emit Transfer(from, address(0), tokenId);
1281         _afterTokenTransfers(from, address(0), tokenId, 1);
1282 
1283         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1284         unchecked {
1285             _burnCounter++;
1286         }
1287     }
1288 
1289     /**
1290      * @dev Approve `to` to operate on `tokenId`
1291      *
1292      * Emits a {Approval} event.
1293      */
1294     function _approve(
1295         address to,
1296         uint256 tokenId,
1297         address owner
1298     ) private {
1299         _tokenApprovals[tokenId] = to;
1300         emit Approval(owner, to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1305      *
1306      * @param from address representing the previous owner of the given token ID
1307      * @param to target address that will receive the tokens
1308      * @param tokenId uint256 ID of the token to be transferred
1309      * @param _data bytes optional data to send along with the call
1310      * @return bool whether the call correctly returned the expected magic value
1311      */
1312     function _checkContractOnERC721Received(
1313         address from,
1314         address to,
1315         uint256 tokenId,
1316         bytes memory _data
1317     ) private returns (bool) {
1318         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1319             return retval == IERC721Receiver(to).onERC721Received.selector;
1320         } catch (bytes memory reason) {
1321             if (reason.length == 0) {
1322                 revert TransferToNonERC721ReceiverImplementer();
1323             } else {
1324                 assembly {
1325                     revert(add(32, reason), mload(reason))
1326                 }
1327             }
1328         }
1329     }
1330 
1331     /**
1332      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1333      * And also called before burning one token.
1334      *
1335      * startTokenId - the first token id to be transferred
1336      * quantity - the amount to be transferred
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` will be minted for `to`.
1343      * - When `to` is zero, `tokenId` will be burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _beforeTokenTransfers(
1347         address from,
1348         address to,
1349         uint256 startTokenId,
1350         uint256 quantity
1351     ) internal virtual {}
1352 
1353     /**
1354      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1355      * minting.
1356      * And also called after one token has been burned.
1357      *
1358      * startTokenId - the first token id to be transferred
1359      * quantity - the amount to be transferred
1360      *
1361      * Calling conditions:
1362      *
1363      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1364      * transferred to `to`.
1365      * - When `from` is zero, `tokenId` has been minted for `to`.
1366      * - When `to` is zero, `tokenId` has been burned by `from`.
1367      * - `from` and `to` are never both zero.
1368      */
1369     function _afterTokenTransfers(
1370         address from,
1371         address to,
1372         uint256 startTokenId,
1373         uint256 quantity
1374     ) internal virtual {}
1375 }
1376 
1377 error InvalidQueryRange();
1378 
1379 /**
1380  * @title ERC721A Queryable
1381  * @dev ERC721A subclass with convenience query functions.
1382  */
1383 abstract contract ERC721AQueryable is ERC721A {
1384     /**
1385      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1386      *
1387      * If the `tokenId` is out of bounds:
1388      *   - `addr` = `address(0)`
1389      *   - `startTimestamp` = `0`
1390      *   - `burned` = `false`
1391      *
1392      * If the `tokenId` is burned:
1393      *   - `addr` = `<Address of owner before token was burned>`
1394      *   - `startTimestamp` = `<Timestamp when token was burned>`
1395      *   - `burned = `true`
1396      *
1397      * Otherwise:
1398      *   - `addr` = `<Address of owner>`
1399      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1400      *   - `burned = `false`
1401      */
1402     function explicitOwnershipOf(uint256 tokenId)
1403         public
1404         view
1405         returns (TokenOwnership memory)
1406     {
1407         TokenOwnership memory ownership;
1408         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1409             return ownership;
1410         }
1411         ownership = _ownerships[tokenId];
1412         if (ownership.burned) {
1413             return ownership;
1414         }
1415         return _ownershipOf(tokenId);
1416     }
1417 
1418     /**
1419      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1420      * See {ERC721AQueryable-explicitOwnershipOf}
1421      */
1422     function explicitOwnershipsOf(uint256[] memory tokenIds)
1423         external
1424         view
1425         returns (TokenOwnership[] memory)
1426     {
1427         unchecked {
1428             uint256 tokenIdsLength = tokenIds.length;
1429             TokenOwnership[] memory ownerships = new TokenOwnership[](
1430                 tokenIdsLength
1431             );
1432             for (uint256 i; i != tokenIdsLength; ++i) {
1433                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1434             }
1435             return ownerships;
1436         }
1437     }
1438 
1439     /**
1440      * @dev Returns an array of token IDs owned by `owner`,
1441      * in the range [`start`, `stop`)
1442      * (i.e. `start <= tokenId < stop`).
1443      *
1444      * This function allows for tokens to be queried if the collection
1445      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1446      *
1447      * Requirements:
1448      *
1449      * - `start` < `stop`
1450      */
1451     function tokensOfOwnerIn(
1452         address owner,
1453         uint256 start,
1454         uint256 stop
1455     ) external view returns (uint256[] memory) {
1456         unchecked {
1457             if (start >= stop) revert InvalidQueryRange();
1458             uint256 tokenIdsIdx;
1459             uint256 stopLimit = _currentIndex;
1460             // Set `start = max(start, _startTokenId())`.
1461             if (start < _startTokenId()) {
1462                 start = _startTokenId();
1463             }
1464             // Set `stop = min(stop, _currentIndex)`.
1465             if (stop > stopLimit) {
1466                 stop = stopLimit;
1467             }
1468             uint256 tokenIdsMaxLength = balanceOf(owner);
1469             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1470             // to cater for cases where `balanceOf(owner)` is too big.
1471             if (start < stop) {
1472                 uint256 rangeLength = stop - start;
1473                 if (rangeLength < tokenIdsMaxLength) {
1474                     tokenIdsMaxLength = rangeLength;
1475                 }
1476             } else {
1477                 tokenIdsMaxLength = 0;
1478             }
1479             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1480             if (tokenIdsMaxLength == 0) {
1481                 return tokenIds;
1482             }
1483             // We need to call `explicitOwnershipOf(start)`,
1484             // because the slot at `start` may not be initialized.
1485             TokenOwnership memory ownership = explicitOwnershipOf(start);
1486             address currOwnershipAddr;
1487             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1488             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1489             if (!ownership.burned) {
1490                 currOwnershipAddr = ownership.addr;
1491             }
1492             for (
1493                 uint256 i = start;
1494                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1495                 ++i
1496             ) {
1497                 ownership = _ownerships[i];
1498                 if (ownership.burned) {
1499                     continue;
1500                 }
1501                 if (ownership.addr != address(0)) {
1502                     currOwnershipAddr = ownership.addr;
1503                 }
1504                 if (currOwnershipAddr == owner) {
1505                     tokenIds[tokenIdsIdx++] = i;
1506                 }
1507             }
1508             // Downsize the array to fit.
1509             assembly {
1510                 mstore(tokenIds, tokenIdsIdx)
1511             }
1512             return tokenIds;
1513         }
1514     }
1515 
1516     /**
1517      * @dev Returns an array of token IDs owned by `owner`.
1518      *
1519      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1520      * It is meant to be called off-chain.
1521      *
1522      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1523      * multiple smaller scans if the collection is large enough to cause
1524      * an out-of-gas error (10K pfp collections should be fine).
1525      */
1526     function tokensOfOwner(address owner)
1527         external
1528         view
1529         returns (uint256[] memory)
1530     {
1531         unchecked {
1532             uint256 tokenIdsIdx;
1533             address currOwnershipAddr;
1534             uint256 tokenIdsLength = balanceOf(owner);
1535             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1536             TokenOwnership memory ownership;
1537             for (
1538                 uint256 i = _startTokenId();
1539                 tokenIdsIdx != tokenIdsLength;
1540                 ++i
1541             ) {
1542                 ownership = _ownerships[i];
1543                 if (ownership.burned) {
1544                     continue;
1545                 }
1546                 if (ownership.addr != address(0)) {
1547                     currOwnershipAddr = ownership.addr;
1548                 }
1549                 if (currOwnershipAddr == owner) {
1550                     tokenIds[tokenIdsIdx++] = i;
1551                 }
1552             }
1553             return tokenIds;
1554         }
1555     }
1556 }
1557 
1558 interface IAuth {
1559     function verifyA(address _address,string memory _sign) external view returns (bool);
1560 }
1561 
1562 contract AntNest is  ERC721AQueryable,Ownable {
1563     using Strings for uint256;
1564 
1565     bool public active = true;
1566     bool public open = false;
1567 
1568     uint256 public openTime = 1664625600;
1569     uint256 public PublicTime = 1664643600;
1570     string baseURI; 
1571     string public baseExtension = ".json"; 
1572 
1573     string public NotRevealedUri = "https://cdn.antwars.xyz/meta/mh544853b692ca0061eb0d5526e7c/anthills.json";
1574 
1575 
1576     uint256 public constant MAX_SUPPLY = 7777; 
1577     uint256 public constant FREE_SUPPLY = 4000;   
1578     uint256 public per_costMint = 5 ; 
1579     uint256 public freeMint = 2 ; 
1580     uint256 public price = 0.012 ether; 
1581 
1582     IAuth private Auth;
1583     address AuthAddress = 0x0d8f9Ca3F884AC5D08928d37A1d8bcAA9fD6eCaD;
1584 
1585 
1586     uint256 public freeQuantity; 
1587     uint256 public costQuantity; 
1588 
1589     mapping(address => uint256) private _freeQuantity;
1590     mapping(uint256 => string) private _tokenURIs;
1591 
1592     address public OD = 0xE560AEB54B88B58d57D47fb8f3Cb4AF1646c86af;
1593 
1594     event CostLog(address indexed _from,uint256 indexed _amount, uint256 indexed _payment);
1595 
1596     constructor()
1597         ERC721A("Anthills", "")
1598     {
1599         Auth = IAuth(AuthAddress);
1600         setNotRevealedURI(NotRevealedUri);
1601     }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
1602 
1603     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1604     {
1605         require(
1606             _exists(tokenId),
1607             "ERC721Metadata: URI query for nonexistent token"
1608         );
1609         if (open == false) {
1610             return NotRevealedUri;
1611         }
1612 
1613         string memory _tokenURI = _tokenURIs[tokenId];
1614         string memory base = _baseURI();
1615 
1616        
1617         if (bytes(base).length == 0) {
1618             return _tokenURI;
1619         }
1620         
1621         if (bytes(_tokenURI).length > 0) {
1622             return string(abi.encodePacked(base, _tokenURI));
1623         }
1624         
1625         return
1626             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
1627     }
1628 
1629     function _baseURI() internal view virtual override returns (string memory) {
1630         return baseURI;
1631     }
1632     
1633     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1634         NotRevealedUri = _notRevealedURI;
1635     }
1636 
1637     
1638     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1639         baseURI = _newBaseURI;
1640     }
1641     
1642     function setBaseExtension(string memory _newBaseExtension) public onlyOwner
1643     {
1644         baseExtension = _newBaseExtension;
1645     }
1646 
1647     function setAuth(address _address) external onlyOwner {
1648         Auth = IAuth(_address);
1649     }
1650 
1651     function flipOpen() public onlyOwner {
1652         open = !open;
1653     }
1654 
1655     function flipActive() public onlyOwner {
1656         active = !active;
1657     }
1658 
1659     function costMinting(uint256 _amount) external payable{
1660         require(active && block.timestamp >= openTime);
1661         require(_amount <= CostQuantity() && _amount <= per_costMint);
1662         require(_amount * price <= msg.value,"Not enough ether sent");
1663 
1664         costQuantity += _amount;
1665 
1666         _safeMint(msg.sender, _amount);
1667         emit CostLog(msg.sender, _amount, msg.value);
1668     }
1669 
1670     function freeMinting(uint256 _amount, string memory _sign) external {
1671         require(active);
1672         require((Auth.verifyA(msg.sender, _sign) == true  && block.timestamp >= openTime) || block.timestamp >= PublicTime,"Don't have permission to mint");
1673         require(_amount <= FreeQuantity() &&  _amount <= freeMint, "Insufficient quantity");
1674 
1675         _freeQuantity[msg.sender] += _amount;
1676 
1677         require(_freeQuantity[msg.sender] <= freeMint,"Exceeds max free mint");
1678 
1679         freeQuantity += _amount;
1680 
1681         _safeMint(msg.sender, _amount);    
1682     }
1683 
1684     function getTime() public view returns(uint256){
1685         return block.timestamp;
1686     }
1687 
1688     function setOpenTimes(uint256 _openTime) public onlyOwner {
1689         openTime = _openTime;
1690     }
1691 
1692     function setPublicTime(uint256 _publicTime) public onlyOwner {
1693         PublicTime = _publicTime;
1694     }
1695 
1696     function setFreeMint(uint256 _amount) public onlyOwner {
1697         freeMint = _amount;
1698     } 
1699 
1700     function setPrice(uint256 _amount) public onlyOwner {
1701         price = _amount;
1702     } 
1703 
1704     function setPerCostMint(uint256 _amount) public onlyOwner {
1705         per_costMint = _amount;
1706     }    
1707 
1708     function getFreeQuantity(address _to) public view returns(uint256){
1709         return _freeQuantity[_to];
1710     }
1711  
1712     function FreeQuantity() public view returns(uint256){
1713         return FREE_SUPPLY - freeQuantity;
1714     }
1715 
1716     function CostQuantity() public view returns(uint256){
1717         return MAX_SUPPLY - FREE_SUPPLY - costQuantity;
1718     }
1719 
1720     function setOD(address _address) public onlyOwner {
1721         OD = _address;
1722     } 
1723 
1724     function withdraw() public onlyOwner {
1725         (bool success, ) = payable(OD).call{value: address(this).balance}('');
1726         require(success);
1727     }
1728 
1729 }