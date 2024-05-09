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
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
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
658     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
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
670 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
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
699 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
986 
987         _afterTokenTransfer(address(0), to, tokenId);
988     }
989 
990     /**
991      * @dev Destroys `tokenId`.
992      * The approval is cleared when the token is burned.
993      *
994      * Requirements:
995      *
996      * - `tokenId` must exist.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _burn(uint256 tokenId) internal virtual {
1001         address owner = ERC721.ownerOf(tokenId);
1002 
1003         _beforeTokenTransfer(owner, address(0), tokenId);
1004 
1005         // Clear approvals
1006         _approve(address(0), tokenId);
1007 
1008         _balances[owner] -= 1;
1009         delete _owners[tokenId];
1010 
1011         emit Transfer(owner, address(0), tokenId);
1012 
1013         _afterTokenTransfer(owner, address(0), tokenId);
1014     }
1015 
1016     /**
1017      * @dev Transfers `tokenId` from `from` to `to`.
1018      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must be owned by `from`.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _transfer(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) internal virtual {
1032         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1033         require(to != address(0), "ERC721: transfer to the zero address");
1034 
1035         _beforeTokenTransfer(from, to, tokenId);
1036 
1037         // Clear approvals from the previous owner
1038         _approve(address(0), tokenId);
1039 
1040         _balances[from] -= 1;
1041         _balances[to] += 1;
1042         _owners[tokenId] = to;
1043 
1044         emit Transfer(from, to, tokenId);
1045 
1046         _afterTokenTransfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Approve `to` to operate on `tokenId`
1051      *
1052      * Emits a {Approval} event.
1053      */
1054     function _approve(address to, uint256 tokenId) internal virtual {
1055         _tokenApprovals[tokenId] = to;
1056         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev Approve `operator` to operate on all of `owner` tokens
1061      *
1062      * Emits a {ApprovalForAll} event.
1063      */
1064     function _setApprovalForAll(
1065         address owner,
1066         address operator,
1067         bool approved
1068     ) internal virtual {
1069         require(owner != operator, "ERC721: approve to caller");
1070         _operatorApprovals[owner][operator] = approved;
1071         emit ApprovalForAll(owner, operator, approved);
1072     }
1073 
1074     /**
1075      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1076      * The call is not executed if the target address is not a contract.
1077      *
1078      * @param from address representing the previous owner of the given token ID
1079      * @param to target address that will receive the tokens
1080      * @param tokenId uint256 ID of the token to be transferred
1081      * @param _data bytes optional data to send along with the call
1082      * @return bool whether the call correctly returned the expected magic value
1083      */
1084     function _checkOnERC721Received(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) private returns (bool) {
1090         if (to.isContract()) {
1091             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1092                 return retval == IERC721Receiver.onERC721Received.selector;
1093             } catch (bytes memory reason) {
1094                 if (reason.length == 0) {
1095                     revert("ERC721: transfer to non ERC721Receiver implementer");
1096                 } else {
1097                     assembly {
1098                         revert(add(32, reason), mload(reason))
1099                     }
1100                 }
1101             }
1102         } else {
1103             return true;
1104         }
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before any token transfer. This includes minting
1109      * and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1117      * - `from` and `to` are never both zero.
1118      *
1119      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1120      */
1121     function _beforeTokenTransfer(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) internal virtual {}
1126 
1127     /**
1128      * @dev Hook that is called after any transfer of tokens. This includes
1129      * minting and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - when `from` and `to` are both non-zero.
1134      * - `from` and `to` are never both zero.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _afterTokenTransfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) internal virtual {}
1143 }
1144 
1145 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1146 
1147 
1148 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1149 
1150 pragma solidity ^0.8.0;
1151 
1152 
1153 
1154 /**
1155  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1156  * enumerability of all the token ids in the contract as well as all token ids owned by each
1157  * account.
1158  */
1159 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1160     // Mapping from owner to list of owned token IDs
1161     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1162 
1163     // Mapping from token ID to index of the owner tokens list
1164     mapping(uint256 => uint256) private _ownedTokensIndex;
1165 
1166     // Array with all token ids, used for enumeration
1167     uint256[] private _allTokens;
1168 
1169     // Mapping from token id to position in the allTokens array
1170     mapping(uint256 => uint256) private _allTokensIndex;
1171 
1172     /**
1173      * @dev See {IERC165-supportsInterface}.
1174      */
1175     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1176         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1177     }
1178 
1179     /**
1180      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1181      */
1182     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1183         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1184         return _ownedTokens[owner][index];
1185     }
1186 
1187     /**
1188      * @dev See {IERC721Enumerable-totalSupply}.
1189      */
1190     function totalSupply() public view virtual override returns (uint256) {
1191         return _allTokens.length;
1192     }
1193 
1194     /**
1195      * @dev See {IERC721Enumerable-tokenByIndex}.
1196      */
1197     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1198         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1199         return _allTokens[index];
1200     }
1201 
1202     /**
1203      * @dev Hook that is called before any token transfer. This includes minting
1204      * and burning.
1205      *
1206      * Calling conditions:
1207      *
1208      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1209      * transferred to `to`.
1210      * - When `from` is zero, `tokenId` will be minted for `to`.
1211      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1212      * - `from` cannot be the zero address.
1213      * - `to` cannot be the zero address.
1214      *
1215      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1216      */
1217     function _beforeTokenTransfer(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) internal virtual override {
1222         super._beforeTokenTransfer(from, to, tokenId);
1223 
1224         if (from == address(0)) {
1225             _addTokenToAllTokensEnumeration(tokenId);
1226         } else if (from != to) {
1227             _removeTokenFromOwnerEnumeration(from, tokenId);
1228         }
1229         if (to == address(0)) {
1230             _removeTokenFromAllTokensEnumeration(tokenId);
1231         } else if (to != from) {
1232             _addTokenToOwnerEnumeration(to, tokenId);
1233         }
1234     }
1235 
1236     /**
1237      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1238      * @param to address representing the new owner of the given token ID
1239      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1240      */
1241     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1242         uint256 length = ERC721.balanceOf(to);
1243         _ownedTokens[to][length] = tokenId;
1244         _ownedTokensIndex[tokenId] = length;
1245     }
1246 
1247     /**
1248      * @dev Private function to add a token to this extension's token tracking data structures.
1249      * @param tokenId uint256 ID of the token to be added to the tokens list
1250      */
1251     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1252         _allTokensIndex[tokenId] = _allTokens.length;
1253         _allTokens.push(tokenId);
1254     }
1255 
1256     /**
1257      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1258      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1259      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1260      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1261      * @param from address representing the previous owner of the given token ID
1262      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1263      */
1264     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1265         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1266         // then delete the last slot (swap and pop).
1267 
1268         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1269         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1270 
1271         // When the token to delete is the last token, the swap operation is unnecessary
1272         if (tokenIndex != lastTokenIndex) {
1273             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1274 
1275             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1276             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1277         }
1278 
1279         // This also deletes the contents at the last position of the array
1280         delete _ownedTokensIndex[tokenId];
1281         delete _ownedTokens[from][lastTokenIndex];
1282     }
1283 
1284     /**
1285      * @dev Private function to remove a token from this extension's token tracking data structures.
1286      * This has O(1) time complexity, but alters the order of the _allTokens array.
1287      * @param tokenId uint256 ID of the token to be removed from the tokens list
1288      */
1289     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1290         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1291         // then delete the last slot (swap and pop).
1292 
1293         uint256 lastTokenIndex = _allTokens.length - 1;
1294         uint256 tokenIndex = _allTokensIndex[tokenId];
1295 
1296         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1297         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1298         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1299         uint256 lastTokenId = _allTokens[lastTokenIndex];
1300 
1301         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1302         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1303 
1304         // This also deletes the contents at the last position of the array
1305         delete _allTokensIndex[tokenId];
1306         _allTokens.pop();
1307     }
1308 }
1309 
1310 // File: coolghouls.sol
1311 
1312 
1313 
1314 pragma solidity >=0.7.0 <0.9.0;
1315 
1316 
1317 
1318 contract COOLGHOULS is ERC721Enumerable, Ownable {
1319     using Strings for uint256;
1320 
1321     string public baseURI = "ipfs://QmSbchkJWTzzhFAnX1AdqKoiXPcoJLBPFJHUvaW7Hyq6nn";
1322     uint256 public maxSupply = 5555;
1323     uint256 public maxMintPresale = 4;
1324     uint256 public maxMint = 10;
1325     uint256 public price = 0.05 ether;
1326     bool public active = true;
1327     bool public presale = true;
1328     address[] public whitelist;
1329 
1330     constructor() ERC721("Cool Ghouls", "CG") {
1331         mint(5);
1332     }
1333 
1334     // Internal Methods
1335     // Override
1336     function _baseURI() internal view virtual override returns (string memory) {
1337         return baseURI;
1338     }
1339 
1340     // Public Methods
1341     function mint(uint256 _mintAmount) public payable {
1342         require(active, "The contract is not active");
1343         uint256 supply = totalSupply();
1344         require(_mintAmount > 0, "Mint amount must be at least 1 NFT");
1345         require(supply + _mintAmount <= maxSupply, "Exceeded NFT supply");
1346 
1347         if (msg.sender != owner()) {
1348             if (presale == true) {
1349                 require(isWhitelisted(msg.sender), "User is not whitelisted");
1350                 require(_mintAmount <= maxMintPresale, "Exceeded max mint amount");
1351             } else {
1352                 require(_mintAmount <= maxMint, "Exceeded max mint amount");
1353             }
1354             require(msg.value >= price * _mintAmount, "Insufficient funds");
1355         }
1356 
1357         for (uint256 i = 1; i <= _mintAmount; i++) {
1358             _safeMint(msg.sender, supply + i);
1359         }
1360     }
1361 
1362     // Override
1363     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1364         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1365         string memory newBaseURI = _baseURI();
1366         return bytes(newBaseURI).length > 0 ? string(abi.encodePacked(newBaseURI, "/", tokenId.toString(), ".json")) : "";
1367     }
1368 
1369     function isWhitelisted(address _user) public view returns (bool) {
1370         for (uint i = 0; i < whitelist.length; i++) {
1371             if (whitelist[i] == _user) {
1372                 return true;
1373             }
1374         }
1375         return false;
1376     }
1377 
1378     function getTokenIds(address _address) public view returns (uint256[] memory) {
1379         uint256 tokenCount = balanceOf(_address);
1380         uint256[] memory tokenIds = new uint256[](tokenCount);
1381         for (uint256 i; i < tokenCount; i++) {
1382             tokenIds[i] = tokenOfOwnerByIndex(_address, i);
1383         }
1384         return tokenIds;
1385     }
1386 
1387     // Owner methods
1388     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1389         baseURI = _newBaseURI;
1390     }
1391 
1392     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1393         maxSupply = _newMaxSupply;
1394     }
1395 
1396     function setMaxMintPresale(uint256 _newMaxMintPresale) public onlyOwner {
1397         maxMintPresale = _newMaxMintPresale;
1398     }
1399 
1400     function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1401         maxMint = _newMaxMint;
1402     }
1403 
1404     function setPrice(uint256 _newPrice) public onlyOwner {
1405         price = _newPrice;
1406     }
1407 
1408     function startMinting() public onlyOwner {
1409         active = true;
1410     }
1411 
1412     function stopMinting() public onlyOwner {
1413         active = false;
1414     }
1415 
1416     function startPresale() public onlyOwner {
1417         presale = true;
1418     }
1419 
1420     function stopPresale() public onlyOwner {
1421         presale = false;
1422     }
1423 
1424     function setWhitelist(address[] calldata _whitelist) public onlyOwner {
1425         delete whitelist;
1426         whitelist = _whitelist;
1427     }
1428 
1429     function withdraw() public payable onlyOwner {
1430         (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1431         require(success);
1432     }
1433 }