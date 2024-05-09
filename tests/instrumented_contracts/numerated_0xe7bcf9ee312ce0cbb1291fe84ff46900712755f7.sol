1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/Strings.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev String operations.
235  */
236 library Strings {
237     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
241      */
242     function toString(uint256 value) internal pure returns (string memory) {
243         // Inspired by OraclizeAPI's implementation - MIT licence
244         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
245 
246         if (value == 0) {
247             return "0";
248         }
249         uint256 temp = value;
250         uint256 digits;
251         while (temp != 0) {
252             digits++;
253             temp /= 10;
254         }
255         bytes memory buffer = new bytes(digits);
256         while (value != 0) {
257             digits -= 1;
258             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
259             value /= 10;
260         }
261         return string(buffer);
262     }
263 
264     /**
265      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
266      */
267     function toHexString(uint256 value) internal pure returns (string memory) {
268         if (value == 0) {
269             return "0x00";
270         }
271         uint256 temp = value;
272         uint256 length = 0;
273         while (temp != 0) {
274             length++;
275             temp >>= 8;
276         }
277         return toHexString(value, length);
278     }
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
282      */
283     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
284         bytes memory buffer = new bytes(2 * length + 2);
285         buffer[0] = "0";
286         buffer[1] = "x";
287         for (uint256 i = 2 * length + 1; i > 1; --i) {
288             buffer[i] = _HEX_SYMBOLS[value & 0xf];
289             value >>= 4;
290         }
291         require(value == 0, "Strings: hex length insufficient");
292         return string(buffer);
293     }
294 }
295 
296 // File: erc721a/contracts/IERC721A.sol
297 
298 
299 // ERC721A Contracts v4.0.0
300 // Creator: Chiru Labs
301 
302 pragma solidity ^0.8.4;
303 
304 /**
305  * @dev Interface of an ERC721A compliant contract.
306  */
307 interface IERC721A {
308     /**
309      * The caller must own the token or be an approved operator.
310      */
311     error ApprovalCallerNotOwnerNorApproved();
312 
313     /**
314      * The token does not exist.
315      */
316     error ApprovalQueryForNonexistentToken();
317 
318     /**
319      * The caller cannot approve to their own address.
320      */
321     error ApproveToCaller();
322 
323     /**
324      * The caller cannot approve to the current owner.
325      */
326     error ApprovalToCurrentOwner();
327 
328     /**
329      * Cannot query the balance for the zero address.
330      */
331     error BalanceQueryForZeroAddress();
332 
333     /**
334      * Cannot mint to the zero address.
335      */
336     error MintToZeroAddress();
337 
338     /**
339      * The quantity of tokens minted must be more than zero.
340      */
341     error MintZeroQuantity();
342 
343     /**
344      * The token does not exist.
345      */
346     error OwnerQueryForNonexistentToken();
347 
348     /**
349      * The caller must own the token or be an approved operator.
350      */
351     error TransferCallerNotOwnerNorApproved();
352 
353     /**
354      * The token must be owned by `from`.
355      */
356     error TransferFromIncorrectOwner();
357 
358     /**
359      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
360      */
361     error TransferToNonERC721ReceiverImplementer();
362 
363     /**
364      * Cannot transfer to the zero address.
365      */
366     error TransferToZeroAddress();
367 
368     /**
369      * The token does not exist.
370      */
371     error URIQueryForNonexistentToken();
372 
373     struct TokenOwnership {
374         // The address of the owner.
375         address addr;
376         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
377         uint64 startTimestamp;
378         // Whether the token has been burned.
379         bool burned;
380     }
381 
382     /**
383      * @dev Returns the total amount of tokens stored by the contract.
384      *
385      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
386      */
387     function totalSupply() external view returns (uint256);
388 
389     // ==============================
390     //            IERC165
391     // ==============================
392 
393     /**
394      * @dev Returns true if this contract implements the interface defined by
395      * `interfaceId`. See the corresponding
396      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
397      * to learn more about how these ids are created.
398      *
399      * This function call must use less than 30 000 gas.
400      */
401     function supportsInterface(bytes4 interfaceId) external view returns (bool);
402 
403     // ==============================
404     //            IERC721
405     // ==============================
406 
407     /**
408      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
409      */
410     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
411 
412     /**
413      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
414      */
415     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
416 
417     /**
418      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
419      */
420     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
421 
422     /**
423      * @dev Returns the number of tokens in ``owner``'s account.
424      */
425     function balanceOf(address owner) external view returns (uint256 balance);
426 
427     /**
428      * @dev Returns the owner of the `tokenId` token.
429      *
430      * Requirements:
431      *
432      * - `tokenId` must exist.
433      */
434     function ownerOf(uint256 tokenId) external view returns (address owner);
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId,
453         bytes calldata data
454     ) external;
455 
456     /**
457      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
458      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must exist and be owned by `from`.
465      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) external;
475 
476     /**
477      * @dev Transfers `tokenId` token from `from` to `to`.
478      *
479      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must be owned by `from`.
486      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
487      *
488      * Emits a {Transfer} event.
489      */
490     function transferFrom(
491         address from,
492         address to,
493         uint256 tokenId
494     ) external;
495 
496     /**
497      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
498      * The approval is cleared when the token is transferred.
499      *
500      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
501      *
502      * Requirements:
503      *
504      * - The caller must own the token or be an approved operator.
505      * - `tokenId` must exist.
506      *
507      * Emits an {Approval} event.
508      */
509     function approve(address to, uint256 tokenId) external;
510 
511     /**
512      * @dev Approve or remove `operator` as an operator for the caller.
513      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
514      *
515      * Requirements:
516      *
517      * - The `operator` cannot be the caller.
518      *
519      * Emits an {ApprovalForAll} event.
520      */
521     function setApprovalForAll(address operator, bool _approved) external;
522 
523     /**
524      * @dev Returns the account approved for `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function getApproved(uint256 tokenId) external view returns (address operator);
531 
532     /**
533      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
534      *
535      * See {setApprovalForAll}
536      */
537     function isApprovedForAll(address owner, address operator) external view returns (bool);
538 
539     // ==============================
540     //        IERC721Metadata
541     // ==============================
542 
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() external view returns (string memory);
547 
548     /**
549      * @dev Returns the token collection symbol.
550      */
551     function symbol() external view returns (string memory);
552 
553     /**
554      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
555      */
556     function tokenURI(uint256 tokenId) external view returns (string memory);
557 }
558 
559 // File: erc721a/contracts/ERC721A.sol
560 
561 
562 // ERC721A Contracts v4.0.0
563 // Creator: Chiru Labs
564 
565 pragma solidity ^0.8.4;
566 
567 
568 /**
569  * @dev ERC721 token receiver interface.
570  */
571 interface ERC721A__IERC721Receiver {
572     function onERC721Received(
573         address operator,
574         address from,
575         uint256 tokenId,
576         bytes calldata data
577     ) external returns (bytes4);
578 }
579 
580 /**
581  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
582  * the Metadata extension. Built to optimize for lower gas during batch mints.
583  *
584  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
585  *
586  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
587  *
588  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
589  */
590 contract ERC721A is IERC721A {
591     // Mask of an entry in packed address data.
592     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
593 
594     // The bit position of `numberMinted` in packed address data.
595     uint256 private constant BITPOS_NUMBER_MINTED = 64;
596 
597     // The bit position of `numberBurned` in packed address data.
598     uint256 private constant BITPOS_NUMBER_BURNED = 128;
599 
600     // The bit position of `aux` in packed address data.
601     uint256 private constant BITPOS_AUX = 192;
602 
603     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
604     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
605 
606     // The bit position of `startTimestamp` in packed ownership.
607     uint256 private constant BITPOS_START_TIMESTAMP = 160;
608 
609     // The bit mask of the `burned` bit in packed ownership.
610     uint256 private constant BITMASK_BURNED = 1 << 224;
611     
612     // The bit position of the `nextInitialized` bit in packed ownership.
613     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
614 
615     // The bit mask of the `nextInitialized` bit in packed ownership.
616     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
617 
618     // The tokenId of the next token to be minted.
619     uint256 private _currentIndex;
620 
621     // The number of tokens burned.
622     uint256 private _burnCounter;
623 
624     // Token name
625     string private _name;
626 
627     // Token symbol
628     string private _symbol;
629 
630     // Mapping from token ID to ownership details
631     // An empty struct value does not necessarily mean the token is unowned.
632     // See `_packedOwnershipOf` implementation for details.
633     //
634     // Bits Layout:
635     // - [0..159]   `addr`
636     // - [160..223] `startTimestamp`
637     // - [224]      `burned`
638     // - [225]      `nextInitialized`
639     mapping(uint256 => uint256) private _packedOwnerships;
640 
641     // Mapping owner address to address data.
642     //
643     // Bits Layout:
644     // - [0..63]    `balance`
645     // - [64..127]  `numberMinted`
646     // - [128..191] `numberBurned`
647     // - [192..255] `aux`
648     mapping(address => uint256) private _packedAddressData;
649 
650     // Mapping from token ID to approved address.
651     mapping(uint256 => address) private _tokenApprovals;
652 
653     // Mapping from owner to operator approvals
654     mapping(address => mapping(address => bool)) private _operatorApprovals;
655 
656     constructor(string memory name_, string memory symbol_) {
657         _name = name_;
658         _symbol = symbol_;
659         _currentIndex = _startTokenId();
660     }
661 
662     /**
663      * @dev Returns the starting token ID. 
664      * To change the starting token ID, please override this function.
665      */
666     function _startTokenId() internal view virtual returns (uint256) {
667         return 0;
668     }
669 
670     /**
671      * @dev Returns the next token ID to be minted.
672      */
673     function _nextTokenId() internal view returns (uint256) {
674         return _currentIndex;
675     }
676 
677     /**
678      * @dev Returns the total number of tokens in existence.
679      * Burned tokens will reduce the count. 
680      * To get the total number of tokens minted, please see `_totalMinted`.
681      */
682     function totalSupply() public view override returns (uint256) {
683         // Counter underflow is impossible as _burnCounter cannot be incremented
684         // more than `_currentIndex - _startTokenId()` times.
685         unchecked {
686             return _currentIndex - _burnCounter - _startTokenId();
687         }
688     }
689 
690     /**
691      * @dev Returns the total amount of tokens minted in the contract.
692      */
693     function _totalMinted() internal view returns (uint256) {
694         // Counter underflow is impossible as _currentIndex does not decrement,
695         // and it is initialized to `_startTokenId()`
696         unchecked {
697             return _currentIndex - _startTokenId();
698         }
699     }
700 
701     /**
702      * @dev Returns the total number of tokens burned.
703      */
704     function _totalBurned() internal view returns (uint256) {
705         return _burnCounter;
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
712         // The interface IDs are constants representing the first 4 bytes of the XOR of
713         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
714         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
715         return
716             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
717             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
718             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
719     }
720 
721     /**
722      * @dev See {IERC721-balanceOf}.
723      */
724     function balanceOf(address owner) public view override returns (uint256) {
725         if (owner == address(0)) revert BalanceQueryForZeroAddress();
726         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
727     }
728 
729     /**
730      * Returns the number of tokens minted by `owner`.
731      */
732     function _numberMinted(address owner) internal view returns (uint256) {
733         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
734     }
735 
736     /**
737      * Returns the number of tokens burned by or on behalf of `owner`.
738      */
739     function _numberBurned(address owner) internal view returns (uint256) {
740         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
741     }
742 
743     /**
744      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
745      */
746     function _getAux(address owner) internal view returns (uint64) {
747         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
748     }
749 
750     /**
751      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
752      * If there are multiple variables, please pack them into a uint64.
753      */
754     function _setAux(address owner, uint64 aux) internal {
755         uint256 packed = _packedAddressData[owner];
756         uint256 auxCasted;
757         assembly { // Cast aux without masking.
758             auxCasted := aux
759         }
760         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
761         _packedAddressData[owner] = packed;
762     }
763 
764     /**
765      * Returns the packed ownership data of `tokenId`.
766      */
767     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
768         uint256 curr = tokenId;
769 
770         unchecked {
771             if (_startTokenId() <= curr)
772                 if (curr < _currentIndex) {
773                     uint256 packed = _packedOwnerships[curr];
774                     // If not burned.
775                     if (packed & BITMASK_BURNED == 0) {
776                         // Invariant:
777                         // There will always be an ownership that has an address and is not burned
778                         // before an ownership that does not have an address and is not burned.
779                         // Hence, curr will not underflow.
780                         //
781                         // We can directly compare the packed value.
782                         // If the address is zero, packed is zero.
783                         while (packed == 0) {
784                             packed = _packedOwnerships[--curr];
785                         }
786                         return packed;
787                     }
788                 }
789         }
790         revert OwnerQueryForNonexistentToken();
791     }
792 
793     /**
794      * Returns the unpacked `TokenOwnership` struct from `packed`.
795      */
796     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
797         ownership.addr = address(uint160(packed));
798         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
799         ownership.burned = packed & BITMASK_BURNED != 0;
800     }
801 
802     /**
803      * Returns the unpacked `TokenOwnership` struct at `index`.
804      */
805     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
806         return _unpackedOwnership(_packedOwnerships[index]);
807     }
808 
809     /**
810      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
811      */
812     function _initializeOwnershipAt(uint256 index) internal {
813         if (_packedOwnerships[index] == 0) {
814             _packedOwnerships[index] = _packedOwnershipOf(index);
815         }
816     }
817 
818     /**
819      * Gas spent here starts off proportional to the maximum mint batch size.
820      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
821      */
822     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
823         return _unpackedOwnership(_packedOwnershipOf(tokenId));
824     }
825 
826     /**
827      * @dev See {IERC721-ownerOf}.
828      */
829     function ownerOf(uint256 tokenId) public view override returns (address) {
830         return address(uint160(_packedOwnershipOf(tokenId)));
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-name}.
835      */
836     function name() public view virtual override returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-symbol}.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-tokenURI}.
849      */
850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
851         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
852 
853         string memory baseURI = _baseURI();
854         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
855     }
856 
857     /**
858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
860      * by default, can be overriden in child contracts.
861      */
862     function _baseURI() internal view virtual returns (string memory) {
863         return '';
864     }
865 
866     /**
867      * @dev Casts the address to uint256 without masking.
868      */
869     function _addressToUint256(address value) private pure returns (uint256 result) {
870         assembly {
871             result := value
872         }
873     }
874 
875     /**
876      * @dev Casts the boolean to uint256 without branching.
877      */
878     function _boolToUint256(bool value) private pure returns (uint256 result) {
879         assembly {
880             result := value
881         }
882     }
883 
884     /**
885      * @dev See {IERC721-approve}.
886      */
887     function approve(address to, uint256 tokenId) public override {
888         address owner = address(uint160(_packedOwnershipOf(tokenId)));
889         if (to == owner) revert ApprovalToCurrentOwner();
890 
891         if (_msgSenderERC721A() != owner)
892             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
893                 revert ApprovalCallerNotOwnerNorApproved();
894             }
895 
896         _tokenApprovals[tokenId] = to;
897         emit Approval(owner, to, tokenId);
898     }
899 
900     /**
901      * @dev See {IERC721-getApproved}.
902      */
903     function getApproved(uint256 tokenId) public view override returns (address) {
904         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
905 
906         return _tokenApprovals[tokenId];
907     }
908 
909     /**
910      * @dev See {IERC721-setApprovalForAll}.
911      */
912     function setApprovalForAll(address operator, bool approved) public virtual override {
913         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
914 
915         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
916         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
917     }
918 
919     /**
920      * @dev See {IERC721-isApprovedForAll}.
921      */
922     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
923         return _operatorApprovals[owner][operator];
924     }
925 
926     /**
927      * @dev See {IERC721-transferFrom}.
928      */
929     function transferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         _transfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         safeTransferFrom(from, to, tokenId, '');
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) public virtual override {
957         _transfer(from, to, tokenId);
958         if (to.code.length != 0)
959             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
960                 revert TransferToNonERC721ReceiverImplementer();
961             }
962     }
963 
964     /**
965      * @dev Returns whether `tokenId` exists.
966      *
967      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
968      *
969      * Tokens start existing when they are minted (`_mint`),
970      */
971     function _exists(uint256 tokenId) internal view returns (bool) {
972         return
973             _startTokenId() <= tokenId &&
974             tokenId < _currentIndex && // If within bounds,
975             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
976     }
977 
978     /**
979      * @dev Equivalent to `_safeMint(to, quantity, '')`.
980      */
981     function _safeMint(address to, uint256 quantity) internal {
982         _safeMint(to, quantity, '');
983     }
984 
985     /**
986      * @dev Safely mints `quantity` tokens and transfers them to `to`.
987      *
988      * Requirements:
989      *
990      * - If `to` refers to a smart contract, it must implement
991      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
992      * - `quantity` must be greater than 0.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _safeMint(
997         address to,
998         uint256 quantity,
999         bytes memory _data
1000     ) internal {
1001         uint256 startTokenId = _currentIndex;
1002         if (to == address(0)) revert MintToZeroAddress();
1003         if (quantity == 0) revert MintZeroQuantity();
1004 
1005         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1006 
1007         // Overflows are incredibly unrealistic.
1008         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1009         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1010         unchecked {
1011             // Updates:
1012             // - `balance += quantity`.
1013             // - `numberMinted += quantity`.
1014             //
1015             // We can directly add to the balance and number minted.
1016             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1017 
1018             // Updates:
1019             // - `address` to the owner.
1020             // - `startTimestamp` to the timestamp of minting.
1021             // - `burned` to `false`.
1022             // - `nextInitialized` to `quantity == 1`.
1023             _packedOwnerships[startTokenId] =
1024                 _addressToUint256(to) |
1025                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1026                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1027 
1028             uint256 updatedIndex = startTokenId;
1029             uint256 end = updatedIndex + quantity;
1030 
1031             if (to.code.length != 0) {
1032                 do {
1033                     emit Transfer(address(0), to, updatedIndex);
1034                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1035                         revert TransferToNonERC721ReceiverImplementer();
1036                     }
1037                 } while (updatedIndex < end);
1038                 // Reentrancy protection
1039                 if (_currentIndex != startTokenId) revert();
1040             } else {
1041                 do {
1042                     emit Transfer(address(0), to, updatedIndex++);
1043                 } while (updatedIndex < end);
1044             }
1045             _currentIndex = updatedIndex;
1046         }
1047         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1048     }
1049 
1050     /**
1051      * @dev Mints `quantity` tokens and transfers them to `to`.
1052      *
1053      * Requirements:
1054      *
1055      * - `to` cannot be the zero address.
1056      * - `quantity` must be greater than 0.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _mint(address to, uint256 quantity) internal {
1061         uint256 startTokenId = _currentIndex;
1062         if (to == address(0)) revert MintToZeroAddress();
1063         if (quantity == 0) revert MintZeroQuantity();
1064 
1065         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1066 
1067         // Overflows are incredibly unrealistic.
1068         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1069         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1070         unchecked {
1071             // Updates:
1072             // - `balance += quantity`.
1073             // - `numberMinted += quantity`.
1074             //
1075             // We can directly add to the balance and number minted.
1076             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1077 
1078             // Updates:
1079             // - `address` to the owner.
1080             // - `startTimestamp` to the timestamp of minting.
1081             // - `burned` to `false`.
1082             // - `nextInitialized` to `quantity == 1`.
1083             _packedOwnerships[startTokenId] =
1084                 _addressToUint256(to) |
1085                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1086                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1087 
1088             uint256 updatedIndex = startTokenId;
1089             uint256 end = updatedIndex + quantity;
1090 
1091             do {
1092                 emit Transfer(address(0), to, updatedIndex++);
1093             } while (updatedIndex < end);
1094 
1095             _currentIndex = updatedIndex;
1096         }
1097         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1098     }
1099 
1100     /**
1101      * @dev Transfers `tokenId` from `from` to `to`.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must be owned by `from`.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) private {
1115         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1116 
1117         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1118 
1119         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1120             isApprovedForAll(from, _msgSenderERC721A()) ||
1121             getApproved(tokenId) == _msgSenderERC721A());
1122 
1123         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1124         if (to == address(0)) revert TransferToZeroAddress();
1125 
1126         _beforeTokenTransfers(from, to, tokenId, 1);
1127 
1128         // Clear approvals from the previous owner.
1129         delete _tokenApprovals[tokenId];
1130 
1131         // Underflow of the sender's balance is impossible because we check for
1132         // ownership above and the recipient's balance can't realistically overflow.
1133         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1134         unchecked {
1135             // We can directly increment and decrement the balances.
1136             --_packedAddressData[from]; // Updates: `balance -= 1`.
1137             ++_packedAddressData[to]; // Updates: `balance += 1`.
1138 
1139             // Updates:
1140             // - `address` to the next owner.
1141             // - `startTimestamp` to the timestamp of transfering.
1142             // - `burned` to `false`.
1143             // - `nextInitialized` to `true`.
1144             _packedOwnerships[tokenId] =
1145                 _addressToUint256(to) |
1146                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1147                 BITMASK_NEXT_INITIALIZED;
1148 
1149             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1150             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1151                 uint256 nextTokenId = tokenId + 1;
1152                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1153                 if (_packedOwnerships[nextTokenId] == 0) {
1154                     // If the next slot is within bounds.
1155                     if (nextTokenId != _currentIndex) {
1156                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1157                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1158                     }
1159                 }
1160             }
1161         }
1162 
1163         emit Transfer(from, to, tokenId);
1164         _afterTokenTransfers(from, to, tokenId, 1);
1165     }
1166 
1167     /**
1168      * @dev Equivalent to `_burn(tokenId, false)`.
1169      */
1170     function _burn(uint256 tokenId) internal virtual {
1171         _burn(tokenId, false);
1172     }
1173 
1174     /**
1175      * @dev Destroys `tokenId`.
1176      * The approval is cleared when the token is burned.
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must exist.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1185         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1186 
1187         address from = address(uint160(prevOwnershipPacked));
1188 
1189         if (approvalCheck) {
1190             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1191                 isApprovedForAll(from, _msgSenderERC721A()) ||
1192                 getApproved(tokenId) == _msgSenderERC721A());
1193 
1194             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1195         }
1196 
1197         _beforeTokenTransfers(from, address(0), tokenId, 1);
1198 
1199         // Clear approvals from the previous owner.
1200         delete _tokenApprovals[tokenId];
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1205         unchecked {
1206             // Updates:
1207             // - `balance -= 1`.
1208             // - `numberBurned += 1`.
1209             //
1210             // We can directly decrement the balance, and increment the number burned.
1211             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1212             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1213 
1214             // Updates:
1215             // - `address` to the last owner.
1216             // - `startTimestamp` to the timestamp of burning.
1217             // - `burned` to `true`.
1218             // - `nextInitialized` to `true`.
1219             _packedOwnerships[tokenId] =
1220                 _addressToUint256(from) |
1221                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1222                 BITMASK_BURNED | 
1223                 BITMASK_NEXT_INITIALIZED;
1224 
1225             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1226             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1227                 uint256 nextTokenId = tokenId + 1;
1228                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1229                 if (_packedOwnerships[nextTokenId] == 0) {
1230                     // If the next slot is within bounds.
1231                     if (nextTokenId != _currentIndex) {
1232                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1233                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1234                     }
1235                 }
1236             }
1237         }
1238 
1239         emit Transfer(from, address(0), tokenId);
1240         _afterTokenTransfers(from, address(0), tokenId, 1);
1241 
1242         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1243         unchecked {
1244             _burnCounter++;
1245         }
1246     }
1247 
1248     /**
1249      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1250      *
1251      * @param from address representing the previous owner of the given token ID
1252      * @param to target address that will receive the tokens
1253      * @param tokenId uint256 ID of the token to be transferred
1254      * @param _data bytes optional data to send along with the call
1255      * @return bool whether the call correctly returned the expected magic value
1256      */
1257     function _checkContractOnERC721Received(
1258         address from,
1259         address to,
1260         uint256 tokenId,
1261         bytes memory _data
1262     ) private returns (bool) {
1263         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1264             bytes4 retval
1265         ) {
1266             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1267         } catch (bytes memory reason) {
1268             if (reason.length == 0) {
1269                 revert TransferToNonERC721ReceiverImplementer();
1270             } else {
1271                 assembly {
1272                     revert(add(32, reason), mload(reason))
1273                 }
1274             }
1275         }
1276     }
1277 
1278     /**
1279      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1280      * And also called before burning one token.
1281      *
1282      * startTokenId - the first token id to be transferred
1283      * quantity - the amount to be transferred
1284      *
1285      * Calling conditions:
1286      *
1287      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1288      * transferred to `to`.
1289      * - When `from` is zero, `tokenId` will be minted for `to`.
1290      * - When `to` is zero, `tokenId` will be burned by `from`.
1291      * - `from` and `to` are never both zero.
1292      */
1293     function _beforeTokenTransfers(
1294         address from,
1295         address to,
1296         uint256 startTokenId,
1297         uint256 quantity
1298     ) internal virtual {}
1299 
1300     /**
1301      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1302      * minting.
1303      * And also called after one token has been burned.
1304      *
1305      * startTokenId - the first token id to be transferred
1306      * quantity - the amount to be transferred
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` has been minted for `to`.
1313      * - When `to` is zero, `tokenId` has been burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _afterTokenTransfers(
1317         address from,
1318         address to,
1319         uint256 startTokenId,
1320         uint256 quantity
1321     ) internal virtual {}
1322 
1323     /**
1324      * @dev Returns the message sender (defaults to `msg.sender`).
1325      *
1326      * If you are writing GSN compatible contracts, you need to override this function.
1327      */
1328     function _msgSenderERC721A() internal view virtual returns (address) {
1329         return msg.sender;
1330     }
1331 
1332     /**
1333      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1334      */
1335     function _toString(uint256 value) internal pure returns (string memory ptr) {
1336         assembly {
1337             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1338             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1339             // We will need 1 32-byte word to store the length, 
1340             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1341             ptr := add(mload(0x40), 128)
1342             // Update the free memory pointer to allocate.
1343             mstore(0x40, ptr)
1344 
1345             // Cache the end of the memory to calculate the length later.
1346             let end := ptr
1347 
1348             // We write the string from the rightmost digit to the leftmost digit.
1349             // The following is essentially a do-while loop that also handles the zero case.
1350             // Costs a bit more than early returning for the zero case,
1351             // but cheaper in terms of deployment and overall runtime costs.
1352             for { 
1353                 // Initialize and perform the first pass without check.
1354                 let temp := value
1355                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1356                 ptr := sub(ptr, 1)
1357                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1358                 mstore8(ptr, add(48, mod(temp, 10)))
1359                 temp := div(temp, 10)
1360             } temp { 
1361                 // Keep dividing `temp` until zero.
1362                 temp := div(temp, 10)
1363             } { // Body of the for loop.
1364                 ptr := sub(ptr, 1)
1365                 mstore8(ptr, add(48, mod(temp, 10)))
1366             }
1367             
1368             let length := sub(end, ptr)
1369             // Move the pointer 32 bytes leftwards to make room for the length.
1370             ptr := sub(ptr, 32)
1371             // Store the length.
1372             mstore(ptr, length)
1373         }
1374     }
1375 }
1376 
1377 // File: @openzeppelin/contracts/utils/Context.sol
1378 
1379 
1380 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1381 
1382 pragma solidity ^0.8.0;
1383 
1384 /**
1385  * @dev Provides information about the current execution context, including the
1386  * sender of the transaction and its data. While these are generally available
1387  * via msg.sender and msg.data, they should not be accessed in such a direct
1388  * manner, since when dealing with meta-transactions the account sending and
1389  * paying for execution may not be the actual sender (as far as an application
1390  * is concerned).
1391  *
1392  * This contract is only required for intermediate, library-like contracts.
1393  */
1394 abstract contract Context {
1395     function _msgSender() internal view virtual returns (address) {
1396         return msg.sender;
1397     }
1398 
1399     function _msgData() internal view virtual returns (bytes calldata) {
1400         return msg.data;
1401     }
1402 }
1403 
1404 // File: @openzeppelin/contracts/security/Pausable.sol
1405 
1406 
1407 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1408 
1409 pragma solidity ^0.8.0;
1410 
1411 
1412 /**
1413  * @dev Contract module which allows children to implement an emergency stop
1414  * mechanism that can be triggered by an authorized account.
1415  *
1416  * This module is used through inheritance. It will make available the
1417  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1418  * the functions of your contract. Note that they will not be pausable by
1419  * simply including this module, only once the modifiers are put in place.
1420  */
1421 abstract contract Pausable is Context {
1422     /**
1423      * @dev Emitted when the pause is triggered by `account`.
1424      */
1425     event Paused(address account);
1426 
1427     /**
1428      * @dev Emitted when the pause is lifted by `account`.
1429      */
1430     event Unpaused(address account);
1431 
1432     bool private _paused;
1433 
1434     /**
1435      * @dev Initializes the contract in unpaused state.
1436      */
1437     constructor() {
1438         _paused = false;
1439     }
1440 
1441     /**
1442      * @dev Returns true if the contract is paused, and false otherwise.
1443      */
1444     function paused() public view virtual returns (bool) {
1445         return _paused;
1446     }
1447 
1448     /**
1449      * @dev Modifier to make a function callable only when the contract is not paused.
1450      *
1451      * Requirements:
1452      *
1453      * - The contract must not be paused.
1454      */
1455     modifier whenNotPaused() {
1456         require(!paused(), "Pausable: paused");
1457         _;
1458     }
1459 
1460     /**
1461      * @dev Modifier to make a function callable only when the contract is paused.
1462      *
1463      * Requirements:
1464      *
1465      * - The contract must be paused.
1466      */
1467     modifier whenPaused() {
1468         require(paused(), "Pausable: not paused");
1469         _;
1470     }
1471 
1472     /**
1473      * @dev Triggers stopped state.
1474      *
1475      * Requirements:
1476      *
1477      * - The contract must not be paused.
1478      */
1479     function _pause() internal virtual whenNotPaused {
1480         _paused = true;
1481         emit Paused(_msgSender());
1482     }
1483 
1484     /**
1485      * @dev Returns to normal state.
1486      *
1487      * Requirements:
1488      *
1489      * - The contract must be paused.
1490      */
1491     function _unpause() internal virtual whenPaused {
1492         _paused = false;
1493         emit Unpaused(_msgSender());
1494     }
1495 }
1496 
1497 // File: @openzeppelin/contracts/access/Ownable.sol
1498 
1499 
1500 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1501 
1502 pragma solidity ^0.8.0;
1503 
1504 
1505 /**
1506  * @dev Contract module which provides a basic access control mechanism, where
1507  * there is an account (an owner) that can be granted exclusive access to
1508  * specific functions.
1509  *
1510  * By default, the owner account will be the one that deploys the contract. This
1511  * can later be changed with {transferOwnership}.
1512  *
1513  * This module is used through inheritance. It will make available the modifier
1514  * `onlyOwner`, which can be applied to your functions to restrict their use to
1515  * the owner.
1516  */
1517 abstract contract Ownable is Context {
1518     address private _owner;
1519 
1520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1521 
1522     /**
1523      * @dev Initializes the contract setting the deployer as the initial owner.
1524      */
1525     constructor() {
1526         _transferOwnership(_msgSender());
1527     }
1528 
1529     /**
1530      * @dev Returns the address of the current owner.
1531      */
1532     function owner() public view virtual returns (address) {
1533         return _owner;
1534     }
1535 
1536     /**
1537      * @dev Throws if called by any account other than the owner.
1538      */
1539     modifier onlyOwner() {
1540         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1541         _;
1542     }
1543 
1544     /**
1545      * @dev Leaves the contract without owner. It will not be possible to call
1546      * `onlyOwner` functions anymore. Can only be called by the current owner.
1547      *
1548      * NOTE: Renouncing ownership will leave the contract without an owner,
1549      * thereby removing any functionality that is only available to the owner.
1550      */
1551     function renounceOwnership() public virtual onlyOwner {
1552         _transferOwnership(address(0));
1553     }
1554 
1555     /**
1556      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1557      * Can only be called by the current owner.
1558      */
1559     function transferOwnership(address newOwner) public virtual onlyOwner {
1560         require(newOwner != address(0), "Ownable: new owner is the zero address");
1561         _transferOwnership(newOwner);
1562     }
1563 
1564     /**
1565      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1566      * Internal function without access restriction.
1567      */
1568     function _transferOwnership(address newOwner) internal virtual {
1569         address oldOwner = _owner;
1570         _owner = newOwner;
1571         emit OwnershipTransferred(oldOwner, newOwner);
1572     }
1573 }
1574 
1575 // File: contracts/heroesofarcan.sol
1576 
1577 
1578 
1579 pragma solidity >=0.7.0 <0.9.0;
1580 
1581 
1582 
1583 
1584 
1585 
1586 contract HeroesOfArcan is ERC721A, Ownable, Pausable {
1587     using Address for address;
1588     using Strings for uint256;
1589     event PermanentURI(string _value, uint256 indexed _id);
1590 
1591     uint public constant MAX_SUPPLY = 1000;
1592     uint public PRICE = 0.09 ether;
1593     uint public constant MAX_PER_MINT = 1000;
1594     uint public constant MAX_RESERVE_SUPPLY = 1000;
1595     bool private isRevealed=false;
1596     modifier dev {
1597       require(msg.sender == 0x52610c54C43c5b6910c7c4790A386d984B8Ee23D);
1598       _;
1599    }
1600     string private notRevealUrl="https://gateway.pinata.cloud/ipfs/QmQ9Z1Zn9mvFtp8HCqtj8oC4kngr3LQ7VuS6J6vXq55HAs";
1601 
1602     string public _contractBaseURI="https://gateway.pinata.cloud/ipfs/QmPs8B6G7ZdxakprXDGb7na5o8ei4Sv7nSWRVBWekJUPpc/";
1603 
1604     constructor() ERC721A("Heroes Of Arcan", "HOA") {
1605          transferOwnership(0x47632F8F8F89948BDdF7d46D4D4f957925EfB575); 
1606          }
1607 
1608     // reserve MAX_RESERVE_SUPPLY for promotional purposes
1609     function reserveNFTs(address to, uint256 quantity) external onlyOwner  {
1610         require(quantity > 0, "Quantity cannot be zero");
1611         uint totalMinted = totalSupply();
1612         require(totalMinted+quantity <= MAX_RESERVE_SUPPLY, "No more promo NFTs left");
1613         _safeMint(to, quantity);
1614     }
1615 
1616     function setPrice(uint256 _price) public dev onlyOwner {
1617         PRICE=_price;
1618     }
1619 
1620   function mint(address _to,uint256 quantity) external payable whenNotPaused {
1621         require(quantity > 0, "Quantity cannot be zero");
1622         uint totalMinted = totalSupply();
1623         require(quantity <= MAX_PER_MINT, "Cannot mint that many at once");
1624         require(totalMinted+quantity < MAX_SUPPLY, "Not enough NFTs left to mint");
1625         require(PRICE * quantity <= msg.value, "Insufficient funds sent");
1626         _safeMint(msg.sender, quantity);
1627     }
1628 
1629     function lockMetadata(uint256 quantity) internal {
1630         for (uint256 i = quantity; i > 0; i--) {
1631             uint256 tid = totalSupply() - i;
1632             emit PermanentURI(tokenURI(tid), tid);
1633         }
1634     }
1635 
1636     function pause() public onlyOwner {
1637         _pause();
1638     }
1639 
1640     function unpause() public onlyOwner {
1641         _unpause();
1642     }
1643 
1644     function withdraw() public dev onlyOwner  {
1645         uint balance = address(this).balance;
1646         payable(0x3d3E76Ff4AF910A9f7B74Ff9f570C9757353016D).transfer(balance);
1647     }
1648 
1649     function _baseURI() internal view override returns (string memory) {
1650         return _contractBaseURI;
1651     }
1652 
1653     //return uri for certain token
1654     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1655         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1656         if(!isRevealed){
1657             return notRevealUrl;
1658         }
1659         string memory baseURI = _baseURI();
1660         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1661     }
1662 
1663     function revealCollection() public dev onlyOwner  {
1664         isRevealed=true;
1665     }
1666     function setTokenUri(string memory newBaseTokenURI) public  onlyOwner {
1667         _contractBaseURI=newBaseTokenURI;
1668     }
1669     function setNotRevealUri(string memory newNotRevealedURI)public onlyOwner {
1670         notRevealUrl=newNotRevealedURI;
1671     }
1672 }