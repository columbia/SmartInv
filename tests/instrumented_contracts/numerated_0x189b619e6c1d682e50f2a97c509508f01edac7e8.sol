1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
175 
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
204 
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
349 
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
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
383 
384 
385 
386 /**
387  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
388  * @dev See https://eips.ethereum.org/EIPS/eip-721
389  */
390 interface IERC721Metadata is IERC721 {
391     /**
392      * @dev Returns the token collection name.
393      */
394     function name() external view returns (string memory);
395 
396     /**
397      * @dev Returns the token collection symbol.
398      */
399     function symbol() external view returns (string memory);
400 
401     /**
402      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
403      */
404     function tokenURI(uint256 tokenId) external view returns (string memory);
405 }
406 
407 
408 
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
412 
413 
414 
415 /**
416  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
417  * @dev See https://eips.ethereum.org/EIPS/eip-721
418  */
419 interface IERC721Enumerable is IERC721 {
420     /**
421      * @dev Returns the total amount of tokens stored by the contract.
422      */
423     function totalSupply() external view returns (uint256);
424 
425     /**
426      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
427      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
428      */
429     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
430 
431     /**
432      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
433      * Use along with {totalSupply} to enumerate all tokens.
434      */
435     function tokenByIndex(uint256 index) external view returns (uint256);
436 }
437 
438 
439 
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
443 
444 
445 
446 /**
447  * @dev Collection of functions related to the address type
448  */
449 library Address {
450     /**
451      * @dev Returns true if `account` is a contract.
452      *
453      * [IMPORTANT]
454      * ====
455      * It is unsafe to assume that an address for which this function returns
456      * false is an externally-owned account (EOA) and not a contract.
457      *
458      * Among others, `isContract` will return false for the following
459      * types of addresses:
460      *
461      *  - an externally-owned account
462      *  - a contract in construction
463      *  - an address where a contract will be created
464      *  - an address where a contract lived, but was destroyed
465      * ====
466      */
467     function isContract(address account) internal view returns (bool) {
468         // This method relies on extcodesize, which returns 0 for contracts in
469         // construction, since the code is only stored at the end of the
470         // constructor execution.
471 
472         uint256 size;
473         assembly {
474             size := extcodesize(account)
475         }
476         return size > 0;
477     }
478 
479     /**
480      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
481      * `recipient`, forwarding all available gas and reverting on errors.
482      *
483      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
484      * of certain opcodes, possibly making contracts go over the 2300 gas limit
485      * imposed by `transfer`, making them unable to receive funds via
486      * `transfer`. {sendValue} removes this limitation.
487      *
488      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
489      *
490      * IMPORTANT: because control is transferred to `recipient`, care must be
491      * taken to not create reentrancy vulnerabilities. Consider using
492      * {ReentrancyGuard} or the
493      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
494      */
495     function sendValue(address payable recipient, uint256 amount) internal {
496         require(address(this).balance >= amount, "Address: insufficient balance");
497 
498         (bool success, ) = recipient.call{value: amount}("");
499         require(success, "Address: unable to send value, recipient may have reverted");
500     }
501 
502     /**
503      * @dev Performs a Solidity function call using a low level `call`. A
504      * plain `call` is an unsafe replacement for a function call: use this
505      * function instead.
506      *
507      * If `target` reverts with a revert reason, it is bubbled up by this
508      * function (like regular Solidity function calls).
509      *
510      * Returns the raw returned data. To convert to the expected return value,
511      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
512      *
513      * Requirements:
514      *
515      * - `target` must be a contract.
516      * - calling `target` with `data` must not revert.
517      *
518      * _Available since v3.1._
519      */
520     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
521         return functionCall(target, data, "Address: low-level call failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
526      * `errorMessage` as a fallback revert reason when `target` reverts.
527      *
528      * _Available since v3.1._
529      */
530     function functionCall(
531         address target,
532         bytes memory data,
533         string memory errorMessage
534     ) internal returns (bytes memory) {
535         return functionCallWithValue(target, data, 0, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but also transferring `value` wei to `target`.
541      *
542      * Requirements:
543      *
544      * - the calling contract must have an ETH balance of at least `value`.
545      * - the called Solidity function must be `payable`.
546      *
547      * _Available since v3.1._
548      */
549     function functionCallWithValue(
550         address target,
551         bytes memory data,
552         uint256 value
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
559      * with `errorMessage` as a fallback revert reason when `target` reverts.
560      *
561      * _Available since v3.1._
562      */
563     function functionCallWithValue(
564         address target,
565         bytes memory data,
566         uint256 value,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         require(address(this).balance >= value, "Address: insufficient balance for call");
570         require(isContract(target), "Address: call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.call{value: value}(data);
573         return verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but performing a static call.
579      *
580      * _Available since v3.3._
581      */
582     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
583         return functionStaticCall(target, data, "Address: low-level static call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal view returns (bytes memory) {
597         require(isContract(target), "Address: static call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.staticcall(data);
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but performing a delegate call.
606      *
607      * _Available since v3.4._
608      */
609     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
610         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
615      * but performing a delegate call.
616      *
617      * _Available since v3.4._
618      */
619     function functionDelegateCall(
620         address target,
621         bytes memory data,
622         string memory errorMessage
623     ) internal returns (bytes memory) {
624         require(isContract(target), "Address: delegate call to non-contract");
625 
626         (bool success, bytes memory returndata) = target.delegatecall(data);
627         return verifyCallResult(success, returndata, errorMessage);
628     }
629 
630     /**
631      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
632      * revert reason using the provided one.
633      *
634      * _Available since v4.3._
635      */
636     function verifyCallResult(
637         bool success,
638         bytes memory returndata,
639         string memory errorMessage
640     ) internal pure returns (bytes memory) {
641         if (success) {
642             return returndata;
643         } else {
644             // Look for revert reason and bubble it up if present
645             if (returndata.length > 0) {
646                 // The easiest way to bubble the revert reason is using memory via assembly
647 
648                 assembly {
649                     let returndata_size := mload(returndata)
650                     revert(add(32, returndata), returndata_size)
651                 }
652             } else {
653                 revert(errorMessage);
654             }
655         }
656     }
657 }
658 
659 
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
663 
664 
665 
666 /**
667  * @dev Implementation of the {IERC165} interface.
668  *
669  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
670  * for the additional interface id that will be supported. For example:
671  *
672  * ```solidity
673  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
674  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
675  * }
676  * ```
677  *
678  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
679  */
680 abstract contract ERC165 is IERC165 {
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
685         return interfaceId == type(IERC165).interfaceId;
686     }
687 }
688 
689 
690 // File contracts/ERC721A.sol
691 
692 
693 // Creator: Chiru Labs
694 
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
699  *
700  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
701  *
702  * Does not support burning tokens to address(0).
703  *
704  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
705  */
706 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
707     using Address for address;
708     using Strings for uint256;
709 
710     struct TokenOwnership {
711         address addr;
712         uint64 startTimestamp;
713     }
714 
715     struct AddressData {
716         uint128 balance;
717         uint128 numberMinted;
718     }
719 
720     uint256 internal currentIndex = 0;
721 
722     // Token name
723     string private _name;
724 
725     // Token symbol
726     string private _symbol;
727 
728     // Mapping from token ID to ownership details
729     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
730     mapping(uint256 => TokenOwnership) internal _ownerships;
731 
732     // Mapping owner address to address data
733     mapping(address => AddressData) private _addressData;
734 
735     // Mapping from token ID to approved address
736     mapping(uint256 => address) private _tokenApprovals;
737 
738     // Mapping from owner to operator approvals
739     mapping(address => mapping(address => bool)) private _operatorApprovals;
740 
741     constructor(string memory name_, string memory symbol_) {
742         _name = name_;
743         _symbol = symbol_;
744     }
745 
746     /**
747      * @dev See {IERC721Enumerable-totalSupply}.
748      */
749     function totalSupply() public view override returns (uint256) {
750         return currentIndex;
751     }
752 
753     /**
754      * @dev See {IERC721Enumerable-tokenByIndex}.
755      */
756     function tokenByIndex(uint256 index) public view override returns (uint256) {
757         require(index < totalSupply(), 'ERC721A: global index out of bounds');
758         return index;
759     }
760 
761     /**
762      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
763      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
764      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
765      */
766     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
767         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
768         uint256 numMintedSoFar = totalSupply();
769         uint256 tokenIdsIdx = 0;
770         address currOwnershipAddr = address(0);
771         for (uint256 i = 0; i < numMintedSoFar; i++) {
772             TokenOwnership memory ownership = _ownerships[i];
773             if (ownership.addr != address(0)) {
774                 currOwnershipAddr = ownership.addr;
775             }
776             if (currOwnershipAddr == owner) {
777                 if (tokenIdsIdx == index) {
778                     return i;
779                 }
780                 tokenIdsIdx++;
781             }
782         }
783         revert('ERC721A: unable to get token of owner by index');
784     }
785 
786     /**
787      * @dev See {IERC165-supportsInterface}.
788      */
789     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
790         return
791             interfaceId == type(IERC721).interfaceId ||
792             interfaceId == type(IERC721Metadata).interfaceId ||
793             interfaceId == type(IERC721Enumerable).interfaceId ||
794             super.supportsInterface(interfaceId);
795     }
796 
797     /**
798      * @dev See {IERC721-balanceOf}.
799      */
800     function balanceOf(address owner) public view override returns (uint256) {
801         require(owner != address(0), 'ERC721A: balance query for the zero address');
802         return uint256(_addressData[owner].balance);
803     }
804 
805     function _numberMinted(address owner) internal view returns (uint256) {
806         require(owner != address(0), 'ERC721A: number minted query for the zero address');
807         return uint256(_addressData[owner].numberMinted);
808     }
809 
810     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
811         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
812 
813         for (uint256 curr = tokenId; ; curr--) {
814             TokenOwnership memory ownership = _ownerships[curr];
815             if (ownership.addr != address(0)) {
816                 return ownership;
817             }
818         }
819 
820         revert('ERC721A: unable to determine the owner of token');
821     }
822 
823     /**
824      * @dev See {IERC721-ownerOf}.
825      */
826     function ownerOf(uint256 tokenId) public view override returns (address) {
827         return ownershipOf(tokenId).addr;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-name}.
832      */
833     function name() public view virtual override returns (string memory) {
834         return _name;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-symbol}.
839      */
840     function symbol() public view virtual override returns (string memory) {
841         return _symbol;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-tokenURI}.
846      */
847     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
848         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
849 
850         string memory baseURI = _baseURI();
851         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
852     }
853 
854     /**
855      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
856      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
857      * by default, can be overriden in child contracts.
858      */
859     function _baseURI() internal view virtual returns (string memory) {
860         return '';
861     }
862 
863     /**
864      * @dev See {IERC721-approve}.
865      */
866     function approve(address to, uint256 tokenId) public override {
867         address owner = ERC721A.ownerOf(tokenId);
868         require(to != owner, 'ERC721A: approval to current owner');
869 
870         require(
871             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
872             'ERC721A: approve caller is not owner nor approved for all'
873         );
874 
875         _approve(to, tokenId, owner);
876     }
877 
878     /**
879      * @dev See {IERC721-getApproved}.
880      */
881     function getApproved(uint256 tokenId) public view override returns (address) {
882         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
883 
884         return _tokenApprovals[tokenId];
885     }
886 
887     /**
888      * @dev See {IERC721-setApprovalForAll}.
889      */
890     function setApprovalForAll(address operator, bool approved) public override {
891         require(operator != _msgSender(), 'ERC721A: approve to caller');
892 
893         _operatorApprovals[_msgSender()][operator] = approved;
894         emit ApprovalForAll(_msgSender(), operator, approved);
895     }
896 
897     /**
898      * @dev See {IERC721-isApprovedForAll}.
899      */
900     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
901         return _operatorApprovals[owner][operator];
902     }
903 
904     /**
905      * @dev See {IERC721-transferFrom}.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public override {
912         _transfer(from, to, tokenId);
913     }
914 
915     /**
916      * @dev See {IERC721-safeTransferFrom}.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId
922     ) public override {
923         safeTransferFrom(from, to, tokenId, '');
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) public override {
935         _transfer(from, to, tokenId);
936         require(
937             _checkOnERC721Received(from, to, tokenId, _data),
938             'ERC721A: transfer to non ERC721Receiver implementer'
939         );
940     }
941 
942     /**
943      * @dev Returns whether `tokenId` exists.
944      *
945      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
946      *
947      * Tokens start existing when they are minted (`_mint`),
948      */
949     function _exists(uint256 tokenId) internal view returns (bool) {
950         return tokenId < currentIndex;
951     }
952 
953     function _safeMint(address to, uint256 quantity) internal {
954         _safeMint(to, quantity, '');
955     }
956 
957     /**
958      * @dev Mints `quantity` tokens and transfers them to `to`.
959      *
960      * Requirements:
961      *
962      * - `to` cannot be the zero address.
963      * - `quantity` cannot be larger than the max batch size.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _safeMint(
968         address to,
969         uint256 quantity,
970         bytes memory _data
971     ) internal {
972         uint256 startTokenId = currentIndex;
973         require(to != address(0), 'ERC721A: mint to the zero address');
974         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
975         require(!_exists(startTokenId), 'ERC721A: token already minted');
976         require(quantity > 0, 'ERC721A: quantity must be greater 0');
977 
978         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
979 
980         AddressData memory addressData = _addressData[to];
981         _addressData[to] = AddressData(
982             addressData.balance + uint128(quantity),
983             addressData.numberMinted + uint128(quantity)
984         );
985         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
986 
987         uint256 updatedIndex = startTokenId;
988 
989         for (uint256 i = 0; i < quantity; i++) {
990             emit Transfer(address(0), to, updatedIndex);
991             require(
992                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
993                 'ERC721A: transfer to non ERC721Receiver implementer'
994             );
995             updatedIndex++;
996         }
997 
998       currentIndex = updatedIndex;
999         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1000     }
1001 
1002     /**
1003      * @dev Transfers `tokenId` from `from` to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must be owned by `from`.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) private {
1017         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1018 
1019         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1020             getApproved(tokenId) == _msgSender() ||
1021             isApprovedForAll(prevOwnership.addr, _msgSender()));
1022 
1023         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1024 
1025         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1026         require(to != address(0), 'ERC721A: transfer to the zero address');
1027 
1028         _beforeTokenTransfers(from, to, tokenId, 1);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId, prevOwnership.addr);
1032 
1033         // Underflow of the sender's balance is impossible because we check for
1034         // ownership above and the recipient's balance can't realistically overflow.
1035         unchecked {
1036             _addressData[from].balance -= 1;
1037             _addressData[to].balance += 1;
1038         }
1039 
1040         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1041 
1042         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1043         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1044         uint256 nextTokenId = tokenId + 1;
1045         if (_ownerships[nextTokenId].addr == address(0)) {
1046             if (_exists(nextTokenId)) {
1047                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1048             }
1049         }
1050 
1051         emit Transfer(from, to, tokenId);
1052         _afterTokenTransfers(from, to, tokenId, 1);
1053     }
1054 
1055     /**
1056      * @dev Approve `to` to operate on `tokenId`
1057      *
1058      * Emits a {Approval} event.
1059      */
1060     function _approve(
1061         address to,
1062         uint256 tokenId,
1063         address owner
1064     ) private {
1065         _tokenApprovals[tokenId] = to;
1066         emit Approval(owner, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1071      * The call is not executed if the target address is not a contract.
1072      *
1073      * @param from address representing the previous owner of the given token ID
1074      * @param to target address that will receive the tokens
1075      * @param tokenId uint256 ID of the token to be transferred
1076      * @param _data bytes optional data to send along with the call
1077      * @return bool whether the call correctly returned the expected magic value
1078      */
1079     function _checkOnERC721Received(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) private returns (bool) {
1085         if (to.isContract()) {
1086             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1087                 return retval == IERC721Receiver(to).onERC721Received.selector;
1088             } catch (bytes memory reason) {
1089                 if (reason.length == 0) {
1090                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1091                 } else {
1092                     assembly {
1093                         revert(add(32, reason), mload(reason))
1094                     }
1095                 }
1096             }
1097         } else {
1098             return true;
1099         }
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1104      *
1105      * startTokenId - the first token id to be transferred
1106      * quantity - the amount to be transferred
1107      *
1108      * Calling conditions:
1109      *
1110      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1111      * transferred to `to`.
1112      * - When `from` is zero, `tokenId` will be minted for `to`.
1113      */
1114     function _beforeTokenTransfers(
1115         address from,
1116         address to,
1117         uint256 startTokenId,
1118         uint256 quantity
1119     ) internal virtual {}
1120 
1121     /**
1122      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1123      * minting.
1124      *
1125      * startTokenId - the first token id to be transferred
1126      * quantity - the amount to be transferred
1127      *
1128      * Calling conditions:
1129      *
1130      * - when `from` and `to` are both non-zero.
1131      * - `from` and `to` are never both zero.
1132      */
1133     function _afterTokenTransfers(
1134         address from,
1135         address to,
1136         uint256 startTokenId,
1137         uint256 quantity
1138     ) internal virtual {}
1139 }
1140 
1141 contract XCOPYBAYC is ERC721A, Ownable {
1142 
1143     string public baseURI = "ipfs://QmcR6rFHX3fY2vQPnMeGj7QKox7dj8rrxFcisLcrWHXN7j/";
1144     string public contractURI = "ipfs://QmbJegAuXConSjVja8qkpFWNoSeE11qb7udTHtwe2tpkVG";
1145     string public constant baseExtension = ".json";
1146     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1147 
1148     uint256 public constant MAX_PER_TX_FREE = 5;
1149     uint256 public constant MAX_PER_TX = 10;
1150     uint256 public constant FREE_MAX_SUPPLY = 300;
1151     uint256 public MAX_SUPPLY = 3333;
1152     uint256 public price = 0.004 ether;
1153 
1154     bool public paused = true;
1155 
1156     constructor() ERC721A("XCOPYBAYC", "XBAYC") {}
1157 
1158     function mint(uint256 _amount) external payable {
1159         address _caller = _msgSender();
1160         require(!paused, "Paused");
1161         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1162         require(_amount > 0, "No 0 mints");
1163         require(tx.origin == _caller, "No contracts");
1164 
1165         if(FREE_MAX_SUPPLY >= totalSupply()){
1166             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1167         }else{
1168             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1169             require(_amount * price == msg.value, "Invalid funds provided");
1170         }
1171 
1172         _safeMint(_caller, _amount);
1173     }
1174 
1175 
1176 
1177     function withdraw() external onlyOwner {
1178         uint256 balance = address(this).balance;
1179         (bool success, ) = _msgSender().call{value: balance}("");
1180         require(success, "Failed to send");
1181     }
1182 
1183     function pause(bool _state) external onlyOwner {
1184         paused = _state;
1185     }
1186 
1187     function setBaseURI(string memory baseURI_) external onlyOwner {
1188         baseURI = baseURI_;
1189     }
1190 
1191     function setContractURI(string memory _contractURI) external onlyOwner {
1192         contractURI = _contractURI;
1193     }
1194 
1195 function setPrice(uint256 newPrice) public onlyOwner {
1196         price = newPrice;
1197 }
1198 
1199 function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1200         MAX_SUPPLY = newSupply;
1201 }
1202 
1203 
1204     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1205         require(_exists(_tokenId), "Token does not exist.");
1206         return bytes(baseURI).length > 0 ? string(
1207             abi.encodePacked(
1208               baseURI,
1209               Strings.toString(_tokenId),
1210               baseExtension
1211             )
1212         ) : "";
1213     }
1214 }