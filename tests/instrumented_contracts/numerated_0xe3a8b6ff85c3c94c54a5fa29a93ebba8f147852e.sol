1 // Sources flattened with hardhat v2.10.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
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
99      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
174 
175 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.0
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
183  * @dev See https://eips.ethereum.org/EIPS/eip-721
184  */
185 interface IERC721Metadata is IERC721 {
186     /**
187      * @dev Returns the token collection name.
188      */
189     function name() external view returns (string memory);
190 
191     /**
192      * @dev Returns the token collection symbol.
193      */
194     function symbol() external view returns (string memory);
195 
196     /**
197      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
198      */
199     function tokenURI(uint256 tokenId) external view returns (string memory);
200 }
201 
202 
203 // File erc721a/contracts/IERC721A.sol@v3.3.0
204 
205 // ERC721A Contracts v3.3.0
206 // Creator: Chiru Labs
207 
208 pragma solidity ^0.8.4;
209 
210 
211 /**
212  * @dev Interface of an ERC721A compliant contract.
213  */
214 interface IERC721A is IERC721, IERC721Metadata {
215     /**
216      * The caller must own the token or be an approved operator.
217      */
218     error ApprovalCallerNotOwnerNorApproved();
219 
220     /**
221      * The token does not exist.
222      */
223     error ApprovalQueryForNonexistentToken();
224 
225     /**
226      * The caller cannot approve to their own address.
227      */
228     error ApproveToCaller();
229 
230     /**
231      * The caller cannot approve to the current owner.
232      */
233     error ApprovalToCurrentOwner();
234 
235     /**
236      * Cannot query the balance for the zero address.
237      */
238     error BalanceQueryForZeroAddress();
239 
240     /**
241      * Cannot mint to the zero address.
242      */
243     error MintToZeroAddress();
244 
245     /**
246      * The quantity of tokens minted must be more than zero.
247      */
248     error MintZeroQuantity();
249 
250     /**
251      * The token does not exist.
252      */
253     error OwnerQueryForNonexistentToken();
254 
255     /**
256      * The caller must own the token or be an approved operator.
257      */
258     error TransferCallerNotOwnerNorApproved();
259 
260     /**
261      * The token must be owned by `from`.
262      */
263     error TransferFromIncorrectOwner();
264 
265     /**
266      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
267      */
268     error TransferToNonERC721ReceiverImplementer();
269 
270     /**
271      * Cannot transfer to the zero address.
272      */
273     error TransferToZeroAddress();
274 
275     /**
276      * The token does not exist.
277      */
278     error URIQueryForNonexistentToken();
279 
280     // Compiler will pack this into a single 256bit word.
281     struct TokenOwnership {
282         // The address of the owner.
283         address addr;
284         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
285         uint64 startTimestamp;
286         // Whether the token has been burned.
287         bool burned;
288     }
289 
290     // Compiler will pack this into a single 256bit word.
291     struct AddressData {
292         // Realistically, 2**64-1 is more than enough.
293         uint64 balance;
294         // Keeps track of mint count with minimal overhead for tokenomics.
295         uint64 numberMinted;
296         // Keeps track of burn count with minimal overhead for tokenomics.
297         uint64 numberBurned;
298         // For miscellaneous variable(s) pertaining to the address
299         // (e.g. number of whitelist mint slots used).
300         // If there are multiple variables, please pack them into a uint64.
301         uint64 aux;
302     }
303 
304     /**
305      * @dev Returns the total amount of tokens stored by the contract.
306      * 
307      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
308      */
309     function totalSupply() external view returns (uint256);
310 }
311 
312 
313 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.0
314 
315 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @title ERC721 token receiver interface
321  * @dev Interface for any contract that wants to support safeTransfers
322  * from ERC721 asset contracts.
323  */
324 interface IERC721Receiver {
325     /**
326      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
327      * by `operator` from `from`, this function is called.
328      *
329      * It must return its Solidity selector to confirm the token transfer.
330      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
331      *
332      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
333      */
334     function onERC721Received(
335         address operator,
336         address from,
337         uint256 tokenId,
338         bytes calldata data
339     ) external returns (bytes4);
340 }
341 
342 
343 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
344 
345 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
346 
347 pragma solidity ^0.8.1;
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      *
370      * [IMPORTANT]
371      * ====
372      * You shouldn't rely on `isContract` to protect against flash loan attacks!
373      *
374      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
375      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
376      * constructor.
377      * ====
378      */
379     function isContract(address account) internal view returns (bool) {
380         // This method relies on extcodesize/address.code.length, which returns 0
381         // for contracts in construction, since the code is only stored at the end
382         // of the constructor execution.
383 
384         return account.code.length > 0;
385     }
386 
387     /**
388      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
389      * `recipient`, forwarding all available gas and reverting on errors.
390      *
391      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
392      * of certain opcodes, possibly making contracts go over the 2300 gas limit
393      * imposed by `transfer`, making them unable to receive funds via
394      * `transfer`. {sendValue} removes this limitation.
395      *
396      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
397      *
398      * IMPORTANT: because control is transferred to `recipient`, care must be
399      * taken to not create reentrancy vulnerabilities. Consider using
400      * {ReentrancyGuard} or the
401      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
402      */
403     function sendValue(address payable recipient, uint256 amount) internal {
404         require(address(this).balance >= amount, "Address: insufficient balance");
405 
406         (bool success, ) = recipient.call{value: amount}("");
407         require(success, "Address: unable to send value, recipient may have reverted");
408     }
409 
410     /**
411      * @dev Performs a Solidity function call using a low level `call`. A
412      * plain `call` is an unsafe replacement for a function call: use this
413      * function instead.
414      *
415      * If `target` reverts with a revert reason, it is bubbled up by this
416      * function (like regular Solidity function calls).
417      *
418      * Returns the raw returned data. To convert to the expected return value,
419      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
420      *
421      * Requirements:
422      *
423      * - `target` must be a contract.
424      * - calling `target` with `data` must not revert.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
429         return functionCall(target, data, "Address: low-level call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
434      * `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, 0, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but also transferring `value` wei to `target`.
449      *
450      * Requirements:
451      *
452      * - the calling contract must have an ETH balance of at least `value`.
453      * - the called Solidity function must be `payable`.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(
458         address target,
459         bytes memory data,
460         uint256 value
461     ) internal returns (bytes memory) {
462         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
467      * with `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(
472         address target,
473         bytes memory data,
474         uint256 value,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(address(this).balance >= value, "Address: insufficient balance for call");
478         require(isContract(target), "Address: call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.call{value: value}(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a static call.
487      *
488      * _Available since v3.3._
489      */
490     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
491         return functionStaticCall(target, data, "Address: low-level static call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a static call.
497      *
498      * _Available since v3.3._
499      */
500     function functionStaticCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal view returns (bytes memory) {
505         require(isContract(target), "Address: static call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.staticcall(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but performing a delegate call.
514      *
515      * _Available since v3.4._
516      */
517     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
518         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a delegate call.
524      *
525      * _Available since v3.4._
526      */
527     function functionDelegateCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(isContract(target), "Address: delegate call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.delegatecall(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
540      * revert reason using the provided one.
541      *
542      * _Available since v4.3._
543      */
544     function verifyCallResult(
545         bool success,
546         bytes memory returndata,
547         string memory errorMessage
548     ) internal pure returns (bytes memory) {
549         if (success) {
550             return returndata;
551         } else {
552             // Look for revert reason and bubble it up if present
553             if (returndata.length > 0) {
554                 // The easiest way to bubble the revert reason is using memory via assembly
555                 /// @solidity memory-safe-assembly
556                 assembly {
557                     let returndata_size := mload(returndata)
558                     revert(add(32, returndata), returndata_size)
559                 }
560             } else {
561                 revert(errorMessage);
562             }
563         }
564     }
565 }
566 
567 
568 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
569 
570 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev Provides information about the current execution context, including the
576  * sender of the transaction and its data. While these are generally available
577  * via msg.sender and msg.data, they should not be accessed in such a direct
578  * manner, since when dealing with meta-transactions the account sending and
579  * paying for execution may not be the actual sender (as far as an application
580  * is concerned).
581  *
582  * This contract is only required for intermediate, library-like contracts.
583  */
584 abstract contract Context {
585     function _msgSender() internal view virtual returns (address) {
586         return msg.sender;
587     }
588 
589     function _msgData() internal view virtual returns (bytes calldata) {
590         return msg.data;
591     }
592 }
593 
594 
595 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.0
596 
597 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev String operations.
603  */
604 library Strings {
605     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
606     uint8 private constant _ADDRESS_LENGTH = 20;
607 
608     /**
609      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
610      */
611     function toString(uint256 value) internal pure returns (string memory) {
612         // Inspired by OraclizeAPI's implementation - MIT licence
613         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
614 
615         if (value == 0) {
616             return "0";
617         }
618         uint256 temp = value;
619         uint256 digits;
620         while (temp != 0) {
621             digits++;
622             temp /= 10;
623         }
624         bytes memory buffer = new bytes(digits);
625         while (value != 0) {
626             digits -= 1;
627             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
628             value /= 10;
629         }
630         return string(buffer);
631     }
632 
633     /**
634      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
635      */
636     function toHexString(uint256 value) internal pure returns (string memory) {
637         if (value == 0) {
638             return "0x00";
639         }
640         uint256 temp = value;
641         uint256 length = 0;
642         while (temp != 0) {
643             length++;
644             temp >>= 8;
645         }
646         return toHexString(value, length);
647     }
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
651      */
652     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
653         bytes memory buffer = new bytes(2 * length + 2);
654         buffer[0] = "0";
655         buffer[1] = "x";
656         for (uint256 i = 2 * length + 1; i > 1; --i) {
657             buffer[i] = _HEX_SYMBOLS[value & 0xf];
658             value >>= 4;
659         }
660         require(value == 0, "Strings: hex length insufficient");
661         return string(buffer);
662     }
663 
664     /**
665      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
666      */
667     function toHexString(address addr) internal pure returns (string memory) {
668         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
669     }
670 }
671 
672 
673 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.0
674 
675 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
676 
677 pragma solidity ^0.8.0;
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
703 // File erc721a/contracts/ERC721A.sol@v3.3.0
704 
705 // ERC721A Contracts v3.3.0
706 // Creator: Chiru Labs
707 
708 pragma solidity ^0.8.4;
709 
710 
711 
712 
713 
714 
715 /**
716  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
717  * the Metadata extension. Built to optimize for lower gas during batch mints.
718  *
719  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
720  *
721  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
722  *
723  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
724  */
725 contract ERC721A is Context, ERC165, IERC721A {
726     using Address for address;
727     using Strings for uint256;
728 
729     // The tokenId of the next token to be minted.
730     uint256 internal _currentIndex;
731 
732     // The number of tokens burned.
733     uint256 internal _burnCounter;
734 
735     // Token name
736     string private _name;
737 
738     // Token symbol
739     string private _symbol;
740 
741     // Mapping from token ID to ownership details
742     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
743     mapping(uint256 => TokenOwnership) internal _ownerships;
744 
745     // Mapping owner address to address data
746     mapping(address => AddressData) private _addressData;
747 
748     // Mapping from token ID to approved address
749     mapping(uint256 => address) private _tokenApprovals;
750 
751     // Mapping from owner to operator approvals
752     mapping(address => mapping(address => bool)) private _operatorApprovals;
753 
754     constructor(string memory name_, string memory symbol_) {
755         _name = name_;
756         _symbol = symbol_;
757         _currentIndex = _startTokenId();
758     }
759 
760     /**
761      * To change the starting tokenId, please override this function.
762      */
763     function _startTokenId() internal view virtual returns (uint256) {
764         return 0;
765     }
766 
767     /**
768      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
769      */
770     function totalSupply() public view override returns (uint256) {
771         // Counter underflow is impossible as _burnCounter cannot be incremented
772         // more than _currentIndex - _startTokenId() times
773         unchecked {
774             return _currentIndex - _burnCounter - _startTokenId();
775         }
776     }
777 
778     /**
779      * Returns the total amount of tokens minted in the contract.
780      */
781     function _totalMinted() internal view returns (uint256) {
782         // Counter underflow is impossible as _currentIndex does not decrement,
783         // and it is initialized to _startTokenId()
784         unchecked {
785             return _currentIndex - _startTokenId();
786         }
787     }
788 
789     /**
790      * @dev See {IERC165-supportsInterface}.
791      */
792     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
793         return
794             interfaceId == type(IERC721).interfaceId ||
795             interfaceId == type(IERC721Metadata).interfaceId ||
796             super.supportsInterface(interfaceId);
797     }
798 
799     /**
800      * @dev See {IERC721-balanceOf}.
801      */
802     function balanceOf(address owner) public view override returns (uint256) {
803         if (owner == address(0)) revert BalanceQueryForZeroAddress();
804         return uint256(_addressData[owner].balance);
805     }
806 
807     /**
808      * Returns the number of tokens minted by `owner`.
809      */
810     function _numberMinted(address owner) internal view returns (uint256) {
811         return uint256(_addressData[owner].numberMinted);
812     }
813 
814     /**
815      * Returns the number of tokens burned by or on behalf of `owner`.
816      */
817     function _numberBurned(address owner) internal view returns (uint256) {
818         return uint256(_addressData[owner].numberBurned);
819     }
820 
821     /**
822      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
823      */
824     function _getAux(address owner) internal view returns (uint64) {
825         return _addressData[owner].aux;
826     }
827 
828     /**
829      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
830      * If there are multiple variables, please pack them into a uint64.
831      */
832     function _setAux(address owner, uint64 aux) internal {
833         _addressData[owner].aux = aux;
834     }
835 
836     /**
837      * Gas spent here starts off proportional to the maximum mint batch size.
838      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
839      */
840     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
841         uint256 curr = tokenId;
842 
843         unchecked {
844             if (_startTokenId() <= curr) if (curr < _currentIndex) {
845                 TokenOwnership memory ownership = _ownerships[curr];
846                 if (!ownership.burned) {
847                     if (ownership.addr != address(0)) {
848                         return ownership;
849                     }
850                     // Invariant:
851                     // There will always be an ownership that has an address and is not burned
852                     // before an ownership that does not have an address and is not burned.
853                     // Hence, curr will not underflow.
854                     while (true) {
855                         curr--;
856                         ownership = _ownerships[curr];
857                         if (ownership.addr != address(0)) {
858                             return ownership;
859                         }
860                     }
861                 }
862             }
863         }
864         revert OwnerQueryForNonexistentToken();
865     }
866 
867     /**
868      * @dev See {IERC721-ownerOf}.
869      */
870     function ownerOf(uint256 tokenId) public view override returns (address) {
871         return _ownershipOf(tokenId).addr;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-name}.
876      */
877     function name() public view virtual override returns (string memory) {
878         return _name;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-symbol}.
883      */
884     function symbol() public view virtual override returns (string memory) {
885         return _symbol;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-tokenURI}.
890      */
891     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
892         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
893 
894         string memory baseURI = _baseURI();
895         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
896     }
897 
898     /**
899      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
900      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
901      * by default, can be overriden in child contracts.
902      */
903     function _baseURI() internal view virtual returns (string memory) {
904         return '';
905     }
906 
907     /**
908      * @dev See {IERC721-approve}.
909      */
910     function approve(address to, uint256 tokenId) public override {
911         address owner = ERC721A.ownerOf(tokenId);
912         if (to == owner) revert ApprovalToCurrentOwner();
913 
914         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
915             revert ApprovalCallerNotOwnerNorApproved();
916         }
917 
918         _approve(to, tokenId, owner);
919     }
920 
921     /**
922      * @dev See {IERC721-getApproved}.
923      */
924     function getApproved(uint256 tokenId) public view override returns (address) {
925         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
926 
927         return _tokenApprovals[tokenId];
928     }
929 
930     /**
931      * @dev See {IERC721-setApprovalForAll}.
932      */
933     function setApprovalForAll(address operator, bool approved) public virtual override {
934         if (operator == _msgSender()) revert ApproveToCaller();
935 
936         _operatorApprovals[_msgSender()][operator] = approved;
937         emit ApprovalForAll(_msgSender(), operator, approved);
938     }
939 
940     /**
941      * @dev See {IERC721-isApprovedForAll}.
942      */
943     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
944         return _operatorApprovals[owner][operator];
945     }
946 
947     /**
948      * @dev See {IERC721-transferFrom}.
949      */
950     function transferFrom(
951         address from,
952         address to,
953         uint256 tokenId
954     ) public virtual override {
955         _transfer(from, to, tokenId);
956     }
957 
958     /**
959      * @dev See {IERC721-safeTransferFrom}.
960      */
961     function safeTransferFrom(
962         address from,
963         address to,
964         uint256 tokenId
965     ) public virtual override {
966         safeTransferFrom(from, to, tokenId, '');
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) public virtual override {
978         _transfer(from, to, tokenId);
979         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
980             revert TransferToNonERC721ReceiverImplementer();
981         }
982     }
983 
984     /**
985      * @dev Returns whether `tokenId` exists.
986      *
987      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
988      *
989      * Tokens start existing when they are minted (`_mint`),
990      */
991     function _exists(uint256 tokenId) internal view returns (bool) {
992         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
993     }
994 
995     /**
996      * @dev Equivalent to `_safeMint(to, quantity, '')`.
997      */
998     function _safeMint(address to, uint256 quantity) internal {
999         _safeMint(to, quantity, '');
1000     }
1001 
1002     /**
1003      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - If `to` refers to a smart contract, it must implement
1008      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1009      * - `quantity` must be greater than 0.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 quantity,
1016         bytes memory _data
1017     ) internal {
1018         uint256 startTokenId = _currentIndex;
1019         if (to == address(0)) revert MintToZeroAddress();
1020         if (quantity == 0) revert MintZeroQuantity();
1021 
1022         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1023 
1024         // Overflows are incredibly unrealistic.
1025         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1026         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1027         unchecked {
1028             _addressData[to].balance += uint64(quantity);
1029             _addressData[to].numberMinted += uint64(quantity);
1030 
1031             _ownerships[startTokenId].addr = to;
1032             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1033 
1034             uint256 updatedIndex = startTokenId;
1035             uint256 end = updatedIndex + quantity;
1036 
1037             if (to.isContract()) {
1038                 do {
1039                     emit Transfer(address(0), to, updatedIndex);
1040                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1041                         revert TransferToNonERC721ReceiverImplementer();
1042                     }
1043                 } while (updatedIndex < end);
1044                 // Reentrancy protection
1045                 if (_currentIndex != startTokenId) revert();
1046             } else {
1047                 do {
1048                     emit Transfer(address(0), to, updatedIndex++);
1049                 } while (updatedIndex < end);
1050             }
1051             _currentIndex = updatedIndex;
1052         }
1053         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1054     }
1055 
1056     /**
1057      * @dev Mints `quantity` tokens and transfers them to `to`.
1058      *
1059      * Requirements:
1060      *
1061      * - `to` cannot be the zero address.
1062      * - `quantity` must be greater than 0.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _mint(address to, uint256 quantity) internal {
1067         uint256 startTokenId = _currentIndex;
1068         if (to == address(0)) revert MintToZeroAddress();
1069         if (quantity == 0) revert MintZeroQuantity();
1070 
1071         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1072 
1073         // Overflows are incredibly unrealistic.
1074         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1075         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1076         unchecked {
1077             _addressData[to].balance += uint64(quantity);
1078             _addressData[to].numberMinted += uint64(quantity);
1079 
1080             _ownerships[startTokenId].addr = to;
1081             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1082 
1083             uint256 updatedIndex = startTokenId;
1084             uint256 end = updatedIndex + quantity;
1085 
1086             do {
1087                 emit Transfer(address(0), to, updatedIndex++);
1088             } while (updatedIndex < end);
1089 
1090             _currentIndex = updatedIndex;
1091         }
1092         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1093     }
1094 
1095     /**
1096      * @dev Transfers `tokenId` from `from` to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must be owned by `from`.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _transfer(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) private {
1110         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1111 
1112         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1113 
1114         bool isApprovedOrOwner = (_msgSender() == from ||
1115             isApprovedForAll(from, _msgSender()) ||
1116             getApproved(tokenId) == _msgSender());
1117 
1118         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1119         if (to == address(0)) revert TransferToZeroAddress();
1120 
1121         _beforeTokenTransfers(from, to, tokenId, 1);
1122 
1123         // Clear approvals from the previous owner
1124         _approve(address(0), tokenId, from);
1125 
1126         // Underflow of the sender's balance is impossible because we check for
1127         // ownership above and the recipient's balance can't realistically overflow.
1128         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1129         unchecked {
1130             _addressData[from].balance -= 1;
1131             _addressData[to].balance += 1;
1132 
1133             TokenOwnership storage currSlot = _ownerships[tokenId];
1134             currSlot.addr = to;
1135             currSlot.startTimestamp = uint64(block.timestamp);
1136 
1137             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1138             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1139             uint256 nextTokenId = tokenId + 1;
1140             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1141             if (nextSlot.addr == address(0)) {
1142                 // This will suffice for checking _exists(nextTokenId),
1143                 // as a burned slot cannot contain the zero address.
1144                 if (nextTokenId != _currentIndex) {
1145                     nextSlot.addr = from;
1146                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1147                 }
1148             }
1149         }
1150 
1151         emit Transfer(from, to, tokenId);
1152         _afterTokenTransfers(from, to, tokenId, 1);
1153     }
1154 
1155     /**
1156      * @dev Equivalent to `_burn(tokenId, false)`.
1157      */
1158     function _burn(uint256 tokenId) internal virtual {
1159         _burn(tokenId, false);
1160     }
1161 
1162     /**
1163      * @dev Destroys `tokenId`.
1164      * The approval is cleared when the token is burned.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must exist.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1173         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1174 
1175         address from = prevOwnership.addr;
1176 
1177         if (approvalCheck) {
1178             bool isApprovedOrOwner = (_msgSender() == from ||
1179                 isApprovedForAll(from, _msgSender()) ||
1180                 getApproved(tokenId) == _msgSender());
1181 
1182             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         }
1184 
1185         _beforeTokenTransfers(from, address(0), tokenId, 1);
1186 
1187         // Clear approvals from the previous owner
1188         _approve(address(0), tokenId, from);
1189 
1190         // Underflow of the sender's balance is impossible because we check for
1191         // ownership above and the recipient's balance can't realistically overflow.
1192         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1193         unchecked {
1194             AddressData storage addressData = _addressData[from];
1195             addressData.balance -= 1;
1196             addressData.numberBurned += 1;
1197 
1198             // Keep track of who burned the token, and the timestamp of burning.
1199             TokenOwnership storage currSlot = _ownerships[tokenId];
1200             currSlot.addr = from;
1201             currSlot.startTimestamp = uint64(block.timestamp);
1202             currSlot.burned = true;
1203 
1204             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1205             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1206             uint256 nextTokenId = tokenId + 1;
1207             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1208             if (nextSlot.addr == address(0)) {
1209                 // This will suffice for checking _exists(nextTokenId),
1210                 // as a burned slot cannot contain the zero address.
1211                 if (nextTokenId != _currentIndex) {
1212                     nextSlot.addr = from;
1213                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1214                 }
1215             }
1216         }
1217 
1218         emit Transfer(from, address(0), tokenId);
1219         _afterTokenTransfers(from, address(0), tokenId, 1);
1220 
1221         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1222         unchecked {
1223             _burnCounter++;
1224         }
1225     }
1226 
1227     /**
1228      * @dev Approve `to` to operate on `tokenId`
1229      *
1230      * Emits a {Approval} event.
1231      */
1232     function _approve(
1233         address to,
1234         uint256 tokenId,
1235         address owner
1236     ) private {
1237         _tokenApprovals[tokenId] = to;
1238         emit Approval(owner, to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1243      *
1244      * @param from address representing the previous owner of the given token ID
1245      * @param to target address that will receive the tokens
1246      * @param tokenId uint256 ID of the token to be transferred
1247      * @param _data bytes optional data to send along with the call
1248      * @return bool whether the call correctly returned the expected magic value
1249      */
1250     function _checkContractOnERC721Received(
1251         address from,
1252         address to,
1253         uint256 tokenId,
1254         bytes memory _data
1255     ) private returns (bool) {
1256         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1257             return retval == IERC721Receiver(to).onERC721Received.selector;
1258         } catch (bytes memory reason) {
1259             if (reason.length == 0) {
1260                 revert TransferToNonERC721ReceiverImplementer();
1261             } else {
1262                 assembly {
1263                     revert(add(32, reason), mload(reason))
1264                 }
1265             }
1266         }
1267     }
1268 
1269     /**
1270      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1271      * And also called before burning one token.
1272      *
1273      * startTokenId - the first token id to be transferred
1274      * quantity - the amount to be transferred
1275      *
1276      * Calling conditions:
1277      *
1278      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1279      * transferred to `to`.
1280      * - When `from` is zero, `tokenId` will be minted for `to`.
1281      * - When `to` is zero, `tokenId` will be burned by `from`.
1282      * - `from` and `to` are never both zero.
1283      */
1284     function _beforeTokenTransfers(
1285         address from,
1286         address to,
1287         uint256 startTokenId,
1288         uint256 quantity
1289     ) internal virtual {}
1290 
1291     /**
1292      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1293      * minting.
1294      * And also called after one token has been burned.
1295      *
1296      * startTokenId - the first token id to be transferred
1297      * quantity - the amount to be transferred
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` has been minted for `to`.
1304      * - When `to` is zero, `tokenId` has been burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _afterTokenTransfers(
1308         address from,
1309         address to,
1310         uint256 startTokenId,
1311         uint256 quantity
1312     ) internal virtual {}
1313 }
1314 
1315 
1316 // File @openzeppelin/contracts/utils/Counters.sol@v4.7.0
1317 
1318 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1319 
1320 pragma solidity ^0.8.0;
1321 
1322 /**
1323  * @title Counters
1324  * @author Matt Condon (@shrugs)
1325  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1326  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1327  *
1328  * Include with `using Counters for Counters.Counter;`
1329  */
1330 library Counters {
1331     struct Counter {
1332         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1333         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1334         // this feature: see https://github.com/ethereum/solidity/issues/4637
1335         uint256 _value; // default: 0
1336     }
1337 
1338     function current(Counter storage counter) internal view returns (uint256) {
1339         return counter._value;
1340     }
1341 
1342     function increment(Counter storage counter) internal {
1343         unchecked {
1344             counter._value += 1;
1345         }
1346     }
1347 
1348     function decrement(Counter storage counter) internal {
1349         uint256 value = counter._value;
1350         require(value > 0, "Counter: decrement overflow");
1351         unchecked {
1352             counter._value = value - 1;
1353         }
1354     }
1355 
1356     function reset(Counter storage counter) internal {
1357         counter._value = 0;
1358     }
1359 }
1360 
1361 
1362 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.0
1363 
1364 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1365 
1366 pragma solidity ^0.8.0;
1367 
1368 /**
1369  * @dev Contract module which provides a basic access control mechanism, where
1370  * there is an account (an owner) that can be granted exclusive access to
1371  * specific functions.
1372  *
1373  * By default, the owner account will be the one that deploys the contract. This
1374  * can later be changed with {transferOwnership}.
1375  *
1376  * This module is used through inheritance. It will make available the modifier
1377  * `onlyOwner`, which can be applied to your functions to restrict their use to
1378  * the owner.
1379  */
1380 abstract contract Ownable is Context {
1381     address private _owner;
1382 
1383     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1384 
1385     /**
1386      * @dev Initializes the contract setting the deployer as the initial owner.
1387      */
1388     constructor() {
1389         _transferOwnership(_msgSender());
1390     }
1391 
1392     /**
1393      * @dev Throws if called by any account other than the owner.
1394      */
1395     modifier onlyOwner() {
1396         _checkOwner();
1397         _;
1398     }
1399 
1400     /**
1401      * @dev Returns the address of the current owner.
1402      */
1403     function owner() public view virtual returns (address) {
1404         return _owner;
1405     }
1406 
1407     /**
1408      * @dev Throws if the sender is not the owner.
1409      */
1410     function _checkOwner() internal view virtual {
1411         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1412     }
1413 
1414     /**
1415      * @dev Leaves the contract without owner. It will not be possible to call
1416      * `onlyOwner` functions anymore. Can only be called by the current owner.
1417      *
1418      * NOTE: Renouncing ownership will leave the contract without an owner,
1419      * thereby removing any functionality that is only available to the owner.
1420      */
1421     function renounceOwnership() public virtual onlyOwner {
1422         _transferOwnership(address(0));
1423     }
1424 
1425     /**
1426      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1427      * Can only be called by the current owner.
1428      */
1429     function transferOwnership(address newOwner) public virtual onlyOwner {
1430         require(newOwner != address(0), "Ownable: new owner is the zero address");
1431         _transferOwnership(newOwner);
1432     }
1433 
1434     /**
1435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1436      * Internal function without access restriction.
1437      */
1438     function _transferOwnership(address newOwner) internal virtual {
1439         address oldOwner = _owner;
1440         _owner = newOwner;
1441         emit OwnershipTransferred(oldOwner, newOwner);
1442     }
1443 }
1444 
1445 
1446 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.0
1447 
1448 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1449 
1450 pragma solidity ^0.8.0;
1451 
1452 /**
1453  * @dev Interface of the ERC20 standard as defined in the EIP.
1454  */
1455 interface IERC20 {
1456     /**
1457      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1458      * another (`to`).
1459      *
1460      * Note that `value` may be zero.
1461      */
1462     event Transfer(address indexed from, address indexed to, uint256 value);
1463 
1464     /**
1465      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1466      * a call to {approve}. `value` is the new allowance.
1467      */
1468     event Approval(address indexed owner, address indexed spender, uint256 value);
1469 
1470     /**
1471      * @dev Returns the amount of tokens in existence.
1472      */
1473     function totalSupply() external view returns (uint256);
1474 
1475     /**
1476      * @dev Returns the amount of tokens owned by `account`.
1477      */
1478     function balanceOf(address account) external view returns (uint256);
1479 
1480     /**
1481      * @dev Moves `amount` tokens from the caller's account to `to`.
1482      *
1483      * Returns a boolean value indicating whether the operation succeeded.
1484      *
1485      * Emits a {Transfer} event.
1486      */
1487     function transfer(address to, uint256 amount) external returns (bool);
1488 
1489     /**
1490      * @dev Returns the remaining number of tokens that `spender` will be
1491      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1492      * zero by default.
1493      *
1494      * This value changes when {approve} or {transferFrom} are called.
1495      */
1496     function allowance(address owner, address spender) external view returns (uint256);
1497 
1498     /**
1499      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1500      *
1501      * Returns a boolean value indicating whether the operation succeeded.
1502      *
1503      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1504      * that someone may use both the old and the new allowance by unfortunate
1505      * transaction ordering. One possible solution to mitigate this race
1506      * condition is to first reduce the spender's allowance to 0 and set the
1507      * desired value afterwards:
1508      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1509      *
1510      * Emits an {Approval} event.
1511      */
1512     function approve(address spender, uint256 amount) external returns (bool);
1513 
1514     /**
1515      * @dev Moves `amount` tokens from `from` to `to` using the
1516      * allowance mechanism. `amount` is then deducted from the caller's
1517      * allowance.
1518      *
1519      * Returns a boolean value indicating whether the operation succeeded.
1520      *
1521      * Emits a {Transfer} event.
1522      */
1523     function transferFrom(
1524         address from,
1525         address to,
1526         uint256 amount
1527     ) external returns (bool);
1528 }
1529 
1530 
1531 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.0
1532 
1533 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1534 
1535 pragma solidity ^0.8.0;
1536 
1537 /**
1538  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1539  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1540  *
1541  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1542  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1543  * need to send a transaction, and thus is not required to hold Ether at all.
1544  */
1545 interface IERC20Permit {
1546     /**
1547      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1548      * given ``owner``'s signed approval.
1549      *
1550      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1551      * ordering also apply here.
1552      *
1553      * Emits an {Approval} event.
1554      *
1555      * Requirements:
1556      *
1557      * - `spender` cannot be the zero address.
1558      * - `deadline` must be a timestamp in the future.
1559      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1560      * over the EIP712-formatted function arguments.
1561      * - the signature must use ``owner``'s current nonce (see {nonces}).
1562      *
1563      * For more information on the signature format, see the
1564      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1565      * section].
1566      */
1567     function permit(
1568         address owner,
1569         address spender,
1570         uint256 value,
1571         uint256 deadline,
1572         uint8 v,
1573         bytes32 r,
1574         bytes32 s
1575     ) external;
1576 
1577     /**
1578      * @dev Returns the current nonce for `owner`. This value must be
1579      * included whenever a signature is generated for {permit}.
1580      *
1581      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1582      * prevents a signature from being used multiple times.
1583      */
1584     function nonces(address owner) external view returns (uint256);
1585 
1586     /**
1587      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1588      */
1589     // solhint-disable-next-line func-name-mixedcase
1590     function DOMAIN_SEPARATOR() external view returns (bytes32);
1591 }
1592 
1593 
1594 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.0
1595 
1596 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1597 
1598 pragma solidity ^0.8.0;
1599 
1600 
1601 
1602 /**
1603  * @title SafeERC20
1604  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1605  * contract returns false). Tokens that return no value (and instead revert or
1606  * throw on failure) are also supported, non-reverting calls are assumed to be
1607  * successful.
1608  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1609  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1610  */
1611 library SafeERC20 {
1612     using Address for address;
1613 
1614     function safeTransfer(
1615         IERC20 token,
1616         address to,
1617         uint256 value
1618     ) internal {
1619         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1620     }
1621 
1622     function safeTransferFrom(
1623         IERC20 token,
1624         address from,
1625         address to,
1626         uint256 value
1627     ) internal {
1628         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1629     }
1630 
1631     /**
1632      * @dev Deprecated. This function has issues similar to the ones found in
1633      * {IERC20-approve}, and its usage is discouraged.
1634      *
1635      * Whenever possible, use {safeIncreaseAllowance} and
1636      * {safeDecreaseAllowance} instead.
1637      */
1638     function safeApprove(
1639         IERC20 token,
1640         address spender,
1641         uint256 value
1642     ) internal {
1643         // safeApprove should only be called when setting an initial allowance,
1644         // or when resetting it to zero. To increase and decrease it, use
1645         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1646         require(
1647             (value == 0) || (token.allowance(address(this), spender) == 0),
1648             "SafeERC20: approve from non-zero to non-zero allowance"
1649         );
1650         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1651     }
1652 
1653     function safeIncreaseAllowance(
1654         IERC20 token,
1655         address spender,
1656         uint256 value
1657     ) internal {
1658         uint256 newAllowance = token.allowance(address(this), spender) + value;
1659         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1660     }
1661 
1662     function safeDecreaseAllowance(
1663         IERC20 token,
1664         address spender,
1665         uint256 value
1666     ) internal {
1667         unchecked {
1668             uint256 oldAllowance = token.allowance(address(this), spender);
1669             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1670             uint256 newAllowance = oldAllowance - value;
1671             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1672         }
1673     }
1674 
1675     function safePermit(
1676         IERC20Permit token,
1677         address owner,
1678         address spender,
1679         uint256 value,
1680         uint256 deadline,
1681         uint8 v,
1682         bytes32 r,
1683         bytes32 s
1684     ) internal {
1685         uint256 nonceBefore = token.nonces(owner);
1686         token.permit(owner, spender, value, deadline, v, r, s);
1687         uint256 nonceAfter = token.nonces(owner);
1688         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1689     }
1690 
1691     /**
1692      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1693      * on the return value: the return value is optional (but if data is returned, it must not be false).
1694      * @param token The token targeted by the call.
1695      * @param data The call data (encoded using abi.encode or one of its variants).
1696      */
1697     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1698         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1699         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1700         // the target address contains contract code and also asserts for success in the low-level call.
1701 
1702         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1703         if (returndata.length > 0) {
1704             // Return data is optional
1705             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1706         }
1707     }
1708 }
1709 
1710 
1711 // File contracts/MonkeNFT.sol
1712 /// @author zscarabsz
1713 /// @title Monke NFT (genesis)
1714 // SPDX-License-Identifier: MIT
1715 
1716 pragma solidity ^0.8.11;  
1717 contract MonkeEnlightenmentNFT is ERC721A , Ownable{  
1718     constructor() ERC721A("MonkeEnlightenmentNFT", "MNFT") {}  
1719 
1720     using Counters for Counters.Counter;
1721     using Strings for uint256;
1722 
1723     address payable private _PaymentAddress = payable(0x78bD4Fa99C9492A5Efc75a821a4034d88403004d);
1724 	address private _monkeContract = address (0);
1725 
1726     Counters.Counter private _publicMNFT;
1727     uint256 private _MNFT_MAX = 3333;
1728     uint256 private _activeDateTime = 1663987096; 
1729     string private _tokenBaseURI = "";
1730     string private _revealURI = "https://ipfs.io/ipfs/QmbdvrpNNGRHBjafJ4YxZK2BznxEgkYpeH3SYEjC4m3Uoq";
1731     
1732     uint256 private PRESALE_PRICE = 0.00 ether;   
1733     uint256 private PUBLIC_PRICE = 0.00 ether;	 
1734     uint256 private REVEAL_DELAY = 96 hours;
1735     uint256 private PRESALE_HOURS = 0 hours;
1736     uint256 private PRESALE_MINT_LIMIT = 20;
1737 	uint256 private PUBLIC_MINT_LIMIT = 20;
1738 	uint256 private MONKE_TOKENS_NEEDED = 30000;
1739 
1740     mapping(address => bool) private _mappingWhiteList;
1741     mapping(address => uint256) private _mappingPresaleMintCount;
1742 	mapping(address => uint256) private _mappingPublicMintCount;
1743 	
1744 	function setMonkeToken(address token) public onlyOwner {
1745         _monkeContract = token;
1746     }
1747 	
1748 	function setMaxMintAmount(uint256 maxAmount) external onlyOwner {
1749         _MNFT_MAX = maxAmount;
1750     }
1751 
1752     function setPaymentAddress(address paymentAddress) external onlyOwner {
1753         _PaymentAddress = payable(paymentAddress);
1754     }
1755 
1756     function setActiveDateTime(uint256 activeDateTime, uint256 presaleHours, uint256 revealDelay) external onlyOwner {
1757         _activeDateTime = activeDateTime;
1758         REVEAL_DELAY = revealDelay;
1759         PRESALE_HOURS = presaleHours;
1760     }
1761 
1762     function setWhiteList(address[] memory whiteListAddress, bool bEnable) external onlyOwner {
1763         for (uint256 i = 0; i < whiteListAddress.length; i++) {
1764             _mappingWhiteList[whiteListAddress[i]] = bEnable;
1765         }
1766     }
1767 
1768     function isWhiteListed(address addr) public view returns (bool) {
1769         return _mappingWhiteList[addr];
1770     }
1771 
1772     function setMintPrice(uint256 presaleMintPrice, uint256 publicMintPrice) external onlyOwner {
1773         PRESALE_PRICE = presaleMintPrice; 
1774         PUBLIC_PRICE = publicMintPrice; 
1775     }
1776 
1777     function setMintMaxLimit(uint256 presaleMintLimit, uint256 publicsaleMintLimit) external onlyOwner {
1778         PRESALE_MINT_LIMIT = presaleMintLimit;
1779 		PUBLIC_MINT_LIMIT = publicsaleMintLimit;
1780     }
1781 	
1782 	function getPresaleMintMaxLimit() public view returns (uint256) {
1783 		return PRESALE_MINT_LIMIT;
1784 	}
1785 	
1786 	function getPublicsaleMintMaxLimit() public view returns (uint256) {
1787 		return PUBLIC_MINT_LIMIT;
1788 	}
1789 	
1790 	function getMintMax() public view returns (uint256) {
1791 		return _MNFT_MAX;
1792 	}
1793 	
1794     function setMonkeTokensNeeded(uint256 tokensAmount) external onlyOwner {
1795         MONKE_TOKENS_NEEDED = tokensAmount;
1796     }
1797 	
1798 	function setURIs(string memory revealURI, string memory baseURI) external onlyOwner {
1799         _revealURI = revealURI;
1800 		_tokenBaseURI = baseURI;
1801     }
1802 	
1803     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
1804         require(_exists(tokenId), "Token does not exist");
1805 
1806         if (_activeDateTime + REVEAL_DELAY < block.timestamp) {
1807             return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1808         }
1809         return _revealURI;
1810     }
1811 
1812     function withdraw() external onlyOwner {
1813         uint256 balance = address(this).balance;
1814         payable(msg.sender).transfer(balance);
1815     }
1816 
1817     function price() public view returns (uint256) {
1818 		return (block.timestamp < _activeDateTime)? PRESALE_PRICE : PUBLIC_PRICE;
1819     }
1820 	
1821 	function isPresaleMintActive() public view returns (bool) {
1822 		if (isPublicMintActive() == true) {
1823 			return false;
1824 		}
1825 		return (block.timestamp > _activeDateTime - PRESALE_HOURS)? true : false;
1826 	}
1827 	
1828 	function isPublicMintActive() public view returns (bool) {
1829 		return (block.timestamp > _activeDateTime)? true : false;
1830 	}
1831 
1832     function adminMint(uint256 adminMintAmt) external onlyOwner {
1833 		require(_publicMNFT.current() + adminMintAmt < _MNFT_MAX, "Purchase would exceed _MNFT_MAX");
1834 		
1835 		for (uint256 i = 0; i < adminMintAmt; i++) {
1836 			_publicMNFT.increment();
1837 		}
1838         _safeMint(msg.sender, adminMintAmt);
1839     }
1840 	
1841 	function hasMonkeToken(address user) public view returns(bool) {
1842 		IERC20 instance = IERC20(_monkeContract);
1843 		bool result = false;
1844 		uint bal = instance.balanceOf(user);
1845 
1846 		if(bal >= MONKE_TOKENS_NEEDED){
1847 			result = true;
1848 		}
1849 
1850 		return result;
1851 	}
1852 
1853     function purchase(uint256 numberOfTokens) external payable {
1854         require(msg.sender != owner(), "You are owner!");
1855         require(_publicMNFT.current() + numberOfTokens < _MNFT_MAX, "Purchase would exceed _MNFT_MAX");
1856 		require(hasMonkeToken(msg.sender) == true, "need to own more Monke tokens");
1857 
1858         if (block.timestamp < _activeDateTime) {
1859             require(_mappingWhiteList[msg.sender] == true, "Not registered to WhiteList");   
1860             require(block.timestamp > _activeDateTime - PRESALE_HOURS , "Mint is not activated for presale");
1861             require(_mappingPresaleMintCount[msg.sender] + numberOfTokens <= PRESALE_MINT_LIMIT, "Overflow for PRESALE_MINT_LIMIT");
1862             _mappingPresaleMintCount[msg.sender] = _mappingPresaleMintCount[msg.sender] + numberOfTokens;
1863         }
1864 		else {
1865 			require(block.timestamp > _activeDateTime, "Mint is not activated for public sale");
1866 			require(numberOfTokens <= 10, "Amount to high for single transaction");
1867 			require(_mappingPublicMintCount[msg.sender] + numberOfTokens <= PUBLIC_MINT_LIMIT, "Overflow for PUBLIC_MINT_LIMIT");
1868 			_mappingPublicMintCount[msg.sender] = _mappingPublicMintCount[msg.sender] + numberOfTokens;
1869 		}
1870 
1871         for(uint256 i=0; i<numberOfTokens; i++){
1872             _publicMNFT.increment();
1873         }
1874 		
1875         _safeMint(msg.sender, numberOfTokens);
1876     }   
1877 }
1878 
1879 interface iMonkeToken {
1880 	function ownerOf(uint256 tokenId) external returns (address);
1881 	function balanceOf(address tokenOwner) external returns (uint balance);
1882 }