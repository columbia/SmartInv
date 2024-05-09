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
15 Contract: ERC-721 Token "X7 Ecosystem Maxi" NFT
16 
17 A utility NFT offering fee discounts across the X7 ecosystem.
18 
19 This contract will NOT be renounced.
20 
21 The following are the only functions that can be called on the contract that affect the contract:
22 
23     function setMintFeeDestination(address mintFeeDestination_) external onlyOwner {
24         require(mintFeeDestination != mintFeeDestination_);
25         address oldMintFeeDestination = mintFeeDestination;
26         mintFeeDestination = mintFeeDestination_;
27         emit MintFeeDestinationSet(oldMintFeeDestination, mintFeeDestination_);
28     }
29 
30     function setBaseURI(string memory baseURI_) external onlyOwner {
31         require(keccak256(abi.encodePacked(_internalBaseURI)) != keccak256(abi.encodePacked(baseURI_)));
32         string memory oldBaseURI = _internalBaseURI;
33         _internalBaseURI = baseURI_;
34         emit BaseURISet(oldBaseURI, baseURI_);
35     }
36 
37     function setMintPrice(uint256 mintPrice_) external onlyOwner {
38         require(mintPrice_ > mintPrice);
39         uint256 oldPrice = mintPrice;
40         mintPrice = mintPrice_;
41         emit MintPriceSet(oldPrice, mintPrice_);
42     }
43 
44 These functions will be passed to DAO governance once the ecosystem stabilizes.
45 
46 */
47 
48 abstract contract Ownable {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     constructor(address owner_) {
54         _transferOwnership(owner_);
55     }
56 
57     modifier onlyOwner() {
58         _checkOwner();
59         _;
60     }
61 
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     function _checkOwner() internal view virtual {
67         require(owner() == msg.sender, "Ownable: caller is not the owner");
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         _transferOwnership(newOwner);
77     }
78 
79     function _transferOwnership(address newOwner) internal virtual {
80         address oldOwner = _owner;
81         _owner = newOwner;
82         emit OwnershipTransferred(oldOwner, newOwner);
83     }
84 }
85 
86 /**
87  * @title ERC721 token receiver interface
88  * @dev Interface for any contract that wants to support safeTransfers
89  * from ERC721 asset contracts.
90  */
91 interface IERC721Receiver {
92     /**
93      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
94      * by `operator` from `from`, this function is called.
95      *
96      * It must return its Solidity selector to confirm the token transfer.
97      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
98      *
99      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
100      */
101     function onERC721Received(
102         address operator,
103         address from,
104         uint256 tokenId,
105         bytes calldata data
106     ) external returns (bytes4);
107 }
108 
109 /**
110  * @dev Interface of the ERC165 standard, as defined in the
111  * https://eips.ethereum.org/EIPS/eip-165[EIP].
112  *
113  * Implementers can declare support of contract interfaces, which can then be
114  * queried by others ({ERC165Checker}).
115  *
116  * For an implementation, see {ERC165}.
117  */
118 interface IERC165 {
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30 000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 }
129 
130 /**
131  * @dev Required interface of an ERC721 compliant contract.
132  */
133 interface IERC721 is IERC165 {
134     /**
135      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
136      */
137     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
138 
139     /**
140      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
141      */
142     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
146      */
147     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
148 
149     /**
150      * @dev Returns the number of tokens in ``owner``'s account.
151      */
152     function balanceOf(address owner) external view returns (uint256 balance);
153 
154     /**
155      * @dev Returns the owner of the `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function ownerOf(uint256 tokenId) external view returns (address owner);
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId,
180         bytes calldata data
181     ) external;
182 
183     /**
184      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
185      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must exist and be owned by `from`.
192      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
193      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
194      *
195      * Emits a {Transfer} event.
196      */
197     function safeTransferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external;
202 
203     /**
204      * @dev Transfers `tokenId` token from `from` to `to`.
205      *
206      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
207      *
208      * Requirements:
209      *
210      * - `from` cannot be the zero address.
211      * - `to` cannot be the zero address.
212      * - `tokenId` token must be owned by `from`.
213      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(
218         address from,
219         address to,
220         uint256 tokenId
221     ) external;
222 
223     /**
224      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
225      * The approval is cleared when the token is transferred.
226      *
227      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
228      *
229      * Requirements:
230      *
231      * - The caller must own the token or be an approved operator.
232      * - `tokenId` must exist.
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address to, uint256 tokenId) external;
237 
238     /**
239      * @dev Approve or remove `operator` as an operator for the caller.
240      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
241      *
242      * Requirements:
243      *
244      * - The `operator` cannot be the caller.
245      *
246      * Emits an {ApprovalForAll} event.
247      */
248     function setApprovalForAll(address operator, bool _approved) external;
249 
250     /**
251      * @dev Returns the account approved for `tokenId` token.
252      *
253      * Requirements:
254      *
255      * - `tokenId` must exist.
256      */
257     function getApproved(uint256 tokenId) external view returns (address operator);
258 
259     /**
260      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
261      *
262      * See {setApprovalForAll}
263      */
264     function isApprovedForAll(address owner, address operator) external view returns (bool);
265 }
266 
267 /**
268  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
269  * @dev See https://eips.ethereum.org/EIPS/eip-721
270  */
271 interface IERC721Metadata is IERC721 {
272     /**
273      * @dev Returns the token collection name.
274      */
275     function name() external view returns (string memory);
276 
277     /**
278      * @dev Returns the token collection symbol.
279      */
280     function symbol() external view returns (string memory);
281 
282     /**
283      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
284      */
285     function tokenURI(uint256 tokenId) external view returns (string memory);
286 }
287 
288 /**
289  * @dev Collection of functions related to the address type
290  */
291 library Address {
292     /**
293      * @dev Returns true if `account` is a contract.
294      *
295      * [IMPORTANT]
296      * ====
297      * It is unsafe to assume that an address for which this function returns
298      * false is an externally-owned account (EOA) and not a contract.
299      *
300      * Among others, `isContract` will return false for the following
301      * types of addresses:
302      *
303      *  - an externally-owned account
304      *  - a contract in construction
305      *  - an address where a contract will be created
306      *  - an address where a contract lived, but was destroyed
307      * ====
308      *
309      * [IMPORTANT]
310      * ====
311      * You shouldn't rely on `isContract` to protect against flash loan attacks!
312      *
313      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
314      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
315      * constructor.
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // This method relies on extcodesize/address.code.length, which returns 0
320         // for contracts in construction, since the code is only stored at the end
321         // of the constructor execution.
322 
323         return account.code.length > 0;
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         (bool success, ) = recipient.call{value: amount}("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain `call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(address(this).balance >= value, "Address: insufficient balance for call");
417         require(isContract(target), "Address: call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.call{value: value}(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal view returns (bytes memory) {
444         require(isContract(target), "Address: static call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         require(isContract(target), "Address: delegate call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.delegatecall(data);
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
479      * revert reason using the provided one.
480      *
481      * _Available since v4.3._
482      */
483     function verifyCallResult(
484         bool success,
485         bytes memory returndata,
486         string memory errorMessage
487     ) internal pure returns (bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             // Look for revert reason and bubble it up if present
492             if (returndata.length > 0) {
493                 // The easiest way to bubble the revert reason is using memory via assembly
494                 /// @solidity memory-safe-assembly
495                 assembly {
496                     let returndata_size := mload(returndata)
497                     revert(add(32, returndata), returndata_size)
498                 }
499             } else {
500                 revert(errorMessage);
501             }
502         }
503     }
504 }
505 
506 /**
507  * @dev Provides information about the current execution context, including the
508  * sender of the transaction and its data. While these are generally available
509  * via msg.sender and msg.data, they should not be accessed in such a direct
510  * manner, since when dealing with meta-transactions the account sending and
511  * paying for execution may not be the actual sender (as far as an application
512  * is concerned).
513  *
514  * This contract is only required for intermediate, library-like contracts.
515  */
516 abstract contract Context {
517     function _msgSender() internal view virtual returns (address) {
518         return msg.sender;
519     }
520 
521     function _msgData() internal view virtual returns (bytes calldata) {
522         return msg.data;
523     }
524 }
525 
526 /**
527  * @dev String operations.
528  */
529 library Strings {
530     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
531     uint8 private constant _ADDRESS_LENGTH = 20;
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
535      */
536     function toString(uint256 value) internal pure returns (string memory) {
537         // Inspired by OraclizeAPI's implementation - MIT licence
538         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
539 
540         if (value == 0) {
541             return "0";
542         }
543         uint256 temp = value;
544         uint256 digits;
545         while (temp != 0) {
546             digits++;
547             temp /= 10;
548         }
549         bytes memory buffer = new bytes(digits);
550         while (value != 0) {
551             digits -= 1;
552             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
553             value /= 10;
554         }
555         return string(buffer);
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
560      */
561     function toHexString(uint256 value) internal pure returns (string memory) {
562         if (value == 0) {
563             return "0x00";
564         }
565         uint256 temp = value;
566         uint256 length = 0;
567         while (temp != 0) {
568             length++;
569             temp >>= 8;
570         }
571         return toHexString(value, length);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
576      */
577     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
578         bytes memory buffer = new bytes(2 * length + 2);
579         buffer[0] = "0";
580         buffer[1] = "x";
581         for (uint256 i = 2 * length + 1; i > 1; --i) {
582             buffer[i] = _HEX_SYMBOLS[value & 0xf];
583             value >>= 4;
584         }
585         require(value == 0, "Strings: hex length insufficient");
586         return string(buffer);
587     }
588 
589     /**
590      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
591      */
592     function toHexString(address addr) internal pure returns (string memory) {
593         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
594     }
595 }
596 
597 /**
598  * @dev Implementation of the {IERC165} interface.
599  *
600  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
601  * for the additional interface id that will be supported. For example:
602  *
603  * ```solidity
604  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
605  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
606  * }
607  * ```
608  *
609  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
610  */
611 abstract contract ERC165 is IERC165 {
612     /**
613      * @dev See {IERC165-supportsInterface}.
614      */
615     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
616         return interfaceId == type(IERC165).interfaceId;
617     }
618 }
619 
620 /**
621  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
622  * the Metadata extension, but not including the Enumerable extension, which is available separately as
623  * {ERC721Enumerable}.
624  */
625 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
626     using Address for address;
627     using Strings for uint256;
628 
629     // Token name
630     string private _name;
631 
632     // Token symbol
633     string private _symbol;
634 
635     // Mapping from token ID to owner address
636     mapping(uint256 => address) private _owners;
637 
638     // Mapping owner address to token count
639     mapping(address => uint256) private _balances;
640 
641     // Mapping from token ID to approved address
642     mapping(uint256 => address) private _tokenApprovals;
643 
644     // Mapping from owner to operator approvals
645     mapping(address => mapping(address => bool)) private _operatorApprovals;
646 
647     /**
648      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
649      */
650     constructor(string memory name_, string memory symbol_) {
651         _name = name_;
652         _symbol = symbol_;
653     }
654 
655     /**
656      * @dev See {IERC165-supportsInterface}.
657      */
658     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
659         return
660         interfaceId == type(IERC721).interfaceId ||
661         interfaceId == type(IERC721Metadata).interfaceId ||
662         super.supportsInterface(interfaceId);
663     }
664 
665     /**
666      * @dev See {IERC721-balanceOf}.
667      */
668     function balanceOf(address owner) public view virtual override returns (uint256) {
669         require(owner != address(0), "ERC721: address zero is not a valid owner");
670         return _balances[owner];
671     }
672 
673     /**
674      * @dev See {IERC721-ownerOf}.
675      */
676     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
677         address owner = _owners[tokenId];
678         require(owner != address(0), "ERC721: invalid token ID");
679         return owner;
680     }
681 
682     /**
683      * @dev See {IERC721Metadata-name}.
684      */
685     function name() public view virtual override returns (string memory) {
686         return _name;
687     }
688 
689     /**
690      * @dev See {IERC721Metadata-symbol}.
691      */
692     function symbol() public view virtual override returns (string memory) {
693         return _symbol;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-tokenURI}.
698      */
699     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
700         _requireMinted(tokenId);
701 
702         string memory baseURI = _baseURI();
703         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
704     }
705 
706     /**
707      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
708      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
709      * by default, can be overridden in child contracts.
710      */
711     function _baseURI() internal view virtual returns (string memory) {
712         return "";
713     }
714 
715     /**
716      * @dev See {IERC721-approve}.
717      */
718     function approve(address to, uint256 tokenId) public virtual override {
719         address owner = ERC721.ownerOf(tokenId);
720         require(to != owner, "ERC721: approval to current owner");
721 
722         require(
723             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
724             "ERC721: approve caller is not token owner nor approved for all"
725         );
726 
727         _approve(to, tokenId);
728     }
729 
730     /**
731      * @dev See {IERC721-getApproved}.
732      */
733     function getApproved(uint256 tokenId) public view virtual override returns (address) {
734         _requireMinted(tokenId);
735 
736         return _tokenApprovals[tokenId];
737     }
738 
739     /**
740      * @dev See {IERC721-setApprovalForAll}.
741      */
742     function setApprovalForAll(address operator, bool approved) public virtual override {
743         _setApprovalForAll(_msgSender(), operator, approved);
744     }
745 
746     /**
747      * @dev See {IERC721-isApprovedForAll}.
748      */
749     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
750         return _operatorApprovals[owner][operator];
751     }
752 
753     /**
754      * @dev See {IERC721-transferFrom}.
755      */
756     function transferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) public virtual override {
761         //solhint-disable-next-line max-line-length
762         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
763 
764         _transfer(from, to, tokenId);
765     }
766 
767     /**
768      * @dev See {IERC721-safeTransferFrom}.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) public virtual override {
775         safeTransferFrom(from, to, tokenId, "");
776     }
777 
778     /**
779      * @dev See {IERC721-safeTransferFrom}.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes memory data
786     ) public virtual override {
787         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
788         _safeTransfer(from, to, tokenId, data);
789     }
790 
791     /**
792      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
793      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
794      *
795      * `data` is additional data, it has no specified format and it is sent in call to `to`.
796      *
797      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
798      * implement alternative mechanisms to perform token transfer, such as signature-based.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must exist and be owned by `from`.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _safeTransfer(
810         address from,
811         address to,
812         uint256 tokenId,
813         bytes memory data
814     ) internal virtual {
815         _transfer(from, to, tokenId);
816         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
817     }
818 
819     /**
820      * @dev Returns whether `tokenId` exists.
821      *
822      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
823      *
824      * Tokens start existing when they are minted (`_mint`),
825      * and stop existing when they are burned (`_burn`).
826      */
827     function _exists(uint256 tokenId) internal view virtual returns (bool) {
828         return _owners[tokenId] != address(0);
829     }
830 
831     /**
832      * @dev Returns whether `spender` is allowed to manage `tokenId`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      */
838     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
839         address owner = ERC721.ownerOf(tokenId);
840         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
841     }
842 
843     /**
844      * @dev Safely mints `tokenId` and transfers it to `to`.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must not exist.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _safeMint(address to, uint256 tokenId) internal virtual {
854         _safeMint(to, tokenId, "");
855     }
856 
857     /**
858      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
859      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
860      */
861     function _safeMint(
862         address to,
863         uint256 tokenId,
864         bytes memory data
865     ) internal virtual {
866         _mint(to, tokenId);
867         require(
868             _checkOnERC721Received(address(0), to, tokenId, data),
869             "ERC721: transfer to non ERC721Receiver implementer"
870         );
871     }
872 
873     /**
874      * @dev Mints `tokenId` and transfers it to `to`.
875      *
876      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
877      *
878      * Requirements:
879      *
880      * - `tokenId` must not exist.
881      * - `to` cannot be the zero address.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _mint(address to, uint256 tokenId) internal virtual {
886         require(to != address(0), "ERC721: mint to the zero address");
887         require(!_exists(tokenId), "ERC721: token already minted");
888 
889         _beforeTokenTransfer(address(0), to, tokenId);
890 
891         _balances[to] += 1;
892         _owners[tokenId] = to;
893 
894         emit Transfer(address(0), to, tokenId);
895 
896         _afterTokenTransfer(address(0), to, tokenId);
897     }
898 
899     /**
900      * @dev Destroys `tokenId`.
901      * The approval is cleared when the token is burned.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _burn(uint256 tokenId) internal virtual {
910         address owner = ERC721.ownerOf(tokenId);
911 
912         _beforeTokenTransfer(owner, address(0), tokenId);
913 
914         // Clear approvals
915         _approve(address(0), tokenId);
916 
917         _balances[owner] -= 1;
918         delete _owners[tokenId];
919 
920         emit Transfer(owner, address(0), tokenId);
921 
922         _afterTokenTransfer(owner, address(0), tokenId);
923     }
924 
925     /**
926      * @dev Transfers `tokenId` from `from` to `to`.
927      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
928      *
929      * Requirements:
930      *
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _transfer(
937         address from,
938         address to,
939         uint256 tokenId
940     ) internal virtual {
941         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
942         require(to != address(0), "ERC721: transfer to the zero address");
943 
944         _beforeTokenTransfer(from, to, tokenId);
945 
946         // Clear approvals from the previous owner
947         _approve(address(0), tokenId);
948 
949         _balances[from] -= 1;
950         _balances[to] += 1;
951         _owners[tokenId] = to;
952 
953         emit Transfer(from, to, tokenId);
954 
955         _afterTokenTransfer(from, to, tokenId);
956     }
957 
958     /**
959      * @dev Approve `to` to operate on `tokenId`
960      *
961      * Emits an {Approval} event.
962      */
963     function _approve(address to, uint256 tokenId) internal virtual {
964         _tokenApprovals[tokenId] = to;
965         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
966     }
967 
968     /**
969      * @dev Approve `operator` to operate on all of `owner` tokens
970      *
971      * Emits an {ApprovalForAll} event.
972      */
973     function _setApprovalForAll(
974         address owner,
975         address operator,
976         bool approved
977     ) internal virtual {
978         require(owner != operator, "ERC721: approve to caller");
979         _operatorApprovals[owner][operator] = approved;
980         emit ApprovalForAll(owner, operator, approved);
981     }
982 
983     /**
984      * @dev Reverts if the `tokenId` has not been minted yet.
985      */
986     function _requireMinted(uint256 tokenId) internal view virtual {
987         require(_exists(tokenId), "ERC721: invalid token ID");
988     }
989 
990     /**
991      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
992      * The call is not executed if the target address is not a contract.
993      *
994      * @param from address representing the previous owner of the given token ID
995      * @param to target address that will receive the tokens
996      * @param tokenId uint256 ID of the token to be transferred
997      * @param data bytes optional data to send along with the call
998      * @return bool whether the call correctly returned the expected magic value
999      */
1000     function _checkOnERC721Received(
1001         address from,
1002         address to,
1003         uint256 tokenId,
1004         bytes memory data
1005     ) private returns (bool) {
1006         if (to.isContract()) {
1007             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1008                 return retval == IERC721Receiver.onERC721Received.selector;
1009             } catch (bytes memory reason) {
1010                 if (reason.length == 0) {
1011                     revert("ERC721: transfer to non ERC721Receiver implementer");
1012                 } else {
1013                     /// @solidity memory-safe-assembly
1014                     assembly {
1015                         revert(add(32, reason), mload(reason))
1016                     }
1017                 }
1018             }
1019         } else {
1020             return true;
1021         }
1022     }
1023 
1024     /**
1025      * @dev Hook that is called before any token transfer. This includes minting
1026      * and burning.
1027      *
1028      * Calling conditions:
1029      *
1030      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1031      * transferred to `to`.
1032      * - When `from` is zero, `tokenId` will be minted for `to`.
1033      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1034      * - `from` and `to` are never both zero.
1035      *
1036      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1037      */
1038     function _beforeTokenTransfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) internal virtual {}
1043 
1044     /**
1045      * @dev Hook that is called after any transfer of tokens. This includes
1046      * minting and burning.
1047      *
1048      * Calling conditions:
1049      *
1050      * - when `from` and `to` are both non-zero.
1051      * - `from` and `to` are never both zero.
1052      *
1053      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1054      */
1055     function _afterTokenTransfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) internal virtual {}
1060 }
1061 
1062 /**
1063  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1064  * @dev See https://eips.ethereum.org/EIPS/eip-721
1065  */
1066 interface IERC721Enumerable is IERC721 {
1067     /**
1068      * @dev Returns the total amount of tokens stored by the contract.
1069      */
1070     function totalSupply() external view returns (uint256);
1071 
1072     /**
1073      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1074      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1075      */
1076     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1077 
1078     /**
1079      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1080      * Use along with {totalSupply} to enumerate all tokens.
1081      */
1082     function tokenByIndex(uint256 index) external view returns (uint256);
1083 }
1084 
1085 /**
1086  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1087  * enumerability of all the token ids in the contract as well as all token ids owned by each
1088  * account.
1089  */
1090 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1091     // Mapping from owner to list of owned token IDs
1092     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1093 
1094     // Mapping from token ID to index of the owner tokens list
1095     mapping(uint256 => uint256) private _ownedTokensIndex;
1096 
1097     // Array with all token ids, used for enumeration
1098     uint256[] private _allTokens;
1099 
1100     // Mapping from token id to position in the allTokens array
1101     mapping(uint256 => uint256) private _allTokensIndex;
1102 
1103     /**
1104      * @dev See {IERC165-supportsInterface}.
1105      */
1106     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1107         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1112      */
1113     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1114         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1115         return _ownedTokens[owner][index];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Enumerable-totalSupply}.
1120      */
1121     function totalSupply() public view virtual override returns (uint256) {
1122         return _allTokens.length;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Enumerable-tokenByIndex}.
1127      */
1128     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1129         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1130         return _allTokens[index];
1131     }
1132 
1133     /**
1134      * @dev Hook that is called before any token transfer. This includes minting
1135      * and burning.
1136      *
1137      * Calling conditions:
1138      *
1139      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1140      * transferred to `to`.
1141      * - When `from` is zero, `tokenId` will be minted for `to`.
1142      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1143      * - `from` cannot be the zero address.
1144      * - `to` cannot be the zero address.
1145      *
1146      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1147      */
1148     function _beforeTokenTransfer(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) internal virtual override {
1153         super._beforeTokenTransfer(from, to, tokenId);
1154 
1155         if (from == address(0)) {
1156             _addTokenToAllTokensEnumeration(tokenId);
1157         } else if (from != to) {
1158             _removeTokenFromOwnerEnumeration(from, tokenId);
1159         }
1160         if (to == address(0)) {
1161             _removeTokenFromAllTokensEnumeration(tokenId);
1162         } else if (to != from) {
1163             _addTokenToOwnerEnumeration(to, tokenId);
1164         }
1165     }
1166 
1167     /**
1168      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1169      * @param to address representing the new owner of the given token ID
1170      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1171      */
1172     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1173         uint256 length = ERC721.balanceOf(to);
1174         _ownedTokens[to][length] = tokenId;
1175         _ownedTokensIndex[tokenId] = length;
1176     }
1177 
1178     /**
1179      * @dev Private function to add a token to this extension's token tracking data structures.
1180      * @param tokenId uint256 ID of the token to be added to the tokens list
1181      */
1182     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1183         _allTokensIndex[tokenId] = _allTokens.length;
1184         _allTokens.push(tokenId);
1185     }
1186 
1187     /**
1188      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1189      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1190      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1191      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1192      * @param from address representing the previous owner of the given token ID
1193      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1194      */
1195     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1196         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1197         // then delete the last slot (swap and pop).
1198 
1199         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1200         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1201 
1202         // When the token to delete is the last token, the swap operation is unnecessary
1203         if (tokenIndex != lastTokenIndex) {
1204             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1205 
1206             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1207             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1208         }
1209 
1210         // This also deletes the contents at the last position of the array
1211         delete _ownedTokensIndex[tokenId];
1212         delete _ownedTokens[from][lastTokenIndex];
1213     }
1214 
1215     /**
1216      * @dev Private function to remove a token from this extension's token tracking data structures.
1217      * This has O(1) time complexity, but alters the order of the _allTokens array.
1218      * @param tokenId uint256 ID of the token to be removed from the tokens list
1219      */
1220     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1221         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1222         // then delete the last slot (swap and pop).
1223 
1224         uint256 lastTokenIndex = _allTokens.length - 1;
1225         uint256 tokenIndex = _allTokensIndex[tokenId];
1226 
1227         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1228         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1229         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1230         uint256 lastTokenId = _allTokens[lastTokenIndex];
1231 
1232         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1233         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1234 
1235         // This also deletes the contents at the last position of the array
1236         delete _allTokensIndex[tokenId];
1237         _allTokens.pop();
1238     }
1239 }
1240 
1241 /**
1242  * @dev Implementation of the {IERC721Receiver} interface.
1243  *
1244  * Accepts all token transfers.
1245  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
1246  */
1247 contract ERC721Holder is IERC721Receiver {
1248     /**
1249      * @dev See {IERC721Receiver-onERC721Received}.
1250      *
1251      * Always returns `IERC721Receiver.onERC721Received.selector`.
1252      */
1253     function onERC721Received(
1254         address,
1255         address,
1256         uint256,
1257         bytes memory
1258     ) public virtual override returns (bytes4) {
1259         return this.onERC721Received.selector;
1260     }
1261 }
1262 
1263 interface IX7Migration {
1264     function inMigration(address) external view returns (bool);
1265 }
1266 
1267 contract X7EcosystemMaxi is ERC721Enumerable, ERC721Holder, Ownable {
1268 
1269     address payable public mintFeeDestination;
1270     address payable public treasury;
1271     string public _internalBaseURI;
1272 
1273     uint256 public maxSupply = 500;
1274     uint256 public mintPrice = 10**17;
1275     uint256 public maxMintsPerTransaction = 5;
1276 
1277     bool public mintingOpen;
1278     bool public whitelistComplete;
1279 
1280     bool public whitelistActive = true;
1281     IX7Migration public whitelistAuthority;
1282 
1283     event MintingOpen();
1284     event MintFeeDestinationSet(address indexed oldDestination, address indexed newDestination);
1285     event MintPriceSet(uint256 oldPrice, uint256 newPrice);
1286     event BaseURISet(string oldURI, string newURI);
1287     event WhitelistActivitySet(bool whitelistActive);
1288     event WhitelistAuthoritySet(address indexed oldWhitelistAuthority, address indexed newWhitelistAuthority);
1289 
1290     constructor(address mintFeeDestination_, address treasury_) ERC721("X7 Ecosystem Maxi", "X7EMAXI") Ownable(0x7000a09c425ABf5173FF458dF1370C25d1C58105) {
1291         mintFeeDestination = payable(mintFeeDestination_);
1292         treasury = payable(treasury_);
1293     }
1294 
1295     function whitelist(address holder) external view returns (bool) {
1296         return whitelistAuthority.inMigration(holder);
1297     }
1298 
1299     function setMintFeeDestination(address mintFeeDestination_) external onlyOwner {
1300         require(mintFeeDestination != mintFeeDestination_);
1301         address oldMintFeeDestination = mintFeeDestination;
1302         mintFeeDestination = payable(mintFeeDestination_);
1303         emit MintFeeDestinationSet(oldMintFeeDestination, mintFeeDestination_);
1304     }
1305 
1306     function setBaseURI(string memory baseURI_) external onlyOwner {
1307         require(keccak256(abi.encodePacked(_internalBaseURI)) != keccak256(abi.encodePacked(baseURI_)));
1308         string memory oldBaseURI = _internalBaseURI;
1309         _internalBaseURI = baseURI_;
1310         emit BaseURISet(oldBaseURI, baseURI_);
1311     }
1312 
1313     function setMintPrice(uint256 mintPrice_) external onlyOwner {
1314         require(mintPrice_ > mintPrice);
1315         uint256 oldPrice = mintPrice;
1316         mintPrice = mintPrice_;
1317         emit MintPriceSet(oldPrice, mintPrice_);
1318     }
1319 
1320     function setWhitelist(bool isActive) external onlyOwner {
1321         require(!whitelistComplete);
1322         require(whitelistActive != isActive);
1323         whitelistActive = isActive;
1324         emit WhitelistActivitySet(isActive);
1325     }
1326 
1327     function setWhitelistComplete() external onlyOwner {
1328         require(!whitelistComplete);
1329         whitelistComplete = true;
1330         whitelistActive = false;
1331     }
1332 
1333     function setWhitelistAuthority(address whitelistAuthority_) external onlyOwner {
1334         require(address(whitelistAuthority) != whitelistAuthority_);
1335         address oldWhitelistAuthority = address(whitelistAuthority);
1336         whitelistAuthority = IX7Migration(whitelistAuthority_);
1337         emit WhitelistAuthoritySet(oldWhitelistAuthority, whitelistAuthority_);
1338     }
1339 
1340     function openMinting() external onlyOwner {
1341         require(!mintingOpen);
1342         require(mintFeeDestination != address(0));
1343         mintingOpen = true;
1344         emit MintingOpen();
1345     }
1346 
1347     function mint() external payable {
1348         _mintMany(1);
1349     }
1350 
1351     function mintMany(uint256 numMints) external payable {
1352         _mintMany(numMints);
1353     }
1354 
1355     function _mintMany(uint256 numMints) internal {
1356         require(mintingOpen);
1357         require(!whitelistActive || whitelistAuthority.inMigration(msg.sender));
1358         require(totalSupply() + numMints <= maxSupply);
1359         require(numMints > 0 && numMints <= maxMintsPerTransaction);
1360         require(msg.value == numMints * mintPrice);
1361 
1362         uint256 treasuryFee = msg.value * 10 / 100;
1363 
1364         bool success;
1365 
1366         (success,) = treasury.call{value: treasuryFee}("");
1367         require(success);
1368 
1369         (success,) = mintFeeDestination.call{value: msg.value - treasuryFee}("");
1370         require(success);
1371 
1372         uint256 nextTokenId = ERC721Enumerable.totalSupply();
1373 
1374         for (uint i=0; i < numMints; i++) {
1375             super._mint(msg.sender, nextTokenId + i);
1376         }
1377     }
1378 
1379     function _baseURI() internal view override returns (string memory) {
1380         return _internalBaseURI;
1381     }
1382 }