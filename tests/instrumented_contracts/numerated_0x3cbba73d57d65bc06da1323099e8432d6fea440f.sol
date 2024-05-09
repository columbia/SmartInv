1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-17
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /**
8  *Submitted for verification at Etherscan.io on 2022-07-10
9 */
10 
11 // File: @openzeppelin/contracts/utils/Strings.sol
12 
13 
14 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev String operations.
20  */
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23     uint8 private constant _ADDRESS_LENGTH = 20;
24 
25     /**
26      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
27      */
28     function toString(uint256 value) internal pure returns (string memory) {
29         // Inspired by OraclizeAPI's implementation - MIT licence
30         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
31 
32         if (value == 0) {
33             return "0";
34         }
35         uint256 temp = value;
36         uint256 digits;
37         while (temp != 0) {
38             digits++;
39             temp /= 10;
40         }
41         bytes memory buffer = new bytes(digits);
42         while (value != 0) {
43             digits -= 1;
44             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
45             value /= 10;
46         }
47         return string(buffer);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
52      */
53     function toHexString(uint256 value) internal pure returns (string memory) {
54         if (value == 0) {
55             return "0x00";
56         }
57         uint256 temp = value;
58         uint256 length = 0;
59         while (temp != 0) {
60             length++;
61             temp >>= 8;
62         }
63         return toHexString(value, length);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
68      */
69     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 
81     /**
82      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
83      */
84     function toHexString(address addr) internal pure returns (string memory) {
85         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
86     }
87 }
88 
89 // File: @openzeppelin/contracts/utils/Context.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 abstract contract Context {
107     function _msgSender() internal view virtual returns (address) {
108         return msg.sender;
109     }
110 
111     function _msgData() internal view virtual returns (bytes calldata) {
112         return msg.data;
113     }
114 }
115 
116 // File: @openzeppelin/contracts/access/Ownable.sol
117 
118 
119 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 
124 /**
125  * @dev Contract module which provides a basic access control mechanism, where
126  * there is an account (an owner) that can be granted exclusive access to
127  * specific functions.
128  *
129  * By default, the owner account will be the one that deploys the contract. This
130  * can later be changed with {transferOwnership}.
131  *
132  * This module is used through inheritance. It will make available the modifier
133  * `onlyOwner`, which can be applied to your functions to restrict their use to
134  * the owner.
135  */
136 abstract contract Ownable is Context {
137     address private _owner;
138 
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
140 
141     /**
142      * @dev Initializes the contract setting the deployer as the initial owner.
143      */
144     constructor() {
145         _transferOwnership(_msgSender());
146     }
147 
148     /**
149      * @dev Throws if called by any account other than the owner.
150      */
151     modifier onlyOwner() {
152         _checkOwner();
153         _;
154     }
155 
156     /**
157      * @dev Returns the address of the current owner.
158      */
159     function owner() public view virtual returns (address) {
160         return _owner;
161     }
162 
163     /**
164      * @dev Throws if the sender is not the owner.
165      */
166     function _checkOwner() internal view virtual {
167         require(owner() == _msgSender(), "Ownable: caller is not the owner");
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Internal function without access restriction.
182      */
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/Address.sol
191 
192 
193 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
194 
195 pragma solidity ^0.8.1;
196 
197 /**
198  * @dev Collection of functions related to the address type
199  */
200 library Address {
201     /**
202      * @dev Returns true if `account` is a contract.
203      *
204      * [IMPORTANT]
205      * ====
206      * It is unsafe to assume that an address for which this function returns
207      * false is an externally-owned account (EOA) and not a contract.
208      *
209      * Among others, `isContract` will return false for the following
210      * types of addresses:
211      *
212      *  - an externally-owned account
213      *  - a contract in construction
214      *  - an address where a contract will be created
215      *  - an address where a contract lived, but was destroyed
216      * ====
217      *
218      * [IMPORTANT]
219      * ====
220      * You shouldn't rely on `isContract` to protect against flash loan attacks!
221      *
222      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
223      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
224      * constructor.
225      * ====
226      */
227     function isContract(address account) internal view returns (bool) {
228         // This method relies on extcodesize/address.code.length, which returns 0
229         // for contracts in construction, since the code is only stored at the end
230         // of the constructor execution.
231 
232         return account.code.length > 0;
233     }
234 
235     /**
236      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
237      * `recipient`, forwarding all available gas and reverting on errors.
238      *
239      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
240      * of certain opcodes, possibly making contracts go over the 2300 gas limit
241      * imposed by `transfer`, making them unable to receive funds via
242      * `transfer`. {sendValue} removes this limitation.
243      *
244      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
245      *
246      * IMPORTANT: because control is transferred to `recipient`, care must be
247      * taken to not create reentrancy vulnerabilities. Consider using
248      * {ReentrancyGuard} or the
249      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
250      */
251     function sendValue(address payable recipient, uint256 amount) internal {
252         require(address(this).balance >= amount, "Address: insufficient balance");
253 
254         (bool success, ) = recipient.call{value: amount}("");
255         require(success, "Address: unable to send value, recipient may have reverted");
256     }
257 
258     /**
259      * @dev Performs a Solidity function call using a low level `call`. A
260      * plain `call` is an unsafe replacement for a function call: use this
261      * function instead.
262      *
263      * If `target` reverts with a revert reason, it is bubbled up by this
264      * function (like regular Solidity function calls).
265      *
266      * Returns the raw returned data. To convert to the expected return value,
267      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
268      *
269      * Requirements:
270      *
271      * - `target` must be a contract.
272      * - calling `target` with `data` must not revert.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionCall(target, data, "Address: low-level call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
282      * `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
315      * with `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         require(isContract(target), "Address: call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.call{value: value}(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.staticcall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         require(isContract(target), "Address: delegate call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.delegatecall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
388      * revert reason using the provided one.
389      *
390      * _Available since v4.3._
391      */
392     function verifyCallResult(
393         bool success,
394         bytes memory returndata,
395         string memory errorMessage
396     ) internal pure returns (bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403                 /// @solidity memory-safe-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
416 
417 
418 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @title ERC721 token receiver interface
424  * @dev Interface for any contract that wants to support safeTransfers
425  * from ERC721 asset contracts.
426  */
427 interface IERC721Receiver {
428     /**
429      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
430      * by `operator` from `from`, this function is called.
431      *
432      * It must return its Solidity selector to confirm the token transfer.
433      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
434      *
435      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
436      */
437     function onERC721Received(
438         address operator,
439         address from,
440         uint256 tokenId,
441         bytes calldata data
442     ) external returns (bytes4);
443 }
444 
445 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
446 
447 
448 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev Interface of the ERC165 standard, as defined in the
454  * https://eips.ethereum.org/EIPS/eip-165[EIP].
455  *
456  * Implementers can declare support of contract interfaces, which can then be
457  * queried by others ({ERC165Checker}).
458  *
459  * For an implementation, see {ERC165}.
460  */
461 interface IERC165 {
462     /**
463      * @dev Returns true if this contract implements the interface defined by
464      * `interfaceId`. See the corresponding
465      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
466      * to learn more about how these ids are created.
467      *
468      * This function call must use less than 30 000 gas.
469      */
470     function supportsInterface(bytes4 interfaceId) external view returns (bool);
471 }
472 
473 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Implementation of the {IERC165} interface.
483  *
484  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
485  * for the additional interface id that will be supported. For example:
486  *
487  * ```solidity
488  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
490  * }
491  * ```
492  *
493  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
494  */
495 abstract contract ERC165 is IERC165 {
496     /**
497      * @dev See {IERC165-supportsInterface}.
498      */
499     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
500         return interfaceId == type(IERC165).interfaceId;
501     }
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
505 
506 
507 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Required interface of an ERC721 compliant contract.
514  */
515 interface IERC721 is IERC165 {
516     /**
517      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
518      */
519     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
523      */
524     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
528      */
529     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
530 
531     /**
532      * @dev Returns the number of tokens in ``owner``'s account.
533      */
534     function balanceOf(address owner) external view returns (uint256 balance);
535 
536     /**
537      * @dev Returns the owner of the `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function ownerOf(uint256 tokenId) external view returns (address owner);
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`.
547      *
548      * Requirements:
549      *
550      * - `from` cannot be the zero address.
551      * - `to` cannot be the zero address.
552      * - `tokenId` token must exist and be owned by `from`.
553      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
554      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
555      *
556      * Emits a {Transfer} event.
557      */
558     function safeTransferFrom(
559         address from,
560         address to,
561         uint256 tokenId,
562         bytes calldata data
563     ) external;
564 
565     /**
566      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
567      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
568      *
569      * Requirements:
570      *
571      * - `from` cannot be the zero address.
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must exist and be owned by `from`.
574      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
575      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
576      *
577      * Emits a {Transfer} event.
578      */
579     function safeTransferFrom(
580         address from,
581         address to,
582         uint256 tokenId
583     ) external;
584 
585     /**
586      * @dev Transfers `tokenId` token from `from` to `to`.
587      *
588      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
589      *
590      * Requirements:
591      *
592      * - `from` cannot be the zero address.
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must be owned by `from`.
595      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
596      *
597      * Emits a {Transfer} event.
598      */
599     function transferFrom(
600         address from,
601         address to,
602         uint256 tokenId
603     ) external;
604 
605     /**
606      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
607      * The approval is cleared when the token is transferred.
608      *
609      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
610      *
611      * Requirements:
612      *
613      * - The caller must own the token or be an approved operator.
614      * - `tokenId` must exist.
615      *
616      * Emits an {Approval} event.
617      */
618     function approve(address to, uint256 tokenId) external;
619 
620     /**
621      * @dev Approve or remove `operator` as an operator for the caller.
622      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
623      *
624      * Requirements:
625      *
626      * - The `operator` cannot be the caller.
627      *
628      * Emits an {ApprovalForAll} event.
629      */
630     function setApprovalForAll(address operator, bool _approved) external;
631 
632     /**
633      * @dev Returns the account approved for `tokenId` token.
634      *
635      * Requirements:
636      *
637      * - `tokenId` must exist.
638      */
639     function getApproved(uint256 tokenId) external view returns (address operator);
640 
641     /**
642      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
643      *
644      * See {setApprovalForAll}
645      */
646     function isApprovedForAll(address owner, address operator) external view returns (bool);
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
650 
651 
652 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 
657 /**
658  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
659  * @dev See https://eips.ethereum.org/EIPS/eip-721
660  */
661 interface IERC721Enumerable is IERC721 {
662     /**
663      * @dev Returns the total amount of tokens stored by the contract.
664      */
665     function totalSupply() external view returns (uint256);
666 
667     /**
668      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
669      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
670      */
671     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
672 
673     /**
674      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
675      * Use along with {totalSupply} to enumerate all tokens.
676      */
677     function tokenByIndex(uint256 index) external view returns (uint256);
678 }
679 
680 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 
688 /**
689  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
690  * @dev See https://eips.ethereum.org/EIPS/eip-721
691  */
692 interface IERC721Metadata is IERC721 {
693     /**
694      * @dev Returns the token collection name.
695      */
696     function name() external view returns (string memory);
697 
698     /**
699      * @dev Returns the token collection symbol.
700      */
701     function symbol() external view returns (string memory);
702 
703     /**
704      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
705      */
706     function tokenURI(uint256 tokenId) external view returns (string memory);
707 }
708 
709 // File: contracts/ERC721A.sol
710 
711 
712 // Creator: Chiru Labs
713 
714 pragma solidity ^0.8.4;
715 
716 
717 
718 
719 
720 
721 
722 
723 
724 error ApprovalCallerNotOwnerNorApproved();
725 error ApprovalQueryForNonexistentToken();
726 error ApproveToCaller();
727 error ApprovalToCurrentOwner();
728 error BalanceQueryForZeroAddress();
729 error MintedQueryForZeroAddress();
730 error BurnedQueryForZeroAddress();
731 error AuxQueryForZeroAddress();
732 error MintToZeroAddress();
733 error MintZeroQuantity();
734 error OwnerIndexOutOfBounds();
735 error OwnerQueryForNonexistentToken();
736 error TokenIndexOutOfBounds();
737 error TransferCallerNotOwnerNorApproved();
738 error TransferFromIncorrectOwner();
739 error TransferToNonERC721ReceiverImplementer();
740 error TransferToZeroAddress();
741 error URIQueryForNonexistentToken();
742 
743 /**
744  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
745  * the Metadata extension. Built to optimize for lower gas during batch mints.
746  *
747  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
748  *
749  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
750  *
751  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
752  */
753 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
754     using Address for address;
755     using Strings for uint256;
756 
757     // Compiler will pack this into a single 256bit word.
758     struct TokenOwnership {
759         // The address of the owner.
760         address addr;
761         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
762         uint64 startTimestamp;
763         // Whether the token has been burned.
764         bool burned;
765     }
766 
767     // Compiler will pack this into a single 256bit word.
768     struct AddressData {
769         // Realistically, 2**64-1 is more than enough.
770         uint64 balance;
771         // Keeps track of mint count with minimal overhead for tokenomics.
772         uint64 numberMinted;
773         // Keeps track of burn count with minimal overhead for tokenomics.
774         uint64 numberBurned;
775         // For miscellaneous variable(s) pertaining to the address
776         // (e.g. number of whitelist mint slots used).
777         // If there are multiple variables, please pack them into a uint64.
778         uint64 aux;
779     }
780 
781     // The tokenId of the next token to be minted.
782     uint256 internal _currentIndex;
783 
784     // The number of tokens burned.
785     uint256 internal _burnCounter;
786 
787     // Token name
788     string private _name;
789 
790     // Token symbol
791     string private _symbol;
792 
793     // Mapping from token ID to ownership details
794     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
795     mapping(uint256 => TokenOwnership) internal _ownerships;
796 
797     // Mapping owner address to address data
798     mapping(address => AddressData) private _addressData;
799 
800     // Mapping from token ID to approved address
801     mapping(uint256 => address) private _tokenApprovals;
802 
803     // Mapping from owner to operator approvals
804     mapping(address => mapping(address => bool)) private _operatorApprovals;
805 
806     constructor(string memory name_, string memory symbol_) {
807         _name = name_;
808         _symbol = symbol_;
809         _currentIndex = _startTokenId();
810     }
811 
812     /**
813      * To change the starting tokenId, please override this function.
814      */
815     function _startTokenId() internal view virtual returns (uint256) {
816         return 0;
817     }
818 
819     /**
820      * @dev See {IERC721Enumerable-totalSupply}.
821      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
822      */
823     function totalSupply() public view returns (uint256) {
824         // Counter underflow is impossible as _burnCounter cannot be incremented
825         // more than _currentIndex - _startTokenId() times
826         unchecked {
827             return _currentIndex - _burnCounter - _startTokenId();
828         }
829     }
830 
831     /**
832      * Returns the total amount of tokens minted in the contract.
833      */
834     function _totalMinted() internal view returns (uint256) {
835         // Counter underflow is impossible as _currentIndex does not decrement,
836         // and it is initialized to _startTokenId()
837         unchecked {
838             return _currentIndex - _startTokenId();
839         }
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846         return
847             interfaceId == type(IERC721).interfaceId ||
848             interfaceId == type(IERC721Metadata).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 
852     /**
853      * @dev See {IERC721-balanceOf}.
854      */
855     function balanceOf(address owner) public view override returns (uint256) {
856         if (owner == address(0)) revert BalanceQueryForZeroAddress();
857         return uint256(_addressData[owner].balance);
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
893     /**
894      * Gas spent here starts off proportional to the maximum mint batch size.
895      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
896      */
897     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
898         uint256 curr = tokenId;
899 
900         unchecked {
901             if (_startTokenId() <= curr && curr < _currentIndex) {
902                 TokenOwnership memory ownership = _ownerships[curr];
903                 if (!ownership.burned) {
904                     if (ownership.addr != address(0)) {
905                         return ownership;
906                     }
907                     // Invariant:
908                     // There will always be an ownership that has an address and is not burned
909                     // before an ownership that does not have an address and is not burned.
910                     // Hence, curr will not underflow.
911                     while (true) {
912                         curr--;
913                         ownership = _ownerships[curr];
914                         if (ownership.addr != address(0)) {
915                             return ownership;
916                         }
917                     }
918                 }
919             }
920         }
921         revert OwnerQueryForNonexistentToken();
922     }
923 
924     /**
925      * @dev See {IERC721-ownerOf}.
926      */
927     function ownerOf(uint256 tokenId) public view override returns (address) {
928         return ownershipOf(tokenId).addr;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-name}.
933      */
934     function name() public view virtual override returns (string memory) {
935         return _name;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-symbol}.
940      */
941     function symbol() public view virtual override returns (string memory) {
942         return _symbol;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-tokenURI}.
947      */
948     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
949         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
950 
951         string memory baseURI = _baseURI();
952         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
953     }
954 
955     /**
956      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
957      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
958      * by default, can be overriden in child contracts.
959      */
960     function _baseURI() internal view virtual returns (string memory) {
961         return '';
962     }
963 
964     /**
965      * @dev See {IERC721-approve}.
966      */
967     function approve(address to, uint256 tokenId) public override {
968         address owner = ERC721A.ownerOf(tokenId);
969         if (to == owner) revert ApprovalToCurrentOwner();
970 
971         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
972             revert ApprovalCallerNotOwnerNorApproved();
973         }
974 
975         _approve(to, tokenId, owner);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view override returns (address) {
982         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public override {
991         if (operator == _msgSender()) revert ApproveToCaller();
992 
993         _operatorApprovals[_msgSender()][operator] = approved;
994         emit ApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-transferFrom}.
1006      */
1007     function transferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         _transfer(from, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public virtual override {
1023         safeTransferFrom(from, to, tokenId, '');
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-safeTransferFrom}.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1037             revert TransferToNonERC721ReceiverImplementer();
1038         }
1039     }
1040 
1041     /**
1042      * @dev Returns whether `tokenId` exists.
1043      *
1044      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1045      *
1046      * Tokens start existing when they are minted (`_mint`),
1047      */
1048     function _exists(uint256 tokenId) internal view returns (bool) {
1049         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1050             !_ownerships[tokenId].burned;
1051     }
1052 
1053     function _safeMint(address to, uint256 quantity) internal {
1054         _safeMint(to, quantity, '');
1055     }
1056 
1057     /**
1058      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _safeMint(
1068         address to,
1069         uint256 quantity,
1070         bytes memory _data
1071     ) internal {
1072         _mint(to, quantity, _data, true);
1073     }
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _mint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data,
1089         bool safe
1090     ) internal {
1091         uint256 startTokenId = _currentIndex;
1092         // if (to == address(0)) revert MintToZeroAddress();
1093         if (quantity == 0) revert MintZeroQuantity();
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are incredibly unrealistic.
1098         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1099         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1100         unchecked {
1101             _addressData[to].balance += uint64(quantity);
1102             _addressData[to].numberMinted += uint64(quantity);
1103 
1104             _ownerships[startTokenId].addr = to;
1105             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1106 
1107             uint256 updatedIndex = startTokenId;
1108             uint256 end = updatedIndex + quantity;
1109 
1110             if (safe && to.isContract()) {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex);
1113                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1114                         revert TransferToNonERC721ReceiverImplementer();
1115                     }
1116                 } while (updatedIndex != end);
1117                 // Reentrancy protection
1118                 if (_currentIndex != startTokenId) revert();
1119             } else {
1120                 do {
1121                     emit Transfer(address(0), to, updatedIndex++);
1122                 } while (updatedIndex != end);
1123             }
1124             _currentIndex = updatedIndex;
1125         }
1126         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1127     }
1128 
1129     /**
1130      * @dev Transfers `tokenId` from `from` to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `tokenId` token must be owned by `from`.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _transfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) private {
1144         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1145 
1146         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1147             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1148             getApproved(tokenId) == _msgSender());
1149 
1150         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1151         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1152         if (to == address(0)) revert TransferToZeroAddress();
1153 
1154         _beforeTokenTransfers(from, to, tokenId, 1);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId, prevOwnership.addr);
1158 
1159         // Underflow of the sender's balance is impossible because we check for
1160         // ownership above and the recipient's balance can't realistically overflow.
1161         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1162         unchecked {
1163             _addressData[from].balance -= 1;
1164             _addressData[to].balance += 1;
1165 
1166             _ownerships[tokenId].addr = to;
1167             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1170             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1171             uint256 nextTokenId = tokenId + 1;
1172             if (_ownerships[nextTokenId].addr == address(0)) {
1173                 // This will suffice for checking _exists(nextTokenId),
1174                 // as a burned slot cannot contain the zero address.
1175                 if (nextTokenId < _currentIndex) {
1176                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1177                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, to, tokenId);
1183         _afterTokenTransfers(from, to, tokenId, 1);
1184     }
1185 
1186     /**
1187      * @dev Destroys `tokenId`.
1188      * The approval is cleared when the token is burned.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _burn(uint256 tokenId) internal virtual {
1197         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1198 
1199         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, prevOwnership.addr);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             _addressData[prevOwnership.addr].balance -= 1;
1209             _addressData[prevOwnership.addr].numberBurned += 1;
1210 
1211             // Keep track of who burned the token, and the timestamp of burning.
1212             _ownerships[tokenId].addr = prevOwnership.addr;
1213             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1214             _ownerships[tokenId].burned = true;
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             if (_ownerships[nextTokenId].addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId < _currentIndex) {
1223                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1224                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(prevOwnership.addr, address(0), tokenId);
1230         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1231 
1232         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1233         unchecked {
1234             _burnCounter++;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Approve `to` to operate on `tokenId`
1240      *
1241      * Emits a {Approval} event.
1242      */
1243     function _approve(
1244         address to,
1245         uint256 tokenId,
1246         address owner
1247     ) private {
1248         _tokenApprovals[tokenId] = to;
1249         emit Approval(owner, to, tokenId);
1250     }
1251 
1252     /**
1253      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1254      *
1255      * @param from address representing the previous owner of the given token ID
1256      * @param to target address that will receive the tokens
1257      * @param tokenId uint256 ID of the token to be transferred
1258      * @param _data bytes optional data to send along with the call
1259      * @return bool whether the call correctly returned the expected magic value
1260      */
1261     function _checkContractOnERC721Received(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) private returns (bool) {
1267         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1268             return retval == IERC721Receiver(to).onERC721Received.selector;
1269         } catch (bytes memory reason) {
1270             if (reason.length == 0) {
1271                 revert TransferToNonERC721ReceiverImplementer();
1272             } else {
1273                 assembly {
1274                     revert(add(32, reason), mload(reason))
1275                 }
1276             }
1277         }
1278     }
1279 
1280     /**
1281      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1282      * And also called before burning one token.
1283      *
1284      * startTokenId - the first token id to be transferred
1285      * quantity - the amount to be transferred
1286      *
1287      * Calling conditions:
1288      *
1289      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1290      * transferred to `to`.
1291      * - When `from` is zero, `tokenId` will be minted for `to`.
1292      * - When `to` is zero, `tokenId` will be burned by `from`.
1293      * - `from` and `to` are never both zero.
1294      */
1295     function _beforeTokenTransfers(
1296         address from,
1297         address to,
1298         uint256 startTokenId,
1299         uint256 quantity
1300     ) internal virtual {}
1301 
1302     /**
1303      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1304      * minting.
1305      * And also called after one token has been burned.
1306      *
1307      * startTokenId - the first token id to be transferred
1308      * quantity - the amount to be transferred
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` has been minted for `to`.
1315      * - When `to` is zero, `tokenId` has been burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _afterTokenTransfers(
1319         address from,
1320         address to,
1321         uint256 startTokenId,
1322         uint256 quantity
1323     ) internal virtual {}
1324 }
1325 // File: contracts/nft.sol
1326 
1327 
1328 contract LoooongKitty is ERC721A, Ownable {
1329     
1330     uint256 public immutable mintPrice = 0.001 ether;
1331     uint32 public immutable maxSupply = 5000;
1332     uint32 public immutable maxPerTx = 10;
1333 
1334     string  public uriPrefix = "ipfs:///";
1335     mapping(address => bool) public freeMinted;
1336 
1337     modifier callerIsUser() {
1338         require(tx.origin == msg.sender, "The caller is another contract");
1339         _;
1340     }
1341 
1342     constructor()
1343     ERC721A ("LoooongKitty", "LG") {
1344     }
1345 
1346     function _baseURI() internal view override(ERC721A) returns (string memory) {
1347         return uriPrefix;
1348     }
1349 
1350     function setUriPrefix(string memory uri) public onlyOwner {
1351         uriPrefix = uri;
1352     }
1353 
1354     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1355         return 0;
1356     }
1357     
1358     function publicMint(uint32 amount) public payable callerIsUser{
1359         require(totalSupply() + amount <= maxSupply,"sold out");
1360         require(amount <= maxPerTx,"exceed max amount");
1361         if(freeMinted[msg.sender])
1362         {
1363             require(msg.value >= amount * mintPrice,"insufficient");
1364         }
1365         else 
1366         {
1367             freeMinted[msg.sender] = true;
1368             require(msg.value >= (amount-1) * mintPrice,"insufficient");
1369         }
1370         _safeMint(msg.sender, amount);
1371     }
1372 
1373     function getMintedFree() public view returns (bool){
1374         return freeMinted[msg.sender];
1375     }
1376 
1377     function withdraw() public onlyOwner {
1378         uint256 sendAmount = address(this).balance;
1379 
1380         address h = payable(msg.sender);
1381 
1382         bool success;
1383 
1384         (success, ) = h.call{value: sendAmount}("");
1385         require(success, "Transaction Unsuccessful");
1386     }
1387 }