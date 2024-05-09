1 /**
2 
3                                                                           
4                                                                           
5                                                                           
6                                 ████████                                  
7                               ██        ██                                
8                             ██▒▒▒▒        ██                              
9                           ██▒▒▒▒▒▒      ▒▒▒▒██                            
10                           ██▒▒▒▒▒▒      ▒▒▒▒██                            
11                         ██  ▒▒▒▒        ▒▒▒▒▒▒██                          
12                         ██                ▒▒▒▒██                          
13                       ██▒▒      ▒▒▒▒▒▒          ██                        
14                       ██      ▒▒▒▒▒▒▒▒▒▒        ██                        
15                       ██      ▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒██                        
16                       ██▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒██                        
17                         ██▒▒▒▒  ▒▒▒▒▒▒    ▒▒▒▒██                          
18                         ██▒▒▒▒            ▒▒▒▒██                          
19                           ██▒▒              ██                            
20                             ████        ████                              
21                                 ████████                                  
22                                                                           
23                                                                           
24                                                                           
25 
26 */
27 // SPDX-License-Identifier: MIT
28 
29 // File: @openzeppelin/contracts/utils/Strings.sol
30 
31 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev String operations.
37  */
38 library Strings {
39     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
43      */
44     function toString(uint256 value) internal pure returns (string memory) {
45         // Inspired by OraclizeAPI's implementation - MIT licence
46         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
47 
48         if (value == 0) {
49             return "0";
50         }
51         uint256 temp = value;
52         uint256 digits;
53         while (temp != 0) {
54             digits++;
55             temp /= 10;
56         }
57         bytes memory buffer = new bytes(digits);
58         while (value != 0) {
59             digits -= 1;
60             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
61             value /= 10;
62         }
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
68      */
69     function toHexString(uint256 value) internal pure returns (string memory) {
70         if (value == 0) {
71             return "0x00";
72         }
73         uint256 temp = value;
74         uint256 length = 0;
75         while (temp != 0) {
76             length++;
77             temp >>= 8;
78         }
79         return toHexString(value, length);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
84      */
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/Context.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Address.sol
126 
127 
128 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
129 
130 pragma solidity ^0.8.1;
131 
132 /**
133  * @dev Collection of functions related to the address type
134  */
135 library Address {
136     /**
137      * @dev Returns true if `account` is a contract.
138      *
139      * [IMPORTANT]
140      * ====
141      * It is unsafe to assume that an address for which this function returns
142      * false is an externally-owned account (EOA) and not a contract.
143      *
144      * Among others, `isContract` will return false for the following
145      * types of addresses:
146      *
147      *  - an externally-owned account
148      *  - a contract in construction
149      *  - an address where a contract will be created
150      *  - an address where a contract lived, but was destroyed
151      * ====
152      *
153      * [IMPORTANT]
154      * ====
155      * You shouldn't rely on `isContract` to protect against flash loan attacks!
156      *
157      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
158      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
159      * constructor.
160      * ====
161      */
162     function isContract(address account) internal view returns (bool) {
163         // This method relies on extcodesize/address.code.length, which returns 0
164         // for contracts in construction, since the code is only stored at the end
165         // of the constructor execution.
166 
167         return account.code.length > 0;
168     }
169 
170     /**
171      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
172      * `recipient`, forwarding all available gas and reverting on errors.
173      *
174      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
175      * of certain opcodes, possibly making contracts go over the 2300 gas limit
176      * imposed by `transfer`, making them unable to receive funds via
177      * `transfer`. {sendValue} removes this limitation.
178      *
179      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
180      *
181      * IMPORTANT: because control is transferred to `recipient`, care must be
182      * taken to not create reentrancy vulnerabilities. Consider using
183      * {ReentrancyGuard} or the
184      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
185      */
186     function sendValue(address payable recipient, uint256 amount) internal {
187         require(address(this).balance >= amount, "Address: insufficient balance");
188 
189         (bool success, ) = recipient.call{value: amount}("");
190         require(success, "Address: unable to send value, recipient may have reverted");
191     }
192 
193     /**
194      * @dev Performs a Solidity function call using a low level `call`. A
195      * plain `call` is an unsafe replacement for a function call: use this
196      * function instead.
197      *
198      * If `target` reverts with a revert reason, it is bubbled up by this
199      * function (like regular Solidity function calls).
200      *
201      * Returns the raw returned data. To convert to the expected return value,
202      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
203      *
204      * Requirements:
205      *
206      * - `target` must be a contract.
207      * - calling `target` with `data` must not revert.
208      *
209      * _Available since v3.1._
210      */
211     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionCall(target, data, "Address: low-level call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
217      * `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, 0, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but also transferring `value` wei to `target`.
232      *
233      * Requirements:
234      *
235      * - the calling contract must have an ETH balance of at least `value`.
236      * - the called Solidity function must be `payable`.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value
244     ) internal returns (bytes memory) {
245         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
250      * with `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(address(this).balance >= value, "Address: insufficient balance for call");
261         require(isContract(target), "Address: call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.call{value: value}(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a static call.
270      *
271      * _Available since v3.3._
272      */
273     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
274         return functionStaticCall(target, data, "Address: low-level static call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a static call.
280      *
281      * _Available since v3.3._
282      */
283     function functionStaticCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal view returns (bytes memory) {
288         require(isContract(target), "Address: static call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.staticcall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.4._
309      */
310     function functionDelegateCall(
311         address target,
312         bytes memory data,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(isContract(target), "Address: delegate call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.delegatecall(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
323      * revert reason using the provided one.
324      *
325      * _Available since v4.3._
326      */
327     function verifyCallResult(
328         bool success,
329         bytes memory returndata,
330         string memory errorMessage
331     ) internal pure returns (bytes memory) {
332         if (success) {
333             return returndata;
334         } else {
335             // Look for revert reason and bubble it up if present
336             if (returndata.length > 0) {
337                 // The easiest way to bubble the revert reason is using memory via assembly
338 
339                 assembly {
340                     let returndata_size := mload(returndata)
341                     revert(add(32, returndata), returndata_size)
342                 }
343             } else {
344                 revert(errorMessage);
345             }
346         }
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @title ERC721 token receiver interface
359  * @dev Interface for any contract that wants to support safeTransfers
360  * from ERC721 asset contracts.
361  */
362 interface IERC721Receiver {
363     /**
364      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
365      * by `operator` from `from`, this function is called.
366      *
367      * It must return its Solidity selector to confirm the token transfer.
368      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
369      *
370      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
371      */
372     function onERC721Received(
373         address operator,
374         address from,
375         uint256 tokenId,
376         bytes calldata data
377     ) external returns (bytes4);
378 }
379 
380 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @dev Interface of the ERC165 standard, as defined in the
389  * https://eips.ethereum.org/EIPS/eip-165[EIP].
390  *
391  * Implementers can declare support of contract interfaces, which can then be
392  * queried by others ({ERC165Checker}).
393  *
394  * For an implementation, see {ERC165}.
395  */
396 interface IERC165 {
397     /**
398      * @dev Returns true if this contract implements the interface defined by
399      * `interfaceId`. See the corresponding
400      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
401      * to learn more about how these ids are created.
402      *
403      * This function call must use less than 30 000 gas.
404      */
405     function supportsInterface(bytes4 interfaceId) external view returns (bool);
406 }
407 
408 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 
416 /**
417  * @dev Implementation of the {IERC165} interface.
418  *
419  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
420  * for the additional interface id that will be supported. For example:
421  *
422  * ```solidity
423  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
424  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
425  * }
426  * ```
427  *
428  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
429  */
430 abstract contract ERC165 is IERC165 {
431     /**
432      * @dev See {IERC165-supportsInterface}.
433      */
434     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
435         return interfaceId == type(IERC165).interfaceId;
436     }
437 }
438 
439 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 
447 /**
448  * @dev Required interface of an ERC721 compliant contract.
449  */
450 interface IERC721 is IERC165 {
451     /**
452      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
458      */
459     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
460 
461     /**
462      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
463      */
464     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
465 
466     /**
467      * @dev Returns the number of tokens in ``owner``'s account.
468      */
469     function balanceOf(address owner) external view returns (uint256 balance);
470 
471     /**
472      * @dev Returns the owner of the `tokenId` token.
473      *
474      * Requirements:
475      *
476      * - `tokenId` must exist.
477      */
478     function ownerOf(uint256 tokenId) external view returns (address owner);
479 
480     /**
481      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
482      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must exist and be owned by `from`.
489      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
490      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491      *
492      * Emits a {Transfer} event.
493      */
494     function safeTransferFrom(
495         address from,
496         address to,
497         uint256 tokenId
498     ) external;
499 
500     /**
501      * @dev Transfers `tokenId` token from `from` to `to`.
502      *
503      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must be owned by `from`.
510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transferFrom(
515         address from,
516         address to,
517         uint256 tokenId
518     ) external;
519 
520     /**
521      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
522      * The approval is cleared when the token is transferred.
523      *
524      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
525      *
526      * Requirements:
527      *
528      * - The caller must own the token or be an approved operator.
529      * - `tokenId` must exist.
530      *
531      * Emits an {Approval} event.
532      */
533     function approve(address to, uint256 tokenId) external;
534 
535     /**
536      * @dev Returns the account approved for `tokenId` token.
537      *
538      * Requirements:
539      *
540      * - `tokenId` must exist.
541      */
542     function getApproved(uint256 tokenId) external view returns (address operator);
543 
544     /**
545      * @dev Approve or remove `operator` as an operator for the caller.
546      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
547      *
548      * Requirements:
549      *
550      * - The `operator` cannot be the caller.
551      *
552      * Emits an {ApprovalForAll} event.
553      */
554     function setApprovalForAll(address operator, bool _approved) external;
555 
556     /**
557      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
558      *
559      * See {setApprovalForAll}
560      */
561     function isApprovedForAll(address owner, address operator) external view returns (bool);
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId,
580         bytes calldata data
581     ) external;
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
594  * @dev See https://eips.ethereum.org/EIPS/eip-721
595  */
596 interface IERC721Metadata is IERC721 {
597     /**
598      * @dev Returns the token collection name.
599      */
600     function name() external view returns (string memory);
601 
602     /**
603      * @dev Returns the token collection symbol.
604      */
605     function symbol() external view returns (string memory);
606 
607     /**
608      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
609      */
610     function tokenURI(uint256 tokenId) external view returns (string memory);
611 }
612 
613 // File: contracts/new.sol
614 
615 
616 
617 
618 pragma solidity ^0.8.4;
619 
620 
621 
622 
623 
624 
625 
626 
627 error ApprovalCallerNotOwnerNorApproved();
628 error ApprovalQueryForNonexistentToken();
629 error ApproveToCaller();
630 error ApprovalToCurrentOwner();
631 error BalanceQueryForZeroAddress();
632 error MintToZeroAddress();
633 error MintZeroQuantity();
634 error OwnerQueryForNonexistentToken();
635 error TransferCallerNotOwnerNorApproved();
636 error TransferFromIncorrectOwner();
637 error TransferToNonERC721ReceiverImplementer();
638 error TransferToZeroAddress();
639 error URIQueryForNonexistentToken();
640 
641 /**
642  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
643  * the Metadata extension. Built to optimize for lower gas during batch mints.
644  *
645  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
646  *
647  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
648  *
649  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
650  */
651 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
652     using Address for address;
653     using Strings for uint256;
654 
655     // Compiler will pack this into a single 256bit word.
656     struct TokenOwnership {
657         // The address of the owner.
658         address addr;
659         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
660         uint64 startTimestamp;
661         // Whether the token has been burned.
662         bool burned;
663     }
664 
665     // Compiler will pack this into a single 256bit word.
666     struct AddressData {
667         // Realistically, 2**64-1 is more than enough.
668         uint64 balance;
669         // Keeps track of mint count with minimal overhead for tokenomics.
670         uint64 numberMinted;
671         // Keeps track of burn count with minimal overhead for tokenomics.
672         uint64 numberBurned;
673         // For miscellaneous variable(s) pertaining to the address
674         // (e.g. number of whitelist mint slots used).
675         // If there are multiple variables, please pack them into a uint64.
676         uint64 aux;
677     }
678 
679     // The tokenId of the next token to be minted.
680     uint256 internal _currentIndex;
681 
682     // The number of tokens burned.
683     uint256 internal _burnCounter;
684 
685     // Token name
686     string private _name;
687 
688     // Token symbol
689     string private _symbol;
690 
691     // Mapping from token ID to ownership details
692     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
693     mapping(uint256 => TokenOwnership) internal _ownerships;
694 
695     // Mapping owner address to address data
696     mapping(address => AddressData) private _addressData;
697 
698     // Mapping from token ID to approved address
699     mapping(uint256 => address) private _tokenApprovals;
700 
701     // Mapping from owner to operator approvals
702     mapping(address => mapping(address => bool)) private _operatorApprovals;
703 
704     constructor(string memory name_, string memory symbol_) {
705         _name = name_;
706         _symbol = symbol_;
707         _currentIndex = _startTokenId();
708     }
709 
710     /**
711      * To change the starting tokenId, please override this function.
712      */
713     function _startTokenId() internal view virtual returns (uint256) {
714         return 0;
715     }
716 
717     /**
718      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
719      */
720     function totalSupply() public view returns (uint256) {
721         // Counter underflow is impossible as _burnCounter cannot be incremented
722         // more than _currentIndex - _startTokenId() times
723         unchecked {
724             return _currentIndex - _burnCounter - _startTokenId();
725         }
726     }
727 
728     /**
729      * Returns the total amount of tokens minted in the contract.
730      */
731     function _totalMinted() internal view returns (uint256) {
732         // Counter underflow is impossible as _currentIndex does not decrement,
733         // and it is initialized to _startTokenId()
734         unchecked {
735             return _currentIndex - _startTokenId();
736         }
737     }
738 
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
743         return
744             interfaceId == type(IERC721).interfaceId ||
745             interfaceId == type(IERC721Metadata).interfaceId ||
746             super.supportsInterface(interfaceId);
747     }
748 
749     /**
750      * @dev See {IERC721-balanceOf}.
751      */
752     function balanceOf(address owner) public view override returns (uint256) {
753         if (owner == address(0)) revert BalanceQueryForZeroAddress();
754         return uint256(_addressData[owner].balance);
755     }
756 
757     /**
758      * Returns the number of tokens minted by `owner`.
759      */
760     function _numberMinted(address owner) internal view returns (uint256) {
761         return uint256(_addressData[owner].numberMinted);
762     }
763 
764     /**
765      * Returns the number of tokens burned by or on behalf of `owner`.
766      */
767     function _numberBurned(address owner) internal view returns (uint256) {
768         return uint256(_addressData[owner].numberBurned);
769     }
770 
771     /**
772      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
773      */
774     function _getAux(address owner) internal view returns (uint64) {
775         return _addressData[owner].aux;
776     }
777 
778     /**
779      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
780      * If there are multiple variables, please pack them into a uint64.
781      */
782     function _setAux(address owner, uint64 aux) internal {
783         _addressData[owner].aux = aux;
784     }
785 
786     /**
787      * Gas spent here starts off proportional to the maximum mint batch size.
788      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
789      */
790     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
791         uint256 curr = tokenId;
792 
793         unchecked {
794             if (_startTokenId() <= curr && curr < _currentIndex) {
795                 TokenOwnership memory ownership = _ownerships[curr];
796                 if (!ownership.burned) {
797                     if (ownership.addr != address(0)) {
798                         return ownership;
799                     }
800                     // Invariant:
801                     // There will always be an ownership that has an address and is not burned
802                     // before an ownership that does not have an address and is not burned.
803                     // Hence, curr will not underflow.
804                     while (true) {
805                         curr--;
806                         ownership = _ownerships[curr];
807                         if (ownership.addr != address(0)) {
808                             return ownership;
809                         }
810                     }
811                 }
812             }
813         }
814         revert OwnerQueryForNonexistentToken();
815     }
816 
817     /**
818      * @dev See {IERC721-ownerOf}.
819      */
820     function ownerOf(uint256 tokenId) public view override returns (address) {
821         return _ownershipOf(tokenId).addr;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-name}.
826      */
827     function name() public view virtual override returns (string memory) {
828         return _name;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-symbol}.
833      */
834     function symbol() public view virtual override returns (string memory) {
835         return _symbol;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-tokenURI}.
840      */
841     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
842         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
843 
844         string memory baseURI = _baseURI();
845         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
846     }
847 
848     /**
849      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
850      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
851      * by default, can be overriden in child contracts.
852      */
853     function _baseURI() internal view virtual returns (string memory) {
854         return '';
855     }
856 
857     /**
858      * @dev See {IERC721-approve}.
859      */
860     function approve(address to, uint256 tokenId) public override {
861         address owner = ERC721A.ownerOf(tokenId);
862         if (to == owner) revert ApprovalToCurrentOwner();
863 
864         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
865             revert ApprovalCallerNotOwnerNorApproved();
866         }
867 
868         _approve(to, tokenId, owner);
869     }
870 
871     /**
872      * @dev See {IERC721-getApproved}.
873      */
874     function getApproved(uint256 tokenId) public view override returns (address) {
875         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
876 
877         return _tokenApprovals[tokenId];
878     }
879 
880     /**
881      * @dev See {IERC721-setApprovalForAll}.
882      */
883     function setApprovalForAll(address operator, bool approved) public virtual override {
884         if (operator == _msgSender()) revert ApproveToCaller();
885 
886         _operatorApprovals[_msgSender()][operator] = approved;
887         emit ApprovalForAll(_msgSender(), operator, approved);
888     }
889 
890     /**
891      * @dev See {IERC721-isApprovedForAll}.
892      */
893     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
894         return _operatorApprovals[owner][operator];
895     }
896 
897     /**
898      * @dev See {IERC721-transferFrom}.
899      */
900     function transferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         _transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public virtual override {
916         safeTransferFrom(from, to, tokenId, '');
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) public virtual override {
928         _transfer(from, to, tokenId);
929         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
930             revert TransferToNonERC721ReceiverImplementer();
931         }
932     }
933 
934     /**
935      * @dev Returns whether `tokenId` exists.
936      *
937      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
938      *
939      * Tokens start existing when they are minted (`_mint`),
940      */
941     function _exists(uint256 tokenId) internal view returns (bool) {
942         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
943             !_ownerships[tokenId].burned;
944     }
945 
946     function _safeMint(address to, uint256 quantity) internal {
947         _safeMint(to, quantity, '');
948     }
949 
950     /**
951      * @dev Safely mints `quantity` tokens and transfers them to `to`.
952      *
953      * Requirements:
954      *
955      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
956      * - `quantity` must be greater than 0.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _safeMint(
961         address to,
962         uint256 quantity,
963         bytes memory _data
964     ) internal {
965         _mint(to, quantity, _data, true);
966     }
967 
968     /**
969      * @dev Mints `quantity` tokens and transfers them to `to`.
970      *
971      * Requirements:
972      *
973      * - `to` cannot be the zero address.
974      * - `quantity` must be greater than 0.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _mint(
979         address to,
980         uint256 quantity,
981         bytes memory _data,
982         bool safe
983     ) internal {
984         uint256 startTokenId = _currentIndex;
985         if (to == address(0)) revert MintToZeroAddress();
986         if (quantity == 0) revert MintZeroQuantity();
987 
988         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
989 
990         // Overflows are incredibly unrealistic.
991         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
992         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
993         unchecked {
994             _addressData[to].balance += uint64(quantity);
995             _addressData[to].numberMinted += uint64(quantity);
996 
997             _ownerships[startTokenId].addr = to;
998             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
999 
1000             uint256 updatedIndex = startTokenId;
1001             uint256 end = updatedIndex + quantity;
1002 
1003             if (safe && to.isContract()) {
1004                 do {
1005                     emit Transfer(address(0), to, updatedIndex);
1006                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1007                         revert TransferToNonERC721ReceiverImplementer();
1008                     }
1009                 } while (updatedIndex != end);
1010                 // Reentrancy protection
1011                 if (_currentIndex != startTokenId) revert();
1012             } else {
1013                 do {
1014                     emit Transfer(address(0), to, updatedIndex++);
1015                 } while (updatedIndex != end);
1016             }
1017             _currentIndex = updatedIndex;
1018         }
1019         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1020     }
1021 
1022     /**
1023      * @dev Transfers `tokenId` from `from` to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must be owned by `from`.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _transfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) private {
1037         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1038 
1039         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1040 
1041         bool isApprovedOrOwner = (_msgSender() == from ||
1042             isApprovedForAll(from, _msgSender()) ||
1043             getApproved(tokenId) == _msgSender());
1044 
1045         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1046         if (to == address(0)) revert TransferToZeroAddress();
1047 
1048         _beforeTokenTransfers(from, to, tokenId, 1);
1049 
1050         // Clear approvals from the previous owner
1051         _approve(address(0), tokenId, from);
1052 
1053         // Underflow of the sender's balance is impossible because we check for
1054         // ownership above and the recipient's balance can't realistically overflow.
1055         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1056         unchecked {
1057             _addressData[from].balance -= 1;
1058             _addressData[to].balance += 1;
1059 
1060             TokenOwnership storage currSlot = _ownerships[tokenId];
1061             currSlot.addr = to;
1062             currSlot.startTimestamp = uint64(block.timestamp);
1063 
1064             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1065             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1066             uint256 nextTokenId = tokenId + 1;
1067             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1068             if (nextSlot.addr == address(0)) {
1069                 // This will suffice for checking _exists(nextTokenId),
1070                 // as a burned slot cannot contain the zero address.
1071                 if (nextTokenId != _currentIndex) {
1072                     nextSlot.addr = from;
1073                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1074                 }
1075             }
1076         }
1077 
1078         emit Transfer(from, to, tokenId);
1079         _afterTokenTransfers(from, to, tokenId, 1);
1080     }
1081 
1082     /**
1083      * @dev This is equivalent to _burn(tokenId, false)
1084      */
1085     function _burn(uint256 tokenId) internal virtual {
1086         _burn(tokenId, false);
1087     }
1088 
1089     /**
1090      * @dev Destroys `tokenId`.
1091      * The approval is cleared when the token is burned.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must exist.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1100         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1101 
1102         address from = prevOwnership.addr;
1103 
1104         if (approvalCheck) {
1105             bool isApprovedOrOwner = (_msgSender() == from ||
1106                 isApprovedForAll(from, _msgSender()) ||
1107                 getApproved(tokenId) == _msgSender());
1108 
1109             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1110         }
1111 
1112         _beforeTokenTransfers(from, address(0), tokenId, 1);
1113 
1114         // Clear approvals from the previous owner
1115         _approve(address(0), tokenId, from);
1116 
1117         // Underflow of the sender's balance is impossible because we check for
1118         // ownership above and the recipient's balance can't realistically overflow.
1119         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1120         unchecked {
1121             AddressData storage addressData = _addressData[from];
1122             addressData.balance -= 1;
1123             addressData.numberBurned += 1;
1124 
1125             // Keep track of who burned the token, and the timestamp of burning.
1126             TokenOwnership storage currSlot = _ownerships[tokenId];
1127             currSlot.addr = from;
1128             currSlot.startTimestamp = uint64(block.timestamp);
1129             currSlot.burned = true;
1130 
1131             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1132             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1133             uint256 nextTokenId = tokenId + 1;
1134             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1135             if (nextSlot.addr == address(0)) {
1136                 // This will suffice for checking _exists(nextTokenId),
1137                 // as a burned slot cannot contain the zero address.
1138                 if (nextTokenId != _currentIndex) {
1139                     nextSlot.addr = from;
1140                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1141                 }
1142             }
1143         }
1144 
1145         emit Transfer(from, address(0), tokenId);
1146         _afterTokenTransfers(from, address(0), tokenId, 1);
1147 
1148         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1149         unchecked {
1150             _burnCounter++;
1151         }
1152     }
1153 
1154     /**
1155      * @dev Approve `to` to operate on `tokenId`
1156      *
1157      * Emits a {Approval} event.
1158      */
1159     function _approve(
1160         address to,
1161         uint256 tokenId,
1162         address owner
1163     ) private {
1164         _tokenApprovals[tokenId] = to;
1165         emit Approval(owner, to, tokenId);
1166     }
1167 
1168     /**
1169      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1170      *
1171      * @param from address representing the previous owner of the given token ID
1172      * @param to target address that will receive the tokens
1173      * @param tokenId uint256 ID of the token to be transferred
1174      * @param _data bytes optional data to send along with the call
1175      * @return bool whether the call correctly returned the expected magic value
1176      */
1177     function _checkContractOnERC721Received(
1178         address from,
1179         address to,
1180         uint256 tokenId,
1181         bytes memory _data
1182     ) private returns (bool) {
1183         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1184             return retval == IERC721Receiver(to).onERC721Received.selector;
1185         } catch (bytes memory reason) {
1186             if (reason.length == 0) {
1187                 revert TransferToNonERC721ReceiverImplementer();
1188             } else {
1189                 assembly {
1190                     revert(add(32, reason), mload(reason))
1191                 }
1192             }
1193         }
1194     }
1195 
1196     /**
1197      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1198      * And also called before burning one token.
1199      *
1200      * startTokenId - the first token id to be transferred
1201      * quantity - the amount to be transferred
1202      *
1203      * Calling conditions:
1204      *
1205      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1206      * transferred to `to`.
1207      * - When `from` is zero, `tokenId` will be minted for `to`.
1208      * - When `to` is zero, `tokenId` will be burned by `from`.
1209      * - `from` and `to` are never both zero.
1210      */
1211     function _beforeTokenTransfers(
1212         address from,
1213         address to,
1214         uint256 startTokenId,
1215         uint256 quantity
1216     ) internal virtual {}
1217 
1218     /**
1219      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1220      * minting.
1221      * And also called after one token has been burned.
1222      *
1223      * startTokenId - the first token id to be transferred
1224      * quantity - the amount to be transferred
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` has been minted for `to`.
1231      * - When `to` is zero, `tokenId` has been burned by `from`.
1232      * - `from` and `to` are never both zero.
1233      */
1234     function _afterTokenTransfers(
1235         address from,
1236         address to,
1237         uint256 startTokenId,
1238         uint256 quantity
1239     ) internal virtual {}
1240 }
1241 
1242 abstract contract Ownable is Context {
1243     address private _owner;
1244 
1245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1246 
1247     /**
1248      * @dev Initializes the contract setting the deployer as the initial owner.
1249      */
1250     constructor() {
1251         _transferOwnership(_msgSender());
1252     }
1253 
1254     /**
1255      * @dev Returns the address of the current owner.
1256      */
1257     function owner() public view virtual returns (address) {
1258         return _owner;
1259     }
1260 
1261     /**
1262      * @dev Throws if called by any account other than the owner.
1263      */
1264     modifier onlyOwner() {
1265         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1266         _;
1267     }
1268 
1269     /**
1270      * @dev Leaves the contract without owner. It will not be possible to call
1271      * `onlyOwner` functions anymore. Can only be called by the current owner.
1272      *
1273      * NOTE: Renouncing ownership will leave the contract without an owner,
1274      * thereby removing any functionality that is only available to the owner.
1275      */
1276     function renounceOwnership() public virtual onlyOwner {
1277         _transferOwnership(address(0));
1278     }
1279 
1280     /**
1281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1282      * Can only be called by the current owner.
1283      */
1284     function transferOwnership(address newOwner) public virtual onlyOwner {
1285         require(newOwner != address(0), "Ownable: new owner is the zero address");
1286         _transferOwnership(newOwner);
1287     }
1288 
1289     /**
1290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1291      * Internal function without access restriction.
1292      */
1293     function _transferOwnership(address newOwner) internal virtual {
1294         address oldOwner = _owner;
1295         _owner = newOwner;
1296         emit OwnershipTransferred(oldOwner, newOwner);
1297     }
1298 }
1299     pragma solidity ^0.8.7;
1300     
1301     contract EGGSareGOOD is ERC721A, Ownable {
1302     using Strings for uint256;
1303 
1304 
1305   string private uriPrefix ;
1306   string private uriSuffix = ".json";
1307   string public hiddenURL;
1308 
1309   
1310   
1311 
1312   uint256 public cost = 0.00 ether;
1313   uint256 public whiteListCost = 0 ;
1314   
1315 
1316   uint16 public maxSupply = 999;
1317   uint8 public maxMintAmountPerTx = 2;
1318     uint8 public maxFreeMintAmountPerWallet = 2;
1319                                                              
1320   bool public WLpaused = true;
1321   bool public paused = true;
1322   bool public reveal =false;
1323   mapping (address => uint8) public NFTPerWLAddress;
1324    mapping (address => uint8) public NFTPerPublicAddress;
1325   mapping (address => bool) public isWhitelisted;
1326  
1327   
1328   
1329  
1330   
1331 
1332   constructor() ERC721A("egg on mi head", "egg") {
1333   }
1334 
1335  function burn(uint[] calldata token) external onlyOwner{
1336      for(uint i ; i <token.length ; i ++)
1337    _burn(token[i]);
1338  }
1339   
1340 
1341   
1342  
1343   function mint(uint8 _mintAmount) external payable  {
1344      uint16 totalSupply = uint16(totalSupply());
1345      uint8 nft = NFTPerPublicAddress[msg.sender];
1346     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1347     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1348 
1349     require(!paused, "The contract is paused!");
1350     
1351       if(nft >= maxFreeMintAmountPerWallet)
1352     {
1353     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1354     }
1355     else {
1356          uint8 costAmount = _mintAmount + nft;
1357         if(costAmount > maxFreeMintAmountPerWallet)
1358        {
1359         costAmount = costAmount - maxFreeMintAmountPerWallet;
1360         require(msg.value >= cost * costAmount, "Insufficient funds!");
1361        }
1362        
1363          
1364     }
1365     
1366 
1367 
1368     _safeMint(msg.sender , _mintAmount);
1369 
1370     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1371      
1372      delete totalSupply;
1373      delete _mintAmount;
1374   }
1375   
1376   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1377      uint16 totalSupply = uint16(totalSupply());
1378     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1379      _safeMint(_receiver , _mintAmount);
1380      delete _mintAmount;
1381      delete _receiver;
1382      delete totalSupply;
1383   }
1384 
1385   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1386      uint16 totalSupply = uint16(totalSupply());
1387      uint totalAmount =   _amountPerAddress * addresses.length;
1388     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1389      for (uint256 i = 0; i < addresses.length; i++) {
1390             _safeMint(addresses[i], _amountPerAddress);
1391         }
1392 
1393      delete _amountPerAddress;
1394      delete totalSupply;
1395   }
1396 
1397  
1398 
1399   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1400       maxSupply = _maxSupply;
1401   }
1402 
1403 
1404 
1405    
1406   function tokenURI(uint256 _tokenId)
1407     public
1408     view
1409     virtual
1410     override
1411     returns (string memory)
1412   {
1413     require(
1414       _exists(_tokenId),
1415       "ERC721Metadata: URI query for nonexistent token"
1416     );
1417     
1418   
1419 if ( reveal == false)
1420 {
1421     return hiddenURL;
1422 }
1423     
1424 
1425     string memory currentBaseURI = _baseURI();
1426     return bytes(currentBaseURI).length > 0
1427         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1428         : "";
1429   }
1430  
1431    function setWLPaused() external onlyOwner {
1432     WLpaused = !WLpaused;
1433   }
1434   function setWLCost(uint256 _cost) external onlyOwner {
1435     whiteListCost = _cost;
1436     delete _cost;
1437   }
1438 
1439 
1440 
1441  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1442     maxFreeMintAmountPerWallet = _limit;
1443    delete _limit;
1444 
1445 }
1446 
1447     
1448   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1449         for(uint8 i = 0; i < entries.length; i++) {
1450             isWhitelisted[entries[i]] = true;
1451         }   
1452     }
1453 
1454     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1455         for(uint8 i = 0; i < entries.length; i++) {
1456              isWhitelisted[entries[i]] = false;
1457         }
1458     }
1459 
1460 function whitelistMint(uint8 _mintAmount) external payable {
1461         
1462     
1463         uint8 nft = NFTPerWLAddress[msg.sender];
1464        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1465 
1466        require (nft + _mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per address");
1467       
1468 
1469 
1470     require(!WLpaused, "Whitelist minting is over!");
1471          if(nft >= maxFreeMintAmountPerWallet)
1472     {
1473     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1474     }
1475     else {
1476          uint8 costAmount = _mintAmount + nft;
1477         if(costAmount > maxFreeMintAmountPerWallet)
1478        {
1479         costAmount = costAmount - maxFreeMintAmountPerWallet;
1480         require(msg.value >= whiteListCost * costAmount, "Insufficient funds!");
1481        }
1482        
1483          
1484     }
1485     
1486     
1487 
1488      _safeMint(msg.sender , _mintAmount);
1489       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1490      
1491       delete _mintAmount;
1492        delete nft;
1493     
1494     }
1495 
1496   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1497     uriPrefix = _uriPrefix;
1498   }
1499    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1500     hiddenURL = _uriPrefix;
1501   }
1502 
1503 
1504   function setPaused() external onlyOwner {
1505     paused = !paused;
1506     WLpaused = true;
1507   }
1508 
1509   function setCost(uint _cost) external onlyOwner{
1510       cost = _cost;
1511 
1512   }
1513 
1514  function setRevealed() external onlyOwner{
1515      reveal = !reveal;
1516  }
1517 
1518   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1519       maxMintAmountPerTx = _maxtx;
1520 
1521   }
1522 
1523  
1524 
1525   function withdraw() external onlyOwner {
1526   uint _balance = address(this).balance;
1527      payable(msg.sender).transfer(_balance ); 
1528        
1529   }
1530 
1531 
1532   function _baseURI() internal view  override returns (string memory) {
1533     return uriPrefix;
1534   }
1535 }