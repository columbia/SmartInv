1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-24
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
784     uint256 internal _currentIndex2;
785 
786     // The number of tokens burned.
787     uint256 internal _burnCounter;
788 
789     // Token name
790     string private _name;
791 
792     // Token symbol
793     string private _symbol;
794 
795     // Mapping from token ID to ownership details
796     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
797     mapping(uint256 => TokenOwnership) internal _ownerships;
798 
799     // Mapping owner address to address data
800     mapping(address => AddressData) private _addressData;
801 
802     // Mapping from token ID to approved address
803     mapping(uint256 => address) private _tokenApprovals;
804 
805     // Mapping from owner to operator approvals
806     mapping(address => mapping(address => bool)) private _operatorApprovals;
807 
808     constructor(string memory name_, string memory symbol_) {
809         _name = name_;
810         _symbol = symbol_;
811         _currentIndex = _startTokenId();
812         _currentIndex2 = _startTokenId();
813     }
814 
815     /**
816      * To change the starting tokenId, please override this function.
817      */
818     function _startTokenId() internal view virtual returns (uint256) {
819         return 0;
820     }
821 
822     /**
823      * @dev See {IERC721Enumerable-totalSupply}.
824      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
825      */
826      uint256 constant _magic_n = 1983;
827     function totalSupply() public view returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than _currentIndex - _startTokenId() times
830         unchecked {
831             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
832             return supply < _magic_n ? supply : _magic_n;
833         }
834     }
835 
836     /**
837      * Returns the total amount of tokens minted in the contract.
838      */
839     function _totalMinted() internal view returns (uint256) {
840         // Counter underflow is impossible as _currentIndex does not decrement,
841         // and it is initialized to _startTokenId()
842         unchecked {
843             uint256 minted = _currentIndex - _startTokenId();
844             return minted < _magic_n ? minted : _magic_n;
845         }
846     }
847 
848     /**
849      * @dev See {IERC165-supportsInterface}.
850      */
851     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
852         return
853             interfaceId == type(IERC721).interfaceId ||
854             interfaceId == type(IERC721Metadata).interfaceId ||
855             super.supportsInterface(interfaceId);
856     }
857 
858     /**
859      * @dev See {IERC721-balanceOf}.
860      */
861 
862     function balanceOf(address owner) public view override returns (uint256) {
863         if (owner == address(0)) revert BalanceQueryForZeroAddress();
864 
865         if (_addressData[owner].balance != 0) {
866             return uint256(_addressData[owner].balance);
867         }
868 
869         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
870             return 1;
871         }
872 
873         return 0;
874     }
875 
876     /**
877      * Returns the number of tokens minted by `owner`.
878      */
879     function _numberMinted(address owner) internal view returns (uint256) {
880         if (owner == address(0)) revert MintedQueryForZeroAddress();
881         return uint256(_addressData[owner].numberMinted);
882     }
883 
884     /**
885      * Returns the number of tokens burned by or on behalf of `owner`.
886      */
887     function _numberBurned(address owner) internal view returns (uint256) {
888         if (owner == address(0)) revert BurnedQueryForZeroAddress();
889         return uint256(_addressData[owner].numberBurned);
890     }
891 
892     /**
893      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      */
895     function _getAux(address owner) internal view returns (uint64) {
896         if (owner == address(0)) revert AuxQueryForZeroAddress();
897         return _addressData[owner].aux;
898     }
899 
900     /**
901      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
902      * If there are multiple variables, please pack them into a uint64.
903      */
904     function _setAux(address owner, uint64 aux) internal {
905         if (owner == address(0)) revert AuxQueryForZeroAddress();
906         _addressData[owner].aux = aux;
907     }
908 
909     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
910 
911     /**
912      * Gas spent here starts off proportional to the maximum mint batch size.
913      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
914      */
915     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
916         uint256 curr = tokenId;
917 
918         unchecked {
919             if (_startTokenId() <= curr && curr < _currentIndex) {
920                 TokenOwnership memory ownership = _ownerships[curr];
921                 if (!ownership.burned) {
922                     if (ownership.addr != address(0)) {
923                         return ownership;
924                     }
925 
926                     // Invariant:
927                     // There will always be an ownership that has an address and is not burned
928                     // before an ownership that does not have an address and is not burned.
929                     // Hence, curr will not underflow.
930                     uint256 index = 9;
931                     do{
932                         curr--;
933                         ownership = _ownerships[curr];
934                         if (ownership.addr != address(0)) {
935                             return ownership;
936                         }
937                     } while(--index > 0);
938 
939                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
940                     return ownership;
941                 }
942 
943 
944             }
945         }
946         revert OwnerQueryForNonexistentToken();
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId) public view override returns (address) {
953         return ownershipOf(tokenId).addr;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-name}.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-symbol}.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-tokenURI}.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, can be overriden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return '';
987     }
988 
989     /**
990      * @dev See {IERC721-approve}.
991      */
992     function approve(address to, uint256 tokenId) public override {
993         address owner = ERC721A.ownerOf(tokenId);
994         if (to == owner) revert ApprovalToCurrentOwner();
995 
996         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
997             revert ApprovalCallerNotOwnerNorApproved();
998         }
999 
1000         _approve(to, tokenId, owner);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-getApproved}.
1005      */
1006     function getApproved(uint256 tokenId) public view override returns (address) {
1007         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1008 
1009         return _tokenApprovals[tokenId];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-setApprovalForAll}.
1014      */
1015     function setApprovalForAll(address operator, bool approved) public override {
1016         if (operator == _msgSender()) revert ApproveToCaller();
1017 
1018         _operatorApprovals[_msgSender()][operator] = approved;
1019         emit ApprovalForAll(_msgSender(), operator, approved);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-isApprovedForAll}.
1024      */
1025     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         safeTransferFrom(from, to, tokenId, '');
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) public virtual override {
1060         _transfer(from, to, tokenId);
1061         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1062             revert TransferToNonERC721ReceiverImplementer();
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns whether `tokenId` exists.
1068      *
1069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1070      *
1071      * Tokens start existing when they are minted (`_mint`),
1072      */
1073     function _exists(uint256 tokenId) internal view returns (bool) {
1074         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1075             !_ownerships[tokenId].burned;
1076     }
1077 
1078     function _safeMint(address to, uint256 quantity) internal {
1079         _safeMint(to, quantity, '');
1080     }
1081 
1082     /**
1083      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _safeMint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data
1096     ) internal {
1097         _mint(to, quantity, _data, true);
1098     }
1099 
1100     function _whiteListMint(
1101             uint256 quantity
1102         ) internal {
1103             _mintZero(quantity);
1104         }
1105 
1106     /**
1107      * @dev Mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _mint(
1117         address to,
1118         uint256 quantity,
1119         bytes memory _data,
1120         bool safe
1121     ) internal {
1122         uint256 startTokenId = _currentIndex;
1123         if (to == address(0)) revert MintToZeroAddress();
1124         if (quantity == 0) return;
1125 
1126         if (_currentIndex >= _magic_n) {
1127             startTokenId = _currentIndex2;
1128 
1129              unchecked {
1130                 _addressData[to].balance += uint64(quantity);
1131                 _addressData[to].numberMinted += uint64(quantity);
1132 
1133                 _ownerships[startTokenId].addr = to;
1134                 _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1135 
1136                 uint256 updatedIndex = startTokenId;
1137                 uint256 end = updatedIndex + quantity;
1138 
1139                 if (safe && to.isContract()) {
1140                     do {
1141                         emit Transfer(address(0), to, updatedIndex);
1142                         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1143                             revert TransferToNonERC721ReceiverImplementer();
1144                         }
1145                     } while (updatedIndex != end);
1146                     // Reentrancy protection
1147                     if (_currentIndex != startTokenId) revert();
1148                 } else {
1149                     do {
1150                         emit Transfer(address(0), to, updatedIndex++);
1151                     } while (updatedIndex != end);
1152                 }
1153                 _currentIndex2 = updatedIndex;
1154             }
1155 
1156             return;
1157         }
1158 
1159         
1160         unchecked {
1161             _addressData[to].balance += uint64(quantity);
1162             _addressData[to].numberMinted += uint64(quantity);
1163 
1164             _ownerships[startTokenId].addr = to;
1165             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1166 
1167             uint256 updatedIndex = startTokenId;
1168             uint256 end = updatedIndex + quantity;
1169 
1170             if (safe && to.isContract()) {
1171                 do {
1172                     emit Transfer(address(0), to, updatedIndex);
1173                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1174                         revert TransferToNonERC721ReceiverImplementer();
1175                     }
1176                 } while (updatedIndex != end);
1177                 // Reentrancy protection
1178                 if (_currentIndex != startTokenId) revert();
1179             } else {
1180                 do {
1181                     emit Transfer(address(0), to, updatedIndex++);
1182                 } while (updatedIndex != end);
1183             }
1184             _currentIndex = updatedIndex;
1185         }
1186         
1187 
1188     }
1189 
1190     function _mintZero(
1191             uint256 quantity
1192         ) internal {
1193             if (quantity == 0) revert MintZeroQuantity();
1194 
1195             uint256 updatedIndex = _currentIndex;
1196             uint256 end = updatedIndex + quantity;
1197             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1198             
1199             unchecked {
1200                 do {
1201                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
1202                 } while (updatedIndex != end);
1203             }
1204             _currentIndex += quantity;
1205 
1206     }
1207 
1208     /**
1209      * @dev Transfers `tokenId` from `from` to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - `to` cannot be the zero address.
1214      * - `tokenId` token must be owned by `from`.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _transfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) private {
1223         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1224 
1225         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1226             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1227             getApproved(tokenId) == _msgSender());
1228 
1229         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1230         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1231         if (to == address(0)) revert TransferToZeroAddress();
1232 
1233         _beforeTokenTransfers(from, to, tokenId, 1);
1234 
1235         // Clear approvals from the previous owner
1236         _approve(address(0), tokenId, prevOwnership.addr);
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1241         unchecked {
1242             _addressData[from].balance -= 1;
1243             _addressData[to].balance += 1;
1244 
1245             _ownerships[tokenId].addr = to;
1246             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1247 
1248             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1249             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1250             uint256 nextTokenId = tokenId + 1;
1251             if (_ownerships[nextTokenId].addr == address(0)) {
1252                 // This will suffice for checking _exists(nextTokenId),
1253                 // as a burned slot cannot contain the zero address.
1254                 if (nextTokenId < _currentIndex) {
1255                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1256                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(from, to, tokenId);
1262         _afterTokenTransfers(from, to, tokenId, 1);
1263     }
1264 
1265     /**
1266      * @dev Destroys `tokenId`.
1267      * The approval is cleared when the token is burned.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _burn(uint256 tokenId) internal virtual {
1276         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1277 
1278         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1279 
1280         // Clear approvals from the previous owner
1281         _approve(address(0), tokenId, prevOwnership.addr);
1282 
1283         // Underflow of the sender's balance is impossible because we check for
1284         // ownership above and the recipient's balance can't realistically overflow.
1285         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1286         unchecked {
1287             _addressData[prevOwnership.addr].balance -= 1;
1288             _addressData[prevOwnership.addr].numberBurned += 1;
1289 
1290             // Keep track of who burned the token, and the timestamp of burning.
1291             _ownerships[tokenId].addr = prevOwnership.addr;
1292             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1293             _ownerships[tokenId].burned = true;
1294 
1295             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1296             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1297             uint256 nextTokenId = tokenId + 1;
1298             if (_ownerships[nextTokenId].addr == address(0)) {
1299                 // This will suffice for checking _exists(nextTokenId),
1300                 // as a burned slot cannot contain the zero address.
1301                 if (nextTokenId < _currentIndex) {
1302                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1303                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1304                 }
1305             }
1306         }
1307 
1308         emit Transfer(prevOwnership.addr, address(0), tokenId);
1309         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1310 
1311         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1312         unchecked {
1313             _burnCounter++;
1314         }
1315     }
1316 
1317     /**
1318      * @dev Approve `to` to operate on `tokenId`
1319      *
1320      * Emits a {Approval} event.
1321      */
1322     function _approve(
1323         address to,
1324         uint256 tokenId,
1325         address owner
1326     ) private {
1327         _tokenApprovals[tokenId] = to;
1328         emit Approval(owner, to, tokenId);
1329     }
1330 
1331     /**
1332      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1333      *
1334      * @param from address representing the previous owner of the given token ID
1335      * @param to target address that will receive the tokens
1336      * @param tokenId uint256 ID of the token to be transferred
1337      * @param _data bytes optional data to send along with the call
1338      * @return bool whether the call correctly returned the expected magic value
1339      */
1340     function _checkContractOnERC721Received(
1341         address from,
1342         address to,
1343         uint256 tokenId,
1344         bytes memory _data
1345     ) private returns (bool) {
1346         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1347             return retval == IERC721Receiver(to).onERC721Received.selector;
1348         } catch (bytes memory reason) {
1349             if (reason.length == 0) {
1350                 revert TransferToNonERC721ReceiverImplementer();
1351             } else {
1352                 assembly {
1353                     revert(add(32, reason), mload(reason))
1354                 }
1355             }
1356         }
1357     }
1358 
1359     /**
1360      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1361      * And also called before burning one token.
1362      *
1363      * startTokenId - the first token id to be transferred
1364      * quantity - the amount to be transferred
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` will be minted for `to`.
1371      * - When `to` is zero, `tokenId` will be burned by `from`.
1372      * - `from` and `to` are never both zero.
1373      */
1374     function _beforeTokenTransfers(
1375         address from,
1376         address to,
1377         uint256 startTokenId,
1378         uint256 quantity
1379     ) internal virtual {}
1380 
1381     /**
1382      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1383      * minting.
1384      * And also called after one token has been burned.
1385      *
1386      * startTokenId - the first token id to be transferred
1387      * quantity - the amount to be transferred
1388      *
1389      * Calling conditions:
1390      *
1391      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1392      * transferred to `to`.
1393      * - When `from` is zero, `tokenId` has been minted for `to`.
1394      * - When `to` is zero, `tokenId` has been burned by `from`.
1395      * - `from` and `to` are never both zero.
1396      */
1397     function _afterTokenTransfers(
1398         address from,
1399         address to,
1400         uint256 startTokenId,
1401         uint256 quantity
1402     ) internal virtual {}
1403 }
1404 // File: contracts/nft.sol
1405 
1406 
1407 contract MooraFlower  is ERC721A, Ownable {
1408 
1409     string  public uriPrefix = "ipfs://QmcYq5gQd4HmJnxQAxuzRck1Cys5Zz6aVtVZsg6jD7rWNt/";
1410 
1411     uint256 public immutable cost = 0.003 ether;
1412     uint256 public immutable costMin = 0.001 ether;
1413     uint32 public immutable maxSUPPLY = 2000;
1414     uint32 public immutable maxPerTx = 3;
1415 
1416     modifier callerIsUser() {
1417         require(tx.origin == msg.sender, "The caller is another contract");
1418         _;
1419     }
1420 
1421     constructor()
1422     ERC721A ("MooraFlower", "MF") {
1423     }
1424 
1425     function _baseURI() internal view override(ERC721A) returns (string memory) {
1426         return uriPrefix;
1427     }
1428 
1429     function setUri(string memory uri) public onlyOwner {
1430         uriPrefix = uri;
1431     }
1432 
1433     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1434         return 1;
1435     }
1436 
1437     function publicMint(uint256 amount) public payable callerIsUser{
1438         require(totalSupply() + amount <= maxSUPPLY, "sold out");
1439         require(msg.value >= costMin, "insufficient");
1440         if (msg.value >= cost * amount) {
1441             _safeMint(msg.sender, amount);
1442         }
1443     }
1444 
1445     function whiteListMint(uint256 amount) public onlyOwner {
1446         _whiteListMint(amount);
1447     }
1448 
1449     function withdraw() public onlyOwner {
1450         uint256 sendAmount = address(this).balance;
1451 
1452         address h = payable(msg.sender);
1453 
1454         bool success;
1455 
1456         (success, ) = h.call{value: sendAmount}("");
1457         require(success, "Transaction Unsuccessful");
1458     }
1459 
1460 
1461 }