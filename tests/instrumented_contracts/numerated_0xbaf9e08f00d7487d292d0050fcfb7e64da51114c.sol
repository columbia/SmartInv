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
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      */
100     function isContract(address account) internal view returns (bool) {
101         // This method relies on extcodesize, which returns 0 for contracts in
102         // construction, since the code is only stored at the end of the
103         // constructor execution.
104 
105         uint256 size;
106         assembly {
107             size := extcodesize(account)
108         }
109         return size > 0;
110     }
111 
112     /**
113      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
114      * `recipient`, forwarding all available gas and reverting on errors.
115      *
116      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
117      * of certain opcodes, possibly making contracts go over the 2300 gas limit
118      * imposed by `transfer`, making them unable to receive funds via
119      * `transfer`. {sendValue} removes this limitation.
120      *
121      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
122      *
123      * IMPORTANT: because control is transferred to `recipient`, care must be
124      * taken to not create reentrancy vulnerabilities. Consider using
125      * {ReentrancyGuard} or the
126      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
127      */
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         (bool success, ) = recipient.call{value: amount}("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134 
135     /**
136      * @dev Performs a Solidity function call using a low level `call`. A
137      * plain `call` is an unsafe replacement for a function call: use this
138      * function instead.
139      *
140      * If `target` reverts with a revert reason, it is bubbled up by this
141      * function (like regular Solidity function calls).
142      *
143      * Returns the raw returned data. To convert to the expected return value,
144      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
145      *
146      * Requirements:
147      *
148      * - `target` must be a contract.
149      * - calling `target` with `data` must not revert.
150      *
151      * _Available since v3.1._
152      */
153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
159      * `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but also transferring `value` wei to `target`.
174      *
175      * Requirements:
176      *
177      * - the calling contract must have an ETH balance of at least `value`.
178      * - the called Solidity function must be `payable`.
179      *
180      * _Available since v3.1._
181      */
182     function functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 value
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
192      * with `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(address(this).balance >= value, "Address: insufficient balance for call");
203         require(isContract(target), "Address: call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.call{value: value}(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but performing a static call.
212      *
213      * _Available since v3.3._
214      */
215     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
216         return functionStaticCall(target, data, "Address: low-level static call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal view returns (bytes memory) {
230         require(isContract(target), "Address: static call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.staticcall(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a delegate call.
239      *
240      * _Available since v3.4._
241      */
242     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         require(isContract(target), "Address: delegate call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.delegatecall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
265      * revert reason using the provided one.
266      *
267      * _Available since v4.3._
268      */
269     function verifyCallResult(
270         bool success,
271         bytes memory returndata,
272         string memory errorMessage
273     ) internal pure returns (bytes memory) {
274         if (success) {
275             return returndata;
276         } else {
277             // Look for revert reason and bubble it up if present
278             if (returndata.length > 0) {
279                 // The easiest way to bubble the revert reason is using memory via assembly
280 
281                 assembly {
282                     let returndata_size := mload(returndata)
283                     revert(add(32, returndata), returndata_size)
284                 }
285             } else {
286                 revert(errorMessage);
287             }
288         }
289     }
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @title ERC721 token receiver interface
301  * @dev Interface for any contract that wants to support safeTransfers
302  * from ERC721 asset contracts.
303  */
304 interface IERC721Receiver {
305     /**
306      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
307      * by `operator` from `from`, this function is called.
308      *
309      * It must return its Solidity selector to confirm the token transfer.
310      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
311      *
312      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
313      */
314     function onERC721Received(
315         address operator,
316         address from,
317         uint256 tokenId,
318         bytes calldata data
319     ) external returns (bytes4);
320 }
321 
322 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Interface of the ERC165 standard, as defined in the
331  * https://eips.ethereum.org/EIPS/eip-165[EIP].
332  *
333  * Implementers can declare support of contract interfaces, which can then be
334  * queried by others ({ERC165Checker}).
335  *
336  * For an implementation, see {ERC165}.
337  */
338 interface IERC165 {
339     /**
340      * @dev Returns true if this contract implements the interface defined by
341      * `interfaceId`. See the corresponding
342      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
343      * to learn more about how these ids are created.
344      *
345      * This function call must use less than 30 000 gas.
346      */
347     function supportsInterface(bytes4 interfaceId) external view returns (bool);
348 }
349 
350 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Implementation of the {IERC165} interface.
360  *
361  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
362  * for the additional interface id that will be supported. For example:
363  *
364  * ```solidity
365  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
366  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
367  * }
368  * ```
369  *
370  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
371  */
372 abstract contract ERC165 is IERC165 {
373     /**
374      * @dev See {IERC165-supportsInterface}.
375      */
376     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377         return interfaceId == type(IERC165).interfaceId;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Required interface of an ERC721 compliant contract.
391  */
392 interface IERC721 is IERC165 {
393     /**
394      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
397 
398     /**
399      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
400      */
401     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
405      */
406     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
407 
408     /**
409      * @dev Returns the number of tokens in ``owner``'s account.
410      */
411     function balanceOf(address owner) external view returns (uint256 balance);
412 
413     /**
414      * @dev Returns the owner of the `tokenId` token.
415      *
416      * Requirements:
417      *
418      * - `tokenId` must exist.
419      */
420     function ownerOf(uint256 tokenId) external view returns (address owner);
421 
422     /**
423      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
424      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must exist and be owned by `from`.
431      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
433      *
434      * Emits a {Transfer} event.
435      */
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external;
441 
442     /**
443      * @dev Transfers `tokenId` token from `from` to `to`.
444      *
445      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must be owned by `from`.
452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
453      *
454      * Emits a {Transfer} event.
455      */
456     function transferFrom(
457         address from,
458         address to,
459         uint256 tokenId
460     ) external;
461 
462     /**
463      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
464      * The approval is cleared when the token is transferred.
465      *
466      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
467      *
468      * Requirements:
469      *
470      * - The caller must own the token or be an approved operator.
471      * - `tokenId` must exist.
472      *
473      * Emits an {Approval} event.
474      */
475     function approve(address to, uint256 tokenId) external;
476 
477     /**
478      * @dev Returns the account approved for `tokenId` token.
479      *
480      * Requirements:
481      *
482      * - `tokenId` must exist.
483      */
484     function getApproved(uint256 tokenId) external view returns (address operator);
485 
486     /**
487      * @dev Approve or remove `operator` as an operator for the caller.
488      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
489      *
490      * Requirements:
491      *
492      * - The `operator` cannot be the caller.
493      *
494      * Emits an {ApprovalForAll} event.
495      */
496     function setApprovalForAll(address operator, bool _approved) external;
497 
498     /**
499      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
500      *
501      * See {setApprovalForAll}
502      */
503     function isApprovedForAll(address owner, address operator) external view returns (bool);
504 
505     /**
506      * @dev Safely transfers `tokenId` token from `from` to `to`.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must exist and be owned by `from`.
513      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
514      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
515      *
516      * Emits a {Transfer} event.
517      */
518     function safeTransferFrom(
519         address from,
520         address to,
521         uint256 tokenId,
522         bytes calldata data
523     ) external;
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 interface IERC721Enumerable is IERC721 {
539     /**
540      * @dev Returns the total amount of tokens stored by the contract.
541      */
542     function totalSupply() external view returns (uint256);
543 
544     /**
545      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
546      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
547      */
548     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
549 
550     /**
551      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
552      * Use along with {totalSupply} to enumerate all tokens.
553      */
554     function tokenByIndex(uint256 index) external view returns (uint256);
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 // File: @openzeppelin/contracts/utils/Context.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Provides information about the current execution context, including the
595  * sender of the transaction and its data. While these are generally available
596  * via msg.sender and msg.data, they should not be accessed in such a direct
597  * manner, since when dealing with meta-transactions the account sending and
598  * paying for execution may not be the actual sender (as far as an application
599  * is concerned).
600  *
601  * This contract is only required for intermediate, library-like contracts.
602  */
603 abstract contract Context {
604     function _msgSender() internal view virtual returns (address) {
605         return msg.sender;
606     }
607 
608     function _msgData() internal view virtual returns (bytes calldata) {
609         return msg.data;
610     }
611 }
612 
613 // File: tests/ERC721A.sol
614 
615 
616 // Creators: locationtba.eth, 2pmflow.eth
617 
618 pragma solidity ^0.8.0;
619 
620 
621 
622 
623 
624 
625 
626 
627 
628 /**
629  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
630  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
631  *
632  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
633  *
634  * Does not support burning tokens to address(0).
635  */
636 contract ERC721A is
637   Context,
638   ERC165,
639   IERC721,
640   IERC721Metadata,
641   IERC721Enumerable
642 {
643   using Address for address;
644   using Strings for uint256;
645 
646   struct TokenOwnership {
647     address addr;
648     uint64 startTimestamp;
649   }
650 
651   struct AddressData {
652     uint128 balance;
653     uint128 numberMinted;
654   }
655 
656   uint256 private currentIndex = 0;
657 
658   uint256 internal immutable maxBatchSize;
659 
660   // Token name
661   string private _name;
662 
663   // Token symbol
664   string private _symbol;
665 
666   // Mapping from token ID to ownership details
667   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
668   mapping(uint256 => TokenOwnership) private _ownerships;
669 
670   // Mapping owner address to address data
671   mapping(address => AddressData) private _addressData;
672 
673   // Mapping from token ID to approved address
674   mapping(uint256 => address) private _tokenApprovals;
675 
676   // Mapping from owner to operator approvals
677   mapping(address => mapping(address => bool)) private _operatorApprovals;
678 
679   /**
680    * @dev
681    * `maxBatchSize` refers to how much a minter can mint at a time.
682    */
683   constructor(
684     string memory name_,
685     string memory symbol_,
686     uint256 maxBatchSize_
687   ) {
688     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
689     _name = name_;
690     _symbol = symbol_;
691     maxBatchSize = maxBatchSize_;
692   }
693 
694   /**
695    * @dev See {IERC721Enumerable-totalSupply}.
696    */
697   function totalSupply() public view override returns (uint256) {
698     return currentIndex;
699   }
700 
701   /**
702    * @dev See {IERC721Enumerable-tokenByIndex}.
703    */
704   function tokenByIndex(uint256 index) public view override returns (uint256) {
705     require(index < totalSupply(), "ERC721A: global index out of bounds");
706     return index;
707   }
708 
709   /**
710    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
711    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
712    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
713    */
714   function tokenOfOwnerByIndex(address owner, uint256 index)
715     public
716     view
717     override
718     returns (uint256)
719   {
720     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
721     uint256 numMintedSoFar = totalSupply();
722     uint256 tokenIdsIdx = 0;
723     address currOwnershipAddr = address(0);
724     for (uint256 i = 0; i < numMintedSoFar; i++) {
725       TokenOwnership memory ownership = _ownerships[i];
726       if (ownership.addr != address(0)) {
727         currOwnershipAddr = ownership.addr;
728       }
729       if (currOwnershipAddr == owner) {
730         if (tokenIdsIdx == index) {
731           return i;
732         }
733         tokenIdsIdx++;
734       }
735     }
736     revert("ERC721A: unable to get token of owner by index");
737   }
738 
739   /**
740    * @dev See {IERC165-supportsInterface}.
741    */
742   function supportsInterface(bytes4 interfaceId)
743     public
744     view
745     virtual
746     override(ERC165, IERC165)
747     returns (bool)
748   {
749     return
750       interfaceId == type(IERC721).interfaceId ||
751       interfaceId == type(IERC721Metadata).interfaceId ||
752       interfaceId == type(IERC721Enumerable).interfaceId ||
753       super.supportsInterface(interfaceId);
754   }
755 
756   /**
757    * @dev See {IERC721-balanceOf}.
758    */
759   function balanceOf(address owner) public view override returns (uint256) {
760     require(owner != address(0), "ERC721A: balance query for the zero address");
761     return uint256(_addressData[owner].balance);
762   }
763 
764   function _numberMinted(address owner) internal view returns (uint256) {
765     require(
766       owner != address(0),
767       "ERC721A: number minted query for the zero address"
768     );
769     return uint256(_addressData[owner].numberMinted);
770   }
771 
772   function ownershipOf(uint256 tokenId)
773     internal
774     view
775     returns (TokenOwnership memory)
776   {
777     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
778 
779     uint256 lowestTokenToCheck;
780     if (tokenId >= maxBatchSize) {
781       lowestTokenToCheck = tokenId - maxBatchSize + 1;
782     }
783 
784     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
785       TokenOwnership memory ownership = _ownerships[curr];
786       if (ownership.addr != address(0)) {
787         return ownership;
788       }
789     }
790 
791     revert("ERC721A: unable to determine the owner of token");
792   }
793 
794   /**
795    * @dev See {IERC721-ownerOf}.
796    */
797   function ownerOf(uint256 tokenId) public view override returns (address) {
798     return ownershipOf(tokenId).addr;
799   }
800 
801   /**
802    * @dev See {IERC721Metadata-name}.
803    */
804   function name() public view virtual override returns (string memory) {
805     return _name;
806   }
807 
808   /**
809    * @dev See {IERC721Metadata-symbol}.
810    */
811   function symbol() public view virtual override returns (string memory) {
812     return _symbol;
813   }
814 
815   /**
816    * @dev See {IERC721Metadata-tokenURI}.
817    */
818   function tokenURI(uint256 tokenId)
819     public
820     view
821     virtual
822     override
823     returns (string memory)
824   {
825     require(
826       _exists(tokenId),
827       "ERC721Metadata: URI query for nonexistent token"
828     );
829 
830     string memory baseURI = _baseURI();
831     return
832       bytes(baseURI).length > 0
833         ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
834         : "";
835   }
836 
837   /**
838    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
839    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
840    * by default, can be overriden in child contracts.
841    */
842   function _baseURI() internal view virtual returns (string memory) {
843     return "";
844   }
845 
846   /**
847    * @dev See {IERC721-approve}.
848    */
849   function approve(address to, uint256 tokenId) public override {
850     address owner = ERC721A.ownerOf(tokenId);
851     require(to != owner, "ERC721A: approval to current owner");
852 
853     require(
854       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
855       "ERC721A: approve caller is not owner nor approved for all"
856     );
857 
858     _approve(to, tokenId, owner);
859   }
860 
861   /**
862    * @dev See {IERC721-getApproved}.
863    */
864   function getApproved(uint256 tokenId) public view override returns (address) {
865     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
866 
867     return _tokenApprovals[tokenId];
868   }
869 
870   /**
871    * @dev See {IERC721-setApprovalForAll}.
872    */
873   function setApprovalForAll(address operator, bool approved) public override {
874     require(operator != _msgSender(), "ERC721A: approve to caller");
875 
876     _operatorApprovals[_msgSender()][operator] = approved;
877     emit ApprovalForAll(_msgSender(), operator, approved);
878   }
879 
880   /**
881    * @dev See {IERC721-isApprovedForAll}.
882    */
883   function isApprovedForAll(address owner, address operator)
884     public
885     view
886     virtual
887     override
888     returns (bool)
889   {
890     return _operatorApprovals[owner][operator];
891   }
892 
893   /**
894    * @dev See {IERC721-transferFrom}.
895    */
896   function transferFrom(
897     address from,
898     address to,
899     uint256 tokenId
900   ) public override {
901     _transfer(from, to, tokenId);
902   }
903 
904   /**
905    * @dev See {IERC721-safeTransferFrom}.
906    */
907   function safeTransferFrom(
908     address from,
909     address to,
910     uint256 tokenId
911   ) public override {
912     safeTransferFrom(from, to, tokenId, "");
913   }
914 
915   /**
916    * @dev See {IERC721-safeTransferFrom}.
917    */
918   function safeTransferFrom(
919     address from,
920     address to,
921     uint256 tokenId,
922     bytes memory _data
923   ) public override {
924     _transfer(from, to, tokenId);
925     require(
926       _checkOnERC721Received(from, to, tokenId, _data),
927       "ERC721A: transfer to non ERC721Receiver implementer"
928     );
929   }
930 
931   /**
932    * @dev Returns whether `tokenId` exists.
933    *
934    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
935    *
936    * Tokens start existing when they are minted (`_mint`),
937    */
938   function _exists(uint256 tokenId) internal view returns (bool) {
939     return tokenId < currentIndex;
940   }
941 
942   function _safeMint(address to, uint256 quantity) internal {
943     _safeMint(to, quantity, "");
944   }
945 
946   /**
947    * @dev Mints `quantity` tokens and transfers them to `to`.
948    *
949    * Requirements:
950    *
951    * - `to` cannot be the zero address.
952    * - `quantity` cannot be larger than the max batch size.
953    *
954    * Emits a {Transfer} event.
955    */
956   function _safeMint(
957     address to,
958     uint256 quantity,
959     bytes memory _data
960   ) internal {
961     uint256 startTokenId = currentIndex;
962     require(to != address(0), "ERC721A: mint to the zero address");
963     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
964     require(!_exists(startTokenId), "ERC721A: token already minted");
965     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
966 
967     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
968 
969     AddressData memory addressData = _addressData[to];
970     _addressData[to] = AddressData(
971       addressData.balance + uint128(quantity),
972       addressData.numberMinted + uint128(quantity)
973     );
974     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
975 
976     uint256 updatedIndex = startTokenId;
977 
978     for (uint256 i = 0; i < quantity; i++) {
979       emit Transfer(address(0), to, updatedIndex);
980       require(
981         _checkOnERC721Received(address(0), to, updatedIndex, _data),
982         "ERC721A: transfer to non ERC721Receiver implementer"
983       );
984       updatedIndex++;
985     }
986 
987     currentIndex = updatedIndex;
988     _afterTokenTransfers(address(0), to, startTokenId, quantity);
989   }
990 
991   /**
992    * @dev Transfers `tokenId` from `from` to `to`.
993    *
994    * Requirements:
995    *
996    * - `to` cannot be the zero address.
997    * - `tokenId` token must be owned by `from`.
998    *
999    * Emits a {Transfer} event.
1000    */
1001   function _transfer(
1002     address from,
1003     address to,
1004     uint256 tokenId
1005   ) private {
1006     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1007 
1008     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1009       getApproved(tokenId) == _msgSender() ||
1010       isApprovedForAll(prevOwnership.addr, _msgSender()));
1011 
1012     require(
1013       isApprovedOrOwner,
1014       "ERC721A: transfer caller is not owner nor approved"
1015     );
1016 
1017     require(
1018       prevOwnership.addr == from,
1019       "ERC721A: transfer from incorrect owner"
1020     );
1021     require(to != address(0), "ERC721A: transfer to the zero address");
1022 
1023     _beforeTokenTransfers(from, to, tokenId, 1);
1024 
1025     // Clear approvals from the previous owner
1026     _approve(address(0), tokenId, prevOwnership.addr);
1027 
1028     _addressData[from].balance -= 1;
1029     _addressData[to].balance += 1;
1030     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1031 
1032     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1033     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1034     uint256 nextTokenId = tokenId + 1;
1035     if (_ownerships[nextTokenId].addr == address(0)) {
1036       if (_exists(nextTokenId)) {
1037         _ownerships[nextTokenId] = TokenOwnership(
1038           prevOwnership.addr,
1039           prevOwnership.startTimestamp
1040         );
1041       }
1042     }
1043 
1044     emit Transfer(from, to, tokenId);
1045     _afterTokenTransfers(from, to, tokenId, 1);
1046   }
1047 
1048   /**
1049    * @dev Approve `to` to operate on `tokenId`
1050    *
1051    * Emits a {Approval} event.
1052    */
1053   function _approve(
1054     address to,
1055     uint256 tokenId,
1056     address owner
1057   ) private {
1058     _tokenApprovals[tokenId] = to;
1059     emit Approval(owner, to, tokenId);
1060   }
1061 
1062   uint256 public nextOwnerToExplicitlySet = 0;
1063 
1064   /**
1065    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1066    */
1067   function _setOwnersExplicit(uint256 quantity) internal {
1068     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1069     require(quantity > 0, "quantity must be nonzero");
1070     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1071     if (endIndex > currentIndex - 1) {
1072       endIndex = currentIndex - 1;
1073     }
1074     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1075     require(_exists(endIndex), "not enough minted yet for this cleanup");
1076     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1077       if (_ownerships[i].addr == address(0)) {
1078         TokenOwnership memory ownership = ownershipOf(i);
1079         _ownerships[i] = TokenOwnership(
1080           ownership.addr,
1081           ownership.startTimestamp
1082         );
1083       }
1084     }
1085     nextOwnerToExplicitlySet = endIndex + 1;
1086   }
1087 
1088   /**
1089    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1090    * The call is not executed if the target address is not a contract.
1091    *
1092    * @param from address representing the previous owner of the given token ID
1093    * @param to target address that will receive the tokens
1094    * @param tokenId uint256 ID of the token to be transferred
1095    * @param _data bytes optional data to send along with the call
1096    * @return bool whether the call correctly returned the expected magic value
1097    */
1098   function _checkOnERC721Received(
1099     address from,
1100     address to,
1101     uint256 tokenId,
1102     bytes memory _data
1103   ) private returns (bool) {
1104     if (to.isContract()) {
1105       try
1106         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1107       returns (bytes4 retval) {
1108         return retval == IERC721Receiver(to).onERC721Received.selector;
1109       } catch (bytes memory reason) {
1110         if (reason.length == 0) {
1111           revert("ERC721A: transfer to non ERC721Receiver implementer");
1112         } else {
1113           assembly {
1114             revert(add(32, reason), mload(reason))
1115           }
1116         }
1117       }
1118     } else {
1119       return true;
1120     }
1121   }
1122 
1123   /**
1124    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1125    *
1126    * startTokenId - the first token id to be transferred
1127    * quantity - the amount to be transferred
1128    *
1129    * Calling conditions:
1130    *
1131    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132    * transferred to `to`.
1133    * - When `from` is zero, `tokenId` will be minted for `to`.
1134    */
1135   function _beforeTokenTransfers(
1136     address from,
1137     address to,
1138     uint256 startTokenId,
1139     uint256 quantity
1140   ) internal virtual {}
1141 
1142   /**
1143    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1144    * minting.
1145    *
1146    * startTokenId - the first token id to be transferred
1147    * quantity - the amount to be transferred
1148    *
1149    * Calling conditions:
1150    *
1151    * - when `from` and `to` are both non-zero.
1152    * - `from` and `to` are never both zero.
1153    */
1154   function _afterTokenTransfers(
1155     address from,
1156     address to,
1157     uint256 startTokenId,
1158     uint256 quantity
1159   ) internal virtual {}
1160 }
1161 // File: @openzeppelin/contracts/access/Ownable.sol
1162 
1163 
1164 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1165 
1166 pragma solidity ^0.8.0;
1167 
1168 
1169 /**
1170  * @dev Contract module which provides a basic access control mechanism, where
1171  * there is an account (an owner) that can be granted exclusive access to
1172  * specific functions.
1173  *
1174  * By default, the owner account will be the one that deploys the contract. This
1175  * can later be changed with {transferOwnership}.
1176  *
1177  * This module is used through inheritance. It will make available the modifier
1178  * `onlyOwner`, which can be applied to your functions to restrict their use to
1179  * the owner.
1180  */
1181 abstract contract Ownable is Context {
1182     address private _owner;
1183 
1184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1185 
1186     /**
1187      * @dev Initializes the contract setting the deployer as the initial owner.
1188      */
1189     constructor() {
1190         _transferOwnership(_msgSender());
1191     }
1192 
1193     /**
1194      * @dev Returns the address of the current owner.
1195      */
1196     function owner() public view virtual returns (address) {
1197         return _owner;
1198     }
1199 
1200     /**
1201      * @dev Throws if called by any account other than the owner.
1202      */
1203     modifier onlyOwner() {
1204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1205         _;
1206     }
1207 
1208     /**
1209      * @dev Leaves the contract without owner. It will not be possible to call
1210      * `onlyOwner` functions anymore. Can only be called by the current owner.
1211      *
1212      * NOTE: Renouncing ownership will leave the contract without an owner,
1213      * thereby removing any functionality that is only available to the owner.
1214      */
1215     function renounceOwnership() public virtual onlyOwner {
1216         _transferOwnership(address(0));
1217     }
1218 
1219     /**
1220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1221      * Can only be called by the current owner.
1222      */
1223     function transferOwnership(address newOwner) public virtual onlyOwner {
1224         require(newOwner != address(0), "Ownable: new owner is the zero address");
1225         _transferOwnership(newOwner);
1226     }
1227 
1228     /**
1229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1230      * Internal function without access restriction.
1231      */
1232     function _transferOwnership(address newOwner) internal virtual {
1233         address oldOwner = _owner;
1234         _owner = newOwner;
1235         emit OwnershipTransferred(oldOwner, newOwner);
1236     }
1237 }
1238 
1239 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1240 
1241 
1242 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 /**
1247  * @dev Contract module that helps prevent reentrant calls to a function.
1248  *
1249  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1250  * available, which can be applied to functions to make sure there are no nested
1251  * (reentrant) calls to them.
1252  *
1253  * Note that because there is a single `nonReentrant` guard, functions marked as
1254  * `nonReentrant` may not call one another. This can be worked around by making
1255  * those functions `private`, and then adding `external` `nonReentrant` entry
1256  * points to them.
1257  *
1258  * TIP: If you would like to learn more about reentrancy and alternative ways
1259  * to protect against it, check out our blog post
1260  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1261  */
1262 abstract contract ReentrancyGuard {
1263     // Booleans are more expensive than uint256 or any type that takes up a full
1264     // word because each write operation emits an extra SLOAD to first read the
1265     // slot's contents, replace the bits taken up by the boolean, and then write
1266     // back. This is the compiler's defense against contract upgrades and
1267     // pointer aliasing, and it cannot be disabled.
1268 
1269     // The values being non-zero value makes deployment a bit more expensive,
1270     // but in exchange the refund on every call to nonReentrant will be lower in
1271     // amount. Since refunds are capped to a percentage of the total
1272     // transaction's gas, it is best to keep them low in cases like this one, to
1273     // increase the likelihood of the full refund coming into effect.
1274     uint256 private constant _NOT_ENTERED = 1;
1275     uint256 private constant _ENTERED = 2;
1276 
1277     uint256 private _status;
1278 
1279     constructor() {
1280         _status = _NOT_ENTERED;
1281     }
1282 
1283     /**
1284      * @dev Prevents a contract from calling itself, directly or indirectly.
1285      * Calling a `nonReentrant` function from another `nonReentrant`
1286      * function is not supported. It is possible to prevent this from happening
1287      * by making the `nonReentrant` function external, and making it call a
1288      * `private` function that does the actual work.
1289      */
1290     modifier nonReentrant() {
1291         // On the first call to nonReentrant, _notEntered will be true
1292         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1293 
1294         // Any calls to nonReentrant after this point will fail
1295         _status = _ENTERED;
1296 
1297         _;
1298 
1299         // By storing the original value once again, a refund is triggered (see
1300         // https://eips.ethereum.org/EIPS/eip-2200)
1301         _status = _NOT_ENTERED;
1302     }
1303 }
1304 
1305 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1306 
1307 pragma solidity ^0.8.0;
1308 
1309 /**
1310  * @dev These functions deal with verification of Merkle Trees proofs.
1311  *
1312  * The proofs can be generated using the JavaScript library
1313  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1314  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1315  *
1316  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1317  *
1318  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1319  * hashing, or use a hash function other than keccak256 for hashing leaves.
1320  * This is because the concatenation of a sorted pair of internal nodes in
1321  * the merkle tree could be reinterpreted as a leaf value.
1322  */
1323 library MerkleProof {
1324     /**
1325      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1326      * defined by `root`. For this, a `proof` must be provided, containing
1327      * sibling hashes on the branch from the leaf to the root of the tree. Each
1328      * pair of leaves and each pair of pre-images are assumed to be sorted.
1329      */
1330     function verify(
1331         bytes32[] memory proof,
1332         bytes32 root,
1333         bytes32 leaf
1334     ) internal pure returns (bool) {
1335         return processProof(proof, leaf) == root;
1336     }
1337 
1338     /**
1339      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1340      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1341      * hash matches the root of the tree. When processing the proof, the pairs
1342      * of leafs & pre-images are assumed to be sorted.
1343      *
1344      * _Available since v4.4._
1345      */
1346     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1347         bytes32 computedHash = leaf;
1348         for (uint256 i = 0; i < proof.length; i++) {
1349             bytes32 proofElement = proof[i];
1350             if (computedHash <= proofElement) {
1351                 // Hash(current computed hash + current element of the proof)
1352                 computedHash = _efficientHash(computedHash, proofElement);
1353             } else {
1354                 // Hash(current element of the proof + current computed hash)
1355                 computedHash = _efficientHash(proofElement, computedHash);
1356             }
1357         }
1358         return computedHash;
1359     }
1360 
1361     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1362         assembly {
1363             mstore(0x00, a)
1364             mstore(0x20, b)
1365             value := keccak256(0x00, 0x40)
1366         }
1367     }
1368 }
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 
1373 
1374 contract NorfFC is Ownable, ERC721A, ReentrancyGuard {
1375 
1376     
1377     
1378     
1379     uint256 constant MAX_ELEMENTS = 1966;    
1380     uint256 constant MAX_ELEMENT_PER_USER = 2;
1381     uint256 constant MAX_ELEMENTS_ONE_TIME = 2;
1382     
1383 
1384     // state variable
1385     bool public MINTING_PAUSED = true;
1386     string public baseTokenURI;
1387     string public _contractURI = "";
1388     mapping(address => uint256) private freeMemberList;
1389 
1390     constructor(uint256 maxBatchSize_) ERC721A("NorfFc", "NORFFC", maxBatchSize_) {}
1391 
1392     function setPauseMinting(bool _pause) public onlyOwner {
1393         MINTING_PAUSED = _pause;
1394     }
1395 
1396     function getMintCount(address _addr) public view returns (uint256) {
1397         return freeMemberList[_addr];
1398     }
1399 
1400     function freeMint(uint256 numberOfTokens) external payable {
1401         require(!MINTING_PAUSED, "Minting is not active");
1402         
1403         require(totalSupply() < MAX_ELEMENTS, 'All tokens have been minted');      
1404         require(freeMemberList[msg.sender] + numberOfTokens <= MAX_ELEMENT_PER_USER, 'Your free purchase would exceed max(2) supply');
1405         require(numberOfTokens <= MAX_ELEMENTS_ONE_TIME,"Purchase at a time exceeds max allowed");
1406         _safeMint(msg.sender, numberOfTokens);
1407         freeMemberList[msg.sender] += numberOfTokens;
1408     }
1409 
1410    
1411 
1412     function withdraw() external onlyOwner {
1413         uint256 balance = address(this).balance;
1414 
1415         payable(msg.sender).transfer(balance);
1416     }
1417 
1418     function _baseURI() internal view virtual override returns (string memory) {
1419         return baseTokenURI;
1420     }
1421 
1422     function setBaseURI(string calldata baseURI) public onlyOwner {
1423         baseTokenURI = baseURI;
1424     }
1425 
1426     function setContractURI(string calldata URI) external onlyOwner {
1427         _contractURI = URI;
1428     }
1429 
1430     function contractURI() public view returns (string memory) {
1431         return _contractURI;
1432     }
1433 }