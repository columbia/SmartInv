1 //███╗░░░███╗███████╗██╗░░██╗░█████╗░███████╗██╗░░░██╗██╗░░██╗██╗
2 //████╗░████║██╔════╝██║░██╔╝██╔══██╗╚════██║██║░░░██║██║░██╔╝██║
3 //██╔████╔██║█████╗░░█████═╝░███████║░░███╔═╝██║░░░██║█████═╝░██║
4 //██║╚██╔╝██║██╔══╝░░██╔═██╗░██╔══██║██╔══╝░░██║░░░██║██╔═██╗░██║
5 //██║░╚═╝░██║███████╗██║░╚██╗██║░░██║███████╗╚██████╔╝██║░╚██╗██║
6 //╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝░╚═════╝░╚═╝░░╚═╝╚═╝
7 
8 
9 // Sources flattened with hardhat v2.8.0 https://hardhat.org
10 
11 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
12 
13 // SPDX-License-Identifier: MIT
14 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 
40 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
41 
42 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Required interface of an ERC721 compliant contract.
48  */
49 interface IERC721 is IERC165 {
50     /**
51      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
52      */
53     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
54 
55     /**
56      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
57      */
58     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
59 
60     /**
61      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
62      */
63     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
64 
65     /**
66      * @dev Returns the number of tokens in ``owner``'s account.
67      */
68     function balanceOf(address owner) external view returns (uint256 balance);
69 
70     /**
71      * @dev Returns the owner of the `tokenId` token.
72      *
73      * Requirements:
74      *
75      * - `tokenId` must exist.
76      */
77     function ownerOf(uint256 tokenId) external view returns (address owner);
78 
79     /**
80      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
81      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must exist and be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
89      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
90      *
91      * Emits a {Transfer} event.
92      */
93     function safeTransferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Transfers `tokenId` token from `from` to `to`.
101      *
102      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must be owned by `from`.
109      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Returns the account approved for `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function getApproved(uint256 tokenId) external view returns (address operator);
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
157      *
158      * See {setApprovalForAll}
159      */
160     function isApprovedForAll(address owner, address operator) external view returns (bool);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 }
182 
183 
184 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
185 
186 
187 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @title ERC721 token receiver interface
193  * @dev Interface for any contract that wants to support safeTransfers
194  * from ERC721 asset contracts.
195  */
196 interface IERC721Receiver {
197     /**
198      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
199      * by `operator` from `from`, this function is called.
200      *
201      * It must return its Solidity selector to confirm the token transfer.
202      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
203      *
204      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
205      */
206     function onERC721Received(
207         address operator,
208         address from,
209         uint256 tokenId,
210         bytes calldata data
211     ) external returns (bytes4);
212 }
213 
214 
215 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
216 
217 
218 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
224  * @dev See https://eips.ethereum.org/EIPS/eip-721
225  */
226 interface IERC721Metadata is IERC721 {
227     /**
228      * @dev Returns the token collection name.
229      */
230     function name() external view returns (string memory);
231 
232     /**
233      * @dev Returns the token collection symbol.
234      */
235     function symbol() external view returns (string memory);
236 
237     /**
238      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
239      */
240     function tokenURI(uint256 tokenId) external view returns (string memory);
241 }
242 
243 
244 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.1
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
253  * @dev See https://eips.ethereum.org/EIPS/eip-721
254  */
255 interface IERC721Enumerable is IERC721 {
256     /**
257      * @dev Returns the total amount of tokens stored by the contract.
258      */
259     function totalSupply() external view returns (uint256);
260 
261     /**
262      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
263      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
264      */
265     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
266 
267     /**
268      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
269      * Use along with {totalSupply} to enumerate all tokens.
270      */
271     function tokenByIndex(uint256 index) external view returns (uint256);
272 }
273 
274 
275 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // This method relies on extcodesize, which returns 0 for contracts in
305         // construction, since the code is only stored at the end of the
306         // constructor execution.
307 
308         uint256 size;
309         assembly {
310             size := extcodesize(account)
311         }
312         return size > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         (bool success, ) = recipient.call{value: amount}("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain `call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         require(isContract(target), "Address: call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.call{value: value}(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
419         return functionStaticCall(target, data, "Address: low-level static call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.staticcall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(isContract(target), "Address: delegate call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
468      * revert reason using the provided one.
469      *
470      * _Available since v4.3._
471      */
472     function verifyCallResult(
473         bool success,
474         bytes memory returndata,
475         string memory errorMessage
476     ) internal pure returns (bytes memory) {
477         if (success) {
478             return returndata;
479         } else {
480             // Look for revert reason and bubble it up if present
481             if (returndata.length > 0) {
482                 // The easiest way to bubble the revert reason is using memory via assembly
483 
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 
496 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
497 
498 
499 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Provides information about the current execution context, including the
505  * sender of the transaction and its data. While these are generally available
506  * via msg.sender and msg.data, they should not be accessed in such a direct
507  * manner, since when dealing with meta-transactions the account sending and
508  * paying for execution may not be the actual sender (as far as an application
509  * is concerned).
510  *
511  * This contract is only required for intermediate, library-like contracts.
512  */
513 abstract contract Context {
514     function _msgSender() internal view virtual returns (address) {
515         return msg.sender;
516     }
517 
518     function _msgData() internal view virtual returns (bytes calldata) {
519         return msg.data;
520     }
521 }
522 
523 
524 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev String operations.
533  */
534 library Strings {
535     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
536 
537     /**
538      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
539      */
540     function toString(uint256 value) internal pure returns (string memory) {
541         // Inspired by OraclizeAPI's implementation - MIT licence
542         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
543 
544         if (value == 0) {
545             return "0";
546         }
547         uint256 temp = value;
548         uint256 digits;
549         while (temp != 0) {
550             digits++;
551             temp /= 10;
552         }
553         bytes memory buffer = new bytes(digits);
554         while (value != 0) {
555             digits -= 1;
556             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
557             value /= 10;
558         }
559         return string(buffer);
560     }
561 
562     /**
563      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
564      */
565     function toHexString(uint256 value) internal pure returns (string memory) {
566         if (value == 0) {
567             return "0x00";
568         }
569         uint256 temp = value;
570         uint256 length = 0;
571         while (temp != 0) {
572             length++;
573             temp >>= 8;
574         }
575         return toHexString(value, length);
576     }
577 
578     /**
579      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
580      */
581     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
582         bytes memory buffer = new bytes(2 * length + 2);
583         buffer[0] = "0";
584         buffer[1] = "x";
585         for (uint256 i = 2 * length + 1; i > 1; --i) {
586             buffer[i] = _HEX_SYMBOLS[value & 0xf];
587             value >>= 4;
588         }
589         require(value == 0, "Strings: hex length insufficient");
590         return string(buffer);
591     }
592 }
593 
594 
595 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
596 
597 
598 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @dev Implementation of the {IERC165} interface.
604  *
605  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
606  * for the additional interface id that will be supported. For example:
607  *
608  * ```solidity
609  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
611  * }
612  * ```
613  *
614  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
615  */
616 abstract contract ERC165 is IERC165 {
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
621         return interfaceId == type(IERC165).interfaceId;
622     }
623 }
624 
625 
626 // File contracts/ERC721A.sol
627 
628 
629 // Creators: locationtba.eth, 2pmflow.eth
630 
631 pragma solidity ^0.8.0;
632 
633 
634 
635 
636 
637 
638 
639 
640 /**
641  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
642  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
643  *
644  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
645  *
646  * Does not support burning tokens to address(0).
647  */
648 contract ERC721A is
649   Context,
650   ERC165,
651   IERC721,
652   IERC721Metadata,
653   IERC721Enumerable
654 {
655   using Address for address;
656   using Strings for uint256;
657 
658   struct TokenOwnership {
659     address addr;
660     uint64 startTimestamp;
661   }
662 
663   struct AddressData {
664     uint128 balance;
665     uint128 numberMinted;
666   }
667 
668   uint256 private currentIndex = 0;
669 
670   uint256 internal immutable maxBatchSize;
671 
672   // Token name
673   string private _name;
674 
675   // Token symbol
676   string private _symbol;
677 
678   // Mapping from token ID to ownership details
679   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
680   mapping(uint256 => TokenOwnership) private _ownerships;
681 
682   // Mapping owner address to address data
683   mapping(address => AddressData) private _addressData;
684 
685   // Mapping from token ID to approved address
686   mapping(uint256 => address) private _tokenApprovals;
687 
688   // Mapping from owner to operator approvals
689   mapping(address => mapping(address => bool)) private _operatorApprovals;
690 
691   /**
692    * @dev
693    * `maxBatchSize` refers to how much a minter can mint at a time.
694    */
695   constructor(
696     string memory name_,
697     string memory symbol_,
698     uint256 maxBatchSize_
699   ) {
700     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
701     _name = name_;
702     _symbol = symbol_;
703     maxBatchSize = maxBatchSize_;
704   }
705 
706   /**
707    * @dev See {IERC721Enumerable-totalSupply}.
708    */
709   function totalSupply() public view override returns (uint256) {
710     return currentIndex;
711   }
712 
713   /**
714    * @dev See {IERC721Enumerable-tokenByIndex}.
715    */
716   function tokenByIndex(uint256 index) public view override returns (uint256) {
717     require(index < totalSupply(), "ERC721A: global index out of bounds");
718     return index;
719   }
720 
721   /**
722    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
723    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
724    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
725    */
726   function tokenOfOwnerByIndex(address owner, uint256 index)
727     public
728     view
729     override
730     returns (uint256)
731   {
732     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
733     uint256 numMintedSoFar = totalSupply();
734     uint256 tokenIdsIdx = 0;
735     address currOwnershipAddr = address(0);
736     for (uint256 i = 0; i < numMintedSoFar; i++) {
737       TokenOwnership memory ownership = _ownerships[i];
738       if (ownership.addr != address(0)) {
739         currOwnershipAddr = ownership.addr;
740       }
741       if (currOwnershipAddr == owner) {
742         if (tokenIdsIdx == index) {
743           return i;
744         }
745         tokenIdsIdx++;
746       }
747     }
748     revert("ERC721A: unable to get token of owner by index");
749   }
750 
751   /**
752    * @dev See {IERC165-supportsInterface}.
753    */
754   function supportsInterface(bytes4 interfaceId)
755     public
756     view
757     virtual
758     override(ERC165, IERC165)
759     returns (bool)
760   {
761     return
762       interfaceId == type(IERC721).interfaceId ||
763       interfaceId == type(IERC721Metadata).interfaceId ||
764       interfaceId == type(IERC721Enumerable).interfaceId ||
765       super.supportsInterface(interfaceId);
766   }
767 
768   /**
769    * @dev See {IERC721-balanceOf}.
770    */
771   function balanceOf(address owner) public view override returns (uint256) {
772     require(owner != address(0), "ERC721A: balance query for the zero address");
773     return uint256(_addressData[owner].balance);
774   }
775 
776   function _numberMinted(address owner) internal view returns (uint256) {
777     require(
778       owner != address(0),
779       "ERC721A: number minted query for the zero address"
780     );
781     return uint256(_addressData[owner].numberMinted);
782   }
783 
784   function ownershipOf(uint256 tokenId)
785     internal
786     view
787     returns (TokenOwnership memory)
788   {
789     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
790 
791     uint256 lowestTokenToCheck;
792     if (tokenId >= maxBatchSize) {
793       lowestTokenToCheck = tokenId - maxBatchSize + 1;
794     }
795 
796     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
797       TokenOwnership memory ownership = _ownerships[curr];
798       if (ownership.addr != address(0)) {
799         return ownership;
800       }
801     }
802 
803     revert("ERC721A: unable to determine the owner of token");
804   }
805 
806   /**
807    * @dev See {IERC721-ownerOf}.
808    */
809   function ownerOf(uint256 tokenId) public view override returns (address) {
810     return ownershipOf(tokenId).addr;
811   }
812 
813   /**
814    * @dev See {IERC721Metadata-name}.
815    */
816   function name() public view virtual override returns (string memory) {
817     return _name;
818   }
819 
820   /**
821    * @dev See {IERC721Metadata-symbol}.
822    */
823   function symbol() public view virtual override returns (string memory) {
824     return _symbol;
825   }
826 
827   /**
828    * @dev See {IERC721Metadata-tokenURI}.
829    */
830   function tokenURI(uint256 tokenId)
831     public
832     view
833     virtual
834     override
835     returns (string memory)
836   {
837     require(
838       _exists(tokenId),
839       "ERC721Metadata: URI query for nonexistent token"
840     );
841 
842     string memory baseURI = _baseURI();
843     return
844       bytes(baseURI).length > 0
845         ? string(abi.encodePacked(baseURI, tokenId.toString()))
846         : "";
847   }
848 
849   /**
850    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
851    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
852    * by default, can be overriden in child contracts.
853    */
854   function _baseURI() internal view virtual returns (string memory) {
855     return "";
856   }
857 
858   /**
859    * @dev See {IERC721-approve}.
860    */
861   function approve(address to, uint256 tokenId) public override {
862     address owner = ERC721A.ownerOf(tokenId);
863     require(to != owner, "ERC721A: approval to current owner");
864 
865     require(
866       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
867       "ERC721A: approve caller is not owner nor approved for all"
868     );
869 
870     _approve(to, tokenId, owner);
871   }
872 
873   /**
874    * @dev See {IERC721-getApproved}.
875    */
876   function getApproved(uint256 tokenId) public view override returns (address) {
877     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
878 
879     return _tokenApprovals[tokenId];
880   }
881 
882   /**
883    * @dev See {IERC721-setApprovalForAll}.
884    */
885   function setApprovalForAll(address operator, bool approved) public override {
886     require(operator != _msgSender(), "ERC721A: approve to caller");
887 
888     _operatorApprovals[_msgSender()][operator] = approved;
889     emit ApprovalForAll(_msgSender(), operator, approved);
890   }
891 
892   /**
893    * @dev See {IERC721-isApprovedForAll}.
894    */
895   function isApprovedForAll(address owner, address operator)
896     public
897     view
898     virtual
899     override
900     returns (bool)
901   {
902     return _operatorApprovals[owner][operator];
903   }
904 
905   /**
906    * @dev See {IERC721-transferFrom}.
907    */
908   function transferFrom(
909     address from,
910     address to,
911     uint256 tokenId
912   ) public override {
913     _transfer(from, to, tokenId);
914   }
915 
916   /**
917    * @dev See {IERC721-safeTransferFrom}.
918    */
919   function safeTransferFrom(
920     address from,
921     address to,
922     uint256 tokenId
923   ) public override {
924     safeTransferFrom(from, to, tokenId, "");
925   }
926 
927   /**
928    * @dev See {IERC721-safeTransferFrom}.
929    */
930   function safeTransferFrom(
931     address from,
932     address to,
933     uint256 tokenId,
934     bytes memory _data
935   ) public override {
936     _transfer(from, to, tokenId);
937     require(
938       _checkOnERC721Received(from, to, tokenId, _data),
939       "ERC721A: transfer to non ERC721Receiver implementer"
940     );
941   }
942 
943   /**
944    * @dev Returns whether `tokenId` exists.
945    *
946    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
947    *
948    * Tokens start existing when they are minted (`_mint`),
949    */
950   function _exists(uint256 tokenId) internal view returns (bool) {
951     return tokenId < currentIndex;
952   }
953 
954   function _safeMint(address to, uint256 quantity) internal {
955     _safeMint(to, quantity, "");
956   }
957 
958   /**
959    * @dev Mints `quantity` tokens and transfers them to `to`.
960    *
961    * Requirements:
962    *
963    * - `to` cannot be the zero address.
964    * - `quantity` cannot be larger than the max batch size.
965    *
966    * Emits a {Transfer} event.
967    */
968   function _safeMint(
969     address to,
970     uint256 quantity,
971     bytes memory _data
972   ) internal {
973     uint256 startTokenId = currentIndex;
974     require(to != address(0), "ERC721A: mint to the zero address");
975     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
976     require(!_exists(startTokenId), "ERC721A: token already minted");
977     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
978 
979     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
980 
981     AddressData memory addressData = _addressData[to];
982     _addressData[to] = AddressData(
983       addressData.balance + uint128(quantity),
984       addressData.numberMinted + uint128(quantity)
985     );
986     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
987 
988     uint256 updatedIndex = startTokenId;
989 
990     for (uint256 i = 0; i < quantity; i++) {
991       emit Transfer(address(0), to, updatedIndex);
992       require(
993         _checkOnERC721Received(address(0), to, updatedIndex, _data),
994         "ERC721A: transfer to non ERC721Receiver implementer"
995       );
996       updatedIndex++;
997     }
998 
999     currentIndex = updatedIndex;
1000     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1001   }
1002 
1003   /**
1004    * @dev Transfers `tokenId` from `from` to `to`.
1005    *
1006    * Requirements:
1007    *
1008    * - `to` cannot be the zero address.
1009    * - `tokenId` token must be owned by `from`.
1010    *
1011    * Emits a {Transfer} event.
1012    */
1013   function _transfer(
1014     address from,
1015     address to,
1016     uint256 tokenId
1017   ) private {
1018     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1019 
1020     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1021       getApproved(tokenId) == _msgSender() ||
1022       isApprovedForAll(prevOwnership.addr, _msgSender()));
1023 
1024     require(
1025       isApprovedOrOwner,
1026       "ERC721A: transfer caller is not owner nor approved"
1027     );
1028 
1029     require(prevOwnership.addr == from,"ERC721A: transfer from incorrect owner");
1030     require(to != address(0), "ERC721A: transfer to the zero address");
1031 
1032     _beforeTokenTransfers(from, to, tokenId, 1);
1033 
1034     // Clear approvals from the previous owner
1035     _approve(address(0), tokenId, prevOwnership.addr);
1036 
1037     _addressData[from].balance -= 1;
1038     _addressData[to].balance += 1;
1039     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1040 
1041     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1042     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1043     uint256 nextTokenId = tokenId + 1;
1044     if (_ownerships[nextTokenId].addr == address(0)) {
1045       if (_exists(nextTokenId)) {
1046         _ownerships[nextTokenId] = TokenOwnership(
1047           prevOwnership.addr,
1048           prevOwnership.startTimestamp
1049         );
1050       }
1051     }
1052 
1053     emit Transfer(from, to, tokenId);
1054     _afterTokenTransfers(from, to, tokenId, 1);
1055   }
1056 
1057   /**
1058    * @dev Approve `to` to operate on `tokenId`
1059    *
1060    * Emits a {Approval} event.
1061    */
1062   function _approve(
1063     address to,
1064     uint256 tokenId,
1065     address owner
1066   ) private {
1067     _tokenApprovals[tokenId] = to;
1068     emit Approval(owner, to, tokenId);
1069   }
1070 
1071   uint256 public nextOwnerToExplicitlySet = 0;
1072 
1073   /**
1074    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1075    */
1076   function _setOwnersExplicit(uint256 quantity) internal {
1077     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1078     require(quantity > 0, "quantity must be nonzero");
1079     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1080     if (endIndex > currentIndex - 1) {
1081       endIndex = currentIndex - 1;
1082     }
1083     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1084     require(_exists(endIndex), "not enough minted yet for this cleanup");
1085     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1086       if (_ownerships[i].addr == address(0)) {
1087         TokenOwnership memory ownership = ownershipOf(i);
1088         _ownerships[i] = TokenOwnership(
1089           ownership.addr,
1090           ownership.startTimestamp
1091         );
1092       }
1093     }
1094     nextOwnerToExplicitlySet = endIndex + 1;
1095   }
1096 
1097   /**
1098    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1099    * The call is not executed if the target address is not a contract.
1100    *
1101    * @param from address representing the previous owner of the given token ID
1102    * @param to target address that will receive the tokens
1103    * @param tokenId uint256 ID of the token to be transferred
1104    * @param _data bytes optional data to send along with the call
1105    * @return bool whether the call correctly returned the expected magic value
1106    */
1107   function _checkOnERC721Received(
1108     address from,
1109     address to,
1110     uint256 tokenId,
1111     bytes memory _data
1112   ) private returns (bool) {
1113     if (to.isContract()) {
1114       try
1115         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1116       returns (bytes4 retval) {
1117         return retval == IERC721Receiver(to).onERC721Received.selector;
1118       } catch (bytes memory reason) {
1119         if (reason.length == 0) {
1120           revert("ERC721A: transfer to non ERC721Receiver implementer");
1121         } else {
1122           assembly {
1123             revert(add(32, reason), mload(reason))
1124           }
1125         }
1126       }
1127     } else {
1128       return true;
1129     }
1130   }
1131 
1132   /**
1133    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1134    *
1135    * startTokenId - the first token id to be transferred
1136    * quantity - the amount to be transferred
1137    *
1138    * Calling conditions:
1139    *
1140    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1141    * transferred to `to`.
1142    * - When `from` is zero, `tokenId` will be minted for `to`.
1143    */
1144   function _beforeTokenTransfers(
1145     address from,
1146     address to,
1147     uint256 startTokenId,
1148     uint256 quantity
1149   ) internal virtual {}
1150 
1151   /**
1152    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1153    * minting.
1154    *
1155    * startTokenId - the first token id to be transferred
1156    * quantity - the amount to be transferred
1157    *
1158    * Calling conditions:
1159    *
1160    * - when `from` and `to` are both non-zero.
1161    * - `from` and `to` are never both zero.
1162    */
1163   function _afterTokenTransfers(
1164     address from,
1165     address to,
1166     uint256 startTokenId,
1167     uint256 quantity
1168   ) internal virtual {}
1169 }
1170 
1171 
1172 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
1173 
1174 
1175 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 /**
1180  * @dev Contract module which provides a basic access control mechanism, where
1181  * there is an account (an owner) that can be granted exclusive access to
1182  * specific functions.
1183  *
1184  * By default, the owner account will be the one that deploys the contract. This
1185  * can later be changed with {transferOwnership}.
1186  *
1187  * This module is used through inheritance. It will make available the modifier
1188  * `onlyOwner`, which can be applied to your functions to restrict their use to
1189  * the owner.
1190  */
1191 abstract contract Ownable is Context {
1192     address private _owner;
1193 
1194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1195 
1196     /**
1197      * @dev Initializes the contract setting the deployer as the initial owner.
1198      */
1199     constructor() {
1200         _transferOwnership(_msgSender());
1201     }
1202 
1203     /**
1204      * @dev Returns the address of the current owner.
1205      */
1206     function owner() public view virtual returns (address) {
1207         return _owner;
1208     }
1209 
1210     /**
1211      * @dev Throws if called by any account other than the owner.
1212      */
1213     modifier onlyOwner() {
1214         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1215         _;
1216     }
1217 
1218     /**
1219      * @dev Leaves the contract without owner. It will not be possible to call
1220      * `onlyOwner` functions anymore. Can only be called by the current owner.
1221      *
1222      * NOTE: Renouncing ownership will leave the contract without an owner,
1223      * thereby removing any functionality that is only available to the owner.
1224      */
1225     function renounceOwnership() public virtual onlyOwner {
1226         _transferOwnership(address(0));
1227     }
1228 
1229     /**
1230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1231      * Can only be called by the current owner.
1232      */
1233     function transferOwnership(address newOwner) public virtual onlyOwner {
1234         require(newOwner != address(0), "Ownable: new owner is the zero address");
1235         _transferOwnership(newOwner);
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Internal function without access restriction.
1241      */
1242     function _transferOwnership(address newOwner) internal virtual {
1243         address oldOwner = _owner;
1244         _owner = newOwner;
1245         emit OwnershipTransferred(oldOwner, newOwner);
1246     }
1247 }
1248 
1249 
1250 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.1
1251 
1252 
1253 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 library MerkleProof {
1258     /**
1259      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1260      * defined by `root`. For this, a `proof` must be provided, containing
1261      * sibling hashes on the branch from the leaf to the root of the tree. Each
1262      * pair of leaves and each pair of pre-images are assumed to be sorted.
1263      */
1264     function verify( bytes32[] memory proof,bytes32 root, bytes32 leaf) internal pure returns (bool) 
1265     {
1266         return processProof(proof, leaf) == root;
1267     }
1268 
1269     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1270         bytes32 computedHash = leaf;
1271         for (uint256 i = 0; i < proof.length; i++) {
1272             bytes32 proofElement = proof[i];
1273             if (computedHash <= proofElement) {
1274                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1275             } else {
1276                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1277             }
1278         }
1279         return computedHash;
1280     }
1281 }
1282 
1283 
1284 
1285 pragma solidity ^0.8.2;
1286 
1287 contract Mekazuki is Ownable, ERC721A {
1288     string private _baseTokenURI;
1289     uint256 public publicTime;
1290     uint256 public freeSupply = 666;
1291     uint256 public supply = 10000;
1292     uint256 public price = 0.030 ether;
1293 
1294     uint256 public maxFreeMint = 1;
1295     uint256 public maxPublicMint = 20;
1296     uint256 public maxMintPerAccount = 20;
1297     uint256 public minted = 0;
1298 
1299     mapping (address => uint256) public listAddress;
1300 
1301     constructor(
1302         uint256 _publicTime
1303     ) ERC721A("MEKAZUKI", "MKZ", supply) {
1304 				publicTime = _publicTime;
1305     }
1306 
1307     event Created(address indexed to, uint256 amount);
1308 
1309     function _baseURI() internal view virtual override returns (string memory) {
1310         return _baseTokenURI;
1311     }
1312 
1313     function setBaseURI(string calldata baseURI) public onlyOwner {
1314         _baseTokenURI = baseURI;
1315     }
1316 
1317     function setMintTime(uint256 _publicTIme) public onlyOwner {
1318         publicTime = _publicTIme;
1319     }
1320 
1321     function mint(uint256 amount) payable public {
1322         require(publicTime > 0 && block.timestamp > publicTime, "Invalid mint time");
1323         if (minted < freeSupply) 
1324         {
1325           require(minted + amount <= freeSupply, "Free Mint Closed");
1326           require(listAddress[msg.sender] + amount <= maxFreeMint,"Limit");
1327         }
1328         else 
1329         {
1330           require(amount <= maxMintPerAccount,"Max 20 Amount");
1331           require(minted + amount <= supply, "Sold Out");
1332           require(listAddress[msg.sender] + amount <= maxMintPerAccount,"Limit");
1333           require(msg.value >= price * amount, "Out of ETH");
1334         }
1335         minted += amount;
1336         listAddress[msg.sender] += amount;
1337          _safeMint(msg.sender, amount);
1338     }
1339     
1340     function devMint( address to,uint256 numToMint) payable public onlyOwner {
1341         _safeMint(to, numToMint);
1342     }
1343 		
1344     function withdraw() public onlyOwner {
1345         payable(msg.sender).transfer(payable(address(this)).balance);
1346     }
1347 
1348     function setOwnersExplicit(uint256 quantity) public onlyOwner {
1349         _setOwnersExplicit(quantity);
1350     }
1351 
1352     function numberMinted(address owner) public view returns (uint256) {
1353         return _numberMinted(owner);
1354     }
1355 
1356 
1357 }