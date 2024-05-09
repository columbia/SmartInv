1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 
67 /**
68  * @dev Provides information about the current execution context, including the
69  * sender of the transaction and its data. While these are generally available
70  * via msg.sender and msg.data, they should not be accessed in such a direct
71  * manner, since when dealing with meta-transactions the account sending and
72  * paying for execution may not be the actual sender (as far as an application
73  * is concerned).
74  *
75  * This contract is only required for intermediate, library-like contracts.
76  */
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes calldata) {
83         return msg.data;
84     }
85 }
86 
87 /**
88  * @dev Collection of functions related to the address type
89  */
90 library Address {
91     /**
92      * @dev Returns true if `account` is a contract.
93      *
94      * [IMPORTANT]
95      * ====
96      * It is unsafe to assume that an address for which this function returns
97      * false is an externally-owned account (EOA) and not a contract.
98      *
99      * Among others, `isContract` will return false for the following
100      * types of addresses:
101      *
102      *  - an externally-owned account
103      *  - a contract in construction
104      *  - an address where a contract will be created
105      *  - an address where a contract lived, but was destroyed
106      * ====
107      *
108      * [IMPORTANT]
109      * ====
110      * You shouldn't rely on `isContract` to protect against flash loan attacks!
111      *
112      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
113      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
114      * constructor.
115      * ====
116      */
117     function isContract(address account) internal view returns (bool) {
118         // This method relies on extcodesize/address.code.length, which returns 0
119         // for contracts in construction, since the code is only stored at the end
120         // of the constructor execution.
121 
122         return account.code.length > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 /**
306  * @title ERC721 token receiver interface
307  * @dev Interface for any contract that wants to support safeTransfers
308  * from ERC721 asset contracts.
309  */
310 interface IERC721Receiver {
311     /**
312      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
313      * by `operator` from `from`, this function is called.
314      *
315      * It must return its Solidity selector to confirm the token transfer.
316      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
317      *
318      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
319      */
320     function onERC721Received(
321         address operator,
322         address from,
323         uint256 tokenId,
324         bytes calldata data
325     ) external returns (bytes4);
326 }
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 /**
350  * @dev Implementation of the {IERC165} interface.
351  *
352  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
353  * for the additional interface id that will be supported. For example:
354  *
355  * ```solidity
356  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
358  * }
359  * ```
360  *
361  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
362  */
363 abstract contract ERC165 is IERC165 {
364     /**
365      * @dev See {IERC165-supportsInterface}.
366      */
367     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368         return interfaceId == type(IERC165).interfaceId;
369     }
370 }
371 
372 /**
373  * @dev Required interface of an ERC721 compliant contract.
374  */
375 interface IERC721 is IERC165 {
376     /**
377      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
383      */
384     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
385 
386     /**
387      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
388      */
389     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
390 
391     /**
392      * @dev Returns the number of tokens in ``owner``'s account.
393      */
394     function balanceOf(address owner) external view returns (uint256 balance);
395 
396     /**
397      * @dev Returns the owner of the `tokenId` token.
398      *
399      * Requirements:
400      *
401      * - `tokenId` must exist.
402      */
403     function ownerOf(uint256 tokenId) external view returns (address owner);
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
407      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) external;
424 
425     /**
426      * @dev Transfers `tokenId` token from `from` to `to`.
427      *
428      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      *
437      * Emits a {Transfer} event.
438      */
439     function transferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
447      * The approval is cleared when the token is transferred.
448      *
449      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
450      *
451      * Requirements:
452      *
453      * - The caller must own the token or be an approved operator.
454      * - `tokenId` must exist.
455      *
456      * Emits an {Approval} event.
457      */
458     function approve(address to, uint256 tokenId) external;
459 
460     /**
461      * @dev Returns the account approved for `tokenId` token.
462      *
463      * Requirements:
464      *
465      * - `tokenId` must exist.
466      */
467     function getApproved(uint256 tokenId) external view returns (address operator);
468 
469     /**
470      * @dev Approve or remove `operator` as an operator for the caller.
471      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
472      *
473      * Requirements:
474      *
475      * - The `operator` cannot be the caller.
476      *
477      * Emits an {ApprovalForAll} event.
478      */
479     function setApprovalForAll(address operator, bool _approved) external;
480 
481     /**
482      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
483      *
484      * See {setApprovalForAll}
485      */
486     function isApprovedForAll(address owner, address operator) external view returns (bool);
487 
488     /**
489      * @dev Safely transfers `tokenId` token from `from` to `to`.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must exist and be owned by `from`.
496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
497      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
498      *
499      * Emits a {Transfer} event.
500      */
501     function safeTransferFrom(
502         address from,
503         address to,
504         uint256 tokenId,
505         bytes calldata data
506     ) external;
507 }
508 
509 /**
510  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
511  * @dev See https://eips.ethereum.org/EIPS/eip-721
512  */
513 interface IERC721Enumerable is IERC721 {
514     /**
515      * @dev Returns the total amount of tokens stored by the contract.
516      */
517     function totalSupply() external view returns (uint256);
518 
519     /**
520      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
521      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
522      */
523     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
524 
525     /**
526      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
527      * Use along with {totalSupply} to enumerate all tokens.
528      */
529     function tokenByIndex(uint256 index) external view returns (uint256);
530 }
531 
532 /**
533  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
534  * @dev See https://eips.ethereum.org/EIPS/eip-721
535  */
536 interface IERC721Metadata is IERC721 {
537     /**
538      * @dev Returns the token collection name.
539      */
540     function name() external view returns (string memory);
541 
542     /**
543      * @dev Returns the token collection symbol.
544      */
545     function symbol() external view returns (string memory);
546 
547     /**
548      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
549      */
550     function tokenURI(uint256 tokenId) external view returns (string memory);
551 }
552 
553 error ApprovalCallerNotOwnerNorApproved();
554 error ApprovalQueryForNonexistentToken();
555 error ApproveToCaller();
556 error ApprovalToCurrentOwner();
557 error BalanceQueryForZeroAddress();
558 error MintedQueryForZeroAddress();
559 error BurnedQueryForZeroAddress();
560 error AuxQueryForZeroAddress();
561 error MintToZeroAddress();
562 error MintZeroQuantity();
563 error OwnerIndexOutOfBounds();
564 error OwnerQueryForNonexistentToken();
565 error TokenIndexOutOfBounds();
566 error TransferCallerNotOwnerNorApproved();
567 error TransferFromIncorrectOwner();
568 error TransferToNonERC721ReceiverImplementer();
569 error TransferToZeroAddress();
570 error URIQueryForNonexistentToken();
571 
572 /**
573  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
574  * the Metadata extension. Built to optimize for lower gas during batch mints.
575  *
576  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
577  *
578  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
579  *
580  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
581  */
582 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
583     using Address for address;
584     using Strings for uint256;
585 
586     // Compiler will pack this into a single 256bit word.
587     struct TokenOwnership {
588         // The address of the owner.
589         address addr;
590         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
591         uint64 startTimestamp;
592         // Whether the token has been burned.
593         bool burned;
594     }
595 
596     // Compiler will pack this into a single 256bit word.
597     struct AddressData {
598         // Realistically, 2**64-1 is more than enough.
599         uint64 balance;
600         // Keeps track of mint count with minimal overhead for tokenomics.
601         uint64 numberMinted;
602         // Keeps track of burn count with minimal overhead for tokenomics.
603         uint64 numberBurned;
604         // For miscellaneous variable(s) pertaining to the address
605         // (e.g. number of whitelist mint slots used).
606         // If there are multiple variables, please pack them into a uint64.
607         uint64 aux;
608     }
609 
610     // The tokenId of the next token to be minted.
611     uint256 internal _currentIndex;
612 
613     // The number of tokens burned.
614     uint256 internal _burnCounter;
615 
616     // Token name
617     string private _name;
618 
619     // Token symbol
620     string private _symbol;
621 
622     // Mapping from token ID to ownership details
623     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
624     mapping(uint256 => TokenOwnership) internal _ownerships;
625 
626     // Mapping owner address to address data
627     mapping(address => AddressData) private _addressData;
628 
629     // Mapping from token ID to approved address
630     mapping(uint256 => address) private _tokenApprovals;
631 
632     // Mapping from owner to operator approvals
633     mapping(address => mapping(address => bool)) private _operatorApprovals;
634 
635     constructor(string memory name_, string memory symbol_) {
636         _name = name_;
637         _symbol = symbol_;
638         _currentIndex = _startTokenId();
639     }
640 
641     /**
642      * To change the starting tokenId, please override this function.
643      */
644     function _startTokenId() internal view virtual returns (uint256) {
645         return 0;
646     }
647 
648     /**
649      * @dev See {IERC721Enumerable-totalSupply}.
650      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
651      */
652     function totalSupply() public view returns (uint256) {
653         // Counter underflow is impossible as _burnCounter cannot be incremented
654         // more than _currentIndex - _startTokenId() times
655         unchecked {
656             return _currentIndex - _burnCounter - _startTokenId();
657         }
658     }
659 
660     /**
661      * Returns the total amount of tokens minted in the contract.
662      */
663     function _totalMinted() internal view returns (uint256) {
664         // Counter underflow is impossible as _currentIndex does not decrement,
665         // and it is initialized to _startTokenId()
666         unchecked {
667             return _currentIndex - _startTokenId();
668         }
669     }
670 
671     /**
672      * @dev See {IERC165-supportsInterface}.
673      */
674     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
675         return
676             interfaceId == type(IERC721).interfaceId ||
677             interfaceId == type(IERC721Metadata).interfaceId ||
678             super.supportsInterface(interfaceId);
679     }
680 
681     /**
682      * @dev See {IERC721-balanceOf}.
683      */
684     function balanceOf(address owner) public view override returns (uint256) {
685         if (owner == address(0)) revert BalanceQueryForZeroAddress();
686         return uint256(_addressData[owner].balance);
687     }
688 
689     /**
690      * Returns the number of tokens minted by `owner`.
691      */
692     function _numberMinted(address owner) internal view returns (uint256) {
693         if (owner == address(0)) revert MintedQueryForZeroAddress();
694         return uint256(_addressData[owner].numberMinted);
695     }
696 
697     /**
698      * Returns the number of tokens burned by or on behalf of `owner`.
699      */
700     function _numberBurned(address owner) internal view returns (uint256) {
701         if (owner == address(0)) revert BurnedQueryForZeroAddress();
702         return uint256(_addressData[owner].numberBurned);
703     }
704 
705     /**
706      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
707      */
708     function _getAux(address owner) internal view returns (uint64) {
709         if (owner == address(0)) revert AuxQueryForZeroAddress();
710         return _addressData[owner].aux;
711     }
712 
713     /**
714      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
715      * If there are multiple variables, please pack them into a uint64.
716      */
717     function _setAux(address owner, uint64 aux) internal {
718         if (owner == address(0)) revert AuxQueryForZeroAddress();
719         _addressData[owner].aux = aux;
720     }
721 
722     /**
723      * Gas spent here starts off proportional to the maximum mint batch size.
724      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
725      */
726     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
727         uint256 curr = tokenId;
728 
729         unchecked {
730             if (_startTokenId() <= curr && curr < _currentIndex) {
731                 TokenOwnership memory ownership = _ownerships[curr];
732                 if (!ownership.burned) {
733                     if (ownership.addr != address(0)) {
734                         return ownership;
735                     }
736                     // Invariant:
737                     // There will always be an ownership that has an address and is not burned
738                     // before an ownership that does not have an address and is not burned.
739                     // Hence, curr will not underflow.
740                     while (true) {
741                         curr--;
742                         ownership = _ownerships[curr];
743                         if (ownership.addr != address(0)) {
744                             return ownership;
745                         }
746                     }
747                 }
748             }
749         }
750         revert OwnerQueryForNonexistentToken();
751     }
752 
753     /**
754      * @dev See {IERC721-ownerOf}.
755      */
756     function ownerOf(uint256 tokenId) public view override returns (address) {
757         return ownershipOf(tokenId).addr;
758     }
759 
760     /**
761      * @dev See {IERC721Metadata-name}.
762      */
763     function name() public view virtual override returns (string memory) {
764         return _name;
765     }
766 
767     /**
768      * @dev See {IERC721Metadata-symbol}.
769      */
770     function symbol() public view virtual override returns (string memory) {
771         return _symbol;
772     }
773 
774     /**
775      * @dev See {IERC721Metadata-tokenURI}.
776      */
777     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
778         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
779 
780         string memory baseURI = _baseURI();
781         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
782     }
783 
784     /**
785      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
786      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
787      * by default, can be overriden in child contracts.
788      */
789     function _baseURI() internal view virtual returns (string memory) {
790         return '';
791     }
792 
793     /**
794      * @dev See {IERC721-approve}.
795      */
796     function approve(address to, uint256 tokenId) public virtual override {
797         address owner = ERC721A.ownerOf(tokenId);
798         if (to == owner) revert ApprovalToCurrentOwner();
799 
800         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
801             revert ApprovalCallerNotOwnerNorApproved();
802         }
803 
804         _approve(to, tokenId, owner);
805     }
806 
807     /**
808      * @dev See {IERC721-getApproved}.
809      */
810     function getApproved(uint256 tokenId) public view override returns (address) {
811         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
812 
813         return _tokenApprovals[tokenId];
814     }
815 
816     /**
817      * @dev See {IERC721-setApprovalForAll}.
818      */
819     function setApprovalForAll(address operator, bool approved) public override {
820         if (operator == _msgSender()) revert ApproveToCaller();
821 
822         _operatorApprovals[_msgSender()][operator] = approved;
823         emit ApprovalForAll(_msgSender(), operator, approved);
824     }
825 
826     /**
827      * @dev See {IERC721-isApprovedForAll}.
828      */
829     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
830         return _operatorApprovals[owner][operator];
831     }
832 
833     /**
834      * @dev See {IERC721-transferFrom}.
835      */
836     function transferFrom(
837         address from,
838         address to,
839         uint256 tokenId
840     ) public virtual override {
841         _transfer(from, to, tokenId);
842     }
843 
844     /**
845      * @dev See {IERC721-safeTransferFrom}.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         safeTransferFrom(from, to, tokenId, '');
853     }
854 
855     /**
856      * @dev See {IERC721-safeTransferFrom}.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId,
862         bytes memory _data
863     ) public virtual override {
864         _transfer(from, to, tokenId);
865         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
866             revert TransferToNonERC721ReceiverImplementer();
867         }
868     }
869 
870     /**
871      * @dev Returns whether `tokenId` exists.
872      *
873      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
874      *
875      * Tokens start existing when they are minted (`_mint`),
876      */
877     function _exists(uint256 tokenId) internal view returns (bool) {
878         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
879             !_ownerships[tokenId].burned;
880     }
881 
882     function _safeMint(address to, uint256 quantity) internal {
883         _safeMint(to, quantity, '');
884     }
885 
886     /**
887      * @dev Safely mints `quantity` tokens and transfers them to `to`.
888      *
889      * Requirements:
890      *
891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
892      * - `quantity` must be greater than 0.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _safeMint(
897         address to,
898         uint256 quantity,
899         bytes memory _data
900     ) internal {
901         _mint(to, quantity, _data, true);
902     }
903 
904     /**
905      * @dev Mints `quantity` tokens and transfers them to `to`.
906      *
907      * Requirements:
908      *
909      * - `to` cannot be the zero address.
910      * - `quantity` must be greater than 0.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _mint(
915         address to,
916         uint256 quantity,
917         bytes memory _data,
918         bool safe
919     ) internal {
920         uint256 startTokenId = _currentIndex;
921         if (to == address(0)) revert MintToZeroAddress();
922         if (quantity == 0) revert MintZeroQuantity();
923 
924         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
925 
926         // Overflows are incredibly unrealistic.
927         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
928         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
929         unchecked {
930             _addressData[to].balance += uint64(quantity);
931             _addressData[to].numberMinted += uint64(quantity);
932 
933             _ownerships[startTokenId].addr = to;
934             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
935 
936             uint256 updatedIndex = startTokenId;
937             uint256 end = updatedIndex + quantity;
938 
939             if (safe && to.isContract()) {
940                 do {
941                     emit Transfer(address(0), to, updatedIndex);
942                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
943                         revert TransferToNonERC721ReceiverImplementer();
944                     }
945                 } while (updatedIndex != end);
946                 // Reentrancy protection
947                 if (_currentIndex != startTokenId) revert();
948             } else {
949                 do {
950                     emit Transfer(address(0), to, updatedIndex++);
951                 } while (updatedIndex != end);
952             }
953             _currentIndex = updatedIndex;
954         }
955         _afterTokenTransfers(address(0), to, startTokenId, quantity);
956     }
957 
958     /**
959      * @dev Transfers `tokenId` from `from` to `to`.
960      *
961      * Requirements:
962      *
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must be owned by `from`.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _transfer(
969         address from,
970         address to,
971         uint256 tokenId
972     ) private {
973         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
974 
975         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
976             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
977             getApproved(tokenId) == _msgSender());
978 
979         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
980         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
981         if (to == address(0)) revert TransferToZeroAddress();
982 
983         _beforeTokenTransfers(from, to, tokenId, 1);
984 
985         // Clear approvals from the previous owner
986         _approve(address(0), tokenId, prevOwnership.addr);
987 
988         // Underflow of the sender's balance is impossible because we check for
989         // ownership above and the recipient's balance can't realistically overflow.
990         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
991         unchecked {
992             _addressData[from].balance -= 1;
993             _addressData[to].balance += 1;
994 
995             _ownerships[tokenId].addr = to;
996             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
997 
998             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
999             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1000             uint256 nextTokenId = tokenId + 1;
1001             if (_ownerships[nextTokenId].addr == address(0)) {
1002                 // This will suffice for checking _exists(nextTokenId),
1003                 // as a burned slot cannot contain the zero address.
1004                 if (nextTokenId < _currentIndex) {
1005                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1006                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1007                 }
1008             }
1009         }
1010 
1011         emit Transfer(from, to, tokenId);
1012         _afterTokenTransfers(from, to, tokenId, 1);
1013     }
1014 
1015     /**
1016      * @dev Destroys `tokenId`.
1017      * The approval is cleared when the token is burned.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _burn(uint256 tokenId) internal virtual {
1026         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1027 
1028         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId, prevOwnership.addr);
1032 
1033         // Underflow of the sender's balance is impossible because we check for
1034         // ownership above and the recipient's balance can't realistically overflow.
1035         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1036         unchecked {
1037             _addressData[prevOwnership.addr].balance -= 1;
1038             _addressData[prevOwnership.addr].numberBurned += 1;
1039 
1040             // Keep track of who burned the token, and the timestamp of burning.
1041             _ownerships[tokenId].addr = prevOwnership.addr;
1042             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1043             _ownerships[tokenId].burned = true;
1044 
1045             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1046             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1047             uint256 nextTokenId = tokenId + 1;
1048             if (_ownerships[nextTokenId].addr == address(0)) {
1049                 // This will suffice for checking _exists(nextTokenId),
1050                 // as a burned slot cannot contain the zero address.
1051                 if (nextTokenId < _currentIndex) {
1052                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1053                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1054                 }
1055             }
1056         }
1057 
1058         emit Transfer(prevOwnership.addr, address(0), tokenId);
1059         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1060 
1061         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1062         unchecked {
1063             _burnCounter++;
1064         }
1065     }
1066 
1067     /**
1068      * @dev Approve `to` to operate on `tokenId`
1069      *
1070      * Emits a {Approval} event.
1071      */
1072     function _approve(
1073         address to,
1074         uint256 tokenId,
1075         address owner
1076     ) private {
1077         _tokenApprovals[tokenId] = to;
1078         emit Approval(owner, to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1083      *
1084      * @param from address representing the previous owner of the given token ID
1085      * @param to target address that will receive the tokens
1086      * @param tokenId uint256 ID of the token to be transferred
1087      * @param _data bytes optional data to send along with the call
1088      * @return bool whether the call correctly returned the expected magic value
1089      */
1090     function _checkContractOnERC721Received(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) private returns (bool) {
1096         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1097             return retval == IERC721Receiver(to).onERC721Received.selector;
1098         } catch (bytes memory reason) {
1099             if (reason.length == 0) {
1100                 revert TransferToNonERC721ReceiverImplementer();
1101             } else {
1102                 assembly {
1103                     revert(add(32, reason), mload(reason))
1104                 }
1105             }
1106         }
1107     }
1108 
1109     /**
1110      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1111      * And also called before burning one token.
1112      *
1113      * startTokenId - the first token id to be transferred
1114      * quantity - the amount to be transferred
1115      *
1116      * Calling conditions:
1117      *
1118      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1119      * transferred to `to`.
1120      * - When `from` is zero, `tokenId` will be minted for `to`.
1121      * - When `to` is zero, `tokenId` will be burned by `from`.
1122      * - `from` and `to` are never both zero.
1123      */
1124     function _beforeTokenTransfers(
1125         address from,
1126         address to,
1127         uint256 startTokenId,
1128         uint256 quantity
1129     ) internal virtual {}
1130 
1131     /**
1132      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1133      * minting.
1134      * And also called after one token has been burned.
1135      *
1136      * startTokenId - the first token id to be transferred
1137      * quantity - the amount to be transferred
1138      *
1139      * Calling conditions:
1140      *
1141      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1142      * transferred to `to`.
1143      * - When `from` is zero, `tokenId` has been minted for `to`.
1144      * - When `to` is zero, `tokenId` has been burned by `from`.
1145      * - `from` and `to` are never both zero.
1146      */
1147     function _afterTokenTransfers(
1148         address from,
1149         address to,
1150         uint256 startTokenId,
1151         uint256 quantity
1152     ) internal virtual {}
1153 }
1154 
1155 contract MhNFT is ERC721A {
1156     using Strings for uint256;
1157 
1158     string public baseURI; //base url of the token uri
1159     address public owner; // owner of the contract
1160     uint256 public mintPrice; // normal mint price
1161     uint256 public maxSupply; //maximum supply
1162     bool public isMintActive;
1163 
1164     // reveal related variables
1165     bool public isRevealed;
1166     string public placeholderURI; // placeholder uri when unrevealed
1167 
1168     // Payment
1169     uint256 private maxShares;
1170     mapping(address => uint256) private _shares;
1171     mapping(address => uint256) private _released;
1172     uint256 private _totalShares;
1173     uint256 private _totalReleased;
1174     address[] private _activeShareAddresses;
1175     bool private _lockedShares;
1176 
1177     // Mint
1178     uint256 public maxBatch;
1179     uint256 public publicMintable;
1180 
1181     // Staking
1182     mapping(uint256 => bool) private _staking;
1183 
1184     constructor(string memory _baseUri, string memory _placeholderURI) ERC721A("Meta Hooligans", "MH") {
1185         //init variables
1186         maxShares = 1000;
1187         owner = msg.sender;
1188         maxSupply = 8888;
1189 
1190         maxBatch = 11;
1191 
1192         // Second round of tokens
1193         mintPrice = 0.15 ether;
1194         isMintActive = false;
1195         publicMintable = 1500;
1196 
1197         // Max reserved tokens for owner
1198         _setAux(owner, 888);
1199         baseURI = _baseUri;
1200         placeholderURI = _placeholderURI;
1201 
1202         // Prep initial Payees
1203         _totalShares = maxShares;
1204         
1205         // A
1206         _shares[address(0xcc39e35310Cfd6288B1207F17c35Fb286dF31cCb)] = 125;
1207         _activeShareAddresses.push(address(0xcc39e35310Cfd6288B1207F17c35Fb286dF31cCb));
1208 
1209         // I
1210         _shares[address(0x91fec88ACf5951d76ABbb6f0C49e539499eB40fe)] = 40;
1211         _activeShareAddresses.push(address(0x91fec88ACf5951d76ABbb6f0C49e539499eB40fe));
1212 
1213         // D
1214         _shares[address(0x230a9d302205c8Ea21cC51834EcA3cBFCEEDB3Fb)] = 420;
1215         _activeShareAddresses.push(address(0x230a9d302205c8Ea21cC51834EcA3cBFCEEDB3Fb));
1216 
1217         // B
1218         _shares[address(0x00b08925e0FbE084329D0695c246676318E1030F)] = 415;
1219         _activeShareAddresses.push(address(0x00b08925e0FbE084329D0695c246676318E1030F));
1220 
1221         // // Donations
1222         // _shares[address(0xE4838f37145f4066714867E224D16050441fAcA6)] = 0;
1223         // _activeShareAddresses.push(address(0xE4838f37145f4066714867E224D16050441fAcA6));
1224 
1225         // // Marketing
1226         // _shares[address(0x8C32aA65108b8efE92A436D97e573330AdaDd5F0)] = 0;
1227         // _activeShareAddresses.push(address(0x8C32aA65108b8efE92A436D97e573330AdaDd5F0));
1228     }
1229 
1230     function _startTokenId() internal view virtual override returns (uint256) {
1231         return 1;
1232     }
1233 
1234     ///////////////////////////////////////////////
1235     // owner related
1236     ///////////////////////////////////////////////
1237     modifier ownerOnly () {
1238         require(msg.sender == owner, "Only owner");
1239         _;
1240     }
1241 
1242     function setOwner(address _owner) external ownerOnly{
1243         owner = _owner;
1244     }
1245     function withdrawAll() public ownerOnly {
1246         uint256 balance = address(this).balance;
1247         require(balance > 0, "Nothing to withdraw");
1248         _released[msg.sender] += balance; 
1249         _totalReleased += balance;
1250         payable(msg.sender).transfer(balance);
1251     }
1252     function withdrawToAddress(address _address) public ownerOnly {
1253         require(_address != address(0), "Cannot be address 0");
1254         require(_address != address(this), "Cannot be address the contract");
1255         uint256 balance = address(this).balance;
1256         require(balance > 0, "Nothing to withdraw");
1257         _released[msg.sender] += balance; 
1258         _totalReleased += balance;
1259         payable(msg.sender).transfer(balance);
1260     }
1261     function withdraw() public ownerOnly {
1262         require(_activeShareAddresses.length > 0, "No shares to process");
1263         uint256 balance = address(this).balance;
1264         require(balance > 0, "Nothing to withdraw");
1265         uint256 remainingBalance = balance;
1266         for(uint256 i=0; i<_activeShareAddresses.length; i++){
1267             uint256 shareBalance = 0;
1268             if(i == _activeShareAddresses.length-1){
1269                 shareBalance = remainingBalance;
1270             } else {
1271                 shareBalance = _shares[_activeShareAddresses[i]] * balance / _totalShares;
1272             }
1273             require(shareBalance > 0, "Error splitting shares");
1274             _released[_activeShareAddresses[i]] += shareBalance;
1275             _totalReleased += shareBalance;
1276             remainingBalance -= shareBalance;
1277             payable(_activeShareAddresses[i]).transfer(shareBalance);
1278         }
1279     }
1280     function ownerMintable() public ownerOnly view returns (uint64) {
1281         return _getAux(msg.sender);
1282     }
1283 
1284     ///////////////////////////////////////////////
1285     // payment related
1286     ///////////////////////////////////////////////
1287     receive() external payable { }
1288     function addPayee(address _address, uint256 _sharesToGive) external ownerOnly {
1289         require(!_lockedShares, "Shares are locked");
1290         require(_totalShares + _sharesToGive <= maxShares, "Cannot exceed 100% shares");
1291         require(_shares[_address] == 0, "Shares already exist for payee");
1292         
1293         _shares[_address] = _sharesToGive;
1294         _totalShares += _sharesToGive;
1295         _activeShareAddresses.push(_address);
1296     }
1297     function removePayee(address _address) external ownerOnly {
1298         require(!_lockedShares, "Shares are locked");
1299         require(_shares[_address] > 0, "Not a payee");
1300         _totalShares -= _shares[_address];
1301         _shares[_address] = 0;
1302 
1303         address[] memory newArray = new address[](_activeShareAddresses.length-1);
1304         uint256 count = 0;
1305         for(uint256 i=0; i < _activeShareAddresses.length; i++){
1306             if(_activeShareAddresses[i] != _address){
1307                 newArray[count] = _activeShareAddresses[i];
1308                 count += 1;
1309             }
1310         }
1311 
1312         _activeShareAddresses = newArray;
1313     }
1314     function modifyPayee(address _address, uint256 _sharesToGive) external ownerOnly {
1315         require(!_lockedShares, "Shares are locked");
1316         require(_shares[_address] > 0, "Not a payee");
1317         require(_sharesToGive > 0, "Shares has to greather than 0");
1318         require(_totalShares - _shares[_address] + _sharesToGive <= maxShares, "Shares cannot exceed 100");
1319         
1320         _totalShares = _totalShares - _shares[_address] + _sharesToGive;
1321         _shares[_address] = _sharesToGive;
1322     }
1323     function shares() public view returns (uint) {
1324         if(msg.sender == owner){
1325             return maxShares;
1326         }
1327         return _shares[msg.sender];
1328     }
1329     function released() public view returns (uint) {
1330         return _released[msg.sender];
1331     }
1332     function totalShares() public ownerOnly view returns (uint) {
1333         return _totalShares;
1334     }
1335     function releasedForAddress(address _address) public ownerOnly view returns (uint) {
1336         return _released[_address];
1337     }
1338     function sharesForAddress(address _address) public ownerOnly view returns (uint) {
1339         if(_address == owner){
1340             return maxShares;
1341         }
1342         return _shares[_address];
1343     }
1344     function lockShares() public ownerOnly {
1345         _lockedShares = true;
1346     }
1347 
1348     ///////////////////////////////////////////////
1349     // base url related
1350     ///////////////////////////////////////////////
1351     function _baseURI() internal view virtual override returns (string memory) {
1352         return baseURI;
1353     }
1354     function setBaseURI(string memory uri) public ownerOnly{
1355         baseURI = uri;
1356     }
1357     function setIsRevealed(bool _isRevealed) public ownerOnly{
1358         isRevealed=_isRevealed;
1359     }
1360     function setPlaceholderUri(string memory uri) public ownerOnly{
1361         placeholderURI = uri;
1362     }
1363     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1364         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1365 
1366         if(!isRevealed){
1367             return bytes(placeholderURI).length !=0 ? string(abi.encodePacked(placeholderURI)) : '';
1368         } else {
1369             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1370         }
1371     }
1372 
1373     ///////////////////////////////////////////////
1374     // mint related
1375     ///////////////////////////////////////////////
1376     event TokenMinted(uint256);
1377     event TokenAirDropped(address, uint256);
1378 
1379     function setPublicMintable(uint256 _amount) external ownerOnly {
1380         require(_amount + totalSupply() + ownerMintable() <= maxSupply, "Cannot be more than max");
1381         publicMintable = _amount;
1382     }
1383     function setPublicMintableWithPrice(uint256 _amount, uint256 _price) external ownerOnly {
1384         require(_amount + totalSupply() <= maxSupply, "Cannot be more than max");
1385         publicMintable = _amount;
1386         mintPrice = _price;
1387     }
1388     function setMaxMintBatch(uint256 _amount) external ownerOnly {
1389         require(_amount > 0, "Needs to be more than 0");
1390         maxBatch = _amount;
1391     }
1392     function setMintPrice(uint256 _price) external ownerOnly{
1393         mintPrice = _price;
1394     }
1395     function setMintActive(bool _active) external ownerOnly{
1396         isMintActive = _active;
1397     }
1398     function mint(uint64 _amount) external payable {
1399         // Owner with value or public mints
1400         if(msg.sender != owner || msg.value > 0){
1401             require(isMintActive, "Public mint is not active");
1402             require(mintPrice > 0, "Public mint price is not set");
1403             require(_amount <= maxBatch, "Cannot mint more than maxBatch");
1404             require(publicMintable - _amount >= 0, "Not enough tokens available for public");
1405             require(msg.value >= mintPrice * _amount, "Price is not met");
1406             publicMintable = publicMintable - _amount;
1407         }
1408 
1409         // Owner reserved tokens
1410         if(msg.sender == owner && msg.value == 0) {
1411             // Is owner
1412             uint64 ownerMintableTokens = ownerMintable();
1413             require(ownerMintableTokens >= _amount , "Not enough token left for owner");
1414             _setAux(owner, ownerMintableTokens - _amount);
1415         }
1416 
1417         _safeMint(msg.sender, _amount);
1418     }
1419     ///////////////////////////////////////////////
1420     // Stake functionality with overrides
1421     ///////////////////////////////////////////////
1422     event Stake(uint256 indexed tokenId);
1423     event UnStake(uint256 indexed tokenId);
1424 
1425     function stake(uint256 tokenId) public {
1426         require(ownerOf(tokenId) == msg.sender, "Only owner of token can stake");
1427         require(_staking[tokenId] == false, "Token already staking");
1428         _staking[tokenId] = true;
1429 
1430         emit Stake(tokenId);
1431     }
1432     function unstake(uint256 tokenId) public {
1433         require(ownerOf(tokenId) == msg.sender, "Only owner of token can unstake");
1434         require(_staking[tokenId] == true, "Token not staking");
1435         _staking[tokenId] = false;
1436 
1437          emit UnStake(tokenId);
1438     }
1439     function isStaking(uint256 tokenId) public view returns (bool) {
1440         return _staking[tokenId];
1441     }
1442 
1443     ///////////////////////////////////////////////
1444     // Transfers
1445     ///////////////////////////////////////////////
1446     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1447         require(isStaking(tokenId) == false, "Token is staking");
1448         ERC721A.transferFrom(from, to, tokenId);
1449     }
1450     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1451         require(isStaking(tokenId) == false, "Token is staking");
1452         ERC721A.safeTransferFrom(from, to, tokenId, "");
1453     }
1454     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1455         require(isStaking(tokenId) == false, "Token is staking");
1456         ERC721A.safeTransferFrom(from, to, tokenId, _data);
1457     }
1458     function approve(address to, uint256 tokenId) public override {
1459         require(isStaking(tokenId) == false, "Token is staking");
1460         ERC721A.approve(to, tokenId);
1461     }
1462 }