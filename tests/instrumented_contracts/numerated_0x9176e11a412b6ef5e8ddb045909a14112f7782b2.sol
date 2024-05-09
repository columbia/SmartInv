1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.9.0 https://hardhat.org
3 
4 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 
74 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 
102 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
106 
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 
180 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
184 
185 
186 
187 /**
188  * @dev Interface of the ERC165 standard, as defined in the
189  * https://eips.ethereum.org/EIPS/eip-165[EIP].
190  *
191  * Implementers can declare support of contract interfaces, which can then be
192  * queried by others ({ERC165Checker}).
193  *
194  * For an implementation, see {ERC165}.
195  */
196 interface IERC165 {
197     /**
198      * @dev Returns true if this contract implements the interface defined by
199      * `interfaceId`. See the corresponding
200      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
201      * to learn more about how these ids are created.
202      *
203      * This function call must use less than 30 000 gas.
204      */
205     function supportsInterface(bytes4 interfaceId) external view returns (bool);
206 }
207 
208 
209 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
210 
211 
212 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
213 
214 
215 
216 /**
217  * @dev Required interface of an ERC721 compliant contract.
218  */
219 interface IERC721 is IERC165 {
220     /**
221      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
224 
225     /**
226      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
227      */
228     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
229 
230     /**
231      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
232      */
233     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
234 
235     /**
236      * @dev Returns the number of tokens in ``owner``'s account.
237      */
238     function balanceOf(address owner) external view returns (uint256 balance);
239 
240     /**
241      * @dev Returns the owner of the `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function ownerOf(uint256 tokenId) external view returns (address owner);
248 
249     /**
250      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
251      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
252      *
253      * Requirements:
254      *
255      * - `from` cannot be the zero address.
256      * - `to` cannot be the zero address.
257      * - `tokenId` token must exist and be owned by `from`.
258      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
259      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
260      *
261      * Emits a {Transfer} event.
262      */
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId
267     ) external;
268 
269     /**
270      * @dev Transfers `tokenId` token from `from` to `to`.
271      *
272      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
273      *
274      * Requirements:
275      *
276      * - `from` cannot be the zero address.
277      * - `to` cannot be the zero address.
278      * - `tokenId` token must be owned by `from`.
279      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(
284         address from,
285         address to,
286         uint256 tokenId
287     ) external;
288 
289     /**
290      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
291      * The approval is cleared when the token is transferred.
292      *
293      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
294      *
295      * Requirements:
296      *
297      * - The caller must own the token or be an approved operator.
298      * - `tokenId` must exist.
299      *
300      * Emits an {Approval} event.
301      */
302     function approve(address to, uint256 tokenId) external;
303 
304     /**
305      * @dev Returns the account approved for `tokenId` token.
306      *
307      * Requirements:
308      *
309      * - `tokenId` must exist.
310      */
311     function getApproved(uint256 tokenId) external view returns (address operator);
312 
313     /**
314      * @dev Approve or remove `operator` as an operator for the caller.
315      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
316      *
317      * Requirements:
318      *
319      * - The `operator` cannot be the caller.
320      *
321      * Emits an {ApprovalForAll} event.
322      */
323     function setApprovalForAll(address operator, bool _approved) external;
324 
325     /**
326      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
327      *
328      * See {setApprovalForAll}
329      */
330     function isApprovedForAll(address owner, address operator) external view returns (bool);
331 
332     /**
333      * @dev Safely transfers `tokenId` token from `from` to `to`.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `tokenId` token must exist and be owned by `from`.
340      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
341      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
342      *
343      * Emits a {Transfer} event.
344      */
345     function safeTransferFrom(
346         address from,
347         address to,
348         uint256 tokenId,
349         bytes calldata data
350     ) external;
351 }
352 
353 
354 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
358 
359 
360 
361 /**
362  * @title ERC721 token receiver interface
363  * @dev Interface for any contract that wants to support safeTransfers
364  * from ERC721 asset contracts.
365  */
366 interface IERC721Receiver {
367     /**
368      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
369      * by `operator` from `from`, this function is called.
370      *
371      * It must return its Solidity selector to confirm the token transfer.
372      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
373      *
374      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
375      */
376     function onERC721Received(
377         address operator,
378         address from,
379         uint256 tokenId,
380         bytes calldata data
381     ) external returns (bytes4);
382 }
383 
384 
385 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
389 
390 
391 
392 /**
393  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
394  * @dev See https://eips.ethereum.org/EIPS/eip-721
395  */
396 interface IERC721Metadata is IERC721 {
397     /**
398      * @dev Returns the token collection name.
399      */
400     function name() external view returns (string memory);
401 
402     /**
403      * @dev Returns the token collection symbol.
404      */
405     function symbol() external view returns (string memory);
406 
407     /**
408      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
409      */
410     function tokenURI(uint256 tokenId) external view returns (string memory);
411 }
412 
413 
414 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
415 
416 
417 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
418 
419 /**
420  * @dev Collection of functions related to the address type
421  */
422 library Address {
423     /**
424      * @dev Returns true if `account` is a contract.
425      *
426      * [IMPORTANT]
427      * ====
428      * It is unsafe to assume that an address for which this function returns
429      * false is an externally-owned account (EOA) and not a contract.
430      *
431      * Among others, `isContract` will return false for the following
432      * types of addresses:
433      *
434      *  - an externally-owned account
435      *  - a contract in construction
436      *  - an address where a contract will be created
437      *  - an address where a contract lived, but was destroyed
438      * ====
439      *
440      * [IMPORTANT]
441      * ====
442      * You shouldn't rely on `isContract` to protect against flash loan attacks!
443      *
444      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
445      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
446      * constructor.
447      * ====
448      */
449     function isContract(address account) internal view returns (bool) {
450         // This method relies on extcodesize/address.code.length, which returns 0
451         // for contracts in construction, since the code is only stored at the end
452         // of the constructor execution.
453 
454         return account.code.length > 0;
455     }
456 
457     /**
458      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
459      * `recipient`, forwarding all available gas and reverting on errors.
460      *
461      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
462      * of certain opcodes, possibly making contracts go over the 2300 gas limit
463      * imposed by `transfer`, making them unable to receive funds via
464      * `transfer`. {sendValue} removes this limitation.
465      *
466      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
467      *
468      * IMPORTANT: because control is transferred to `recipient`, care must be
469      * taken to not create reentrancy vulnerabilities. Consider using
470      * {ReentrancyGuard} or the
471      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
472      */
473     function sendValue(address payable recipient, uint256 amount) internal {
474         require(address(this).balance >= amount, "Address: insufficient balance");
475 
476         (bool success, ) = recipient.call{value: amount}("");
477         require(success, "Address: unable to send value, recipient may have reverted");
478     }
479 
480     /**
481      * @dev Performs a Solidity function call using a low level `call`. A
482      * plain `call` is an unsafe replacement for a function call: use this
483      * function instead.
484      *
485      * If `target` reverts with a revert reason, it is bubbled up by this
486      * function (like regular Solidity function calls).
487      *
488      * Returns the raw returned data. To convert to the expected return value,
489      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
490      *
491      * Requirements:
492      *
493      * - `target` must be a contract.
494      * - calling `target` with `data` must not revert.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionCall(target, data, "Address: low-level call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
504      * `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         return functionCallWithValue(target, data, 0, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but also transferring `value` wei to `target`.
519      *
520      * Requirements:
521      *
522      * - the calling contract must have an ETH balance of at least `value`.
523      * - the called Solidity function must be `payable`.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value
531     ) internal returns (bytes memory) {
532         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
537      * with `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         require(address(this).balance >= value, "Address: insufficient balance for call");
548         require(isContract(target), "Address: call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.call{value: value}(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a static call.
557      *
558      * _Available since v3.3._
559      */
560     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
561         return functionStaticCall(target, data, "Address: low-level static call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a static call.
567      *
568      * _Available since v3.3._
569      */
570     function functionStaticCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal view returns (bytes memory) {
575         require(isContract(target), "Address: static call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.staticcall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
588         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a delegate call.
594      *
595      * _Available since v3.4._
596      */
597     function functionDelegateCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         require(isContract(target), "Address: delegate call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.delegatecall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
610      * revert reason using the provided one.
611      *
612      * _Available since v4.3._
613      */
614     function verifyCallResult(
615         bool success,
616         bytes memory returndata,
617         string memory errorMessage
618     ) internal pure returns (bytes memory) {
619         if (success) {
620             return returndata;
621         } else {
622             // Look for revert reason and bubble it up if present
623             if (returndata.length > 0) {
624                 // The easiest way to bubble the revert reason is using memory via assembly
625 
626                 assembly {
627                     let returndata_size := mload(returndata)
628                     revert(add(32, returndata), returndata_size)
629                 }
630             } else {
631                 revert(errorMessage);
632             }
633         }
634     }
635 }
636 
637 
638 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
642 
643 
644 
645 /**
646  * @dev Implementation of the {IERC165} interface.
647  *
648  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
649  * for the additional interface id that will be supported. For example:
650  *
651  * ```solidity
652  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
653  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
654  * }
655  * ```
656  *
657  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
658  */
659 abstract contract ERC165 is IERC165 {
660     /**
661      * @dev See {IERC165-supportsInterface}.
662      */
663     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
664         return interfaceId == type(IERC165).interfaceId;
665     }
666 }
667 
668 
669 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
670 
671 
672 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
673 
674 
675 
676 
677 
678 
679 
680 
681 
682 /**
683  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
684  * the Metadata extension, but not including the Enumerable extension, which is available separately as
685  * {ERC721Enumerable}.
686  */
687 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
688     using Address for address;
689     using Strings for uint256;
690 
691     // Token name
692     string private _name;
693 
694     // Token symbol
695     string private _symbol;
696 
697     // Mapping from token ID to owner address
698     mapping(uint256 => address) private _owners;
699 
700     // Mapping owner address to token count
701     mapping(address => uint256) private _balances;
702 
703     // Mapping from token ID to approved address
704     mapping(uint256 => address) private _tokenApprovals;
705 
706     // Mapping from owner to operator approvals
707     mapping(address => mapping(address => bool)) private _operatorApprovals;
708 
709     /**
710      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
711      */
712     constructor(string memory name_, string memory symbol_) {
713         _name = name_;
714         _symbol = symbol_;
715     }
716 
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
721         return
722             interfaceId == type(IERC721).interfaceId ||
723             interfaceId == type(IERC721Metadata).interfaceId ||
724             super.supportsInterface(interfaceId);
725     }
726 
727     /**
728      * @dev See {IERC721-balanceOf}.
729      */
730     function balanceOf(address owner) public view virtual override returns (uint256) {
731         require(owner != address(0), "ERC721: balance query for the zero address");
732         return _balances[owner];
733     }
734 
735     /**
736      * @dev See {IERC721-ownerOf}.
737      */
738     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
739         address owner = _owners[tokenId];
740         require(owner != address(0), "ERC721: owner query for nonexistent token");
741         return owner;
742     }
743 
744     /**
745      * @dev See {IERC721Metadata-name}.
746      */
747     function name() public view virtual override returns (string memory) {
748         return _name;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-symbol}.
753      */
754     function symbol() public view virtual override returns (string memory) {
755         return _symbol;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-tokenURI}.
760      */
761     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
762         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
763 
764         string memory baseURI = _baseURI();
765         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
766     }
767 
768     /**
769      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
770      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
771      * by default, can be overriden in child contracts.
772      */
773     function _baseURI() internal view virtual returns (string memory) {
774         return "";
775     }
776 
777     /**
778      * @dev See {IERC721-approve}.
779      */
780     function approve(address to, uint256 tokenId) public virtual override {
781         address owner = ERC721.ownerOf(tokenId);
782         require(to != owner, "ERC721: approval to current owner");
783 
784         require(
785             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
786             "ERC721: approve caller is not owner nor approved for all"
787         );
788 
789         _approve(to, tokenId);
790     }
791 
792     /**
793      * @dev See {IERC721-getApproved}.
794      */
795     function getApproved(uint256 tokenId) public view virtual override returns (address) {
796         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
797 
798         return _tokenApprovals[tokenId];
799     }
800 
801     /**
802      * @dev See {IERC721-setApprovalForAll}.
803      */
804     function setApprovalForAll(address operator, bool approved) public virtual override {
805         _setApprovalForAll(_msgSender(), operator, approved);
806     }
807 
808     /**
809      * @dev See {IERC721-isApprovedForAll}.
810      */
811     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
812         return _operatorApprovals[owner][operator];
813     }
814 
815     /**
816      * @dev See {IERC721-transferFrom}.
817      */
818     function transferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) public virtual override {
823         //solhint-disable-next-line max-line-length
824         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
825 
826         _transfer(from, to, tokenId);
827     }
828 
829     /**
830      * @dev See {IERC721-safeTransferFrom}.
831      */
832     function safeTransferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) public virtual override {
837         safeTransferFrom(from, to, tokenId, "");
838     }
839 
840     /**
841      * @dev See {IERC721-safeTransferFrom}.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) public virtual override {
849         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
850         _safeTransfer(from, to, tokenId, _data);
851     }
852 
853     /**
854      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
855      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
856      *
857      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
858      *
859      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
860      * implement alternative mechanisms to perform token transfer, such as signature-based.
861      *
862      * Requirements:
863      *
864      * - `from` cannot be the zero address.
865      * - `to` cannot be the zero address.
866      * - `tokenId` token must exist and be owned by `from`.
867      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _safeTransfer(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) internal virtual {
877         _transfer(from, to, tokenId);
878         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
879     }
880 
881     /**
882      * @dev Returns whether `tokenId` exists.
883      *
884      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
885      *
886      * Tokens start existing when they are minted (`_mint`),
887      * and stop existing when they are burned (`_burn`).
888      */
889     function _exists(uint256 tokenId) internal view virtual returns (bool) {
890         return _owners[tokenId] != address(0);
891     }
892 
893     /**
894      * @dev Returns whether `spender` is allowed to manage `tokenId`.
895      *
896      * Requirements:
897      *
898      * - `tokenId` must exist.
899      */
900     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
901         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
902         address owner = ERC721.ownerOf(tokenId);
903         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
904     }
905 
906     /**
907      * @dev Safely mints `tokenId` and transfers it to `to`.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must not exist.
912      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _safeMint(address to, uint256 tokenId) internal virtual {
917         _safeMint(to, tokenId, "");
918     }
919 
920     /**
921      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
922      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
923      */
924     function _safeMint(
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) internal virtual {
929         _mint(to, tokenId);
930         require(
931             _checkOnERC721Received(address(0), to, tokenId, _data),
932             "ERC721: transfer to non ERC721Receiver implementer"
933         );
934     }
935 
936     /**
937      * @dev Mints `tokenId` and transfers it to `to`.
938      *
939      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
940      *
941      * Requirements:
942      *
943      * - `tokenId` must not exist.
944      * - `to` cannot be the zero address.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _mint(address to, uint256 tokenId) internal virtual {
949         require(to != address(0), "ERC721: mint to the zero address");
950         require(!_exists(tokenId), "ERC721: token already minted");
951 
952         _beforeTokenTransfer(address(0), to, tokenId);
953 
954         _balances[to] += 1;
955         _owners[tokenId] = to;
956 
957         emit Transfer(address(0), to, tokenId);
958 
959         _afterTokenTransfer(address(0), to, tokenId);
960     }
961 
962     /**
963      * @dev Destroys `tokenId`.
964      * The approval is cleared when the token is burned.
965      *
966      * Requirements:
967      *
968      * - `tokenId` must exist.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _burn(uint256 tokenId) internal virtual {
973         address owner = ERC721.ownerOf(tokenId);
974 
975         _beforeTokenTransfer(owner, address(0), tokenId);
976 
977         // Clear approvals
978         _approve(address(0), tokenId);
979 
980         _balances[owner] -= 1;
981         delete _owners[tokenId];
982 
983         emit Transfer(owner, address(0), tokenId);
984 
985         _afterTokenTransfer(owner, address(0), tokenId);
986     }
987 
988     /**
989      * @dev Transfers `tokenId` from `from` to `to`.
990      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
991      *
992      * Requirements:
993      *
994      * - `to` cannot be the zero address.
995      * - `tokenId` token must be owned by `from`.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _transfer(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) internal virtual {
1004         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1005         require(to != address(0), "ERC721: transfer to the zero address");
1006 
1007         _beforeTokenTransfer(from, to, tokenId);
1008 
1009         // Clear approvals from the previous owner
1010         _approve(address(0), tokenId);
1011 
1012         _balances[from] -= 1;
1013         _balances[to] += 1;
1014         _owners[tokenId] = to;
1015 
1016         emit Transfer(from, to, tokenId);
1017 
1018         _afterTokenTransfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Approve `to` to operate on `tokenId`
1023      *
1024      * Emits a {Approval} event.
1025      */
1026     function _approve(address to, uint256 tokenId) internal virtual {
1027         _tokenApprovals[tokenId] = to;
1028         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Approve `operator` to operate on all of `owner` tokens
1033      *
1034      * Emits a {ApprovalForAll} event.
1035      */
1036     function _setApprovalForAll(
1037         address owner,
1038         address operator,
1039         bool approved
1040     ) internal virtual {
1041         require(owner != operator, "ERC721: approve to caller");
1042         _operatorApprovals[owner][operator] = approved;
1043         emit ApprovalForAll(owner, operator, approved);
1044     }
1045 
1046     /**
1047      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1048      * The call is not executed if the target address is not a contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param _data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         if (to.isContract()) {
1063             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1064                 return retval == IERC721Receiver.onERC721Received.selector;
1065             } catch (bytes memory reason) {
1066                 if (reason.length == 0) {
1067                     revert("ERC721: transfer to non ERC721Receiver implementer");
1068                 } else {
1069                     assembly {
1070                         revert(add(32, reason), mload(reason))
1071                     }
1072                 }
1073             }
1074         } else {
1075             return true;
1076         }
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` and `to` are never both zero.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Hook that is called after any transfer of tokens. This includes
1101      * minting and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - when `from` and `to` are both non-zero.
1106      * - `from` and `to` are never both zero.
1107      *
1108      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1109      */
1110     function _afterTokenTransfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {}
1115 }
1116 
1117 
1118 // File contracts/ShinyWhitelistedNFTDrop.sol
1119 
1120 
1121 
1122 
1123 
1124 
1125 contract ShinyWhitelistedNFTDrop is ERC721, Ownable {
1126     using Strings for uint256;
1127 
1128     uint256 public constant TOTAL_NFTS = 2222;
1129     uint256 public whitelistedAddressesCount;
1130 
1131     bool public saleStartStatus;
1132     bool public whitelistRegistrationStatus;
1133 
1134     uint256 public tokenCounter;
1135     uint256 public membershipFee;
1136 
1137     string private _baseTokenURI = "";
1138 
1139     mapping(address => bool) private _whitelistedAddressStatuses;
1140     mapping(address => bool) private _whitelistedAddressNFTClaimStatuses;
1141 
1142     constructor()
1143         Ownable()
1144         ERC721("EverydayGoddesses", "EGS")
1145     {}
1146 
1147     /* Admin Methods Start */
1148 
1149     function updateTokenBaseURI(string calldata baseTokenURI_)
1150         external
1151         onlyOwner
1152     {
1153         _baseTokenURI = baseTokenURI_;
1154     }
1155 
1156     function toggleSell() external onlyOwner {
1157         saleStartStatus = !saleStartStatus;
1158     }
1159 
1160     function toggleWhitelistRegistration() external onlyOwner {
1161         whitelistRegistrationStatus = !whitelistRegistrationStatus;
1162     }
1163 
1164     function addAddressesAsWhitelisted(address[] calldata _addresses)
1165         external
1166         onlyOwner
1167     {
1168         require(
1169             whitelistedAddressesCount + _addresses.length <= TOTAL_NFTS,
1170             "ShinyWhitelistedNFTDrop: Whitelist is full"
1171         );
1172 
1173         for (
1174             uint256 addressIndex = 0;
1175             addressIndex < _addresses.length;
1176             addressIndex++
1177         ) {
1178             _whitelistedAddressStatuses[_addresses[addressIndex]] = true;
1179         }
1180         whitelistedAddressesCount += _addresses.length;
1181     }
1182 
1183     function setMembershipFee(uint256 membershipFee_) external onlyOwner {
1184         membershipFee = membershipFee_;
1185     }
1186 
1187     function mintForWhitelistedTokens(address[] calldata whitelistedAddresses_)
1188         external
1189         onlyOwner
1190     {
1191         require(
1192             whitelistedAddresses_.length > 0,
1193             "ShinyWhitelistedNFTDrop: No addresses"
1194         );
1195         require(
1196             whitelistedAddresses_.length <= 3,
1197             "ShinyWhitelistedNFTDrop: Too many addresses"
1198         );
1199 
1200         for (
1201             uint256 whitelistedAddressIndex = 0;
1202             whitelistedAddressIndex < whitelistedAddresses_.length;
1203             whitelistedAddressIndex++
1204         ) {
1205             // Mint NFTs for each whitelisted address
1206             require(
1207                 _whitelistedAddressStatuses[
1208                     whitelistedAddresses_[whitelistedAddressIndex]
1209                 ],
1210                 "ShinyWhitelistedNFTDrop: Address not whitelisted"
1211             );
1212             require(
1213                 !_whitelistedAddressNFTClaimStatuses[
1214                     whitelistedAddresses_[whitelistedAddressIndex]
1215                 ],
1216                 "ShinyWhitelistedNFTDrop: User has already claimed an NFT"
1217             );
1218             // Update the user's claim status
1219             _whitelistedAddressNFTClaimStatuses[
1220                 whitelistedAddresses_[whitelistedAddressIndex]
1221             ] = true;
1222             // Mint the NFT
1223             _safeMint(
1224                 whitelistedAddresses_[whitelistedAddressIndex],
1225                 ++tokenCounter
1226             );
1227         }
1228     }
1229 
1230     /* Admin Methods End */
1231 
1232     /* External Methods Start */
1233 
1234     function getRegistered() external payable {
1235         require(
1236             whitelistRegistrationStatus,
1237             "ShinyWhitelistedNFTDrop: Whitelist registration is closed"
1238         );
1239         require(
1240             whitelistedAddressesCount < TOTAL_NFTS,
1241             "ShinyWhitelistedNFTDrop: Whitelist is full"
1242         );
1243         require(
1244             !_whitelistedAddressStatuses[msg.sender],
1245             "ShinyWhitelistedNFTDrop: User is already registered"
1246         );
1247         require(
1248             msg.value == membershipFee,
1249             "ShinyWhitelistedNFTDrop: Wrong membership fee transferred"
1250         );
1251         // Add the address as a whitelisted address
1252         _whitelistedAddressStatuses[msg.sender] = true;
1253         whitelistedAddressesCount++;
1254         // Transfer the membership fee to the owner
1255         payable(owner()).transfer(msg.value);
1256     }
1257 
1258     function claimNFT() external {
1259         require(
1260             saleStartStatus,
1261             "ShinyWhitelistedNFTDrop: Sale has not started yet"
1262         );
1263         require(
1264             _whitelistedAddressStatuses[msg.sender],
1265             "ShinyWhitelistedNFTDrop: User is not whitelisted"
1266         );
1267         require(
1268             !_whitelistedAddressNFTClaimStatuses[msg.sender],
1269             "ShinyWhitelistedNFTDrop: User has already claimed an NFT"
1270         );
1271         // Update the user's claim status
1272         _whitelistedAddressNFTClaimStatuses[msg.sender] = true;
1273         // Mint the NFT
1274         _safeMint(msg.sender, ++tokenCounter);
1275     }
1276 
1277     /* View Methods Start */
1278     
1279     function isUserWhitelisted(address _userAddress)
1280         external
1281         view
1282         returns (bool)
1283     {
1284         return _whitelistedAddressStatuses[_userAddress];
1285     }
1286 
1287     function hasUserClaimed(address _userAddress) external view returns (bool) {
1288         return _whitelistedAddressNFTClaimStatuses[_userAddress];
1289     }
1290 
1291     /* View Methods End */
1292 
1293     /* External Methods End */
1294 
1295     /* Public Methods Start */
1296 
1297     function tokenURI(uint256 tokenId)
1298         public
1299         view
1300         virtual
1301         override
1302         returns (string memory)
1303     {
1304         require(
1305             _exists(tokenId),
1306             "ShinyWhitelistedNFTDrop: URI query for nonexistent token"
1307         );
1308 
1309         string memory baseURI = _baseURI();
1310         return
1311             bytes(baseURI).length > 0
1312                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1313                 : "";
1314     }
1315 
1316     /* Public Methods End */
1317 
1318     /* Internal Functions Start */
1319 
1320     function _baseURI() internal view override returns (string memory) {
1321         return _baseTokenURI;
1322     }
1323 
1324     /* Internal Functions End */
1325 }