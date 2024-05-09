1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 
211 /**
212  * @dev Implementation of the {IERC165} interface.
213  *
214  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
215  * for the additional interface id that will be supported. For example:
216  *
217  * ```solidity
218  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
219  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
220  * }
221  * ```
222  *
223  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
224  */
225 abstract contract ERC165 is IERC165 {
226     /**
227      * @dev See {IERC165-supportsInterface}.
228      */
229     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
230         return interfaceId == type(IERC165).interfaceId;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
235 
236 
237 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @title ERC721 token receiver interface
243  * @dev Interface for any contract that wants to support safeTransfers
244  * from ERC721 asset contracts.
245  */
246 interface IERC721Receiver {
247     /**
248      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
249      * by `operator` from `from`, this function is called.
250      *
251      * It must return its Solidity selector to confirm the token transfer.
252      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
253      *
254      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
255      */
256     function onERC721Received(
257         address operator,
258         address from,
259         uint256 tokenId,
260         bytes calldata data
261     ) external returns (bytes4);
262 }
263 
264 // File: @openzeppelin/contracts/utils/Context.sol
265 
266 
267 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @dev Provides information about the current execution context, including the
273  * sender of the transaction and its data. While these are generally available
274  * via msg.sender and msg.data, they should not be accessed in such a direct
275  * manner, since when dealing with meta-transactions the account sending and
276  * paying for execution may not be the actual sender (as far as an application
277  * is concerned).
278  *
279  * This contract is only required for intermediate, library-like contracts.
280  */
281 abstract contract Context {
282     function _msgSender() internal view virtual returns (address) {
283         return msg.sender;
284     }
285 
286     function _msgData() internal view virtual returns (bytes calldata) {
287         return msg.data;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/access/Ownable.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 
299 /**
300  * @dev Contract module which provides a basic access control mechanism, where
301  * there is an account (an owner) that can be granted exclusive access to
302  * specific functions.
303  *
304  * By default, the owner account will be the one that deploys the contract. This
305  * can later be changed with {transferOwnership}.
306  *
307  * This module is used through inheritance. It will make available the modifier
308  * `onlyOwner`, which can be applied to your functions to restrict their use to
309  * the owner.
310  */
311 abstract contract Ownable is Context {
312     address private _owner;
313 
314     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
315 
316     /**
317      * @dev Initializes the contract setting the deployer as the initial owner.
318      */
319     constructor() {
320         _transferOwnership(_msgSender());
321     }
322 
323     /**
324      * @dev Returns the address of the current owner.
325      */
326     function owner() public view virtual returns (address) {
327         return _owner;
328     }
329 
330     /**
331      * @dev Throws if called by any account other than the owner.
332      */
333     modifier onlyOwner() {
334         require(owner() == _msgSender(), "Ownable: caller is not the owner");
335         _;
336     }
337 
338     /**
339      * @dev Leaves the contract without owner. It will not be possible to call
340      * `onlyOwner` functions anymore. Can only be called by the current owner.
341      *
342      * NOTE: Renouncing ownership will leave the contract without an owner,
343      * thereby removing any functionality that is only available to the owner.
344      */
345     function renounceOwnership() public virtual onlyOwner {
346         _transferOwnership(address(0));
347     }
348 
349     /**
350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
351      * Can only be called by the current owner.
352      */
353     function transferOwnership(address newOwner) public virtual onlyOwner {
354         require(newOwner != address(0), "Ownable: new owner is the zero address");
355         _transferOwnership(newOwner);
356     }
357 
358     /**
359      * @dev Transfers ownership of the contract to a new account (`newOwner`).
360      * Internal function without access restriction.
361      */
362     function _transferOwnership(address newOwner) internal virtual {
363         address oldOwner = _owner;
364         _owner = newOwner;
365         emit OwnershipTransferred(oldOwner, newOwner);
366     }
367 }
368 
369 // File: @openzeppelin/contracts/utils/Address.sol
370 
371 
372 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
373 
374 pragma solidity ^0.8.1;
375 
376 /**
377  * @dev Collection of functions related to the address type
378  */
379 library Address {
380     /**
381      * @dev Returns true if `account` is a contract.
382      *
383      * [IMPORTANT]
384      * ====
385      * It is unsafe to assume that an address for which this function returns
386      * false is an externally-owned account (EOA) and not a contract.
387      *
388      * Among others, `isContract` will return false for the following
389      * types of addresses:
390      *
391      *  - an externally-owned account
392      *  - a contract in construction
393      *  - an address where a contract will be created
394      *  - an address where a contract lived, but was destroyed
395      * ====
396      *
397      * [IMPORTANT]
398      * ====
399      * You shouldn't rely on `isContract` to protect against flash loan attacks!
400      *
401      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
402      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
403      * constructor.
404      * ====
405      */
406     function isContract(address account) internal view returns (bool) {
407         // This method relies on extcodesize/address.code.length, which returns 0
408         // for contracts in construction, since the code is only stored at the end
409         // of the constructor execution.
410 
411         return account.code.length > 0;
412     }
413 
414     /**
415      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
416      * `recipient`, forwarding all available gas and reverting on errors.
417      *
418      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
419      * of certain opcodes, possibly making contracts go over the 2300 gas limit
420      * imposed by `transfer`, making them unable to receive funds via
421      * `transfer`. {sendValue} removes this limitation.
422      *
423      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
424      *
425      * IMPORTANT: because control is transferred to `recipient`, care must be
426      * taken to not create reentrancy vulnerabilities. Consider using
427      * {ReentrancyGuard} or the
428      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
429      */
430     function sendValue(address payable recipient, uint256 amount) internal {
431         require(address(this).balance >= amount, "Address: insufficient balance");
432 
433         (bool success, ) = recipient.call{value: amount}("");
434         require(success, "Address: unable to send value, recipient may have reverted");
435     }
436 
437     /**
438      * @dev Performs a Solidity function call using a low level `call`. A
439      * plain `call` is an unsafe replacement for a function call: use this
440      * function instead.
441      *
442      * If `target` reverts with a revert reason, it is bubbled up by this
443      * function (like regular Solidity function calls).
444      *
445      * Returns the raw returned data. To convert to the expected return value,
446      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
447      *
448      * Requirements:
449      *
450      * - `target` must be a contract.
451      * - calling `target` with `data` must not revert.
452      *
453      * _Available since v3.1._
454      */
455     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
456         return functionCall(target, data, "Address: low-level call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
461      * `errorMessage` as a fallback revert reason when `target` reverts.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         return functionCallWithValue(target, data, 0, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but also transferring `value` wei to `target`.
476      *
477      * Requirements:
478      *
479      * - the calling contract must have an ETH balance of at least `value`.
480      * - the called Solidity function must be `payable`.
481      *
482      * _Available since v3.1._
483      */
484     function functionCallWithValue(
485         address target,
486         bytes memory data,
487         uint256 value
488     ) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
494      * with `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(
499         address target,
500         bytes memory data,
501         uint256 value,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         require(address(this).balance >= value, "Address: insufficient balance for call");
505         require(isContract(target), "Address: call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.call{value: value}(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but performing a static call.
514      *
515      * _Available since v3.3._
516      */
517     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
518         return functionStaticCall(target, data, "Address: low-level static call failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal view returns (bytes memory) {
532         require(isContract(target), "Address: static call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.staticcall(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but performing a delegate call.
541      *
542      * _Available since v3.4._
543      */
544     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
545         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
550      * but performing a delegate call.
551      *
552      * _Available since v3.4._
553      */
554     function functionDelegateCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal returns (bytes memory) {
559         require(isContract(target), "Address: delegate call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.delegatecall(data);
562         return verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
567      * revert reason using the provided one.
568      *
569      * _Available since v4.3._
570      */
571     function verifyCallResult(
572         bool success,
573         bytes memory returndata,
574         string memory errorMessage
575     ) internal pure returns (bytes memory) {
576         if (success) {
577             return returndata;
578         } else {
579             // Look for revert reason and bubble it up if present
580             if (returndata.length > 0) {
581                 // The easiest way to bubble the revert reason is using memory via assembly
582 
583                 assembly {
584                     let returndata_size := mload(returndata)
585                     revert(add(32, returndata), returndata_size)
586                 }
587             } else {
588                 revert(errorMessage);
589             }
590         }
591     }
592 }
593 
594 // File: @openzeppelin/contracts/utils/Strings.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev String operations.
603  */
604 library Strings {
605     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
609      */
610     function toString(uint256 value) internal pure returns (string memory) {
611         // Inspired by OraclizeAPI's implementation - MIT licence
612         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
613 
614         if (value == 0) {
615             return "0";
616         }
617         uint256 temp = value;
618         uint256 digits;
619         while (temp != 0) {
620             digits++;
621             temp /= 10;
622         }
623         bytes memory buffer = new bytes(digits);
624         while (value != 0) {
625             digits -= 1;
626             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
627             value /= 10;
628         }
629         return string(buffer);
630     }
631 
632     /**
633      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
634      */
635     function toHexString(uint256 value) internal pure returns (string memory) {
636         if (value == 0) {
637             return "0x00";
638         }
639         uint256 temp = value;
640         uint256 length = 0;
641         while (temp != 0) {
642             length++;
643             temp >>= 8;
644         }
645         return toHexString(value, length);
646     }
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
650      */
651     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
652         bytes memory buffer = new bytes(2 * length + 2);
653         buffer[0] = "0";
654         buffer[1] = "x";
655         for (uint256 i = 2 * length + 1; i > 1; --i) {
656             buffer[i] = _HEX_SYMBOLS[value & 0xf];
657             value >>= 4;
658         }
659         require(value == 0, "Strings: hex length insufficient");
660         return string(buffer);
661     }
662 }
663 
664 // File: contracts/ZombieBananaBunch.sol
665 
666 
667 pragma solidity ^0.8.7;
668 
669 
670 
671 
672 
673 
674 
675 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
676 
677 pragma solidity ^0.8.4;
678 
679 error ApprovalCallerNotOwnerNorApproved();
680 error ApprovalQueryForNonexistentToken();
681 error ApproveToCaller();
682 error ApprovalToCurrentOwner();
683 error BalanceQueryForZeroAddress();
684 error MintedQueryForZeroAddress();
685 error BurnedQueryForZeroAddress();
686 error AuxQueryForZeroAddress();
687 error MintToZeroAddress();
688 error MintZeroQuantity();
689 error OwnerIndexOutOfBounds();
690 error OwnerQueryForNonexistentToken();
691 error TokenIndexOutOfBounds();
692 error TransferCallerNotOwnerNorApproved();
693 error TransferFromIncorrectOwner();
694 error TransferToNonERC721ReceiverImplementer();
695 error TransferToZeroAddress();
696 error URIQueryForNonexistentToken();
697 
698 /**
699  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
700  * the Metadata extension. Built to optimize for lower gas during batch mints.
701  *
702  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
703  *
704  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
705  *
706  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
707  */
708 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
709     using Address for address;
710     using Strings for uint256;
711 
712     // Compiler will pack this into a single 256bit word.
713     struct TokenOwnership {
714         // The address of the owner.
715         address addr;
716         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
717         uint64 startTimestamp;
718         // Whether the token has been burned.
719         bool burned;
720     }
721 
722     // Compiler will pack this into a single 256bit word.
723     struct AddressData {
724         // Realistically, 2**64-1 is more than enough.
725         uint64 balance;
726         // Keeps track of mint count with minimal overhead for tokenomics.
727         uint64 numberMinted;
728         // Keeps track of burn count with minimal overhead for tokenomics.
729         uint64 numberBurned;
730         // For miscellaneous variable(s) pertaining to the address
731         // (e.g. number of whitelist mint slots used). 
732         // If there are multiple variables, please pack them into a uint64.
733         uint64 aux;
734     }
735 
736     // The tokenId of the next token to be minted.
737     uint256 internal _currentIndex;
738 
739     // The number of tokens burned.
740     uint256 internal _burnCounter;
741 
742     // Token name
743     string private _name;
744 
745     // Token symbol
746     string private _symbol;
747 
748     // Mapping from token ID to ownership details
749     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
750     mapping(uint256 => TokenOwnership) internal _ownerships;
751 
752     // Mapping owner address to address data
753     mapping(address => AddressData) private _addressData;
754 
755     // Mapping from token ID to approved address
756     mapping(uint256 => address) private _tokenApprovals;
757 
758     // Mapping from owner to operator approvals
759     mapping(address => mapping(address => bool)) private _operatorApprovals;
760 
761     constructor(string memory name_, string memory symbol_) {
762         _name = name_;
763         _symbol = symbol_;
764     }
765 
766     /**
767      * @dev See {IERC721Enumerable-totalSupply}.
768      */
769     function totalSupply() public view returns (uint256) {
770         // Counter underflow is impossible as _burnCounter cannot be incremented
771         // more than _currentIndex times
772         unchecked {
773             return _currentIndex - _burnCounter;    
774         }
775     }
776 
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
781         return
782             interfaceId == type(IERC721).interfaceId ||
783             interfaceId == type(IERC721Metadata).interfaceId ||
784             super.supportsInterface(interfaceId);
785     }
786 
787     /**
788      * @dev See {IERC721-balanceOf}.
789      */
790     function balanceOf(address owner) public view override returns (uint256) {
791         if (owner == address(0)) revert BalanceQueryForZeroAddress();
792         return uint256(_addressData[owner].balance);
793     }
794 
795     /**
796      * Returns the number of tokens minted by `owner`.
797      */
798     function _numberMinted(address owner) internal view returns (uint256) {
799         if (owner == address(0)) revert MintedQueryForZeroAddress();
800         return uint256(_addressData[owner].numberMinted);
801     }
802 
803     /**
804      * Returns the number of tokens burned by or on behalf of `owner`.
805      */
806     function _numberBurned(address owner) internal view returns (uint256) {
807         if (owner == address(0)) revert BurnedQueryForZeroAddress();
808         return uint256(_addressData[owner].numberBurned);
809     }
810 
811     /**
812      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
813      */
814     function _getAux(address owner) internal view returns (uint64) {
815         if (owner == address(0)) revert AuxQueryForZeroAddress();
816         return _addressData[owner].aux;
817     }
818 
819     /**
820      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
821      * If there are multiple variables, please pack them into a uint64.
822      */
823     function _setAux(address owner, uint64 aux) internal {
824         if (owner == address(0)) revert AuxQueryForZeroAddress();
825         _addressData[owner].aux = aux;
826     }
827 
828     /**
829      * Gas spent here starts off proportional to the maximum mint batch size.
830      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
831      */
832     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
833         uint256 curr = tokenId;
834 
835         unchecked {
836             if (curr < _currentIndex) {
837                 TokenOwnership memory ownership = _ownerships[curr];
838                 if (!ownership.burned) {
839                     if (ownership.addr != address(0)) {
840                         return ownership;
841                     }
842                     // Invariant: 
843                     // There will always be an ownership that has an address and is not burned 
844                     // before an ownership that does not have an address and is not burned.
845                     // Hence, curr will not underflow.
846                     while (true) {
847                         curr--;
848                         ownership = _ownerships[curr];
849                         if (ownership.addr != address(0)) {
850                             return ownership;
851                         }
852                     }
853                 }
854             }
855         }
856         revert OwnerQueryForNonexistentToken();
857     }
858 
859     /**
860      * @dev See {IERC721-ownerOf}.
861      */
862     function ownerOf(uint256 tokenId) public view override returns (address) {
863         return ownershipOf(tokenId).addr;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-name}.
868      */
869     function name() public view virtual override returns (string memory) {
870         return _name;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-symbol}.
875      */
876     function symbol() public view virtual override returns (string memory) {
877         return _symbol;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-tokenURI}.
882      */
883     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
884         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
885 
886         string memory baseURI = _baseURI();
887         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
888     }
889 
890     /**
891      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
892      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
893      * by default, can be overriden in child contracts.
894      */
895     function _baseURI() internal view virtual returns (string memory) {
896         return '';
897     }
898 
899     /**
900      * @dev See {IERC721-approve}.
901      */
902     function approve(address to, uint256 tokenId) public override {
903         address owner = ERC721A.ownerOf(tokenId);
904         if (to == owner) revert ApprovalToCurrentOwner();
905 
906         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
907             revert ApprovalCallerNotOwnerNorApproved();
908         }
909 
910         _approve(to, tokenId, owner);
911     }
912 
913     /**
914      * @dev See {IERC721-getApproved}.
915      */
916     function getApproved(uint256 tokenId) public view override returns (address) {
917         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
918 
919         return _tokenApprovals[tokenId];
920     }
921 
922     /**
923      * @dev See {IERC721-setApprovalForAll}.
924      */
925     function setApprovalForAll(address operator, bool approved) public override {
926         if (operator == _msgSender()) revert ApproveToCaller();
927 
928         _operatorApprovals[_msgSender()][operator] = approved;
929         emit ApprovalForAll(_msgSender(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
936         return _operatorApprovals[owner][operator];
937     }
938 
939     /**
940      * @dev See {IERC721-transferFrom}.
941      */
942     function transferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public virtual override {
947         _transfer(from, to, tokenId);
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public virtual override {
958         safeTransferFrom(from, to, tokenId, '');
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) public virtual override {
970         _transfer(from, to, tokenId);
971         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
972             revert TransferToNonERC721ReceiverImplementer();
973         }
974     }
975 
976     /**
977      * @dev Returns whether `tokenId` exists.
978      *
979      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
980      *
981      * Tokens start existing when they are minted (`_mint`),
982      */
983     function _exists(uint256 tokenId) internal view returns (bool) {
984         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
985     }
986 
987     function _safeMint(address to, uint256 quantity) internal {
988         _safeMint(to, quantity, '');
989     }
990 
991     /**
992      * @dev Safely mints `quantity` tokens and transfers them to `to`.
993      *
994      * Requirements:
995      *
996      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
997      * - `quantity` must be greater than 0.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _safeMint(
1002         address to,
1003         uint256 quantity,
1004         bytes memory _data
1005     ) internal {
1006         _mint(to, quantity, _data, true);
1007     }
1008 
1009     /**
1010      * @dev Mints `quantity` tokens and transfers them to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `quantity` must be greater than 0.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _mint(
1020         address to,
1021         uint256 quantity,
1022         bytes memory _data,
1023         bool safe
1024     ) internal {
1025         uint256 startTokenId = _currentIndex;
1026         if (to == address(0)) revert MintToZeroAddress();
1027         if (quantity == 0) revert MintZeroQuantity();
1028 
1029         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1030 
1031         // Overflows are incredibly unrealistic.
1032         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1033         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1034         unchecked {
1035             _addressData[to].balance += uint64(quantity);
1036             _addressData[to].numberMinted += uint64(quantity);
1037 
1038             _ownerships[startTokenId].addr = to;
1039             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1040 
1041             uint256 updatedIndex = startTokenId;
1042 
1043             for (uint256 i; i < quantity; i++) {
1044                 emit Transfer(address(0), to, updatedIndex);
1045                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1046                     revert TransferToNonERC721ReceiverImplementer();
1047                 }
1048                 updatedIndex++;
1049             }
1050 
1051             _currentIndex = updatedIndex;
1052         }
1053         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1054     }
1055 
1056     /**
1057      * @dev Transfers `tokenId` from `from` to `to`.
1058      *
1059      * Requirements:
1060      *
1061      * - `to` cannot be the zero address.
1062      * - `tokenId` token must be owned by `from`.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _transfer(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) private {
1071         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1072 
1073         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1074             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1075             getApproved(tokenId) == _msgSender());
1076 
1077         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1078         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1079         if (to == address(0)) revert TransferToZeroAddress();
1080 
1081         _beforeTokenTransfers(from, to, tokenId, 1);
1082 
1083         // Clear approvals from the previous owner
1084         _approve(address(0), tokenId, prevOwnership.addr);
1085 
1086         // Underflow of the sender's balance is impossible because we check for
1087         // ownership above and the recipient's balance can't realistically overflow.
1088         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1089         unchecked {
1090             _addressData[from].balance -= 1;
1091             _addressData[to].balance += 1;
1092 
1093             _ownerships[tokenId].addr = to;
1094             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1095 
1096             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1097             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1098             uint256 nextTokenId = tokenId + 1;
1099             if (_ownerships[nextTokenId].addr == address(0)) {
1100                 // This will suffice for checking _exists(nextTokenId),
1101                 // as a burned slot cannot contain the zero address.
1102                 if (nextTokenId < _currentIndex) {
1103                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1104                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1105                 }
1106             }
1107         }
1108 
1109         emit Transfer(from, to, tokenId);
1110         _afterTokenTransfers(from, to, tokenId, 1);
1111     }
1112 
1113     /**
1114      * @dev Destroys `tokenId`.
1115      * The approval is cleared when the token is burned.
1116      *
1117      * Requirements:
1118      *
1119      * - `tokenId` must exist.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _burn(uint256 tokenId) internal virtual {
1124         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1125 
1126         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1127 
1128         // Clear approvals from the previous owner
1129         _approve(address(0), tokenId, prevOwnership.addr);
1130 
1131         // Underflow of the sender's balance is impossible because we check for
1132         // ownership above and the recipient's balance can't realistically overflow.
1133         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1134         unchecked {
1135             _addressData[prevOwnership.addr].balance -= 1;
1136             _addressData[prevOwnership.addr].numberBurned += 1;
1137 
1138             // Keep track of who burned the token, and the timestamp of burning.
1139             _ownerships[tokenId].addr = prevOwnership.addr;
1140             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1141             _ownerships[tokenId].burned = true;
1142 
1143             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1144             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1145             uint256 nextTokenId = tokenId + 1;
1146             if (_ownerships[nextTokenId].addr == address(0)) {
1147                 // This will suffice for checking _exists(nextTokenId),
1148                 // as a burned slot cannot contain the zero address.
1149                 if (nextTokenId < _currentIndex) {
1150                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1151                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1152                 }
1153             }
1154         }
1155 
1156         emit Transfer(prevOwnership.addr, address(0), tokenId);
1157         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1158 
1159         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1160         unchecked { 
1161             _burnCounter++;
1162         }
1163     }
1164 
1165     /**
1166      * @dev Approve `to` to operate on `tokenId`
1167      *
1168      * Emits a {Approval} event.
1169      */
1170     function _approve(
1171         address to,
1172         uint256 tokenId,
1173         address owner
1174     ) private {
1175         _tokenApprovals[tokenId] = to;
1176         emit Approval(owner, to, tokenId);
1177     }
1178 
1179     /**
1180      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1181      * The call is not executed if the target address is not a contract.
1182      *
1183      * @param from address representing the previous owner of the given token ID
1184      * @param to target address that will receive the tokens
1185      * @param tokenId uint256 ID of the token to be transferred
1186      * @param _data bytes optional data to send along with the call
1187      * @return bool whether the call correctly returned the expected magic value
1188      */
1189     function _checkOnERC721Received(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) private returns (bool) {
1195         if (to.isContract()) {
1196             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1197                 return retval == IERC721Receiver(to).onERC721Received.selector;
1198             } catch (bytes memory reason) {
1199                 if (reason.length == 0) {
1200                     revert TransferToNonERC721ReceiverImplementer();
1201                 } else {
1202                     assembly {
1203                         revert(add(32, reason), mload(reason))
1204                     }
1205                 }
1206             }
1207         } else {
1208             return true;
1209         }
1210     }
1211 
1212     /**
1213      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1214      * And also called before burning one token.
1215      *
1216      * startTokenId - the first token id to be transferred
1217      * quantity - the amount to be transferred
1218      *
1219      * Calling conditions:
1220      *
1221      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1222      * transferred to `to`.
1223      * - When `from` is zero, `tokenId` will be minted for `to`.
1224      * - When `to` is zero, `tokenId` will be burned by `from`.
1225      * - `from` and `to` are never both zero.
1226      */
1227     function _beforeTokenTransfers(
1228         address from,
1229         address to,
1230         uint256 startTokenId,
1231         uint256 quantity
1232     ) internal virtual {}
1233 
1234     /**
1235      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1236      * minting.
1237      * And also called after one token has been burned.
1238      *
1239      * startTokenId - the first token id to be transferred
1240      * quantity - the amount to be transferred
1241      *
1242      * Calling conditions:
1243      *
1244      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1245      * transferred to `to`.
1246      * - When `from` is zero, `tokenId` has been minted for `to`.
1247      * - When `to` is zero, `tokenId` has been burned by `from`.
1248      * - `from` and `to` are never both zero.
1249      */
1250     function _afterTokenTransfers(
1251         address from,
1252         address to,
1253         uint256 startTokenId,
1254         uint256 quantity
1255     ) internal virtual {}
1256 }
1257 
1258 contract ZombieBananaBunch is ERC721A, Ownable {
1259     using Strings for uint256;
1260     
1261     uint256 public MAX_SUPPLY = 6969;
1262     uint256 public FREE_SUPPLY = 696;
1263 
1264     string private BASE_URI;
1265     string private UNREVEAL_URI;
1266 
1267     uint256 public FREE_MINT_LIMIT = 1;
1268     
1269     uint256 public COST = 0.01 ether;
1270 
1271     uint256 public SALE_STEP = 0; // 0 => NONE, 1 => OPEN
1272 
1273     constructor() ERC721A("Zombie Banana Bunch", "ZBB") {}
1274 
1275     function setFreeMintLimit(uint256 _freeMintLimit) external onlyOwner {
1276         FREE_MINT_LIMIT = _freeMintLimit;
1277     }
1278     
1279     function setCost(uint256 _cost) external onlyOwner {
1280         COST = _cost;
1281     }
1282 
1283     function numberMinted(address _owner) public view returns (uint256) {
1284         return _numberMinted(_owner);
1285     }
1286 
1287     function mint(uint256 _mintAmount) external payable {
1288         require(SALE_STEP == 1, "Sale is not opened");
1289 
1290         if (totalSupply() < FREE_SUPPLY) {
1291             require(numberMinted(msg.sender) < FREE_MINT_LIMIT, "Exceeds Free Mint Amount");
1292 
1293             _mintLoop(msg.sender, 1);
1294         } else {
1295             require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1296 
1297             require(msg.value >= COST * _mintAmount, "Insuffient funds");
1298 
1299             _mintLoop(msg.sender, _mintAmount);
1300         }
1301     }
1302 
1303     function airdrop(address[] memory _airdropAddresses, uint256 _mintAmount) external onlyOwner {
1304         require(totalSupply() + _airdropAddresses.length * _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1305 
1306         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1307             address to = _airdropAddresses[i];
1308             _mintLoop(to, _mintAmount);
1309         }
1310     }
1311 
1312     function _baseURI() internal view virtual override returns (string memory) {
1313         return BASE_URI;
1314     }
1315 
1316     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1317         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1318         string memory currentBaseURI = _baseURI();
1319         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : UNREVEAL_URI;
1320     }
1321 
1322     function setMaxSupply(uint256 _supply) external onlyOwner {
1323         MAX_SUPPLY = _supply;
1324     }
1325 
1326     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1327         BASE_URI = _newBaseURI;
1328     }
1329 
1330     function setUnrevealURI(string memory _newUnrevealURI) external onlyOwner {
1331         UNREVEAL_URI = _newUnrevealURI;
1332     }
1333 
1334     function setSaleStep(uint256 _saleStep) external onlyOwner {
1335         SALE_STEP = _saleStep;
1336     }
1337 
1338     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1339         _safeMint(_receiver, _mintAmount);
1340     }
1341 
1342     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1343         return ownershipOf(tokenId);
1344     }
1345 
1346     function withdraw() external onlyOwner {
1347         uint256 curBalance = address(this).balance;
1348         payable(msg.sender).transfer(curBalance);
1349     }
1350 }