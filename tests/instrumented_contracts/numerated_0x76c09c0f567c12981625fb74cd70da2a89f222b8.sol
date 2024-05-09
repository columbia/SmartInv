1 // SPDX-License-Identifier: MIT
2 /* Squirt Game
3  Rulez: 1. to be possessor 2. start game (reveal) on the sixth day 3. just a winner. 
4  456 Nfts
5  Free mint
6  Max 1 x Transaction
7 */
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 
15 
16 // File: @openzeppelin/contracts/utils/Context.sol
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 // File: @openzeppelin/contracts/access/Ownable.sol
44 
45 
46 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
128      */
129     function toString(uint256 value) internal pure returns (string memory) {
130         // Inspired by OraclizeAPI's implementation - MIT licence
131         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
132 
133         if (value == 0) {
134             return "0";
135         }
136         uint256 temp = value;
137         uint256 digits;
138         while (temp != 0) {
139             digits++;
140             temp /= 10;
141         }
142         bytes memory buffer = new bytes(digits);
143         while (value != 0) {
144             digits -= 1;
145             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
146             value /= 10;
147         }
148         return string(buffer);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
153      */
154     function toHexString(uint256 value) internal pure returns (string memory) {
155         if (value == 0) {
156             return "0x00";
157         }
158         uint256 temp = value;
159         uint256 length = 0;
160         while (temp != 0) {
161             length++;
162             temp >>= 8;
163         }
164         return toHexString(value, length);
165     }
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
169      */
170     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
171         bytes memory buffer = new bytes(2 * length + 2);
172         buffer[0] = "0";
173         buffer[1] = "x";
174         for (uint256 i = 2 * length + 1; i > 1; --i) {
175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
176             value >>= 4;
177         }
178         require(value == 0, "Strings: hex length insufficient");
179         return string(buffer);
180     }
181 }
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
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
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
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
702  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
703  *
704  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
705  *
706  * Does not support burning tokens to address(0).
707  *
708  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
709  */
710 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
711     using Address for address;
712     using Strings for uint256;
713 
714     struct TokenOwnership {
715         address addr;
716         uint64 startTimestamp;
717     }
718 
719     struct AddressData {
720         uint128 balance;
721         uint128 numberMinted;
722     }
723 
724     uint256 internal currentIndex = 0;
725 
726     uint256 internal immutable maxBatchSize;
727 
728     // Token name
729     string private _name;
730 
731     // Token symbol
732     string private _symbol;
733 
734     // Mapping from token ID to ownership details
735     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
736     mapping(uint256 => TokenOwnership) internal _ownerships;
737 
738     // Mapping owner address to address data
739     mapping(address => AddressData) private _addressData;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     /**
748      * @dev
749      * `maxBatchSize` refers to how much a minter can mint at a time.
750      */
751     constructor(
752         string memory name_,
753         string memory symbol_,
754         uint256 maxBatchSize_
755     ) {
756         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
757         _name = name_;
758         _symbol = symbol_;
759         maxBatchSize = maxBatchSize_;
760     }
761 
762     /**
763      * @dev See {IERC721Enumerable-totalSupply}.
764      */
765     function totalSupply() public view override returns (uint256) {
766         return currentIndex;
767     }
768 
769     /**
770      * @dev See {IERC721Enumerable-tokenByIndex}.
771      */
772     function tokenByIndex(uint256 index) public view override returns (uint256) {
773         require(index < totalSupply(), 'ERC721A: global index out of bounds');
774         return index;
775     }
776 
777     /**
778      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
779      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
780      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
781      */
782     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
783         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
784         uint256 numMintedSoFar = totalSupply();
785         uint256 tokenIdsIdx = 0;
786         address currOwnershipAddr = address(0);
787         for (uint256 i = 0; i < numMintedSoFar; i++) {
788             TokenOwnership memory ownership = _ownerships[i];
789             if (ownership.addr != address(0)) {
790                 currOwnershipAddr = ownership.addr;
791             }
792             if (currOwnershipAddr == owner) {
793                 if (tokenIdsIdx == index) {
794                     return i;
795                 }
796                 tokenIdsIdx++;
797             }
798         }
799         revert('ERC721A: unable to get token of owner by index');
800     }
801 
802     /**
803      * @dev See {IERC165-supportsInterface}.
804      */
805     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
806         return
807             interfaceId == type(IERC721).interfaceId ||
808             interfaceId == type(IERC721Metadata).interfaceId ||
809             interfaceId == type(IERC721Enumerable).interfaceId ||
810             super.supportsInterface(interfaceId);
811     }
812 
813     /**
814      * @dev See {IERC721-balanceOf}.
815      */
816     function balanceOf(address owner) public view override returns (uint256) {
817         require(owner != address(0), 'ERC721A: balance query for the zero address');
818         return uint256(_addressData[owner].balance);
819     }
820 
821     function _numberMinted(address owner) internal view returns (uint256) {
822         require(owner != address(0), 'ERC721A: number minted query for the zero address');
823         return uint256(_addressData[owner].numberMinted);
824     }
825 
826     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
827         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
828 
829         uint256 lowestTokenToCheck;
830         if (tokenId >= maxBatchSize) {
831             lowestTokenToCheck = tokenId - maxBatchSize + 1;
832         }
833 
834         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
835             TokenOwnership memory ownership = _ownerships[curr];
836             if (ownership.addr != address(0)) {
837                 return ownership;
838             }
839         }
840 
841         revert('ERC721A: unable to determine the owner of token');
842     }
843 
844     /**
845      * @dev See {IERC721-ownerOf}.
846      */
847     function ownerOf(uint256 tokenId) public view override returns (address) {
848         return ownershipOf(tokenId).addr;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-name}.
853      */
854     function name() public view virtual override returns (string memory) {
855         return _name;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-symbol}.
860      */
861     function symbol() public view virtual override returns (string memory) {
862         return _symbol;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-tokenURI}.
867      */
868     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
869         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
870 
871         string memory baseURI = _baseURI();
872         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
873     }
874 
875     /**
876      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
877      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
878      * by default, can be overriden in child contracts.
879      */
880     function _baseURI() internal view virtual returns (string memory) {
881         return '';
882     }
883 
884     /**
885      * @dev See {IERC721-approve}.
886      */
887     function approve(address to, uint256 tokenId) public override {
888         address owner = ERC721A.ownerOf(tokenId);
889         require(to != owner, 'ERC721A: approval to current owner');
890 
891         require(
892             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
893             'ERC721A: approve caller is not owner nor approved for all'
894         );
895 
896         _approve(to, tokenId, owner);
897     }
898 
899     /**
900      * @dev See {IERC721-getApproved}.
901      */
902     function getApproved(uint256 tokenId) public view override returns (address) {
903         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
904 
905         return _tokenApprovals[tokenId];
906     }
907 
908     /**
909      * @dev See {IERC721-setApprovalForAll}.
910      */
911     function setApprovalForAll(address operator, bool approved) public override {
912         require(operator != _msgSender(), 'ERC721A: approve to caller');
913 
914         _operatorApprovals[_msgSender()][operator] = approved;
915         emit ApprovalForAll(_msgSender(), operator, approved);
916     }
917 
918     /**
919      * @dev See {IERC721-isApprovedForAll}.
920      */
921     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
922         return _operatorApprovals[owner][operator];
923     }
924 
925     /**
926      * @dev See {IERC721-transferFrom}.
927      */
928     function transferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public override {
933         _transfer(from, to, tokenId);
934     }
935 
936     /**
937      * @dev See {IERC721-safeTransferFrom}.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public override {
944         safeTransferFrom(from, to, tokenId, '');
945     }
946 
947     /**
948      * @dev See {IERC721-safeTransferFrom}.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) public override {
956         _transfer(from, to, tokenId);
957         require(
958             _checkOnERC721Received(from, to, tokenId, _data),
959             'ERC721A: transfer to non ERC721Receiver implementer'
960         );
961     }
962 
963     /**
964      * @dev Returns whether `tokenId` exists.
965      *
966      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
967      *
968      * Tokens start existing when they are minted (`_mint`),
969      */
970     function _exists(uint256 tokenId) internal view returns (bool) {
971         return tokenId < currentIndex;
972     }
973 
974     function _safeMint(address to, uint256 quantity) internal {
975         _safeMint(to, quantity, '');
976     }
977 
978     /**
979      * @dev Mints `quantity` tokens and transfers them to `to`.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `quantity` cannot be larger than the max batch size.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeMint(
989         address to,
990         uint256 quantity,
991         bytes memory _data
992     ) internal {
993         uint256 startTokenId = currentIndex;
994         require(to != address(0), 'ERC721A: mint to the zero address');
995         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
996         require(!_exists(startTokenId), 'ERC721A: token already minted');
997         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
998         require(quantity > 0, 'ERC721A: quantity must be greater 0');
999 
1000         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1001 
1002         AddressData memory addressData = _addressData[to];
1003         _addressData[to] = AddressData(
1004             addressData.balance + uint128(quantity),
1005             addressData.numberMinted + uint128(quantity)
1006         );
1007         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1008 
1009         uint256 updatedIndex = startTokenId;
1010 
1011         for (uint256 i = 0; i < quantity; i++) {
1012             emit Transfer(address(0), to, updatedIndex);
1013             require(
1014                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1015                 'ERC721A: transfer to non ERC721Receiver implementer'
1016             );
1017             updatedIndex++;
1018         }
1019 
1020         currentIndex = updatedIndex;
1021         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1022     }
1023 /**
1024      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1025      * The call is not executed if the target address is not a contract.
1026      *
1027      * @param from address representing the previous owner of the given token ID
1028      * @param to target address that will receive the tokens
1029      * @param tokenId uint256 ID of the token to be transferred
1030      * @param _data bytes optional data to send along with the call
1031      * @return bool whether the call correctly returned the expected magic value
1032      */
1033     function _checkOnERC721Received(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) private returns (bool) {
1039         if (to.isContract()) {
1040             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1041                 return retval == IERC721Receiver(to).onERC721Received.selector;
1042             } catch (bytes memory reason) {
1043                 if (reason.length == 0) {
1044                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1045                 } else {
1046                     assembly {
1047                         revert(add(32, reason), mload(reason))
1048                     }
1049                 }
1050             }
1051         } else {
1052             return true;
1053         }
1054     }
1055     /**
1056      * @dev Transfers `tokenId` from `from` to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must be owned by `from`.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _transfer(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) private {
1070         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1071 
1072         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1073             getApproved(tokenId) == _msgSender() ||
1074             isApprovedForAll(prevOwnership.addr, _msgSender()));
1075 
1076         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1077 
1078         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1079         require(to != address(0), 'ERC721A: transfer to the zero address');
1080 
1081         _beforeTokenTransfers(from, to, tokenId, 1);
1082 
1083         // Clear approvals from the previous owner
1084         _approve(address(0), tokenId, prevOwnership.addr);
1085 
1086         // Underflow of the sender's balance is impossible because we check for
1087         // ownership above and the recipient's balance can't realistically overflow.
1088         unchecked {
1089             _addressData[from].balance -= 1;
1090             _addressData[to].balance += 1;
1091         }
1092 
1093         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1094 
1095         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1096         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1097         uint256 nextTokenId = tokenId + 1;
1098         if (_ownerships[nextTokenId].addr == address(0)) {
1099             if (_exists(nextTokenId)) {
1100                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1101             }
1102         }
1103 
1104         emit Transfer(from, to, tokenId);
1105         _afterTokenTransfers(from, to, tokenId, 1);
1106     }
1107 
1108     /**
1109      * @dev Approve `to` to operate on `tokenId`
1110      *
1111      * Emits a {Approval} event.
1112      */
1113     function _approve(
1114         address to,
1115         uint256 tokenId,
1116         address owner
1117     ) private {
1118         _tokenApprovals[tokenId] = to;
1119         emit Approval(owner, to, tokenId);
1120     }
1121 
1122     
1123 
1124     /**
1125      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1126      *
1127      * startTokenId - the first token id to be transferred
1128      * quantity - the amount to be transferred
1129      *
1130      * Calling conditions:
1131      *
1132      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1133      * transferred to `to`.
1134      * - When `from` is zero, `tokenId` will be minted for `to`.
1135      */
1136     function _beforeTokenTransfers(
1137         address from,
1138         address to,
1139         uint256 startTokenId,
1140         uint256 quantity
1141     ) internal virtual {}
1142 
1143     /**
1144      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1145      * minting.
1146      *
1147      * startTokenId - the first token id to be transferred
1148      * quantity - the amount to be transferred
1149      *
1150      * Calling conditions:
1151      *
1152      * - when `from` and `to` are both non-zero.
1153      * - `from` and `to` are never both zero.
1154      */
1155     function _afterTokenTransfers(
1156         address from,
1157         address to,
1158         uint256 startTokenId,
1159         uint256 quantity
1160     ) internal virtual {}
1161 }
1162 
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 contract squirtGame is ERC721A, Ownable {
1167   using Strings for uint256;
1168 
1169   string private uriPrefix = "";
1170   string private uriSuffix = ".json";
1171   string public hiddenMetadataUri;
1172   
1173   uint256 public price = 0 ether; 
1174   uint256 public maxSupply = 456; 
1175   uint256 public maxMintAmountPerTx = 1; 
1176   
1177   bool public paused = true;
1178   bool public revealed = false;
1179   mapping(address => uint256) public addressMintedBalance;
1180 
1181 
1182   constructor() ERC721A("squirtGame", "$QUIRT", maxMintAmountPerTx) {
1183     setHiddenMetadataUri("ipfs://QmNr6sitWcWSfhKmqWCmsszJpqQGaGG4QDNRYF2i1mMsb8");
1184   }
1185 
1186   modifier mintCompliance(uint256 _mintAmount) {
1187     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1188     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1189     _;
1190   }
1191 
1192   function squirt(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1193    {
1194     require(!paused, "The contract is paused!");
1195     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1196     
1197     
1198     _safeMint(msg.sender, _mintAmount);
1199   }
1200 
1201    
1202   function dropToAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1203     _safeMint(_to, _mintAmount);
1204   }
1205 
1206  
1207   function walletOfOwner(address _owner)
1208     public
1209     view
1210     returns (uint256[] memory)
1211   {
1212     uint256 ownerTokenCount = balanceOf(_owner);
1213     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1214     uint256 currentTokenId = 0;
1215     uint256 ownedTokenIndex = 0;
1216 
1217     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1218       address currentTokenOwner = ownerOf(currentTokenId);
1219 
1220       if (currentTokenOwner == _owner) {
1221         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1222 
1223         ownedTokenIndex++;
1224       }
1225 
1226       currentTokenId++;
1227     }
1228 
1229     return ownedTokenIds;
1230   }
1231 
1232   function tokenURI(uint256 _tokenId)
1233     public
1234     view
1235     virtual
1236     override
1237     returns (string memory)
1238   {
1239     require(
1240       _exists(_tokenId),
1241       "ERC721Metadata: URI query for nonexistent token"
1242     );
1243 
1244     if (revealed == false) {
1245       return hiddenMetadataUri;
1246     }
1247 
1248     string memory currentBaseURI = _baseURI();
1249     return bytes(currentBaseURI).length > 0
1250         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1251         : "";
1252   }
1253 
1254   function setRevealed(bool _state) public onlyOwner {
1255     revealed = _state;
1256   
1257   }
1258 
1259   function setPrice(uint256 _price) public onlyOwner {
1260     price = _price;
1261 
1262   }
1263  
1264   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1265     hiddenMetadataUri = _hiddenMetadataUri;
1266   }
1267 
1268 
1269 
1270   function setUriPresquirt(string memory _uriPrefix) public onlyOwner {
1271     uriPrefix = _uriPrefix;
1272   }
1273 
1274   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1275     uriSuffix = _uriSuffix;
1276   }
1277 
1278   function setPaused(bool _state) public onlyOwner {
1279     paused = _state;
1280   }
1281 
1282   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1283       _safeMint(_receiver, _mintAmount);
1284   }
1285 
1286   function _baseURI() internal view virtual override returns (string memory) {
1287     return uriPrefix;
1288     
1289   }
1290 
1291     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1292     maxMintAmountPerTx = _maxMintAmountPerTx;
1293 
1294   }
1295 
1296     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1297     maxSupply = _maxSupply;
1298 
1299   }
1300 
1301   function squirtdraw() public onlyOwner {
1302     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1303     require(os);
1304     
1305 
1306  
1307   }
1308   
1309 }