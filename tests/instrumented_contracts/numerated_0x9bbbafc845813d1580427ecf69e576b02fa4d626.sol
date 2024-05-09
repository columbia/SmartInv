1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.7 <0.9.0;
3 
4 
5 
6 //import "../../utils/Strings.sol";
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
68 }
69 
70 //import "../../utils/Context.sol";
71 /**
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 abstract contract Context {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 
86     function _msgData() internal view virtual returns (bytes calldata) {
87         return msg.data;
88     }
89 }
90 
91 
92 //import "@openzeppelin/contracts/access/Ownable.sol";
93 /**
94  * @dev Contract module which provides a basic access control mechanism, where
95  * there is an account (an owner) that can be granted exclusive access to
96  * specific functions.
97  *
98  * By default, the owner account will be the one that deploys the contract. This
99  * can later be changed with {transferOwnership}.
100  *
101  * This module is used through inheritance. It will make available the modifier
102  * `onlyOwner`, which can be applied to your functions to restrict their use to
103  * the owner.
104  */
105 abstract contract Ownable is Context {
106     address private _owner;
107 
108     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110     /**
111      * @dev Initializes the contract setting the deployer as the initial owner.
112      */
113     constructor() {
114         _transferOwnership(_msgSender());
115     }
116 
117     /**
118      * @dev Returns the address of the current owner.
119      */
120     function owner() public view virtual returns (address) {
121         return _owner;
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the owner.
126      */
127     modifier onlyOwner() {
128         require(owner() == _msgSender(), "Ownable: caller is not the owner");
129         _;
130     }
131 
132     /**
133      * @dev Leaves the contract without owner. It will not be possible to call
134      * `onlyOwner` functions anymore. Can only be called by the current owner.
135      *
136      * NOTE: Renouncing ownership will leave the contract without an owner,
137      * thereby removing any functionality that is only available to the owner.
138      */
139     function renounceOwnership() public virtual onlyOwner {
140         _transferOwnership(address(0));
141     }
142 
143     /**
144      * @dev Transfers ownership of the contract to a new account (`newOwner`).
145      * Can only be called by the current owner.
146      */
147     function transferOwnership(address newOwner) public virtual onlyOwner {
148         require(newOwner != address(0), "Ownable: new owner is the zero address");
149         _transferOwnership(newOwner);
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Internal function without access restriction.
155      */
156     function _transferOwnership(address newOwner) internal virtual {
157         address oldOwner = _owner;
158         _owner = newOwner;
159         emit OwnershipTransferred(oldOwner, newOwner);
160     }
161 }
162 
163 //import "../../utils/introspection/IERC165.sol";
164 /**
165  * @dev Interface of the ERC165 standard, as defined in the
166  * https://eips.ethereum.org/EIPS/eip-165[EIP].
167  *
168  * Implementers can declare support of contract interfaces, which can then be
169  * queried by others ({ERC165Checker}).
170  *
171  * For an implementation, see {ERC165}.
172  */
173 interface IERC165 {
174     /**
175      * @dev Returns true if this contract implements the interface defined by
176      * `interfaceId`. See the corresponding
177      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
178      * to learn more about how these ids are created.
179      *
180      * This function call must use less than 30 000 gas.
181      */
182     function supportsInterface(bytes4 interfaceId) external view returns (bool);
183 }
184 
185 //import "./IERC721.sol";
186 /**
187  * @dev Required interface of an ERC721 compliant contract.
188  */
189 interface IERC721 is IERC165 {
190     /**
191      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
194 
195     /**
196      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
197      */
198     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
199 
200     /**
201      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
202      */
203     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
204 
205     /**
206      * @dev Returns the number of tokens in ``owner``'s account.
207      */
208     function balanceOf(address owner) external view returns (uint256 balance);
209 
210     /**
211      * @dev Returns the owner of the `tokenId` token.
212      *
213      * Requirements:
214      *
215      * - `tokenId` must exist.
216      */
217     function ownerOf(uint256 tokenId) external view returns (address owner);
218 
219     /**
220      * @dev Safely transfers `tokenId` token from `from` to `to`.
221      *
222      * Requirements:
223      *
224      * - `from` cannot be the zero address.
225      * - `to` cannot be the zero address.
226      * - `tokenId` token must exist and be owned by `from`.
227      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
228      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
229      *
230      * Emits a {Transfer} event.
231      */
232     function safeTransferFrom(
233         address from,
234         address to,
235         uint256 tokenId,
236         bytes calldata data
237     ) external;
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
241      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
242      *
243      * Requirements:
244      *
245      * - `from` cannot be the zero address.
246      * - `to` cannot be the zero address.
247      * - `tokenId` token must exist and be owned by `from`.
248      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
250      *
251      * Emits a {Transfer} event.
252      */
253     function safeTransferFrom(
254         address from,
255         address to,
256         uint256 tokenId
257     ) external;
258 
259     /**
260      * @dev Transfers `tokenId` token from `from` to `to`.
261      *
262      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must be owned by `from`.
269      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transferFrom(
274         address from,
275         address to,
276         uint256 tokenId
277     ) external;
278 
279     /**
280      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
281      * The approval is cleared when the token is transferred.
282      *
283      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
284      *
285      * Requirements:
286      *
287      * - The caller must own the token or be an approved operator.
288      * - `tokenId` must exist.
289      *
290      * Emits an {Approval} event.
291      */
292     function approve(address to, uint256 tokenId) external;
293 
294     /**
295      * @dev Approve or remove `operator` as an operator for the caller.
296      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
297      *
298      * Requirements:
299      *
300      * - The `operator` cannot be the caller.
301      *
302      * Emits an {ApprovalForAll} event.
303      */
304     function setApprovalForAll(address operator, bool _approved) external;
305 
306     /**
307      * @dev Returns the account approved for `tokenId` token.
308      *
309      * Requirements:
310      *
311      * - `tokenId` must exist.
312      */
313     function getApproved(uint256 tokenId) external view returns (address operator);
314 
315     /**
316      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
317      *
318      * See {setApprovalForAll}
319      */
320     function isApprovedForAll(address owner, address operator) external view returns (bool);
321 }
322 
323 //import "./IERC721Receiver.sol";
324 /**
325  * @title ERC721 token receiver interface
326  * @dev Interface for any contract that wants to support safeTransfers
327  * from ERC721 asset contracts.
328  */
329 interface IERC721Receiver {
330     /**
331      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
332      * by `operator` from `from`, this function is called.
333      *
334      * It must return its Solidity selector to confirm the token transfer.
335      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
336      *
337      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
338      */
339     function onERC721Received(
340         address operator,
341         address from,
342         uint256 tokenId,
343         bytes calldata data
344     ) external returns (bytes4);
345 }
346 
347 
348 
349 //import "./extensions/IERC721Metadata.sol";
350 /**
351  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
352  * @dev See https://eips.ethereum.org/EIPS/eip-721
353  */
354 interface IERC721Metadata is IERC721 {
355     /**
356      * @dev Returns the token collection name.
357      */
358     function name() external view returns (string memory);
359 
360     /**
361      * @dev Returns the token collection symbol.
362      */
363     function symbol() external view returns (string memory);
364 
365     /**
366      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
367      */
368     function tokenURI(uint256 tokenId) external view returns (string memory);
369 }
370 
371 
372 //import "../../utils/Address.sol";
373 /**
374  * @dev Collection of functions related to the address type
375  */
376 library Address {
377     /**
378      * @dev Returns true if `account` is a contract.
379      *
380      * [IMPORTANT]
381      * ====
382      * It is unsafe to assume that an address for which this function returns
383      * false is an externally-owned account (EOA) and not a contract.
384      *
385      * Among others, `isContract` will return false for the following
386      * types of addresses:
387      *
388      *  - an externally-owned account
389      *  - a contract in construction
390      *  - an address where a contract will be created
391      *  - an address where a contract lived, but was destroyed
392      * ====
393      *
394      * [IMPORTANT]
395      * ====
396      * You shouldn't rely on `isContract` to protect against flash loan attacks!
397      *
398      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
399      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
400      * constructor.
401      * ====
402      */
403     function isContract(address account) internal view returns (bool) {
404         // This method relies on extcodesize/address.code.length, which returns 0
405         // for contracts in construction, since the code is only stored at the end
406         // of the constructor execution.
407 
408         return account.code.length > 0;
409     }
410 
411     /**
412      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
413      * `recipient`, forwarding all available gas and reverting on errors.
414      *
415      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
416      * of certain opcodes, possibly making contracts go over the 2300 gas limit
417      * imposed by `transfer`, making them unable to receive funds via
418      * `transfer`. {sendValue} removes this limitation.
419      *
420      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
421      *
422      * IMPORTANT: because control is transferred to `recipient`, care must be
423      * taken to not create reentrancy vulnerabilities. Consider using
424      * {ReentrancyGuard} or the
425      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
426      */
427     function sendValue(address payable recipient, uint256 amount) internal {
428         require(address(this).balance >= amount, "Address: insufficient balance");
429 
430         (bool success, ) = recipient.call{value: amount}("");
431         require(success, "Address: unable to send value, recipient may have reverted");
432     }
433 
434     /**
435      * @dev Performs a Solidity function call using a low level `call`. A
436      * plain `call` is an unsafe replacement for a function call: use this
437      * function instead.
438      *
439      * If `target` reverts with a revert reason, it is bubbled up by this
440      * function (like regular Solidity function calls).
441      *
442      * Returns the raw returned data. To convert to the expected return value,
443      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
444      *
445      * Requirements:
446      *
447      * - `target` must be a contract.
448      * - calling `target` with `data` must not revert.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionCall(target, data, "Address: low-level call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
458      * `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, 0, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but also transferring `value` wei to `target`.
473      *
474      * Requirements:
475      *
476      * - the calling contract must have an ETH balance of at least `value`.
477      * - the called Solidity function must be `payable`.
478      *
479      * _Available since v3.1._
480      */
481     function functionCallWithValue(
482         address target,
483         bytes memory data,
484         uint256 value
485     ) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
491      * with `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCallWithValue(
496         address target,
497         bytes memory data,
498         uint256 value,
499         string memory errorMessage
500     ) internal returns (bytes memory) {
501         require(address(this).balance >= value, "Address: insufficient balance for call");
502         require(isContract(target), "Address: call to non-contract");
503 
504         (bool success, bytes memory returndata) = target.call{value: value}(data);
505         return verifyCallResult(success, returndata, errorMessage);
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
510      * but performing a static call.
511      *
512      * _Available since v3.3._
513      */
514     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
515         return functionStaticCall(target, data, "Address: low-level static call failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
520      * but performing a static call.
521      *
522      * _Available since v3.3._
523      */
524     function functionStaticCall(
525         address target,
526         bytes memory data,
527         string memory errorMessage
528     ) internal view returns (bytes memory) {
529         require(isContract(target), "Address: static call to non-contract");
530 
531         (bool success, bytes memory returndata) = target.staticcall(data);
532         return verifyCallResult(success, returndata, errorMessage);
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
537      * but performing a delegate call.
538      *
539      * _Available since v3.4._
540      */
541     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
542         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
547      * but performing a delegate call.
548      *
549      * _Available since v3.4._
550      */
551     function functionDelegateCall(
552         address target,
553         bytes memory data,
554         string memory errorMessage
555     ) internal returns (bytes memory) {
556         require(isContract(target), "Address: delegate call to non-contract");
557 
558         (bool success, bytes memory returndata) = target.delegatecall(data);
559         return verifyCallResult(success, returndata, errorMessage);
560     }
561 
562     /**
563      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
564      * revert reason using the provided one.
565      *
566      * _Available since v4.3._
567      */
568     function verifyCallResult(
569         bool success,
570         bytes memory returndata,
571         string memory errorMessage
572     ) internal pure returns (bytes memory) {
573         if (success) {
574             return returndata;
575         } else {
576             // Look for revert reason and bubble it up if present
577             if (returndata.length > 0) {
578                 // The easiest way to bubble the revert reason is using memory via assembly
579 
580                 assembly {
581                     let returndata_size := mload(returndata)
582                     revert(add(32, returndata), returndata_size)
583                 }
584             } else {
585                 revert(errorMessage);
586             }
587         }
588     }
589 }
590 
591 
592 
593 //import "../../utils/introspection/ERC165.sol";
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 
617 
618 /**
619  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
620  * the Metadata extension, but not including the Enumerable extension, which is available separately as
621  * {ERC721Enumerable}.
622  */
623 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
624     using Address for address;
625     using Strings for uint256;
626 
627     // Token name
628     string private _name;
629 
630     // Token symbol
631     string private _symbol;
632 
633     // Mapping from token ID to owner address
634     mapping(uint256 => address) private _owners;
635 
636     // Mapping owner address to token count
637     mapping(address => uint256) private _balances;
638 
639     // Mapping from token ID to approved address
640     mapping(uint256 => address) private _tokenApprovals;
641 
642     // Mapping from owner to operator approvals
643     mapping(address => mapping(address => bool)) private _operatorApprovals;
644 
645     /**
646      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
647      */
648     constructor(string memory name_, string memory symbol_) {
649         _name = name_;
650         _symbol = symbol_;
651     }
652 
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
657         return
658             interfaceId == type(IERC721).interfaceId ||
659             interfaceId == type(IERC721Metadata).interfaceId ||
660             super.supportsInterface(interfaceId);
661     }
662 
663     /**
664      * @dev See {IERC721-balanceOf}.
665      */
666     function balanceOf(address owner) public view virtual override returns (uint256) {
667         require(owner != address(0), "ERC721: balance query for the zero address");
668         return _balances[owner];
669     }
670 
671     /**
672      * @dev See {IERC721-ownerOf}.
673      */
674     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
675         address owner = _owners[tokenId];
676         require(owner != address(0), "ERC721: owner query for nonexistent token");
677         return owner;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-name}.
682      */
683     function name() public view virtual override returns (string memory) {
684         return _name;
685     }
686 
687     /**
688      * @dev See {IERC721Metadata-symbol}.
689      */
690     function symbol() public view virtual override returns (string memory) {
691         return _symbol;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-tokenURI}.
696      */
697     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
698         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
699 
700         string memory baseURI = _baseURI();
701         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
702     }
703 
704     /**
705      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
706      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
707      * by default, can be overridden in child contracts.
708      */
709     function _baseURI() internal view virtual returns (string memory) {
710         return "";
711     }
712 
713     /**
714      * @dev See {IERC721-approve}.
715      */
716     function approve(address to, uint256 tokenId) public virtual override {
717         address owner = ERC721.ownerOf(tokenId);
718         require(to != owner, "ERC721: approval to current owner");
719 
720         require(
721             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
722             "ERC721: approve caller is not owner nor approved for all"
723         );
724 
725         _approve(to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-getApproved}.
730      */
731     function getApproved(uint256 tokenId) public view virtual override returns (address) {
732         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
733 
734         return _tokenApprovals[tokenId];
735     }
736 
737     /**
738      * @dev See {IERC721-setApprovalForAll}.
739      */
740     function setApprovalForAll(address operator, bool approved) public virtual override {
741         _setApprovalForAll(_msgSender(), operator, approved);
742     }
743 
744     /**
745      * @dev See {IERC721-isApprovedForAll}.
746      */
747     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
748         return _operatorApprovals[owner][operator];
749     }
750 
751     /**
752      * @dev See {IERC721-transferFrom}.
753      */
754     function transferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         //solhint-disable-next-line max-line-length
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761 
762         _transfer(from, to, tokenId);
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) public virtual override {
773         safeTransferFrom(from, to, tokenId, "");
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) public virtual override {
785         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
786         _safeTransfer(from, to, tokenId, _data);
787     }
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
791      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
792      *
793      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
794      *
795      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
796      * implement alternative mechanisms to perform token transfer, such as signature-based.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must exist and be owned by `from`.
803      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
804      *
805      * Emits a {Transfer} event.
806      */
807     function _safeTransfer(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) internal virtual {
813         _transfer(from, to, tokenId);
814         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
815     }
816 
817     /**
818      * @dev Returns whether `tokenId` exists.
819      *
820      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
821      *
822      * Tokens start existing when they are minted (`_mint`),
823      * and stop existing when they are burned (`_burn`).
824      */
825     function _exists(uint256 tokenId) internal view virtual returns (bool) {
826         return _owners[tokenId] != address(0);
827     }
828 
829     /**
830      * @dev Returns whether `spender` is allowed to manage `tokenId`.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      */
836     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
837         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
838         address owner = ERC721.ownerOf(tokenId);
839         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
840     }
841 
842     /**
843      * @dev Safely mints `tokenId` and transfers it to `to`.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must not exist.
848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _safeMint(address to, uint256 tokenId) internal virtual {
853         _safeMint(to, tokenId, "");
854     }
855 
856     /**
857      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
858      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
859      */
860     function _safeMint(
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _mint(to, tokenId);
866         require(
867             _checkOnERC721Received(address(0), to, tokenId, _data),
868             "ERC721: transfer to non ERC721Receiver implementer"
869         );
870     }
871 
872     /**
873      * @dev Mints `tokenId` and transfers it to `to`.
874      *
875      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
876      *
877      * Requirements:
878      *
879      * - `tokenId` must not exist.
880      * - `to` cannot be the zero address.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _mint(address to, uint256 tokenId) internal virtual {
885         require(to != address(0), "ERC721: mint to the zero address");
886         require(!_exists(tokenId), "ERC721: token already minted");
887 
888         _beforeTokenTransfer(address(0), to, tokenId);
889 
890         _balances[to] += 1;
891         _owners[tokenId] = to;
892 
893         emit Transfer(address(0), to, tokenId);
894 
895         _afterTokenTransfer(address(0), to, tokenId);
896     }
897 
898     /**
899      * @dev Destroys `tokenId`.
900      * The approval is cleared when the token is burned.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _burn(uint256 tokenId) internal virtual {
909         address owner = ERC721.ownerOf(tokenId);
910 
911         _beforeTokenTransfer(owner, address(0), tokenId);
912 
913         // Clear approvals
914         _approve(address(0), tokenId);
915 
916         _balances[owner] -= 1;
917         delete _owners[tokenId];
918 
919         emit Transfer(owner, address(0), tokenId);
920 
921         _afterTokenTransfer(owner, address(0), tokenId);
922     }
923 
924     /**
925      * @dev Transfers `tokenId` from `from` to `to`.
926      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
927      *
928      * Requirements:
929      *
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must be owned by `from`.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _transfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) internal virtual {
940         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
941         require(to != address(0), "ERC721: transfer to the zero address");
942 
943         _beforeTokenTransfer(from, to, tokenId);
944 
945         // Clear approvals from the previous owner
946         _approve(address(0), tokenId);
947 
948         _balances[from] -= 1;
949         _balances[to] += 1;
950         _owners[tokenId] = to;
951 
952         emit Transfer(from, to, tokenId);
953 
954         _afterTokenTransfer(from, to, tokenId);
955     }
956 
957     /**
958      * @dev Approve `to` to operate on `tokenId`
959      *
960      * Emits a {Approval} event.
961      */
962     function _approve(address to, uint256 tokenId) internal virtual {
963         _tokenApprovals[tokenId] = to;
964         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
965     }
966 
967     /**
968      * @dev Approve `operator` to operate on all of `owner` tokens
969      *
970      * Emits a {ApprovalForAll} event.
971      */
972     function _setApprovalForAll(
973         address owner,
974         address operator,
975         bool approved
976     ) internal virtual {
977         require(owner != operator, "ERC721: approve to caller");
978         _operatorApprovals[owner][operator] = approved;
979         emit ApprovalForAll(owner, operator, approved);
980     }
981 
982     /**
983      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
984      * The call is not executed if the target address is not a contract.
985      *
986      * @param from address representing the previous owner of the given token ID
987      * @param to target address that will receive the tokens
988      * @param tokenId uint256 ID of the token to be transferred
989      * @param _data bytes optional data to send along with the call
990      * @return bool whether the call correctly returned the expected magic value
991      */
992     function _checkOnERC721Received(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) private returns (bool) {
998         if (to.isContract()) {
999             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1000                 return retval == IERC721Receiver.onERC721Received.selector;
1001             } catch (bytes memory reason) {
1002                 if (reason.length == 0) {
1003                     revert("ERC721: transfer to non ERC721Receiver implementer");
1004                 } else {
1005                     assembly {
1006                         revert(add(32, reason), mload(reason))
1007                     }
1008                 }
1009             }
1010         } else {
1011             return true;
1012         }
1013     }
1014 
1015     /**
1016      * @dev Hook that is called before any token transfer. This includes minting
1017      * and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` will be minted for `to`.
1024      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1025      * - `from` and `to` are never both zero.
1026      *
1027      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1028      */
1029     function _beforeTokenTransfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) internal virtual {}
1034 
1035     /**
1036      * @dev Hook that is called after any transfer of tokens. This includes
1037      * minting and burning.
1038      *
1039      * Calling conditions:
1040      *
1041      * - when `from` and `to` are both non-zero.
1042      * - `from` and `to` are never both zero.
1043      *
1044      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1045      */
1046     function _afterTokenTransfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual {}
1051 }
1052 
1053 
1054 //import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
1055 /**
1056  * @dev Contract module that helps prevent reentrant calls to a function.
1057  *
1058  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1059  * available, which can be applied to functions to make sure there are no nested
1060  * (reentrant) calls to them.
1061  *
1062  * Note that because there is a single `nonReentrant` guard, functions marked as
1063  * `nonReentrant` may not call one another. This can be worked around by making
1064  * those functions `private`, and then adding `external` `nonReentrant` entry
1065  * points to them.
1066  *
1067  * TIP: If you would like to learn more about reentrancy and alternative ways
1068  * to protect against it, check out our blog post
1069  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1070  */
1071 abstract contract ReentrancyGuard {
1072     // Booleans are more expensive than uint256 or any type that takes up a full
1073     // word because each write operation emits an extra SLOAD to first read the
1074     // slot's contents, replace the bits taken up by the boolean, and then write
1075     // back. This is the compiler's defense against contract upgrades and
1076     // pointer aliasing, and it cannot be disabled.
1077 
1078     // The values being non-zero value makes deployment a bit more expensive,
1079     // but in exchange the refund on every call to nonReentrant will be lower in
1080     // amount. Since refunds are capped to a percentage of the total
1081     // transaction's gas, it is best to keep them low in cases like this one, to
1082     // increase the likelihood of the full refund coming into effect.
1083     uint256 private constant _NOT_ENTERED = 1;
1084     uint256 private constant _ENTERED = 2;
1085 
1086     uint256 private _status;
1087 
1088     constructor() {
1089         _status = _NOT_ENTERED;
1090     }
1091 
1092     /**
1093      * @dev Prevents a contract from calling itself, directly or indirectly.
1094      * Calling a `nonReentrant` function from another `nonReentrant`
1095      * function is not supported. It is possible to prevent this from happening
1096      * by making the `nonReentrant` function external, and making it call a
1097      * `private` function that does the actual work.
1098      */
1099     modifier nonReentrant() {
1100         // On the first call to nonReentrant, _notEntered will be true
1101         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1102 
1103         // Any calls to nonReentrant after this point will fail
1104         _status = _ENTERED;
1105 
1106         _;
1107 
1108         // By storing the original value once again, a refund is triggered (see
1109         // https://eips.ethereum.org/EIPS/eip-2200)
1110         _status = _NOT_ENTERED;
1111     }
1112 }
1113 
1114 
1115 //import "./Common/IAirdrop.sol";
1116 //--------------------------------------------
1117 // AIRDROP intterface
1118 //--------------------------------------------
1119 interface IAirdrop {
1120     //--------------------
1121     // function
1122     //--------------------
1123     function getTotal() external view returns (uint256);
1124     function getAt( uint256 at ) external view returns (address);
1125 }
1126 
1127 //import "./Common/IWhiteList.sol";
1128 //--------------------------------------------
1129 // WHITELIST intterface
1130 //--------------------------------------------
1131 interface IWhiteList {
1132     //--------------------
1133     // function
1134     //--------------------
1135     function check( address target ) external view returns (bool);
1136 }
1137 
1138 
1139 //--------------------------------------------------------
1140 // Token: WONDER SECRET CLUB
1141 //--------------------------------------------------------
1142 contract Token is Ownable, ERC721, ReentrancyGuard {
1143     //--------------------------------------------------------
1144     // constant
1145     //--------------------------------------------------------
1146     string constant private TOKEN_NAME = "WONDER SECRET CLUB";
1147     string constant private TOKEN_SYMBOL = "WSC";
1148     uint256 constant private BLOCK_SEC_MARGIN = 30;
1149 
1150     //-----------------------------------------
1151     // mainnet
1152     //-----------------------------------------
1153     address constant private OWNER_ADDRESS = 0x8ee348062160811cba1c1A51E66c6A73214655F8;
1154     uint256 constant private RESERVED_TOKEN = 120;
1155     uint256 constant private AIRDROP_ADDRESS = 49;
1156     uint256 constant private AIRDROP_TOKEN_PER_ADDRESS = 2;
1157     uint256 constant private AIRDROP_TOKEN = AIRDROP_ADDRESS*AIRDROP_TOKEN_PER_ADDRESS;
1158 
1159     // enum
1160     uint256 constant private INFO_SALE_SUSPENDED = 0;
1161     uint256 constant private INFO_SALE_START = 1;
1162     uint256 constant private INFO_SALE_END = 2;
1163     uint256 constant private INFO_SALE_PRICE = 3;
1164     uint256 constant private INFO_SALE_WHITELISTED = 4;
1165     uint256 constant private INFO_SALE_MAX_MINT = 5;
1166     uint256 constant private INFO_SALE_USER_MINTED = 6;
1167     uint256 constant private INFO_MAX = 7;
1168     uint256 constant private USER_INFO_SALE = INFO_MAX;
1169     uint256 constant private USER_INFO_SUPPLY = INFO_MAX + 1;
1170     uint256 constant private USER_INFO_TOTAL = INFO_MAX + 2;
1171     uint256 constant private USER_INFO_MAX = INFO_MAX + 3;
1172 
1173     //--------------------------------------------------------
1174     // storage
1175     //--------------------------------------------------------
1176     address private _manager;
1177     string private _baseUriForHidden;
1178     string private _baseUriForRevealed;
1179     uint256 private _tokenMax;
1180     uint256 private _totalSupply;
1181 
1182     // AIRDROP
1183     IAirdrop private _AIRDROP_list;
1184 
1185     // MINTED
1186     IWhiteList private _MINTED_list;
1187 
1188     // WONDERLIST SALE
1189     bool private _WONDERLIST_SALE_isSuspended;
1190     uint256 private _WONDERLIST_SALE_start;
1191     uint256 private _WONDERLIST_SALE_end;
1192     uint256 private _WONDERLIST_SALE_price;
1193     uint256 private _WONDERLIST_SALE_quantity;
1194     IWhiteList[] private _WONDERLIST_SALE_arrWhiteList;
1195     mapping( address => uint256 ) private _WONDERLIST_SALE_mapMinted;
1196 
1197     // WONDERKIDS SALE
1198     bool private _WONDERKIDS_SALE_isSuspended;
1199     uint256 private _WONDERKIDS_SALE_start;
1200     uint256 private _WONDERKIDS_SALE_end;
1201     uint256 private _WONDERKIDS_SALE_price;
1202     uint256 private _WONDERKIDS_SALE_quantity;
1203     IWhiteList[] private _WONDERKIDS_SALE_arrWhiteList;
1204     mapping( address => uint256 ) private _WONDERKIDS_SALE_mapMinted;
1205 
1206     // PUBLIC SALE
1207     bool private _PUBLIC_SALE_isSuspended;
1208     uint256 private _PUBLIC_SALE_start;
1209     uint256 private _PUBLIC_SALE_end;
1210     uint256 private _PUBLIC_SALE_price;
1211     uint256 private _PUBLIC_SALE_quantity;
1212     IWhiteList[] private _PUBLIC_SALE_arrWhiteList;
1213     mapping( address => uint256 ) private _PUBLIC_SALE_mapMinted;
1214 
1215     // FINAL SALE
1216     bool private _FINAL_SALE_isSuspended;
1217     uint256 private _FINAL_SALE_start;
1218     uint256 private _FINAL_SALE_end;
1219     uint256 private _FINAL_SALE_price;
1220     uint256 private _FINAL_SALE_quantity;
1221     mapping( address => uint256 ) private _FINAL_SALE_mapMinted;
1222 
1223     //--------------------------------------------------------
1224     // [modifier] onlyOwnerOrManager
1225     //--------------------------------------------------------
1226     modifier onlyOwnerOrManager() {
1227         require( msg.sender == owner() || msg.sender == manager(), "caller is not the owner neither manager" );
1228         _;
1229     }
1230 
1231     //--------------------------------------------------------
1232     // constructor
1233     //--------------------------------------------------------
1234     constructor() Ownable() ERC721( TOKEN_NAME, TOKEN_SYMBOL ) {
1235         transferOwnership( OWNER_ADDRESS );
1236         _manager = msg.sender;
1237 
1238         //-----------------------
1239         // mainnet
1240         //-----------------------
1241         _baseUriForHidden = "ipfs://QmZkJocmGRFCef9t2q2MGUQ4Z7kNH9KPASwEeD2kx11URw/";
1242         _tokenMax = 5555;
1243 
1244         _AIRDROP_list = IAirdrop(0x2D44980Dda803827E756B5E4F4B0e1A3a824766E);   // additional
1245         _MINTED_list = IWhiteList(0x801de38D7F3cF2f2f5B23814541C3351189951B5);  // additional
1246 
1247         //=======================
1248         // WONDERLIST SALE
1249         //=======================
1250         _WONDERLIST_SALE_start = 1656946800;            // 2022-07-04 15:00:00(UTC)
1251         _WONDERLIST_SALE_end   = 1656954000;            // 2022-07-04 17:00:00(UTC)
1252         _WONDERLIST_SALE_price = 40000000000000000;     // 0.04 ETH
1253         _WONDERLIST_SALE_quantity = 1;
1254         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0x582b680e1b1c8aCAA9442E80b12CD0efAf1f3bd1) );   // fixed: 6/13
1255         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0x632ae52C10159fDb8f191F778f1aE9cA2ABFEeb3) );   // fixed: 6/13
1256         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0x7e72b15Cd97F08F7aE7a32C06Cca732eeb08C98c) );   // fixed: 6/13
1257         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0x06Dccb6EE7a900759CE426ef713120508f9C5036) );   // fixed: 6/13
1258         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0xe1bAD705EC6710800B3fe507c66a20cbd895Fe8E) );   // fixed: 6/13
1259         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0x6B9cC7A4c3e7A4eB56f29D3B3556FeB9318D1446) );   // fixed: 6/13
1260         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0x174fF1E0136a1bd578D8e27f6C430963b342F59F) );   // fixed: 6/13
1261         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0xD94e994c032fa5132f070D899703c19E686cFE3a) );   // fixed: 6/13
1262         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0x9be8f83f81291aacdB12f37a80A464d7Bfe4B8A1) );   // fixed: 6/13
1263         _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(0xB2ec8cde166f57a4E0D871d59610aa9ff30A6096) );   // additional
1264 
1265         //+++++++++++++++++++++++
1266         // WONDERKIDS SALE
1267         //+++++++++++++++++++++++
1268         _WONDERKIDS_SALE_start = 1656946800;            // 2022-07-04 15:00:00(UTC)
1269         _WONDERKIDS_SALE_end   = 1656954000;            // 2022-07-04 17:00:00(UTC)
1270         _WONDERKIDS_SALE_price = 40000000000000000;     // 0.04 ETH
1271         _WONDERKIDS_SALE_quantity = 2;
1272         _WONDERKIDS_SALE_arrWhiteList.push( IWhiteList(0x6452EBc37A790d8A5614bB3E30cf544eB5555796) );   // fixed: 6/13
1273         _WONDERKIDS_SALE_arrWhiteList.push( IWhiteList(0x2B56E26E85a552Eaa2C8C332C96EE4A11B7B4cac) );   // additional
1274 
1275         //***********************
1276         // PUBLIC SALE
1277         //***********************
1278         _PUBLIC_SALE_start = 1656954000;                // 2022-07-04 17:00:00(UTC)
1279         _PUBLIC_SALE_end   = 1656961200;                // 2022-07-04 19:00:00(UTC)
1280         _PUBLIC_SALE_price = 50000000000000000;         // 0.05 ETH
1281         _PUBLIC_SALE_quantity = 1;
1282         _PUBLIC_SALE_arrWhiteList.push( IWhiteList(0x2821Dbf2685fCda10C64907637aF56c7f92C4dd6) );       // fixed: 6/13
1283         _PUBLIC_SALE_arrWhiteList.push( IWhiteList(0x55E25eb0DbB1AA8a9b47e44fD27438B827D4A986) );       // fixed: 6/13
1284         _PUBLIC_SALE_arrWhiteList.push( IWhiteList(0x62a2CC3889d65666A669533fE8f92a323FE2c9A8) );       // fixed: 6/13
1285         _PUBLIC_SALE_arrWhiteList.push( IWhiteList(0x904f99D3646660096752e0Bc2fd5458962788F7B) );       // fixed: 6/13
1286         _PUBLIC_SALE_arrWhiteList.push( IWhiteList(0x8336f23513c25c52775DB44624BA5B731C8BAE18) );       // fixed: 6/13
1287 
1288         //~~~~~~~~~~~~~~~~~~~~~~~
1289         // FINAL SALE
1290         //~~~~~~~~~~~~~~~~~~~~~~~
1291         _FINAL_SALE_start = 1656961200;                 // 2022-07-04 19:00:00(UTC)
1292         _FINAL_SALE_end   = 0;                          // no period
1293         _FINAL_SALE_price = 50000000000000000;          // 0.05 ETH
1294         _FINAL_SALE_quantity = 2;
1295     }
1296 
1297     //--------------------------------------------------------
1298     // [public] manager
1299     //--------------------------------------------------------
1300     function manager() public view returns (address) {
1301         return( _manager );
1302     }
1303 
1304     //--------------------------------------------------------
1305     // [external/onlyOwner] setManager
1306     //--------------------------------------------------------
1307     function setManager( address target ) external onlyOwner {
1308         _manager = target;
1309     }
1310 
1311     //--------------------------------------------------------
1312     // [external] get
1313     //--------------------------------------------------------
1314     function baseUriForHidden() external view returns (string memory) { return( _baseUriForHidden ); }
1315     function baseUriForRevealed() external view returns (string memory) { return( _baseUriForRevealed ); }
1316     function tokenMax() external view returns (uint256) { return( _tokenMax ); }
1317     function totalSupply() external view returns (uint256) { return( _totalSupply ); }
1318 
1319     //--------------------------------------------------------
1320     // [external/onlyOwnerOrManager] set
1321     //--------------------------------------------------------
1322     function setBaseUriForHidden( string calldata uri ) external onlyOwnerOrManager { _baseUriForHidden = uri; }
1323     function setBaseUriForRevealed( string calldata uri ) external onlyOwnerOrManager { _baseUriForRevealed = uri; }
1324     function setTokenMax( uint256 max ) external onlyOwnerOrManager { _tokenMax = max; }
1325 
1326     //--------------------------------------------------------
1327     // [public/override] tokenURI
1328     //--------------------------------------------------------
1329     function tokenURI( uint256 tokenId ) public view override returns (string memory) {
1330         require( _exists( tokenId ), "nonexistent token" );
1331 
1332         if( bytes(_baseUriForRevealed).length > 0 ){
1333             return( string( abi.encodePacked( _baseUriForRevealed, Strings.toString( tokenId ) ) ) );            
1334         }
1335 
1336         return( string( abi.encodePacked( _baseUriForHidden, Strings.toString( tokenId ) ) ) );
1337     }
1338 
1339     //--------------------------------------------------------
1340     // [external/onlyOwnerOrManager] write - AIRDROP
1341     //--------------------------------------------------------
1342     function AIRDROP_setList( address list ) external onlyOwnerOrManager {
1343         require( list != address(0), "AIRDROP: invalid list" );
1344         _AIRDROP_list = IAirdrop(list);
1345     }
1346 
1347     //--------------------------------------------------------
1348     // [external/onlyOwnerOrManager] write - MINTED
1349     //--------------------------------------------------------
1350     function MINTED_setList( address list ) external onlyOwnerOrManager {
1351         require( list != address(0), "MINTED: invalid list" );
1352         _MINTED_list = IWhiteList(list);
1353     }
1354 
1355     //========================================================
1356     // [public] getInfo - WONDERLIST SALE
1357     //========================================================
1358     function WONDERLIST_SALE_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
1359         uint256[INFO_MAX] memory arrRet;
1360 
1361         if( _WONDERLIST_SALE_isSuspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
1362         arrRet[INFO_SALE_START] = _WONDERLIST_SALE_start;
1363         arrRet[INFO_SALE_END] = _WONDERLIST_SALE_end;
1364         arrRet[INFO_SALE_PRICE] = _WONDERLIST_SALE_price;
1365         if( _checkWhitelist( _WONDERLIST_SALE_arrWhiteList, target, true ) ){ arrRet[INFO_SALE_WHITELISTED] = 1; }
1366         arrRet[INFO_SALE_MAX_MINT] = _WONDERLIST_SALE_quantity;
1367         arrRet[INFO_SALE_USER_MINTED] = _WONDERLIST_SALE_mapMinted[target];
1368 
1369         return( arrRet );
1370     }
1371 
1372     //========================================================
1373     // [external/onlyOwnerOrManager] write - WONDERLIST SALE
1374     //========================================================
1375     // isSuspended
1376     function WONDERLIST_SALE_suspend( bool flag ) external onlyOwnerOrManager {
1377         _WONDERLIST_SALE_isSuspended = flag;
1378     }
1379 
1380     // start-end
1381     function WONDERLIST_SALE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager {
1382         _WONDERLIST_SALE_start = start;
1383         _WONDERLIST_SALE_end = end;
1384     }
1385 
1386     // price
1387     function WONDERLIST_SALE_setPrice( uint256 price ) external onlyOwnerOrManager {
1388         _WONDERLIST_SALE_price = price;
1389     }
1390 
1391     // quantity
1392     function WONDERLIST_SALE_setQuantity( uint256 quantity ) external onlyOwnerOrManager {
1393         _WONDERLIST_SALE_quantity = quantity;
1394     }
1395 
1396     // whitelist
1397     function WONDERLIST_SALE_setWhiteList( address[] calldata lists ) external onlyOwnerOrManager {
1398         delete _WONDERLIST_SALE_arrWhiteList;
1399 
1400         for( uint256 i=0; i<lists.length; i++ ){
1401             require( lists[i] != address(0), "WONDERLIST SALE: invalid list"  );
1402             _WONDERLIST_SALE_arrWhiteList.push( IWhiteList(lists[i]) );
1403         }
1404     }
1405 
1406     //========================================================
1407     // [external/payable] mint - WONDERLIST SALE
1408     //========================================================
1409     function WONDERLIST_SALE_mint( uint256 num ) external payable nonReentrant {
1410         uint256[INFO_MAX] memory arrInfo = WONDERLIST_SALE_getInfo( msg.sender );
1411 
1412         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "WONDERLIST SALE: suspended" );
1413         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "WONDERLIST SALE: not opend" );
1414         require( arrInfo[INFO_SALE_END] == 0 || arrInfo[INFO_SALE_END] > (block.timestamp-BLOCK_SEC_MARGIN), "WONDERLIST SALE: finished" );
1415         require( arrInfo[INFO_SALE_WHITELISTED] == 1, "WONDERLIST SALE: not whitelisted" );
1416         require( arrInfo[INFO_SALE_MAX_MINT] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "WONDERLIST SALE: reached the limit" );
1417 
1418         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
1419 
1420         _mintTokens( msg.sender, num );
1421         _WONDERLIST_SALE_mapMinted[msg.sender] += num;
1422     }
1423 
1424     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1425     // [public] getInfo - WONDERKIDS SALE
1426     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1427     function WONDERKIDS_SALE_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
1428         uint256[INFO_MAX] memory arrRet;
1429 
1430         if( _WONDERKIDS_SALE_isSuspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
1431         arrRet[INFO_SALE_START] = _WONDERKIDS_SALE_start;
1432         arrRet[INFO_SALE_END] = _WONDERKIDS_SALE_end;
1433         arrRet[INFO_SALE_PRICE] = _WONDERKIDS_SALE_price;
1434         if( _checkWhitelist( _WONDERKIDS_SALE_arrWhiteList, target, true ) ){ arrRet[INFO_SALE_WHITELISTED] = 1; }
1435         arrRet[INFO_SALE_MAX_MINT] = _WONDERKIDS_SALE_quantity;
1436         arrRet[INFO_SALE_USER_MINTED] = _WONDERKIDS_SALE_mapMinted[target];
1437 
1438         return( arrRet );
1439     }
1440 
1441     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1442     // [external/onlyOwnerOrManager] write - WONDERKIDS SALE
1443     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1444     // isSuspended
1445     function WONDERKIDS_SALE_suspend( bool flag ) external onlyOwnerOrManager {
1446         _WONDERKIDS_SALE_isSuspended = flag;
1447     }
1448 
1449     // start-end
1450     function WONDERKIDS_SALE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager {
1451         _WONDERKIDS_SALE_start = start;
1452         _WONDERKIDS_SALE_end = end;
1453     }
1454 
1455     // price
1456     function WONDERKIDS_SALE_setPrice( uint256 price ) external onlyOwnerOrManager {
1457         _WONDERKIDS_SALE_price = price;
1458     }
1459 
1460     // quantity
1461     function WONDERKIDS_SALE_setQuantity( uint256 quantity ) external onlyOwnerOrManager {
1462         _WONDERKIDS_SALE_quantity = quantity;
1463     }
1464 
1465     // whitelist
1466     function WONDERKIDS_SALE_setWhiteList( address[] calldata lists ) external onlyOwnerOrManager {
1467         delete _WONDERKIDS_SALE_arrWhiteList;
1468 
1469         for( uint256 i=0; i<lists.length; i++ ){
1470             require( lists[i] != address(0), "WONDERKIDS SALE: invalid list"  );
1471             _WONDERKIDS_SALE_arrWhiteList.push( IWhiteList(lists[i]) );
1472         }
1473     }
1474 
1475     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1476     // [external/payable] mint - WONDERKIDS SALE
1477     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1478     function WONDERKIDS_SALE_mint( uint256 num ) external payable nonReentrant {
1479         uint256[INFO_MAX] memory arrInfo = WONDERKIDS_SALE_getInfo( msg.sender );
1480 
1481         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "WONDERKIDS SALE: suspended" );
1482         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "WONDERKIDS SALE: not opend" );
1483         require( arrInfo[INFO_SALE_END] == 0 || arrInfo[INFO_SALE_END] > (block.timestamp-BLOCK_SEC_MARGIN), "WONDERKIDS SALE: finished" );
1484         require( arrInfo[INFO_SALE_WHITELISTED] == 1, "WONDERKIDS SALE: not whitelisted" );
1485         require( arrInfo[INFO_SALE_MAX_MINT] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "WONDERKIDS SALE: reached the limit" );
1486 
1487         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
1488 
1489         _mintTokens( msg.sender, num );
1490         _WONDERKIDS_SALE_mapMinted[msg.sender] += num;
1491     }
1492 
1493     //********************************************************
1494     // [public] getInfo - PUBLIC SALE
1495     //********************************************************
1496     function PUBLIC_SALE_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
1497         uint256[INFO_MAX] memory arrRet;
1498 
1499         if( _PUBLIC_SALE_isSuspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
1500         arrRet[INFO_SALE_START] = _PUBLIC_SALE_start;
1501         arrRet[INFO_SALE_END] = _PUBLIC_SALE_end;
1502         arrRet[INFO_SALE_PRICE] = _PUBLIC_SALE_price;
1503         if( _checkWhitelist( _PUBLIC_SALE_arrWhiteList, target, false ) ){ arrRet[INFO_SALE_WHITELISTED] = 1; }
1504         arrRet[INFO_SALE_MAX_MINT] = _PUBLIC_SALE_quantity;
1505         arrRet[INFO_SALE_USER_MINTED] = _PUBLIC_SALE_mapMinted[target];
1506 
1507         return( arrRet );
1508     }
1509 
1510     //********************************************************
1511     // [external/onlyOwnerOrManager] write - PUBLIC SALE
1512     //********************************************************
1513     // isSuspended
1514     function PUBLIC_SALE_suspend( bool flag ) external onlyOwnerOrManager {
1515         _PUBLIC_SALE_isSuspended = flag;
1516     }
1517 
1518     // start-end
1519     function PUBLIC_SALE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager {
1520         _PUBLIC_SALE_start = start;
1521         _PUBLIC_SALE_end = end;
1522     }
1523 
1524     // price
1525     function PUBLIC_SALE_setPrice( uint256 price ) external onlyOwnerOrManager {
1526         _PUBLIC_SALE_price = price;
1527     }
1528 
1529     // quantity
1530     function PUBLIC_SALE_setQuantity( uint256 quantity ) external onlyOwnerOrManager {
1531         _PUBLIC_SALE_quantity = quantity;
1532     }
1533 
1534     // whitelist
1535     function PUBLIC_SALE_setWhiteList( address[] calldata lists ) external onlyOwnerOrManager {
1536         delete _PUBLIC_SALE_arrWhiteList;
1537 
1538         for( uint256 i=0; i<lists.length; i++ ){
1539             require( lists[i] != address(0), "PUBLIC SALE: invalid list"  );
1540             _PUBLIC_SALE_arrWhiteList.push( IWhiteList(lists[i]) );
1541         }
1542     }
1543 
1544     //********************************************************
1545     // [external/payable] mint - PUBLIC SALE
1546     //********************************************************
1547     function PUBLIC_SALE_mint( uint256 num ) external payable nonReentrant {
1548         uint256[INFO_MAX] memory arrInfo = PUBLIC_SALE_getInfo( msg.sender );
1549 
1550         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "PUBLIC SALE: suspended" );
1551         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "PUBLIC SALE: not opend" );
1552         require( arrInfo[INFO_SALE_END] == 0 || arrInfo[INFO_SALE_END] > (block.timestamp-BLOCK_SEC_MARGIN), "PUBLIC SALE: finished" );
1553         require( arrInfo[INFO_SALE_WHITELISTED] == 1, "PUBLIC SALE: not whitelisted" );
1554         require( arrInfo[INFO_SALE_MAX_MINT] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "PUBLIC SALE: reached the limit" );
1555 
1556         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
1557 
1558         _mintTokens( msg.sender, num );
1559         _PUBLIC_SALE_mapMinted[msg.sender] += num;
1560     }
1561 
1562     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1563     // [public] getInfo - FINAL SALE
1564     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1565     function FINAL_SALE_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
1566         uint256[INFO_MAX] memory arrRet;
1567 
1568         if( _FINAL_SALE_isSuspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
1569         arrRet[INFO_SALE_START] = _FINAL_SALE_start;
1570         arrRet[INFO_SALE_END] = _FINAL_SALE_end;
1571         arrRet[INFO_SALE_PRICE] = _FINAL_SALE_price;
1572         arrRet[INFO_SALE_WHITELISTED] = 1;
1573         arrRet[INFO_SALE_MAX_MINT] = _FINAL_SALE_quantity;
1574         arrRet[INFO_SALE_USER_MINTED] = _FINAL_SALE_mapMinted[target];
1575 
1576         return( arrRet );
1577     }
1578 
1579     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1580     // [external/onlyOwnerOrManager] write - FINAL SALE
1581     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1582     // isSuspended
1583     function FINAL_SALE_suspend( bool flag ) external onlyOwnerOrManager {
1584         _FINAL_SALE_isSuspended = flag;
1585     }
1586 
1587     // start-end
1588     function FINAL_SALE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager {
1589         _FINAL_SALE_start = start;
1590         _FINAL_SALE_end = end;
1591     }
1592 
1593     // price
1594     function FINAL_SALE_setPrice( uint256 price ) external onlyOwnerOrManager {
1595         _FINAL_SALE_price = price;
1596     }
1597 
1598     // quantity
1599     function FINAL_SALE_setQuantity( uint256 quantity ) external onlyOwnerOrManager {
1600         _FINAL_SALE_quantity = quantity;
1601     }
1602 
1603     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1604     // [external/payable] mint - FINAL SALE
1605     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1606     function FINAL_SALE_mint( uint256 num ) external payable nonReentrant {
1607         uint256[INFO_MAX] memory arrInfo = FINAL_SALE_getInfo( msg.sender );
1608 
1609         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "FINAL SALE: suspended" );
1610         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "FINAL SALE: not opend" );
1611         require( arrInfo[INFO_SALE_END] == 0 || arrInfo[INFO_SALE_END] > (block.timestamp-BLOCK_SEC_MARGIN), "FINAL SALE: finished" );
1612         require( arrInfo[INFO_SALE_MAX_MINT] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "FINAL SALE: reached the limit" );
1613 
1614         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
1615 
1616         _mintTokens( msg.sender, num );
1617         _FINAL_SALE_mapMinted[msg.sender] += num;
1618     }
1619 
1620     //--------------------------------------------------------
1621     // [internal] _checkWhitelist
1622     //--------------------------------------------------------
1623     function _checkWhitelist( IWhiteList[] storage lists, address target, bool checkMinted ) internal view returns (bool) {
1624         if( checkMinted ){
1625             if( _MINTED_list.check( target ) ){
1626                 return( false );
1627             }
1628         }
1629 
1630         for( uint256 i=0; i<lists.length; i++ ){
1631             if( lists[i].check(target) ){
1632                 return( true);
1633             }
1634         }
1635 
1636         return( false );        
1637     }
1638 
1639     //--------------------------------------------------------
1640     // [internal] _checkPayment
1641     //--------------------------------------------------------
1642     function _checkPayment( address msgSender, uint256 price, uint256 payment ) internal {
1643         require( price <= payment, "insufficient value" );
1644 
1645         // refund if overpaymented
1646         if( price < payment ){
1647             uint256 change = payment - price;
1648             address payable target = payable( msgSender );
1649             target.transfer( change );
1650         }
1651     }
1652 
1653     //--------------------------------------------------------
1654     // [internal] _mintTokens
1655     //--------------------------------------------------------
1656     function _mintTokens( address to, uint256 num ) internal {
1657         require( _totalSupply >= (RESERVED_TOKEN+AIRDROP_TOKEN), "airdrop not finished" );
1658         require( (_totalSupply+num) <= _tokenMax, "exceeded the supply range" );
1659 
1660         for( uint256 i=0; i<num; i++ ){
1661             _mint( to, _totalSupply+(i+1) );
1662         }
1663         _totalSupply += num;
1664     }
1665 
1666     //--------------------------------------------------------
1667     // [external/onlyOwnerOrManager] reserveTokens
1668     //--------------------------------------------------------
1669     function reserveTokens( uint256 num ) external onlyOwnerOrManager {
1670         require( (_totalSupply+num) <= RESERVED_TOKEN, "exceeded the reservation range" );
1671 
1672         for( uint256 i=0; i<num; i++ ){
1673             _mint( owner(), _totalSupply+(i+1) );
1674         }
1675         _totalSupply += num;
1676     }
1677 
1678     //--------------------------------------------------------
1679     // [external/onlyOwnerOrManager] airdropTokens
1680     //--------------------------------------------------------
1681     function airdropTokens() external onlyOwnerOrManager {
1682         require( _totalSupply == RESERVED_TOKEN, "could not airdrop" );
1683 
1684         uint256 num = _AIRDROP_list.getTotal();
1685         require( num == AIRDROP_ADDRESS, "invalid airdrop list" );
1686 
1687         for( uint256 i=0; i<AIRDROP_ADDRESS; i++ ){
1688             address target = _AIRDROP_list.getAt( i );
1689             for( uint256 j=0; j<AIRDROP_TOKEN_PER_ADDRESS; j++ ){
1690                 _mint( target, _totalSupply+(1+AIRDROP_TOKEN_PER_ADDRESS*i+j) );
1691             }
1692         }
1693         _totalSupply += AIRDROP_TOKEN;
1694     }
1695 
1696     //--------------------------------------------------------
1697     // [external] getUserInfo
1698     //--------------------------------------------------------
1699     function getUserInfo( address target ) external view returns (uint256[USER_INFO_MAX] memory) {
1700         uint256[USER_INFO_MAX] memory userInfo;
1701         uint256[INFO_MAX] memory info;
1702 
1703         // WONDERLIST
1704         if( _checkWhitelist( _WONDERLIST_SALE_arrWhiteList, target, true ) && (_WONDERLIST_SALE_end == 0 || _WONDERLIST_SALE_end > block.timestamp) ){
1705             userInfo[USER_INFO_SALE] = 1;
1706             info = WONDERLIST_SALE_getInfo( target );
1707         }
1708         // WONDERKIDS
1709         else if( _checkWhitelist( _WONDERKIDS_SALE_arrWhiteList, target , true ) && (_WONDERKIDS_SALE_end == 0 || _WONDERKIDS_SALE_end > block.timestamp) ){
1710             userInfo[USER_INFO_SALE] = 2;
1711             info = WONDERKIDS_SALE_getInfo( target );
1712         }
1713         // PUBLIC
1714         else if( _checkWhitelist( _PUBLIC_SALE_arrWhiteList, target, false  ) && (_PUBLIC_SALE_end == 0 || _PUBLIC_SALE_end > block.timestamp) ){
1715             userInfo[USER_INFO_SALE] = 3;
1716             info = PUBLIC_SALE_getInfo( target );
1717         }
1718         // FINAL
1719         else{
1720             userInfo[USER_INFO_SALE] = 4;
1721             info = FINAL_SALE_getInfo( target );
1722         }
1723 
1724         for( uint256 i=0; i<INFO_MAX; i++ ){
1725             userInfo[i] = info[i];
1726         }
1727 
1728         userInfo[USER_INFO_SUPPLY] = _totalSupply;
1729         userInfo[USER_INFO_TOTAL] = _tokenMax;
1730 
1731         return( userInfo );
1732     }
1733 
1734     //--------------------------------------------------------
1735     // [external] checkBalance
1736     //--------------------------------------------------------
1737     function checkBalance() external view returns (uint256) {
1738         return( address(this).balance );
1739     }
1740 
1741     //--------------------------------------------------------
1742     // [external/onlyOwnerOrManager] withdraw
1743     //--------------------------------------------------------
1744     function withdraw( uint256 amount ) external onlyOwnerOrManager nonReentrant {
1745         require( amount <= address(this).balance, "insufficient balance" );
1746 
1747         address payable target = payable( owner() );
1748         target.transfer( amount );
1749     }
1750 
1751 }