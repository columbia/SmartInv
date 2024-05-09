1 /**
2  (
3 (_)
4 ###       .
5 (#c    __\|/__
6  #\     wWWWw
7  \ \-. (/. .\)
8  /\ /`\/\   /\
9  |\/   \_) (_|
10  `\.' ; ; `' ;`\
11    `\;  ;    .  ;/\
12      `\;    ;  ;|  \
13       ;   .'  ' ;  /
14       |_.'   ;  | /)
15       (     ''._;/`
16       |    ' . ;
17       |.-'   .:)
18       |        |
19       (  .'  : |
20       |,-  .:: |
21       | ,-'  .;|
22   wan_/___,_.:_\_
23     [I_I_I_I_I_I_]
24     | __________ |
25     | || |  | || |
26    _| ||_|__|_|| |_
27   /=--------------=\
28  /                  \
29 |                    |
30  */
31 // SPDX-License-Identifier: MIT
32 //Developer Info: 
33 
34 
35 
36 // File: @openzeppelin/contracts/utils/Strings.sol
37 
38 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev String operations.
44  */
45 library Strings {
46     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
50      */
51     function toString(uint256 value) internal pure returns (string memory) {
52         // Inspired by OraclizeAPI's implementation - MIT licence
53         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
54 
55         if (value == 0) {
56             return "0";
57         }
58         uint256 temp = value;
59         uint256 digits;
60         while (temp != 0) {
61             digits++;
62             temp /= 10;
63         }
64         bytes memory buffer = new bytes(digits);
65         while (value != 0) {
66             digits -= 1;
67             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
68             value /= 10;
69         }
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
75      */
76     function toHexString(uint256 value) internal pure returns (string memory) {
77         if (value == 0) {
78             return "0x00";
79         }
80         uint256 temp = value;
81         uint256 length = 0;
82         while (temp != 0) {
83             length++;
84             temp >>= 8;
85         }
86         return toHexString(value, length);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
91      */
92     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
93         bytes memory buffer = new bytes(2 * length + 2);
94         buffer[0] = "0";
95         buffer[1] = "x";
96         for (uint256 i = 2 * length + 1; i > 1; --i) {
97             buffer[i] = _HEX_SYMBOLS[value & 0xf];
98             value >>= 4;
99         }
100         require(value == 0, "Strings: hex length insufficient");
101         return string(buffer);
102     }
103 }
104 
105 // File: @openzeppelin/contracts/utils/Context.sol
106 
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Provides information about the current execution context, including the
114  * sender of the transaction and its data. While these are generally available
115  * via msg.sender and msg.data, they should not be accessed in such a direct
116  * manner, since when dealing with meta-transactions the account sending and
117  * paying for execution may not be the actual sender (as far as an application
118  * is concerned).
119  *
120  * This contract is only required for intermediate, library-like contracts.
121  */
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         return msg.data;
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/Address.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
136 
137 pragma solidity ^0.8.1;
138 
139 /**
140  * @dev Collection of functions related to the address type
141  */
142 library Address {
143     /**
144      * @dev Returns true if `account` is a contract.
145      *
146      * [IMPORTANT]
147      * ====
148      * It is unsafe to assume that an address for which this function returns
149      * false is an externally-owned account (EOA) and not a contract.
150      *
151      * Among others, `isContract` will return false for the following
152      * types of addresses:
153      *
154      *  - an externally-owned account
155      *  - a contract in construction
156      *  - an address where a contract will be created
157      *  - an address where a contract lived, but was destroyed
158      * ====
159      *
160      * [IMPORTANT]
161      * ====
162      * You shouldn't rely on `isContract` to protect against flash loan attacks!
163      *
164      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
165      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
166      * constructor.
167      * ====
168      */
169     function isContract(address account) internal view returns (bool) {
170         // This method relies on extcodesize/address.code.length, which returns 0
171         // for contracts in construction, since the code is only stored at the end
172         // of the constructor execution.
173 
174         return account.code.length > 0;
175     }
176 
177     /**
178      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
179      * `recipient`, forwarding all available gas and reverting on errors.
180      *
181      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
182      * of certain opcodes, possibly making contracts go over the 2300 gas limit
183      * imposed by `transfer`, making them unable to receive funds via
184      * `transfer`. {sendValue} removes this limitation.
185      *
186      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
187      *
188      * IMPORTANT: because control is transferred to `recipient`, care must be
189      * taken to not create reentrancy vulnerabilities. Consider using
190      * {ReentrancyGuard} or the
191      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
192      */
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(success, "Address: unable to send value, recipient may have reverted");
198     }
199 
200     /**
201      * @dev Performs a Solidity function call using a low level `call`. A
202      * plain `call` is an unsafe replacement for a function call: use this
203      * function instead.
204      *
205      * If `target` reverts with a revert reason, it is bubbled up by this
206      * function (like regular Solidity function calls).
207      *
208      * Returns the raw returned data. To convert to the expected return value,
209      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
210      *
211      * Requirements:
212      *
213      * - `target` must be a contract.
214      * - calling `target` with `data` must not revert.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionCall(target, data, "Address: low-level call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
224      * `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but also transferring `value` wei to `target`.
239      *
240      * Requirements:
241      *
242      * - the calling contract must have an ETH balance of at least `value`.
243      * - the called Solidity function must be `payable`.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
257      * with `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(address(this).balance >= value, "Address: insufficient balance for call");
268         require(isContract(target), "Address: call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.call{value: value}(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
281         return functionStaticCall(target, data, "Address: low-level static call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         require(isContract(target), "Address: static call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.staticcall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but performing a delegate call.
304      *
305      * _Available since v3.4._
306      */
307     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
313      * but performing a delegate call.
314      *
315      * _Available since v3.4._
316      */
317     function functionDelegateCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(isContract(target), "Address: delegate call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.delegatecall(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
330      * revert reason using the provided one.
331      *
332      * _Available since v4.3._
333      */
334     function verifyCallResult(
335         bool success,
336         bytes memory returndata,
337         string memory errorMessage
338     ) internal pure returns (bytes memory) {
339         if (success) {
340             return returndata;
341         } else {
342             // Look for revert reason and bubble it up if present
343             if (returndata.length > 0) {
344                 // The easiest way to bubble the revert reason is using memory via assembly
345 
346                 assembly {
347                     let returndata_size := mload(returndata)
348                     revert(add(32, returndata), returndata_size)
349                 }
350             } else {
351                 revert(errorMessage);
352             }
353         }
354     }
355 }
356 
357 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @title ERC721 token receiver interface
366  * @dev Interface for any contract that wants to support safeTransfers
367  * from ERC721 asset contracts.
368  */
369 interface IERC721Receiver {
370     /**
371      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
372      * by `operator` from `from`, this function is called.
373      *
374      * It must return its Solidity selector to confirm the token transfer.
375      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
376      *
377      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
378      */
379     function onERC721Received(
380         address operator,
381         address from,
382         uint256 tokenId,
383         bytes calldata data
384     ) external returns (bytes4);
385 }
386 
387 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Interface of the ERC165 standard, as defined in the
396  * https://eips.ethereum.org/EIPS/eip-165[EIP].
397  *
398  * Implementers can declare support of contract interfaces, which can then be
399  * queried by others ({ERC165Checker}).
400  *
401  * For an implementation, see {ERC165}.
402  */
403 interface IERC165 {
404     /**
405      * @dev Returns true if this contract implements the interface defined by
406      * `interfaceId`. See the corresponding
407      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
408      * to learn more about how these ids are created.
409      *
410      * This function call must use less than 30 000 gas.
411      */
412     function supportsInterface(bytes4 interfaceId) external view returns (bool);
413 }
414 
415 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Implementation of the {IERC165} interface.
425  *
426  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
427  * for the additional interface id that will be supported. For example:
428  *
429  * ```solidity
430  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
432  * }
433  * ```
434  *
435  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
436  */
437 abstract contract ERC165 is IERC165 {
438     /**
439      * @dev See {IERC165-supportsInterface}.
440      */
441     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
442         return interfaceId == type(IERC165).interfaceId;
443     }
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Required interface of an ERC721 compliant contract.
456  */
457 interface IERC721 is IERC165 {
458     /**
459      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
460      */
461     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
462 
463     /**
464      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
465      */
466     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
470      */
471     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
472 
473     /**
474      * @dev Returns the number of tokens in ``owner``'s account.
475      */
476     function balanceOf(address owner) external view returns (uint256 balance);
477 
478     /**
479      * @dev Returns the owner of the `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function ownerOf(uint256 tokenId) external view returns (address owner);
486 
487     /**
488      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
489      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must exist and be owned by `from`.
496      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
497      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
498      *
499      * Emits a {Transfer} event.
500      */
501     function safeTransferFrom(
502         address from,
503         address to,
504         uint256 tokenId
505     ) external;
506 
507     /**
508      * @dev Transfers `tokenId` token from `from` to `to`.
509      *
510      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      *
519      * Emits a {Transfer} event.
520      */
521     function transferFrom(
522         address from,
523         address to,
524         uint256 tokenId
525     ) external;
526 
527     /**
528      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
529      * The approval is cleared when the token is transferred.
530      *
531      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
532      *
533      * Requirements:
534      *
535      * - The caller must own the token or be an approved operator.
536      * - `tokenId` must exist.
537      *
538      * Emits an {Approval} event.
539      */
540     function approve(address to, uint256 tokenId) external;
541 
542     /**
543      * @dev Returns the account approved for `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function getApproved(uint256 tokenId) external view returns (address operator);
550 
551     /**
552      * @dev Approve or remove `operator` as an operator for the caller.
553      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
554      *
555      * Requirements:
556      *
557      * - The `operator` cannot be the caller.
558      *
559      * Emits an {ApprovalForAll} event.
560      */
561     function setApprovalForAll(address operator, bool _approved) external;
562 
563     /**
564      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
565      *
566      * See {setApprovalForAll}
567      */
568     function isApprovedForAll(address owner, address operator) external view returns (bool);
569 
570     /**
571      * @dev Safely transfers `tokenId` token from `from` to `to`.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId,
587         bytes calldata data
588     ) external;
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
601  * @dev See https://eips.ethereum.org/EIPS/eip-721
602  */
603 interface IERC721Metadata is IERC721 {
604     /**
605      * @dev Returns the token collection name.
606      */
607     function name() external view returns (string memory);
608 
609     /**
610      * @dev Returns the token collection symbol.
611      */
612     function symbol() external view returns (string memory);
613 
614     /**
615      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
616      */
617     function tokenURI(uint256 tokenId) external view returns (string memory);
618 }
619 
620 // File: contracts/new.sol
621 
622 
623 
624 
625 pragma solidity ^0.8.4;
626 
627 
628 
629 
630 
631 
632 
633 
634 error ApprovalCallerNotOwnerNorApproved();
635 error ApprovalQueryForNonexistentToken();
636 error ApproveToCaller();
637 error ApprovalToCurrentOwner();
638 error BalanceQueryForZeroAddress();
639 error MintToZeroAddress();
640 error MintZeroQuantity();
641 error OwnerQueryForNonexistentToken();
642 error TransferCallerNotOwnerNorApproved();
643 error TransferFromIncorrectOwner();
644 error TransferToNonERC721ReceiverImplementer();
645 error TransferToZeroAddress();
646 error URIQueryForNonexistentToken();
647 
648 /**
649  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
650  * the Metadata extension. Built to optimize for lower gas during batch mints.
651  *
652  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
653  *
654  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
655  *
656  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
657  */
658 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
659     using Address for address;
660     using Strings for uint256;
661 
662     // Compiler will pack this into a single 256bit word.
663     struct TokenOwnership {
664         // The address of the owner.
665         address addr;
666         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
667         uint64 startTimestamp;
668         // Whether the token has been burned.
669         bool burned;
670     }
671 
672     // Compiler will pack this into a single 256bit word.
673     struct AddressData {
674         // Realistically, 2**64-1 is more than enough.
675         uint64 balance;
676         // Keeps track of mint count with minimal overhead for tokenomics.
677         uint64 numberMinted;
678         // Keeps track of burn count with minimal overhead for tokenomics.
679         uint64 numberBurned;
680         // For miscellaneous variable(s) pertaining to the address
681         // (e.g. number of whitelist mint slots used).
682         // If there are multiple variables, please pack them into a uint64.
683         uint64 aux;
684     }
685 
686     // The tokenId of the next token to be minted.
687     uint256 internal _currentIndex;
688 
689     // The number of tokens burned.
690     uint256 internal _burnCounter;
691 
692     // Token name
693     string private _name;
694 
695     // Token symbol
696     string private _symbol;
697 
698     // Mapping from token ID to ownership details
699     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
700     mapping(uint256 => TokenOwnership) internal _ownerships;
701 
702     // Mapping owner address to address data
703     mapping(address => AddressData) private _addressData;
704 
705     // Mapping from token ID to approved address
706     mapping(uint256 => address) private _tokenApprovals;
707 
708     // Mapping from owner to operator approvals
709     mapping(address => mapping(address => bool)) private _operatorApprovals;
710 
711     constructor(string memory name_, string memory symbol_) {
712         _name = name_;
713         _symbol = symbol_;
714         _currentIndex = _startTokenId();
715     }
716 
717     /**
718      * To change the starting tokenId, please override this function.
719      */
720     function _startTokenId() internal view virtual returns (uint256) {
721         return 0;
722     }
723 
724     /**
725      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
726      */
727     function totalSupply() public view returns (uint256) {
728         // Counter underflow is impossible as _burnCounter cannot be incremented
729         // more than _currentIndex - _startTokenId() times
730         unchecked {
731             return _currentIndex - _burnCounter - _startTokenId();
732         }
733     }
734 
735     /**
736      * Returns the total amount of tokens minted in the contract.
737      */
738     function _totalMinted() internal view returns (uint256) {
739         // Counter underflow is impossible as _currentIndex does not decrement,
740         // and it is initialized to _startTokenId()
741         unchecked {
742             return _currentIndex - _startTokenId();
743         }
744     }
745 
746     /**
747      * @dev See {IERC165-supportsInterface}.
748      */
749     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
750         return
751             interfaceId == type(IERC721).interfaceId ||
752             interfaceId == type(IERC721Metadata).interfaceId ||
753             super.supportsInterface(interfaceId);
754     }
755 
756     /**
757      * @dev See {IERC721-balanceOf}.
758      */
759     function balanceOf(address owner) public view override returns (uint256) {
760         if (owner == address(0)) revert BalanceQueryForZeroAddress();
761         return uint256(_addressData[owner].balance);
762     }
763 
764     /**
765      * Returns the number of tokens minted by `owner`.
766      */
767     function _numberMinted(address owner) internal view returns (uint256) {
768         return uint256(_addressData[owner].numberMinted);
769     }
770 
771     /**
772      * Returns the number of tokens burned by or on behalf of `owner`.
773      */
774     function _numberBurned(address owner) internal view returns (uint256) {
775         return uint256(_addressData[owner].numberBurned);
776     }
777 
778     /**
779      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
780      */
781     function _getAux(address owner) internal view returns (uint64) {
782         return _addressData[owner].aux;
783     }
784 
785     /**
786      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
787      * If there are multiple variables, please pack them into a uint64.
788      */
789     function _setAux(address owner, uint64 aux) internal {
790         _addressData[owner].aux = aux;
791     }
792 
793     /**
794      * Gas spent here starts off proportional to the maximum mint batch size.
795      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
796      */
797     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
798         uint256 curr = tokenId;
799 
800         unchecked {
801             if (_startTokenId() <= curr && curr < _currentIndex) {
802                 TokenOwnership memory ownership = _ownerships[curr];
803                 if (!ownership.burned) {
804                     if (ownership.addr != address(0)) {
805                         return ownership;
806                     }
807                     // Invariant:
808                     // There will always be an ownership that has an address and is not burned
809                     // before an ownership that does not have an address and is not burned.
810                     // Hence, curr will not underflow.
811                     while (true) {
812                         curr--;
813                         ownership = _ownerships[curr];
814                         if (ownership.addr != address(0)) {
815                             return ownership;
816                         }
817                     }
818                 }
819             }
820         }
821         revert OwnerQueryForNonexistentToken();
822     }
823 
824     /**
825      * @dev See {IERC721-ownerOf}.
826      */
827     function ownerOf(uint256 tokenId) public view override returns (address) {
828         return _ownershipOf(tokenId).addr;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-name}.
833      */
834     function name() public view virtual override returns (string memory) {
835         return _name;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-symbol}.
840      */
841     function symbol() public view virtual override returns (string memory) {
842         return _symbol;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-tokenURI}.
847      */
848     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
849         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
850 
851         string memory baseURI = _baseURI();
852         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
853     }
854 
855     /**
856      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
857      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
858      * by default, can be overriden in child contracts.
859      */
860     function _baseURI() internal view virtual returns (string memory) {
861         return '';
862     }
863 
864     /**
865      * @dev See {IERC721-approve}.
866      */
867     function approve(address to, uint256 tokenId) public override {
868         address owner = ERC721A.ownerOf(tokenId);
869         if (to == owner) revert ApprovalToCurrentOwner();
870 
871         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
872             revert ApprovalCallerNotOwnerNorApproved();
873         }
874 
875         _approve(to, tokenId, owner);
876     }
877 
878     /**
879      * @dev See {IERC721-getApproved}.
880      */
881     function getApproved(uint256 tokenId) public view override returns (address) {
882         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
883 
884         return _tokenApprovals[tokenId];
885     }
886 
887     /**
888      * @dev See {IERC721-setApprovalForAll}.
889      */
890     function setApprovalForAll(address operator, bool approved) public virtual override {
891         if (operator == _msgSender()) revert ApproveToCaller();
892 
893         _operatorApprovals[_msgSender()][operator] = approved;
894         emit ApprovalForAll(_msgSender(), operator, approved);
895     }
896 
897     /**
898      * @dev See {IERC721-isApprovedForAll}.
899      */
900     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
901         return _operatorApprovals[owner][operator];
902     }
903 
904     /**
905      * @dev See {IERC721-transferFrom}.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         _transfer(from, to, tokenId);
913     }
914 
915     /**
916      * @dev See {IERC721-safeTransferFrom}.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId
922     ) public virtual override {
923         safeTransferFrom(from, to, tokenId, '');
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) public virtual override {
935         _transfer(from, to, tokenId);
936         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
937             revert TransferToNonERC721ReceiverImplementer();
938         }
939     }
940 
941     /**
942      * @dev Returns whether `tokenId` exists.
943      *
944      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
945      *
946      * Tokens start existing when they are minted (`_mint`),
947      */
948     function _exists(uint256 tokenId) internal view returns (bool) {
949         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
950             !_ownerships[tokenId].burned;
951     }
952 
953     function _safeMint(address to, uint256 quantity) internal {
954         _safeMint(to, quantity, '');
955     }
956 
957     /**
958      * @dev Safely mints `quantity` tokens and transfers them to `to`.
959      *
960      * Requirements:
961      *
962      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
963      * - `quantity` must be greater than 0.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _safeMint(
968         address to,
969         uint256 quantity,
970         bytes memory _data
971     ) internal {
972         _mint(to, quantity, _data, true);
973     }
974 
975     /**
976      * @dev Mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - `to` cannot be the zero address.
981      * - `quantity` must be greater than 0.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _mint(
986         address to,
987         uint256 quantity,
988         bytes memory _data,
989         bool safe
990     ) internal {
991         uint256 startTokenId = _currentIndex;
992         if (to == address(0)) revert MintToZeroAddress();
993         if (quantity == 0) revert MintZeroQuantity();
994 
995         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
996 
997         // Overflows are incredibly unrealistic.
998         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
999         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1000         unchecked {
1001             _addressData[to].balance += uint64(quantity);
1002             _addressData[to].numberMinted += uint64(quantity);
1003 
1004             _ownerships[startTokenId].addr = to;
1005             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1006 
1007             uint256 updatedIndex = startTokenId;
1008             uint256 end = updatedIndex + quantity;
1009 
1010             if (safe && to.isContract()) {
1011                 do {
1012                     emit Transfer(address(0), to, updatedIndex);
1013                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1014                         revert TransferToNonERC721ReceiverImplementer();
1015                     }
1016                 } while (updatedIndex != end);
1017                 // Reentrancy protection
1018                 if (_currentIndex != startTokenId) revert();
1019             } else {
1020                 do {
1021                     emit Transfer(address(0), to, updatedIndex++);
1022                 } while (updatedIndex != end);
1023             }
1024             _currentIndex = updatedIndex;
1025         }
1026         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1027     }
1028 
1029     /**
1030      * @dev Transfers `tokenId` from `from` to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must be owned by `from`.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _transfer(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) private {
1044         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1045 
1046         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1047 
1048         bool isApprovedOrOwner = (_msgSender() == from ||
1049             isApprovedForAll(from, _msgSender()) ||
1050             getApproved(tokenId) == _msgSender());
1051 
1052         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1053         if (to == address(0)) revert TransferToZeroAddress();
1054 
1055         _beforeTokenTransfers(from, to, tokenId, 1);
1056 
1057         // Clear approvals from the previous owner
1058         _approve(address(0), tokenId, from);
1059 
1060         // Underflow of the sender's balance is impossible because we check for
1061         // ownership above and the recipient's balance can't realistically overflow.
1062         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1063         unchecked {
1064             _addressData[from].balance -= 1;
1065             _addressData[to].balance += 1;
1066 
1067             TokenOwnership storage currSlot = _ownerships[tokenId];
1068             currSlot.addr = to;
1069             currSlot.startTimestamp = uint64(block.timestamp);
1070 
1071             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1072             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1073             uint256 nextTokenId = tokenId + 1;
1074             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1075             if (nextSlot.addr == address(0)) {
1076                 // This will suffice for checking _exists(nextTokenId),
1077                 // as a burned slot cannot contain the zero address.
1078                 if (nextTokenId != _currentIndex) {
1079                     nextSlot.addr = from;
1080                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1081                 }
1082             }
1083         }
1084 
1085         emit Transfer(from, to, tokenId);
1086         _afterTokenTransfers(from, to, tokenId, 1);
1087     }
1088 
1089     /**
1090      * @dev This is equivalent to _burn(tokenId, false)
1091      */
1092     function _burn(uint256 tokenId) internal virtual {
1093         _burn(tokenId, false);
1094     }
1095 
1096     /**
1097      * @dev Destroys `tokenId`.
1098      * The approval is cleared when the token is burned.
1099      *
1100      * Requirements:
1101      *
1102      * - `tokenId` must exist.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1107         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1108 
1109         address from = prevOwnership.addr;
1110 
1111         if (approvalCheck) {
1112             bool isApprovedOrOwner = (_msgSender() == from ||
1113                 isApprovedForAll(from, _msgSender()) ||
1114                 getApproved(tokenId) == _msgSender());
1115 
1116             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1117         }
1118 
1119         _beforeTokenTransfers(from, address(0), tokenId, 1);
1120 
1121         // Clear approvals from the previous owner
1122         _approve(address(0), tokenId, from);
1123 
1124         // Underflow of the sender's balance is impossible because we check for
1125         // ownership above and the recipient's balance can't realistically overflow.
1126         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1127         unchecked {
1128             AddressData storage addressData = _addressData[from];
1129             addressData.balance -= 1;
1130             addressData.numberBurned += 1;
1131 
1132             // Keep track of who burned the token, and the timestamp of burning.
1133             TokenOwnership storage currSlot = _ownerships[tokenId];
1134             currSlot.addr = from;
1135             currSlot.startTimestamp = uint64(block.timestamp);
1136             currSlot.burned = true;
1137 
1138             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1139             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1140             uint256 nextTokenId = tokenId + 1;
1141             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1142             if (nextSlot.addr == address(0)) {
1143                 // This will suffice for checking _exists(nextTokenId),
1144                 // as a burned slot cannot contain the zero address.
1145                 if (nextTokenId != _currentIndex) {
1146                     nextSlot.addr = from;
1147                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1148                 }
1149             }
1150         }
1151 
1152         emit Transfer(from, address(0), tokenId);
1153         _afterTokenTransfers(from, address(0), tokenId, 1);
1154 
1155         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1156         unchecked {
1157             _burnCounter++;
1158         }
1159     }
1160 
1161     /**
1162      * @dev Approve `to` to operate on `tokenId`
1163      *
1164      * Emits a {Approval} event.
1165      */
1166     function _approve(
1167         address to,
1168         uint256 tokenId,
1169         address owner
1170     ) private {
1171         _tokenApprovals[tokenId] = to;
1172         emit Approval(owner, to, tokenId);
1173     }
1174 
1175     /**
1176      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1177      *
1178      * @param from address representing the previous owner of the given token ID
1179      * @param to target address that will receive the tokens
1180      * @param tokenId uint256 ID of the token to be transferred
1181      * @param _data bytes optional data to send along with the call
1182      * @return bool whether the call correctly returned the expected magic value
1183      */
1184     function _checkContractOnERC721Received(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) private returns (bool) {
1190         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1191             return retval == IERC721Receiver(to).onERC721Received.selector;
1192         } catch (bytes memory reason) {
1193             if (reason.length == 0) {
1194                 revert TransferToNonERC721ReceiverImplementer();
1195             } else {
1196                 assembly {
1197                     revert(add(32, reason), mload(reason))
1198                 }
1199             }
1200         }
1201     }
1202 
1203     /**
1204      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1205      * And also called before burning one token.
1206      *
1207      * startTokenId - the first token id to be transferred
1208      * quantity - the amount to be transferred
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` will be minted for `to`.
1215      * - When `to` is zero, `tokenId` will be burned by `from`.
1216      * - `from` and `to` are never both zero.
1217      */
1218     function _beforeTokenTransfers(
1219         address from,
1220         address to,
1221         uint256 startTokenId,
1222         uint256 quantity
1223     ) internal virtual {}
1224 
1225     /**
1226      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1227      * minting.
1228      * And also called after one token has been burned.
1229      *
1230      * startTokenId - the first token id to be transferred
1231      * quantity - the amount to be transferred
1232      *
1233      * Calling conditions:
1234      *
1235      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1236      * transferred to `to`.
1237      * - When `from` is zero, `tokenId` has been minted for `to`.
1238      * - When `to` is zero, `tokenId` has been burned by `from`.
1239      * - `from` and `to` are never both zero.
1240      */
1241     function _afterTokenTransfers(
1242         address from,
1243         address to,
1244         uint256 startTokenId,
1245         uint256 quantity
1246     ) internal virtual {}
1247 }
1248 
1249 abstract contract Ownable is Context {
1250     address private _owner;
1251 
1252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1253 
1254     /**
1255      * @dev Initializes the contract setting the deployer as the initial owner.
1256      */
1257     constructor() {
1258         _transferOwnership(_msgSender());
1259     }
1260 
1261     /**
1262      * @dev Returns the address of the current owner.
1263      */
1264     function owner() public view virtual returns (address) {
1265         return _owner;
1266     }
1267 
1268     /**
1269      * @dev Throws if called by any account other than the owner.
1270      */
1271     modifier onlyOwner() {
1272         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1273         _;
1274     }
1275 
1276     /**
1277      * @dev Leaves the contract without owner. It will not be possible to call
1278      * `onlyOwner` functions anymore. Can only be called by the current owner.
1279      *
1280      * NOTE: Renouncing ownership will leave the contract without an owner,
1281      * thereby removing any functionality that is only available to the owner.
1282      */
1283     function renounceOwnership() public virtual onlyOwner {
1284         _transferOwnership(address(0));
1285     }
1286 
1287     /**
1288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1289      * Can only be called by the current owner.
1290      */
1291     function transferOwnership(address newOwner) public virtual onlyOwner {
1292         require(newOwner != address(0), "Ownable: new owner is the zero address");
1293         _transferOwnership(newOwner);
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Internal function without access restriction.
1299      */
1300     function _transferOwnership(address newOwner) internal virtual {
1301         address oldOwner = _owner;
1302         _owner = newOwner;
1303         emit OwnershipTransferred(oldOwner, newOwner);
1304     }
1305 }
1306 pragma solidity ^0.8.13;
1307 
1308 interface IOperatorFilterRegistry {
1309     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1310     function register(address registrant) external;
1311     function registerAndSubscribe(address registrant, address subscription) external;
1312     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1313     function updateOperator(address registrant, address operator, bool filtered) external;
1314     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1315     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1316     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1317     function subscribe(address registrant, address registrantToSubscribe) external;
1318     function unsubscribe(address registrant, bool copyExistingEntries) external;
1319     function subscriptionOf(address addr) external returns (address registrant);
1320     function subscribers(address registrant) external returns (address[] memory);
1321     function subscriberAt(address registrant, uint256 index) external returns (address);
1322     function copyEntriesOf(address registrant, address registrantToCopy) external;
1323     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1324     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1325     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1326     function filteredOperators(address addr) external returns (address[] memory);
1327     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1328     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1329     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1330     function isRegistered(address addr) external returns (bool);
1331     function codeHashOf(address addr) external returns (bytes32);
1332 }
1333 pragma solidity ^0.8.13;
1334 
1335 
1336 
1337 abstract contract OperatorFilterer {
1338     error OperatorNotAllowed(address operator);
1339 
1340     IOperatorFilterRegistry constant operatorFilterRegistry =
1341         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1342 
1343     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1344         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1345         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1346         // order for the modifier to filter addresses.
1347         if (address(operatorFilterRegistry).code.length > 0) {
1348             if (subscribe) {
1349                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1350             } else {
1351                 if (subscriptionOrRegistrantToCopy != address(0)) {
1352                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1353                 } else {
1354                     operatorFilterRegistry.register(address(this));
1355                 }
1356             }
1357         }
1358     }
1359 
1360     modifier onlyAllowedOperator(address from) virtual {
1361         // Check registry code length to facilitate testing in environments without a deployed registry.
1362         if (address(operatorFilterRegistry).code.length > 0) {
1363             // Allow spending tokens from addresses with balance
1364             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1365             // from an EOA.
1366             if (from == msg.sender) {
1367                 _;
1368                 return;
1369             }
1370             if (
1371                 !(
1372                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1373                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1374                 )
1375             ) {
1376                 revert OperatorNotAllowed(msg.sender);
1377             }
1378         }
1379         _;
1380     }
1381 }
1382 pragma solidity ^0.8.13;
1383 
1384 
1385 
1386 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1387     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1388 
1389     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1390 }
1391     pragma solidity ^0.8.7;
1392     
1393     contract WeirdArtNyc is ERC721A, DefaultOperatorFilterer , Ownable {
1394     using Strings for uint256;
1395 
1396 
1397   string private uriPrefix ;
1398   string private uriSuffix = ".json";
1399   string public hiddenURL;
1400 
1401   
1402   
1403 
1404   uint256 public cost = 0.005 ether;
1405  
1406   
1407 
1408   uint16 public maxSupply = 1212;
1409   uint8 public maxMintAmountPerTx = 1;
1410     uint8 public maxFreeMintAmountPerWallet = 1;
1411                                                              
1412  
1413   bool public paused = true;
1414   bool public reveal =false;
1415 
1416    mapping (address => uint8) public NFTPerPublicAddress;
1417 
1418  
1419   
1420   
1421  
1422   
1423 
1424   constructor() ERC721A("Weird Art Nyc", "NYC") {
1425   }
1426 
1427 
1428   
1429  
1430   function mint(uint8 _mintAmount) external payable  {
1431      uint16 totalSupply = uint16(totalSupply());
1432      uint8 nft = NFTPerPublicAddress[msg.sender];
1433     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1434     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1435 
1436     require(!paused, "The contract is paused!");
1437     
1438       if(nft >= maxFreeMintAmountPerWallet)
1439     {
1440     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1441     }
1442     else {
1443          uint8 costAmount = _mintAmount + nft;
1444         if(costAmount > maxFreeMintAmountPerWallet)
1445        {
1446         costAmount = costAmount - maxFreeMintAmountPerWallet;
1447         require(msg.value >= cost * costAmount, "Insufficient funds!");
1448        }
1449        
1450          
1451     }
1452     
1453 
1454 
1455     _safeMint(msg.sender , _mintAmount);
1456 
1457     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1458      
1459      delete totalSupply;
1460      delete _mintAmount;
1461   }
1462   
1463   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1464      uint16 totalSupply = uint16(totalSupply());
1465     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1466      _safeMint(_receiver , _mintAmount);
1467      delete _mintAmount;
1468      delete _receiver;
1469      delete totalSupply;
1470   }
1471 
1472   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1473      uint16 totalSupply = uint16(totalSupply());
1474      uint totalAmount =   _amountPerAddress * addresses.length;
1475     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1476      for (uint256 i = 0; i < addresses.length; i++) {
1477             _safeMint(addresses[i], _amountPerAddress);
1478         }
1479 
1480      delete _amountPerAddress;
1481      delete totalSupply;
1482   }
1483 
1484  
1485 
1486   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1487       maxSupply = _maxSupply;
1488   }
1489 
1490 
1491 
1492    
1493   function tokenURI(uint256 _tokenId)
1494     public
1495     view
1496     virtual
1497     override
1498     returns (string memory)
1499   {
1500     require(
1501       _exists(_tokenId),
1502       "ERC721Metadata: URI query for nonexistent token"
1503     );
1504     
1505   
1506 if ( reveal == false)
1507 {
1508     return hiddenURL;
1509 }
1510     
1511 
1512     string memory currentBaseURI = _baseURI();
1513     return bytes(currentBaseURI).length > 0
1514         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1515         : "";
1516   }
1517  
1518  
1519 
1520 
1521  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1522     maxFreeMintAmountPerWallet = _limit;
1523    delete _limit;
1524 
1525 }
1526 
1527     
1528   
1529 
1530   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1531     uriPrefix = _uriPrefix;
1532   }
1533    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1534     hiddenURL = _uriPrefix;
1535   }
1536 
1537 
1538   function setPaused() external onlyOwner {
1539     paused = !paused;
1540    
1541   }
1542 
1543   function setCost(uint _cost) external onlyOwner{
1544       cost = _cost;
1545 
1546   }
1547 
1548  function setRevealed() external onlyOwner{
1549      reveal = !reveal;
1550  }
1551 
1552   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1553       maxMintAmountPerTx = _maxtx;
1554 
1555   }
1556 
1557  
1558 
1559   function withdraw() external onlyOwner {
1560   uint _balance = address(this).balance;
1561      payable(msg.sender).transfer(_balance ); 
1562        
1563   }
1564 
1565 
1566   function _baseURI() internal view  override returns (string memory) {
1567     return uriPrefix;
1568   }
1569 
1570     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1571         super.transferFrom(from, to, tokenId);
1572     }
1573 
1574     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1575         super.safeTransferFrom(from, to, tokenId);
1576     }
1577 
1578     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1579         public
1580         override
1581         onlyAllowedOperator(from)
1582     {
1583         super.safeTransferFrom(from, to, tokenId, data);
1584     }
1585 }