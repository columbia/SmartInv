1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.7 <0.9.0;
3 
4 //import "@openzeppelin/contracts/utils/Strings.sol";
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11     uint8 private constant _ADDRESS_LENGTH = 20;
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 
69     /**
70      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
71      */
72     function toHexString(address addr) internal pure returns (string memory) {
73         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
74     }
75 }
76 
77 //import "../utils/Context.sol";
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 
99 //import "@openzeppelin/contracts/access/Ownable.sol";
100 /**
101  * @dev Contract module which provides a basic access control mechanism, where
102  * there is an account (an owner) that can be granted exclusive access to
103  * specific functions.
104  *
105  * By default, the owner account will be the one that deploys the contract. This
106  * can later be changed with {transferOwnership}.
107  *
108  * This module is used through inheritance. It will make available the modifier
109  * `onlyOwner`, which can be applied to your functions to restrict their use to
110  * the owner.
111  */
112 abstract contract Ownable is Context {
113     address private _owner;
114 
115     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
116 
117     /**
118      * @dev Initializes the contract setting the deployer as the initial owner.
119      */
120     constructor() {
121         _transferOwnership(_msgSender());
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the owner.
126      */
127     modifier onlyOwner() {
128         _checkOwner();
129         _;
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if the sender is not the owner.
141      */
142     function _checkOwner() internal view virtual {
143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 //import "../../utils/Address.sol";
178 /**
179  * @dev Collection of functions related to the address type
180  */
181 library Address {
182     /**
183      * @dev Returns true if `account` is a contract.
184      *
185      * [IMPORTANT]
186      * ====
187      * It is unsafe to assume that an address for which this function returns
188      * false is an externally-owned account (EOA) and not a contract.
189      *
190      * Among others, `isContract` will return false for the following
191      * types of addresses:
192      *
193      *  - an externally-owned account
194      *  - a contract in construction
195      *  - an address where a contract will be created
196      *  - an address where a contract lived, but was destroyed
197      * ====
198      *
199      * [IMPORTANT]
200      * ====
201      * You shouldn't rely on `isContract` to protect against flash loan attacks!
202      *
203      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
204      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
205      * constructor.
206      * ====
207      */
208     function isContract(address account) internal view returns (bool) {
209         // This method relies on extcodesize/address.code.length, which returns 0
210         // for contracts in construction, since the code is only stored at the end
211         // of the constructor execution.
212 
213         return account.code.length > 0;
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         (bool success, ) = recipient.call{value: amount}("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain `call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, 0, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but also transferring `value` wei to `target`.
278      *
279      * Requirements:
280      *
281      * - the calling contract must have an ETH balance of at least `value`.
282      * - the called Solidity function must be `payable`.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
296      * with `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(address(this).balance >= value, "Address: insufficient balance for call");
307         require(isContract(target), "Address: call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.call{value: value}(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
320         return functionStaticCall(target, data, "Address: low-level static call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal view returns (bytes memory) {
334         require(isContract(target), "Address: static call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.staticcall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(isContract(target), "Address: delegate call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.delegatecall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
369      * revert reason using the provided one.
370      *
371      * _Available since v4.3._
372      */
373     function verifyCallResult(
374         bool success,
375         bytes memory returndata,
376         string memory errorMessage
377     ) internal pure returns (bytes memory) {
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384                 /// @solidity memory-safe-assembly
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 //import "../../utils/introspection/IERC165.sol";
397 /**
398  * @dev Interface of the ERC165 standard, as defined in the
399  * https://eips.ethereum.org/EIPS/eip-165[EIP].
400  *
401  * Implementers can declare support of contract interfaces, which can then be
402  * queried by others ({ERC165Checker}).
403  *
404  * For an implementation, see {ERC165}.
405  */
406 interface IERC165 {
407     /**
408      * @dev Returns true if this contract implements the interface defined by
409      * `interfaceId`. See the corresponding
410      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
411      * to learn more about how these ids are created.
412      *
413      * This function call must use less than 30 000 gas.
414      */
415     function supportsInterface(bytes4 interfaceId) external view returns (bool);
416 }
417 
418 
419 //import "./IERC721.sol";
420 /**
421  * @dev Required interface of an ERC721 compliant contract.
422  */
423 interface IERC721 is IERC165 {
424     /**
425      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
431      */
432     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
436      */
437     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
438 
439     /**
440      * @dev Returns the number of tokens in ``owner``'s account.
441      */
442     function balanceOf(address owner) external view returns (uint256 balance);
443 
444     /**
445      * @dev Returns the owner of the `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function ownerOf(uint256 tokenId) external view returns (address owner);
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId,
470         bytes calldata data
471     ) external;
472 
473     /**
474      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
475      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must exist and be owned by `from`.
482      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484      *
485      * Emits a {Transfer} event.
486      */
487     function safeTransferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Transfers `tokenId` token from `from` to `to`.
495      *
496      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must be owned by `from`.
503      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
504      *
505      * Emits a {Transfer} event.
506      */
507     function transferFrom(
508         address from,
509         address to,
510         uint256 tokenId
511     ) external;
512 
513     /**
514      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
515      * The approval is cleared when the token is transferred.
516      *
517      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
518      *
519      * Requirements:
520      *
521      * - The caller must own the token or be an approved operator.
522      * - `tokenId` must exist.
523      *
524      * Emits an {Approval} event.
525      */
526     function approve(address to, uint256 tokenId) external;
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      *
536      * Emits an {ApprovalForAll} event.
537      */
538     function setApprovalForAll(address operator, bool _approved) external;
539 
540     /**
541      * @dev Returns the account approved for `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function getApproved(uint256 tokenId) external view returns (address operator);
548 
549     /**
550      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
551      *
552      * See {setApprovalForAll}
553      */
554     function isApprovedForAll(address owner, address operator) external view returns (bool);
555 }
556 
557 //import "./IERC721Receiver.sol";
558 /**
559  * @title ERC721 token receiver interface
560  * @dev Interface for any contract that wants to support safeTransfers
561  * from ERC721 asset contracts.
562  */
563 interface IERC721Receiver {
564     /**
565      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
566      * by `operator` from `from`, this function is called.
567      *
568      * It must return its Solidity selector to confirm the token transfer.
569      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
570      *
571      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
572      */
573     function onERC721Received(
574         address operator,
575         address from,
576         uint256 tokenId,
577         bytes calldata data
578     ) external returns (bytes4);
579 }
580 
581 
582 //import "./extensions/IERC721Metadata.sol";
583 /**
584  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
585  * @dev See https://eips.ethereum.org/EIPS/eip-721
586  */
587 interface IERC721Metadata is IERC721 {
588     /**
589      * @dev Returns the token collection name.
590      */
591     function name() external view returns (string memory);
592 
593     /**
594      * @dev Returns the token collection symbol.
595      */
596     function symbol() external view returns (string memory);
597 
598     /**
599      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
600      */
601     function tokenURI(uint256 tokenId) external view returns (string memory);
602 }
603 
604 
605 //import "../../utils/introspection/ERC165.sol";
606 /**
607  * @dev Implementation of the {IERC165} interface.
608  *
609  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
610  * for the additional interface id that will be supported. For example:
611  *
612  * ```solidity
613  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
615  * }
616  * ```
617  *
618  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
619  */
620 abstract contract ERC165 is IERC165 {
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625         return interfaceId == type(IERC165).interfaceId;
626     }
627 }
628 
629 
630 //import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
631 /**
632  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
633  * the Metadata extension, but not including the Enumerable extension, which is available separately as
634  * {ERC721Enumerable}.
635  */
636 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
637     using Address for address;
638     using Strings for uint256;
639 
640     // Token name
641     string private _name;
642 
643     // Token symbol
644     string private _symbol;
645 
646     // Mapping from token ID to owner address
647     mapping(uint256 => address) private _owners;
648 
649     // Mapping owner address to token count
650     mapping(address => uint256) private _balances;
651 
652     // Mapping from token ID to approved address
653     mapping(uint256 => address) private _tokenApprovals;
654 
655     // Mapping from owner to operator approvals
656     mapping(address => mapping(address => bool)) private _operatorApprovals;
657 
658     /**
659      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
660      */
661     constructor(string memory name_, string memory symbol_) {
662         _name = name_;
663         _symbol = symbol_;
664     }
665 
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      */
669     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
670         return
671             interfaceId == type(IERC721).interfaceId ||
672             interfaceId == type(IERC721Metadata).interfaceId ||
673             super.supportsInterface(interfaceId);
674     }
675 
676     /**
677      * @dev See {IERC721-balanceOf}.
678      */
679     function balanceOf(address owner) public view virtual override returns (uint256) {
680         require(owner != address(0), "ERC721: address zero is not a valid owner");
681         return _balances[owner];
682     }
683 
684     /**
685      * @dev See {IERC721-ownerOf}.
686      */
687     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
688         address owner = _owners[tokenId];
689         require(owner != address(0), "ERC721: invalid token ID");
690         return owner;
691     }
692 
693     /**
694      * @dev See {IERC721Metadata-name}.
695      */
696     function name() public view virtual override returns (string memory) {
697         return _name;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-symbol}.
702      */
703     function symbol() public view virtual override returns (string memory) {
704         return _symbol;
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-tokenURI}.
709      */
710     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
711         _requireMinted(tokenId);
712 
713         string memory baseURI = _baseURI();
714         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
715     }
716 
717     /**
718      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
719      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
720      * by default, can be overridden in child contracts.
721      */
722     function _baseURI() internal view virtual returns (string memory) {
723         return "";
724     }
725 
726     /**
727      * @dev See {IERC721-approve}.
728      */
729     function approve(address to, uint256 tokenId) public virtual override {
730         address owner = ERC721.ownerOf(tokenId);
731         require(to != owner, "ERC721: approval to current owner");
732 
733         require(
734             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
735             "ERC721: approve caller is not token owner nor approved for all"
736         );
737 
738         _approve(to, tokenId);
739     }
740 
741     /**
742      * @dev See {IERC721-getApproved}.
743      */
744     function getApproved(uint256 tokenId) public view virtual override returns (address) {
745         _requireMinted(tokenId);
746 
747         return _tokenApprovals[tokenId];
748     }
749 
750     /**
751      * @dev See {IERC721-setApprovalForAll}.
752      */
753     function setApprovalForAll(address operator, bool approved) public virtual override {
754         _setApprovalForAll(_msgSender(), operator, approved);
755     }
756 
757     /**
758      * @dev See {IERC721-isApprovedForAll}.
759      */
760     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
761         return _operatorApprovals[owner][operator];
762     }
763 
764     /**
765      * @dev See {IERC721-transferFrom}.
766      */
767     function transferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) public virtual override {
772         //solhint-disable-next-line max-line-length
773         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
774 
775         _transfer(from, to, tokenId);
776     }
777 
778     /**
779      * @dev See {IERC721-safeTransferFrom}.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId
785     ) public virtual override {
786         safeTransferFrom(from, to, tokenId, "");
787     }
788 
789     /**
790      * @dev See {IERC721-safeTransferFrom}.
791      */
792     function safeTransferFrom(
793         address from,
794         address to,
795         uint256 tokenId,
796         bytes memory data
797     ) public virtual override {
798         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
799         _safeTransfer(from, to, tokenId, data);
800     }
801 
802     /**
803      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
804      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
805      *
806      * `data` is additional data, it has no specified format and it is sent in call to `to`.
807      *
808      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
809      * implement alternative mechanisms to perform token transfer, such as signature-based.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must exist and be owned by `from`.
816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _safeTransfer(
821         address from,
822         address to,
823         uint256 tokenId,
824         bytes memory data
825     ) internal virtual {
826         _transfer(from, to, tokenId);
827         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
828     }
829 
830     /**
831      * @dev Returns whether `tokenId` exists.
832      *
833      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
834      *
835      * Tokens start existing when they are minted (`_mint`),
836      * and stop existing when they are burned (`_burn`).
837      */
838     function _exists(uint256 tokenId) internal view virtual returns (bool) {
839         return _owners[tokenId] != address(0);
840     }
841 
842     /**
843      * @dev Returns whether `spender` is allowed to manage `tokenId`.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
850         address owner = ERC721.ownerOf(tokenId);
851         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
852     }
853 
854     /**
855      * @dev Safely mints `tokenId` and transfers it to `to`.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must not exist.
860      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _safeMint(address to, uint256 tokenId) internal virtual {
865         _safeMint(to, tokenId, "");
866     }
867 
868     /**
869      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
870      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
871      */
872     function _safeMint(
873         address to,
874         uint256 tokenId,
875         bytes memory data
876     ) internal virtual {
877         _mint(to, tokenId);
878         require(
879             _checkOnERC721Received(address(0), to, tokenId, data),
880             "ERC721: transfer to non ERC721Receiver implementer"
881         );
882     }
883 
884     /**
885      * @dev Mints `tokenId` and transfers it to `to`.
886      *
887      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
888      *
889      * Requirements:
890      *
891      * - `tokenId` must not exist.
892      * - `to` cannot be the zero address.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _mint(address to, uint256 tokenId) internal virtual {
897         require(to != address(0), "ERC721: mint to the zero address");
898         require(!_exists(tokenId), "ERC721: token already minted");
899 
900         _beforeTokenTransfer(address(0), to, tokenId);
901 
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(address(0), to, tokenId);
906 
907         _afterTokenTransfer(address(0), to, tokenId);
908     }
909 
910     /**
911      * @dev Destroys `tokenId`.
912      * The approval is cleared when the token is burned.
913      *
914      * Requirements:
915      *
916      * - `tokenId` must exist.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _burn(uint256 tokenId) internal virtual {
921         address owner = ERC721.ownerOf(tokenId);
922 
923         _beforeTokenTransfer(owner, address(0), tokenId);
924 
925         // Clear approvals
926         _approve(address(0), tokenId);
927 
928         _balances[owner] -= 1;
929         delete _owners[tokenId];
930 
931         emit Transfer(owner, address(0), tokenId);
932 
933         _afterTokenTransfer(owner, address(0), tokenId);
934     }
935 
936     /**
937      * @dev Transfers `tokenId` from `from` to `to`.
938      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
939      *
940      * Requirements:
941      *
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must be owned by `from`.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _transfer(
948         address from,
949         address to,
950         uint256 tokenId
951     ) internal virtual {
952         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
953         require(to != address(0), "ERC721: transfer to the zero address");
954 
955         _beforeTokenTransfer(from, to, tokenId);
956 
957         // Clear approvals from the previous owner
958         _approve(address(0), tokenId);
959 
960         _balances[from] -= 1;
961         _balances[to] += 1;
962         _owners[tokenId] = to;
963 
964         emit Transfer(from, to, tokenId);
965 
966         _afterTokenTransfer(from, to, tokenId);
967     }
968 
969     /**
970      * @dev Approve `to` to operate on `tokenId`
971      *
972      * Emits an {Approval} event.
973      */
974     function _approve(address to, uint256 tokenId) internal virtual {
975         _tokenApprovals[tokenId] = to;
976         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
977     }
978 
979     /**
980      * @dev Approve `operator` to operate on all of `owner` tokens
981      *
982      * Emits an {ApprovalForAll} event.
983      */
984     function _setApprovalForAll(
985         address owner,
986         address operator,
987         bool approved
988     ) internal virtual {
989         require(owner != operator, "ERC721: approve to caller");
990         _operatorApprovals[owner][operator] = approved;
991         emit ApprovalForAll(owner, operator, approved);
992     }
993 
994     /**
995      * @dev Reverts if the `tokenId` has not been minted yet.
996      */
997     function _requireMinted(uint256 tokenId) internal view virtual {
998         require(_exists(tokenId), "ERC721: invalid token ID");
999     }
1000 
1001     /**
1002      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1003      * The call is not executed if the target address is not a contract.
1004      *
1005      * @param from address representing the previous owner of the given token ID
1006      * @param to target address that will receive the tokens
1007      * @param tokenId uint256 ID of the token to be transferred
1008      * @param data bytes optional data to send along with the call
1009      * @return bool whether the call correctly returned the expected magic value
1010      */
1011     function _checkOnERC721Received(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes memory data
1016     ) private returns (bool) {
1017         if (to.isContract()) {
1018             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1019                 return retval == IERC721Receiver.onERC721Received.selector;
1020             } catch (bytes memory reason) {
1021                 if (reason.length == 0) {
1022                     revert("ERC721: transfer to non ERC721Receiver implementer");
1023                 } else {
1024                     /// @solidity memory-safe-assembly
1025                     assembly {
1026                         revert(add(32, reason), mload(reason))
1027                     }
1028                 }
1029             }
1030         } else {
1031             return true;
1032         }
1033     }
1034 
1035     /**
1036      * @dev Hook that is called before any token transfer. This includes minting
1037      * and burning.
1038      *
1039      * Calling conditions:
1040      *
1041      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1042      * transferred to `to`.
1043      * - When `from` is zero, `tokenId` will be minted for `to`.
1044      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1045      * - `from` and `to` are never both zero.
1046      *
1047      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1048      */
1049     function _beforeTokenTransfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) internal virtual {}
1054 
1055     /**
1056      * @dev Hook that is called after any transfer of tokens. This includes
1057      * minting and burning.
1058      *
1059      * Calling conditions:
1060      *
1061      * - when `from` and `to` are both non-zero.
1062      * - `from` and `to` are never both zero.
1063      *
1064      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1065      */
1066     function _afterTokenTransfer(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) internal virtual {}
1071 }
1072 
1073 
1074 //import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
1075 /**
1076  * @dev Contract module that helps prevent reentrant calls to a function.
1077  *
1078  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1079  * available, which can be applied to functions to make sure there are no nested
1080  * (reentrant) calls to them.
1081  *
1082  * Note that because there is a single `nonReentrant` guard, functions marked as
1083  * `nonReentrant` may not call one another. This can be worked around by making
1084  * those functions `private`, and then adding `external` `nonReentrant` entry
1085  * points to them.
1086  *
1087  * TIP: If you would like to learn more about reentrancy and alternative ways
1088  * to protect against it, check out our blog post
1089  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1090  */
1091 abstract contract ReentrancyGuard {
1092     // Booleans are more expensive than uint256 or any type that takes up a full
1093     // word because each write operation emits an extra SLOAD to first read the
1094     // slot's contents, replace the bits taken up by the boolean, and then write
1095     // back. This is the compiler's defense against contract upgrades and
1096     // pointer aliasing, and it cannot be disabled.
1097 
1098     // The values being non-zero value makes deployment a bit more expensive,
1099     // but in exchange the refund on every call to nonReentrant will be lower in
1100     // amount. Since refunds are capped to a percentage of the total
1101     // transaction's gas, it is best to keep them low in cases like this one, to
1102     // increase the likelihood of the full refund coming into effect.
1103     uint256 private constant _NOT_ENTERED = 1;
1104     uint256 private constant _ENTERED = 2;
1105 
1106     uint256 private _status;
1107 
1108     constructor() {
1109         _status = _NOT_ENTERED;
1110     }
1111 
1112     /**
1113      * @dev Prevents a contract from calling itself, directly or indirectly.
1114      * Calling a `nonReentrant` function from another `nonReentrant`
1115      * function is not supported. It is possible to prevent this from happening
1116      * by making the `nonReentrant` function external, and making it call a
1117      * `private` function that does the actual work.
1118      */
1119     modifier nonReentrant() {
1120         // On the first call to nonReentrant, _notEntered will be true
1121         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1122 
1123         // Any calls to nonReentrant after this point will fail
1124         _status = _ENTERED;
1125 
1126         _;
1127 
1128         // By storing the original value once again, a refund is triggered (see
1129         // https://eips.ethereum.org/EIPS/eip-2200)
1130         _status = _NOT_ENTERED;
1131     }
1132 }
1133 
1134 
1135 //import "./Common/IWhitelist.sol";
1136 //--------------------------------------------
1137 // WHITELIST intterface
1138 //--------------------------------------------
1139 interface IWhitelist {
1140     //--------------------
1141     // function
1142     //--------------------
1143     function check( address target ) external view returns (bool);
1144 }
1145 
1146 
1147 //------------------------------------------------------------
1148 // Token(ERC721)
1149 //------------------------------------------------------------
1150 contract Token is Ownable, ERC721, ReentrancyGuard {
1151     //--------------------------------------------------------
1152     // 定数
1153     //--------------------------------------------------------
1154     string constant private TOKEN_NAME = "MetaIdol Extra";
1155     string constant private TOKEN_SYMBOL = "MIE";
1156 
1157     // mainnet
1158     address constant private OWNER_ADDRESS = 0xE2E577A889f2EB52C84c34E4539D33798987B6d2;
1159 
1160 /*
1161     // testnet
1162     address constant private OWNER_ADDRESS = 0xf7831EA80Fc5179f86f82Af3aedDF2b7a2Ce13Df;
1163 */
1164 
1165     // constant
1166     uint256 constant private TOKEN_ID_OFS = 1;
1167     uint256 constant private BLOCK_SEC_MARGIN = 30;
1168 
1169     // enum
1170     uint256 constant private INFO_SUSPENDED = 0;
1171     uint256 constant private INFO_START = 1;
1172     uint256 constant private INFO_END = 2;
1173     uint256 constant private INFO_WHITELISTED = 3;
1174     uint256 constant private INFO_USER_MINTED = 4;
1175     uint256 constant private INFO_USER_MINTABLE = 5;
1176     uint256 constant private INFO_MAX = 6;
1177 
1178     uint256 constant private USER_INFO_TYPE = INFO_MAX;
1179     uint256 constant private USER_INFO_TOTAL_SUPPLY = INFO_MAX + 1;
1180     uint256 constant private USER_INFO_TOKEN_MAX = INFO_MAX + 2;
1181     uint256 constant private USER_INFO_MAX = INFO_MAX + 3;
1182 
1183     //--------------------------------------------------------
1184     // 管理
1185     //--------------------------------------------------------
1186     address private _manager;
1187 
1188     //--------------------------------------------------------
1189     // ストレージ
1190     //--------------------------------------------------------
1191     string private _base_uri_for_hidden;
1192     string private _base_uri_for_revealed;
1193     uint256 private _token_max;
1194     uint256 private _token_reserved;
1195     uint256 private _total_supply;
1196 
1197     // GOLD
1198     bool private _GOLD_is_suspended;
1199     uint256 private _GOLD_start;
1200     uint256 private _GOLD_end;
1201     uint256 private _GOLD_mintable;
1202     IWhitelist[] private _GOLD_arr_whitelist;
1203     mapping( address => uint256 ) private _GOLD_map_user_minted;
1204 
1205     // SILVER
1206     bool private _SILVER_is_suspended;
1207     uint256 private _SILVER_start;
1208     uint256 private _SILVER_end;
1209     uint256 private _SILVER_mintable;
1210     IWhitelist[] private _SILVER_arr_whitelist;
1211     mapping( address => uint256 ) private _SILVER_map_user_minted;
1212 
1213     //--------------------------------------------------------
1214     // [modifier] onlyOwnerOrManager
1215     //--------------------------------------------------------
1216     modifier onlyOwnerOrManager() {
1217         require( msg.sender == owner() || msg.sender == manager(), "caller is not the owner neither manager" );
1218         _;
1219     }
1220 
1221     //--------------------------------------------------------
1222     // コンストラクタ
1223     //--------------------------------------------------------
1224     constructor() Ownable() ERC721( TOKEN_NAME, TOKEN_SYMBOL ) {
1225         transferOwnership( OWNER_ADDRESS );
1226         _manager = msg.sender;
1227 
1228         //-----------------------
1229         // mainnet
1230         //-----------------------
1231         _base_uri_for_hidden = "ipfs://QmWSjFf17rHj6coHC2jGQs97gkLDBh3gADirmysmUkQ9Cm/";
1232         //_base_uri_for_revealed = "";
1233         _token_max = 777;
1234         _token_reserved = 20;
1235 
1236         //***********************
1237         // GOLD
1238         //***********************
1239         _GOLD_start = 1667116800;                  // 2022/10/30 17:00:00(JST)
1240         _GOLD_end   = 1667124000;                  // 2022/10/30 19:00:00(JST)
1241         _GOLD_mintable = 1;                        // 1 nft
1242         _GOLD_arr_whitelist.push( IWhitelist(0x3998f6917935bc77E77b52Bb067cf80eC7C837b4) );
1243         
1244         //~~~~~~~~~~~~~~~~~~~~~~~
1245         // SILVER
1246         //~~~~~~~~~~~~~~~~~~~~~~~
1247         _SILVER_start = 1667125800;                // 2022/10/30 19:30:00(JST)
1248         _SILVER_end   = 1667134800;                // 2022/10/30 22:00:00(JST)
1249         _SILVER_mintable = 5;                      // 5 nft
1250         _SILVER_arr_whitelist.push( IWhitelist(0x3998f6917935bc77E77b52Bb067cf80eC7C837b4) );   // GOLDはSILVERを兼ねる
1251         _SILVER_arr_whitelist.push( IWhitelist(0xf4C6DE0DAb70126FDD388b435ce4A81099768175) );
1252 
1253 /*
1254         //-----------------------
1255         // testnet
1256         //-----------------------
1257         _base_uri_for_hidden = "ipfs://QmbuYkDiEuTxASyhRHtW9HRyvCKFPpk2BGEciSNAJ5sGDv/";
1258         //_base_uri_for_revealed = "";
1259         _token_max = 20;
1260         _token_reserved = 5;
1261 
1262         //***********************
1263         // GOLD
1264         //***********************
1265         _GOLD_start = 1667070000;                  // test 2022-10-30 04:00:00(JST)
1266         _GOLD_end   = 1667073000;                  // test 2022-10-30 04:50:00(JST)
1267         _GOLD_mintable = 1;                        // 1 nft
1268         _GOLD_arr_whitelist.push( IWhitelist(0x370324659963b56f34C86fC120d13176a80e0923) );
1269         
1270         //~~~~~~~~~~~~~~~~~~~~~~~
1271         // SILVER
1272         //~~~~~~~~~~~~~~~~~~~~~~~
1273         _SILVER_start = 1667073600;                // test 2022-10-30 05:00:00(JST)
1274         _SILVER_end   = 1667076600;                // test 2022-10-30 05:50:00(JST)
1275         _SILVER_mintable = 5;                      // 5 nft
1276         _SILVER_arr_whitelist.push( IWhitelist(0x370324659963b56f34C86fC120d13176a80e0923) );   // GOLDはSILVERを兼ねる
1277         _SILVER_arr_whitelist.push( IWhitelist(0xF7131FAF9504ffB195730622c7c664cB138f2a67) );
1278 */
1279     }
1280 
1281     //--------------------------------------------------------
1282     // [public] manager
1283     //--------------------------------------------------------
1284     function manager() public view returns (address) {
1285         return( _manager );
1286     }
1287 
1288     //--------------------------------------------------------
1289     // [external/onlyOwner] setManager
1290     //--------------------------------------------------------
1291     function setManager( address target ) external onlyOwner {
1292         _manager = target;
1293     }
1294 
1295     //--------------------------------------------------------
1296     // [external] get
1297     //--------------------------------------------------------
1298     function baseUriForHidden() external view returns (string memory) { return( _base_uri_for_hidden ); }
1299     function baseUriForRevealed() external view returns (string memory) { return( _base_uri_for_revealed ); }
1300     function tokenMax() external view returns (uint256) { return( _token_max ); }
1301     function tokenReserved() external view returns (uint256) { return( _token_reserved ); }
1302     function totalSupply() external view returns (uint256) { return( _total_supply ); }
1303 
1304     //--------------------------------------------------------
1305     // [external/onlyOwnerOrManager] set
1306     //--------------------------------------------------------
1307     function setBaseUriForHidden( string calldata uri ) external onlyOwnerOrManager { _base_uri_for_hidden = uri; }
1308     function setBaseUriForRevealed( string calldata uri ) external onlyOwnerOrManager { _base_uri_for_revealed = uri; }
1309     function setTokenMax( uint256 max ) external onlyOwnerOrManager { _token_max = max; }
1310     function setTokenReserved( uint256 reserved ) external onlyOwnerOrManager { _token_reserved = reserved; }
1311 
1312     //--------------------------------------------------------
1313     // [public/override] tokenURI
1314     //--------------------------------------------------------
1315     function tokenURI( uint256 tokenId ) public view override returns (string memory) {
1316         require( _exists( tokenId ), "nonexistent token" );
1317 
1318         if( bytes(_base_uri_for_revealed).length > 0 ){
1319             return( string( abi.encodePacked( _base_uri_for_revealed, Strings.toString( tokenId ) ) ) );            
1320         }
1321 
1322         return( string( abi.encodePacked( _base_uri_for_hidden, Strings.toString( tokenId ) ) ) );
1323     }
1324 
1325     //********************************************************
1326     // [public] getInfo - GOLD
1327     //********************************************************
1328     function GOLD_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
1329         uint256[INFO_MAX] memory arrRet;
1330 
1331         if( _GOLD_is_suspended ){ arrRet[INFO_SUSPENDED] = 1; }
1332         arrRet[INFO_START] = _GOLD_start;
1333         arrRet[INFO_END] = _GOLD_end;
1334         if( _checkWhitelist( _GOLD_arr_whitelist, target ) ){ arrRet[INFO_WHITELISTED] = 1; }
1335         arrRet[INFO_USER_MINTED] = _GOLD_map_user_minted[target];
1336         arrRet[INFO_USER_MINTABLE] = _GOLD_mintable;
1337 
1338         return( arrRet );
1339     }
1340 
1341     //********************************************************
1342     // [external/onlyOwnerOrManager] write - GOLD
1343     //********************************************************
1344     // is_suspended
1345     function GOLD_suspend( bool flag ) external onlyOwnerOrManager {
1346         _GOLD_is_suspended = flag;
1347     }
1348 
1349     // start-end
1350     function GOLD_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager {
1351         _GOLD_start = start;
1352         _GOLD_end = end;
1353     }
1354 
1355     // mintable
1356     function GOLD_setMintable( uint256 mintable ) external onlyOwnerOrManager {
1357         _GOLD_mintable = mintable;
1358     }
1359 
1360     // whitelist
1361     function GOLD_setWhiteList( address[] calldata lists ) external onlyOwnerOrManager {
1362         delete _GOLD_arr_whitelist;
1363 
1364         for( uint256 i=0; i<lists.length; i++ ){
1365             require( lists[i] != address(0), "GOLD: invalid list"  );
1366             _GOLD_arr_whitelist.push( IWhitelist(lists[i]) );
1367         }
1368     }
1369 
1370     //********************************************************
1371     // [external/nonReentrant] mint - GOLD
1372     //********************************************************
1373     function GOLD_mint( uint256 num ) external nonReentrant {
1374         uint256[INFO_MAX] memory arrInfo = GOLD_getInfo( msg.sender );
1375 
1376         require( arrInfo[INFO_SUSPENDED] == 0, "GOLD: suspended" );
1377         require( arrInfo[INFO_START] == 0 || arrInfo[INFO_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "GOLD: not opend" );
1378         require( arrInfo[INFO_END] == 0 || (arrInfo[INFO_END]+BLOCK_SEC_MARGIN) > block.timestamp, "GOLD: finished" );
1379         require( arrInfo[INFO_WHITELISTED] == 1, "GOLD: not whitelisted" );
1380         require( arrInfo[INFO_USER_MINTABLE] == 0 || arrInfo[INFO_USER_MINTABLE] >= (arrInfo[INFO_USER_MINTED]+num), "GOLD: reached the limit" );
1381 
1382         _mintTokens( msg.sender, num );
1383         _GOLD_map_user_minted[msg.sender] += num;
1384     }
1385 
1386     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1387     // [public] getInfo - SILVER
1388     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1389     function SILVER_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
1390         uint256[INFO_MAX] memory arrRet;
1391 
1392         if( _SILVER_is_suspended ){ arrRet[INFO_SUSPENDED] = 1; }
1393         arrRet[INFO_START] = _SILVER_start;
1394         arrRet[INFO_END] = _SILVER_end;
1395         if( _checkWhitelist( _SILVER_arr_whitelist, target ) ){ arrRet[INFO_WHITELISTED] = 1; }
1396         arrRet[INFO_USER_MINTED] = _SILVER_map_user_minted[target];
1397         arrRet[INFO_USER_MINTABLE] = _SILVER_mintable;
1398 
1399         return( arrRet );
1400     }
1401 
1402     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1403     // [external/onlyOwnerOrManager] write - SILVER
1404     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1405     // is_suspended
1406     function SILVER_suspend( bool flag ) external onlyOwnerOrManager {
1407         _SILVER_is_suspended = flag;
1408     }
1409 
1410     // start-end
1411     function SILVER_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager {
1412         _SILVER_start = start;
1413         _SILVER_end = end;
1414     }
1415 
1416     // mintable
1417     function SILVER_setMintable( uint256 mintable ) external onlyOwnerOrManager {
1418         _SILVER_mintable = mintable;
1419     }
1420 
1421     // whitelist
1422     function SILVER_setWhiteList( address[] calldata lists ) external onlyOwnerOrManager {
1423         delete _SILVER_arr_whitelist;
1424 
1425         for( uint256 i=0; i<lists.length; i++ ){
1426             require( lists[i] != address(0), "SILVER: invalid list"  );
1427             _SILVER_arr_whitelist.push( IWhitelist(lists[i]) );
1428         }
1429     }
1430 
1431     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1432     // [external/nonReentrant] mint - SILVER
1433     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1434     function SILVER_mint( uint256 num ) external nonReentrant {
1435         uint256[INFO_MAX] memory arrInfo = SILVER_getInfo( msg.sender );
1436 
1437         require( arrInfo[INFO_SUSPENDED] == 0, "SILVER: suspended" );
1438         require( arrInfo[INFO_START] == 0 || arrInfo[INFO_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "SILVER: not opend" );
1439         require( arrInfo[INFO_END] == 0 || (arrInfo[INFO_END]+BLOCK_SEC_MARGIN) > block.timestamp, "SILVER: finished" );
1440         require( arrInfo[INFO_WHITELISTED] == 1, "SILVER: not whitelisted" );
1441         require( arrInfo[INFO_USER_MINTABLE] == 0 || arrInfo[INFO_USER_MINTABLE] >= (arrInfo[INFO_USER_MINTED]+num), "SILVER: reached the limit" );
1442 
1443         _mintTokens( msg.sender, num );
1444         _SILVER_map_user_minted[msg.sender] += num;
1445     }
1446 
1447     //--------------------------------------------------------
1448     // [internal] _checkWhitelist
1449     //--------------------------------------------------------
1450     function _checkWhitelist( IWhitelist[] storage lists, address target ) internal view returns (bool) {
1451         for( uint256 i=0; i<lists.length; i++ ){
1452             if( lists[i].check(target) ){
1453                 return( true );
1454             }
1455         }
1456 
1457         return( false );        
1458     }
1459 
1460     //--------------------------------------------------------
1461     // [internal] _mintTokens
1462     //--------------------------------------------------------
1463     function _mintTokens( address to, uint256 num ) internal {
1464         require( _total_supply >= _token_reserved, "reservation not finished" );
1465         require( (_total_supply+num) <= _token_max, "exceeded the supply range" );
1466 
1467         for( uint256 i=0; i<num; i++ ){
1468             _mint( to, _total_supply+(TOKEN_ID_OFS+i) );
1469         }
1470         _total_supply += num;
1471     }
1472 
1473     //--------------------------------------------------------
1474     // [external/onlyOwnerOrManager] reserveTokens
1475     //--------------------------------------------------------
1476     function reserveTokens( uint256 num ) external onlyOwnerOrManager {
1477         require( (_total_supply+num) <= _token_reserved, "exceeded the reservation range" );
1478 
1479         for( uint256 i=0; i<num; i++ ){
1480             _mint( owner(), _total_supply+(TOKEN_ID_OFS+i) );
1481         }
1482         _total_supply += num;
1483     }
1484 
1485     //--------------------------------------------------------
1486     // [external] getUserInfo
1487     //--------------------------------------------------------
1488     function getUserInfo( address target ) external view returns (uint256[USER_INFO_MAX] memory) {
1489         uint256[USER_INFO_MAX] memory userInfo;
1490         uint256[INFO_MAX] memory info;
1491 
1492         // GOLD
1493         if( _checkWhitelist( _GOLD_arr_whitelist, target ) && (_GOLD_end == 0 || _GOLD_end > (block.timestamp+BLOCK_SEC_MARGIN/2)) ){
1494             userInfo[USER_INFO_TYPE] = 1;
1495             info = GOLD_getInfo( target );
1496         }
1497         // SILVER
1498         else{
1499             userInfo[USER_INFO_TYPE] = 2;
1500             info = SILVER_getInfo( target );
1501         }
1502 
1503         for( uint256 i=0; i<INFO_MAX; i++ ){
1504             userInfo[i] = info[i];
1505         }
1506 
1507         userInfo[USER_INFO_TOTAL_SUPPLY] = _total_supply;
1508         userInfo[USER_INFO_TOKEN_MAX] = _token_max;
1509 
1510         return( userInfo );
1511     }
1512 
1513 }