1 /**
2  *Submitted for verification at Etherscan.io on 01-07-2022
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Context.sol
78 
79 
80 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 abstract contract Context {
95     function _msgSender() internal view virtual returns (address) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes calldata) {
100         return msg.data;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/access/Ownable.sol
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 
112 /**
113  * @dev Contract module which provides a basic access control mechanism, where
114  * there is an account (an owner) that can be granted exclusive access to
115  * specific functions.
116  *
117  * By default, the owner account will be the one that deploys the contract. This
118  * can later be changed with {transferOwnership}.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be applied to your functions to restrict their use to
122  * the owner.
123  */
124 abstract contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor() {
133         _transferOwnership(_msgSender());
134     }
135 
136     /**
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view virtual returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(owner() == _msgSender(), "Ownable: caller is not the owner");
148         _;
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         _transferOwnership(address(0));
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Can only be called by the current owner.
165      */
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         _transferOwnership(newOwner);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Internal function without access restriction.
174      */
175     function _transferOwnership(address newOwner) internal virtual {
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 // File: @openzeppelin/contracts/utils/Address.sol
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Collection of functions related to the address type
191  */
192 library Address {
193     /**
194      * @dev Returns true if `account` is a contract.
195      *
196      * [IMPORTANT]
197      * ====
198      * It is unsafe to assume that an address for which this function returns
199      * false is an externally-owned account (EOA) and not a contract.
200      *
201      * Among others, `isContract` will return false for the following
202      * types of addresses:
203      *
204      *  - an externally-owned account
205      *  - a contract in construction
206      *  - an address where a contract will be created
207      *  - an address where a contract lived, but was destroyed
208      * ====
209      */
210     function isContract(address account) internal view returns (bool) {
211         // This method relies on extcodesize, which returns 0 for contracts in
212         // construction, since the code is only stored at the end of the
213         // constructor execution.
214 
215         uint256 size;
216         assembly {
217             size := extcodesize(account)
218         }
219         return size > 0;
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
668 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
955     }
956 
957     /**
958      * @dev Destroys `tokenId`.
959      * The approval is cleared when the token is burned.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _burn(uint256 tokenId) internal virtual {
968         address owner = ERC721.ownerOf(tokenId);
969 
970         _beforeTokenTransfer(owner, address(0), tokenId);
971 
972         // Clear approvals
973         _approve(address(0), tokenId);
974 
975         _balances[owner] -= 1;
976         delete _owners[tokenId];
977 
978         emit Transfer(owner, address(0), tokenId);
979     }
980 
981     /**
982      * @dev Transfers `tokenId` from `from` to `to`.
983      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must be owned by `from`.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _transfer(
993         address from,
994         address to,
995         uint256 tokenId
996     ) internal virtual {
997         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
998         require(to != address(0), "ERC721: transfer to the zero address");
999 
1000         _beforeTokenTransfer(from, to, tokenId);
1001 
1002         // Clear approvals from the previous owner
1003         _approve(address(0), tokenId);
1004 
1005         _balances[from] -= 1;
1006         _balances[to] += 1;
1007         _owners[tokenId] = to;
1008 
1009         emit Transfer(from, to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Approve `to` to operate on `tokenId`
1014      *
1015      * Emits a {Approval} event.
1016      */
1017     function _approve(address to, uint256 tokenId) internal virtual {
1018         _tokenApprovals[tokenId] = to;
1019         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Approve `operator` to operate on all of `owner` tokens
1024      *
1025      * Emits a {ApprovalForAll} event.
1026      */
1027     function _setApprovalForAll(
1028         address owner,
1029         address operator,
1030         bool approved
1031     ) internal virtual {
1032         require(owner != operator, "ERC721: approve to caller");
1033         _operatorApprovals[owner][operator] = approved;
1034         emit ApprovalForAll(owner, operator, approved);
1035     }
1036 
1037     /**
1038      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1039      * The call is not executed if the target address is not a contract.
1040      *
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkOnERC721Received(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) private returns (bool) {
1053         if (to.isContract()) {
1054             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1055                 return retval == IERC721Receiver.onERC721Received.selector;
1056             } catch (bytes memory reason) {
1057                 if (reason.length == 0) {
1058                     revert("ERC721: transfer to non ERC721Receiver implementer");
1059                 } else {
1060                     assembly {
1061                         revert(add(32, reason), mload(reason))
1062                     }
1063                 }
1064             }
1065         } else {
1066             return true;
1067         }
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before any token transfer. This includes minting
1072      * and burning.
1073      *
1074      * Calling conditions:
1075      *
1076      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1077      * transferred to `to`.
1078      * - When `from` is zero, `tokenId` will be minted for `to`.
1079      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1080      * - `from` and `to` are never both zero.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual {}
1089 }
1090 
1091 // File: contracts/MicroExplorers.sol
1092 
1093 pragma solidity >=0.7.0 <0.9.0;
1094 
1095 contract MicroExplorers is ERC721, Ownable {
1096 using Strings for uint256;
1097 
1098   string public baseURI;
1099   string public baseExtension = ".json";
1100   uint256 public cost = 0.01 ether;
1101   uint256 public maxSupply = 10000;
1102   uint256 public maxMintAmount = 20;
1103   uint256 public nextTokenId = 1;
1104   bool public paused = false;
1105   
1106   address owner1; 
1107   address owner2;
1108   address owner3;
1109   address owner4;
1110 
1111   constructor(
1112     string memory _name,
1113     string memory _symbol,
1114     string memory _initBaseURI,
1115     address _owner1,
1116     address _owner2,
1117     address _owner3,
1118     address _owner4
1119   ) ERC721(_name, _symbol) {
1120     setBaseURI(_initBaseURI);
1121     owner1 = _owner1;
1122     owner2 = _owner2;
1123     owner3 = _owner3;
1124     owner4 = _owner4;
1125     mint(20);
1126   }
1127 
1128   // internal
1129   function _baseURI() internal view virtual override returns (string memory) {
1130     return baseURI;
1131   }
1132 
1133   // public
1134   function mint(uint256 _mintAmount) public payable {
1135     require(!paused, "Minting is currently paused");
1136     require(_mintAmount > 0, "You cannot mint 0 Micro Explorers");
1137     require(_mintAmount <= maxMintAmount, "Request exceeds max mint amount of 20");
1138     require(nextTokenId-1 + _mintAmount <= maxSupply, "Request exceeds total supply");
1139 
1140     uint256 totalMintPrice = cost * _mintAmount;
1141     if (msg.sender != owner1 && msg.sender != owner2 && msg.sender != owner3 && msg.sender != owner4) {
1142       require(msg.value >= totalMintPrice, "Value provided is less than total mint price");
1143     }
1144 
1145     for (uint256 i = 0; i < _mintAmount; i++) {
1146       _safeMint(msg.sender, nextTokenId++);
1147     }
1148     
1149     if (msg.sender != owner1 && msg.sender != owner2 && msg.sender != owner3 && msg.sender != owner4) {
1150       payable(owner1).transfer(totalMintPrice * 33 / 100);
1151       payable(owner2).transfer(totalMintPrice * 33 / 100);
1152       payable(owner3).transfer(totalMintPrice * 33 / 100);
1153       payable(owner4).transfer(totalMintPrice/ 100);
1154     }
1155   }
1156 
1157   function tokenURI(uint256 tokenId)
1158     public
1159     view
1160     virtual
1161     override
1162     returns (string memory)
1163   {
1164     require(
1165       _exists(tokenId),
1166       "ERC721Metadata: URI query for nonexistent token"
1167     );
1168 
1169     string memory currentBaseURI = _baseURI();
1170     return bytes(currentBaseURI).length > 0
1171         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1172         : "";
1173   }
1174   
1175   //only owner
1176   function setCost(uint256 _newCost) public onlyOwner {
1177     cost = _newCost;
1178   }
1179 
1180   function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1181     maxMintAmount = _newmaxMintAmount;
1182   }
1183 
1184   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1185     baseURI = _newBaseURI;
1186   }
1187 
1188   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1189     baseExtension = _newBaseExtension;
1190   }
1191 
1192   function pause(bool _state) public onlyOwner {
1193     paused = _state;
1194   }
1195 }