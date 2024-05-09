1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
33 
34 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @title ERC721 token receiver interface
185  * @dev Interface for any contract that wants to support safeTransfers
186  * from ERC721 asset contracts.
187  */
188 interface IERC721Receiver {
189     /**
190      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
191      * by `operator` from `from`, this function is called.
192      *
193      * It must return its Solidity selector to confirm the token transfer.
194      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
195      *
196      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
197      */
198     function onERC721Received(
199         address operator,
200         address from,
201         uint256 tokenId,
202         bytes calldata data
203     ) external returns (bytes4);
204 }
205 
206 
207 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Metadata is IERC721 {
219     /**
220      * @dev Returns the token collection name.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the token collection symbol.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
231      */
232     function tokenURI(uint256 tokenId) external view returns (string memory);
233 }
234 
235 
236 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.1
237 
238 
239 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
245  * @dev See https://eips.ethereum.org/EIPS/eip-721
246  */
247 interface IERC721Enumerable is IERC721 {
248     /**
249      * @dev Returns the total amount of tokens stored by the contract.
250      */
251     function totalSupply() external view returns (uint256);
252 
253     /**
254      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
255      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
256      */
257     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
258 
259     /**
260      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
261      * Use along with {totalSupply} to enumerate all tokens.
262      */
263     function tokenByIndex(uint256 index) external view returns (uint256);
264 }
265 
266 
267 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // This method relies on extcodesize, which returns 0 for contracts in
297         // construction, since the code is only stored at the end of the
298         // constructor execution.
299 
300         uint256 size;
301         assembly {
302             size := extcodesize(account)
303         }
304         return size > 0;
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         (bool success, ) = recipient.call{value: amount}("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain `call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(address(this).balance >= value, "Address: insufficient balance for call");
398         require(isContract(target), "Address: call to non-contract");
399 
400         (bool success, bytes memory returndata) = target.call{value: value}(data);
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
411         return functionStaticCall(target, data, "Address: low-level static call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal view returns (bytes memory) {
425         require(isContract(target), "Address: static call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.staticcall(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a delegate call.
444      *
445      * _Available since v3.4._
446      */
447     function functionDelegateCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         require(isContract(target), "Address: delegate call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.delegatecall(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
460      * revert reason using the provided one.
461      *
462      * _Available since v4.3._
463      */
464     function verifyCallResult(
465         bool success,
466         bytes memory returndata,
467         string memory errorMessage
468     ) internal pure returns (bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 assembly {
477                     let returndata_size := mload(returndata)
478                     revert(add(32, returndata), returndata_size)
479                 }
480             } else {
481                 revert(errorMessage);
482             }
483         }
484     }
485 }
486 
487 
488 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
489 
490 
491 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Provides information about the current execution context, including the
497  * sender of the transaction and its data. While these are generally available
498  * via msg.sender and msg.data, they should not be accessed in such a direct
499  * manner, since when dealing with meta-transactions the account sending and
500  * paying for execution may not be the actual sender (as far as an application
501  * is concerned).
502  *
503  * This contract is only required for intermediate, library-like contracts.
504  */
505 abstract contract Context {
506     function _msgSender() internal view virtual returns (address) {
507         return msg.sender;
508     }
509 
510     function _msgData() internal view virtual returns (bytes calldata) {
511         return msg.data;
512     }
513 }
514 
515 
516 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev String operations.
525  */
526 library Strings {
527     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
531      */
532     function toString(uint256 value) internal pure returns (string memory) {
533         // Inspired by OraclizeAPI's implementation - MIT licence
534         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
535 
536         if (value == 0) {
537             return "0";
538         }
539         uint256 temp = value;
540         uint256 digits;
541         while (temp != 0) {
542             digits++;
543             temp /= 10;
544         }
545         bytes memory buffer = new bytes(digits);
546         while (value != 0) {
547             digits -= 1;
548             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
549             value /= 10;
550         }
551         return string(buffer);
552     }
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
556      */
557     function toHexString(uint256 value) internal pure returns (string memory) {
558         if (value == 0) {
559             return "0x00";
560         }
561         uint256 temp = value;
562         uint256 length = 0;
563         while (temp != 0) {
564             length++;
565             temp >>= 8;
566         }
567         return toHexString(value, length);
568     }
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
572      */
573     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
574         bytes memory buffer = new bytes(2 * length + 2);
575         buffer[0] = "0";
576         buffer[1] = "x";
577         for (uint256 i = 2 * length + 1; i > 1; --i) {
578             buffer[i] = _HEX_SYMBOLS[value & 0xf];
579             value >>= 4;
580         }
581         require(value == 0, "Strings: hex length insufficient");
582         return string(buffer);
583     }
584 }
585 
586 
587 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 
617 
618 // File contracts/ERC721A.sol
619 
620 
621 // Creators: locationtba.eth, 2pmflow.eth
622 
623 pragma solidity ^0.8.0;
624 
625 
626 
627 
628 
629 
630 
631 
632 /**
633  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
634  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
635  *
636  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
637  *
638  * Does not support burning tokens to address(0).
639  */
640 contract ERC721A is
641   Context,
642   ERC165,
643   IERC721,
644   IERC721Metadata,
645   IERC721Enumerable
646 {
647   using Address for address;
648   using Strings for uint256;
649 
650   struct TokenOwnership {
651     address addr;
652     uint64 startTimestamp;
653   }
654 
655   struct AddressData {
656     uint128 balance;
657     uint128 numberMinted;
658   }
659 
660   uint256 private currentIndex = 0;
661 
662   uint256 internal immutable maxBatchSize;
663 
664   // Token name
665   string private _name;
666 
667   // Token symbol
668   string private _symbol;
669 
670   // Mapping from token ID to ownership details
671   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
672   mapping(uint256 => TokenOwnership) private _ownerships;
673 
674   // Mapping owner address to address data
675   mapping(address => AddressData) private _addressData;
676 
677   // Mapping from token ID to approved address
678   mapping(uint256 => address) private _tokenApprovals;
679 
680   // Mapping from owner to operator approvals
681   mapping(address => mapping(address => bool)) private _operatorApprovals;
682 
683   /**
684    * @dev
685    * `maxBatchSize` refers to how much a minter can mint at a time.
686    */
687   constructor(
688     string memory name_,
689     string memory symbol_,
690     uint256 maxBatchSize_
691   ) {
692     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
693     _name = name_;
694     _symbol = symbol_;
695     maxBatchSize = maxBatchSize_;
696   }
697 
698   /**
699    * @dev See {IERC721Enumerable-totalSupply}.
700    */
701   function totalSupply() public view override returns (uint256) {
702     return currentIndex;
703   }
704 
705   /**
706    * @dev See {IERC721Enumerable-tokenByIndex}.
707    */
708   function tokenByIndex(uint256 index) public view override returns (uint256) {
709     require(index < totalSupply(), "ERC721A: global index out of bounds");
710     return index;
711   }
712 
713   /**
714    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
715    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
716    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
717    */
718   function tokenOfOwnerByIndex(address owner, uint256 index)
719     public
720     view
721     override
722     returns (uint256)
723   {
724     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
725     uint256 numMintedSoFar = totalSupply();
726     uint256 tokenIdsIdx = 0;
727     address currOwnershipAddr = address(0);
728     for (uint256 i = 0; i < numMintedSoFar; i++) {
729       TokenOwnership memory ownership = _ownerships[i];
730       if (ownership.addr != address(0)) {
731         currOwnershipAddr = ownership.addr;
732       }
733       if (currOwnershipAddr == owner) {
734         if (tokenIdsIdx == index) {
735           return i;
736         }
737         tokenIdsIdx++;
738       }
739     }
740     revert("ERC721A: unable to get token of owner by index");
741   }
742 
743   /**
744    * @dev See {IERC165-supportsInterface}.
745    */
746   function supportsInterface(bytes4 interfaceId)
747     public
748     view
749     virtual
750     override(ERC165, IERC165)
751     returns (bool)
752   {
753     return
754       interfaceId == type(IERC721).interfaceId ||
755       interfaceId == type(IERC721Metadata).interfaceId ||
756       interfaceId == type(IERC721Enumerable).interfaceId ||
757       super.supportsInterface(interfaceId);
758   }
759 
760   /**
761    * @dev See {IERC721-balanceOf}.
762    */
763   function balanceOf(address owner) public view override returns (uint256) {
764     require(owner != address(0), "ERC721A: balance query for the zero address");
765     return uint256(_addressData[owner].balance);
766   }
767 
768   function _numberMinted(address owner) internal view returns (uint256) {
769     require(
770       owner != address(0),
771       "ERC721A: number minted query for the zero address"
772     );
773     return uint256(_addressData[owner].numberMinted);
774   }
775 
776   function ownershipOf(uint256 tokenId)
777     internal
778     view
779     returns (TokenOwnership memory)
780   {
781     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
782 
783     uint256 lowestTokenToCheck;
784     if (tokenId >= maxBatchSize) {
785       lowestTokenToCheck = tokenId - maxBatchSize + 1;
786     }
787 
788     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
789       TokenOwnership memory ownership = _ownerships[curr];
790       if (ownership.addr != address(0)) {
791         return ownership;
792       }
793     }
794 
795     revert("ERC721A: unable to determine the owner of token");
796   }
797 
798   /**
799    * @dev See {IERC721-ownerOf}.
800    */
801   function ownerOf(uint256 tokenId) public view override returns (address) {
802     return ownershipOf(tokenId).addr;
803   }
804 
805   /**
806    * @dev See {IERC721Metadata-name}.
807    */
808   function name() public view virtual override returns (string memory) {
809     return _name;
810   }
811 
812   /**
813    * @dev See {IERC721Metadata-symbol}.
814    */
815   function symbol() public view virtual override returns (string memory) {
816     return _symbol;
817   }
818 
819   /**
820    * @dev See {IERC721Metadata-tokenURI}.
821    */
822   function tokenURI(uint256 tokenId)
823     public
824     view
825     virtual
826     override
827     returns (string memory)
828   {
829     require(
830       _exists(tokenId),
831       "ERC721Metadata: URI query for nonexistent token"
832     );
833 
834     string memory baseURI = _baseURI();
835     return
836       bytes(baseURI).length > 0
837         ? string(abi.encodePacked(baseURI, tokenId.toString()))
838         : "";
839   }
840 
841   /**
842    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
843    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
844    * by default, can be overriden in child contracts.
845    */
846   function _baseURI() internal view virtual returns (string memory) {
847     return "";
848   }
849 
850   /**
851    * @dev See {IERC721-approve}.
852    */
853   function approve(address to, uint256 tokenId) public override {
854     address owner = ERC721A.ownerOf(tokenId);
855     require(to != owner, "ERC721A: approval to current owner");
856 
857     require(
858       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
859       "ERC721A: approve caller is not owner nor approved for all"
860     );
861 
862     _approve(to, tokenId, owner);
863   }
864 
865   /**
866    * @dev See {IERC721-getApproved}.
867    */
868   function getApproved(uint256 tokenId) public view override returns (address) {
869     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
870 
871     return _tokenApprovals[tokenId];
872   }
873 
874   /**
875    * @dev See {IERC721-setApprovalForAll}.
876    */
877   function setApprovalForAll(address operator, bool approved) public override {
878     require(operator != _msgSender(), "ERC721A: approve to caller");
879 
880     _operatorApprovals[_msgSender()][operator] = approved;
881     emit ApprovalForAll(_msgSender(), operator, approved);
882   }
883 
884   /**
885    * @dev See {IERC721-isApprovedForAll}.
886    */
887   function isApprovedForAll(address owner, address operator)
888     public
889     view
890     virtual
891     override
892     returns (bool)
893   {
894     return _operatorApprovals[owner][operator];
895   }
896 
897   /**
898    * @dev See {IERC721-transferFrom}.
899    */
900   function transferFrom(
901     address from,
902     address to,
903     uint256 tokenId
904   ) public override {
905     _transfer(from, to, tokenId);
906   }
907 
908   /**
909    * @dev See {IERC721-safeTransferFrom}.
910    */
911   function safeTransferFrom(
912     address from,
913     address to,
914     uint256 tokenId
915   ) public override {
916     safeTransferFrom(from, to, tokenId, "");
917   }
918 
919   /**
920    * @dev See {IERC721-safeTransferFrom}.
921    */
922   function safeTransferFrom(
923     address from,
924     address to,
925     uint256 tokenId,
926     bytes memory _data
927   ) public override {
928     _transfer(from, to, tokenId);
929     require(
930       _checkOnERC721Received(from, to, tokenId, _data),
931       "ERC721A: transfer to non ERC721Receiver implementer"
932     );
933   }
934 
935   /**
936    * @dev Returns whether `tokenId` exists.
937    *
938    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
939    *
940    * Tokens start existing when they are minted (`_mint`),
941    */
942   function _exists(uint256 tokenId) internal view returns (bool) {
943     return tokenId < currentIndex;
944   }
945 
946   function _safeMint(address to, uint256 quantity) internal {
947     _safeMint(to, quantity, "");
948   }
949 
950   /**
951    * @dev Mints `quantity` tokens and transfers them to `to`.
952    *
953    * Requirements:
954    *
955    * - `to` cannot be the zero address.
956    * - `quantity` cannot be larger than the max batch size.
957    *
958    * Emits a {Transfer} event.
959    */
960   function _safeMint(
961     address to,
962     uint256 quantity,
963     bytes memory _data
964   ) internal {
965     uint256 startTokenId = currentIndex;
966     require(to != address(0), "ERC721A: mint to the zero address");
967     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
968     require(!_exists(startTokenId), "ERC721A: token already minted");
969     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
970 
971     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
972 
973     AddressData memory addressData = _addressData[to];
974     _addressData[to] = AddressData(
975       addressData.balance + uint128(quantity),
976       addressData.numberMinted + uint128(quantity)
977     );
978     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
979 
980     uint256 updatedIndex = startTokenId;
981 
982     for (uint256 i = 0; i < quantity; i++) {
983       emit Transfer(address(0), to, updatedIndex);
984       require(
985         _checkOnERC721Received(address(0), to, updatedIndex, _data),
986         "ERC721A: transfer to non ERC721Receiver implementer"
987       );
988       updatedIndex++;
989     }
990 
991     currentIndex = updatedIndex;
992     _afterTokenTransfers(address(0), to, startTokenId, quantity);
993   }
994 
995   /**
996    * @dev Transfers `tokenId` from `from` to `to`.
997    *
998    * Requirements:
999    *
1000    * - `to` cannot be the zero address.
1001    * - `tokenId` token must be owned by `from`.
1002    *
1003    * Emits a {Transfer} event.
1004    */
1005   function _transfer(
1006     address from,
1007     address to,
1008     uint256 tokenId
1009   ) private {
1010     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1011 
1012     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1013       getApproved(tokenId) == _msgSender() ||
1014       isApprovedForAll(prevOwnership.addr, _msgSender()));
1015 
1016     require(
1017       isApprovedOrOwner,
1018       "ERC721A: transfer caller is not owner nor approved"
1019     );
1020 
1021     require(
1022       prevOwnership.addr == from,
1023       "ERC721A: transfer from incorrect owner"
1024     );
1025     require(to != address(0), "ERC721A: transfer to the zero address");
1026 
1027     _beforeTokenTransfers(from, to, tokenId, 1);
1028 
1029     // Clear approvals from the previous owner
1030     _approve(address(0), tokenId, prevOwnership.addr);
1031 
1032     _addressData[from].balance -= 1;
1033     _addressData[to].balance += 1;
1034     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1035 
1036     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1037     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1038     uint256 nextTokenId = tokenId + 1;
1039     if (_ownerships[nextTokenId].addr == address(0)) {
1040       if (_exists(nextTokenId)) {
1041         _ownerships[nextTokenId] = TokenOwnership(
1042           prevOwnership.addr,
1043           prevOwnership.startTimestamp
1044         );
1045       }
1046     }
1047 
1048     emit Transfer(from, to, tokenId);
1049     _afterTokenTransfers(from, to, tokenId, 1);
1050   }
1051 
1052   /**
1053    * @dev Approve `to` to operate on `tokenId`
1054    *
1055    * Emits a {Approval} event.
1056    */
1057   function _approve(
1058     address to,
1059     uint256 tokenId,
1060     address owner
1061   ) private {
1062     _tokenApprovals[tokenId] = to;
1063     emit Approval(owner, to, tokenId);
1064   }
1065 
1066   uint256 public nextOwnerToExplicitlySet = 0;
1067 
1068   /**
1069    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1070    */
1071   function _setOwnersExplicit(uint256 quantity) internal {
1072     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1073     require(quantity > 0, "quantity must be nonzero");
1074     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1075     if (endIndex > currentIndex - 1) {
1076       endIndex = currentIndex - 1;
1077     }
1078     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1079     require(_exists(endIndex), "not enough minted yet for this cleanup");
1080     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1081       if (_ownerships[i].addr == address(0)) {
1082         TokenOwnership memory ownership = ownershipOf(i);
1083         _ownerships[i] = TokenOwnership(
1084           ownership.addr,
1085           ownership.startTimestamp
1086         );
1087       }
1088     }
1089     nextOwnerToExplicitlySet = endIndex + 1;
1090   }
1091 
1092   /**
1093    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1094    * The call is not executed if the target address is not a contract.
1095    *
1096    * @param from address representing the previous owner of the given token ID
1097    * @param to target address that will receive the tokens
1098    * @param tokenId uint256 ID of the token to be transferred
1099    * @param _data bytes optional data to send along with the call
1100    * @return bool whether the call correctly returned the expected magic value
1101    */
1102   function _checkOnERC721Received(
1103     address from,
1104     address to,
1105     uint256 tokenId,
1106     bytes memory _data
1107   ) private returns (bool) {
1108     if (to.isContract()) {
1109       try
1110         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1111       returns (bytes4 retval) {
1112         return retval == IERC721Receiver(to).onERC721Received.selector;
1113       } catch (bytes memory reason) {
1114         if (reason.length == 0) {
1115           revert("ERC721A: transfer to non ERC721Receiver implementer");
1116         } else {
1117           assembly {
1118             revert(add(32, reason), mload(reason))
1119           }
1120         }
1121       }
1122     } else {
1123       return true;
1124     }
1125   }
1126 
1127   /**
1128    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1129    *
1130    * startTokenId - the first token id to be transferred
1131    * quantity - the amount to be transferred
1132    *
1133    * Calling conditions:
1134    *
1135    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1136    * transferred to `to`.
1137    * - When `from` is zero, `tokenId` will be minted for `to`.
1138    */
1139   function _beforeTokenTransfers(
1140     address from,
1141     address to,
1142     uint256 startTokenId,
1143     uint256 quantity
1144   ) internal virtual {}
1145 
1146   /**
1147    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1148    * minting.
1149    *
1150    * startTokenId - the first token id to be transferred
1151    * quantity - the amount to be transferred
1152    *
1153    * Calling conditions:
1154    *
1155    * - when `from` and `to` are both non-zero.
1156    * - `from` and `to` are never both zero.
1157    */
1158   function _afterTokenTransfers(
1159     address from,
1160     address to,
1161     uint256 startTokenId,
1162     uint256 quantity
1163   ) internal virtual {}
1164 }
1165 
1166 
1167 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
1168 
1169 
1170 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 /**
1175  * @dev Contract module which provides a basic access control mechanism, where
1176  * there is an account (an owner) that can be granted exclusive access to
1177  * specific functions.
1178  *
1179  * By default, the owner account will be the one that deploys the contract. This
1180  * can later be changed with {transferOwnership}.
1181  *
1182  * This module is used through inheritance. It will make available the modifier
1183  * `onlyOwner`, which can be applied to your functions to restrict their use to
1184  * the owner.
1185  */
1186 abstract contract Ownable is Context {
1187     address private _owner;
1188 
1189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1190 
1191     /**
1192      * @dev Initializes the contract setting the deployer as the initial owner.
1193      */
1194     constructor() {
1195         _transferOwnership(_msgSender());
1196     }
1197 
1198     /**
1199      * @dev Returns the address of the current owner.
1200      */
1201     function owner() public view virtual returns (address) {
1202         return _owner;
1203     }
1204 
1205     /**
1206      * @dev Throws if called by any account other than the owner.
1207      */
1208     modifier onlyOwner() {
1209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1210         _;
1211     }
1212 
1213     /**
1214      * @dev Leaves the contract without owner. It will not be possible to call
1215      * `onlyOwner` functions anymore. Can only be called by the current owner.
1216      *
1217      * NOTE: Renouncing ownership will leave the contract without an owner,
1218      * thereby removing any functionality that is only available to the owner.
1219      */
1220     function renounceOwnership() public virtual onlyOwner {
1221         _transferOwnership(address(0));
1222     }
1223 
1224     /**
1225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1226      * Can only be called by the current owner.
1227      */
1228     function transferOwnership(address newOwner) public virtual onlyOwner {
1229         require(newOwner != address(0), "Ownable: new owner is the zero address");
1230         _transferOwnership(newOwner);
1231     }
1232 
1233     /**
1234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1235      * Internal function without access restriction.
1236      */
1237     function _transferOwnership(address newOwner) internal virtual {
1238         address oldOwner = _owner;
1239         _owner = newOwner;
1240         emit OwnershipTransferred(oldOwner, newOwner);
1241     }
1242 }
1243 
1244 
1245 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.1
1246 
1247 
1248 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 /**
1253  * @dev These functions deal with verification of Merkle Trees proofs.
1254  *
1255  * The proofs can be generated using the JavaScript library
1256  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1257  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1258  *
1259  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1260  */
1261 library MerkleProof {
1262     /**
1263      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1264      * defined by `root`. For this, a `proof` must be provided, containing
1265      * sibling hashes on the branch from the leaf to the root of the tree. Each
1266      * pair of leaves and each pair of pre-images are assumed to be sorted.
1267      */
1268     function verify(
1269         bytes32[] memory proof,
1270         bytes32 root,
1271         bytes32 leaf
1272     ) internal pure returns (bool) {
1273         return processProof(proof, leaf) == root;
1274     }
1275 
1276     /**
1277      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1278      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1279      * hash matches the root of the tree. When processing the proof, the pairs
1280      * of leafs & pre-images are assumed to be sorted.
1281      *
1282      * _Available since v4.4._
1283      */
1284     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1285         bytes32 computedHash = leaf;
1286         for (uint256 i = 0; i < proof.length; i++) {
1287             bytes32 proofElement = proof[i];
1288             if (computedHash <= proofElement) {
1289                 // Hash(current computed hash + current element of the proof)
1290                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1291             } else {
1292                 // Hash(current element of the proof + current computed hash)
1293                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1294             }
1295         }
1296         return computedHash;
1297     }
1298 }
1299 
1300 
1301 // File contracts/FFC.sol
1302 
1303 
1304 pragma solidity ^0.8.2;
1305 
1306 
1307 
1308 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1309 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1310 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1311 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1312 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1313 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1314 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1315 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1316 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1317 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&  @@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1318 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     *@,  .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1319 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%  @@%   @@       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1320 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(      ,@@%.         ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1321 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             .&@*         (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1322 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&                                        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1323 // @@@@@@@@@@@@@@@@@@@@@@@@@@*                                                #@@@@@@@@@@@@@@@@@@@@@@@@
1324 // @@@@@@@@@@@@@@@@@@@@@#                                                        @@@@@@@@@@@@@@@@@@@@@@
1325 // @@@@@@@@@@@@@@@@@@                                                              %@@@@@@@@@@@@@@@@@@@
1326 // @@@@@@@@@@@@@@@@                                                                  @@@@@@@@@@@@@@@@@@
1327 // @@@@@@@@@@@@@@                                                                  @@.    *@@@@@@@@@@@@
1328 // @@@@@@@@@@@@%                                                                   @#    ..@@@@@@@@@@@@
1329 // @@@@@@@@@@@%                                  (@@@@@(                            &@@&@@@@@@@@@@@@@@@
1330 // @@@@@@@@@@@                                 ,@*.    *@,                              *@@@@@@@@@@@@@@
1331 // @@@@@@@@@@@                                 #@..  ...@#                               @@@@@@@@@@@@@@
1332 // @@@@@@@@@@@                                  *@@*./@@*         .@.   (@               @@@@@@@@@@@@@@
1333 // @@@@@@@@@@@                                                      %@@@&               /@@@@@@@@@@@@@@
1334 // @@@@@@@@@@@                                                                          @@@@@@@@@@@@@@@
1335 // @@@@@@@@@@@(                                                                        &@@@@@@@@@@@@@@@
1336 // @@@@@@@@@@@@                                                                       @@@@@@@@@@@@@@@@@
1337 // @@@@@@@@@@@@&                                                                    ,@@@@@@@@@@@@@@@@@@
1338 // @@@@@@@@@@@@@&                                                                 ,@@@@@@@@@@@@@@@@@@@@
1339 // @@@@@@@@@@@@@@@,                                                            .@@@@@@@@@@@@@@@@@@@@@@@
1340 // @@@@@@@@@@@@@@@@@@                                                       &@@@@@@@@@@@@@@@@@@@@@@@@@@
1341 // @@@@@@@@@@@@@@@@@@@@@.                                              *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1342 // @@@@@@@@@@@@@@@@@@@@@@@@@@/                                   (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1343 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/.              .*&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1344 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1345 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1346 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1347 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1348 contract FortuneFriendsClub is Ownable, ERC721A {
1349     string private _baseTokenURI;
1350 
1351     uint256 public presaleTime;
1352     uint256 public affectedTime;
1353     uint256 public publicRaffleTime;
1354 
1355     bytes32 public presaleMerkleRoot;
1356     bytes32 public affectedMerkleRoot;
1357     bytes32 public publicRaffleMerkleRoot;
1358 
1359     uint16 public devAmount = 100;
1360     uint16 public presaleAmount = 8645;
1361     uint256 public price = 0.055 ether;
1362     uint16 public supply = 8888;
1363 
1364     constructor(
1365         bytes32 _presaleMerkleRoot, 
1366         bytes32 _affectedMerkleRoot, 
1367         uint256 _presaleTime,
1368         uint256 _affectedTime,
1369         uint256 _publicRaffleTime
1370     ) ERC721A("Fortune Friends Club", "FFC", supply) {
1371         presaleMerkleRoot = _presaleMerkleRoot;
1372         affectedMerkleRoot = _affectedMerkleRoot;
1373 				presaleTime = _presaleTime;
1374 				affectedTime = _affectedTime;
1375 				publicRaffleTime = _publicRaffleTime;
1376     }
1377 
1378     event Created(address indexed to, uint256 amount);
1379 
1380     // Base URI
1381 
1382     function _baseURI() internal view virtual override returns (string memory) {
1383         return _baseTokenURI;
1384     }
1385 
1386     // Setters
1387 
1388     function setBaseURI(string calldata baseURI) public onlyOwner {
1389         _baseTokenURI = baseURI;
1390     }
1391 
1392     function setPresaleMerkleRoot(bytes32 newMerkleRoot) public onlyOwner {
1393         presaleMerkleRoot = newMerkleRoot;
1394     }
1395 
1396     function setAffectedMerkleRoot(bytes32 newMerkleRoot) public onlyOwner {
1397         affectedMerkleRoot = newMerkleRoot;
1398     }
1399 
1400     function setPublicRaffleMerkleRoot(bytes32 newMerkleRoot) public onlyOwner {
1401         publicRaffleMerkleRoot = newMerkleRoot;
1402     }
1403 
1404     function setMintTime(uint256 _presaleTime, uint256 _affectedTime, uint256 _publicRaffleTime) public onlyOwner {
1405         require(_affectedTime > _presaleTime && _publicRaffleTime > _affectedTime, "Invalid mint timings");
1406         presaleTime = _presaleTime;
1407         affectedTime = _affectedTime;
1408         publicRaffleTime = _publicRaffleTime;
1409     }
1410 
1411     // Mint
1412 
1413     function presaleMint(
1414         bytes32[] calldata merkleProof, uint16 numToMint, uint16 mintCap
1415     ) payable public isMintValid(numToMint, mintCap) isPriceValid(numToMint) isMintLive(presaleTime) {
1416         require(totalSupply() + numToMint < presaleAmount + 1, "Not enough remaining for mint amount requested");
1417         require(MerkleProof.verify(merkleProof, presaleMerkleRoot, keccak256(abi.encodePacked(msg.sender, mintCap))), "Leaf node could not be verified, check proof.");
1418         _safeMint(msg.sender, numToMint);
1419         emit Created(msg.sender, numToMint);
1420     }
1421 
1422     function affectedMint(
1423         bytes32[] calldata merkleProof, uint16 numToMint, uint16 mintCap
1424     ) payable public isMintValid(numToMint, mintCap) isMintLive(affectedTime) {
1425         require(MerkleProof.verify(merkleProof, affectedMerkleRoot, keccak256(abi.encodePacked(msg.sender, mintCap))), "Leaf node could not be verified, check proof");
1426         _safeMint(msg.sender, numToMint);
1427         emit Created(msg.sender, numToMint);
1428     }
1429 
1430     function publicRaffleMint(
1431         bytes32[] calldata merkleProof, uint16 numToMint
1432     ) payable public isMintValid(numToMint, 1) isPriceValid(numToMint) isMintLive(publicRaffleTime) {
1433         require(MerkleProof.verify(merkleProof, publicRaffleMerkleRoot, keccak256(abi.encodePacked(msg.sender))), "Leaf node could not be verified, check proof");
1434         _safeMint(msg.sender, numToMint);
1435         emit Created(msg.sender, numToMint);
1436     }
1437 
1438     function devMint(
1439         address to,
1440         uint16 numToMint
1441     ) payable public onlyOwner isMintValid(numToMint, devAmount) {
1442 				require(numToMint % 5 == 0);
1443         for (uint32 i = 0; i < numToMint / 5; i++) {
1444             _safeMint(to, 5);
1445         }
1446     }
1447 		
1448     // Dev
1449 
1450     function withdraw() public onlyOwner {
1451         payable(msg.sender).transfer(payable(address(this)).balance);
1452     }
1453 
1454     function setOwnersExplicit(uint256 quantity) public onlyOwner {
1455         _setOwnersExplicit(quantity);
1456     }
1457 
1458     function numberMinted(address owner) public view returns (uint256) {
1459         return _numberMinted(owner);
1460     }
1461 
1462 
1463     // Modifiers
1464 
1465     modifier isMintValid(uint16 numToMint, uint16 mintCap) {
1466         require(totalSupply() + numToMint < supply + 1, "Not enough remaining for mint amount requested");
1467         require(numberMinted(msg.sender) + numToMint < mintCap + 1, "Too many minted");
1468         require(numToMint > 0, "Quantity needs to be more than 0");
1469         _;
1470     }
1471 
1472     modifier isPriceValid(uint16 numToMint) {
1473         require(msg.value > 0, "Value has to be above 0");
1474         require(msg.value == price * numToMint, "Not enough ETH sent: check price");
1475         require(numberMinted(msg.sender) < 1, "Has minted before");
1476         _;
1477     }
1478 
1479     modifier isMintLive(uint256 time) {
1480         require(time > 0 && block.timestamp > time, "Invalid mint time");
1481         _;
1482     }
1483 }