1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.15;
3 
4 /*
5 
6  /$$   /$$ /$$$$$$$$       /$$$$$$$$ /$$
7 | $$  / $$|_____ $$/      | $$_____/|__/
8 |  $$/ $$/     /$$/       | $$       /$$ /$$$$$$$   /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$
9  \  $$$$/     /$$/        | $$$$$   | $$| $$__  $$ |____  $$| $$__  $$ /$$_____/ /$$__  $$
10   >$$  $$    /$$/         | $$__/   | $$| $$  \ $$  /$$$$$$$| $$  \ $$| $$      | $$$$$$$$
11  /$$/\  $$  /$$/          | $$      | $$| $$  | $$ /$$__  $$| $$  | $$| $$      | $$_____/
12 | $$  \ $$ /$$/           | $$      | $$| $$  | $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$
13 |__/  |__/|__/            |__/      |__/|__/  |__/ \_______/|__/  |__/ \_______/ \_______/
14 
15 Contract: ERC-721 Token "X7 Pioneer" NFT
16 
17 A utility NFT offering reward withdrawal.
18 
19 This contract will NOT be renounced.
20 
21 The following are the only functions that can be called on the contract that affect the contract:
22 
23     function setTransferUnlockFeeDestination(address transferUnlockFeeDestination_) external onlyOwner {
24         require(transferUnlockFeeDestination != transferUnlockFeeDestination_);
25         address oldTransferUnlockFeeDestination = transferUnlockFeeDestination;
26         transferUnlockFeeDestination = payable(transferUnlockFeeDestination_);
27         emit TransferUnlockFeeDestinationSet(oldTransferUnlockFeeDestination, transferUnlockFeeDestination_);
28     }
29 
30     function setBaseURI(string memory baseURI_) external onlyOwner {
31         require(keccak256(abi.encodePacked(_internalBaseURI)) != keccak256(abi.encodePacked(baseURI_)));
32         string memory oldBaseURI = _internalBaseURI;
33         _internalBaseURI = baseURI_;
34         emit BaseURISet(oldBaseURI, baseURI_);
35     }
36 
37     function setTransferUnlockFee(uint256 transferUnlockFee_) external onlyOwner {
38         require(transferUnlockFee_ != transferUnlockFee);
39         uint256 oldTransferUnlockFee = transferUnlockFee;
40         transferUnlockFee = transferUnlockFee_;
41         emit TransferUnlockFeeSet(oldTransferUnlockFee, transferUnlockFee_);
42     }
43 
44     function SetAllowTokenOwnerVariantSelection(bool allowed) external onlyOwner {
45         require(allowTokenOwnerVariantSelection != allowed);
46         allowTokenOwnerVariantSelection = allowed;
47     }
48 
49 These functions will be passed to DAO governance once the ecosystem stabilizes.
50 
51 */
52 
53 abstract contract Ownable {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     constructor(address owner_) {
59         _transferOwnership(owner_);
60     }
61 
62     modifier onlyOwner() {
63         _checkOwner();
64         _;
65     }
66 
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     function _checkOwner() internal view virtual {
72         require(owner() == msg.sender, "Ownable: caller is not the owner");
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         _transferOwnership(address(0));
77     }
78 
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _transferOwnership(newOwner);
82     }
83 
84     function _transferOwnership(address newOwner) internal virtual {
85         address oldOwner = _owner;
86         _owner = newOwner;
87         emit OwnershipTransferred(oldOwner, newOwner);
88     }
89 }
90 
91 abstract contract ReentrancyGuard {
92     uint256 private constant _NOT_ENTERED = 1;
93     uint256 private constant _ENTERED = 2;
94 
95     uint256 private _status;
96 
97     constructor() {
98         _status = _NOT_ENTERED;
99     }
100 
101     modifier nonReentrant() {
102         _nonReentrantBefore();
103         _;
104         _nonReentrantAfter();
105     }
106 
107     function _nonReentrantBefore() private {
108         // On the first call to nonReentrant, _status will be _NOT_ENTERED
109         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
110 
111         // Any calls to nonReentrant after this point will fail
112         _status = _ENTERED;
113     }
114 
115     function _nonReentrantAfter() private {
116         // By storing the original value once again, a refund is triggered (see
117         // https://eips.ethereum.org/EIPS/eip-2200)
118         _status = _NOT_ENTERED;
119     }
120 
121     function _reentrancyGuardEntered() internal view returns (bool) {
122         return _status == _ENTERED;
123     }
124 }
125 
126 /**
127  * @title ERC721 token receiver interface
128  * @dev Interface for any contract that wants to support safeTransfers
129  * from ERC721 asset contracts.
130  */
131 interface IERC721Receiver {
132     /**
133      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
134      * by `operator` from `from`, this function is called.
135      *
136      * It must return its Solidity selector to confirm the token transfer.
137      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
138      *
139      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
140      */
141     function onERC721Received(
142         address operator,
143         address from,
144         uint256 tokenId,
145         bytes calldata data
146     ) external returns (bytes4);
147 }
148 
149 /**
150  * @dev Interface of the ERC165 standard, as defined in the
151  * https://eips.ethereum.org/EIPS/eip-165[EIP].
152  *
153  * Implementers can declare support of contract interfaces, which can then be
154  * queried by others ({ERC165Checker}).
155  *
156  * For an implementation, see {ERC165}.
157  */
158 interface IERC165 {
159     /**
160      * @dev Returns true if this contract implements the interface defined by
161      * `interfaceId`. See the corresponding
162      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
163      * to learn more about how these ids are created.
164      *
165      * This function call must use less than 30 000 gas.
166      */
167     function supportsInterface(bytes4 interfaceId) external view returns (bool);
168 }
169 
170 /**
171  * @dev Required interface of an ERC721 compliant contract.
172  */
173 interface IERC721 is IERC165 {
174     /**
175      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
178 
179     /**
180      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
181      */
182     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
183 
184     /**
185      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
186      */
187     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
188 
189     /**
190      * @dev Returns the number of tokens in ``owner``'s account.
191      */
192     function balanceOf(address owner) external view returns (uint256 balance);
193 
194     /**
195      * @dev Returns the owner of the `tokenId` token.
196      *
197      * Requirements:
198      *
199      * - `tokenId` must exist.
200      */
201     function ownerOf(uint256 tokenId) external view returns (address owner);
202 
203     /**
204      * @dev Safely transfers `tokenId` token from `from` to `to`.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must exist and be owned by `from`.
211      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId,
220         bytes calldata data
221     ) external;
222 
223     /**
224      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
225      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must exist and be owned by `from`.
232      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
233      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
234      *
235      * Emits a {Transfer} event.
236      */
237     function safeTransferFrom(
238         address from,
239         address to,
240         uint256 tokenId
241     ) external;
242 
243     /**
244      * @dev Transfers `tokenId` token from `from` to `to`.
245      *
246      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transferFrom(
258         address from,
259         address to,
260         uint256 tokenId
261     ) external;
262 
263     /**
264      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
265      * The approval is cleared when the token is transferred.
266      *
267      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
268      *
269      * Requirements:
270      *
271      * - The caller must own the token or be an approved operator.
272      * - `tokenId` must exist.
273      *
274      * Emits an {Approval} event.
275      */
276     function approve(address to, uint256 tokenId) external;
277 
278     /**
279      * @dev Approve or remove `operator` as an operator for the caller.
280      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
281      *
282      * Requirements:
283      *
284      * - The `operator` cannot be the caller.
285      *
286      * Emits an {ApprovalForAll} event.
287      */
288     function setApprovalForAll(address operator, bool _approved) external;
289 
290     /**
291      * @dev Returns the account approved for `tokenId` token.
292      *
293      * Requirements:
294      *
295      * - `tokenId` must exist.
296      */
297     function getApproved(uint256 tokenId) external view returns (address operator);
298 
299     /**
300      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
301      *
302      * See {setApprovalForAll}
303      */
304     function isApprovedForAll(address owner, address operator) external view returns (bool);
305 }
306 
307 /**
308  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
309  * @dev See https://eips.ethereum.org/EIPS/eip-721
310  */
311 interface IERC721Metadata is IERC721 {
312     /**
313      * @dev Returns the token collection name.
314      */
315     function name() external view returns (string memory);
316 
317     /**
318      * @dev Returns the token collection symbol.
319      */
320     function symbol() external view returns (string memory);
321 
322     /**
323      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
324      */
325     function tokenURI(uint256 tokenId) external view returns (string memory);
326 }
327 
328 /**
329  * @dev Collection of functions related to the address type
330  */
331 library Address {
332     /**
333      * @dev Returns true if `account` is a contract.
334      *
335      * [IMPORTANT]
336      * ====
337      * It is unsafe to assume that an address for which this function returns
338      * false is an externally-owned account (EOA) and not a contract.
339      *
340      * Among others, `isContract` will return false for the following
341      * types of addresses:
342      *
343      *  - an externally-owned account
344      *  - a contract in construction
345      *  - an address where a contract will be created
346      *  - an address where a contract lived, but was destroyed
347      * ====
348      *
349      * [IMPORTANT]
350      * ====
351      * You shouldn't rely on `isContract` to protect against flash loan attacks!
352      *
353      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
354      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
355      * constructor.
356      * ====
357      */
358     function isContract(address account) internal view returns (bool) {
359         // This method relies on extcodesize/address.code.length, which returns 0
360         // for contracts in construction, since the code is only stored at the end
361         // of the constructor execution.
362 
363         return account.code.length > 0;
364     }
365 
366     /**
367      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
368      * `recipient`, forwarding all available gas and reverting on errors.
369      *
370      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
371      * of certain opcodes, possibly making contracts go over the 2300 gas limit
372      * imposed by `transfer`, making them unable to receive funds via
373      * `transfer`. {sendValue} removes this limitation.
374      *
375      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
376      *
377      * IMPORTANT: because control is transferred to `recipient`, care must be
378      * taken to not create reentrancy vulnerabilities. Consider using
379      * {ReentrancyGuard} or the
380      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
381      */
382     function sendValue(address payable recipient, uint256 amount) internal {
383         require(address(this).balance >= amount, "Address: insufficient balance");
384 
385         (bool success, ) = recipient.call{value: amount}("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain `call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408         return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, 0, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but also transferring `value` wei to `target`.
428      *
429      * Requirements:
430      *
431      * - the calling contract must have an ETH balance of at least `value`.
432      * - the called Solidity function must be `payable`.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value
440     ) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446      * with `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(
451         address target,
452         bytes memory data,
453         uint256 value,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         require(address(this).balance >= value, "Address: insufficient balance for call");
457         require(isContract(target), "Address: call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.call{value: value}(data);
460         return verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a static call.
466      *
467      * _Available since v3.3._
468      */
469     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
470         return functionStaticCall(target, data, "Address: low-level static call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a static call.
476      *
477      * _Available since v3.3._
478      */
479     function functionStaticCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal view returns (bytes memory) {
484         require(isContract(target), "Address: static call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.staticcall(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a delegate call.
503      *
504      * _Available since v3.4._
505      */
506     function functionDelegateCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(isContract(target), "Address: delegate call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.delegatecall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
519      * revert reason using the provided one.
520      *
521      * _Available since v4.3._
522      */
523     function verifyCallResult(
524         bool success,
525         bytes memory returndata,
526         string memory errorMessage
527     ) internal pure returns (bytes memory) {
528         if (success) {
529             return returndata;
530         } else {
531             // Look for revert reason and bubble it up if present
532             if (returndata.length > 0) {
533                 // The easiest way to bubble the revert reason is using memory via assembly
534                 /// @solidity memory-safe-assembly
535                 assembly {
536                     let returndata_size := mload(returndata)
537                     revert(add(32, returndata), returndata_size)
538                 }
539             } else {
540                 revert(errorMessage);
541             }
542         }
543     }
544 }
545 
546 /**
547  * @dev Provides information about the current execution context, including the
548  * sender of the transaction and its data. While these are generally available
549  * via msg.sender and msg.data, they should not be accessed in such a direct
550  * manner, since when dealing with meta-transactions the account sending and
551  * paying for execution may not be the actual sender (as far as an application
552  * is concerned).
553  *
554  * This contract is only required for intermediate, library-like contracts.
555  */
556 abstract contract Context {
557     function _msgSender() internal view virtual returns (address) {
558         return msg.sender;
559     }
560 
561     function _msgData() internal view virtual returns (bytes calldata) {
562         return msg.data;
563     }
564 }
565 
566 /**
567  * @dev String operations.
568  */
569 library Strings {
570     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
571     uint8 private constant _ADDRESS_LENGTH = 20;
572 
573     /**
574      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
575      */
576     function toString(uint256 value) internal pure returns (string memory) {
577         // Inspired by OraclizeAPI's implementation - MIT licence
578         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
579 
580         if (value == 0) {
581             return "0";
582         }
583         uint256 temp = value;
584         uint256 digits;
585         while (temp != 0) {
586             digits++;
587             temp /= 10;
588         }
589         bytes memory buffer = new bytes(digits);
590         while (value != 0) {
591             digits -= 1;
592             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
593             value /= 10;
594         }
595         return string(buffer);
596     }
597 
598     /**
599      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
600      */
601     function toHexString(uint256 value) internal pure returns (string memory) {
602         if (value == 0) {
603             return "0x00";
604         }
605         uint256 temp = value;
606         uint256 length = 0;
607         while (temp != 0) {
608             length++;
609             temp >>= 8;
610         }
611         return toHexString(value, length);
612     }
613 
614     /**
615      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
616      */
617     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
618         bytes memory buffer = new bytes(2 * length + 2);
619         buffer[0] = "0";
620         buffer[1] = "x";
621         for (uint256 i = 2 * length + 1; i > 1; --i) {
622             buffer[i] = _HEX_SYMBOLS[value & 0xf];
623             value >>= 4;
624         }
625         require(value == 0, "Strings: hex length insufficient");
626         return string(buffer);
627     }
628 
629     /**
630      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
631      */
632     function toHexString(address addr) internal pure returns (string memory) {
633         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
634     }
635 }
636 
637 /**
638  * @dev Implementation of the {IERC165} interface.
639  *
640  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
641  * for the additional interface id that will be supported. For example:
642  *
643  * ```solidity
644  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
645  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
646  * }
647  * ```
648  *
649  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
650  */
651 abstract contract ERC165 is IERC165 {
652     /**
653      * @dev See {IERC165-supportsInterface}.
654      */
655     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
656         return interfaceId == type(IERC165).interfaceId;
657     }
658 }
659 
660 /**
661  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
662  * the Metadata extension, but not including the Enumerable extension, which is available separately as
663  * {ERC721Enumerable}.
664  */
665 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
666     using Address for address;
667     using Strings for uint256;
668 
669     // Token name
670     string private _name;
671 
672     // Token symbol
673     string private _symbol;
674 
675     // Mapping from token ID to owner address
676     mapping(uint256 => address) private _owners;
677 
678     // Mapping owner address to token count
679     mapping(address => uint256) private _balances;
680 
681     // Mapping from token ID to approved address
682     mapping(uint256 => address) private _tokenApprovals;
683 
684     // Mapping from owner to operator approvals
685     mapping(address => mapping(address => bool)) private _operatorApprovals;
686 
687     /**
688      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
689      */
690     constructor(string memory name_, string memory symbol_) {
691         _name = name_;
692         _symbol = symbol_;
693     }
694 
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
699         return
700         interfaceId == type(IERC721).interfaceId ||
701         interfaceId == type(IERC721Metadata).interfaceId ||
702         super.supportsInterface(interfaceId);
703     }
704 
705     /**
706      * @dev See {IERC721-balanceOf}.
707      */
708     function balanceOf(address owner) public view virtual override returns (uint256) {
709         require(owner != address(0), "ERC721: address zero is not a valid owner");
710         return _balances[owner];
711     }
712 
713     /**
714      * @dev See {IERC721-ownerOf}.
715      */
716     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
717         address owner = _owners[tokenId];
718         require(owner != address(0), "ERC721: invalid token ID");
719         return owner;
720     }
721 
722     /**
723      * @dev See {IERC721Metadata-name}.
724      */
725     function name() public view virtual override returns (string memory) {
726         return _name;
727     }
728 
729     /**
730      * @dev See {IERC721Metadata-symbol}.
731      */
732     function symbol() public view virtual override returns (string memory) {
733         return _symbol;
734     }
735 
736     /**
737      * @dev See {IERC721Metadata-tokenURI}.
738      */
739     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
740         _requireMinted(tokenId);
741 
742         string memory baseURI = _baseURI();
743         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
744     }
745 
746     /**
747      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
748      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
749      * by default, can be overridden in child contracts.
750      */
751     function _baseURI() internal view virtual returns (string memory) {
752         return "";
753     }
754 
755     /**
756      * @dev See {IERC721-approve}.
757      */
758     function approve(address to, uint256 tokenId) public virtual override {
759         address owner = ERC721.ownerOf(tokenId);
760         require(to != owner, "ERC721: approval to current owner");
761 
762         require(
763             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
764             "ERC721: approve caller is not token owner nor approved for all"
765         );
766 
767         _approve(to, tokenId);
768     }
769 
770     /**
771      * @dev See {IERC721-getApproved}.
772      */
773     function getApproved(uint256 tokenId) public view virtual override returns (address) {
774         _requireMinted(tokenId);
775 
776         return _tokenApprovals[tokenId];
777     }
778 
779     /**
780      * @dev See {IERC721-setApprovalForAll}.
781      */
782     function setApprovalForAll(address operator, bool approved) public virtual override {
783         _setApprovalForAll(_msgSender(), operator, approved);
784     }
785 
786     /**
787      * @dev See {IERC721-isApprovedForAll}.
788      */
789     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
790         return _operatorApprovals[owner][operator];
791     }
792 
793     /**
794      * @dev See {IERC721-transferFrom}.
795      */
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) public virtual override {
801         //solhint-disable-next-line max-line-length
802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
803 
804         _transfer(from, to, tokenId);
805     }
806 
807     /**
808      * @dev See {IERC721-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public virtual override {
815         safeTransferFrom(from, to, tokenId, "");
816     }
817 
818     /**
819      * @dev See {IERC721-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId,
825         bytes memory data
826     ) public virtual override {
827         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
828         _safeTransfer(from, to, tokenId, data);
829     }
830 
831     /**
832      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
833      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
834      *
835      * `data` is additional data, it has no specified format and it is sent in call to `to`.
836      *
837      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
838      * implement alternative mechanisms to perform token transfer, such as signature-based.
839      *
840      * Requirements:
841      *
842      * - `from` cannot be the zero address.
843      * - `to` cannot be the zero address.
844      * - `tokenId` token must exist and be owned by `from`.
845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _safeTransfer(
850         address from,
851         address to,
852         uint256 tokenId,
853         bytes memory data
854     ) internal virtual {
855         _transfer(from, to, tokenId);
856         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
857     }
858 
859     /**
860      * @dev Returns whether `tokenId` exists.
861      *
862      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
863      *
864      * Tokens start existing when they are minted (`_mint`),
865      * and stop existing when they are burned (`_burn`).
866      */
867     function _exists(uint256 tokenId) internal view virtual returns (bool) {
868         return _owners[tokenId] != address(0);
869     }
870 
871     /**
872      * @dev Returns whether `spender` is allowed to manage `tokenId`.
873      *
874      * Requirements:
875      *
876      * - `tokenId` must exist.
877      */
878     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
879         address owner = ERC721.ownerOf(tokenId);
880         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
881     }
882 
883     /**
884      * @dev Safely mints `tokenId` and transfers it to `to`.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must not exist.
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _safeMint(address to, uint256 tokenId) internal virtual {
894         _safeMint(to, tokenId, "");
895     }
896 
897     /**
898      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
899      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
900      */
901     function _safeMint(
902         address to,
903         uint256 tokenId,
904         bytes memory data
905     ) internal virtual {
906         _mint(to, tokenId);
907         require(
908             _checkOnERC721Received(address(0), to, tokenId, data),
909             "ERC721: transfer to non ERC721Receiver implementer"
910         );
911     }
912 
913     /**
914      * @dev Mints `tokenId` and transfers it to `to`.
915      *
916      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
917      *
918      * Requirements:
919      *
920      * - `tokenId` must not exist.
921      * - `to` cannot be the zero address.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _mint(address to, uint256 tokenId) internal virtual {
926         require(to != address(0), "ERC721: mint to the zero address");
927         require(!_exists(tokenId), "ERC721: token already minted");
928 
929         _beforeTokenTransfer(address(0), to, tokenId);
930 
931         _balances[to] += 1;
932         _owners[tokenId] = to;
933 
934         emit Transfer(address(0), to, tokenId);
935 
936         _afterTokenTransfer(address(0), to, tokenId);
937     }
938 
939     /**
940      * @dev Destroys `tokenId`.
941      * The approval is cleared when the token is burned.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _burn(uint256 tokenId) internal virtual {
950         address owner = ERC721.ownerOf(tokenId);
951 
952         _beforeTokenTransfer(owner, address(0), tokenId);
953 
954         // Clear approvals
955         _approve(address(0), tokenId);
956 
957         _balances[owner] -= 1;
958         delete _owners[tokenId];
959 
960         emit Transfer(owner, address(0), tokenId);
961 
962         _afterTokenTransfer(owner, address(0), tokenId);
963     }
964 
965     /**
966      * @dev Transfers `tokenId` from `from` to `to`.
967      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
968      *
969      * Requirements:
970      *
971      * - `to` cannot be the zero address.
972      * - `tokenId` token must be owned by `from`.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _transfer(
977         address from,
978         address to,
979         uint256 tokenId
980     ) internal virtual {
981         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
982         require(to != address(0), "ERC721: transfer to the zero address");
983 
984         _beforeTokenTransfer(from, to, tokenId);
985 
986         // Clear approvals from the previous owner
987         _approve(address(0), tokenId);
988 
989         _balances[from] -= 1;
990         _balances[to] += 1;
991         _owners[tokenId] = to;
992 
993         emit Transfer(from, to, tokenId);
994 
995         _afterTokenTransfer(from, to, tokenId);
996     }
997 
998     /**
999      * @dev Approve `to` to operate on `tokenId`
1000      *
1001      * Emits an {Approval} event.
1002      */
1003     function _approve(address to, uint256 tokenId) internal virtual {
1004         _tokenApprovals[tokenId] = to;
1005         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev Approve `operator` to operate on all of `owner` tokens
1010      *
1011      * Emits an {ApprovalForAll} event.
1012      */
1013     function _setApprovalForAll(
1014         address owner,
1015         address operator,
1016         bool approved
1017     ) internal virtual {
1018         require(owner != operator, "ERC721: approve to caller");
1019         _operatorApprovals[owner][operator] = approved;
1020         emit ApprovalForAll(owner, operator, approved);
1021     }
1022 
1023     /**
1024      * @dev Reverts if the `tokenId` has not been minted yet.
1025      */
1026     function _requireMinted(uint256 tokenId) internal view virtual {
1027         require(_exists(tokenId), "ERC721: invalid token ID");
1028     }
1029 
1030     /**
1031      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1032      * The call is not executed if the target address is not a contract.
1033      *
1034      * @param from address representing the previous owner of the given token ID
1035      * @param to target address that will receive the tokens
1036      * @param tokenId uint256 ID of the token to be transferred
1037      * @param data bytes optional data to send along with the call
1038      * @return bool whether the call correctly returned the expected magic value
1039      */
1040     function _checkOnERC721Received(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes memory data
1045     ) private returns (bool) {
1046         if (to.isContract()) {
1047             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1048                 return retval == IERC721Receiver.onERC721Received.selector;
1049             } catch (bytes memory reason) {
1050                 if (reason.length == 0) {
1051                     revert("ERC721: transfer to non ERC721Receiver implementer");
1052                 } else {
1053                     /// @solidity memory-safe-assembly
1054                     assembly {
1055                         revert(add(32, reason), mload(reason))
1056                     }
1057                 }
1058             }
1059         } else {
1060             return true;
1061         }
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1074      * - `from` and `to` are never both zero.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual {}
1083 
1084     /**
1085      * @dev Hook that is called after any transfer of tokens. This includes
1086      * minting and burning.
1087      *
1088      * Calling conditions:
1089      *
1090      * - when `from` and `to` are both non-zero.
1091      * - `from` and `to` are never both zero.
1092      *
1093      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1094      */
1095     function _afterTokenTransfer(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) internal virtual {}
1100 }
1101 
1102 /**
1103  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1104  * @dev See https://eips.ethereum.org/EIPS/eip-721
1105  */
1106 interface IERC721Enumerable is IERC721 {
1107     /**
1108      * @dev Returns the total amount of tokens stored by the contract.
1109      */
1110     function totalSupply() external view returns (uint256);
1111 
1112     /**
1113      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1114      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1115      */
1116     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1117 
1118     /**
1119      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1120      * Use along with {totalSupply} to enumerate all tokens.
1121      */
1122     function tokenByIndex(uint256 index) external view returns (uint256);
1123 }
1124 
1125 /**
1126  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1127  * enumerability of all the token ids in the contract as well as all token ids owned by each
1128  * account.
1129  */
1130 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1131     // Mapping from owner to list of owned token IDs
1132     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1133 
1134     // Mapping from token ID to index of the owner tokens list
1135     mapping(uint256 => uint256) private _ownedTokensIndex;
1136 
1137     // Array with all token ids, used for enumeration
1138     uint256[] private _allTokens;
1139 
1140     // Mapping from token id to position in the allTokens array
1141     mapping(uint256 => uint256) private _allTokensIndex;
1142 
1143     /**
1144      * @dev See {IERC165-supportsInterface}.
1145      */
1146     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1147         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1152      */
1153     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1154         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1155         return _ownedTokens[owner][index];
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Enumerable-totalSupply}.
1160      */
1161     function totalSupply() public view virtual override returns (uint256) {
1162         return _allTokens.length;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Enumerable-tokenByIndex}.
1167      */
1168     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1169         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1170         return _allTokens[index];
1171     }
1172 
1173     /**
1174      * @dev Hook that is called before any token transfer. This includes minting
1175      * and burning.
1176      *
1177      * Calling conditions:
1178      *
1179      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1180      * transferred to `to`.
1181      * - When `from` is zero, `tokenId` will be minted for `to`.
1182      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1183      * - `from` cannot be the zero address.
1184      * - `to` cannot be the zero address.
1185      *
1186      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1187      */
1188     function _beforeTokenTransfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) internal virtual override {
1193         super._beforeTokenTransfer(from, to, tokenId);
1194 
1195         if (from == address(0)) {
1196             _addTokenToAllTokensEnumeration(tokenId);
1197         } else if (from != to) {
1198             _removeTokenFromOwnerEnumeration(from, tokenId);
1199         }
1200         if (to == address(0)) {
1201             _removeTokenFromAllTokensEnumeration(tokenId);
1202         } else if (to != from) {
1203             _addTokenToOwnerEnumeration(to, tokenId);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1209      * @param to address representing the new owner of the given token ID
1210      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1211      */
1212     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1213         uint256 length = ERC721.balanceOf(to);
1214         _ownedTokens[to][length] = tokenId;
1215         _ownedTokensIndex[tokenId] = length;
1216     }
1217 
1218     /**
1219      * @dev Private function to add a token to this extension's token tracking data structures.
1220      * @param tokenId uint256 ID of the token to be added to the tokens list
1221      */
1222     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1223         _allTokensIndex[tokenId] = _allTokens.length;
1224         _allTokens.push(tokenId);
1225     }
1226 
1227     /**
1228      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1229      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1230      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1231      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1232      * @param from address representing the previous owner of the given token ID
1233      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1234      */
1235     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1236         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1237         // then delete the last slot (swap and pop).
1238 
1239         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1240         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1241 
1242         // When the token to delete is the last token, the swap operation is unnecessary
1243         if (tokenIndex != lastTokenIndex) {
1244             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1245 
1246             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1247             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1248         }
1249 
1250         // This also deletes the contents at the last position of the array
1251         delete _ownedTokensIndex[tokenId];
1252         delete _ownedTokens[from][lastTokenIndex];
1253     }
1254 
1255     /**
1256      * @dev Private function to remove a token from this extension's token tracking data structures.
1257      * This has O(1) time complexity, but alters the order of the _allTokens array.
1258      * @param tokenId uint256 ID of the token to be removed from the tokens list
1259      */
1260     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1261         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1262         // then delete the last slot (swap and pop).
1263 
1264         uint256 lastTokenIndex = _allTokens.length - 1;
1265         uint256 tokenIndex = _allTokensIndex[tokenId];
1266 
1267         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1268         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1269         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1270         uint256 lastTokenId = _allTokens[lastTokenIndex];
1271 
1272         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1273         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1274 
1275         // This also deletes the contents at the last position of the array
1276         delete _allTokensIndex[tokenId];
1277         _allTokens.pop();
1278     }
1279 }
1280 
1281 /**
1282  * @dev Implementation of the {IERC721Receiver} interface.
1283  *
1284  * Accepts all token transfers.
1285  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
1286  */
1287 contract ERC721Holder is IERC721Receiver {
1288     /**
1289      * @dev See {IERC721Receiver-onERC721Received}.
1290      *
1291      * Always returns `IERC721Receiver.onERC721Received.selector`.
1292      */
1293     function onERC721Received(
1294         address,
1295         address,
1296         uint256,
1297         bytes memory
1298     ) public virtual override returns (bytes4) {
1299         return this.onERC721Received.selector;
1300     }
1301 }
1302 
1303 contract X7Pioneer is ERC721Enumerable, ERC721Holder, Ownable, ReentrancyGuard {
1304 
1305     enum Variant {
1306         NOT_SELECTED,
1307         SELECTION1,
1308         SELECTION2,
1309         SELECTION3,
1310         SELECTION4,
1311         SELECTION5,
1312         SELECTION6,
1313         SELECTION7
1314     }
1315 
1316     address payable public transferUnlockFeeDestination;
1317     string public _internalBaseURI;
1318 
1319     mapping(uint256 => bool) public transferUnlocked;
1320 
1321     uint256 public lastETHBalance;
1322     uint256 public totalRewards;
1323 
1324     // token ID => claimed rewards
1325     mapping(uint256 => uint256) public rewardsClaimed;
1326 
1327     // 0.07 ETH
1328     uint256 public transferUnlockFee = 7 * 10**16;
1329 
1330     bool public airdropActive = true;
1331     mapping(address => bool) public receivedAirdrop;
1332 
1333     bool public allowTokenOwnerVariantSelection = true;
1334 
1335     // tokenId => Variant
1336     mapping(uint256 => Variant) public selectedVariantIndex;
1337 
1338     event TransferUnlockFeeDestinationSet(address indexed oldDestination, address indexed newDestination);
1339     event TransferUnlockFeeSet(uint256 oldPrice, uint256 newPrice);
1340 
1341     event BaseURISet(string oldURI, string newURI);
1342     event TransferUnlocked(uint256 indexed tokenId);
1343 
1344     event RewardsClaimed(uint256 indexed tokenId, address indexed receipient, uint256 amount);
1345 
1346     event AirdropDisabled();
1347     event VariantSelected(uint256 indexed tokenId, Variant variantIndex);
1348 
1349     constructor(address transferUnlockFeeDestination_) ERC721("X7 Pioneer", "X7PIONEER") Ownable(msg.sender) {
1350         transferUnlockFeeDestination = payable(transferUnlockFeeDestination_);
1351     }
1352 
1353     receive () external payable {}
1354 
1355     function setTransferUnlockFeeDestination(address transferUnlockFeeDestination_) external onlyOwner {
1356         require(transferUnlockFeeDestination != transferUnlockFeeDestination_);
1357         address oldTransferUnlockFeeDestination = transferUnlockFeeDestination;
1358         transferUnlockFeeDestination = payable(transferUnlockFeeDestination_);
1359         emit TransferUnlockFeeDestinationSet(oldTransferUnlockFeeDestination, transferUnlockFeeDestination_);
1360     }
1361 
1362     function setBaseURI(string memory baseURI_) external onlyOwner {
1363         require(keccak256(abi.encodePacked(_internalBaseURI)) != keccak256(abi.encodePacked(baseURI_)));
1364         string memory oldBaseURI = _internalBaseURI;
1365         _internalBaseURI = baseURI_;
1366         emit BaseURISet(oldBaseURI, baseURI_);
1367     }
1368 
1369     function setTransferUnlockFee(uint256 transferUnlockFee_) external onlyOwner {
1370         require(transferUnlockFee_ != transferUnlockFee);
1371         uint256 oldTransferUnlockFee = transferUnlockFee;
1372         transferUnlockFee = transferUnlockFee_;
1373         emit TransferUnlockFeeSet(oldTransferUnlockFee, transferUnlockFee_);
1374     }
1375 
1376     function SetAllowTokenOwnerVariantSelection(bool allowed) external onlyOwner {
1377         require(allowTokenOwnerVariantSelection != allowed);
1378         allowTokenOwnerVariantSelection = allowed;
1379     }
1380 
1381     function airdropTokens(address[] memory recipients) external onlyOwner {
1382         require(airdropActive);
1383         for (uint i=0; i < recipients.length; i++) {
1384             if (!receivedAirdrop[recipients[i]]) {
1385                 uint256 nextTokenId = ERC721Enumerable.totalSupply();
1386                 super._mint(recipients[i], nextTokenId + i);
1387             }
1388         }
1389     }
1390 
1391     function disableAirDrop() external onlyOwner {
1392         require(airdropActive);
1393         airdropActive = false;
1394         emit AirdropDisabled();
1395     }
1396 
1397     function unlockTransfer(uint256 tokenId) external payable {
1398         require(!transferUnlocked[tokenId]);
1399         require(ownerOf(tokenId) == msg.sender);
1400         require(msg.value == transferUnlockFee);
1401         (bool ok, ) = transferUnlockFeeDestination.call{value: msg.value}("");
1402         require(ok);
1403         transferUnlocked[tokenId] = true;
1404         emit TransferUnlocked(tokenId);
1405     }
1406 
1407     function claimRewards(uint256[] memory tokenIds) public nonReentrant {
1408         if (lastETHBalance < address(this).balance) {
1409             totalRewards += (address(this).balance - lastETHBalance);
1410         }
1411 
1412         uint256 claimable;
1413         uint256 tokenClaimable;
1414 
1415         for (uint i=0; i < tokenIds.length; i++) {
1416             require(ownerOf(tokenIds[i]) == msg.sender);
1417             uint256 tokenTotalRewards = totalRewards / totalSupply();
1418             uint256 tokenClaimedRewards = rewardsClaimed[tokenIds[i]];
1419             if (tokenClaimedRewards < tokenTotalRewards) {
1420                 rewardsClaimed[tokenIds[i]] = tokenTotalRewards;
1421                 tokenClaimable = tokenTotalRewards - tokenClaimedRewards;
1422                 claimable += tokenClaimable;
1423                 emit RewardsClaimed(tokenIds[i], msg.sender, tokenClaimable);
1424             }
1425         }
1426 
1427         if (claimable > 0) {
1428             lastETHBalance = address(this).balance - claimable;
1429             (bool ok, ) = msg.sender.call{value: claimable}("");
1430             require(ok);
1431         }
1432     }
1433 
1434     function unclaimedRewards(uint256 tokenId) public view returns (uint256) {
1435         uint256 totalRewards_ = totalRewards;
1436         if (lastETHBalance < address(this).balance) {
1437             totalRewards_ += (address(this).balance - lastETHBalance);
1438         }
1439         return (totalRewards / totalSupply()) - rewardsClaimed[tokenId];
1440     }
1441 
1442     function unclaimedRewards(uint[] memory tokenIds) public view returns (uint256) {
1443         uint256 totalRewards_ = totalRewards;
1444         if (lastETHBalance < address(this).balance) {
1445             totalRewards_ += (address(this).balance - lastETHBalance);
1446         }
1447 
1448         uint256 claimable;
1449         uint256 tokenClaimable;
1450 
1451         for (uint i=0; i < tokenIds.length; i++) {
1452             require(ownerOf(tokenIds[i]) == msg.sender);
1453             uint256 tokenTotalRewards = totalRewards / totalSupply();
1454             uint256 tokenClaimedRewards = rewardsClaimed[tokenIds[i]];
1455             if (tokenClaimedRewards < tokenTotalRewards) {
1456                 tokenClaimable = tokenTotalRewards - tokenClaimedRewards;
1457                 claimable += tokenClaimable;
1458             }
1459         }
1460 
1461         return claimable;
1462     }
1463 
1464     function selectVariant(uint256 tokenId, Variant variant) external {
1465         require(allowTokenOwnerVariantSelection);
1466         require(ownerOf(tokenId) == msg.sender);
1467         require(variant != Variant.NOT_SELECTED);
1468         require(variant != selectedVariantIndex[tokenId]);
1469         selectedVariantIndex[tokenId] = variant;
1470         emit VariantSelected(tokenId, variant);
1471     }
1472 
1473     function _beforeTokenTransfer(
1474         address from,
1475         address to,
1476         uint256 tokenId
1477     ) internal override {
1478         require(transferUnlocked[tokenId] || msg.sender == owner());
1479         super._beforeTokenTransfer(from, to, tokenId);
1480 
1481     }
1482     function _baseURI() internal view override returns (string memory) {
1483         return _internalBaseURI;
1484     }
1485 }