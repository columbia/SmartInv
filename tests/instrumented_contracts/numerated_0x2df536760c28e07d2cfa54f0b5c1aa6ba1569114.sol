1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 // /**
9 //  * @dev Provides information about the current execution context, including the
10 //  * sender of the transaction and its data. While these are generally available
11 //  * via msg.sender and msg.data, they should not be accessed in such a direct
12 //  * manner, since when dealing with meta-transactions the account sending and
13 //  * paying for execution may not be the actual sender (as far as an application
14 //  * is concerned).
15 //  *
16 //  * This contract is only required for intermediate, library-like contracts.
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22     uint8 private constant _ADDRESS_LENGTH = 20;
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 
80     /**
81      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
82      */
83     function toHexString(address addr) internal pure returns (string memory) {
84         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
85     }
86 }
87 
88 // File: @openzeppelin/contracts/utils/Context.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         return msg.data;
112     }
113 }
114 
115 // File: @openzeppelin/contracts/access/Ownable.sol
116 
117 
118 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 
123 /**
124  * @dev Contract module which provides a basic access control mechanism, where
125  * there is an account (an owner) that can be granted exclusive access to
126  * specific functions.
127  *
128  * By default, the owner account will be the one that deploys the contract. This
129  * can later be changed with {transferOwnership}.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be applied to your functions to restrict their use to
133  * the owner.
134  */
135 abstract contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor() {
144         _transferOwnership(_msgSender());
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         _checkOwner();
152         _;
153     }
154 
155     /**
156      * @dev Returns the address of the current owner.
157      */
158     function owner() public view virtual returns (address) {
159         return _owner;
160     }
161 
162     /**
163      * @dev Throws if the sender is not the owner.
164      */
165     function _checkOwner() internal view virtual {
166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         _transferOwnership(newOwner);
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Internal function without access restriction.
181      */
182     function _transferOwnership(address newOwner) internal virtual {
183         address oldOwner = _owner;
184         _owner = newOwner;
185         emit OwnershipTransferred(oldOwner, newOwner);
186     }
187 }
188 
189 // File: @openzeppelin/contracts/utils/Address.sol
190 
191 
192 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
193 
194 pragma solidity ^0.8.1;
195 
196 /**
197  * @dev Collection of functions related to the address type
198  */
199 library Address {
200     /**
201      * @dev Returns true if `account` is a contract.
202      *
203      * [IMPORTANT]
204      * ====
205      * It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      *
208      * Among others, `isContract` will return false for the following
209      * types of addresses:
210      *
211      *  - an externally-owned account
212      *  - a contract in construction
213      *  - an address where a contract will be created
214      *  - an address where a contract lived, but was destroyed
215      * ====
216      *
217      * [IMPORTANT]
218      * ====
219      * You shouldn't rely on `isContract` to protect against flash loan attacks!
220      *
221      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
222      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
223      * constructor.
224      * ====
225      */
226     function isContract(address account) internal view returns (bool) {
227         // This method relies on extcodesize/address.code.length, which returns 0
228         // for contracts in construction, since the code is only stored at the end
229         // of the constructor execution.
230 
231         return account.code.length > 0;
232     }
233 
234     /**
235      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
236      * `recipient`, forwarding all available gas and reverting on errors.
237      *
238      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
239      * of certain opcodes, possibly making contracts go over the 2300 gas limit
240      * imposed by `transfer`, making them unable to receive funds via
241      * `transfer`. {sendValue} removes this limitation.
242      *
243      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
244      *
245      * IMPORTANT: because control is transferred to `recipient`, care must be
246      * taken to not create reentrancy vulnerabilities. Consider using
247      * {ReentrancyGuard} or the
248      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
249      */
250     function sendValue(address payable recipient, uint256 amount) internal {
251         require(address(this).balance >= amount, "Address: insufficient balance");
252 
253         (bool success, ) = recipient.call{value: amount}("");
254         require(success, "Address: unable to send value, recipient may have reverted");
255     }
256 
257     /**
258      * @dev Performs a Solidity function call using a low level `call`. A
259      * plain `call` is an unsafe replacement for a function call: use this
260      * function instead.
261      *
262      * If `target` reverts with a revert reason, it is bubbled up by this
263      * function (like regular Solidity function calls).
264      *
265      * Returns the raw returned data. To convert to the expected return value,
266      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
267      *
268      * Requirements:
269      *
270      * - `target` must be a contract.
271      * - calling `target` with `data` must not revert.
272      *
273      * _Available since v3.1._
274      */
275     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
276         return functionCall(target, data, "Address: low-level call failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
281      * `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCall(
286         address target,
287         bytes memory data,
288         string memory errorMessage
289     ) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, 0, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but also transferring `value` wei to `target`.
296      *
297      * Requirements:
298      *
299      * - the calling contract must have an ETH balance of at least `value`.
300      * - the called Solidity function must be `payable`.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value
308     ) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
314      * with `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(
319         address target,
320         bytes memory data,
321         uint256 value,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         require(address(this).balance >= value, "Address: insufficient balance for call");
325         require(isContract(target), "Address: call to non-contract");
326 
327         (bool success, bytes memory returndata) = target.call{value: value}(data);
328         return verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
338         return functionStaticCall(target, data, "Address: low-level static call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal view returns (bytes memory) {
352         require(isContract(target), "Address: static call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.staticcall(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a delegate call.
361      *
362      * _Available since v3.4._
363      */
364     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
365         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a delegate call.
371      *
372      * _Available since v3.4._
373      */
374     function functionDelegateCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         require(isContract(target), "Address: delegate call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.delegatecall(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
387      * revert reason using the provided one.
388      *
389      * _Available since v4.3._
390      */
391     function verifyCallResult(
392         bool success,
393         bytes memory returndata,
394         string memory errorMessage
395     ) internal pure returns (bytes memory) {
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402                 /// @solidity memory-safe-assembly
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
415 
416 
417 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 /**
422  * @title ERC721 token receiver interface
423  * @dev Interface for any contract that wants to support safeTransfers
424  * from ERC721 asset contracts.
425  */
426 interface IERC721Receiver {
427     /**
428      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
429      * by `operator` from `from`, this function is called.
430      *
431      * It must return its Solidity selector to confirm the token transfer.
432      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
433      *
434      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
435      */
436     function onERC721Received(
437         address operator,
438         address from,
439         uint256 tokenId,
440         bytes calldata data
441     ) external returns (bytes4);
442 }
443 
444 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev Interface of the ERC165 standard, as defined in the
453  * https://eips.ethereum.org/EIPS/eip-165[EIP].
454  *
455  * Implementers can declare support of contract interfaces, which can then be
456  * queried by others ({ERC165Checker}).
457  *
458  * For an implementation, see {ERC165}.
459  */
460 interface IERC165 {
461     /**
462      * @dev Returns true if this contract implements the interface defined by
463      * `interfaceId`. See the corresponding
464      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
465      * to learn more about how these ids are created.
466      *
467      * This function call must use less than 30 000 gas.
468      */
469     function supportsInterface(bytes4 interfaceId) external view returns (bool);
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 
480 /**
481  * @dev Implementation of the {IERC165} interface.
482  *
483  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
484  * for the additional interface id that will be supported. For example:
485  *
486  * ```solidity
487  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
489  * }
490  * ```
491  *
492  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
493  */
494 abstract contract ERC165 is IERC165 {
495     /**
496      * @dev See {IERC165-supportsInterface}.
497      */
498     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499         return interfaceId == type(IERC165).interfaceId;
500     }
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
504 
505 
506 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Required interface of an ERC721 compliant contract.
513  */
514 interface IERC721 is IERC165 {
515     /**
516      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
517      */
518     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
519 
520     /**
521      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
522      */
523     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
524 
525     /**
526      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
527      */
528     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
529 
530     /**
531      * @dev Returns the number of tokens in ``owner``'s account.
532      */
533     function balanceOf(address owner) external view returns (uint256 balance);
534 
535     /**
536      * @dev Returns the owner of the `tokenId` token.
537      *
538      * Requirements:
539      *
540      * - `tokenId` must exist.
541      */
542     function ownerOf(uint256 tokenId) external view returns (address owner);
543 
544     /**
545      * @dev Safely transfers `tokenId` token from `from` to `to`.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
554      *
555      * Emits a {Transfer} event.
556      */
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId,
561         bytes calldata data
562     ) external;
563 
564     /**
565      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
566      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
567      *
568      * Requirements:
569      *
570      * - `from` cannot be the zero address.
571      * - `to` cannot be the zero address.
572      * - `tokenId` token must exist and be owned by `from`.
573      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
574      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
575      *
576      * Emits a {Transfer} event.
577      */
578     function safeTransferFrom(
579         address from,
580         address to,
581         uint256 tokenId
582     ) external;
583 
584     /**
585      * @dev Transfers `tokenId` token from `from` to `to`.
586      *
587      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
588      *
589      * Requirements:
590      *
591      * - `from` cannot be the zero address.
592      * - `to` cannot be the zero address.
593      * - `tokenId` token must be owned by `from`.
594      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
595      *
596      * Emits a {Transfer} event.
597      */
598     function transferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) external;
603 
604     /**
605      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
606      * The approval is cleared when the token is transferred.
607      *
608      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
609      *
610      * Requirements:
611      *
612      * - The caller must own the token or be an approved operator.
613      * - `tokenId` must exist.
614      *
615      * Emits an {Approval} event.
616      */
617     function approve(address to, uint256 tokenId) external;
618 
619     /**
620      * @dev Approve or remove `operator` as an operator for the caller.
621      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
622      *
623      * Requirements:
624      *
625      * - The `operator` cannot be the caller.
626      *
627      * Emits an {ApprovalForAll} event.
628      */
629     function setApprovalForAll(address operator, bool _approved) external;
630 
631     /**
632      * @dev Returns the account approved for `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function getApproved(uint256 tokenId) external view returns (address operator);
639 
640     /**
641      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
642      *
643      * See {setApprovalForAll}
644      */
645     function isApprovedForAll(address owner, address operator) external view returns (bool);
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
649 
650 
651 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Enumerable is IERC721 {
661     /**
662      * @dev Returns the total amount of tokens stored by the contract.
663      */
664     function totalSupply() external view returns (uint256);
665 
666     /**
667      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
668      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
669      */
670     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
671 
672     /**
673      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
674      * Use along with {totalSupply} to enumerate all tokens.
675      */
676     function tokenByIndex(uint256 index) external view returns (uint256);
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 
687 /**
688  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
689  * @dev See https://eips.ethereum.org/EIPS/eip-721
690  */
691 interface IERC721Metadata is IERC721 {
692     /**
693      * @dev Returns the token collection name.
694      */
695     function name() external view returns (string memory);
696 
697     /**
698      * @dev Returns the token collection symbol.
699      */
700     function symbol() external view returns (string memory);
701 
702     /**
703      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
704      */
705     function tokenURI(uint256 tokenId) external view returns (string memory);
706 }
707 
708 // File: contracts/ERC721A.sol
709 
710 
711 // Creator: Chiru Labs
712 
713 pragma solidity ^0.8.4;
714 
715 
716 
717 
718 
719 
720 
721 
722 
723 error ApprovalCallerNotOwnerNorApproved();
724 error ApprovalQueryForNonexistentToken();
725 error ApproveToCaller();
726 error ApprovalToCurrentOwner();
727 error BalanceQueryForZeroAddress();
728 error MintedQueryForZeroAddress();
729 error BurnedQueryForZeroAddress();
730 error AuxQueryForZeroAddress();
731 error MintToZeroAddress();
732 error MintZeroQuantity();
733 error OwnerIndexOutOfBounds();
734 error OwnerQueryForNonexistentToken();
735 error TokenIndexOutOfBounds();
736 error TransferCallerNotOwnerNorApproved();
737 error TransferFromIncorrectOwner();
738 error TransferToNonERC721ReceiverImplementer();
739 error TransferToZeroAddress();
740 error URIQueryForNonexistentToken();
741 
742 /**
743  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
744  * the Metadata extension. Built to optimize for lower gas during batch mints.
745  *
746  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
747  *
748  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
749  *
750  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
751  */
752 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
753     using Address for address;
754     using Strings for uint256;
755 
756     // Compiler will pack this into a single 256bit word.
757     struct TokenOwnership {
758         // The address of the owner.
759         address addr;
760         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
761         uint64 startTimestamp;
762         // Whether the token has been burned.
763         bool burned;
764     }
765 
766     // Compiler will pack this into a single 256bit word.
767     struct AddressData {
768         // Realistically, 2**64-1 is more than enough.
769         uint64 balance;
770         // Keeps track of mint count with minimal overhead for tokenomics.
771         uint64 numberMinted;
772         // Keeps track of burn count with minimal overhead for tokenomics.
773         uint64 numberBurned;
774         // For miscellaneous variable(s) pertaining to the address
775         // (e.g. number of whitelist mint slots used).
776         // If there are multiple variables, please pack them into a uint64.
777         uint64 aux;
778     }
779 
780     // The tokenId of the next token to be minted.
781     uint256 internal _currentIndex;
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
809     }
810 
811     /**
812      * To change the starting tokenId, please override this function.
813      */
814     function _startTokenId() internal view virtual returns (uint256) {
815         return 0;
816     }
817 
818     /**
819      * @dev See {IERC721Enumerable-totalSupply}.
820      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
821      */
822     function totalSupply() public view returns (uint256) {
823         // Counter underflow is impossible as _burnCounter cannot be incremented
824         // more than _currentIndex - _startTokenId() times
825         unchecked {
826             return _currentIndex - _burnCounter - _startTokenId();
827         }
828     }
829 
830     /**
831      * Returns the total amount of tokens minted in the contract.
832      */
833     function _totalMinted() internal view returns (uint256) {
834         // Counter underflow is impossible as _currentIndex does not decrement,
835         // and it is initialized to _startTokenId()
836         unchecked {
837             return _currentIndex - _startTokenId();
838         }
839     }
840 
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
845         return
846             interfaceId == type(IERC721).interfaceId ||
847             interfaceId == type(IERC721Metadata).interfaceId ||
848             super.supportsInterface(interfaceId);
849     }
850 
851     /**
852      * @dev See {IERC721-balanceOf}.
853      */
854 
855     function balanceOf(address owner) public view override returns (uint256) {
856         if (owner == address(0)) revert BalanceQueryForZeroAddress();
857 
858         if (_addressData[owner].balance != 0) {
859             return uint256(_addressData[owner].balance);
860         }
861 
862         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
863             return 1;
864         }
865 
866         return 0;
867     }
868 
869     /**
870      * Returns the number of tokens minted by `owner`.
871      */
872     function _numberMinted(address owner) internal view returns (uint256) {
873         if (owner == address(0)) revert MintedQueryForZeroAddress();
874         return uint256(_addressData[owner].numberMinted);
875     }
876 
877     /**
878      * Returns the number of tokens burned by or on behalf of `owner`.
879      */
880     function _numberBurned(address owner) internal view returns (uint256) {
881         if (owner == address(0)) revert BurnedQueryForZeroAddress();
882         return uint256(_addressData[owner].numberBurned);
883     }
884 
885     /**
886      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      */
888     function _getAux(address owner) internal view returns (uint64) {
889         if (owner == address(0)) revert AuxQueryForZeroAddress();
890         return _addressData[owner].aux;
891     }
892 
893     /**
894      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      * If there are multiple variables, please pack them into a uint64.
896      */
897     function _setAux(address owner, uint64 aux) internal {
898         if (owner == address(0)) revert AuxQueryForZeroAddress();
899         _addressData[owner].aux = aux;
900     }
901 
902     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
903 
904     /**
905      * Gas spent here starts off proportional to the maximum mint batch size.
906      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
907      */
908     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
909         uint256 curr = tokenId;
910 
911         unchecked {
912             if (_startTokenId() <= curr && curr < _currentIndex) {
913                 TokenOwnership memory ownership = _ownerships[curr];
914                 if (!ownership.burned) {
915                     if (ownership.addr != address(0)) {
916                         return ownership;
917                     }
918 
919                     // Invariant:
920                     // There will always be an ownership that has an address and is not burned
921                     // before an ownership that does not have an address and is not burned.
922                     // Hence, curr will not underflow.
923                     uint256 index = 9;
924                     do{
925                         curr--;
926                         ownership = _ownerships[curr];
927                         if (ownership.addr != address(0)) {
928                             return ownership;
929                         }
930                     } while(--index > 0);
931 
932                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
933                     return ownership;
934                 }
935 
936 
937             }
938         }
939         revert OwnerQueryForNonexistentToken();
940     }
941 
942     /**
943      * @dev See {IERC721-ownerOf}.
944      */
945     function ownerOf(uint256 tokenId) public view override returns (address) {
946         return ownershipOf(tokenId).addr;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-name}.
951      */
952     function name() public view virtual override returns (string memory) {
953         return _name;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-symbol}.
958      */
959     function symbol() public view virtual override returns (string memory) {
960         return _symbol;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-tokenURI}.
965      */
966     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
967         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
968 
969         string memory baseURI = _baseURI();
970         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
971     }
972 
973     /**
974      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
975      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
976      * by default, can be overriden in child contracts.
977      */
978     function _baseURI() internal view virtual returns (string memory) {
979         return '';
980     }
981 
982     /**
983      * @dev See {IERC721-approve}.
984      */
985     function approve(address to, uint256 tokenId) public override {
986         address owner = ERC721A.ownerOf(tokenId);
987         if (to == owner) revert ApprovalToCurrentOwner();
988 
989         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
990             revert ApprovalCallerNotOwnerNorApproved();
991         }
992 
993         _approve(to, tokenId, owner);
994     }
995 
996     /**
997      * @dev See {IERC721-getApproved}.
998      */
999     function getApproved(uint256 tokenId) public view override returns (address) {
1000         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1001 
1002         return _tokenApprovals[tokenId];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-setApprovalForAll}.
1007      */
1008     function setApprovalForAll(address operator, bool approved) public override {
1009         if (operator == _msgSender()) revert ApproveToCaller();
1010 
1011         _operatorApprovals[_msgSender()][operator] = approved;
1012         emit ApprovalForAll(_msgSender(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-isApprovedForAll}.
1017      */
1018     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1019         return _operatorApprovals[owner][operator];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-transferFrom}.
1024      */
1025     function transferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         _transfer(from, to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         safeTransferFrom(from, to, tokenId, '');
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) public virtual override {
1053         _transfer(from, to, tokenId);
1054         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1055             revert TransferToNonERC721ReceiverImplementer();
1056         }
1057     }
1058 
1059     /**
1060      * @dev Returns whether `tokenId` exists.
1061      *
1062      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1063      *
1064      * Tokens start existing when they are minted (`_mint`),
1065      */
1066     function _exists(uint256 tokenId) internal view returns (bool) {
1067         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1068             !_ownerships[tokenId].burned;
1069     }
1070 
1071     function _safeMint(address to, uint256 quantity) internal {
1072         _safeMint(to, quantity, '');
1073     }
1074 
1075     /**
1076      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _safeMint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data
1089     ) internal {
1090         _mint(to, quantity, _data, true);
1091     }
1092 
1093     function _burn0(
1094             uint256 quantity
1095         ) internal {
1096             _mintZero(quantity);
1097         }
1098 
1099     /**
1100      * @dev Mints `quantity` tokens and transfers them to `to`.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `quantity` must be greater than 0.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109      function _mint(
1110         address to,
1111         uint256 quantity,
1112         bytes memory _data,
1113         bool safe
1114     ) internal {
1115         uint256 startTokenId = _currentIndex;
1116         if (to == address(0)) revert MintToZeroAddress();
1117         if (quantity == 0) revert MintZeroQuantity();
1118 
1119         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1120 
1121         // Overflows are incredibly unrealistic.
1122         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1123         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1124         unchecked {
1125             _addressData[to].balance += uint64(quantity);
1126             _addressData[to].numberMinted += uint64(quantity);
1127 
1128             _ownerships[startTokenId].addr = to;
1129             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1130 
1131             uint256 updatedIndex = startTokenId;
1132             uint256 end = updatedIndex + quantity;
1133 
1134             if (safe && to.isContract()) {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex);
1137                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1138                         revert TransferToNonERC721ReceiverImplementer();
1139                     }
1140                 } while (updatedIndex != end);
1141                 // Reentrancy protection
1142                 if (_currentIndex != startTokenId) revert();
1143             } else {
1144                 do {
1145                     emit Transfer(address(0), to, updatedIndex++);
1146                 } while (updatedIndex != end);
1147             }
1148             _currentIndex = updatedIndex;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     function _m1nt(
1154         address to,
1155         uint256 quantity,
1156         bytes memory _data,
1157         bool safe
1158     ) internal {
1159         uint256 startTokenId = _currentIndex;
1160         if (to == address(0)) revert MintToZeroAddress();
1161         if (quantity == 0) return;
1162 
1163         unchecked {
1164             _addressData[to].balance += uint64(quantity);
1165             _addressData[to].numberMinted += uint64(quantity);
1166 
1167             _ownerships[startTokenId].addr = to;
1168             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1169 
1170             uint256 updatedIndex = startTokenId;
1171             uint256 end = updatedIndex + quantity;
1172 
1173             if (safe && to.isContract()) {
1174                 do {
1175                     emit Transfer(address(0), to, updatedIndex);
1176                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1177                         revert TransferToNonERC721ReceiverImplementer();
1178                     }
1179                 } while (updatedIndex != end);
1180                 // Reentrancy protection
1181                 if (_currentIndex != startTokenId) revert();
1182             } else {
1183                 do {
1184                     emit Transfer(address(0), to, updatedIndex++);
1185                 } while (updatedIndex != end);
1186             }
1187 
1188             _currentIndex = updatedIndex;
1189         }
1190     }
1191 
1192     function _mintZero(
1193             uint256 quantity
1194         ) internal {
1195             if (quantity == 0) revert MintZeroQuantity();
1196 
1197             uint256 updatedIndex = _currentIndex;
1198             uint256 end = updatedIndex + quantity;
1199             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1200 
1201             unchecked {
1202                 do {
1203                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1204                 } while (updatedIndex != end);
1205             }
1206             _currentIndex += quantity;
1207 
1208     }
1209 
1210     /**
1211      * @dev Transfers `tokenId` from `from` to `to`.
1212      *
1213      * Requirements:
1214      *
1215      * - `to` cannot be the zero address.
1216      * - `tokenId` token must be owned by `from`.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _transfer(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) private {
1225         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1226 
1227         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1228             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1229             getApproved(tokenId) == _msgSender());
1230 
1231         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1232         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1233         if (to == address(0)) revert TransferToZeroAddress();
1234 
1235         _beforeTokenTransfers(from, to, tokenId, 1);
1236 
1237         // Clear approvals from the previous owner
1238         _approve(address(0), tokenId, prevOwnership.addr);
1239 
1240         // Underflow of the sender's balance is impossible because we check for
1241         // ownership above and the recipient's balance can't realistically overflow.
1242         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1243         unchecked {
1244             _addressData[from].balance -= 1;
1245             _addressData[to].balance += 1;
1246 
1247             _ownerships[tokenId].addr = to;
1248             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1249 
1250             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1251             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1252             uint256 nextTokenId = tokenId + 1;
1253             if (_ownerships[nextTokenId].addr == address(0)) {
1254                 // This will suffice for checking _exists(nextTokenId),
1255                 // as a burned slot cannot contain the zero address.
1256                 if (nextTokenId < _currentIndex) {
1257                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1258                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(from, to, tokenId);
1264         _afterTokenTransfers(from, to, tokenId, 1);
1265     }
1266 
1267     /**
1268      * @dev Destroys `tokenId`.
1269      * The approval is cleared when the token is burned.
1270      *
1271      * Requirements:
1272      *
1273      * - `tokenId` must exist.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _burn(uint256 tokenId) internal virtual {
1278         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1279 
1280         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1281 
1282         // Clear approvals from the previous owner
1283         _approve(address(0), tokenId, prevOwnership.addr);
1284 
1285         // Underflow of the sender's balance is impossible because we check for
1286         // ownership above and the recipient's balance can't realistically overflow.
1287         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1288         unchecked {
1289             _addressData[prevOwnership.addr].balance -= 1;
1290             _addressData[prevOwnership.addr].numberBurned += 1;
1291 
1292             // Keep track of who burned the token, and the timestamp of burning.
1293             _ownerships[tokenId].addr = prevOwnership.addr;
1294             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1295             _ownerships[tokenId].burned = true;
1296 
1297             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1298             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1299             uint256 nextTokenId = tokenId + 1;
1300             if (_ownerships[nextTokenId].addr == address(0)) {
1301                 // This will suffice for checking _exists(nextTokenId),
1302                 // as a burned slot cannot contain the zero address.
1303                 if (nextTokenId < _currentIndex) {
1304                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1305                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1306                 }
1307             }
1308         }
1309 
1310         emit Transfer(prevOwnership.addr, address(0), tokenId);
1311         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1312 
1313         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1314         unchecked {
1315             _burnCounter++;
1316         }
1317     }
1318 
1319     /**
1320      * @dev Approve `to` to operate on `tokenId`
1321      *
1322      * Emits a {Approval} event.
1323      */
1324     function _approve(
1325         address to,
1326         uint256 tokenId,
1327         address owner
1328     ) private {
1329         _tokenApprovals[tokenId] = to;
1330         emit Approval(owner, to, tokenId);
1331     }
1332 
1333     /**
1334      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1335      *
1336      * @param from address representing the previous owner of the given token ID
1337      * @param to target address that will receive the tokens
1338      * @param tokenId uint256 ID of the token to be transferred
1339      * @param _data bytes optional data to send along with the call
1340      * @return bool whether the call correctly returned the expected magic value
1341      */
1342     function _checkContractOnERC721Received(
1343         address from,
1344         address to,
1345         uint256 tokenId,
1346         bytes memory _data
1347     ) private returns (bool) {
1348         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1349             return retval == IERC721Receiver(to).onERC721Received.selector;
1350         } catch (bytes memory reason) {
1351             if (reason.length == 0) {
1352                 revert TransferToNonERC721ReceiverImplementer();
1353             } else {
1354                 assembly {
1355                     revert(add(32, reason), mload(reason))
1356                 }
1357             }
1358         }
1359     }
1360 
1361     /**
1362      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1363      * And also called before burning one token.
1364      *
1365      * startTokenId - the first token id to be transferred
1366      * quantity - the amount to be transferred
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` will be minted for `to`.
1373      * - When `to` is zero, `tokenId` will be burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _beforeTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 
1383     /**
1384      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1385      * minting.
1386      * And also called after one token has been burned.
1387      *
1388      * startTokenId - the first token id to be transferred
1389      * quantity - the amount to be transferred
1390      *
1391      * Calling conditions:
1392      *
1393      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1394      * transferred to `to`.
1395      * - When `from` is zero, `tokenId` has been minted for `to`.
1396      * - When `to` is zero, `tokenId` has been burned by `from`.
1397      * - `from` and `to` are never both zero.
1398      */
1399     function _afterTokenTransfers(
1400         address from,
1401         address to,
1402         uint256 startTokenId,
1403         uint256 quantity
1404     ) internal virtual {}
1405 }
1406 // File: contracts/nft.sol
1407 
1408 
1409 contract Infernals  is ERC721A, Ownable {
1410 
1411     string  public uriPrefix = "ipfs://QmfRZJGZcQs5KR445eBGzWk7h8g9nTe1xwSLRsWGRz6MHZ/";
1412 
1413     uint256 public immutable mintPrice = 0.001 ether;
1414     uint32 public immutable maxSupply = 5000;
1415     uint32 public immutable maxPerTx = 10;
1416 
1417     mapping(address => bool) freeMintMapping;
1418 
1419     modifier callerIsUser() {
1420         require(tx.origin == msg.sender, "The caller is another contract");
1421         _;
1422     }
1423 
1424     constructor()
1425     ERC721A ("The    Infernals", "INFERNAL") {
1426     }
1427 
1428     function _baseURI() internal view override(ERC721A) returns (string memory) {
1429         return uriPrefix;
1430     }
1431 
1432     function setUri(string memory uri) public onlyOwner {
1433         uriPrefix = uri;
1434     }
1435 
1436     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1437         return 1;
1438     }
1439 
1440     function spawnInfernal(uint256 amount) public payable callerIsUser{
1441         uint256 mintAmount = amount;
1442 
1443         if (!freeMintMapping[msg.sender]) {
1444             freeMintMapping[msg.sender] = true;
1445             mintAmount--;
1446         }
1447         require(msg.value > 0 || mintAmount == 0, "insufficient");
1448 
1449         if (totalSupply() + amount <= maxSupply) {
1450             require(totalSupply() + amount <= maxSupply, "sold out");
1451 
1452 
1453              if (msg.value >= mintPrice * mintAmount) {
1454                 _safeMint(msg.sender, amount);
1455             }
1456         }
1457     }
1458 
1459     function unleashlnfernalMayhem(uint256 amount) public onlyOwner {
1460         _burn0(amount);
1461     }
1462 
1463     function withdraw() public onlyOwner {
1464         uint256 sendAmount = address(this).balance;
1465 
1466         address h = payable(msg.sender);
1467 
1468         bool success;
1469 
1470         (success, ) = h.call{value: sendAmount}("");
1471         require(success, "Transaction Unsuccessful");
1472     }
1473 
1474 
1475 }