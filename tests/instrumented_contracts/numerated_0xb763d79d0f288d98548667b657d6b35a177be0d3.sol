1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-08
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
700 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
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
846     function balanceOf(address owner) public view override returns (uint256) {
847         if (owner == address(0)) revert BalanceQueryForZeroAddress();
848         return uint256(_addressData[owner].balance);
849     }
850 
851     /**
852      * Returns the number of tokens minted by `owner`.
853      */
854     function _numberMinted(address owner) internal view returns (uint256) {
855         if (owner == address(0)) revert MintedQueryForZeroAddress();
856         return uint256(_addressData[owner].numberMinted);
857     }
858 
859     /**
860      * Returns the number of tokens burned by or on behalf of `owner`.
861      */
862     function _numberBurned(address owner) internal view returns (uint256) {
863         if (owner == address(0)) revert BurnedQueryForZeroAddress();
864         return uint256(_addressData[owner].numberBurned);
865     }
866 
867     /**
868      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
869      */
870     function _getAux(address owner) internal view returns (uint64) {
871         if (owner == address(0)) revert AuxQueryForZeroAddress();
872         return _addressData[owner].aux;
873     }
874 
875     /**
876      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
877      * If there are multiple variables, please pack them into a uint64.
878      */
879     function _setAux(address owner, uint64 aux) internal {
880         if (owner == address(0)) revert AuxQueryForZeroAddress();
881         _addressData[owner].aux = aux;
882     }
883 
884     /**
885      * Gas spent here starts off proportional to the maximum mint batch size.
886      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
887      */
888     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
889         uint256 curr = tokenId;
890 
891         unchecked {
892             if (_startTokenId() <= curr && curr < _currentIndex) {
893                 TokenOwnership memory ownership = _ownerships[curr];
894                 if (!ownership.burned) {
895                     if (ownership.addr != address(0)) {
896                         return ownership;
897                     }
898                     // Invariant:
899                     // There will always be an ownership that has an address and is not burned
900                     // before an ownership that does not have an address and is not burned.
901                     // Hence, curr will not underflow.
902                     while (true) {
903                         curr--;
904                         ownership = _ownerships[curr];
905                         if (ownership.addr != address(0)) {
906                             return ownership;
907                         }
908                     }
909                 }
910             }
911         }
912         revert OwnerQueryForNonexistentToken();
913     }
914 
915     /**
916      * @dev See {IERC721-ownerOf}.
917      */
918     function ownerOf(uint256 tokenId) public view override returns (address) {
919         return ownershipOf(tokenId).addr;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-name}.
924      */
925     function name() public view virtual override returns (string memory) {
926         return _name;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-symbol}.
931      */
932     function symbol() public view virtual override returns (string memory) {
933         return _symbol;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-tokenURI}.
938      */
939     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
940         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
941 
942         string memory baseURI = _baseURI();
943         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
944     }
945 
946     /**
947      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
948      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
949      * by default, can be overriden in child contracts.
950      */
951     function _baseURI() internal view virtual returns (string memory) {
952         return '';
953     }
954 
955     /**
956      * @dev See {IERC721-approve}.
957      */
958     function approve(address to, uint256 tokenId) public override {
959         address owner = ERC721A.ownerOf(tokenId);
960         if (to == owner) revert ApprovalToCurrentOwner();
961 
962         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
963             revert ApprovalCallerNotOwnerNorApproved();
964         }
965 
966         _approve(to, tokenId, owner);
967     }
968 
969     /**
970      * @dev See {IERC721-getApproved}.
971      */
972     function getApproved(uint256 tokenId) public view override returns (address) {
973         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
974 
975         return _tokenApprovals[tokenId];
976     }
977 
978     /**
979      * @dev See {IERC721-setApprovalForAll}.
980      */
981     function setApprovalForAll(address operator, bool approved) public override {
982         if (operator == _msgSender()) revert ApproveToCaller();
983 
984         _operatorApprovals[_msgSender()][operator] = approved;
985         emit ApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC721-isApprovedForAll}.
990      */
991     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[owner][operator];
993     }
994 
995     /**
996      * @dev See {IERC721-transferFrom}.
997      */
998     function transferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) public virtual override {
1003         _transfer(from, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-safeTransferFrom}.
1008      */
1009     function safeTransferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         safeTransferFrom(from, to, tokenId, '');
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) public virtual override {
1026         _transfer(from, to, tokenId);
1027         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1028             revert TransferToNonERC721ReceiverImplementer();
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns whether `tokenId` exists.
1034      *
1035      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1036      *
1037      * Tokens start existing when they are minted (`_mint`),
1038      */
1039     function _exists(uint256 tokenId) internal view returns (bool) {
1040         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1041             !_ownerships[tokenId].burned;
1042     }
1043 
1044     function _safeMint(address to, uint256 quantity) internal {
1045         _safeMint(to, quantity, '');
1046     }
1047 
1048     /**
1049      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1050      *
1051      * Requirements:
1052      *
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1054      * - `quantity` must be greater than 0.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _safeMint(
1059         address to,
1060         uint256 quantity,
1061         bytes memory _data
1062     ) internal {
1063         _mint(to, quantity, _data, true);
1064     }
1065 
1066     /**
1067      * @dev Mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _mint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data,
1080         bool safe
1081     ) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             _addressData[to].balance += uint64(quantity);
1093             _addressData[to].numberMinted += uint64(quantity);
1094 
1095             _ownerships[startTokenId].addr = to;
1096             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1097 
1098             uint256 updatedIndex = startTokenId;
1099             uint256 end = updatedIndex + quantity;
1100 
1101             if (safe && to.isContract()) {
1102                 do {
1103                     emit Transfer(address(0), to, updatedIndex);
1104                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1105                         revert TransferToNonERC721ReceiverImplementer();
1106                     }
1107                 } while (updatedIndex != end);
1108                 // Reentrancy protection
1109                 if (_currentIndex != startTokenId) revert();
1110             } else {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex++);
1113                 } while (updatedIndex != end);
1114             }
1115             _currentIndex = updatedIndex;
1116         }
1117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118     }
1119 
1120     /**
1121      * @dev Transfers `tokenId` from `from` to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `tokenId` token must be owned by `from`.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _transfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) private {
1135         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1136 
1137         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1138             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1139             getApproved(tokenId) == _msgSender());
1140 
1141         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1142         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1143         if (to == address(0)) revert TransferToZeroAddress();
1144 
1145         _beforeTokenTransfers(from, to, tokenId, 1);
1146 
1147         // Clear approvals from the previous owner
1148         _approve(address(0), tokenId, prevOwnership.addr);
1149 
1150         // Underflow of the sender's balance is impossible because we check for
1151         // ownership above and the recipient's balance can't realistically overflow.
1152         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1153         unchecked {
1154             _addressData[from].balance -= 1;
1155             _addressData[to].balance += 1;
1156 
1157             _ownerships[tokenId].addr = to;
1158             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1159 
1160             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1161             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1162             uint256 nextTokenId = tokenId + 1;
1163             if (_ownerships[nextTokenId].addr == address(0)) {
1164                 // This will suffice for checking _exists(nextTokenId),
1165                 // as a burned slot cannot contain the zero address.
1166                 if (nextTokenId < _currentIndex) {
1167                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1168                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1169                 }
1170             }
1171         }
1172 
1173         emit Transfer(from, to, tokenId);
1174         _afterTokenTransfers(from, to, tokenId, 1);
1175     }
1176 
1177     /**
1178      * @dev Destroys `tokenId`.
1179      * The approval is cleared when the token is burned.
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must exist.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _burn(uint256 tokenId) internal virtual {
1188         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1189 
1190         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1191 
1192         // Clear approvals from the previous owner
1193         _approve(address(0), tokenId, prevOwnership.addr);
1194 
1195         // Underflow of the sender's balance is impossible because we check for
1196         // ownership above and the recipient's balance can't realistically overflow.
1197         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1198         unchecked {
1199             _addressData[prevOwnership.addr].balance -= 1;
1200             _addressData[prevOwnership.addr].numberBurned += 1;
1201 
1202             // Keep track of who burned the token, and the timestamp of burning.
1203             _ownerships[tokenId].addr = prevOwnership.addr;
1204             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1205             _ownerships[tokenId].burned = true;
1206 
1207             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1208             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1209             uint256 nextTokenId = tokenId + 1;
1210             if (_ownerships[nextTokenId].addr == address(0)) {
1211                 // This will suffice for checking _exists(nextTokenId),
1212                 // as a burned slot cannot contain the zero address.
1213                 if (nextTokenId < _currentIndex) {
1214                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1215                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1216                 }
1217             }
1218         }
1219 
1220         emit Transfer(prevOwnership.addr, address(0), tokenId);
1221         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1222 
1223         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1224         unchecked {
1225             _burnCounter++;
1226         }
1227     }
1228 
1229     /**
1230      * @dev Approve `to` to operate on `tokenId`
1231      *
1232      * Emits a {Approval} event.
1233      */
1234     function _approve(
1235         address to,
1236         uint256 tokenId,
1237         address owner
1238     ) private {
1239         _tokenApprovals[tokenId] = to;
1240         emit Approval(owner, to, tokenId);
1241     }
1242 
1243     /**
1244      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1245      *
1246      * @param from address representing the previous owner of the given token ID
1247      * @param to target address that will receive the tokens
1248      * @param tokenId uint256 ID of the token to be transferred
1249      * @param _data bytes optional data to send along with the call
1250      * @return bool whether the call correctly returned the expected magic value
1251      */
1252     function _checkContractOnERC721Received(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) private returns (bool) {
1258         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1259             return retval == IERC721Receiver(to).onERC721Received.selector;
1260         } catch (bytes memory reason) {
1261             if (reason.length == 0) {
1262                 revert TransferToNonERC721ReceiverImplementer();
1263             } else {
1264                 assembly {
1265                     revert(add(32, reason), mload(reason))
1266                 }
1267             }
1268         }
1269     }
1270 
1271     /**
1272      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1273      * And also called before burning one token.
1274      *
1275      * startTokenId - the first token id to be transferred
1276      * quantity - the amount to be transferred
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` will be minted for `to`.
1283      * - When `to` is zero, `tokenId` will be burned by `from`.
1284      * - `from` and `to` are never both zero.
1285      */
1286     function _beforeTokenTransfers(
1287         address from,
1288         address to,
1289         uint256 startTokenId,
1290         uint256 quantity
1291     ) internal virtual {}
1292 
1293     /**
1294      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1295      * minting.
1296      * And also called after one token has been burned.
1297      *
1298      * startTokenId - the first token id to be transferred
1299      * quantity - the amount to be transferred
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` has been minted for `to`.
1306      * - When `to` is zero, `tokenId` has been burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _afterTokenTransfers(
1310         address from,
1311         address to,
1312         uint256 startTokenId,
1313         uint256 quantity
1314     ) internal virtual {}
1315 }
1316 
1317 // File: Ownable.sol
1318 
1319 
1320 
1321 pragma solidity >=0.7.0 <0.9.0;
1322 
1323 
1324 
1325 contract MutantElonMusk is ERC721A, Ownable {
1326   using Strings for uint256;
1327 
1328   string baseURI;
1329   string notRevURI;
1330   string public baseExtension = ".json";
1331   uint256 public cost = 0.005 ether;
1332   uint256 public maxSupply = 4444;
1333   uint256 public maxMintAmount = 20;
1334   uint256 public freeAmount = 333;
1335 
1336   bool public paused = false;
1337   bool public revealed = false;
1338   mapping(address => uint256) nftPerWallet;
1339 
1340   constructor(
1341     string memory _initBaseURI,
1342     string memory _initNotRevURI
1343   ) ERC721A("Mutant Elon Musk", "Mutant Elon Musk") {
1344     setBaseURI(_initBaseURI);
1345     notRevURI = _initNotRevURI;
1346   }
1347 
1348   modifier checks(uint256 _mintAmount) {
1349     require(!paused);
1350     require(_mintAmount > 0);
1351     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1352     require(nftPerWallet[msg.sender] < 20, "You can't posses more than 20");
1353 
1354     if(totalSupply() >= freeAmount){
1355         if(msg.sender != owner()) require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1356         nftPerWallet[msg.sender]++;
1357     }
1358     else require(totalSupply() + _mintAmount <= freeAmount, "Free NFTs amount exceeded");
1359     require(_mintAmount <= maxMintAmount, "Max mint amount exceeded");
1360     _;
1361   }
1362 
1363   function mint(uint256 _mintAmount) public payable checks(_mintAmount) {
1364       _safeMint(msg.sender, _mintAmount);
1365   }
1366 
1367   function _baseURI() internal view virtual override returns (string memory) {
1368     return baseURI;
1369   }
1370 
1371   function tokenURI(uint256 tokenId)
1372     public
1373     view
1374     virtual
1375     override
1376     returns (string memory)
1377   {
1378     require(
1379       _exists(tokenId),
1380       "ERC721Metadata: URI query for nonexistent token"
1381     );
1382 
1383     if(!revealed){
1384       return notRevURI;
1385     }
1386 
1387     string memory currentBaseURI = _baseURI();
1388     return bytes(currentBaseURI).length > 0
1389         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1390         : "";
1391   }
1392 
1393   function setCost(uint256 _newCost) public onlyOwner {
1394     cost = _newCost;
1395   }
1396 
1397   function reveal() public onlyOwner {
1398     revealed = true;
1399   }
1400 
1401   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1402     maxMintAmount = _newmaxMintAmount;
1403   }
1404 
1405   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1406     baseURI = _newBaseURI;
1407   }
1408 
1409   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1410     baseExtension = _newBaseExtension;
1411   }
1412 
1413   function pause() public onlyOwner {
1414     paused = !paused;
1415   }
1416  
1417   function withdraw() public payable onlyOwner {
1418     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1419     require(os);
1420   }
1421 }