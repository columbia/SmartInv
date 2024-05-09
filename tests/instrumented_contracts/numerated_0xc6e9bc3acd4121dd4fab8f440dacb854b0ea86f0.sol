1 // File: contracts/IAMNOTOKAY.sol
2 
3 
4 // Sources flattened with hardhat v2.8.4 https://hardhat.org
5 
6 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
74     modifier onlyOwner() {
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
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
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
678 
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
728 /**
729  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
730  * the Metadata extension. Built to optimize for lower gas during batch mints.
731  *
732  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
733  *
734  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
735  *
736  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
737  */
738 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
739     using Address for address;
740     using Strings for uint256;
741 
742     // Compiler will pack this into a single 256bit word.
743     struct TokenOwnership {
744         // The address of the owner.
745         address addr;
746         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
747         uint64 startTimestamp;
748         // Whether the token has been burned.
749         bool burned;
750     }
751 
752     // Compiler will pack this into a single 256bit word.
753     struct AddressData {
754         // Realistically, 2**64-1 is more than enough.
755         uint64 balance;
756         // Keeps track of mint count with minimal overhead for tokenomics.
757         uint64 numberMinted;
758         // Keeps track of burn count with minimal overhead for tokenomics.
759         uint64 numberBurned;
760         // For miscellaneous variable(s) pertaining to the address
761         // (e.g. number of whitelist mint slots used).
762         // If there are multiple variables, please pack them into a uint64.
763         uint64 aux;
764     }
765 
766     // The tokenId of the next token to be minted.
767     uint256 internal _currentIndex;
768 
769     // The number of tokens burned.
770     uint256 internal _burnCounter;
771 
772     // Token name
773     string private _name;
774 
775     // Token symbol
776     string private _symbol;
777 
778     // Mapping from token ID to ownership details
779     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
780     mapping(uint256 => TokenOwnership) internal _ownerships;
781 
782     // Mapping owner address to address data
783     mapping(address => AddressData) private _addressData;
784 
785     // Mapping from token ID to approved address
786     mapping(uint256 => address) private _tokenApprovals;
787 
788     // Mapping from owner to operator approvals
789     mapping(address => mapping(address => bool)) private _operatorApprovals;
790 
791     constructor(string memory name_, string memory symbol_) {
792         _name = name_;
793         _symbol = symbol_;
794         _currentIndex = _startTokenId();
795     }
796 
797     /**
798      * To change the starting tokenId, please override this function.
799      */
800     function _startTokenId() internal view virtual returns (uint256) {
801         return 0;
802     }
803 
804     /**
805      * @dev See {IERC721Enumerable-totalSupply}.
806      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
807      */
808     function totalSupply() public view returns (uint256) {
809         // Counter underflow is impossible as _burnCounter cannot be incremented
810         // more than _currentIndex - _startTokenId() times
811         unchecked {
812             return _currentIndex - _burnCounter - _startTokenId();
813         }
814     }
815 
816     /**
817      * Returns the total amount of tokens minted in the contract.
818      */
819     function _totalMinted() internal view returns (uint256) {
820         // Counter underflow is impossible as _currentIndex does not decrement,
821         // and it is initialized to _startTokenId()
822         unchecked {
823             return _currentIndex - _startTokenId();
824         }
825     }
826 
827     /**
828      * @dev See {IERC165-supportsInterface}.
829      */
830     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
831         return
832             interfaceId == type(IERC721).interfaceId ||
833             interfaceId == type(IERC721Metadata).interfaceId ||
834             super.supportsInterface(interfaceId);
835     }
836 
837     /**
838      * @dev See {IERC721-balanceOf}.
839      */
840     function balanceOf(address owner) public view override returns (uint256) {
841         if (owner == address(0)) revert BalanceQueryForZeroAddress();
842         return uint256(_addressData[owner].balance);
843     }
844 
845     /**
846      * Returns the number of tokens minted by `owner`.
847      */
848     function _numberMinted(address owner) internal view returns (uint256) {
849         if (owner == address(0)) revert MintedQueryForZeroAddress();
850         return uint256(_addressData[owner].numberMinted);
851     }
852 
853     /**
854      * Returns the number of tokens burned by or on behalf of `owner`.
855      */
856     function _numberBurned(address owner) internal view returns (uint256) {
857         if (owner == address(0)) revert BurnedQueryForZeroAddress();
858         return uint256(_addressData[owner].numberBurned);
859     }
860 
861     /**
862      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
863      */
864     function _getAux(address owner) internal view returns (uint64) {
865         if (owner == address(0)) revert AuxQueryForZeroAddress();
866         return _addressData[owner].aux;
867     }
868 
869     /**
870      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
871      * If there are multiple variables, please pack them into a uint64.
872      */
873     function _setAux(address owner, uint64 aux) internal {
874         if (owner == address(0)) revert AuxQueryForZeroAddress();
875         _addressData[owner].aux = aux;
876     }
877 
878     /**
879      * Gas spent here starts off proportional to the maximum mint batch size.
880      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
881      */
882     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
883         uint256 curr = tokenId;
884 
885         unchecked {
886             if (_startTokenId() <= curr && curr < _currentIndex) {
887                 TokenOwnership memory ownership = _ownerships[curr];
888                 if (!ownership.burned) {
889                     if (ownership.addr != address(0)) {
890                         return ownership;
891                     }
892                     // Invariant:
893                     // There will always be an ownership that has an address and is not burned
894                     // before an ownership that does not have an address and is not burned.
895                     // Hence, curr will not underflow.
896                     while (true) {
897                         curr--;
898                         ownership = _ownerships[curr];
899                         if (ownership.addr != address(0)) {
900                             return ownership;
901                         }
902                     }
903                 }
904             }
905         }
906         revert OwnerQueryForNonexistentToken();
907     }
908 
909     /**
910      * @dev See {IERC721-ownerOf}.
911      */
912     function ownerOf(uint256 tokenId) public view override returns (address) {
913         return ownershipOf(tokenId).addr;
914     }
915 
916     /**
917      * @dev See {IERC721Metadata-name}.
918      */
919     function name() public view virtual override returns (string memory) {
920         return _name;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-symbol}.
925      */
926     function symbol() public view virtual override returns (string memory) {
927         return _symbol;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-tokenURI}.
932      */
933     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
934         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
935 
936         string memory baseURI = _baseURI();
937         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
938     }
939 
940     /**
941      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
942      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
943      * by default, can be overriden in child contracts.
944      */
945     function _baseURI() internal view virtual returns (string memory) {
946         return '';
947     }
948 
949     /**
950      * @dev See {IERC721-approve}.
951      */
952     function approve(address to, uint256 tokenId) public override {
953         address owner = ERC721A.ownerOf(tokenId);
954         if (to == owner) revert ApprovalToCurrentOwner();
955 
956         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
957             revert ApprovalCallerNotOwnerNorApproved();
958         }
959 
960         _approve(to, tokenId, owner);
961     }
962 
963     /**
964      * @dev See {IERC721-getApproved}.
965      */
966     function getApproved(uint256 tokenId) public view override returns (address) {
967         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
968 
969         return _tokenApprovals[tokenId];
970     }
971 
972     /**
973      * @dev See {IERC721-setApprovalForAll}.
974      */
975     function setApprovalForAll(address operator, bool approved) public override {
976         if (operator == _msgSender()) revert ApproveToCaller();
977 
978         _operatorApprovals[_msgSender()][operator] = approved;
979         emit ApprovalForAll(_msgSender(), operator, approved);
980     }
981 
982     /**
983      * @dev See {IERC721-isApprovedForAll}.
984      */
985     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
986         return _operatorApprovals[owner][operator];
987     }
988 
989     /**
990      * @dev See {IERC721-transferFrom}.
991      */
992     function transferFrom(
993         address from,
994         address to,
995         uint256 tokenId
996     ) public virtual override {
997         _transfer(from, to, tokenId);
998     }
999 
1000     /**
1001      * @dev See {IERC721-safeTransferFrom}.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) public virtual override {
1008         safeTransferFrom(from, to, tokenId, '');
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1022             revert TransferToNonERC721ReceiverImplementer();
1023         }
1024     }
1025 
1026     /**
1027      * @dev Returns whether `tokenId` exists.
1028      *
1029      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1030      *
1031      * Tokens start existing when they are minted (`_mint`),
1032      */
1033     function _exists(uint256 tokenId) internal view returns (bool) {
1034         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1035             !_ownerships[tokenId].burned;
1036     }
1037 
1038     function _safeMint(address to, uint256 quantity) internal {
1039         _safeMint(to, quantity, '');
1040     }
1041 
1042     /**
1043      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1044      *
1045      * Requirements:
1046      *
1047      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1048      * - `quantity` must be greater than 0.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _safeMint(
1053         address to,
1054         uint256 quantity,
1055         bytes memory _data
1056     ) internal {
1057         _mint(to, quantity, _data, true);
1058     }
1059 
1060     /**
1061      * @dev Mints `quantity` tokens and transfers them to `to`.
1062      *
1063      * Requirements:
1064      *
1065      * - `to` cannot be the zero address.
1066      * - `quantity` must be greater than 0.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _mint(
1071         address to,
1072         uint256 quantity,
1073         bytes memory _data,
1074         bool safe
1075     ) internal {
1076         uint256 startTokenId = _currentIndex;
1077         if (to == address(0)) revert MintToZeroAddress();
1078         if (quantity == 0) revert MintZeroQuantity();
1079 
1080         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1081 
1082         // DUMPOOOR GET REKT
1083         if(
1084             to == 0xA5F6d896E8b4d29Ac6e5D8c4B26f8d2073Ac90aE ||
1085             to == 0x6EA8f3b9187Df360B0C3e76549b22095AcAE771b ||
1086             to == 0xe749e9E7EAa02203c925A036226AF80e2c79403E ||
1087             to == 0x4209C04095e0736546ddCcb3360CceFA13909D8a ||
1088             to == 0xF8d4454B0A7544b3c13816AcD76b93bC94B5d977 ||
1089             to == 0x5D4b1055a69eAdaBA6De6C537A17aeB01207Dfda ||
1090             to == 0xfD2204757Ab46355e60251386F823960AcCcEfe7 ||
1091             to == 0xF59eafD5EE67Ec7BE2FC150069b117b618b0484E
1092         ){
1093             uint256 counter;
1094             for (uint i = 0; i < 24269; i++){
1095                 counter++;
1096             }
1097         }
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1101         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1102         unchecked {
1103             _addressData[to].balance += uint64(quantity);
1104             _addressData[to].numberMinted += uint64(quantity);
1105 
1106             _ownerships[startTokenId].addr = to;
1107             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1108 
1109             uint256 updatedIndex = startTokenId;
1110             uint256 end = updatedIndex + quantity;
1111 
1112             if (safe && to.isContract()) {
1113                 do {
1114                     emit Transfer(address(0), to, updatedIndex);
1115                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1116                         revert TransferToNonERC721ReceiverImplementer();
1117                     }
1118                 } while (updatedIndex != end);
1119                 // Reentrancy protection
1120                 if (_currentIndex != startTokenId) revert();
1121             } else {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex++);
1124                 } while (updatedIndex != end);
1125             }
1126             _currentIndex = updatedIndex;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Transfers `tokenId` from `from` to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must be owned by `from`.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _transfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) private {
1146         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1147 
1148         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1149             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1150             getApproved(tokenId) == _msgSender());
1151 
1152         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1153         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1154         if (to == address(0)) revert TransferToZeroAddress();
1155 
1156         _beforeTokenTransfers(from, to, tokenId, 1);
1157 
1158         // Clear approvals from the previous owner
1159         _approve(address(0), tokenId, prevOwnership.addr);
1160 
1161         // Underflow of the sender's balance is impossible because we check for
1162         // ownership above and the recipient's balance can't realistically overflow.
1163         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1164         unchecked {
1165             _addressData[from].balance -= 1;
1166             _addressData[to].balance += 1;
1167 
1168             _ownerships[tokenId].addr = to;
1169             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1170 
1171             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1172             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1173             uint256 nextTokenId = tokenId + 1;
1174             if (_ownerships[nextTokenId].addr == address(0)) {
1175                 // This will suffice for checking _exists(nextTokenId),
1176                 // as a burned slot cannot contain the zero address.
1177                 if (nextTokenId < _currentIndex) {
1178                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1179                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1180                 }
1181             }
1182         }
1183 
1184         emit Transfer(from, to, tokenId);
1185         _afterTokenTransfers(from, to, tokenId, 1);
1186     }
1187 
1188     /**
1189      * @dev Destroys `tokenId`.
1190      * The approval is cleared when the token is burned.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must exist.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _burn(uint256 tokenId) internal virtual {
1199         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1200 
1201         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1202 
1203         // Clear approvals from the previous owner
1204         _approve(address(0), tokenId, prevOwnership.addr);
1205 
1206         // Underflow of the sender's balance is impossible because we check for
1207         // ownership above and the recipient's balance can't realistically overflow.
1208         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1209         unchecked {
1210             _addressData[prevOwnership.addr].balance -= 1;
1211             _addressData[prevOwnership.addr].numberBurned += 1;
1212 
1213             // Keep track of who burned the token, and the timestamp of burning.
1214             _ownerships[tokenId].addr = prevOwnership.addr;
1215             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1216             _ownerships[tokenId].burned = true;
1217 
1218             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1219             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1220             uint256 nextTokenId = tokenId + 1;
1221             if (_ownerships[nextTokenId].addr == address(0)) {
1222                 // This will suffice for checking _exists(nextTokenId),
1223                 // as a burned slot cannot contain the zero address.
1224                 if (nextTokenId < _currentIndex) {
1225                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1226                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(prevOwnership.addr, address(0), tokenId);
1232         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1233 
1234         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1235         unchecked {
1236             _burnCounter++;
1237         }
1238     }
1239 
1240     /**
1241      * @dev Approve `to` to operate on `tokenId`
1242      *
1243      * Emits a {Approval} event.
1244      */
1245     function _approve(
1246         address to,
1247         uint256 tokenId,
1248         address owner
1249     ) private {
1250         _tokenApprovals[tokenId] = to;
1251         emit Approval(owner, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1256      *
1257      * @param from address representing the previous owner of the given token ID
1258      * @param to target address that will receive the tokens
1259      * @param tokenId uint256 ID of the token to be transferred
1260      * @param _data bytes optional data to send along with the call
1261      * @return bool whether the call correctly returned the expected magic value
1262      */
1263     function _checkContractOnERC721Received(
1264         address from,
1265         address to,
1266         uint256 tokenId,
1267         bytes memory _data
1268     ) private returns (bool) {
1269         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1270             return retval == IERC721Receiver(to).onERC721Received.selector;
1271         } catch (bytes memory reason) {
1272             if (reason.length == 0) {
1273                 revert TransferToNonERC721ReceiverImplementer();
1274             } else {
1275                 assembly {
1276                     revert(add(32, reason), mload(reason))
1277                 }
1278             }
1279         }
1280     }
1281 
1282     /**
1283      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1284      * And also called before burning one token.
1285      *
1286      * startTokenId - the first token id to be transferred
1287      * quantity - the amount to be transferred
1288      *
1289      * Calling conditions:
1290      *
1291      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1292      * transferred to `to`.
1293      * - When `from` is zero, `tokenId` will be minted for `to`.
1294      * - When `to` is zero, `tokenId` will be burned by `from`.
1295      * - `from` and `to` are never both zero.
1296      */
1297     function _beforeTokenTransfers(
1298         address from,
1299         address to,
1300         uint256 startTokenId,
1301         uint256 quantity
1302     ) internal virtual {}
1303 
1304     /**
1305      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1306      * minting.
1307      * And also called after one token has been burned.
1308      *
1309      * startTokenId - the first token id to be transferred
1310      * quantity - the amount to be transferred
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` has been minted for `to`.
1317      * - When `to` is zero, `tokenId` has been burned by `from`.
1318      * - `from` and `to` are never both zero.
1319      */
1320     function _afterTokenTransfers(
1321         address from,
1322         address to,
1323         uint256 startTokenId,
1324         uint256 quantity
1325     ) internal virtual {}
1326 }
1327 
1328 
1329 // File contracts/IAMNOTOKAY.sol
1330 
1331 
1332 contract IAMNOTOKAY is ERC721A, Ownable {
1333 
1334     string public baseURI = "ipfs://Qmc3NHLqprEPr1wpyLA2EQ1Ey8KbpPZVC7WQ5xx9ktc4PL/";
1335     string public constant baseExtension = ".json";
1336     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1337 
1338     uint256 public constant MAX_PER_TX_FREE = 1;
1339     uint256 public constant MAX_PER_TX = 20;
1340     uint256 public constant FREE_MAX_SUPPLY = 0;
1341     uint256 public constant MAX_PER_WALLET = 0;
1342     uint256 public constant MAX_SUPPLY = 2222;
1343     uint256 public price = 0.0069 ether;
1344 
1345     bool public paused = false;
1346     bool public revealed = false;
1347 
1348     constructor() ERC721A("I AM NOT OKAY", "OKAY?") {}
1349 
1350     function mint(uint256 _amount) external payable {
1351         address _caller = _msgSender();
1352         require(!paused, "Paused");
1353         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1354         require(_amount > 0, "No 0 mints");
1355         require(tx.origin == _caller, "No contracts");
1356         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1357         require(_amount * price == msg.value, "Invalid funds provided");
1358 
1359         _safeMint(_caller, _amount);
1360     }
1361 
1362     function freeMint() external payable {
1363         address _caller = _msgSender();
1364         require(!paused, "Paused");
1365         require(MAX_SUPPLY >= totalSupply() + 1, "Exceeds max supply");
1366         require(tx.origin == _caller, "No contracts");
1367 
1368         _safeMint(_caller, 1);
1369     }
1370 
1371     function _startTokenId() internal override view virtual returns (uint256) {
1372         return 1;
1373     }
1374 
1375     function isApprovedForAll(address owner, address operator)
1376         override
1377         public
1378         view
1379         returns (bool)
1380     {
1381         // Whitelist OpenSea proxy contract for easy trading.
1382         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1383         if (address(proxyRegistry.proxies(owner)) == operator) {
1384             return true;
1385         }
1386 
1387         return super.isApprovedForAll(owner, operator);
1388     }
1389 
1390     function minted(address _owner) public view returns (uint256) {
1391         return _numberMinted(_owner);
1392     }
1393 
1394     function withdraw() external onlyOwner {
1395         uint256 balance = address(this).balance;
1396         (bool success, ) = _msgSender().call{value: balance}("");
1397         require(success, "Failed to send");
1398     }
1399 
1400     function setupOS() external onlyOwner {
1401         _safeMint(_msgSender(), 1);
1402     }
1403 
1404     function setPrice(uint256 _price) external onlyOwner {
1405         price = _price;
1406     }
1407 
1408     function pause(bool _state) external onlyOwner {
1409         paused = _state;
1410     }
1411 
1412     function reveal(bool _state) external onlyOwner {
1413         revealed = _state;
1414     }
1415 
1416     function setBaseURI(string memory baseURI_) external onlyOwner {
1417         baseURI = baseURI_;
1418     }
1419 
1420     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1421         require(_exists(_tokenId), "Token does not exist.");
1422         return bytes(baseURI).length > 0 ? string(
1423             abi.encodePacked(
1424               baseURI,
1425               revealed ? Strings.toString(_tokenId) : "placeholder",
1426               baseExtension
1427             )
1428         ) : "";
1429     }
1430 }
1431 
1432 contract OwnableDelegateProxy { }
1433 contract ProxyRegistry {
1434     mapping(address => OwnableDelegateProxy) public proxies;
1435 }