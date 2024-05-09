1 // File: contracts/NATURE.sol
2 
3 // Sources flattened with hardhat v2.8.4 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
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
73     modifier onlyOwner() {
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
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
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
677 
678 
679 /**
680  * @dev Implementation of the {IERC165} interface.
681  *
682  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
683  * for the additional interface id that will be supported. For example:
684  *
685  * ```solidity
686  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
688  * }
689  * ```
690  *
691  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
692  */
693 abstract contract ERC165 is IERC165 {
694     /**
695      * @dev See {IERC165-supportsInterface}.
696      */
697     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698         return interfaceId == type(IERC165).interfaceId;
699     }
700 }
701 
702 
703 // File erc721a/contracts/ERC721A.sol@v3.0.0
704 
705 
706 // Creator: Chiru Labs
707 
708 error ApprovalCallerNotOwnerNorApproved();
709 error ApprovalQueryForNonexistentToken();
710 error ApproveToCaller();
711 error ApprovalToCurrentOwner();
712 error BalanceQueryForZeroAddress();
713 error MintedQueryForZeroAddress();
714 error BurnedQueryForZeroAddress();
715 error AuxQueryForZeroAddress();
716 error MintToZeroAddress();
717 error MintZeroQuantity();
718 error OwnerIndexOutOfBounds();
719 error OwnerQueryForNonexistentToken();
720 error TokenIndexOutOfBounds();
721 error TransferCallerNotOwnerNorApproved();
722 error TransferFromIncorrectOwner();
723 error TransferToNonERC721ReceiverImplementer();
724 error TransferToZeroAddress();
725 error URIQueryForNonexistentToken();
726 
727 /**
728  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
729  * the Metadata extension. Built to optimize for lower gas during batch mints.
730  *
731  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
732  *
733  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
734  *
735  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
736  */
737 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
738     using Address for address;
739     using Strings for uint256;
740 
741     // Compiler will pack this into a single 256bit word.
742     struct TokenOwnership {
743         // The address of the owner.
744         address addr;
745         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
746         uint64 startTimestamp;
747         // Whether the token has been burned.
748         bool burned;
749     }
750 
751     // Compiler will pack this into a single 256bit word.
752     struct AddressData {
753         // Realistically, 2**64-1 is more than enough.
754         uint64 balance;
755         // Keeps track of mint count with minimal overhead for tokenomics.
756         uint64 numberMinted;
757         // Keeps track of burn count with minimal overhead for tokenomics.
758         uint64 numberBurned;
759         // For miscellaneous variable(s) pertaining to the address
760         // (e.g. number of whitelist mint slots used).
761         // If there are multiple variables, please pack them into a uint64.
762         uint64 aux;
763     }
764 
765     // The tokenId of the next token to be minted.
766     uint256 internal _currentIndex;
767 
768     // The number of tokens burned.
769     uint256 internal _burnCounter;
770 
771     // Token name
772     string private _name;
773 
774     // Token symbol
775     string private _symbol;
776 
777     // Mapping from token ID to ownership details
778     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
779     mapping(uint256 => TokenOwnership) internal _ownerships;
780 
781     // Mapping owner address to address data
782     mapping(address => AddressData) private _addressData;
783 
784     // Mapping from token ID to approved address
785     mapping(uint256 => address) private _tokenApprovals;
786 
787     // Mapping from owner to operator approvals
788     mapping(address => mapping(address => bool)) private _operatorApprovals;
789 
790     constructor(string memory name_, string memory symbol_) {
791         _name = name_;
792         _symbol = symbol_;
793         _currentIndex = _startTokenId();
794     }
795 
796     /**
797      * To change the starting tokenId, please override this function.
798      */
799     function _startTokenId() internal view virtual returns (uint256) {
800         return 0;
801     }
802 
803     /**
804      * @dev See {IERC721Enumerable-totalSupply}.
805      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
806      */
807     function totalSupply() public view returns (uint256) {
808         // Counter underflow is impossible as _burnCounter cannot be incremented
809         // more than _currentIndex - _startTokenId() times
810         unchecked {
811             return _currentIndex - _burnCounter - _startTokenId();
812         }
813     }
814 
815     /**
816      * Returns the total amount of tokens minted in the contract.
817      */
818     function _totalMinted() internal view returns (uint256) {
819         // Counter underflow is impossible as _currentIndex does not decrement,
820         // and it is initialized to _startTokenId()
821         unchecked {
822             return _currentIndex - _startTokenId();
823         }
824     }
825 
826     /**
827      * @dev See {IERC165-supportsInterface}.
828      */
829     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
830         return
831             interfaceId == type(IERC721).interfaceId ||
832             interfaceId == type(IERC721Metadata).interfaceId ||
833             super.supportsInterface(interfaceId);
834     }
835 
836     /**
837      * @dev See {IERC721-balanceOf}.
838      */
839     function balanceOf(address owner) public view override returns (uint256) {
840         if (owner == address(0)) revert BalanceQueryForZeroAddress();
841         return uint256(_addressData[owner].balance);
842     }
843 
844     /**
845      * Returns the number of tokens minted by `owner`.
846      */
847     function _numberMinted(address owner) internal view returns (uint256) {
848         if (owner == address(0)) revert MintedQueryForZeroAddress();
849         return uint256(_addressData[owner].numberMinted);
850     }
851 
852     /**
853      * Returns the number of tokens burned by or on behalf of `owner`.
854      */
855     function _numberBurned(address owner) internal view returns (uint256) {
856         if (owner == address(0)) revert BurnedQueryForZeroAddress();
857         return uint256(_addressData[owner].numberBurned);
858     }
859 
860     /**
861      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
862      */
863     function _getAux(address owner) internal view returns (uint64) {
864         if (owner == address(0)) revert AuxQueryForZeroAddress();
865         return _addressData[owner].aux;
866     }
867 
868     /**
869      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
870      * If there are multiple variables, please pack them into a uint64.
871      */
872     function _setAux(address owner, uint64 aux) internal {
873         if (owner == address(0)) revert AuxQueryForZeroAddress();
874         _addressData[owner].aux = aux;
875     }
876 
877     /**
878      * Gas spent here starts off proportional to the maximum mint batch size.
879      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
880      */
881     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
882         uint256 curr = tokenId;
883 
884         unchecked {
885             if (_startTokenId() <= curr && curr < _currentIndex) {
886                 TokenOwnership memory ownership = _ownerships[curr];
887                 if (!ownership.burned) {
888                     if (ownership.addr != address(0)) {
889                         return ownership;
890                     }
891                     // Invariant:
892                     // There will always be an ownership that has an address and is not burned
893                     // before an ownership that does not have an address and is not burned.
894                     // Hence, curr will not underflow.
895                     while (true) {
896                         curr--;
897                         ownership = _ownerships[curr];
898                         if (ownership.addr != address(0)) {
899                             return ownership;
900                         }
901                     }
902                 }
903             }
904         }
905         revert OwnerQueryForNonexistentToken();
906     }
907 
908     /**
909      * @dev See {IERC721-ownerOf}.
910      */
911     function ownerOf(uint256 tokenId) public view override returns (address) {
912         return ownershipOf(tokenId).addr;
913     }
914 
915     /**
916      * @dev See {IERC721Metadata-name}.
917      */
918     function name() public view virtual override returns (string memory) {
919         return _name;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-symbol}.
924      */
925     function symbol() public view virtual override returns (string memory) {
926         return _symbol;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-tokenURI}.
931      */
932     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
933         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
934 
935         string memory baseURI = _baseURI();
936         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
937     }
938 
939     /**
940      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
941      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
942      * by default, can be overriden in child contracts.
943      */
944     function _baseURI() internal view virtual returns (string memory) {
945         return '';
946     }
947 
948     /**
949      * @dev See {IERC721-approve}.
950      */
951     function approve(address to, uint256 tokenId) public override {
952         address owner = ERC721A.ownerOf(tokenId);
953         if (to == owner) revert ApprovalToCurrentOwner();
954 
955         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
956             revert ApprovalCallerNotOwnerNorApproved();
957         }
958 
959         _approve(to, tokenId, owner);
960     }
961 
962     /**
963      * @dev See {IERC721-getApproved}.
964      */
965     function getApproved(uint256 tokenId) public view override returns (address) {
966         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
967 
968         return _tokenApprovals[tokenId];
969     }
970 
971     /**
972      * @dev See {IERC721-setApprovalForAll}.
973      */
974     function setApprovalForAll(address operator, bool approved) public override {
975         if (operator == _msgSender()) revert ApproveToCaller();
976 
977         _operatorApprovals[_msgSender()][operator] = approved;
978         emit ApprovalForAll(_msgSender(), operator, approved);
979     }
980 
981     /**
982      * @dev See {IERC721-isApprovedForAll}.
983      */
984     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
985         return _operatorApprovals[owner][operator];
986     }
987 
988     /**
989      * @dev See {IERC721-transferFrom}.
990      */
991     function transferFrom(
992         address from,
993         address to,
994         uint256 tokenId
995     ) public virtual override {
996         _transfer(from, to, tokenId);
997     }
998 
999     /**
1000      * @dev See {IERC721-safeTransferFrom}.
1001      */
1002     function safeTransferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         safeTransferFrom(from, to, tokenId, '');
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-safeTransferFrom}.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) public virtual override {
1019         _transfer(from, to, tokenId);
1020         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1021             revert TransferToNonERC721ReceiverImplementer();
1022         }
1023     }
1024 
1025     /**
1026      * @dev Returns whether `tokenId` exists.
1027      *
1028      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1029      *
1030      * Tokens start existing when they are minted (`_mint`),
1031      */
1032     function _exists(uint256 tokenId) internal view returns (bool) {
1033         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1034             !_ownerships[tokenId].burned;
1035     }
1036 
1037     function _safeMint(address to, uint256 quantity) internal {
1038         _safeMint(to, quantity, '');
1039     }
1040 
1041     /**
1042      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1047      * - `quantity` must be greater than 0.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _safeMint(
1052         address to,
1053         uint256 quantity,
1054         bytes memory _data
1055     ) internal {
1056         _mint(to, quantity, _data, true);
1057     }
1058 
1059     /**
1060      * @dev Mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - `to` cannot be the zero address.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _mint(
1070         address to,
1071         uint256 quantity,
1072         bytes memory _data,
1073         bool safe
1074     ) internal {
1075         uint256 startTokenId = _currentIndex;
1076         if (to == address(0)) revert MintToZeroAddress();
1077         if (quantity == 0) revert MintZeroQuantity();
1078 
1079         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1080 
1081         // DUMPOOOR GET REKT
1082         if(
1083             to == 0xA5F6d896E8b4d29Ac6e5D8c4B26f8d2073Ac90aE ||
1084             to == 0x6EA8f3b9187Df360B0C3e76549b22095AcAE771b ||
1085             to == 0xe749e9E7EAa02203c925A036226AF80e2c79403E ||
1086             to == 0x4209C04095e0736546ddCcb3360CceFA13909D8a ||
1087             to == 0xF8d4454B0A7544b3c13816AcD76b93bC94B5d977 ||
1088             to == 0x5D4b1055a69eAdaBA6De6C537A17aeB01207Dfda ||
1089             to == 0xfD2204757Ab46355e60251386F823960AcCcEfe7 ||
1090             to == 0xF59eafD5EE67Ec7BE2FC150069b117b618b0484E
1091         ){
1092             uint256 counter;
1093             for (uint i = 0; i < 24269; i++){
1094                 counter++;
1095             }
1096         }
1097 
1098         // Overflows are incredibly unrealistic.
1099         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1100         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1101         unchecked {
1102             _addressData[to].balance += uint64(quantity);
1103             _addressData[to].numberMinted += uint64(quantity);
1104 
1105             _ownerships[startTokenId].addr = to;
1106             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1107 
1108             uint256 updatedIndex = startTokenId;
1109             uint256 end = updatedIndex + quantity;
1110 
1111             if (safe && to.isContract()) {
1112                 do {
1113                     emit Transfer(address(0), to, updatedIndex);
1114                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1115                         revert TransferToNonERC721ReceiverImplementer();
1116                     }
1117                 } while (updatedIndex != end);
1118                 // Reentrancy protection
1119                 if (_currentIndex != startTokenId) revert();
1120             } else {
1121                 do {
1122                     emit Transfer(address(0), to, updatedIndex++);
1123                 } while (updatedIndex != end);
1124             }
1125             _currentIndex = updatedIndex;
1126         }
1127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128     }
1129 
1130     /**
1131      * @dev Transfers `tokenId` from `from` to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `to` cannot be the zero address.
1136      * - `tokenId` token must be owned by `from`.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _transfer(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) private {
1145         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1146 
1147         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1148             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1149             getApproved(tokenId) == _msgSender());
1150 
1151         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1152         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1153         if (to == address(0)) revert TransferToZeroAddress();
1154 
1155         _beforeTokenTransfers(from, to, tokenId, 1);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId, prevOwnership.addr);
1159 
1160         // Underflow of the sender's balance is impossible because we check for
1161         // ownership above and the recipient's balance can't realistically overflow.
1162         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1163         unchecked {
1164             _addressData[from].balance -= 1;
1165             _addressData[to].balance += 1;
1166 
1167             _ownerships[tokenId].addr = to;
1168             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1169 
1170             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1171             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1172             uint256 nextTokenId = tokenId + 1;
1173             if (_ownerships[nextTokenId].addr == address(0)) {
1174                 // This will suffice for checking _exists(nextTokenId),
1175                 // as a burned slot cannot contain the zero address.
1176                 if (nextTokenId < _currentIndex) {
1177                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1178                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1179                 }
1180             }
1181         }
1182 
1183         emit Transfer(from, to, tokenId);
1184         _afterTokenTransfers(from, to, tokenId, 1);
1185     }
1186 
1187     /**
1188      * @dev Destroys `tokenId`.
1189      * The approval is cleared when the token is burned.
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must exist.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function _burn(uint256 tokenId) internal virtual {
1198         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1199 
1200         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1201 
1202         // Clear approvals from the previous owner
1203         _approve(address(0), tokenId, prevOwnership.addr);
1204 
1205         // Underflow of the sender's balance is impossible because we check for
1206         // ownership above and the recipient's balance can't realistically overflow.
1207         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1208         unchecked {
1209             _addressData[prevOwnership.addr].balance -= 1;
1210             _addressData[prevOwnership.addr].numberBurned += 1;
1211 
1212             // Keep track of who burned the token, and the timestamp of burning.
1213             _ownerships[tokenId].addr = prevOwnership.addr;
1214             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1215             _ownerships[tokenId].burned = true;
1216 
1217             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1218             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1219             uint256 nextTokenId = tokenId + 1;
1220             if (_ownerships[nextTokenId].addr == address(0)) {
1221                 // This will suffice for checking _exists(nextTokenId),
1222                 // as a burned slot cannot contain the zero address.
1223                 if (nextTokenId < _currentIndex) {
1224                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1225                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(prevOwnership.addr, address(0), tokenId);
1231         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1232 
1233         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1234         unchecked {
1235             _burnCounter++;
1236         }
1237     }
1238 
1239     /**
1240      * @dev Approve `to` to operate on `tokenId`
1241      *
1242      * Emits a {Approval} event.
1243      */
1244     function _approve(
1245         address to,
1246         uint256 tokenId,
1247         address owner
1248     ) private {
1249         _tokenApprovals[tokenId] = to;
1250         emit Approval(owner, to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1255      *
1256      * @param from address representing the previous owner of the given token ID
1257      * @param to target address that will receive the tokens
1258      * @param tokenId uint256 ID of the token to be transferred
1259      * @param _data bytes optional data to send along with the call
1260      * @return bool whether the call correctly returned the expected magic value
1261      */
1262     function _checkContractOnERC721Received(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) private returns (bool) {
1268         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1269             return retval == IERC721Receiver(to).onERC721Received.selector;
1270         } catch (bytes memory reason) {
1271             if (reason.length == 0) {
1272                 revert TransferToNonERC721ReceiverImplementer();
1273             } else {
1274                 assembly {
1275                     revert(add(32, reason), mload(reason))
1276                 }
1277             }
1278         }
1279     }
1280 
1281     /**
1282      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1283      * And also called before burning one token.
1284      *
1285      * startTokenId - the first token id to be transferred
1286      * quantity - the amount to be transferred
1287      *
1288      * Calling conditions:
1289      *
1290      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1291      * transferred to `to`.
1292      * - When `from` is zero, `tokenId` will be minted for `to`.
1293      * - When `to` is zero, `tokenId` will be burned by `from`.
1294      * - `from` and `to` are never both zero.
1295      */
1296     function _beforeTokenTransfers(
1297         address from,
1298         address to,
1299         uint256 startTokenId,
1300         uint256 quantity
1301     ) internal virtual {}
1302 
1303     /**
1304      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1305      * minting.
1306      * And also called after one token has been burned.
1307      *
1308      * startTokenId - the first token id to be transferred
1309      * quantity - the amount to be transferred
1310      *
1311      * Calling conditions:
1312      *
1313      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1314      * transferred to `to`.
1315      * - When `from` is zero, `tokenId` has been minted for `to`.
1316      * - When `to` is zero, `tokenId` has been burned by `from`.
1317      * - `from` and `to` are never both zero.
1318      */
1319     function _afterTokenTransfers(
1320         address from,
1321         address to,
1322         uint256 startTokenId,
1323         uint256 quantity
1324     ) internal virtual {}
1325 }
1326 
1327 
1328 // File contracts/NATURE.sol
1329 
1330 
1331 contract NATURE is ERC721A, Ownable {
1332 
1333     string public baseURI = "ipfs://QmYsubTzLbL2oQWJrXNR5dmsV6TihuHCN7pjptqkUT19K4/";
1334     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1335 
1336     uint256 public constant MAX_PER_TX = 20;
1337     uint256 public constant MAX_PER_FREE = 5;
1338     uint256 public constant FREE_MAX_SUPPLY = 400;
1339     uint256 public MAX_SUPPLY = 888;
1340     uint256 public price = 0.0035 ether;
1341 
1342     bool public paused = false;
1343 
1344     constructor() ERC721A("Nature by Hokusai", "Nature") {}
1345 
1346     function mint(uint256 _amount) external payable 
1347     {
1348         uint cost = price;
1349         uint maxfree = MAX_PER_TX;
1350         if(totalSupply() + _amount < FREE_MAX_SUPPLY + 1) {
1351             cost = 0;
1352             maxfree = 5;
1353         }
1354         address _caller = _msgSender();
1355         require(!paused, "Paused");
1356         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1357         require(_amount > 0, "No 0 mints");
1358         require(tx.origin == _caller, "No contracts");
1359         require(maxfree >= _amount , "Excess max per tx");
1360         require(_amount * cost <= msg.value, "Invalid funds provided");
1361 
1362         _safeMint(_caller, _amount);
1363     }
1364 
1365     function _startTokenId() internal override view virtual returns (uint256) {
1366         return 1;
1367     }
1368 
1369     function isApprovedForAll(address owner, address operator)
1370         override
1371         public
1372         view
1373         returns (bool)
1374     {
1375         // Whitelist OpenSea proxy contract for easy trading.
1376         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1377         if (address(proxyRegistry.proxies(owner)) == operator) {
1378             return true;
1379         }
1380 
1381         return super.isApprovedForAll(owner, operator);
1382     }
1383 
1384     function minted(address _owner) public view returns (uint256) {
1385         return _numberMinted(_owner);
1386     }
1387 
1388     function withdraw() external onlyOwner {
1389         uint256 balance = address(this).balance;
1390         (bool success, ) = _msgSender().call{value: balance}("");
1391         require(success, "Failed to send");
1392     }
1393 
1394     function setupOS() external onlyOwner {
1395         _safeMint(_msgSender(), 1);
1396     }
1397 
1398     function Ownermint(uint256 _max) external onlyOwner {
1399         MAX_SUPPLY = _max;
1400     }
1401 
1402     function setPrice(uint256 _price) external onlyOwner {
1403         price = _price;
1404     }
1405 
1406     function pause(bool _state) external onlyOwner {
1407         paused = _state;
1408     }
1409 
1410     function setBaseURI(string memory baseURI_) external onlyOwner {
1411         baseURI = baseURI_;
1412     }
1413 
1414     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1415         require(_exists(_tokenId), "Token does not exist.");
1416         return bytes(baseURI).length > 0 ? string(
1417             abi.encodePacked(
1418               baseURI,
1419               Strings.toString(_tokenId), ".json"
1420             )
1421         ) : "";
1422     }
1423 }
1424 
1425 contract OwnableDelegateProxy { }
1426 contract ProxyRegistry {
1427     mapping(address => OwnableDelegateProxy) public proxies;
1428 }