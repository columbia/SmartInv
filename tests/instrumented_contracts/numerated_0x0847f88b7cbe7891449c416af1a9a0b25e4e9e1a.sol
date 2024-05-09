1 pragma solidity 0.8.16;
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
69 /**
70  * @dev Provides information about the current execution context, including the
71  * sender of the transaction and its data. While these are generally available
72  * via msg.sender and msg.data, they should not be accessed in such a direct
73  * manner, since when dealing with meta-transactions the account sending and
74  * paying for execution may not be the actual sender (as far as an application
75  * is concerned).
76  *
77  * This contract is only required for intermediate, library-like contracts.
78  */
79 abstract contract Context {
80     function _msgSender() internal view virtual returns (address) {
81         return msg.sender;
82     }
83 
84     function _msgData() internal view virtual returns (bytes calldata) {
85         return msg.data;
86     }
87 }
88 
89 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
90 /**
91  * @dev Contract module which provides a basic access control mechanism, where
92  * there is an account (an owner) that can be granted exclusive access to
93  * specific functions.
94  *
95  * By default, the owner account will be the one that deploys the contract. This
96  * can later be changed with {transferOwnership}.
97  *
98  * This module is used through inheritance. It will make available the modifier
99  * `onlyOwner`, which can be applied to your functions to restrict their use to
100  * the owner.
101  */
102 abstract contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     /**
108      * @dev Initializes the contract setting the deployer as the initial owner.
109      */
110     constructor() {
111         _transferOwnership(_msgSender());
112     }
113 
114     /**
115      * @dev Returns the address of the current owner.
116      */
117     function owner() public view virtual returns (address) {
118         return _owner;
119     }
120 
121     /**
122      * @dev Throws if called by any account other than the owner.
123      */
124     modifier onlyOwner() {
125         require(owner() == _msgSender(), "Ownable: caller is not the owner");
126         _;
127     }
128 
129     /**
130      * @dev Leaves the contract without owner. It will not be possible to call
131      * `onlyOwner` functions anymore. Can only be called by the current owner.
132      *
133      * NOTE: Renouncing ownership will leave the contract without an owner,
134      * thereby removing any functionality that is only available to the owner.
135      */
136     function renounceOwnership() public virtual onlyOwner {
137         _transferOwnership(address(0));
138     }
139 
140     /**
141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
142      * Can only be called by the current owner.
143      */
144     function transferOwnership(address newOwner) public virtual onlyOwner {
145         require(newOwner != address(0), "Ownable: new owner is the zero address");
146         _transferOwnership(newOwner);
147     }
148 
149     /**
150      * @dev Transfers ownership of the contract to a new account (`newOwner`).
151      * Internal function without access restriction.
152      */
153     function _transferOwnership(address newOwner) internal virtual {
154         address oldOwner = _owner;
155         _owner = newOwner;
156         emit OwnershipTransferred(oldOwner, newOwner);
157     }
158 }
159 
160 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
161 /**
162  * @dev Interface of the ERC165 standard, as defined in the
163  * https://eips.ethereum.org/EIPS/eip-165[EIP].
164  *
165  * Implementers can declare support of contract interfaces, which can then be
166  * queried by others ({ERC165Checker}).
167  *
168  * For an implementation, see {ERC165}.
169  */
170 interface IERC165 {
171     /**
172      * @dev Returns true if this contract implements the interface defined by
173      * `interfaceId`. See the corresponding
174      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
175      * to learn more about how these ids are created.
176      *
177      * This function call must use less than 30 000 gas.
178      */
179     function supportsInterface(bytes4 interfaceId) external view returns (bool);
180 }
181 
182 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
183 /**
184  * @dev Required interface of an ERC721 compliant contract.
185  */
186 interface IERC721 is IERC165 {
187     /**
188      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
189      */
190     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
191 
192     /**
193      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
194      */
195     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
196 
197     /**
198      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
199      */
200     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
201 
202     /**
203      * @dev Returns the number of tokens in ``owner``'s account.
204      */
205     function balanceOf(address owner) external view returns (uint256 balance);
206 
207     /**
208      * @dev Returns the owner of the `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function ownerOf(uint256 tokenId) external view returns (address owner);
215 
216     /**
217      * @dev Safely transfers `tokenId` token from `from` to `to`.
218      *
219      * Requirements:
220      *
221      * - `from` cannot be the zero address.
222      * - `to` cannot be the zero address.
223      * - `tokenId` token must exist and be owned by `from`.
224      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
225      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
226      *
227      * Emits a {Transfer} event.
228      */
229     function safeTransferFrom(
230         address from,
231         address to,
232         uint256 tokenId,
233         bytes calldata data
234     ) external;
235 
236     /**
237      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
238      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
239      *
240      * Requirements:
241      *
242      * - `from` cannot be the zero address.
243      * - `to` cannot be the zero address.
244      * - `tokenId` token must exist and be owned by `from`.
245      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
246      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
247      *
248      * Emits a {Transfer} event.
249      */
250     function safeTransferFrom(
251         address from,
252         address to,
253         uint256 tokenId
254     ) external;
255 
256     /**
257      * @dev Transfers `tokenId` token from `from` to `to`.
258      *
259      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
260      *
261      * Requirements:
262      *
263      * - `from` cannot be the zero address.
264      * - `to` cannot be the zero address.
265      * - `tokenId` token must be owned by `from`.
266      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transferFrom(
271         address from,
272         address to,
273         uint256 tokenId
274     ) external;
275 
276     /**
277      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
278      * The approval is cleared when the token is transferred.
279      *
280      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
281      *
282      * Requirements:
283      *
284      * - The caller must own the token or be an approved operator.
285      * - `tokenId` must exist.
286      *
287      * Emits an {Approval} event.
288      */
289     function approve(address to, uint256 tokenId) external;
290 
291     /**
292      * @dev Approve or remove `operator` as an operator for the caller.
293      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
294      *
295      * Requirements:
296      *
297      * - The `operator` cannot be the caller.
298      *
299      * Emits an {ApprovalForAll} event.
300      */
301     function setApprovalForAll(address operator, bool _approved) external;
302 
303     /**
304      * @dev Returns the account approved for `tokenId` token.
305      *
306      * Requirements:
307      *
308      * - `tokenId` must exist.
309      */
310     function getApproved(uint256 tokenId) external view returns (address operator);
311 
312     /**
313      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
314      *
315      * See {setApprovalForAll}
316      */
317     function isApprovedForAll(address owner, address operator) external view returns (bool);
318 }
319 
320 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
321 /**
322  * @title ERC721 token receiver interface
323  * @dev Interface for any contract that wants to support safeTransfers
324  * from ERC721 asset contracts.
325  */
326 interface IERC721Receiver {
327     /**
328      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
329      * by `operator` from `from`, this function is called.
330      *
331      * It must return its Solidity selector to confirm the token transfer.
332      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
333      *
334      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
335      */
336     function onERC721Received(
337         address operator,
338         address from,
339         uint256 tokenId,
340         bytes calldata data
341     ) external returns (bytes4);
342 }
343 
344 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
345 /**
346  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
347  * @dev See https://eips.ethereum.org/EIPS/eip-721
348  */
349 interface IERC721Metadata is IERC721 {
350     /**
351      * @dev Returns the token collection name.
352      */
353     function name() external view returns (string memory);
354 
355     /**
356      * @dev Returns the token collection symbol.
357      */
358     function symbol() external view returns (string memory);
359 
360     /**
361      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
362      */
363     function tokenURI(uint256 tokenId) external view returns (string memory);
364 }
365 
366 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
367 /**
368  * @dev Collection of functions related to the address type
369  */
370 library Address {
371     /**
372      * @dev Returns true if `account` is a contract.
373      *
374      * [IMPORTANT]
375      * ====
376      * It is unsafe to assume that an address for which this function returns
377      * false is an externally-owned account (EOA) and not a contract.
378      *
379      * Among others, `isContract` will return false for the following
380      * types of addresses:
381      *
382      *  - an externally-owned account
383      *  - a contract in construction
384      *  - an address where a contract will be created
385      *  - an address where a contract lived, but was destroyed
386      * ====
387      *
388      * [IMPORTANT]
389      * ====
390      * You shouldn't rely on `isContract` to protect against flash loan attacks!
391      *
392      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
393      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
394      * constructor.
395      * ====
396      */
397     function isContract(address account) internal view returns (bool) {
398         // This method relies on extcodesize/address.code.length, which returns 0
399         // for contracts in construction, since the code is only stored at the end
400         // of the constructor execution.
401 
402         return account.code.length > 0;
403     }
404 
405     /**
406      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
407      * `recipient`, forwarding all available gas and reverting on errors.
408      *
409      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
410      * of certain opcodes, possibly making contracts go over the 2300 gas limit
411      * imposed by `transfer`, making them unable to receive funds via
412      * `transfer`. {sendValue} removes this limitation.
413      *
414      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
415      *
416      * IMPORTANT: because control is transferred to `recipient`, care must be
417      * taken to not create reentrancy vulnerabilities. Consider using
418      * {ReentrancyGuard} or the
419      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
420      */
421     function sendValue(address payable recipient, uint256 amount) internal {
422         require(address(this).balance >= amount, "Address: insufficient balance");
423 
424         (bool success, ) = recipient.call{value: amount}("");
425         require(success, "Address: unable to send value, recipient may have reverted");
426     }
427 
428     /**
429      * @dev Performs a Solidity function call using a low level `call`. A
430      * plain `call` is an unsafe replacement for a function call: use this
431      * function instead.
432      *
433      * If `target` reverts with a revert reason, it is bubbled up by this
434      * function (like regular Solidity function calls).
435      *
436      * Returns the raw returned data. To convert to the expected return value,
437      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
438      *
439      * Requirements:
440      *
441      * - `target` must be a contract.
442      * - calling `target` with `data` must not revert.
443      *
444      * _Available since v3.1._
445      */
446     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
447         return functionCall(target, data, "Address: low-level call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
452      * `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal returns (bytes memory) {
461         return functionCallWithValue(target, data, 0, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but also transferring `value` wei to `target`.
467      *
468      * Requirements:
469      *
470      * - the calling contract must have an ETH balance of at least `value`.
471      * - the called Solidity function must be `payable`.
472      *
473      * _Available since v3.1._
474      */
475     function functionCallWithValue(
476         address target,
477         bytes memory data,
478         uint256 value
479     ) internal returns (bytes memory) {
480         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
485      * with `errorMessage` as a fallback revert reason when `target` reverts.
486      *
487      * _Available since v3.1._
488      */
489     function functionCallWithValue(
490         address target,
491         bytes memory data,
492         uint256 value,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         require(address(this).balance >= value, "Address: insufficient balance for call");
496         require(isContract(target), "Address: call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.call{value: value}(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a static call.
505      *
506      * _Available since v3.3._
507      */
508     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
509         return functionStaticCall(target, data, "Address: low-level static call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a static call.
515      *
516      * _Available since v3.3._
517      */
518     function functionStaticCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal view returns (bytes memory) {
523         require(isContract(target), "Address: static call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.staticcall(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
531      * but performing a delegate call.
532      *
533      * _Available since v3.4._
534      */
535     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
536         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
541      * but performing a delegate call.
542      *
543      * _Available since v3.4._
544      */
545     function functionDelegateCall(
546         address target,
547         bytes memory data,
548         string memory errorMessage
549     ) internal returns (bytes memory) {
550         require(isContract(target), "Address: delegate call to non-contract");
551 
552         (bool success, bytes memory returndata) = target.delegatecall(data);
553         return verifyCallResult(success, returndata, errorMessage);
554     }
555 
556     /**
557      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
558      * revert reason using the provided one.
559      *
560      * _Available since v4.3._
561      */
562     function verifyCallResult(
563         bool success,
564         bytes memory returndata,
565         string memory errorMessage
566     ) internal pure returns (bytes memory) {
567         if (success) {
568             return returndata;
569         } else {
570             // Look for revert reason and bubble it up if present
571             if (returndata.length > 0) {
572                 // The easiest way to bubble the revert reason is using memory via assembly
573 
574                 assembly {
575                     let returndata_size := mload(returndata)
576                     revert(add(32, returndata), returndata_size)
577                 }
578             } else {
579                 revert(errorMessage);
580             }
581         }
582     }
583 }
584 
585 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
586 /**
587  * @dev Implementation of the {IERC165} interface.
588  *
589  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
590  * for the additional interface id that will be supported. For example:
591  *
592  * ```solidity
593  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
594  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
595  * }
596  * ```
597  *
598  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
599  */
600 abstract contract ERC165 is IERC165 {
601     /**
602      * @dev See {IERC165-supportsInterface}.
603      */
604     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
605         return interfaceId == type(IERC165).interfaceId;
606     }
607 }
608 
609 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
610 /**
611  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
612  * the Metadata extension, but not including the Enumerable extension, which is available separately as
613  * {ERC721Enumerable}.
614  */
615 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
616     using Address for address;
617     using Strings for uint256;
618 
619     // Token name
620     string private _name;
621 
622     // Token symbol
623     string private _symbol;
624 
625     // Mapping from token ID to owner address
626     mapping(uint256 => address) private _owners;
627 
628     // Mapping owner address to token count
629     mapping(address => uint256) private _balances;
630 
631     // Mapping from token ID to approved address
632     mapping(uint256 => address) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     /**
638      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
639      */
640     constructor(string memory name_, string memory symbol_) {
641         _name = name_;
642         _symbol = symbol_;
643     }
644 
645     /**
646      * @dev See {IERC165-supportsInterface}.
647      */
648     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
649         return
650             interfaceId == type(IERC721).interfaceId ||
651             interfaceId == type(IERC721Metadata).interfaceId ||
652             super.supportsInterface(interfaceId);
653     }
654 
655     /**
656      * @dev See {IERC721-balanceOf}.
657      */
658     function balanceOf(address owner) public view virtual override returns (uint256) {
659         require(owner != address(0), "ERC721: balance query for the zero address");
660         return _balances[owner];
661     }
662 
663     /**
664      * @dev See {IERC721-ownerOf}.
665      */
666     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
667         address owner = _owners[tokenId];
668         require(owner != address(0), "ERC721: owner query for nonexistent token");
669         return owner;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-name}.
674      */
675     function name() public view virtual override returns (string memory) {
676         return _name;
677     }
678 
679     /**
680      * @dev See {IERC721Metadata-symbol}.
681      */
682     function symbol() public view virtual override returns (string memory) {
683         return _symbol;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-tokenURI}.
688      */
689     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
690         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
691 
692         string memory baseURI = _baseURI();
693         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
694     }
695 
696     /**
697      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
698      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
699      * by default, can be overridden in child contracts.
700      */
701     function _baseURI() internal view virtual returns (string memory) {
702         return "";
703     }
704 
705     /**
706      * @dev See {IERC721-approve}.
707      */
708     function approve(address to, uint256 tokenId) public virtual override {
709         address owner = ERC721.ownerOf(tokenId);
710         require(to != owner, "ERC721: approval to current owner");
711 
712         require(
713             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
714             "ERC721: approve caller is not owner nor approved for all"
715         );
716 
717         _approve(to, tokenId);
718     }
719 
720     /**
721      * @dev See {IERC721-getApproved}.
722      */
723     function getApproved(uint256 tokenId) public view virtual override returns (address) {
724         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
725 
726         return _tokenApprovals[tokenId];
727     }
728 
729     /**
730      * @dev See {IERC721-setApprovalForAll}.
731      */
732     function setApprovalForAll(address operator, bool approved) public virtual override {
733         _setApprovalForAll(_msgSender(), operator, approved);
734     }
735 
736     /**
737      * @dev See {IERC721-isApprovedForAll}.
738      */
739     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
740         return _operatorApprovals[owner][operator];
741     }
742 
743     /**
744      * @dev See {IERC721-transferFrom}.
745      */
746     function transferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         //solhint-disable-next-line max-line-length
752         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
753 
754         _transfer(from, to, tokenId);
755     }
756 
757     /**
758      * @dev See {IERC721-safeTransferFrom}.
759      */
760     function safeTransferFrom(
761         address from,
762         address to,
763         uint256 tokenId
764     ) public virtual override {
765         safeTransferFrom(from, to, tokenId, "");
766     }
767 
768     /**
769      * @dev See {IERC721-safeTransferFrom}.
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) public virtual override {
777         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
778         _safeTransfer(from, to, tokenId, _data);
779     }
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
786      *
787      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
788      * implement alternative mechanisms to perform token transfer, such as signature-based.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function _safeTransfer(
800         address from,
801         address to,
802         uint256 tokenId,
803         bytes memory _data
804     ) internal virtual {
805         _transfer(from, to, tokenId);
806         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
807     }
808 
809     /**
810      * @dev Returns whether `tokenId` exists.
811      *
812      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
813      *
814      * Tokens start existing when they are minted (`_mint`),
815      * and stop existing when they are burned (`_burn`).
816      */
817     function _exists(uint256 tokenId) internal view virtual returns (bool) {
818         return _owners[tokenId] != address(0);
819     }
820 
821     /**
822      * @dev Returns whether `spender` is allowed to manage `tokenId`.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
829         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
830         address owner = ERC721.ownerOf(tokenId);
831         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
832     }
833 
834     /**
835      * @dev Safely mints `tokenId` and transfers it to `to`.
836      *
837      * Requirements:
838      *
839      * - `tokenId` must not exist.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _safeMint(address to, uint256 tokenId) internal virtual {
845         _safeMint(to, tokenId, "");
846     }
847 
848     /**
849      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
850      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
851      */
852     function _safeMint(
853         address to,
854         uint256 tokenId,
855         bytes memory _data
856     ) internal virtual {
857         _mint(to, tokenId);
858         require(
859             _checkOnERC721Received(address(0), to, tokenId, _data),
860             "ERC721: transfer to non ERC721Receiver implementer"
861         );
862     }
863 
864     /**
865      * @dev Mints `tokenId` and transfers it to `to`.
866      *
867      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
868      *
869      * Requirements:
870      *
871      * - `tokenId` must not exist.
872      * - `to` cannot be the zero address.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _mint(address to, uint256 tokenId) internal virtual {
877         require(to != address(0), "ERC721: mint to the zero address");
878         require(!_exists(tokenId), "ERC721: token already minted");
879 
880         _beforeTokenTransfer(address(0), to, tokenId);
881 
882         _balances[to] += 1;
883         _owners[tokenId] = to;
884 
885         emit Transfer(address(0), to, tokenId);
886 
887         _afterTokenTransfer(address(0), to, tokenId);
888     }
889 
890     /**
891      * @dev Destroys `tokenId`.
892      * The approval is cleared when the token is burned.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _burn(uint256 tokenId) internal virtual {
901         address owner = ERC721.ownerOf(tokenId);
902 
903         _beforeTokenTransfer(owner, address(0), tokenId);
904 
905         // Clear approvals
906         _approve(address(0), tokenId);
907 
908         _balances[owner] -= 1;
909         delete _owners[tokenId];
910 
911         emit Transfer(owner, address(0), tokenId);
912 
913         _afterTokenTransfer(owner, address(0), tokenId);
914     }
915 
916     /**
917      * @dev Transfers `tokenId` from `from` to `to`.
918      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
919      *
920      * Requirements:
921      *
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must be owned by `from`.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _transfer(
928         address from,
929         address to,
930         uint256 tokenId
931     ) internal virtual {
932         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
933         require(to != address(0), "ERC721: transfer to the zero address");
934 
935         _beforeTokenTransfer(from, to, tokenId);
936 
937         // Clear approvals from the previous owner
938         _approve(address(0), tokenId);
939 
940         _balances[from] -= 1;
941         _balances[to] += 1;
942         _owners[tokenId] = to;
943 
944         emit Transfer(from, to, tokenId);
945 
946         _afterTokenTransfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev Approve `to` to operate on `tokenId`
951      *
952      * Emits a {Approval} event.
953      */
954     function _approve(address to, uint256 tokenId) internal virtual {
955         _tokenApprovals[tokenId] = to;
956         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
957     }
958 
959     /**
960      * @dev Approve `operator` to operate on all of `owner` tokens
961      *
962      * Emits a {ApprovalForAll} event.
963      */
964     function _setApprovalForAll(
965         address owner,
966         address operator,
967         bool approved
968     ) internal virtual {
969         require(owner != operator, "ERC721: approve to caller");
970         _operatorApprovals[owner][operator] = approved;
971         emit ApprovalForAll(owner, operator, approved);
972     }
973 
974     /**
975      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
976      * The call is not executed if the target address is not a contract.
977      *
978      * @param from address representing the previous owner of the given token ID
979      * @param to target address that will receive the tokens
980      * @param tokenId uint256 ID of the token to be transferred
981      * @param _data bytes optional data to send along with the call
982      * @return bool whether the call correctly returned the expected magic value
983      */
984     function _checkOnERC721Received(
985         address from,
986         address to,
987         uint256 tokenId,
988         bytes memory _data
989     ) private returns (bool) {
990         if (to.isContract()) {
991             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
992                 return retval == IERC721Receiver.onERC721Received.selector;
993             } catch (bytes memory reason) {
994                 if (reason.length == 0) {
995                     revert("ERC721: transfer to non ERC721Receiver implementer");
996                 } else {
997                     assembly {
998                         revert(add(32, reason), mload(reason))
999                     }
1000                 }
1001             }
1002         } else {
1003             return true;
1004         }
1005     }
1006 
1007     /**
1008      * @dev Hook that is called before any token transfer. This includes minting
1009      * and burning.
1010      *
1011      * Calling conditions:
1012      *
1013      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1014      * transferred to `to`.
1015      * - When `from` is zero, `tokenId` will be minted for `to`.
1016      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1017      * - `from` and `to` are never both zero.
1018      *
1019      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1020      */
1021     function _beforeTokenTransfer(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) internal virtual {}
1026 
1027     /**
1028      * @dev Hook that is called after any transfer of tokens. This includes
1029      * minting and burning.
1030      *
1031      * Calling conditions:
1032      *
1033      * - when `from` and `to` are both non-zero.
1034      * - `from` and `to` are never both zero.
1035      *
1036      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1037      */
1038     function _afterTokenTransfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) internal virtual {}
1043 }
1044 
1045 interface IOperatorFilterRegistry {
1046     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1047     function register(address registrant) external;
1048     function registerAndSubscribe(address registrant, address subscription) external;
1049     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1050     function unregister(address addr) external;
1051     function updateOperator(address registrant, address operator, bool filtered) external;
1052     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1053     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1054     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1055     function subscribe(address registrant, address registrantToSubscribe) external;
1056     function unsubscribe(address registrant, bool copyExistingEntries) external;
1057     function subscriptionOf(address addr) external returns (address registrant);
1058     function subscribers(address registrant) external returns (address[] memory);
1059     function subscriberAt(address registrant, uint256 index) external returns (address);
1060     function copyEntriesOf(address registrant, address registrantToCopy) external;
1061     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1062     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1063     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1064     function filteredOperators(address addr) external returns (address[] memory);
1065     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1066     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1067     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1068     function isRegistered(address addr) external returns (bool);
1069     function codeHashOf(address addr) external returns (bytes32);
1070 }
1071 
1072 abstract contract OperatorFilterer {
1073     error OperatorNotAllowed(address operator);
1074 
1075     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1076         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1077 
1078     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1079         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1080         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1081         // order for the modifier to filter addresses.
1082         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1083             if (subscribe) {
1084                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1085             } else {
1086                 if (subscriptionOrRegistrantToCopy != address(0)) {
1087                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1088                 } else {
1089                     OPERATOR_FILTER_REGISTRY.register(address(this));
1090                 }
1091             }
1092         }
1093     }
1094 
1095     modifier onlyAllowedOperator(address from) virtual {
1096         // Allow spending tokens from addresses with balance
1097         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1098         // from an EOA.
1099         if (from != msg.sender) {
1100             _checkFilterOperator(msg.sender);
1101         }
1102         _;
1103     }
1104 
1105     modifier onlyAllowedOperatorApproval(address operator) virtual {
1106         _checkFilterOperator(operator);
1107         _;
1108     }
1109 
1110     function _checkFilterOperator(address operator) internal view virtual {
1111         // Check registry code length to facilitate testing in environments without a deployed registry.
1112         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1113             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1114                 revert OperatorNotAllowed(operator);
1115             }
1116         }
1117     }
1118 }
1119 
1120 /**
1121  * @title  DefaultOperatorFilterer
1122  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1123  */
1124 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1125     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1126 
1127     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1128 }
1129 
1130 contract TheLocals is Ownable, ERC721, DefaultOperatorFilterer {
1131   using Strings for uint256;
1132 
1133   string private placeholder;
1134   string private _name;
1135   string private _symbol;
1136 
1137   string public baseURI;
1138   address public saleManager;
1139   uint256 public maxSupply;
1140   uint256 public totalSupply;
1141 
1142   mapping (address => bool) private cornMasterOperators;
1143 
1144   mapping(uint256 => uint256) private workStarted;
1145   mapping(uint256 => uint256) private totalWork;
1146 
1147   /**
1148   @dev MUST only be modified by safeTransferWhileSeeding(); if set to 2 then
1149   the _beforeTokenTransfer() block while seeding is disabled.
1150     */
1151   bool private blockTransfer = true;
1152 
1153   /**
1154     @notice Whether working is currently allowed.
1155     @dev If false then working is blocked, but stopWorking is always allowed.
1156   */
1157   bool public workPeriodOpen = false;
1158 
1159   event Work(uint256 indexed tokenId);
1160   event Rest(uint256 indexed tokenId);
1161   event Fired(uint256 indexed tokenId);
1162   event BaseURI(string baseUri);
1163 
1164   constructor(
1165     string memory _name_,
1166     string memory _symbol_,
1167     uint256 _maxSupply,
1168     string memory _placeholder
1169   ) ERC721(_name_, _symbol_) {
1170     maxSupply = _maxSupply;
1171     placeholder = _placeholder;
1172 
1173     setNameAndSymbol(_name_, _symbol_);
1174   }
1175 
1176   modifier onlySaleManager() {
1177     require(msg.sender == saleManager, "only sale manager");
1178     _;
1179   }
1180 
1181   /// @notice Requires that msg.sender owns or is approved for the token.
1182   modifier onlyApprovedOrTokenOwner(uint256 tokenId) {
1183     require(
1184       ownerOf(tokenId) == msg.sender || getApproved(tokenId) == msg.sender || isApprovedForAll(ownerOf(tokenId), msg.sender),
1185       "CornTown: Not approved nor owner"
1186     );
1187     _;
1188   }
1189 
1190   function setNameAndSymbol(string memory _name_, string memory _symbol_) public onlyOwner {
1191     _name = _name_;
1192     _symbol = _symbol_;
1193   }
1194 
1195   function name() public view override returns (string memory) {
1196     return _name;
1197   }
1198 
1199   function symbol() public view override returns (string memory) {
1200     return _symbol;
1201   }
1202 
1203   function setPlaceholder(string memory _placeholder) public onlyOwner {
1204     placeholder = _placeholder;
1205   } 
1206 
1207   function setBaseURI(string memory _baseUri) external onlyOwner {
1208     baseURI = _baseUri;
1209   }
1210 
1211   function _baseURI() internal view override returns (string memory) {
1212     return baseURI;
1213   }
1214 
1215   function tokenURI(uint256 tokenId) public view override returns (string memory) {
1216     if(!_exists(tokenId)) {
1217       return placeholder;
1218     }
1219 
1220     return bytes(baseURI).length > 0 ? string(abi.encodePacked(_baseURI(), tokenId.toString())) : placeholder;
1221   }
1222 
1223   function exits(uint256 tokenId) external view returns (bool) {
1224     return _exists(tokenId);
1225   }
1226 
1227   function mint(address to, uint256 tokenId) external onlySaleManager {
1228     totalSupply += 1;
1229     require(totalSupply <= maxSupply, "maxSupply");
1230 
1231     _safeMint(to, tokenId);
1232   }
1233 
1234   /// @notice Set the address for the saleManager
1235   /// @param _saleManager: address of the sale contract
1236   function setSaleManager(address _saleManager) external onlyOwner {
1237     saleManager = _saleManager;
1238   }
1239 
1240   function setOperator(address _operator) external onlyOwner {
1241     cornMasterOperators[_operator] = true;
1242   }
1243 
1244   function disableOperator(address _operator) external onlyOwner {
1245     cornMasterOperators[_operator] = false;
1246   }
1247 
1248   function isApprovedForAll(address owner, address operator) public override view returns (bool) {
1249     if (cornMasterOperators[operator]) {
1250       return true;
1251     }
1252 
1253     return super.isApprovedForAll(owner, operator);
1254   }
1255 
1256   /**
1257     @notice Returns the length of time, in seconds, that the Local has
1258     been working.
1259     @dev Working is tied to a specific Local, not to the owner, so it doesn't
1260     reset upon sale.
1261     @return working Whether the Local is currently working. MAY be true with
1262     zero current seeding if in the same block as working began.
1263     @return current Zero if not currently working, otherwise the length of time
1264     since the most recent working began.
1265     @return total Total period of time for which the Local has worked across
1266     its life, including the current period.
1267   */
1268   function workingPeriod(uint256 tokenId) external view returns (
1269     bool working,
1270     uint256 current,
1271     uint256 total
1272   ) {
1273     uint256 start = workStarted[tokenId];
1274 
1275     if (start != 0) {
1276       working = true;
1277       current = block.timestamp - start;
1278     }
1279 
1280     total = current + totalWork[tokenId];
1281   }
1282 
1283   /**
1284     @notice Transfer a Local between addresses while the Local is at work, thus not resetting the working experience.
1285   */
1286   function relocateWhileWorking(
1287     address from,
1288     address to,
1289     uint256 tokenId
1290   ) external {
1291     require(ownerOf(tokenId) == msg.sender, "CornTown: Only owner");
1292 
1293     blockTransfer = false;
1294     safeTransferFrom(from, to, tokenId);
1295     blockTransfer = true;
1296   }
1297 
1298   /**
1299     @dev Block transfers while seeding.
1300   */
1301   function _beforeTokenTransfer(address, address, uint256 tokenId) internal view override {
1302     require(
1303       workStarted[tokenId] == 0 || !blockTransfer,
1304       "CornTown: working"
1305     );
1306   }
1307 
1308   /**
1309     @notice Toggles the `toggleWorking` option.
1310   */
1311   function setWorkingStart(bool open) external onlyOwner {
1312     workPeriodOpen = open;
1313   }
1314 
1315   function _toggleWorking(uint256 tokenId) internal onlyApprovedOrTokenOwner(tokenId) {
1316     uint256 start = workStarted[tokenId];
1317 
1318     if (start == 0) {
1319       require(workPeriodOpen, "CornTown: work closed");
1320 
1321       workStarted[tokenId] = block.timestamp;
1322 
1323       emit Work(tokenId);
1324     } else {
1325       totalWork[tokenId] += block.timestamp - start;
1326       workStarted[tokenId] = 0;
1327 
1328       emit Rest(tokenId);
1329     }
1330   }
1331 
1332   /**
1333     @notice Changes the Local working status.
1334     @dev Changes the Local working status (see @notice).
1335   */
1336   function toggleWorking(uint256[] calldata tokenIds) external {
1337     uint256 n = tokenIds.length;
1338 
1339     for (uint256 i = 0; i < n; ++i) {
1340       _toggleWorking(tokenIds[i]);
1341     }
1342   }
1343 
1344   /**
1345     @notice Admin-only ability to Fire a Local from work.
1346     As most sales listings use off-chain signatures it's impossible to detect someone who has set
1347     a local to work and then deliberately listed it on marketplaces iknowing that the sale can't proceed.
1348     This function allows for monitoring of such practices and expulsion if abuse is detected, allowing all
1349     bad workers to be sold on the open market. 
1350   */
1351   function fireFromJob(uint256 tokenId) external onlyOwner {
1352     require(workStarted[tokenId] != 0, "CornTown: not seeding");
1353 
1354     totalWork[tokenId] += block.timestamp - workStarted[tokenId];
1355     workStarted[tokenId] = 0;
1356 
1357     emit Rest(tokenId);
1358     emit Fired(tokenId);
1359   }
1360 
1361   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1362     super.setApprovalForAll(operator, approved);
1363   }
1364 
1365   function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1366     super.approve(operator, tokenId);
1367   }
1368 
1369   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1370     super.transferFrom(from, to, tokenId);
1371   }
1372 
1373   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1374     super.safeTransferFrom(from, to, tokenId);
1375   }
1376 
1377   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1378     public
1379     override
1380     onlyAllowedOperator(from)
1381   {
1382     super.safeTransferFrom(from, to, tokenId, data);
1383   }
1384 }