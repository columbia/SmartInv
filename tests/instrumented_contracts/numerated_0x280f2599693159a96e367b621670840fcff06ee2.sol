1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-18
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
80 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
107 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
185 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
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
405 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
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
435 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
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
463 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
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
494 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
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
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
646  * @dev See https://eips.ethereum.org/EIPS/eip-721
647  */
648 interface IERC721Enumerable is IERC721 {
649     /**
650      * @dev Returns the total amount of tokens stored by the contract.
651      */
652     function totalSupply() external view returns (uint256);
653 
654     /**
655      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
656      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
657      */
658     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
659 
660     /**
661      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
662      * Use along with {totalSupply} to enumerate all tokens.
663      */
664     function tokenByIndex(uint256 index) external view returns (uint256);
665 }
666 
667 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 /**
676  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
677  * @dev See https://eips.ethereum.org/EIPS/eip-721
678  */
679 interface IERC721Metadata is IERC721 {
680     /**
681      * @dev Returns the token collection name.
682      */
683     function name() external view returns (string memory);
684 
685     /**
686      * @dev Returns the token collection symbol.
687      */
688     function symbol() external view returns (string memory);
689 
690     /**
691      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
692      */
693     function tokenURI(uint256 tokenId) external view returns (string memory);
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 
705 
706 
707 
708 
709 
710 /**
711  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
712  * the Metadata extension, but not including the Enumerable extension, which is available separately as
713  * {ERC721Enumerable}.
714  */
715 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
716     using Address for address;
717     using Strings for uint256;
718 
719     // Token name
720     string private _name;
721 
722     // Token symbol
723     string private _symbol;
724 
725     // Mapping from token ID to owner address
726     mapping(uint256 => address) private _owners;
727 
728     // Mapping owner address to token count
729     mapping(address => uint256) private _balances;
730 
731     // Mapping from token ID to approved address
732     mapping(uint256 => address) private _tokenApprovals;
733 
734     // Mapping from owner to operator approvals
735     mapping(address => mapping(address => bool)) private _operatorApprovals;
736 
737     /**
738      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
739      */
740     constructor(string memory name_, string memory symbol_) {
741         _name = name_;
742         _symbol = symbol_;
743     }
744 
745     /**
746      * @dev See {IERC165-supportsInterface}.
747      */
748     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
749         return
750             interfaceId == type(IERC721).interfaceId ||
751             interfaceId == type(IERC721Metadata).interfaceId ||
752             super.supportsInterface(interfaceId);
753     }
754 
755     /**
756      * @dev See {IERC721-balanceOf}.
757      */
758     function balanceOf(address owner) public view virtual override returns (uint256) {
759         require(owner != address(0), "ERC721: balance query for the zero address");
760         return _balances[owner];
761     }
762 
763     /**
764      * @dev See {IERC721-ownerOf}.
765      */
766     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
767         address owner = _owners[tokenId];
768         require(owner != address(0), "ERC721: owner query for nonexistent token");
769         return owner;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-name}.
774      */
775     function name() public view virtual override returns (string memory) {
776         return _name;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-symbol}.
781      */
782     function symbol() public view virtual override returns (string memory) {
783         return _symbol;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-tokenURI}.
788      */
789     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
790         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
791 
792         string memory baseURI = _baseURI();
793         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
794     }
795 
796     /**
797      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
798      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
799      * by default, can be overriden in child contracts.
800      */
801     function _baseURI() internal view virtual returns (string memory) {
802         return "";
803     }
804 
805     /**
806      * @dev See {IERC721-approve}.
807      */
808     function approve(address to, uint256 tokenId) public virtual override {
809         address owner = ERC721.ownerOf(tokenId);
810         require(to != owner, "ERC721: approval to current owner");
811 
812         require(
813             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
814             "ERC721: approve caller is not owner nor approved for all"
815         );
816 
817         _approve(to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-getApproved}.
822      */
823     function getApproved(uint256 tokenId) public view virtual override returns (address) {
824         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
825 
826         return _tokenApprovals[tokenId];
827     }
828 
829     /**
830      * @dev See {IERC721-setApprovalForAll}.
831      */
832     function setApprovalForAll(address operator, bool approved) public virtual override {
833         _setApprovalForAll(_msgSender(), operator, approved);
834     }
835 
836     /**
837      * @dev See {IERC721-isApprovedForAll}.
838      */
839     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
840         return _operatorApprovals[owner][operator];
841     }
842 
843     /**
844      * @dev See {IERC721-transferFrom}.
845      */
846     function transferFrom(
847         address from,
848         address to,
849         uint256 tokenId
850     ) public virtual override {
851         //solhint-disable-next-line max-line-length
852         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
853 
854         _transfer(from, to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         safeTransferFrom(from, to, tokenId, "");
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) public virtual override {
877         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
878         _safeTransfer(from, to, tokenId, _data);
879     }
880 
881     /**
882      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
883      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
884      *
885      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
886      *
887      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
888      * implement alternative mechanisms to perform token transfer, such as signature-based.
889      *
890      * Requirements:
891      *
892      * - `from` cannot be the zero address.
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must exist and be owned by `from`.
895      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _safeTransfer(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) internal virtual {
905         _transfer(from, to, tokenId);
906         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
907     }
908 
909     /**
910      * @dev Returns whether `tokenId` exists.
911      *
912      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
913      *
914      * Tokens start existing when they are minted (`_mint`),
915      * and stop existing when they are burned (`_burn`).
916      */
917     function _exists(uint256 tokenId) internal view virtual returns (bool) {
918         return _owners[tokenId] != address(0);
919     }
920 
921     /**
922      * @dev Returns whether `spender` is allowed to manage `tokenId`.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      */
928     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
929         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
930         address owner = ERC721.ownerOf(tokenId);
931         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
932     }
933 
934     /**
935      * @dev Safely mints `tokenId` and transfers it to `to`.
936      *
937      * Requirements:
938      *
939      * - `tokenId` must not exist.
940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _safeMint(address to, uint256 tokenId) internal virtual {
945         _safeMint(to, tokenId, "");
946     }
947 
948     /**
949      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
950      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
951      */
952     function _safeMint(
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) internal virtual {
957         _mint(to, tokenId);
958         require(
959             _checkOnERC721Received(address(0), to, tokenId, _data),
960             "ERC721: transfer to non ERC721Receiver implementer"
961         );
962     }
963 
964     /**
965      * @dev Mints `tokenId` and transfers it to `to`.
966      *
967      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
968      *
969      * Requirements:
970      *
971      * - `tokenId` must not exist.
972      * - `to` cannot be the zero address.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _mint(address to, uint256 tokenId) internal virtual {
977         require(to != address(0), "ERC721: mint to the zero address");
978         require(!_exists(tokenId), "ERC721: token already minted");
979 
980         _beforeTokenTransfer(address(0), to, tokenId);
981 
982         _balances[to] += 1;
983         _owners[tokenId] = to;
984 
985         emit Transfer(address(0), to, tokenId);
986     }
987 
988     /**
989      * @dev Destroys `tokenId`.
990      * The approval is cleared when the token is burned.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must exist.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _burn(uint256 tokenId) internal virtual {
999         address owner = ERC721.ownerOf(tokenId);
1000 
1001         _beforeTokenTransfer(owner, address(0), tokenId);
1002 
1003         // Clear approvals
1004         _approve(address(0), tokenId);
1005 
1006         _balances[owner] -= 1;
1007         delete _owners[tokenId];
1008 
1009         emit Transfer(owner, address(0), tokenId);
1010     }
1011 
1012     /**
1013      * @dev Transfers `tokenId` from `from` to `to`.
1014      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1015      *
1016      * Requirements:
1017      *
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must be owned by `from`.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _transfer(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) internal virtual {
1028         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1029         require(to != address(0), "ERC721: transfer to the zero address");
1030 
1031         _beforeTokenTransfer(from, to, tokenId);
1032 
1033         // Clear approvals from the previous owner
1034         _approve(address(0), tokenId);
1035 
1036         _balances[from] -= 1;
1037         _balances[to] += 1;
1038         _owners[tokenId] = to;
1039 
1040         emit Transfer(from, to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev Approve `to` to operate on `tokenId`
1045      *
1046      * Emits a {Approval} event.
1047      */
1048     function _approve(address to, uint256 tokenId) internal virtual {
1049         _tokenApprovals[tokenId] = to;
1050         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev Approve `operator` to operate on all of `owner` tokens
1055      *
1056      * Emits a {ApprovalForAll} event.
1057      */
1058     function _setApprovalForAll(
1059         address owner,
1060         address operator,
1061         bool approved
1062     ) internal virtual {
1063         require(owner != operator, "ERC721: approve to caller");
1064         _operatorApprovals[owner][operator] = approved;
1065         emit ApprovalForAll(owner, operator, approved);
1066     }
1067 
1068     /**
1069      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1070      * The call is not executed if the target address is not a contract.
1071      *
1072      * @param from address representing the previous owner of the given token ID
1073      * @param to target address that will receive the tokens
1074      * @param tokenId uint256 ID of the token to be transferred
1075      * @param _data bytes optional data to send along with the call
1076      * @return bool whether the call correctly returned the expected magic value
1077      */
1078     function _checkOnERC721Received(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) private returns (bool) {
1084         if (to.isContract()) {
1085             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1086                 return retval == IERC721Receiver.onERC721Received.selector;
1087             } catch (bytes memory reason) {
1088                 if (reason.length == 0) {
1089                     revert("ERC721: transfer to non ERC721Receiver implementer");
1090                 } else {
1091                     assembly {
1092                         revert(add(32, reason), mload(reason))
1093                     }
1094                 }
1095             }
1096         } else {
1097             return true;
1098         }
1099     }
1100 
1101     /**
1102      * @dev Hook that is called before any token transfer. This includes minting
1103      * and burning.
1104      *
1105      * Calling conditions:
1106      *
1107      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1108      * transferred to `to`.
1109      * - When `from` is zero, `tokenId` will be minted for `to`.
1110      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1111      * - `from` and `to` are never both zero.
1112      *
1113      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1114      */
1115     function _beforeTokenTransfer(
1116         address from,
1117         address to,
1118         uint256 tokenId
1119     ) internal virtual {}
1120 }
1121 
1122 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1123 
1124 
1125 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 
1130 
1131 /**
1132  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1133  * enumerability of all the token ids in the contract as well as all token ids owned by each
1134  * account.
1135  */
1136 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1137     // Mapping from owner to list of owned token IDs
1138     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1139 
1140     // Mapping from token ID to index of the owner tokens list
1141     mapping(uint256 => uint256) private _ownedTokensIndex;
1142 
1143     // Array with all token ids, used for enumeration
1144     uint256[] private _allTokens;
1145 
1146     // Mapping from token id to position in the allTokens array
1147     mapping(uint256 => uint256) private _allTokensIndex;
1148 
1149     /**
1150      * @dev See {IERC165-supportsInterface}.
1151      */
1152     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1153         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1154     }
1155 
1156     /**
1157      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1158      */
1159     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1160         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1161         return _ownedTokens[owner][index];
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Enumerable-totalSupply}.
1166      */
1167     function totalSupply() public view virtual override returns (uint256) {
1168         return _allTokens.length;
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Enumerable-tokenByIndex}.
1173      */
1174     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1175         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1176         return _allTokens[index];
1177     }
1178 
1179     /**
1180      * @dev Hook that is called before any token transfer. This includes minting
1181      * and burning.
1182      *
1183      * Calling conditions:
1184      *
1185      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1186      * transferred to `to`.
1187      * - When `from` is zero, `tokenId` will be minted for `to`.
1188      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1189      * - `from` cannot be the zero address.
1190      * - `to` cannot be the zero address.
1191      *
1192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1193      */
1194     function _beforeTokenTransfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) internal virtual override {
1199         super._beforeTokenTransfer(from, to, tokenId);
1200 
1201         if (from == address(0)) {
1202             _addTokenToAllTokensEnumeration(tokenId);
1203         } else if (from != to) {
1204             _removeTokenFromOwnerEnumeration(from, tokenId);
1205         }
1206         if (to == address(0)) {
1207             _removeTokenFromAllTokensEnumeration(tokenId);
1208         } else if (to != from) {
1209             _addTokenToOwnerEnumeration(to, tokenId);
1210         }
1211     }
1212 
1213     /**
1214      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1215      * @param to address representing the new owner of the given token ID
1216      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1217      */
1218     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1219         uint256 length = ERC721.balanceOf(to);
1220         _ownedTokens[to][length] = tokenId;
1221         _ownedTokensIndex[tokenId] = length;
1222     }
1223 
1224     /**
1225      * @dev Private function to add a token to this extension's token tracking data structures.
1226      * @param tokenId uint256 ID of the token to be added to the tokens list
1227      */
1228     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1229         _allTokensIndex[tokenId] = _allTokens.length;
1230         _allTokens.push(tokenId);
1231     }
1232 
1233     /**
1234      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1235      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1236      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1237      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1238      * @param from address representing the previous owner of the given token ID
1239      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1240      */
1241     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1242         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1243         // then delete the last slot (swap and pop).
1244 
1245         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1246         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1247 
1248         // When the token to delete is the last token, the swap operation is unnecessary
1249         if (tokenIndex != lastTokenIndex) {
1250             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1251 
1252             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1253             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1254         }
1255 
1256         // This also deletes the contents at the last position of the array
1257         delete _ownedTokensIndex[tokenId];
1258         delete _ownedTokens[from][lastTokenIndex];
1259     }
1260 
1261     /**
1262      * @dev Private function to remove a token from this extension's token tracking data structures.
1263      * This has O(1) time complexity, but alters the order of the _allTokens array.
1264      * @param tokenId uint256 ID of the token to be removed from the tokens list
1265      */
1266     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1267         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1268         // then delete the last slot (swap and pop).
1269 
1270         uint256 lastTokenIndex = _allTokens.length - 1;
1271         uint256 tokenIndex = _allTokensIndex[tokenId];
1272 
1273         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1274         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1275         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1276         uint256 lastTokenId = _allTokens[lastTokenIndex];
1277 
1278         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1279         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1280 
1281         // This also deletes the contents at the last position of the array
1282         delete _allTokensIndex[tokenId];
1283         _allTokens.pop();
1284     }
1285 }
1286 
1287 // File: contracts/cosmicmice.sol
1288 
1289 
1290 
1291 
1292 pragma solidity >=0.7.0 <0.9.0;
1293 
1294 
1295 
1296 contract CosmicMice is ERC721Enumerable, Ownable {
1297   using Strings for uint256;
1298 
1299   string public baseURI;
1300   string public baseExtension = ".json";
1301   string public notRevealedUri;
1302   uint256 public cost = 0.035 ether;
1303   uint256 public maxSupply = 6666;
1304   uint256 public maxMintAmount = 10;
1305   uint256 public nftPerAddressLimit = 100;
1306   bool public paused = false;
1307   bool public revealed = false;
1308   mapping(address => uint256) public addressMintedBalance;
1309 
1310   constructor(
1311     string memory _name,
1312     string memory _symbol,
1313     string memory _initBaseURI,
1314     string memory _initNotRevealedUri
1315   ) ERC721(_name, _symbol) {
1316     setBaseURI(_initBaseURI);
1317     setNotRevealedURI(_initNotRevealedUri);
1318   }
1319 
1320   // internal
1321   function _baseURI() internal view virtual override returns (string memory) {
1322     return baseURI;
1323   }
1324 
1325   // public
1326   function mint(uint256 _mintAmount) public payable {
1327     uint256 supply = totalSupply();
1328     require(_mintAmount > 0, "need to mint at least 1 NFT");
1329     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1330     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1331     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1332     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1333 
1334     if (msg.sender != owner()) {
1335         require(!paused, "the contract is paused");
1336         if(supply <= 666) {
1337             require(ownerMintedCount + _mintAmount <= 5, "max NFT per address exceeded for the first 666 ");
1338         }
1339         //free first 666 mint
1340         if(supply >= 666){
1341             require(msg.value >= cost * _mintAmount, "insufficient funds");
1342         }
1343         if(supply >=6659){
1344             paused = true;
1345         }
1346         
1347     }
1348 
1349     for (uint256 i = 1; i <= _mintAmount; i++) {
1350       addressMintedBalance[msg.sender]++;
1351       _safeMint(msg.sender, supply + i);
1352     }
1353   }
1354  
1355 
1356   function walletOfOwner(address _owner)
1357     public
1358     view
1359     returns (uint256[] memory)
1360   {
1361     uint256 ownerTokenCount = balanceOf(_owner);
1362     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1363     for (uint256 i; i < ownerTokenCount; i++) {
1364       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1365     }
1366     return tokenIds;
1367   }
1368 
1369   function tokenURI(uint256 tokenId)
1370     public
1371     view
1372     virtual
1373     override
1374     returns (string memory)
1375   {
1376     require(
1377       _exists(tokenId),
1378       "ERC721Metadata: URI query for nonexistent token"
1379     );
1380     
1381     if(revealed == false) {
1382         return notRevealedUri;
1383     }
1384 
1385     string memory currentBaseURI = _baseURI();
1386     return bytes(currentBaseURI).length > 0
1387         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1388         : "";
1389   }
1390 
1391   //only owner
1392   function reveal() public onlyOwner() {
1393       revealed = true;
1394   }
1395   
1396 
1397   
1398   function setCost(uint256 _newCost) public onlyOwner() {
1399     cost = _newCost;
1400   }
1401 
1402   function setMaxMintAmount(uint256 _newAmount) public onlyOwner() {
1403     maxMintAmount = _newAmount;
1404   }
1405 
1406   function setNftPerAddressLimit(uint256 _newLimit) public onlyOwner() {
1407     nftPerAddressLimit = _newLimit;
1408   }
1409 
1410 
1411   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1412     baseURI = _newBaseURI;
1413   }
1414 
1415   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1416     baseExtension = _newBaseExtension;
1417   }
1418   
1419   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1420     notRevealedUri = _notRevealedURI;
1421   }
1422 
1423   function pause(bool _state) public onlyOwner {
1424     paused = _state;
1425   }
1426   
1427  
1428   function withdraw() public payable onlyOwner {
1429     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1430     require(success);
1431   }
1432 }