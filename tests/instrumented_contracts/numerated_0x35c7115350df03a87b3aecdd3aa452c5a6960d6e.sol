1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
30 
31 
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _transferOwnership(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _transferOwnership(newOwner);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Internal function without access restriction.
95      */
96     function _transferOwnership(address newOwner) internal virtual {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 
104 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
108 
109 
110 
111 /**
112  * @dev String operations.
113  */
114 library Strings {
115     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
119      */
120     function toString(uint256 value) internal pure returns (string memory) {
121         // Inspired by OraclizeAPI's implementation - MIT licence
122         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
123 
124         if (value == 0) {
125             return "0";
126         }
127         uint256 temp = value;
128         uint256 digits;
129         while (temp != 0) {
130             digits++;
131             temp /= 10;
132         }
133         bytes memory buffer = new bytes(digits);
134         while (value != 0) {
135             digits -= 1;
136             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
137             value /= 10;
138         }
139         return string(buffer);
140     }
141 
142     /**
143      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
144      */
145     function toHexString(uint256 value) internal pure returns (string memory) {
146         if (value == 0) {
147             return "0x00";
148         }
149         uint256 temp = value;
150         uint256 length = 0;
151         while (temp != 0) {
152             length++;
153             temp >>= 8;
154         }
155         return toHexString(value, length);
156     }
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
160      */
161     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
162         bytes memory buffer = new bytes(2 * length + 2);
163         buffer[0] = "0";
164         buffer[1] = "x";
165         for (uint256 i = 2 * length + 1; i > 1; --i) {
166             buffer[i] = _HEX_SYMBOLS[value & 0xf];
167             value >>= 4;
168         }
169         require(value == 0, "Strings: hex length insufficient");
170         return string(buffer);
171     }
172 }
173 
174 
175 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
179 
180 
181 
182 /**
183  * @dev Interface of the ERC165 standard, as defined in the
184  * https://eips.ethereum.org/EIPS/eip-165[EIP].
185  *
186  * Implementers can declare support of contract interfaces, which can then be
187  * queried by others ({ERC165Checker}).
188  *
189  * For an implementation, see {ERC165}.
190  */
191 interface IERC165 {
192     /**
193      * @dev Returns true if this contract implements the interface defined by
194      * `interfaceId`. See the corresponding
195      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
196      * to learn more about how these ids are created.
197      *
198      * This function call must use less than 30 000 gas.
199      */
200     function supportsInterface(bytes4 interfaceId) external view returns (bool);
201 }
202 
203 
204 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
205 
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
208 
209 
210 
211 /**
212  * @dev Required interface of an ERC721 compliant contract.
213  */
214 interface IERC721 is IERC165 {
215     /**
216      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
217      */
218     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
219 
220     /**
221      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
222      */
223     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
224 
225     /**
226      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
227      */
228     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
229 
230     /**
231      * @dev Returns the number of tokens in ``owner``'s account.
232      */
233     function balanceOf(address owner) external view returns (uint256 balance);
234 
235     /**
236      * @dev Returns the owner of the `tokenId` token.
237      *
238      * Requirements:
239      *
240      * - `tokenId` must exist.
241      */
242     function ownerOf(uint256 tokenId) external view returns (address owner);
243 
244     /**
245      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
246      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must exist and be owned by `from`.
253      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
254      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
255      *
256      * Emits a {Transfer} event.
257      */
258     function safeTransferFrom(
259         address from,
260         address to,
261         uint256 tokenId
262     ) external;
263 
264     /**
265      * @dev Transfers `tokenId` token from `from` to `to`.
266      *
267      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
268      *
269      * Requirements:
270      *
271      * - `from` cannot be the zero address.
272      * - `to` cannot be the zero address.
273      * - `tokenId` token must be owned by `from`.
274      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
275      *
276      * Emits a {Transfer} event.
277      */
278     function transferFrom(
279         address from,
280         address to,
281         uint256 tokenId
282     ) external;
283 
284     /**
285      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
286      * The approval is cleared when the token is transferred.
287      *
288      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
289      *
290      * Requirements:
291      *
292      * - The caller must own the token or be an approved operator.
293      * - `tokenId` must exist.
294      *
295      * Emits an {Approval} event.
296      */
297     function approve(address to, uint256 tokenId) external;
298 
299     /**
300      * @dev Returns the account approved for `tokenId` token.
301      *
302      * Requirements:
303      *
304      * - `tokenId` must exist.
305      */
306     function getApproved(uint256 tokenId) external view returns (address operator);
307 
308     /**
309      * @dev Approve or remove `operator` as an operator for the caller.
310      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
311      *
312      * Requirements:
313      *
314      * - The `operator` cannot be the caller.
315      *
316      * Emits an {ApprovalForAll} event.
317      */
318     function setApprovalForAll(address operator, bool _approved) external;
319 
320     /**
321      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
322      *
323      * See {setApprovalForAll}
324      */
325     function isApprovedForAll(address owner, address operator) external view returns (bool);
326 
327     /**
328      * @dev Safely transfers `tokenId` token from `from` to `to`.
329      *
330      * Requirements:
331      *
332      * - `from` cannot be the zero address.
333      * - `to` cannot be the zero address.
334      * - `tokenId` token must exist and be owned by `from`.
335      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
336      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
337      *
338      * Emits a {Transfer} event.
339      */
340     function safeTransferFrom(
341         address from,
342         address to,
343         uint256 tokenId,
344         bytes calldata data
345     ) external;
346 }
347 
348 
349 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
353 
354 
355 
356 /**
357  * @title ERC721 token receiver interface
358  * @dev Interface for any contract that wants to support safeTransfers
359  * from ERC721 asset contracts.
360  */
361 interface IERC721Receiver {
362     /**
363      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
364      * by `operator` from `from`, this function is called.
365      *
366      * It must return its Solidity selector to confirm the token transfer.
367      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
368      *
369      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
370      */
371     function onERC721Received(
372         address operator,
373         address from,
374         uint256 tokenId,
375         bytes calldata data
376     ) external returns (bytes4);
377 }
378 
379 
380 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
384 
385 
386 
387 /**
388  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
389  * @dev See https://eips.ethereum.org/EIPS/eip-721
390  */
391 interface IERC721Metadata is IERC721 {
392     /**
393      * @dev Returns the token collection name.
394      */
395     function name() external view returns (string memory);
396 
397     /**
398      * @dev Returns the token collection symbol.
399      */
400     function symbol() external view returns (string memory);
401 
402     /**
403      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
404      */
405     function tokenURI(uint256 tokenId) external view returns (string memory);
406 }
407 
408 
409 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
410 
411 
412 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
413 
414 
415 
416 /**
417  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
418  * @dev See https://eips.ethereum.org/EIPS/eip-721
419  */
420 interface IERC721Enumerable is IERC721 {
421     /**
422      * @dev Returns the total amount of tokens stored by the contract.
423      */
424     function totalSupply() external view returns (uint256);
425 
426     /**
427      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
428      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
429      */
430     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
431 
432     /**
433      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
434      * Use along with {totalSupply} to enumerate all tokens.
435      */
436     function tokenByIndex(uint256 index) external view returns (uint256);
437 }
438 
439 
440 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
444 
445 
446 
447 /**
448  * @dev Collection of functions related to the address type
449  */
450 library Address {
451     /**
452      * @dev Returns true if `account` is a contract.
453      *
454      * [IMPORTANT]
455      * ====
456      * It is unsafe to assume that an address for which this function returns
457      * false is an externally-owned account (EOA) and not a contract.
458      *
459      * Among others, `isContract` will return false for the following
460      * types of addresses:
461      *
462      *  - an externally-owned account
463      *  - a contract in construction
464      *  - an address where a contract will be created
465      *  - an address where a contract lived, but was destroyed
466      * ====
467      */
468     function isContract(address account) internal view returns (bool) {
469         // This method relies on extcodesize, which returns 0 for contracts in
470         // construction, since the code is only stored at the end of the
471         // constructor execution.
472 
473         uint256 size;
474         assembly {
475             size := extcodesize(account)
476         }
477         return size > 0;
478     }
479 
480     /**
481      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
482      * `recipient`, forwarding all available gas and reverting on errors.
483      *
484      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
485      * of certain opcodes, possibly making contracts go over the 2300 gas limit
486      * imposed by `transfer`, making them unable to receive funds via
487      * `transfer`. {sendValue} removes this limitation.
488      *
489      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
490      *
491      * IMPORTANT: because control is transferred to `recipient`, care must be
492      * taken to not create reentrancy vulnerabilities. Consider using
493      * {ReentrancyGuard} or the
494      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
495      */
496     function sendValue(address payable recipient, uint256 amount) internal {
497         require(address(this).balance >= amount, "Address: insufficient balance");
498 
499         (bool success, ) = recipient.call{value: amount}("");
500         require(success, "Address: unable to send value, recipient may have reverted");
501     }
502 
503     /**
504      * @dev Performs a Solidity function call using a low level `call`. A
505      * plain `call` is an unsafe replacement for a function call: use this
506      * function instead.
507      *
508      * If `target` reverts with a revert reason, it is bubbled up by this
509      * function (like regular Solidity function calls).
510      *
511      * Returns the raw returned data. To convert to the expected return value,
512      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
513      *
514      * Requirements:
515      *
516      * - `target` must be a contract.
517      * - calling `target` with `data` must not revert.
518      *
519      * _Available since v3.1._
520      */
521     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
522         return functionCall(target, data, "Address: low-level call failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
527      * `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCall(
532         address target,
533         bytes memory data,
534         string memory errorMessage
535     ) internal returns (bytes memory) {
536         return functionCallWithValue(target, data, 0, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but also transferring `value` wei to `target`.
542      *
543      * Requirements:
544      *
545      * - the calling contract must have an ETH balance of at least `value`.
546      * - the called Solidity function must be `payable`.
547      *
548      * _Available since v3.1._
549      */
550     function functionCallWithValue(
551         address target,
552         bytes memory data,
553         uint256 value
554     ) internal returns (bytes memory) {
555         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
560      * with `errorMessage` as a fallback revert reason when `target` reverts.
561      *
562      * _Available since v3.1._
563      */
564     function functionCallWithValue(
565         address target,
566         bytes memory data,
567         uint256 value,
568         string memory errorMessage
569     ) internal returns (bytes memory) {
570         require(address(this).balance >= value, "Address: insufficient balance for call");
571         require(isContract(target), "Address: call to non-contract");
572 
573         (bool success, bytes memory returndata) = target.call{value: value}(data);
574         return verifyCallResult(success, returndata, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but performing a static call.
580      *
581      * _Available since v3.3._
582      */
583     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
584         return functionStaticCall(target, data, "Address: low-level static call failed");
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
589      * but performing a static call.
590      *
591      * _Available since v3.3._
592      */
593     function functionStaticCall(
594         address target,
595         bytes memory data,
596         string memory errorMessage
597     ) internal view returns (bytes memory) {
598         require(isContract(target), "Address: static call to non-contract");
599 
600         (bool success, bytes memory returndata) = target.staticcall(data);
601         return verifyCallResult(success, returndata, errorMessage);
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
606      * but performing a delegate call.
607      *
608      * _Available since v3.4._
609      */
610     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
611         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(
621         address target,
622         bytes memory data,
623         string memory errorMessage
624     ) internal returns (bytes memory) {
625         require(isContract(target), "Address: delegate call to non-contract");
626 
627         (bool success, bytes memory returndata) = target.delegatecall(data);
628         return verifyCallResult(success, returndata, errorMessage);
629     }
630 
631     /**
632      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
633      * revert reason using the provided one.
634      *
635      * _Available since v4.3._
636      */
637     function verifyCallResult(
638         bool success,
639         bytes memory returndata,
640         string memory errorMessage
641     ) internal pure returns (bytes memory) {
642         if (success) {
643             return returndata;
644         } else {
645             // Look for revert reason and bubble it up if present
646             if (returndata.length > 0) {
647                 // The easiest way to bubble the revert reason is using memory via assembly
648 
649                 assembly {
650                     let returndata_size := mload(returndata)
651                     revert(add(32, returndata), returndata_size)
652                 }
653             } else {
654                 revert(errorMessage);
655             }
656         }
657     }
658 }
659 
660 
661 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
665 
666 
667 
668 /**
669  * @dev Implementation of the {IERC165} interface.
670  *
671  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
672  * for the additional interface id that will be supported. For example:
673  *
674  * ```solidity
675  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
676  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
677  * }
678  * ```
679  *
680  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
681  */
682 abstract contract ERC165 is IERC165 {
683     /**
684      * @dev See {IERC165-supportsInterface}.
685      */
686     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687         return interfaceId == type(IERC165).interfaceId;
688     }
689 }
690 
691 
692 // File contracts/ERC721A.sol
693 
694 
695 // Creator: Chiru Labs
696 
697 
698 /**
699  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
700  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
701  *
702  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
703  *
704  * Does not support burning tokens to address(0).
705  *
706  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
707  */
708 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
709     using Address for address;
710     using Strings for uint256;
711 
712     struct TokenOwnership {
713         address addr;
714         uint64 startTimestamp;
715     }
716 
717     struct AddressData {
718         uint128 balance;
719         uint128 numberMinted;
720     }
721 
722     uint256 internal currentIndex = 1;
723 
724     // Token name
725     string private _name;
726 
727     // Token symbol
728     string private _symbol;
729 
730     // Mapping from token ID to ownership details
731     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
732     mapping(uint256 => TokenOwnership) internal _ownerships;
733 
734     // Mapping owner address to address data
735     mapping(address => AddressData) private _addressData;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     constructor(string memory name_, string memory symbol_) {
744         _name = name_;
745         _symbol = symbol_;
746     }
747 
748     /**
749      * @dev See {IERC721Enumerable-totalSupply}.
750      */
751     function totalSupply() public view override returns (uint256) {
752         return currentIndex;
753     }
754 
755     /**
756      * @dev See {IERC721Enumerable-tokenByIndex}.
757      */
758     function tokenByIndex(uint256 index) public view override returns (uint256) {
759         require(index < totalSupply(), 'ERC721A: global index out of bounds');
760         return index;
761     }
762 
763     /**
764      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
765      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
766      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
767      */
768     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
769         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
770         uint256 numMintedSoFar = totalSupply();
771         uint256 tokenIdsIdx = 0;
772         address currOwnershipAddr = address(0);
773         for (uint256 i = 0; i < numMintedSoFar; i++) {
774             TokenOwnership memory ownership = _ownerships[i];
775             if (ownership.addr != address(0)) {
776                 currOwnershipAddr = ownership.addr;
777             }
778             if (currOwnershipAddr == owner) {
779                 if (tokenIdsIdx == index) {
780                     return i;
781                 }
782                 tokenIdsIdx++;
783             }
784         }
785         revert('ERC721A: unable to get token of owner by index');
786     }
787 
788     /**
789      * @dev See {IERC165-supportsInterface}.
790      */
791     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
792         return
793             interfaceId == type(IERC721).interfaceId ||
794             interfaceId == type(IERC721Metadata).interfaceId ||
795             interfaceId == type(IERC721Enumerable).interfaceId ||
796             super.supportsInterface(interfaceId);
797     }
798 
799     /**
800      * @dev See {IERC721-balanceOf}.
801      */
802     function balanceOf(address owner) public view override returns (uint256) {
803         require(owner != address(0), 'ERC721A: balance query for the zero address');
804         return uint256(_addressData[owner].balance);
805     }
806 
807     function _numberMinted(address owner) internal view returns (uint256) {
808         require(owner != address(0), 'ERC721A: number minted query for the zero address');
809         return uint256(_addressData[owner].numberMinted);
810     }
811 
812     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
813         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
814 
815         for (uint256 curr = tokenId; ; curr--) {
816             TokenOwnership memory ownership = _ownerships[curr];
817             if (ownership.addr != address(0)) {
818                 return ownership;
819             }
820         }
821 
822         revert('ERC721A: unable to determine the owner of token');
823     }
824 
825     /**
826      * @dev See {IERC721-ownerOf}.
827      */
828     function ownerOf(uint256 tokenId) public view override returns (address) {
829         return ownershipOf(tokenId).addr;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-name}.
834      */
835     function name() public view virtual override returns (string memory) {
836         return _name;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-symbol}.
841      */
842     function symbol() public view virtual override returns (string memory) {
843         return _symbol;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-tokenURI}.
848      */
849     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
850         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
851 
852         string memory baseURI = _baseURI();
853         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
854     }
855 
856     /**
857      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
858      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
859      * by default, can be overriden in child contracts.
860      */
861     function _baseURI() internal view virtual returns (string memory) {
862         return '';
863     }
864 
865     /**
866      * @dev See {IERC721-approve}.
867      */
868     function approve(address to, uint256 tokenId) public override {
869         address owner = ERC721A.ownerOf(tokenId);
870         require(to != owner, 'ERC721A: approval to current owner');
871 
872         require(
873             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
874             'ERC721A: approve caller is not owner nor approved for all'
875         );
876 
877         _approve(to, tokenId, owner);
878     }
879 
880     /**
881      * @dev See {IERC721-getApproved}.
882      */
883     function getApproved(uint256 tokenId) public view override returns (address) {
884         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
885 
886         return _tokenApprovals[tokenId];
887     }
888 
889     /**
890      * @dev See {IERC721-setApprovalForAll}.
891      */
892     function setApprovalForAll(address operator, bool approved) public override {
893         require(operator != _msgSender(), 'ERC721A: approve to caller');
894 
895         _operatorApprovals[_msgSender()][operator] = approved;
896         emit ApprovalForAll(_msgSender(), operator, approved);
897     }
898 
899     /**
900      * @dev See {IERC721-isApprovedForAll}.
901      */
902     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
903         return _operatorApprovals[owner][operator];
904     }
905 
906     /**
907      * @dev See {IERC721-transferFrom}.
908      */
909     function transferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public override {
914         _transfer(from, to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) public override {
925         safeTransferFrom(from, to, tokenId, '');
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) public override {
937         _transfer(from, to, tokenId);
938         require(
939             _checkOnERC721Received(from, to, tokenId, _data),
940             'ERC721A: transfer to non ERC721Receiver implementer'
941         );
942     }
943 
944     /**
945      * @dev Returns whether `tokenId` exists.
946      *
947      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
948      *
949      * Tokens start existing when they are minted (`_mint`),
950      */
951     function _exists(uint256 tokenId) internal view returns (bool) {
952         return tokenId < currentIndex;
953     }
954 
955     function _safeMint(address to, uint256 quantity) internal {
956         _safeMint(to, quantity, '');
957     }
958 
959     /**
960      * @dev Mints `quantity` tokens and transfers them to `to`.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - `quantity` cannot be larger than the max batch size.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeMint(
970         address to,
971         uint256 quantity,
972         bytes memory _data
973     ) internal {
974         uint256 startTokenId = currentIndex;
975         require(to != address(0), 'ERC721A: mint to the zero address');
976         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
977         require(!_exists(startTokenId), 'ERC721A: token already minted');
978         require(quantity > 0, 'ERC721A: quantity must be greater 0');
979 
980         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
981 
982         AddressData memory addressData = _addressData[to];
983         _addressData[to] = AddressData(
984             addressData.balance + uint128(quantity),
985             addressData.numberMinted + uint128(quantity)
986         );
987         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
988 
989         uint256 updatedIndex = startTokenId;
990 
991         for (uint256 i = 0; i < quantity; i++) {
992             emit Transfer(address(0), to, updatedIndex);
993             require(
994                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
995                 'ERC721A: transfer to non ERC721Receiver implementer'
996             );
997             updatedIndex++;
998         }
999 
1000         currentIndex = updatedIndex;
1001         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _transfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) private {
1019         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1020 
1021         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1022             getApproved(tokenId) == _msgSender() ||
1023             isApprovedForAll(prevOwnership.addr, _msgSender()));
1024 
1025         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1026 
1027         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1028         require(to != address(0), 'ERC721A: transfer to the zero address');
1029 
1030         _beforeTokenTransfers(from, to, tokenId, 1);
1031 
1032         // Clear approvals from the previous owner
1033         _approve(address(0), tokenId, prevOwnership.addr);
1034 
1035         // Underflow of the sender's balance is impossible because we check for
1036         // ownership above and the recipient's balance can't realistically overflow.
1037         unchecked {
1038             _addressData[from].balance -= 1;
1039             _addressData[to].balance += 1;
1040         }
1041 
1042         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1043 
1044         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1045         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1046         uint256 nextTokenId = tokenId + 1;
1047         if (_ownerships[nextTokenId].addr == address(0)) {
1048             if (_exists(nextTokenId)) {
1049                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1050             }
1051         }
1052 
1053         emit Transfer(from, to, tokenId);
1054         _afterTokenTransfers(from, to, tokenId, 1);
1055     }
1056 
1057     /**
1058      * @dev Approve `to` to operate on `tokenId`
1059      *
1060      * Emits a {Approval} event.
1061      */
1062     function _approve(
1063         address to,
1064         uint256 tokenId,
1065         address owner
1066     ) private {
1067         _tokenApprovals[tokenId] = to;
1068         emit Approval(owner, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1073      * The call is not executed if the target address is not a contract.
1074      *
1075      * @param from address representing the previous owner of the given token ID
1076      * @param to target address that will receive the tokens
1077      * @param tokenId uint256 ID of the token to be transferred
1078      * @param _data bytes optional data to send along with the call
1079      * @return bool whether the call correctly returned the expected magic value
1080      */
1081     function _checkOnERC721Received(
1082         address from,
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) private returns (bool) {
1087         if (to.isContract()) {
1088             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1089                 return retval == IERC721Receiver(to).onERC721Received.selector;
1090             } catch (bytes memory reason) {
1091                 if (reason.length == 0) {
1092                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1093                 } else {
1094                     assembly {
1095                         revert(add(32, reason), mload(reason))
1096                     }
1097                 }
1098             }
1099         } else {
1100             return true;
1101         }
1102     }
1103 
1104     /**
1105      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1106      *
1107      * startTokenId - the first token id to be transferred
1108      * quantity - the amount to be transferred
1109      *
1110      * Calling conditions:
1111      *
1112      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1113      * transferred to `to`.
1114      * - When `from` is zero, `tokenId` will be minted for `to`.
1115      */
1116     function _beforeTokenTransfers(
1117         address from,
1118         address to,
1119         uint256 startTokenId,
1120         uint256 quantity
1121     ) internal virtual {}
1122 
1123     /**
1124      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1125      * minting.
1126      *
1127      * startTokenId - the first token id to be transferred
1128      * quantity - the amount to be transferred
1129      *
1130      * Calling conditions:
1131      *
1132      * - when `from` and `to` are both non-zero.
1133      * - `from` and `to` are never both zero.
1134      */
1135     function _afterTokenTransfers(
1136         address from,
1137         address to,
1138         uint256 startTokenId,
1139         uint256 quantity
1140     ) internal virtual {}
1141 }
1142 
1143 contract KevToadz is ERC721A, Ownable {
1144 
1145     using Address for address;
1146     using Strings for uint;
1147 
1148     uint256 public constant MaxPerWallet = 2;
1149     uint256 public constant MaxTX = 1;
1150     uint256 public constant MaxSupply = 470;
1151     uint256 public constant price = 0.00 ether;
1152     string public baseURI = "ipfs://QmdMvQYoGMuwDPPoGTxcDSoHx3JceCTe5VbngVFXrSu851/";
1153     string public constant baseExtension = ".json";
1154     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1155     mapping(address => uint256) public addressMinted;
1156     bool public paused = true;
1157 
1158     constructor() ERC721A("KevToadz", "KTOADZ") {}
1159 
1160     function mint(uint256 quantity) external payable {
1161         require(!paused, "Paused");
1162         require(MaxSupply >= totalSupply() + quantity, "Exceeds max supply");
1163         require(quantity > 0, "No 0 mints");
1164         require(tx.origin == msg.sender, "No contracts");
1165         require(addressMinted[msg.sender] + quantity <= MaxPerWallet, "Can only mint 2 per wallet.");
1166         require(MaxTX >= quantity, "Tokens per transaction limit exeded,");
1167         require(quantity * price == msg.value, "Invalid funds provided");
1168         addressMinted[msg.sender] += quantity;
1169         _safeMint(msg.sender, quantity);
1170     }
1171 
1172 
1173     function isApprovedForAll(address owner, address operator)
1174         override
1175         public
1176         view
1177         returns (bool)
1178     {
1179         // Whitelist OpenSea proxy contract for easy trading.
1180         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1181         if (address(proxyRegistry.proxies(owner)) == operator) {
1182             return true;
1183         }
1184 
1185         return super.isApprovedForAll(owner, operator);
1186     }
1187 
1188     function withdraw() external onlyOwner {
1189         uint256 balance = address(this).balance;
1190         (bool success, ) = _msgSender().call{value: balance}("");
1191         require(success, "Failed to send");
1192     }
1193 
1194     function pause(bool _state) external onlyOwner {
1195         paused = _state;
1196     }
1197 
1198     function setBaseURI(string memory baseURI_) external onlyOwner {
1199         baseURI = baseURI_;
1200     }
1201 
1202     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1203         require(_exists(_tokenId), "Token does not exist.");
1204         return bytes(baseURI).length > 0 ? string(
1205             abi.encodePacked(
1206               baseURI,
1207               Strings.toString(_tokenId),
1208               baseExtension
1209             )
1210         ) : "";
1211     }
1212 }
1213 
1214 contract OwnableDelegateProxy { }
1215 contract ProxyRegistry {
1216     mapping(address => OwnableDelegateProxy) public proxies;
1217 }