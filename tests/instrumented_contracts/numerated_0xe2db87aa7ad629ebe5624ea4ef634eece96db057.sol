1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 /**
6 
7 $$$$$$\            $$\                     $$$$$$$$\ $$\                       $$$$$$$\  $$\                     
8 \_$$  _|           $$ |                    \__$$  __|$$ |                      $$  __$$\ $$ |                    
9   $$ |  $$$$$$$\ $$$$$$\    $$$$$$\           $$ |   $$$$$$$\   $$$$$$\        $$ |  $$ |$$ |$$\   $$\  $$$$$$\  
10   $$ |  $$  __$$\\_$$  _|  $$  __$$\          $$ |   $$  __$$\ $$  __$$\       $$$$$$$\ |$$ |$$ |  $$ |$$  __$$\ 
11   $$ |  $$ |  $$ | $$ |    $$ /  $$ |         $$ |   $$ |  $$ |$$$$$$$$ |      $$  __$$\ $$ |$$ |  $$ |$$ |  \__|
12   $$ |  $$ |  $$ | $$ |$$\ $$ |  $$ |         $$ |   $$ |  $$ |$$   ____|      $$ |  $$ |$$ |$$ |  $$ |$$ |      
13 $$$$$$\ $$ |  $$ | \$$$$  |\$$$$$$  |         $$ |   $$ |  $$ |\$$$$$$$\       $$$$$$$  |$$ |\$$$$$$  |$$ |      
14 \______|\__|  \__|  \____/  \______/          \__|   \__|  \__| \_______|      \_______/ \__| \______/ \__|      
15                                                                                                                                                                                                                          
16 */
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev String operations.
24  */
25 library Strings {
26     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
27 
28     /**
29      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
30      */
31     function toString(uint256 value) internal pure returns (string memory) {
32         // Inspired by OraclizeAPI's implementation - MIT licence
33         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
34 
35         if (value == 0) {
36             return "0";
37         }
38         uint256 temp = value;
39         uint256 digits;
40         while (temp != 0) {
41             digits++;
42             temp /= 10;
43         }
44         bytes memory buffer = new bytes(digits);
45         while (value != 0) {
46             digits -= 1;
47             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
48             value /= 10;
49         }
50         return string(buffer);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
55      */
56     function toHexString(uint256 value) internal pure returns (string memory) {
57         if (value == 0) {
58             return "0x00";
59         }
60         uint256 temp = value;
61         uint256 length = 0;
62         while (temp != 0) {
63             length++;
64             temp >>= 8;
65         }
66         return toHexString(value, length);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
71      */
72     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
73         bytes memory buffer = new bytes(2 * length + 2);
74         buffer[0] = "0";
75         buffer[1] = "x";
76         for (uint256 i = 2 * length + 1; i > 1; --i) {
77             buffer[i] = _HEX_SYMBOLS[value & 0xf];
78             value >>= 4;
79         }
80         require(value == 0, "Strings: hex length insufficient");
81         return string(buffer);
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Context.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Provides information about the current execution context, including the
94  * sender of the transaction and its data. While these are generally available
95  * via msg.sender and msg.data, they should not be accessed in such a direct
96  * manner, since when dealing with meta-transactions the account sending and
97  * paying for execution may not be the actual sender (as far as an application
98  * is concerned).
99  *
100  * This contract is only required for intermediate, library-like contracts.
101  */
102 abstract contract Context {
103     function _msgSender() internal view virtual returns (address) {
104         return msg.sender;
105     }
106 
107     function _msgData() internal view virtual returns (bytes calldata) {
108         return msg.data;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/utils/Address.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
116 
117 pragma solidity ^0.8.1;
118 
119 /**
120  * @dev Collection of functions related to the address type
121  */
122 library Address {
123     /**
124      * @dev Returns true if `account` is a contract.
125      *
126      * [IMPORTANT]
127      * ====
128      * It is unsafe to assume that an address for which this function returns
129      * false is an externally-owned account (EOA) and not a contract.
130      *
131      * Among others, `isContract` will return false for the following
132      * types of addresses:
133      *
134      *  - an externally-owned account
135      *  - a contract in construction
136      *  - an address where a contract will be created
137      *  - an address where a contract lived, but was destroyed
138      * ====
139      *
140      * [IMPORTANT]
141      * ====
142      * You shouldn't rely on `isContract` to protect against flash loan attacks!
143      *
144      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
145      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
146      * constructor.
147      * ====
148      */
149     function isContract(address account) internal view returns (bool) {
150         // This method relies on extcodesize/address.code.length, which returns 0
151         // for contracts in construction, since the code is only stored at the end
152         // of the constructor execution.
153 
154         return account.code.length > 0;
155     }
156 
157     /**
158      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
159      * `recipient`, forwarding all available gas and reverting on errors.
160      *
161      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
162      * of certain opcodes, possibly making contracts go over the 2300 gas limit
163      * imposed by `transfer`, making them unable to receive funds via
164      * `transfer`. {sendValue} removes this limitation.
165      *
166      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
167      *
168      * IMPORTANT: because control is transferred to `recipient`, care must be
169      * taken to not create reentrancy vulnerabilities. Consider using
170      * {ReentrancyGuard} or the
171      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
172      */
173     function sendValue(address payable recipient, uint256 amount) internal {
174         require(address(this).balance >= amount, "Address: insufficient balance");
175 
176         (bool success, ) = recipient.call{value: amount}("");
177         require(success, "Address: unable to send value, recipient may have reverted");
178     }
179 
180     /**
181      * @dev Performs a Solidity function call using a low level `call`. A
182      * plain `call` is an unsafe replacement for a function call: use this
183      * function instead.
184      *
185      * If `target` reverts with a revert reason, it is bubbled up by this
186      * function (like regular Solidity function calls).
187      *
188      * Returns the raw returned data. To convert to the expected return value,
189      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
190      *
191      * Requirements:
192      *
193      * - `target` must be a contract.
194      * - calling `target` with `data` must not revert.
195      *
196      * _Available since v3.1._
197      */
198     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionCall(target, data, "Address: low-level call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
204      * `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCall(
209         address target,
210         bytes memory data,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, 0, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but also transferring `value` wei to `target`.
219      *
220      * Requirements:
221      *
222      * - the calling contract must have an ETH balance of at least `value`.
223      * - the called Solidity function must be `payable`.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value
231     ) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
237      * with `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCallWithValue(
242         address target,
243         bytes memory data,
244         uint256 value,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         require(address(this).balance >= value, "Address: insufficient balance for call");
248         require(isContract(target), "Address: call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.call{value: value}(data);
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
261         return functionStaticCall(target, data, "Address: low-level static call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a static call.
267      *
268      * _Available since v3.3._
269      */
270     function functionStaticCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal view returns (bytes memory) {
275         require(isContract(target), "Address: static call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.staticcall(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but performing a delegate call.
284      *
285      * _Available since v3.4._
286      */
287     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
293      * but performing a delegate call.
294      *
295      * _Available since v3.4._
296      */
297     function functionDelegateCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         require(isContract(target), "Address: delegate call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.delegatecall(data);
305         return verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
310      * revert reason using the provided one.
311      *
312      * _Available since v4.3._
313      */
314     function verifyCallResult(
315         bool success,
316         bytes memory returndata,
317         string memory errorMessage
318     ) internal pure returns (bytes memory) {
319         if (success) {
320             return returndata;
321         } else {
322             // Look for revert reason and bubble it up if present
323             if (returndata.length > 0) {
324                 // The easiest way to bubble the revert reason is using memory via assembly
325 
326                 assembly {
327                     let returndata_size := mload(returndata)
328                     revert(add(32, returndata), returndata_size)
329                 }
330             } else {
331                 revert(errorMessage);
332             }
333         }
334     }
335 }
336 
337 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @title ERC721 token receiver interface
346  * @dev Interface for any contract that wants to support safeTransfers
347  * from ERC721 asset contracts.
348  */
349 interface IERC721Receiver {
350     /**
351      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
352      * by `operator` from `from`, this function is called.
353      *
354      * It must return its Solidity selector to confirm the token transfer.
355      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
356      *
357      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
358      */
359     function onERC721Received(
360         address operator,
361         address from,
362         uint256 tokenId,
363         bytes calldata data
364     ) external returns (bytes4);
365 }
366 
367 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Interface of the ERC165 standard, as defined in the
376  * https://eips.ethereum.org/EIPS/eip-165[EIP].
377  *
378  * Implementers can declare support of contract interfaces, which can then be
379  * queried by others ({ERC165Checker}).
380  *
381  * For an implementation, see {ERC165}.
382  */
383 interface IERC165 {
384     /**
385      * @dev Returns true if this contract implements the interface defined by
386      * `interfaceId`. See the corresponding
387      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
388      * to learn more about how these ids are created.
389      *
390      * This function call must use less than 30 000 gas.
391      */
392     function supportsInterface(bytes4 interfaceId) external view returns (bool);
393 }
394 
395 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 /**
404  * @dev Implementation of the {IERC165} interface.
405  *
406  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
407  * for the additional interface id that will be supported. For example:
408  *
409  * ```solidity
410  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
411  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
412  * }
413  * ```
414  *
415  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
416  */
417 abstract contract ERC165 is IERC165 {
418     /**
419      * @dev See {IERC165-supportsInterface}.
420      */
421     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
422         return interfaceId == type(IERC165).interfaceId;
423     }
424 }
425 
426 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 
434 /**
435  * @dev Required interface of an ERC721 compliant contract.
436  */
437 interface IERC721 is IERC165 {
438     /**
439      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
440      */
441     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
442 
443     /**
444      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
445      */
446     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
447 
448     /**
449      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
450      */
451     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
452 
453     /**
454      * @dev Returns the number of tokens in ``owner``'s account.
455      */
456     function balanceOf(address owner) external view returns (uint256 balance);
457 
458     /**
459      * @dev Returns the owner of the `tokenId` token.
460      *
461      * Requirements:
462      *
463      * - `tokenId` must exist.
464      */
465     function ownerOf(uint256 tokenId) external view returns (address owner);
466 
467     /**
468      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
469      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must exist and be owned by `from`.
476      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
477      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
478      *
479      * Emits a {Transfer} event.
480      */
481     function safeTransferFrom(
482         address from,
483         address to,
484         uint256 tokenId
485     ) external;
486 
487     /**
488      * @dev Transfers `tokenId` token from `from` to `to`.
489      *
490      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
491      *
492      * Requirements:
493      *
494      * - `from` cannot be the zero address.
495      * - `to` cannot be the zero address.
496      * - `tokenId` token must be owned by `from`.
497      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
498      *
499      * Emits a {Transfer} event.
500      */
501     function transferFrom(
502         address from,
503         address to,
504         uint256 tokenId
505     ) external;
506 
507     /**
508      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
509      * The approval is cleared when the token is transferred.
510      *
511      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
512      *
513      * Requirements:
514      *
515      * - The caller must own the token or be an approved operator.
516      * - `tokenId` must exist.
517      *
518      * Emits an {Approval} event.
519      */
520     function approve(address to, uint256 tokenId) external;
521 
522     /**
523      * @dev Returns the account approved for `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function getApproved(uint256 tokenId) external view returns (address operator);
530 
531     /**
532      * @dev Approve or remove `operator` as an operator for the caller.
533      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
534      *
535      * Requirements:
536      *
537      * - The `operator` cannot be the caller.
538      *
539      * Emits an {ApprovalForAll} event.
540      */
541     function setApprovalForAll(address operator, bool _approved) external;
542 
543     /**
544      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
545      *
546      * See {setApprovalForAll}
547      */
548     function isApprovedForAll(address owner, address operator) external view returns (bool);
549 
550     /**
551      * @dev Safely transfers `tokenId` token from `from` to `to`.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must exist and be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
559      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
560      *
561      * Emits a {Transfer} event.
562      */
563     function safeTransferFrom(
564         address from,
565         address to,
566         uint256 tokenId,
567         bytes calldata data
568     ) external;
569 }
570 
571 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
581  * @dev See https://eips.ethereum.org/EIPS/eip-721
582  */
583 interface IERC721Metadata is IERC721 {
584     /**
585      * @dev Returns the token collection name.
586      */
587     function name() external view returns (string memory);
588 
589     /**
590      * @dev Returns the token collection symbol.
591      */
592     function symbol() external view returns (string memory);
593 
594     /**
595      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
596      */
597     function tokenURI(uint256 tokenId) external view returns (string memory);
598 }
599 
600 // File: contracts/new.sol
601 
602 
603 
604 
605 pragma solidity ^0.8.4;
606 
607 
608 
609 
610 
611 
612 
613 
614 error ApprovalCallerNotOwnerNorApproved();
615 error ApprovalQueryForNonexistentToken();
616 error ApproveToCaller();
617 error ApprovalToCurrentOwner();
618 error BalanceQueryForZeroAddress();
619 error MintToZeroAddress();
620 error MintZeroQuantity();
621 error OwnerQueryForNonexistentToken();
622 error TransferCallerNotOwnerNorApproved();
623 error TransferFromIncorrectOwner();
624 error TransferToNonERC721ReceiverImplementer();
625 error TransferToZeroAddress();
626 error URIQueryForNonexistentToken();
627 
628 /**
629  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
630  * the Metadata extension. Built to optimize for lower gas during batch mints.
631  *
632  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
633  *
634  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
635  *
636  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
637  */
638 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
639     using Address for address;
640     using Strings for uint256;
641 
642     // Compiler will pack this into a single 256bit word.
643     struct TokenOwnership {
644         // The address of the owner.
645         address addr;
646         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
647         uint64 startTimestamp;
648         // Whether the token has been burned.
649         bool burned;
650     }
651 
652     // Compiler will pack this into a single 256bit word.
653     struct AddressData {
654         // Realistically, 2**64-1 is more than enough.
655         uint64 balance;
656         // Keeps track of mint count with minimal overhead for tokenomics.
657         uint64 numberMinted;
658         // Keeps track of burn count with minimal overhead for tokenomics.
659         uint64 numberBurned;
660         // For miscellaneous variable(s) pertaining to the address
661         // (e.g. number of whitelist mint slots used).
662         // If there are multiple variables, please pack them into a uint64.
663         uint64 aux;
664     }
665 
666     // The tokenId of the next token to be minted.
667     uint256 internal _currentIndex;
668 
669     // The number of tokens burned.
670     uint256 internal _burnCounter;
671 
672     // Token name
673     string private _name;
674 
675     // Token symbol
676     string private _symbol;
677 
678     // Mapping from token ID to ownership details
679     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
680     mapping(uint256 => TokenOwnership) internal _ownerships;
681 
682     // Mapping owner address to address data
683     mapping(address => AddressData) private _addressData;
684 
685     // Mapping from token ID to approved address
686     mapping(uint256 => address) private _tokenApprovals;
687 
688     // Mapping from owner to operator approvals
689     mapping(address => mapping(address => bool)) private _operatorApprovals;
690 
691     constructor(string memory name_, string memory symbol_) {
692         _name = name_;
693         _symbol = symbol_;
694         _currentIndex = _startTokenId();
695     }
696 
697     /**
698      * To change the starting tokenId, please override this function.
699      */
700     function _startTokenId() internal view virtual returns (uint256) {
701         return 1;
702     }
703 
704     /**
705      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
706      */
707     function totalSupply() public view returns (uint256) {
708         // Counter underflow is impossible as _burnCounter cannot be incremented
709         // more than _currentIndex - _startTokenId() times
710         unchecked {
711             return _currentIndex - _burnCounter - _startTokenId();
712         }
713     }
714 
715     /**
716      * Returns the total amount of tokens minted in the contract.
717      */
718     function _totalMinted() internal view returns (uint256) {
719         // Counter underflow is impossible as _currentIndex does not decrement,
720         // and it is initialized to _startTokenId()
721         unchecked {
722             return _currentIndex - _startTokenId();
723         }
724     }
725 
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
730         return
731             interfaceId == type(IERC721).interfaceId ||
732             interfaceId == type(IERC721Metadata).interfaceId ||
733             super.supportsInterface(interfaceId);
734     }
735 
736     /**
737      * @dev See {IERC721-balanceOf}.
738      */
739     function balanceOf(address owner) public view override returns (uint256) {
740         if (owner == address(0)) revert BalanceQueryForZeroAddress();
741         return uint256(_addressData[owner].balance);
742     }
743 
744     /**
745      * Returns the number of tokens minted by `owner`.
746      */
747     function _numberMinted(address owner) internal view returns (uint256) {
748         return uint256(_addressData[owner].numberMinted);
749     }
750 
751     /**
752      * Returns the number of tokens burned by or on behalf of `owner`.
753      */
754     function _numberBurned(address owner) internal view returns (uint256) {
755         return uint256(_addressData[owner].numberBurned);
756     }
757 
758     /**
759      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
760      */
761     function _getAux(address owner) internal view returns (uint64) {
762         return _addressData[owner].aux;
763     }
764 
765     /**
766      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
767      * If there are multiple variables, please pack them into a uint64.
768      */
769     function _setAux(address owner, uint64 aux) internal {
770         _addressData[owner].aux = aux;
771     }
772 
773     /**
774      * Gas spent here starts off proportional to the maximum mint batch size.
775      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
776      */
777     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
778         uint256 curr = tokenId;
779 
780         unchecked {
781             if (_startTokenId() <= curr && curr < _currentIndex) {
782                 TokenOwnership memory ownership = _ownerships[curr];
783                 if (!ownership.burned) {
784                     if (ownership.addr != address(0)) {
785                         return ownership;
786                     }
787                     // Invariant:
788                     // There will always be an ownership that has an address and is not burned
789                     // before an ownership that does not have an address and is not burned.
790                     // Hence, curr will not underflow.
791                     while (true) {
792                         curr--;
793                         ownership = _ownerships[curr];
794                         if (ownership.addr != address(0)) {
795                             return ownership;
796                         }
797                     }
798                 }
799             }
800         }
801         revert OwnerQueryForNonexistentToken();
802     }
803 
804     /**
805      * @dev See {IERC721-ownerOf}.
806      */
807     function ownerOf(uint256 tokenId) public view override returns (address) {
808         return _ownershipOf(tokenId).addr;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-name}.
813      */
814     function name() public view virtual override returns (string memory) {
815         return _name;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-symbol}.
820      */
821     function symbol() public view virtual override returns (string memory) {
822         return _symbol;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-tokenURI}.
827      */
828     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
829         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
830 
831         string memory baseURI = _baseURI();
832         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
833     }
834 
835     /**
836      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
837      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
838      * by default, can be overriden in child contracts.
839      */
840     function _baseURI() internal view virtual returns (string memory) {
841         return '';
842     }
843 
844     /**
845      * @dev See {IERC721-approve}.
846      */
847     function approve(address to, uint256 tokenId) public override {
848         address owner = ERC721A.ownerOf(tokenId);
849         if (to == owner) revert ApprovalToCurrentOwner();
850 
851         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
852             revert ApprovalCallerNotOwnerNorApproved();
853         }
854 
855         _approve(to, tokenId, owner);
856     }
857 
858     /**
859      * @dev See {IERC721-getApproved}.
860      */
861     function getApproved(uint256 tokenId) public view override returns (address) {
862         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
863 
864         return _tokenApprovals[tokenId];
865     }
866 
867     /**
868      * @dev See {IERC721-setApprovalForAll}.
869      */
870     function setApprovalForAll(address operator, bool approved) public virtual override {
871         if (operator == _msgSender()) revert ApproveToCaller();
872 
873         _operatorApprovals[_msgSender()][operator] = approved;
874         emit ApprovalForAll(_msgSender(), operator, approved);
875     }
876 
877     /**
878      * @dev See {IERC721-isApprovedForAll}.
879      */
880     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
881         return _operatorApprovals[owner][operator];
882     }
883 
884     /**
885      * @dev See {IERC721-transferFrom}.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         _transfer(from, to, tokenId);
893     }
894 
895     /**
896      * @dev See {IERC721-safeTransferFrom}.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public virtual override {
903         safeTransferFrom(from, to, tokenId, '');
904     }
905 
906     /**
907      * @dev See {IERC721-safeTransferFrom}.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) public virtual override {
915         _transfer(from, to, tokenId);
916         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
917             revert TransferToNonERC721ReceiverImplementer();
918         }
919     }
920 
921     /**
922      * @dev Returns whether `tokenId` exists.
923      *
924      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
925      *
926      * Tokens start existing when they are minted (`_mint`),
927      */
928     function _exists(uint256 tokenId) internal view returns (bool) {
929         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
930             !_ownerships[tokenId].burned;
931     }
932 
933     function _safeMint(address to, uint256 quantity) internal {
934         _safeMint(to, quantity, '');
935     }
936 
937     /**
938      * @dev Safely mints `quantity` tokens and transfers them to `to`.
939      *
940      * Requirements:
941      *
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
943      * - `quantity` must be greater than 0.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _safeMint(
948         address to,
949         uint256 quantity,
950         bytes memory _data
951     ) internal {
952         _mint(to, quantity, _data, true);
953     }
954 
955     /**
956      * @dev Mints `quantity` tokens and transfers them to `to`.
957      *
958      * Requirements:
959      *
960      * - `to` cannot be the zero address.
961      * - `quantity` must be greater than 0.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _mint(
966         address to,
967         uint256 quantity,
968         bytes memory _data,
969         bool safe
970     ) internal {
971         uint256 startTokenId = _currentIndex;
972         if (to == address(0)) revert MintToZeroAddress();
973         if (quantity == 0) revert MintZeroQuantity();
974 
975         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
976 
977         // Overflows are incredibly unrealistic.
978         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
979         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
980         unchecked {
981             _addressData[to].balance += uint64(quantity);
982             _addressData[to].numberMinted += uint64(quantity);
983 
984             _ownerships[startTokenId].addr = to;
985             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
986 
987             uint256 updatedIndex = startTokenId;
988             uint256 end = updatedIndex + quantity;
989 
990             if (safe && to.isContract()) {
991                 do {
992                     emit Transfer(address(0), to, updatedIndex);
993                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
994                         revert TransferToNonERC721ReceiverImplementer();
995                     }
996                 } while (updatedIndex != end);
997                 // Reentrancy protection
998                 if (_currentIndex != startTokenId) revert();
999             } else {
1000                 do {
1001                     emit Transfer(address(0), to, updatedIndex++);
1002                 } while (updatedIndex != end);
1003             }
1004             _currentIndex = updatedIndex;
1005         }
1006         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1007     }
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must be owned by `from`.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _transfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) private {
1024         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1025 
1026         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1027 
1028         bool isApprovedOrOwner = (_msgSender() == from ||
1029             isApprovedForAll(from, _msgSender()) ||
1030             getApproved(tokenId) == _msgSender());
1031 
1032         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1033         if (to == address(0)) revert TransferToZeroAddress();
1034 
1035         _beforeTokenTransfers(from, to, tokenId, 1);
1036 
1037         // Clear approvals from the previous owner
1038         _approve(address(0), tokenId, from);
1039 
1040         // Underflow of the sender's balance is impossible because we check for
1041         // ownership above and the recipient's balance can't realistically overflow.
1042         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1043         unchecked {
1044             _addressData[from].balance -= 1;
1045             _addressData[to].balance += 1;
1046 
1047             TokenOwnership storage currSlot = _ownerships[tokenId];
1048             currSlot.addr = to;
1049             currSlot.startTimestamp = uint64(block.timestamp);
1050 
1051             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1052             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1053             uint256 nextTokenId = tokenId + 1;
1054             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1055             if (nextSlot.addr == address(0)) {
1056                 // This will suffice for checking _exists(nextTokenId),
1057                 // as a burned slot cannot contain the zero address.
1058                 if (nextTokenId != _currentIndex) {
1059                     nextSlot.addr = from;
1060                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1061                 }
1062             }
1063         }
1064 
1065         emit Transfer(from, to, tokenId);
1066         _afterTokenTransfers(from, to, tokenId, 1);
1067     }
1068 
1069     /**
1070      * @dev This is equivalent to _burn(tokenId, false)
1071      */
1072     function _burn(uint256 tokenId) internal virtual {
1073         _burn(tokenId, false);
1074     }
1075 
1076     /**
1077      * @dev Destroys `tokenId`.
1078      * The approval is cleared when the token is burned.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must exist.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1087         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1088 
1089         address from = prevOwnership.addr;
1090 
1091         if (approvalCheck) {
1092             bool isApprovedOrOwner = (_msgSender() == from ||
1093                 isApprovedForAll(from, _msgSender()) ||
1094                 getApproved(tokenId) == _msgSender());
1095 
1096             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1097         }
1098 
1099         _beforeTokenTransfers(from, address(0), tokenId, 1);
1100 
1101         // Clear approvals from the previous owner
1102         _approve(address(0), tokenId, from);
1103 
1104         // Underflow of the sender's balance is impossible because we check for
1105         // ownership above and the recipient's balance can't realistically overflow.
1106         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1107         unchecked {
1108             AddressData storage addressData = _addressData[from];
1109             addressData.balance -= 1;
1110             addressData.numberBurned += 1;
1111 
1112             // Keep track of who burned the token, and the timestamp of burning.
1113             TokenOwnership storage currSlot = _ownerships[tokenId];
1114             currSlot.addr = from;
1115             currSlot.startTimestamp = uint64(block.timestamp);
1116             currSlot.burned = true;
1117 
1118             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1119             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1120             uint256 nextTokenId = tokenId + 1;
1121             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1122             if (nextSlot.addr == address(0)) {
1123                 // This will suffice for checking _exists(nextTokenId),
1124                 // as a burned slot cannot contain the zero address.
1125                 if (nextTokenId != _currentIndex) {
1126                     nextSlot.addr = from;
1127                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1128                 }
1129             }
1130         }
1131 
1132         emit Transfer(from, address(0), tokenId);
1133         _afterTokenTransfers(from, address(0), tokenId, 1);
1134 
1135         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1136         unchecked {
1137             _burnCounter++;
1138         }
1139     }
1140 
1141     /**
1142      * @dev Approve `to` to operate on `tokenId`
1143      *
1144      * Emits a {Approval} event.
1145      */
1146     function _approve(
1147         address to,
1148         uint256 tokenId,
1149         address owner
1150     ) private {
1151         _tokenApprovals[tokenId] = to;
1152         emit Approval(owner, to, tokenId);
1153     }
1154 
1155     /**
1156      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1157      *
1158      * @param from address representing the previous owner of the given token ID
1159      * @param to target address that will receive the tokens
1160      * @param tokenId uint256 ID of the token to be transferred
1161      * @param _data bytes optional data to send along with the call
1162      * @return bool whether the call correctly returned the expected magic value
1163      */
1164     function _checkContractOnERC721Received(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) private returns (bool) {
1170         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1171             return retval == IERC721Receiver(to).onERC721Received.selector;
1172         } catch (bytes memory reason) {
1173             if (reason.length == 0) {
1174                 revert TransferToNonERC721ReceiverImplementer();
1175             } else {
1176                 assembly {
1177                     revert(add(32, reason), mload(reason))
1178                 }
1179             }
1180         }
1181     }
1182 
1183     /**
1184      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1185      * And also called before burning one token.
1186      *
1187      * startTokenId - the first token id to be transferred
1188      * quantity - the amount to be transferred
1189      *
1190      * Calling conditions:
1191      *
1192      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1193      * transferred to `to`.
1194      * - When `from` is zero, `tokenId` will be minted for `to`.
1195      * - When `to` is zero, `tokenId` will be burned by `from`.
1196      * - `from` and `to` are never both zero.
1197      */
1198     function _beforeTokenTransfers(
1199         address from,
1200         address to,
1201         uint256 startTokenId,
1202         uint256 quantity
1203     ) internal virtual {}
1204 
1205     /**
1206      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1207      * minting.
1208      * And also called after one token has been burned.
1209      *
1210      * startTokenId - the first token id to be transferred
1211      * quantity - the amount to be transferred
1212      *
1213      * Calling conditions:
1214      *
1215      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1216      * transferred to `to`.
1217      * - When `from` is zero, `tokenId` has been minted for `to`.
1218      * - When `to` is zero, `tokenId` has been burned by `from`.
1219      * - `from` and `to` are never both zero.
1220      */
1221     function _afterTokenTransfers(
1222         address from,
1223         address to,
1224         uint256 startTokenId,
1225         uint256 quantity
1226     ) internal virtual {}
1227 }
1228 
1229 abstract contract Ownable is Context {
1230     address private _owner;
1231 
1232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1233 
1234     /**
1235      * @dev Initializes the contract setting the deployer as the initial owner.
1236      */
1237     constructor() {
1238         _transferOwnership(_msgSender());
1239     }
1240 
1241     /**
1242      * @dev Returns the address of the current owner.
1243      */
1244     function owner() public view virtual returns (address) {
1245         return _owner;
1246     }
1247 
1248     /**
1249      * @dev Throws if called by any account other than the owner.
1250      */
1251     modifier onlyOwner() {
1252         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1253         _;
1254     }
1255 
1256     /**
1257      * @dev Leaves the contract without owner. It will not be possible to call
1258      * `onlyOwner` functions anymore. Can only be called by the current owner.
1259      *
1260      * NOTE: Renouncing ownership will leave the contract without an owner,
1261      * thereby removing any functionality that is only available to the owner.
1262      */
1263     function renounceOwnership() public virtual onlyOwner {
1264         _transferOwnership(address(0));
1265     }
1266 
1267     /**
1268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1269      * Can only be called by the current owner.
1270      */
1271     function transferOwnership(address newOwner) public virtual onlyOwner {
1272         require(newOwner != address(0), "Ownable: new owner is the zero address");
1273         _transferOwnership(newOwner);
1274     }
1275 
1276     /**
1277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1278      * Internal function without access restriction.
1279      */
1280     function _transferOwnership(address newOwner) internal virtual {
1281         address oldOwner = _owner;
1282         _owner = newOwner;
1283         emit OwnershipTransferred(oldOwner, newOwner);
1284     }
1285 }
1286     pragma solidity ^0.8.7;
1287     
1288     contract IntoTheBlur is ERC721A, Ownable {
1289     using Strings for uint256;
1290 
1291   string private uriPrefix;
1292   string private uriSuffix = ".json";
1293   string public hiddenURL = "ipfs://QmPVWA5q5PGW2thH5LviZ3tmWRNF9XqEDHAHnhydsTN83h";
1294 
1295   uint256 public cost = 0.002 ether;
1296 
1297   uint16 public maxSupply = 1000;
1298   uint8 public maxMintAmountPerTx = 4;
1299   uint8 public maxFreeMintAmountPerWallet = 1;
1300                                                              
1301  
1302   bool public paused = true;
1303   bool public reveal = false;
1304 
1305   mapping (address => uint8) public NFTPerPublicAddress;
1306 
1307   constructor() ERC721A("Into The Blur", "ITBLUR") {
1308   }
1309  
1310   function Mint(uint8 _mintAmount) external payable  {
1311      uint16 totalSupply = uint16(totalSupply());
1312      uint8 nft = NFTPerPublicAddress[msg.sender];
1313     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1314     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1315     require(!paused, "The contract is paused!");
1316     
1317       if(nft >= maxFreeMintAmountPerWallet)
1318     {
1319     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1320     }
1321     else {
1322          uint8 costAmount = _mintAmount + nft;
1323         if(costAmount > maxFreeMintAmountPerWallet)
1324        {
1325         costAmount = costAmount - maxFreeMintAmountPerWallet;
1326         require(msg.value >= cost * costAmount, "Insufficient funds!");
1327        }
1328     }
1329     _safeMint(msg.sender , _mintAmount);
1330     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1331      delete totalSupply;
1332      delete _mintAmount;
1333   }
1334   
1335   function reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1336      uint16 totalSupply = uint16(totalSupply());
1337     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1338      _safeMint(_receiver , _mintAmount);
1339      delete _mintAmount;
1340      delete _receiver;
1341      delete totalSupply;
1342   }
1343 
1344   function airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1345      uint16 totalSupply = uint16(totalSupply());
1346      uint totalAmount =   _amountPerAddress * addresses.length;
1347     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1348      for (uint256 i = 0; i < addresses.length; i++) {
1349             _safeMint(addresses[i], _amountPerAddress);
1350         }
1351      delete _amountPerAddress;
1352      delete totalSupply;
1353   }
1354 
1355   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1356       maxSupply = _maxSupply;
1357   }
1358 
1359   function tokenURI(uint256 _tokenId)
1360     public
1361     view
1362     virtual
1363     override
1364     returns (string memory)
1365   {
1366     require(
1367       _exists(_tokenId),
1368       "ERC721Metadata: URI query for nonexistent token"
1369     );
1370     
1371   
1372 if ( reveal == false)
1373 {
1374     return hiddenURL;
1375 }
1376     
1377 
1378     string memory currentBaseURI = _baseURI();
1379     return bytes(currentBaseURI).length > 0
1380         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1381         : "";
1382   }
1383  
1384   function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1385   maxFreeMintAmountPerWallet = _limit;
1386   delete _limit;
1387 
1388   }
1389 
1390   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1391     uriPrefix = _uriPrefix;
1392   }
1393    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1394     hiddenURL = _uriPrefix;
1395   }
1396 
1397   function setPaused() external onlyOwner {
1398     paused = !paused;
1399    
1400   }
1401 
1402   function setCost(uint _cost) external onlyOwner{
1403       cost = _cost;
1404 
1405   }
1406 
1407  function setRevealed() external onlyOwner{
1408      reveal = !reveal;
1409  }
1410 
1411   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1412       maxMintAmountPerTx = _maxtx;
1413 
1414   }
1415 
1416   function withdraw() external onlyOwner {
1417   uint _balance = address(this).balance;
1418      payable(msg.sender).transfer(_balance ); 
1419        
1420   }
1421 
1422 
1423   function _baseURI() internal view  override returns (string memory) {
1424     return uriPrefix;
1425   }
1426 
1427 }