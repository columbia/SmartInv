1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
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
177 // File: @openzeppelin/contracts/utils/Address.sol
178 
179 
180 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
181 
182 pragma solidity ^0.8.1;
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      *
205      * [IMPORTANT]
206      * ====
207      * You shouldn't rely on `isContract` to protect against flash loan attacks!
208      *
209      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
210      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
211      * constructor.
212      * ====
213      */
214     function isContract(address account) internal view returns (bool) {
215         // This method relies on extcodesize/address.code.length, which returns 0
216         // for contracts in construction, since the code is only stored at the end
217         // of the constructor execution.
218 
219         return account.code.length > 0;
220     }
221 
222     /**
223      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
224      * `recipient`, forwarding all available gas and reverting on errors.
225      *
226      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
227      * of certain opcodes, possibly making contracts go over the 2300 gas limit
228      * imposed by `transfer`, making them unable to receive funds via
229      * `transfer`. {sendValue} removes this limitation.
230      *
231      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
232      *
233      * IMPORTANT: because control is transferred to `recipient`, care must be
234      * taken to not create reentrancy vulnerabilities. Consider using
235      * {ReentrancyGuard} or the
236      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
237      */
238     function sendValue(address payable recipient, uint256 amount) internal {
239         require(address(this).balance >= amount, "Address: insufficient balance");
240 
241         (bool success, ) = recipient.call{value: amount}("");
242         require(success, "Address: unable to send value, recipient may have reverted");
243     }
244 
245     /**
246      * @dev Performs a Solidity function call using a low level `call`. A
247      * plain `call` is an unsafe replacement for a function call: use this
248      * function instead.
249      *
250      * If `target` reverts with a revert reason, it is bubbled up by this
251      * function (like regular Solidity function calls).
252      *
253      * Returns the raw returned data. To convert to the expected return value,
254      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
255      *
256      * Requirements:
257      *
258      * - `target` must be a contract.
259      * - calling `target` with `data` must not revert.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionCall(target, data, "Address: low-level call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
269      * `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, 0, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but also transferring `value` wei to `target`.
284      *
285      * Requirements:
286      *
287      * - the calling contract must have an ETH balance of at least `value`.
288      * - the called Solidity function must be `payable`.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
302      * with `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         require(address(this).balance >= value, "Address: insufficient balance for call");
313         require(isContract(target), "Address: call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.call{value: value}(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
326         return functionStaticCall(target, data, "Address: low-level static call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal view returns (bytes memory) {
340         require(isContract(target), "Address: static call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(isContract(target), "Address: delegate call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.delegatecall(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
375      * revert reason using the provided one.
376      *
377      * _Available since v4.3._
378      */
379     function verifyCallResult(
380         bool success,
381         bytes memory returndata,
382         string memory errorMessage
383     ) internal pure returns (bytes memory) {
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @title ERC721 token receiver interface
411  * @dev Interface for any contract that wants to support safeTransfers
412  * from ERC721 asset contracts.
413  */
414 interface IERC721Receiver {
415     /**
416      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
417      * by `operator` from `from`, this function is called.
418      *
419      * It must return its Solidity selector to confirm the token transfer.
420      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
421      *
422      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
423      */
424     function onERC721Received(
425         address operator,
426         address from,
427         uint256 tokenId,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Interface of the ERC165 standard, as defined in the
441  * https://eips.ethereum.org/EIPS/eip-165[EIP].
442  *
443  * Implementers can declare support of contract interfaces, which can then be
444  * queried by others ({ERC165Checker}).
445  *
446  * For an implementation, see {ERC165}.
447  */
448 interface IERC165 {
449     /**
450      * @dev Returns true if this contract implements the interface defined by
451      * `interfaceId`. See the corresponding
452      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
453      * to learn more about how these ids are created.
454      *
455      * This function call must use less than 30 000 gas.
456      */
457     function supportsInterface(bytes4 interfaceId) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev Implementation of the {IERC165} interface.
470  *
471  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
472  * for the additional interface id that will be supported. For example:
473  *
474  * ```solidity
475  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
476  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
477  * }
478  * ```
479  *
480  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
481  */
482 abstract contract ERC165 is IERC165 {
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487         return interfaceId == type(IERC165).interfaceId;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @dev Required interface of an ERC721 compliant contract.
501  */
502 interface IERC721 is IERC165 {
503     /**
504      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
505      */
506     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
510      */
511     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
515      */
516     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
517 
518     /**
519      * @dev Returns the number of tokens in ``owner``'s account.
520      */
521     function balanceOf(address owner) external view returns (uint256 balance);
522 
523     /**
524      * @dev Returns the owner of the `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function ownerOf(uint256 tokenId) external view returns (address owner);
531 
532     /**
533      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
534      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must exist and be owned by `from`.
541      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
543      *
544      * Emits a {Transfer} event.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) external;
551 
552     /**
553      * @dev Transfers `tokenId` token from `from` to `to`.
554      *
555      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must be owned by `from`.
562      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
563      *
564      * Emits a {Transfer} event.
565      */
566     function transferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
574      * The approval is cleared when the token is transferred.
575      *
576      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
577      *
578      * Requirements:
579      *
580      * - The caller must own the token or be an approved operator.
581      * - `tokenId` must exist.
582      *
583      * Emits an {Approval} event.
584      */
585     function approve(address to, uint256 tokenId) external;
586 
587     /**
588      * @dev Returns the account approved for `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function getApproved(uint256 tokenId) external view returns (address operator);
595 
596     /**
597      * @dev Approve or remove `operator` as an operator for the caller.
598      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
599      *
600      * Requirements:
601      *
602      * - The `operator` cannot be the caller.
603      *
604      * Emits an {ApprovalForAll} event.
605      */
606     function setApprovalForAll(address operator, bool _approved) external;
607 
608     /**
609      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
610      *
611      * See {setApprovalForAll}
612      */
613     function isApprovedForAll(address owner, address operator) external view returns (bool);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
646  * @dev See https://eips.ethereum.org/EIPS/eip-721
647  */
648 interface IERC721Metadata is IERC721 {
649     /**
650      * @dev Returns the token collection name.
651      */
652     function name() external view returns (string memory);
653 
654     /**
655      * @dev Returns the token collection symbol.
656      */
657     function symbol() external view returns (string memory);
658 
659     /**
660      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
661      */
662     function tokenURI(uint256 tokenId) external view returns (string memory);
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
666 
667 
668 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 
674 
675 
676 
677 
678 
679 /**
680  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
681  * the Metadata extension, but not including the Enumerable extension, which is available separately as
682  * {ERC721Enumerable}.
683  */
684 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
685     using Address for address;
686     using Strings for uint256;
687 
688     // Token name
689     string private _name;
690 
691     // Token symbol
692     string private _symbol;
693 
694     // Mapping from token ID to owner address
695     mapping(uint256 => address) private _owners;
696 
697     // Mapping owner address to token count
698     mapping(address => uint256) private _balances;
699 
700     // Mapping from token ID to approved address
701     mapping(uint256 => address) private _tokenApprovals;
702 
703     // Mapping from owner to operator approvals
704     mapping(address => mapping(address => bool)) private _operatorApprovals;
705 
706     /**
707      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
708      */
709     constructor(string memory name_, string memory symbol_) {
710         _name = name_;
711         _symbol = symbol_;
712     }
713 
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
718         return
719             interfaceId == type(IERC721).interfaceId ||
720             interfaceId == type(IERC721Metadata).interfaceId ||
721             super.supportsInterface(interfaceId);
722     }
723 
724     /**
725      * @dev See {IERC721-balanceOf}.
726      */
727     function balanceOf(address owner) public view virtual override returns (uint256) {
728         require(owner != address(0), "ERC721: balance query for the zero address");
729         return _balances[owner];
730     }
731 
732     /**
733      * @dev See {IERC721-ownerOf}.
734      */
735     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
736         address owner = _owners[tokenId];
737         require(owner != address(0), "ERC721: owner query for nonexistent token");
738         return owner;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-name}.
743      */
744     function name() public view virtual override returns (string memory) {
745         return _name;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-symbol}.
750      */
751     function symbol() public view virtual override returns (string memory) {
752         return _symbol;
753     }
754 
755     /**
756      * @dev See {IERC721Metadata-tokenURI}.
757      */
758     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
759         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
760 
761         string memory baseURI = _baseURI();
762         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
763     }
764 
765     /**
766      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
767      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
768      * by default, can be overriden in child contracts.
769      */
770     function _baseURI() internal view virtual returns (string memory) {
771         return "";
772     }
773 
774     /**
775      * @dev See {IERC721-approve}.
776      */
777     function approve(address to, uint256 tokenId) public virtual override {
778         address owner = ERC721.ownerOf(tokenId);
779         require(to != owner, "ERC721: approval to current owner");
780 
781         require(
782             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
783             "ERC721: approve caller is not owner nor approved for all"
784         );
785 
786         _approve(to, tokenId);
787     }
788 
789     /**
790      * @dev See {IERC721-getApproved}.
791      */
792     function getApproved(uint256 tokenId) public view virtual override returns (address) {
793         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
794 
795         return _tokenApprovals[tokenId];
796     }
797 
798     /**
799      * @dev See {IERC721-setApprovalForAll}.
800      */
801     function setApprovalForAll(address operator, bool approved) public virtual override {
802         _setApprovalForAll(_msgSender(), operator, approved);
803     }
804 
805     /**
806      * @dev See {IERC721-isApprovedForAll}.
807      */
808     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
809         return _operatorApprovals[owner][operator];
810     }
811 
812     /**
813      * @dev See {IERC721-transferFrom}.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) public virtual override {
820         //solhint-disable-next-line max-line-length
821         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
822 
823         _transfer(from, to, tokenId);
824     }
825 
826     /**
827      * @dev See {IERC721-safeTransferFrom}.
828      */
829     function safeTransferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) public virtual override {
834         safeTransferFrom(from, to, tokenId, "");
835     }
836 
837     /**
838      * @dev See {IERC721-safeTransferFrom}.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes memory _data
845     ) public virtual override {
846         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
847         _safeTransfer(from, to, tokenId, _data);
848     }
849 
850     /**
851      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
852      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
853      *
854      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
855      *
856      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
857      * implement alternative mechanisms to perform token transfer, such as signature-based.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must exist and be owned by `from`.
864      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _safeTransfer(
869         address from,
870         address to,
871         uint256 tokenId,
872         bytes memory _data
873     ) internal virtual {
874         _transfer(from, to, tokenId);
875         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
876     }
877 
878     /**
879      * @dev Returns whether `tokenId` exists.
880      *
881      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
882      *
883      * Tokens start existing when they are minted (`_mint`),
884      * and stop existing when they are burned (`_burn`).
885      */
886     function _exists(uint256 tokenId) internal view virtual returns (bool) {
887         return _owners[tokenId] != address(0);
888     }
889 
890     /**
891      * @dev Returns whether `spender` is allowed to manage `tokenId`.
892      *
893      * Requirements:
894      *
895      * - `tokenId` must exist.
896      */
897     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
898         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
899         address owner = ERC721.ownerOf(tokenId);
900         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
901     }
902 
903     /**
904      * @dev Safely mints `tokenId` and transfers it to `to`.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must not exist.
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _safeMint(address to, uint256 tokenId) internal virtual {
914         _safeMint(to, tokenId, "");
915     }
916 
917     /**
918      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
919      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
920      */
921     function _safeMint(
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) internal virtual {
926         _mint(to, tokenId);
927         require(
928             _checkOnERC721Received(address(0), to, tokenId, _data),
929             "ERC721: transfer to non ERC721Receiver implementer"
930         );
931     }
932 
933     /**
934      * @dev Mints `tokenId` and transfers it to `to`.
935      *
936      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
937      *
938      * Requirements:
939      *
940      * - `tokenId` must not exist.
941      * - `to` cannot be the zero address.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _mint(address to, uint256 tokenId) internal virtual {
946         require(to != address(0), "ERC721: mint to the zero address");
947         require(!_exists(tokenId), "ERC721: token already minted");
948 
949         _beforeTokenTransfer(address(0), to, tokenId);
950 
951         _balances[to] += 1;
952         _owners[tokenId] = to;
953 
954         emit Transfer(address(0), to, tokenId);
955 
956         _afterTokenTransfer(address(0), to, tokenId);
957     }
958 
959     /**
960      * @dev Destroys `tokenId`.
961      * The approval is cleared when the token is burned.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _burn(uint256 tokenId) internal virtual {
970         address owner = ERC721.ownerOf(tokenId);
971 
972         _beforeTokenTransfer(owner, address(0), tokenId);
973 
974         // Clear approvals
975         _approve(address(0), tokenId);
976 
977         _balances[owner] -= 1;
978         delete _owners[tokenId];
979 
980         emit Transfer(owner, address(0), tokenId);
981 
982         _afterTokenTransfer(owner, address(0), tokenId);
983     }
984 
985     /**
986      * @dev Transfers `tokenId` from `from` to `to`.
987      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
988      *
989      * Requirements:
990      *
991      * - `to` cannot be the zero address.
992      * - `tokenId` token must be owned by `from`.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _transfer(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) internal virtual {
1001         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1002         require(to != address(0), "ERC721: transfer to the zero address");
1003 
1004         _beforeTokenTransfer(from, to, tokenId);
1005 
1006         // Clear approvals from the previous owner
1007         _approve(address(0), tokenId);
1008 
1009         _balances[from] -= 1;
1010         _balances[to] += 1;
1011         _owners[tokenId] = to;
1012 
1013         emit Transfer(from, to, tokenId);
1014 
1015         _afterTokenTransfer(from, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Approve `to` to operate on `tokenId`
1020      *
1021      * Emits a {Approval} event.
1022      */
1023     function _approve(address to, uint256 tokenId) internal virtual {
1024         _tokenApprovals[tokenId] = to;
1025         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev Approve `operator` to operate on all of `owner` tokens
1030      *
1031      * Emits a {ApprovalForAll} event.
1032      */
1033     function _setApprovalForAll(
1034         address owner,
1035         address operator,
1036         bool approved
1037     ) internal virtual {
1038         require(owner != operator, "ERC721: approve to caller");
1039         _operatorApprovals[owner][operator] = approved;
1040         emit ApprovalForAll(owner, operator, approved);
1041     }
1042 
1043     /**
1044      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1045      * The call is not executed if the target address is not a contract.
1046      *
1047      * @param from address representing the previous owner of the given token ID
1048      * @param to target address that will receive the tokens
1049      * @param tokenId uint256 ID of the token to be transferred
1050      * @param _data bytes optional data to send along with the call
1051      * @return bool whether the call correctly returned the expected magic value
1052      */
1053     function _checkOnERC721Received(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) private returns (bool) {
1059         if (to.isContract()) {
1060             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1061                 return retval == IERC721Receiver.onERC721Received.selector;
1062             } catch (bytes memory reason) {
1063                 if (reason.length == 0) {
1064                     revert("ERC721: transfer to non ERC721Receiver implementer");
1065                 } else {
1066                     assembly {
1067                         revert(add(32, reason), mload(reason))
1068                     }
1069                 }
1070             }
1071         } else {
1072             return true;
1073         }
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before any token transfer. This includes minting
1078      * and burning.
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1086      * - `from` and `to` are never both zero.
1087      *
1088      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1089      */
1090     function _beforeTokenTransfer(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) internal virtual {}
1095 
1096     /**
1097      * @dev Hook that is called after any transfer of tokens. This includes
1098      * minting and burning.
1099      *
1100      * Calling conditions:
1101      *
1102      * - when `from` and `to` are both non-zero.
1103      * - `from` and `to` are never both zero.
1104      *
1105      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1106      */
1107     function _afterTokenTransfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) internal virtual {}
1112 }
1113 
1114 // File: contracts/cleomint.sol
1115 
1116 
1117 pragma solidity ^0.8.9;
1118 
1119 
1120 
1121 interface ICLEO {
1122     function balanceOf(address owner) external view returns (uint);
1123     function burn(address account, uint amount) external;
1124 }
1125 
1126 interface ICleoStake {
1127     function randomCobraOwner() external returns (address);
1128     function addTokensToStake(address account, uint16[] calldata tokenIds) external;
1129     function _addToMapping(uint tokenId) external;
1130 }
1131 
1132 contract CleoCannaClub is ERC721, Ownable {
1133     using Strings for uint256;
1134     uint public MAX_TOKENS = 39999;
1135     uint public MINT_PER_TX_LIMIT = 20;
1136 
1137     uint public tokensMinted = 0;
1138     uint16 public phase = 0;
1139     uint16 public cobrasStolen = 0;
1140     uint16 public cleosStolen = 0;
1141     uint16 public cobrasMinted = 0;
1142     uint16 public cleosMinted = 0;
1143 
1144     //payment splitters
1145     address payable public PrimarySplitter;
1146     address payable public SecondarySplitter;
1147     
1148 
1149     bool private _paused = true;
1150     bool public isWhiteListActive = false;
1151 
1152     mapping(uint16 => uint) public phasePrice;
1153     mapping(address => uint) private _whiteList;
1154 
1155     ICleoStake public cleoStake;
1156     ICLEO public CLEO;
1157 
1158     string private _apiURI = "https://cleo10k.s3.amazonaws.com/json/";
1159     string public baseExtension = ".json";
1160     mapping(uint16 => bool) private _isCobra;
1161     
1162     uint16[] private _availableTokens;
1163     uint16 private _randomIndex = 0;
1164     uint private _randomCalls = 0;
1165 
1166     mapping(uint16 => address) private _randomSource;
1167 
1168     event TokenStolen(address owner, uint16 tokenId, address thief);
1169 
1170     constructor(address _primarySplitter) ERC721("Cleo Canna Club", "CCC") {
1171         PrimarySplitter = payable(_primarySplitter);
1172         // How many we mint to ourselves can pick which ones we want
1173 
1174         // Phase 1 is available in the beginning
1175         switchToSalePhase(0, true);
1176 
1177         phasePrice[0] = 0.00 ether;
1178 
1179         // Set default price for each phase
1180         phasePrice[1] = 0.069 ether;
1181         // These phases will mint using cleocoin
1182         phasePrice[2] = 20000 ether;
1183         phasePrice[3] = 40000 ether;
1184         phasePrice[4] = 80000 ether;
1185         
1186         // Fill random source addresses
1187         _randomSource[0] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1188         _randomSource[1] = 0x3cD751E6b0078Be393132286c442345e5DC49699;
1189         _randomSource[2] = 0xb5d85CBf7cB3EE0D56b3bB207D5Fc4B82f43F511;
1190         _randomSource[3] = 0xC098B2a3Aa256D2140208C3de6543aAEf5cd3A94;
1191         _randomSource[4] = 0x28C6c06298d514Db089934071355E5743bf21d60;
1192         _randomSource[5] = 0x2FAF487A4414Fe77e2327F0bf4AE2a264a776AD2;
1193         _randomSource[6] = 0x267be1C1D684F78cb4F6a176C4911b741E4Ffdc0;
1194     }
1195 
1196     function setMaxTokens(uint  _newMax) external onlyOwner {
1197         MAX_TOKENS = _newMax;
1198     }
1199     function setMintTxLimit(uint _newLimit) external onlyOwner {
1200         MINT_PER_TX_LIMIT = _newLimit;
1201     }
1202     function paused() public view virtual returns (bool) {
1203         return _paused;
1204     }
1205 
1206     modifier whenNotPaused() {
1207         require(!paused(), "Pausable: paused");
1208         _;
1209     }
1210     modifier whenPaused() {
1211         require(paused(), "Pausable: not paused");
1212         _;
1213     }
1214 
1215     function setPaused(bool _state) external onlyOwner {
1216         _paused = _state;
1217     }
1218 
1219     function setIWhiteListActive(bool _isWhiteListActive) external onlyOwner {
1220         isWhiteListActive = _isWhiteListActive;
1221     }
1222 
1223     function setWhiteList(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
1224         for (uint256 i = 0; i < addresses.length; i++) {
1225             _whiteList[addresses[i]] = numAllowedToMint;
1226             }
1227     }
1228 
1229     function addAvailableTokens(uint16 _from, uint16 _to) public onlyOwner {
1230         internalAddTokens(_from, _to);
1231     }
1232 
1233     function internalAddTokens(uint16 _from, uint16 _to) internal {
1234         for (uint16 i = _from; i <= _to; i++) {
1235             _availableTokens.push(i);
1236         }
1237     }
1238 
1239     function switchToSalePhase(uint16 _phase, bool _setTokens) public onlyOwner {
1240         phase = _phase;
1241 
1242         if (!_setTokens) {
1243             return;
1244         }
1245         if(phase == 0){
1246             internalAddTokens(1, 2222);
1247         } else if (phase == 1) {
1248             internalAddTokens(2223, 9999);
1249         } else if (phase == 2) {
1250             internalAddTokens(10000, 19999);
1251         } else if (phase == 3) {
1252             internalAddTokens(20000, 29999);
1253         } else if (phase == 4) {
1254             internalAddTokens(30000, 39999);
1255         }
1256     }
1257 
1258     function giveAwayRandom(uint _amount, address _address) public onlyOwner {
1259         require(tokensMinted + _amount <= MAX_TOKENS, "All tokens minted");
1260         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1261 
1262         for (uint i = 0; i < _amount; i++) {
1263             uint16 tokenId = getTokenToBeMinted();
1264             if (isCobra(tokenId) == false) {
1265                 cleoStake._addToMapping(tokenId);
1266             }
1267             _safeMint(_address, tokenId);
1268             tokensMinted++;
1269         }
1270     }
1271 
1272     function giveAwayId(uint16 _id, address _address) public onlyOwner {
1273         require(tokensMinted + 1  <= MAX_TOKENS, "All tokens minted");
1274         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1275         if (isCobra(_id) == false) {
1276                 cleoStake._addToMapping(_id);
1277         }
1278         _safeMint(_address, _id);
1279         tokensMinted++;
1280     }
1281 
1282     function mint(uint _amount, bool _stake) public payable whenNotPaused {
1283         require(tx.origin == msg.sender, "Only EOA");
1284         require(tokensMinted + _amount <= MAX_TOKENS, "All tokens minted");
1285         require(_amount > 0 && _amount <= MINT_PER_TX_LIMIT, "Invalid mint amount");
1286         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1287 
1288         uint totalPennyCost = 0;
1289         if (phase == 1) {
1290             // Paid mint
1291             require(mintPrice(_amount) == msg.value, "Invalid payment amount");
1292         } else {
1293             // Mint via Penny token burn
1294             require(msg.value == 0, "Now minting is done via Penny");
1295             totalPennyCost = mintPrice(_amount);
1296             require(CLEO.balanceOf(msg.sender) >= totalPennyCost, "Not enough Penny");
1297         }
1298 
1299         if (totalPennyCost > 0) {
1300             CLEO.burn(msg.sender, totalPennyCost);
1301         }
1302 
1303         tokensMinted += _amount;
1304         uint16[] memory tokenIds = _stake ? new uint16[](_amount) : new uint16[](0);
1305         for (uint i = 0; i < _amount; i++) {
1306             address recipient = selectRecipient();
1307             if (phase != 1 || phase != 0 ) {
1308                 updateRandomIndex();
1309             }
1310 
1311             uint16 tokenId = getTokenToBeMinted();
1312             
1313 
1314             if (isCobra(tokenId)) {
1315                 cobrasMinted += 1;
1316             }
1317             if (isCobra(tokenId) == false) {
1318                 cleoStake._addToMapping(tokenId);
1319             }
1320 
1321             if (recipient != msg.sender) {
1322                 isCobra(tokenId) ? cobrasStolen += 1 : cleosStolen += 1;
1323                 emit TokenStolen(msg.sender, tokenId, recipient);
1324             }
1325             
1326             if (!_stake || recipient != msg.sender) {
1327                 _safeMint(recipient, tokenId);
1328             } else {
1329                 _safeMint(address(cleoStake), tokenId);
1330                 tokenIds[i] = tokenId;
1331             }
1332         }
1333         if (_stake) {
1334             cleoStake.addTokensToStake(msg.sender, tokenIds);
1335         }
1336     }
1337 
1338     function whitlistMint(uint _amount, bool _stake) public payable {
1339         require(isWhiteListActive, "Whitlelist is not active");
1340         require(_amount <= _whiteList[msg.sender], "Exceeded max available to purchase");
1341         require(tx.origin == msg.sender, "Only EOA");
1342         require(tokensMinted + _amount <= MAX_TOKENS, "Purhase Would exeeed max tokens");
1343         require(_amount > 0 && _amount <= MINT_PER_TX_LIMIT, "Invalid mint amount");
1344         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1345 
1346         
1347         //require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
1348         //require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");
1349 
1350         _whiteList[msg.sender] -= _amount;
1351 
1352         uint totalPennyCost = 0;
1353         if (phase == 1 || phase == 0) {
1354             // Paid mint
1355             require(mintPrice(_amount) == msg.value, "Invalid payment amount");
1356         } else {
1357             // Mint via Penny token burn
1358             require(msg.value == 0, "Can only mint using $CLEO");
1359             totalPennyCost = mintPrice(_amount);
1360             require(CLEO.balanceOf(msg.sender) >= totalPennyCost, "Not enough $CLEO");
1361         }
1362 
1363         if (totalPennyCost > 0) {
1364             CLEO.burn(msg.sender, totalPennyCost);
1365         }
1366 
1367         tokensMinted += _amount;
1368         uint16[] memory tokenIds = _stake ? new uint16[](_amount) : new uint16[](0);
1369         for (uint i = 0; i < _amount; i++) {
1370             address recipient = selectRecipient();
1371             if (phase != 1) {
1372                 updateRandomIndex();
1373             }
1374 
1375             uint16 tokenId = getTokenToBeMinted();
1376             
1377 
1378             if (isCobra(tokenId)) {
1379                 cobrasMinted += 1;
1380             }
1381             if (isCobra(tokenId) == false) {
1382                 cleoStake._addToMapping(tokenId);
1383             }
1384 
1385             if (recipient != msg.sender) {
1386                 isCobra(tokenId) ? cobrasStolen += 1 : cleosStolen += 1;
1387                 emit TokenStolen(msg.sender, tokenId, recipient);
1388             }
1389             
1390             if (!_stake || recipient != msg.sender) {
1391                 _safeMint(recipient, tokenId);
1392             } else {
1393                 _safeMint(address(cleoStake), tokenId);
1394                 tokenIds[i] = tokenId;
1395             }
1396         }
1397         if (_stake) {
1398             cleoStake.addTokensToStake(msg.sender, tokenIds);
1399         }
1400     }
1401 
1402     function selectRecipient() internal returns (address) {
1403         if (phase == 1 || phase == 0) {
1404             return msg.sender; // During ETH sale there is no chance to steal NTF
1405         }
1406 
1407         // 10% chance to steal NTF
1408         if (getSomeRandomNumber(cobrasMinted, 100) >= 10) {
1409             return msg.sender; // 90%
1410         }
1411 
1412         address thief = cleoStake.randomCobraOwner();
1413         if (thief == address(0x0)) {
1414             return msg.sender;
1415         }
1416         return thief;
1417     }
1418 
1419     function mintPrice(uint _amount) public view returns (uint) {
1420         return _amount * phasePrice[phase];
1421     }
1422 
1423     function isCobra(uint16 id) public view returns (bool) {
1424         return _isCobra[id];
1425     }
1426 
1427     function getTokenToBeMinted() private returns (uint16) {
1428         uint random = getSomeRandomNumber(_availableTokens.length, _availableTokens.length);
1429         uint16 tokenId = _availableTokens[random];
1430 
1431         _availableTokens[random] = _availableTokens[_availableTokens.length - 1];
1432         _availableTokens.pop();
1433         return tokenId;
1434     }
1435     
1436     function updateRandomIndex() internal {
1437         _randomIndex += 1;
1438         _randomCalls += 1;
1439         if (_randomIndex > 6) _randomIndex = 0;
1440     }
1441 
1442     function getSomeRandomNumber(uint _seed, uint _limit) internal view returns (uint16) {
1443         uint extra = 0;
1444         for (uint16 i = 0; i < 7; i++) {
1445             extra += _randomSource[_randomIndex].balance;
1446         }
1447 
1448         uint random = uint(
1449             keccak256(
1450                 abi.encodePacked(
1451                     _seed,
1452                     blockhash(block.number - 1),
1453                     block.coinbase,
1454                     block.difficulty,
1455                     msg.sender,
1456                     tokensMinted,
1457                     extra,
1458                     _randomCalls,
1459                     _randomIndex
1460                 )
1461             )
1462         );
1463 
1464         return uint16(random % _limit);
1465     }
1466 
1467     function tokenURI(uint256 tokenId)
1468     public
1469     view
1470     virtual
1471     override
1472     returns (string memory)
1473   {
1474         require(
1475         _exists(tokenId),
1476         "ERC721Metadata: URI query for nonexistent token"
1477     );
1478     
1479     string memory currentBaseURI = _apiURI;
1480     return bytes(currentBaseURI).length > 0
1481         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1482         : "";
1483   }
1484     function shuffleSeeds(uint _seed, uint _max) external onlyOwner {
1485         uint shuffleCount = getSomeRandomNumber(_seed, _max);
1486         _randomIndex = uint16(shuffleCount);
1487         for (uint i = 0; i < shuffleCount; i++) {
1488             updateRandomIndex();
1489         }
1490     }
1491 
1492     function setCobraId(uint16 id, bool special) external onlyOwner {
1493         _isCobra[id] = special;
1494     }
1495 
1496     function setCobraIds(uint16[] calldata ids) external onlyOwner {
1497         for (uint i = 0; i < ids.length; i++) {
1498             _isCobra[ids[i]] = true;
1499         }
1500     }
1501 
1502     function setCleoStake(address _stake) external onlyOwner {
1503         cleoStake = ICleoStake(_stake);
1504     }
1505 
1506     function setCleo(address _cleo) external onlyOwner {
1507         CLEO = ICLEO(_cleo);
1508     }
1509 
1510     function changePhasePrice(uint16 _phase, uint _weiPrice) external onlyOwner {
1511         phasePrice[_phase] = _weiPrice;
1512     }
1513 
1514     function transferFrom(address from, address to, uint tokenId) public virtual override {
1515         // Hardcode the Manager's approval so that users don't have to waste gas approving
1516         if (_msgSender() != address(cleoStake))
1517             require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1518         _transfer(from, to, tokenId);
1519     }
1520 
1521     function totalSupply() external view returns (uint) {
1522         return tokensMinted;
1523     }
1524 
1525     function _baseURI() internal view override returns (string memory) {
1526         return _apiURI;
1527     }
1528 
1529     function setBaseURI(string memory uri) external onlyOwner {
1530         _apiURI = uri;
1531     }
1532 
1533     function changeRandomSource(uint16 _id, address _address) external onlyOwner {
1534         _randomSource[_id] = _address;
1535     }
1536 
1537     function withdraw() external onlyOwner {
1538         (bool success, ) = payable(PrimarySplitter).call{value: address(this).balance}("");
1539         require(success);
1540     }
1541 }