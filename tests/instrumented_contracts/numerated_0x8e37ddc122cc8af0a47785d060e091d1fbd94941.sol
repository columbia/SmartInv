1 // SPDX-License-Identifier: MIT
2 // Creator: Plur Labs
3 
4 pragma solidity ^0.8.4;
5 
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
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
29 
30 /**
31  * @dev String operations.
32  */
33 library Strings {
34     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
38      */
39     function toString(uint256 value) internal pure returns (string memory) {
40         // Inspired by OraclizeAPI's implementation - MIT licence
41         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
42 
43         if (value == 0) {
44             return "0";
45         }
46         uint256 temp = value;
47         uint256 digits;
48         while (temp != 0) {
49             digits++;
50             temp /= 10;
51         }
52         bytes memory buffer = new bytes(digits);
53         while (value != 0) {
54             digits -= 1;
55             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
56             value /= 10;
57         }
58         return string(buffer);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
63      */
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
79      */
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 }
92 
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      *
115      * [IMPORTANT]
116      * ====
117      * You shouldn't rely on `isContract` to protect against flash loan attacks!
118      *
119      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
120      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
121      * constructor.
122      * ====
123      */
124     function isContract(address account) internal view returns (bool) {
125         // This method relies on extcodesize/address.code.length, which returns 0
126         // for contracts in construction, since the code is only stored at the end
127         // of the constructor execution.
128 
129         return account.code.length > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
236         return functionStaticCall(target, data, "Address: low-level static call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(isContract(target), "Address: delegate call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
285      * revert reason using the provided one.
286      *
287      * _Available since v4.3._
288      */
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312 interface IERC721Receiver {
313     /**
314      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
315      * by `operator` from `from`, this function is called.
316      *
317      * It must return its Solidity selector to confirm the token transfer.
318      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
319      *
320      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
321      */
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 
331 /**
332  * @dev Required interface of an ERC721 compliant contract.
333  */
334 interface IERC721 is IERC165 {
335     /**
336      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
337      */
338     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
339 
340     /**
341      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
342      */
343     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
344 
345     /**
346      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
347      */
348     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
349 
350     /**
351      * @dev Returns the number of tokens in ``owner``'s account.
352      */
353     function balanceOf(address owner) external view returns (uint256 balance);
354 
355     /**
356      * @dev Returns the owner of the `tokenId` token.
357      *
358      * Requirements:
359      *
360      * - `tokenId` must exist.
361      */
362     function ownerOf(uint256 tokenId) external view returns (address owner);
363 
364     /**
365      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
366      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
367      *
368      * Requirements:
369      *
370      * - `from` cannot be the zero address.
371      * - `to` cannot be the zero address.
372      * - `tokenId` token must exist and be owned by `from`.
373      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
374      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
375      *
376      * Emits a {Transfer} event.
377      */
378     function safeTransferFrom(
379         address from,
380         address to,
381         uint256 tokenId
382     ) external;
383 
384     /**
385      * @dev Transfers `tokenId` token from `from` to `to`.
386      *
387      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
388      *
389      * Requirements:
390      *
391      * - `from` cannot be the zero address.
392      * - `to` cannot be the zero address.
393      * - `tokenId` token must be owned by `from`.
394      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
395      *
396      * Emits a {Transfer} event.
397      */
398     function transferFrom(
399         address from,
400         address to,
401         uint256 tokenId
402     ) external;
403 
404     /**
405      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
406      * The approval is cleared when the token is transferred.
407      *
408      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
409      *
410      * Requirements:
411      *
412      * - The caller must own the token or be an approved operator.
413      * - `tokenId` must exist.
414      *
415      * Emits an {Approval} event.
416      */
417     function approve(address to, uint256 tokenId) external;
418 
419     /**
420      * @dev Returns the account approved for `tokenId` token.
421      *
422      * Requirements:
423      *
424      * - `tokenId` must exist.
425      */
426     function getApproved(uint256 tokenId) external view returns (address operator);
427 
428     /**
429      * @dev Approve or remove `operator` as an operator for the caller.
430      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
431      *
432      * Requirements:
433      *
434      * - The `operator` cannot be the caller.
435      *
436      * Emits an {ApprovalForAll} event.
437      */
438     function setApprovalForAll(address operator, bool _approved) external;
439 
440     /**
441      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
442      *
443      * See {setApprovalForAll}
444      */
445     function isApprovedForAll(address owner, address operator) external view returns (bool);
446 
447     /**
448      * @dev Safely transfers `tokenId` token from `from` to `to`.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must exist and be owned by `from`.
455      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
457      *
458      * Emits a {Transfer} event.
459      */
460     function safeTransferFrom(
461         address from,
462         address to,
463         uint256 tokenId,
464         bytes calldata data
465     ) external;
466 }
467 
468 
469 
470 /**
471  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
472  * @dev See https://eips.ethereum.org/EIPS/eip-721
473  */
474 interface IERC721Metadata is IERC721 {
475     /**
476      * @dev Returns the token collection name.
477      */
478     function name() external view returns (string memory);
479 
480     /**
481      * @dev Returns the token collection symbol.
482      */
483     function symbol() external view returns (string memory);
484 
485     /**
486      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
487      */
488     function tokenURI(uint256 tokenId) external view returns (string memory);
489 }
490 
491 
492 /**
493  * @dev Implementation of the {IERC165} interface.
494  *
495  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
496  * for the additional interface id that will be supported. For example:
497  *
498  * ```solidity
499  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
500  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
501  * }
502  * ```
503  *
504  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
505  */
506 abstract contract ERC165 is IERC165 {
507     /**
508      * @dev See {IERC165-supportsInterface}.
509      */
510     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511         return interfaceId == type(IERC165).interfaceId;
512     }
513 }
514 
515 
516 /**
517  * @dev Contract module which provides a basic access control mechanism, where
518  * there is an account (an owner) that can be granted exclusive access to
519  * specific functions.
520  *
521  * By default, the owner account will be the one that deploys the contract. This
522  * can later be changed with {transferOwnership}.
523  *
524  * This module is used through inheritance. It will make available the modifier
525  * `onlyOwner`, which can be applied to your functions to restrict their use to
526  * the owner.
527  */
528 abstract contract Ownable is Context {
529     address private _owner;
530 
531     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
532 
533     /**
534      * @dev Initializes the contract setting the deployer as the initial owner.
535      */
536     constructor() {
537         _transferOwnership(_msgSender());
538     }
539 
540     /**
541      * @dev Returns the address of the current owner.
542      */
543     function owner() public view virtual returns (address) {
544         return _owner;
545     }
546 
547     /**
548      * @dev Throws if called by any account other than the owner.
549      */
550     modifier onlyOwner() {
551         require(owner() == _msgSender(), "Ownable: caller is not the owner");
552         _;
553     }
554 
555     /**
556      * @dev Leaves the contract without owner. It will not be possible to call
557      * `onlyOwner` functions anymore. Can only be called by the current owner.
558      *
559      * NOTE: Renouncing ownership will leave the contract without an owner,
560      * thereby removing any functionality that is only available to the owner.
561      */
562     function renounceOwnership() public virtual onlyOwner {
563         _transferOwnership(address(0));
564     }
565 
566     /**
567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
568      * Can only be called by the current owner.
569      */
570     function transferOwnership(address newOwner) public virtual onlyOwner {
571         require(newOwner != address(0), "Ownable: new owner is the zero address");
572         _transferOwnership(newOwner);
573     }
574 
575     /**
576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
577      * Internal function without access restriction.
578      */
579     function _transferOwnership(address newOwner) internal virtual {
580         address oldOwner = _owner;
581         _owner = newOwner;
582         emit OwnershipTransferred(oldOwner, newOwner);
583     }
584 }
585 
586 
587 error ApprovalCallerNotOwnerNorApproved();
588 error ApprovalQueryForNonexistentToken();
589 error ApproveToCaller();
590 error ApprovalToCurrentOwner();
591 error BalanceQueryForZeroAddress();
592 error MintToZeroAddress();
593 error MintZeroQuantity();
594 error OwnerQueryForNonexistentToken();
595 error TransferCallerNotOwnerNorApproved();
596 error TransferFromIncorrectOwner();
597 error TransferToNonERC721ReceiverImplementer();
598 error TransferToZeroAddress();
599 error URIQueryForNonexistentToken();
600 
601 /**
602  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
603  * the Metadata extension. Built to optimize for lower gas during batch mints.
604  *
605  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
606  *
607  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
608  *
609  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
610  */
611 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
612     using Address for address;
613     using Strings for uint256;
614 
615     // Compiler will pack this into a single 256bit word.
616     struct TokenOwnership {
617         // The address of the owner.
618         address addr;
619         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
620         uint64 startTimestamp;
621         // Whether the token has been burned.
622         bool burned;
623     }
624 
625     // Compiler will pack this into a single 256bit word.
626     struct AddressData {
627         // Realistically, 2**64-1 is more than enough.
628         uint64 balance;
629         // Keeps track of mint count with minimal overhead for tokenomics.
630         uint64 numberMinted;
631         // Keeps track of burn count with minimal overhead for tokenomics.
632         uint64 numberBurned;
633         // For miscellaneous variable(s) pertaining to the address
634         // (e.g. number of whitelist mint slots used).
635         // If there are multiple variables, please pack them into a uint64.
636         uint64 aux;
637     }
638 
639     // The tokenId of the next token to be minted.
640     uint256 internal _currentIndex;
641 
642     // The number of tokens burned.
643     uint256 internal _burnCounter;
644 
645     // Token name
646     string private _name;
647 
648     // Token symbol
649     string private _symbol;
650 
651     // Mapping from token ID to ownership details
652     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
653     mapping(uint256 => TokenOwnership) internal _ownerships;
654 
655     // Mapping owner address to address data
656     mapping(address => AddressData) private _addressData;
657 
658     // Mapping from token ID to approved address
659     mapping(uint256 => address) private _tokenApprovals;
660 
661     // Mapping from owner to operator approvals
662     mapping(address => mapping(address => bool)) private _operatorApprovals;
663 
664     constructor(string memory name_, string memory symbol_) {
665         _name = name_;
666         _symbol = symbol_;
667         _currentIndex = _startTokenId();
668     }
669 
670     /**
671      * To change the starting tokenId, please override this function.
672      */
673     function _startTokenId() internal view virtual returns (uint256) {
674         return 0;
675     }
676 
677     /**
678      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
679      */
680     function totalSupply() public view returns (uint256) {
681         // Counter underflow is impossible as _burnCounter cannot be incremented
682         // more than _currentIndex - _startTokenId() times
683         unchecked {
684             return _currentIndex - _burnCounter - _startTokenId();
685         }
686     }
687 
688     /**
689      * Returns the total amount of tokens minted in the contract.
690      */
691     function _totalMinted() internal view returns (uint256) {
692         // Counter underflow is impossible as _currentIndex does not decrement,
693         // and it is initialized to _startTokenId()
694         unchecked {
695             return _currentIndex - _startTokenId();
696         }
697     }
698 
699     /**
700      * @dev See {IERC165-supportsInterface}.
701      */
702     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
703         return
704             interfaceId == type(IERC721).interfaceId ||
705             interfaceId == type(IERC721Metadata).interfaceId ||
706             super.supportsInterface(interfaceId);
707     }
708 
709     /**
710      * @dev See {IERC721-balanceOf}.
711      */
712     function balanceOf(address owner) public view override returns (uint256) {
713         if (owner == address(0)) revert BalanceQueryForZeroAddress();
714         return uint256(_addressData[owner].balance);
715     }
716 
717     /**
718      * Returns the number of tokens minted by `owner`.
719      */
720     function _numberMinted(address owner) internal view returns (uint256) {
721         return uint256(_addressData[owner].numberMinted);
722     }
723 
724     /**
725      * Returns the number of tokens burned by or on behalf of `owner`.
726      */
727     function _numberBurned(address owner) internal view returns (uint256) {
728         return uint256(_addressData[owner].numberBurned);
729     }
730 
731     /**
732      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
733      */
734     function _getAux(address owner) internal view returns (uint64) {
735         return _addressData[owner].aux;
736     }
737 
738     /**
739      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
740      * If there are multiple variables, please pack them into a uint64.
741      */
742     function _setAux(address owner, uint64 aux) internal {
743         _addressData[owner].aux = aux;
744     }
745 
746     /**
747      * Gas spent here starts off proportional to the maximum mint batch size.
748      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
749      */
750     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
751         uint256 curr = tokenId;
752 
753         unchecked {
754             if (_startTokenId() <= curr && curr < _currentIndex) {
755                 TokenOwnership memory ownership = _ownerships[curr];
756                 if (!ownership.burned) {
757                     if (ownership.addr != address(0)) {
758                         return ownership;
759                     }
760                     // Invariant:
761                     // There will always be an ownership that has an address and is not burned
762                     // before an ownership that does not have an address and is not burned.
763                     // Hence, curr will not underflow.
764                     while (true) {
765                         curr--;
766                         ownership = _ownerships[curr];
767                         if (ownership.addr != address(0)) {
768                             return ownership;
769                         }
770                     }
771                 }
772             }
773         }
774         revert OwnerQueryForNonexistentToken();
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view override returns (address) {
781         return _ownershipOf(tokenId).addr;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-name}.
786      */
787     function name() public view virtual override returns (string memory) {
788         return _name;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-symbol}.
793      */
794     function symbol() public view virtual override returns (string memory) {
795         return _symbol;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-tokenURI}.
800      */
801     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
802         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
803 
804         string memory baseURI = _baseURI();
805         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
806     }
807 
808     function _baseURI() internal view virtual returns (string memory) {
809         return "";
810     }
811 
812     /**
813      * @dev See {IERC721-approve}.
814      */
815     function approve(address to, uint256 tokenId) public override {
816         address owner = ERC721A.ownerOf(tokenId);
817         if (to == owner) revert ApprovalToCurrentOwner();
818 
819         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
820             revert ApprovalCallerNotOwnerNorApproved();
821         }
822 
823         _approve(to, tokenId, owner);
824     }
825 
826     /**
827      * @dev See {IERC721-getApproved}.
828      */
829     function getApproved(uint256 tokenId) public view override returns (address) {
830         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
831 
832         return _tokenApprovals[tokenId];
833     }
834 
835     /**
836      * @dev See {IERC721-setApprovalForAll}.
837      */
838     function setApprovalForAll(address operator, bool approved) public virtual override {
839         if (operator == _msgSender()) revert ApproveToCaller();
840 
841         _operatorApprovals[_msgSender()][operator] = approved;
842         emit ApprovalForAll(_msgSender(), operator, approved);
843     }
844 
845     /**
846      * @dev See {IERC721-isApprovedForAll}.
847      */
848     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
849         return _operatorApprovals[owner][operator];
850     }
851 
852     /**
853      * @dev See {IERC721-transferFrom}.
854      */
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) public virtual override {
860         _transfer(from, to, tokenId);
861     }
862 
863     /**
864      * @dev See {IERC721-safeTransferFrom}.
865      */
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         safeTransferFrom(from, to, tokenId, '');
872     }
873 
874     /**
875      * @dev See {IERC721-safeTransferFrom}.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes memory _data
882     ) public virtual override {
883         _transfer(from, to, tokenId);
884         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
885             revert TransferToNonERC721ReceiverImplementer();
886         }
887     }
888 
889     /**
890      * @dev Returns whether `tokenId` exists.
891      *
892      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
893      *
894      * Tokens start existing when they are minted (`_mint`),
895      */
896     function _exists(uint256 tokenId) internal view returns (bool) {
897         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
898     }
899 
900     function _safeMint(address to, uint256 quantity) internal {
901         _safeMint(to, quantity, '');
902     }
903 
904     /**
905      * @dev Safely mints `quantity` tokens and transfers them to `to`.
906      *
907      * Requirements:
908      *
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
910      * - `quantity` must be greater than 0.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _safeMint(
915         address to,
916         uint256 quantity,
917         bytes memory _data
918     ) internal {
919         _mint(to, quantity, _data, true);
920     }
921 
922     /**
923      * @dev Mints `quantity` tokens and transfers them to `to`.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - `quantity` must be greater than 0.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _mint(
933         address to,
934         uint256 quantity,
935         bytes memory _data,
936         bool safe
937     ) internal {
938         uint256 startTokenId = _currentIndex;
939         if (to == address(0)) revert MintToZeroAddress();
940         if (quantity == 0) revert MintZeroQuantity();
941 
942         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
943 
944         // Overflows are incredibly unrealistic.
945         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
946         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
947         unchecked {
948             _addressData[to].balance += uint64(quantity);
949             _addressData[to].numberMinted += uint64(quantity);
950 
951             _ownerships[startTokenId].addr = to;
952             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
953 
954             uint256 updatedIndex = startTokenId;
955             uint256 end = updatedIndex + quantity;
956 
957             if (safe && to.isContract()) {
958                 do {
959                     emit Transfer(address(0), to, updatedIndex);
960                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
961                         revert TransferToNonERC721ReceiverImplementer();
962                     }
963                 } while (updatedIndex != end);
964                 // Reentrancy protection
965                 if (_currentIndex != startTokenId) revert();
966             } else {
967                 do {
968                     emit Transfer(address(0), to, updatedIndex++);
969                 } while (updatedIndex != end);
970             }
971             _currentIndex = updatedIndex;
972         }
973         _afterTokenTransfers(address(0), to, startTokenId, quantity);
974     }
975 
976     /**
977      * @dev Transfers `tokenId` from `from` to `to`.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _transfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) private {
991         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
992 
993         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
994 
995         bool isApprovedOrOwner = (_msgSender() == from ||
996             isApprovedForAll(from, _msgSender()) ||
997             getApproved(tokenId) == _msgSender());
998 
999         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1000         if (to == address(0)) revert TransferToZeroAddress();
1001 
1002         _beforeTokenTransfers(from, to, tokenId, 1);
1003 
1004         // Clear approvals from the previous owner
1005         _approve(address(0), tokenId, from);
1006 
1007         // Underflow of the sender's balance is impossible because we check for
1008         // ownership above and the recipient's balance can't realistically overflow.
1009         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1010         unchecked {
1011             _addressData[from].balance -= 1;
1012             _addressData[to].balance += 1;
1013 
1014             TokenOwnership storage currSlot = _ownerships[tokenId];
1015             currSlot.addr = to;
1016             currSlot.startTimestamp = uint64(block.timestamp);
1017 
1018             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1019             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1020             uint256 nextTokenId = tokenId + 1;
1021             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1022             if (nextSlot.addr == address(0)) {
1023                 // This will suffice for checking _exists(nextTokenId),
1024                 // as a burned slot cannot contain the zero address.
1025                 if (nextTokenId != _currentIndex) {
1026                     nextSlot.addr = from;
1027                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1028                 }
1029             }
1030         }
1031 
1032         emit Transfer(from, to, tokenId);
1033         _afterTokenTransfers(from, to, tokenId, 1);
1034     }
1035 
1036     /**
1037      * @dev This is equivalent to _burn(tokenId, false)
1038      */
1039     function _burn(uint256 tokenId) internal virtual {
1040         _burn(tokenId, false);
1041     }
1042 
1043     /**
1044      * @dev Destroys `tokenId`.
1045      * The approval is cleared when the token is burned.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must exist.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1054         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1055 
1056         address from = prevOwnership.addr;
1057 
1058         if (approvalCheck) {
1059             bool isApprovedOrOwner = (_msgSender() == from ||
1060                 isApprovedForAll(from, _msgSender()) ||
1061                 getApproved(tokenId) == _msgSender());
1062 
1063             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1064         }
1065 
1066         _beforeTokenTransfers(from, address(0), tokenId, 1);
1067 
1068         // Clear approvals from the previous owner
1069         _approve(address(0), tokenId, from);
1070 
1071         // Underflow of the sender's balance is impossible because we check for
1072         // ownership above and the recipient's balance can't realistically overflow.
1073         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1074         unchecked {
1075             AddressData storage addressData = _addressData[from];
1076             addressData.balance -= 1;
1077             addressData.numberBurned += 1;
1078 
1079             // Keep track of who burned the token, and the timestamp of burning.
1080             TokenOwnership storage currSlot = _ownerships[tokenId];
1081             currSlot.addr = from;
1082             currSlot.startTimestamp = uint64(block.timestamp);
1083             currSlot.burned = true;
1084 
1085             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1086             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1087             uint256 nextTokenId = tokenId + 1;
1088             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1089             if (nextSlot.addr == address(0)) {
1090                 // This will suffice for checking _exists(nextTokenId),
1091                 // as a burned slot cannot contain the zero address.
1092                 if (nextTokenId != _currentIndex) {
1093                     nextSlot.addr = from;
1094                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1095                 }
1096             }
1097         }
1098 
1099         emit Transfer(from, address(0), tokenId);
1100         _afterTokenTransfers(from, address(0), tokenId, 1);
1101 
1102         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1103         unchecked {
1104             _burnCounter++;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Approve `to` to operate on `tokenId`
1110      *
1111      * Emits a {Approval} event.
1112      */
1113     function _approve(
1114         address to,
1115         uint256 tokenId,
1116         address owner
1117     ) private {
1118         _tokenApprovals[tokenId] = to;
1119         emit Approval(owner, to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1124      *
1125      * @param from address representing the previous owner of the given token ID
1126      * @param to target address that will receive the tokens
1127      * @param tokenId uint256 ID of the token to be transferred
1128      * @param _data bytes optional data to send along with the call
1129      * @return bool whether the call correctly returned the expected magic value
1130      */
1131     function _checkContractOnERC721Received(
1132         address from,
1133         address to,
1134         uint256 tokenId,
1135         bytes memory _data
1136     ) private returns (bool) {
1137         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1138             return retval == IERC721Receiver(to).onERC721Received.selector;
1139         } catch (bytes memory reason) {
1140             if (reason.length == 0) {
1141                 revert TransferToNonERC721ReceiverImplementer();
1142             } else {
1143                 assembly {
1144                     revert(add(32, reason), mload(reason))
1145                 }
1146             }
1147         }
1148     }
1149 
1150     /**
1151      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1152      * And also called before burning one token.
1153      *
1154      * startTokenId - the first token id to be transferred
1155      * quantity - the amount to be transferred
1156      *
1157      * Calling conditions:
1158      *
1159      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1160      * transferred to `to`.
1161      * - When `from` is zero, `tokenId` will be minted for `to`.
1162      * - When `to` is zero, `tokenId` will be burned by `from`.
1163      * - `from` and `to` are never both zero.
1164      */
1165     function _beforeTokenTransfers(
1166         address from,
1167         address to,
1168         uint256 startTokenId,
1169         uint256 quantity
1170     ) internal virtual {}
1171 
1172     /**
1173      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1174      * minting.
1175      * And also called after one token has been burned.
1176      *
1177      * startTokenId - the first token id to be transferred
1178      * quantity - the amount to be transferred
1179      *
1180      * Calling conditions:
1181      *
1182      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1183      * transferred to `to`.
1184      * - When `from` is zero, `tokenId` has been minted for `to`.
1185      * - When `to` is zero, `tokenId` has been burned by `from`.
1186      * - `from` and `to` are never both zero.
1187      */
1188     function _afterTokenTransfers(
1189         address from,
1190         address to,
1191         uint256 startTokenId,
1192         uint256 quantity
1193     ) internal virtual {}
1194 }
1195 
1196 
1197 contract PLUR is ERC721A,Ownable {
1198   modifier callerIsUser() {
1199     require(tx.origin == msg.sender, "The caller is another contract");
1200     _;
1201   }
1202   constructor(string memory baseURI) ERC721A("PLUR", "PLUR") {
1203     _baseTokenURI = baseURI;
1204   }
1205 
1206   uint256 public supply = 8585;
1207   mapping(address => uint256) public minted;
1208 
1209     string private _baseTokenURI; 
1210 
1211   function mint(uint256 quantity) external payable callerIsUser {
1212     require(quantity <= 10, "can not mint this many.");
1213     require(minted[msg.sender] + quantity <= 20, "not eligible for mint.");
1214     require(quantity <= supply, "balance is not enough.");
1215     minted[msg.sender] += quantity;
1216     supply -= quantity;
1217     _safeMint(msg.sender, quantity);
1218   }
1219 
1220 
1221   function setBaseURI(string calldata baseURI) external onlyOwner {
1222     _baseTokenURI = baseURI;
1223   }
1224    
1225   function _baseURI() internal view virtual override returns (string memory) {
1226       return _baseTokenURI;
1227   }
1228 
1229   function withdraw() external onlyOwner {
1230     require(address(this).balance > 0, "balance is not enough.");
1231     Address.sendValue(payable(msg.sender), address(this).balance);
1232   }
1233 
1234   fallback() external payable{}
1235   receive() external payable{}
1236 
1237 }