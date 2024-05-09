1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Address.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Collection of functions related to the address type
78  */
79 library Address {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * [IMPORTANT]
84      * ====
85      * It is unsafe to assume that an address for which this function returns
86      * false is an externally-owned account (EOA) and not a contract.
87      *
88      * Among others, `isContract` will return false for the following
89      * types of addresses:
90      *
91      *  - an externally-owned account
92      *  - a contract in construction
93      *  - an address where a contract will be created
94      *  - an address where a contract lived, but was destroyed
95      * ====
96      */
97     function isContract(address account) internal view returns (bool) {
98         // This method relies on extcodesize, which returns 0 for contracts in
99         // construction, since the code is only stored at the end of the
100         // constructor execution.
101 
102         uint256 size;
103         assembly {
104             size := extcodesize(account)
105         }
106         return size > 0;
107     }
108 
109     /**
110      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
111      * `recipient`, forwarding all available gas and reverting on errors.
112      *
113      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
114      * of certain opcodes, possibly making contracts go over the 2300 gas limit
115      * imposed by `transfer`, making them unable to receive funds via
116      * `transfer`. {sendValue} removes this limitation.
117      *
118      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
119      *
120      * IMPORTANT: because control is transferred to `recipient`, care must be
121      * taken to not create reentrancy vulnerabilities. Consider using
122      * {ReentrancyGuard} or the
123      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
124      */
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(address(this).balance >= amount, "Address: insufficient balance");
127 
128         (bool success, ) = recipient.call{value: amount}("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 
132     /**
133      * @dev Performs a Solidity function call using a low level `call`. A
134      * plain `call` is an unsafe replacement for a function call: use this
135      * function instead.
136      *
137      * If `target` reverts with a revert reason, it is bubbled up by this
138      * function (like regular Solidity function calls).
139      *
140      * Returns the raw returned data. To convert to the expected return value,
141      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
142      *
143      * Requirements:
144      *
145      * - `target` must be a contract.
146      * - calling `target` with `data` must not revert.
147      *
148      * _Available since v3.1._
149      */
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionCall(target, data, "Address: low-level call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
156      * `errorMessage` as a fallback revert reason when `target` reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, 0, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but also transferring `value` wei to `target`.
171      *
172      * Requirements:
173      *
174      * - the calling contract must have an ETH balance of at least `value`.
175      * - the called Solidity function must be `payable`.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
189      * with `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.call{value: value}(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a static call.
209      *
210      * _Available since v3.3._
211      */
212     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
213         return functionStaticCall(target, data, "Address: low-level static call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal view returns (bytes memory) {
227         require(isContract(target), "Address: static call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.staticcall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a delegate call.
236      *
237      * _Available since v3.4._
238      */
239     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         require(isContract(target), "Address: delegate call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.delegatecall(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
262      * revert reason using the provided one.
263      *
264      * _Available since v4.3._
265      */
266     function verifyCallResult(
267         bool success,
268         bytes memory returndata,
269         string memory errorMessage
270     ) internal pure returns (bytes memory) {
271         if (success) {
272             return returndata;
273         } else {
274             // Look for revert reason and bubble it up if present
275             if (returndata.length > 0) {
276                 // The easiest way to bubble the revert reason is using memory via assembly
277 
278                 assembly {
279                     let returndata_size := mload(returndata)
280                     revert(add(32, returndata), returndata_size)
281                 }
282             } else {
283                 revert(errorMessage);
284             }
285         }
286     }
287 }
288 
289 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
290 
291 
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
319 
320 
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev Interface of the ERC165 standard, as defined in the
326  * https://eips.ethereum.org/EIPS/eip-165[EIP].
327  *
328  * Implementers can declare support of contract interfaces, which can then be
329  * queried by others ({ERC165Checker}).
330  *
331  * For an implementation, see {ERC165}.
332  */
333 interface IERC165 {
334     /**
335      * @dev Returns true if this contract implements the interface defined by
336      * `interfaceId`. See the corresponding
337      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
338      * to learn more about how these ids are created.
339      *
340      * This function call must use less than 30 000 gas.
341      */
342     function supportsInterface(bytes4 interfaceId) external view returns (bool);
343 }
344 
345 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
346 
347 
348 
349 pragma solidity ^0.8.0;
350 
351 
352 /**
353  * @dev Implementation of the {IERC165} interface.
354  *
355  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
356  * for the additional interface id that will be supported. For example:
357  *
358  * ```solidity
359  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
360  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
361  * }
362  * ```
363  *
364  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
365  */
366 abstract contract ERC165 is IERC165 {
367     /**
368      * @dev See {IERC165-supportsInterface}.
369      */
370     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371         return interfaceId == type(IERC165).interfaceId;
372     }
373 }
374 
375 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
376 
377 
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Required interface of an ERC721 compliant contract.
384  */
385 interface IERC721 is IERC165 {
386     /**
387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
393      */
394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
398      */
399     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
400 
401     /**
402      * @dev Returns the number of tokens in ``owner``'s account.
403      */
404     function balanceOf(address owner) external view returns (uint256 balance);
405 
406     /**
407      * @dev Returns the owner of the `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function ownerOf(uint256 tokenId) external view returns (address owner);
414 
415     /**
416      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
417      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId
433     ) external;
434 
435     /**
436      * @dev Transfers `tokenId` token from `from` to `to`.
437      *
438      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
457      * The approval is cleared when the token is transferred.
458      *
459      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
460      *
461      * Requirements:
462      *
463      * - The caller must own the token or be an approved operator.
464      * - `tokenId` must exist.
465      *
466      * Emits an {Approval} event.
467      */
468     function approve(address to, uint256 tokenId) external;
469 
470     /**
471      * @dev Returns the account approved for `tokenId` token.
472      *
473      * Requirements:
474      *
475      * - `tokenId` must exist.
476      */
477     function getApproved(uint256 tokenId) external view returns (address operator);
478 
479     /**
480      * @dev Approve or remove `operator` as an operator for the caller.
481      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
482      *
483      * Requirements:
484      *
485      * - The `operator` cannot be the caller.
486      *
487      * Emits an {ApprovalForAll} event.
488      */
489     function setApprovalForAll(address operator, bool _approved) external;
490 
491     /**
492      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
493      *
494      * See {setApprovalForAll}
495      */
496     function isApprovedForAll(address owner, address operator) external view returns (bool);
497 
498     /**
499      * @dev Safely transfers `tokenId` token from `from` to `to`.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId,
515         bytes calldata data
516     ) external;
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
528  * @dev See https://eips.ethereum.org/EIPS/eip-721
529  */
530 interface IERC721Enumerable is IERC721 {
531     /**
532      * @dev Returns the total amount of tokens stored by the contract.
533      */
534     function totalSupply() external view returns (uint256);
535 
536     /**
537      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
538      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
539      */
540     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
541 
542     /**
543      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
544      * Use along with {totalSupply} to enumerate all tokens.
545      */
546     function tokenByIndex(uint256 index) external view returns (uint256);
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
550 
551 
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
558  * @dev See https://eips.ethereum.org/EIPS/eip-721
559  */
560 interface IERC721Metadata is IERC721 {
561     /**
562      * @dev Returns the token collection name.
563      */
564     function name() external view returns (string memory);
565 
566     /**
567      * @dev Returns the token collection symbol.
568      */
569     function symbol() external view returns (string memory);
570 
571     /**
572      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
573      */
574     function tokenURI(uint256 tokenId) external view returns (string memory);
575 }
576 
577 // File: @openzeppelin/contracts/utils/Context.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Provides information about the current execution context, including the
585  * sender of the transaction and its data. While these are generally available
586  * via msg.sender and msg.data, they should not be accessed in such a direct
587  * manner, since when dealing with meta-transactions the account sending and
588  * paying for execution may not be the actual sender (as far as an application
589  * is concerned).
590  *
591  * This contract is only required for intermediate, library-like contracts.
592  */
593 abstract contract Context {
594     function _msgSender() internal view virtual returns (address) {
595         return msg.sender;
596     }
597 
598     function _msgData() internal view virtual returns (bytes calldata) {
599         return msg.data;
600     }
601 }
602 
603 // File: contracts/ERC721A.sol
604 
605 
606 // Creators: locationtba.eth, 2pmflow.eth
607 
608 pragma solidity ^0.8.0;
609 
610 
611 
612 
613 
614 
615 
616 
617 
618 /**
619  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
620  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
621  *
622  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
623  *
624  * Does not support burning tokens to address(0).
625  */
626 contract ERC721A is
627   Context,
628   ERC165,
629   IERC721,
630   IERC721Metadata,
631   IERC721Enumerable
632 {
633   using Address for address;
634   using Strings for uint256;
635 
636   struct TokenOwnership {
637     address addr;
638     uint64 startTimestamp;
639   }
640 
641   struct AddressData {
642     uint128 balance;
643     uint128 numberMinted;
644   }
645 
646   uint256 private currentIndex = 0;
647 
648   uint256 internal immutable maxBatchSize;
649 
650   // Token name
651   string private _name;
652 
653   // Token symbol
654   string private _symbol;
655 
656   // Mapping from token ID to ownership details
657   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
658   mapping(uint256 => TokenOwnership) private _ownerships;
659 
660   // Mapping owner address to address data
661   mapping(address => AddressData) private _addressData;
662 
663   // Mapping from token ID to approved address
664   mapping(uint256 => address) private _tokenApprovals;
665 
666   // Mapping from owner to operator approvals
667   mapping(address => mapping(address => bool)) private _operatorApprovals;
668 
669   /**
670    * @dev
671    * `maxBatchSize` refers to how much a minter can mint at a time.
672    */
673   constructor(
674     string memory name_,
675     string memory symbol_,
676     uint256 maxBatchSize_
677   ) {
678     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
679     _name = name_;
680     _symbol = symbol_;
681     maxBatchSize = maxBatchSize_;
682   }
683 
684   /**
685    * @dev See {IERC721Enumerable-totalSupply}.
686    */
687   function totalSupply() public view override returns (uint256) {
688     return currentIndex;
689   }
690 
691   /**
692    * @dev See {IERC721Enumerable-tokenByIndex}.
693    */
694   function tokenByIndex(uint256 index) public view override returns (uint256) {
695     require(index < totalSupply(), "ERC721A: global index out of bounds");
696     return index;
697   }
698 
699   /**
700    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
701    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
702    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
703    */
704   function tokenOfOwnerByIndex(address owner, uint256 index)
705     public
706     view
707     override
708     returns (uint256)
709   {
710     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
711     uint256 numMintedSoFar = totalSupply();
712     uint256 tokenIdsIdx = 0;
713     address currOwnershipAddr = address(0);
714     for (uint256 i = 0; i < numMintedSoFar; i++) {
715       TokenOwnership memory ownership = _ownerships[i];
716       if (ownership.addr != address(0)) {
717         currOwnershipAddr = ownership.addr;
718       }
719       if (currOwnershipAddr == owner) {
720         if (tokenIdsIdx == index) {
721           return i;
722         }
723         tokenIdsIdx++;
724       }
725     }
726     revert("ERC721A: unable to get token of owner by index");
727   }
728 
729   /**
730    * @dev See {IERC165-supportsInterface}.
731    */
732   function supportsInterface(bytes4 interfaceId)
733     public
734     view
735     virtual
736     override(ERC165, IERC165)
737     returns (bool)
738   {
739     return
740       interfaceId == type(IERC721).interfaceId ||
741       interfaceId == type(IERC721Metadata).interfaceId ||
742       interfaceId == type(IERC721Enumerable).interfaceId ||
743       super.supportsInterface(interfaceId);
744   }
745 
746   /**
747    * @dev See {IERC721-balanceOf}.
748    */
749   function balanceOf(address owner) public view override returns (uint256) {
750     require(owner != address(0), "ERC721A: balance query for the zero address");
751     return uint256(_addressData[owner].balance);
752   }
753 
754   function _numberMinted(address owner) internal view returns (uint256) {
755     require(
756       owner != address(0),
757       "ERC721A: number minted query for the zero address"
758     );
759     return uint256(_addressData[owner].numberMinted);
760   }
761 
762   function ownershipOf(uint256 tokenId)
763     internal
764     view
765     returns (TokenOwnership memory)
766   {
767     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
768 
769     uint256 lowestTokenToCheck;
770     if (tokenId >= maxBatchSize) {
771       lowestTokenToCheck = tokenId - maxBatchSize + 1;
772     }
773 
774     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
775       TokenOwnership memory ownership = _ownerships[curr];
776       if (ownership.addr != address(0)) {
777         return ownership;
778       }
779     }
780 
781     revert("ERC721A: unable to determine the owner of token");
782   }
783 
784   /**
785    * @dev See {IERC721-ownerOf}.
786    */
787   function ownerOf(uint256 tokenId) public view override returns (address) {
788     return ownershipOf(tokenId).addr;
789   }
790 
791   /**
792    * @dev See {IERC721Metadata-name}.
793    */
794   function name() public view virtual override returns (string memory) {
795     return _name;
796   }
797 
798   /**
799    * @dev See {IERC721Metadata-symbol}.
800    */
801   function symbol() public view virtual override returns (string memory) {
802     return _symbol;
803   }
804 
805   /**
806    * @dev See {IERC721Metadata-tokenURI}.
807    */
808   function tokenURI(uint256 tokenId)
809     public
810     view
811     virtual
812     override
813     returns (string memory)
814   {
815     require(
816       _exists(tokenId),
817       "ERC721Metadata: URI query for nonexistent token"
818     );
819 
820     string memory baseURI = _baseURI();
821     return
822       bytes(baseURI).length > 0
823         ? string(abi.encodePacked(baseURI, tokenId.toString()))
824         : "";
825   }
826 
827   /**
828    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
829    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
830    * by default, can be overriden in child contracts.
831    */
832   function _baseURI() internal view virtual returns (string memory) {
833     return "";
834   }
835 
836   /**
837    * @dev See {IERC721-approve}.
838    */
839   function approve(address to, uint256 tokenId) public override {
840     address owner = ERC721A.ownerOf(tokenId);
841     require(to != owner, "ERC721A: approval to current owner");
842 
843     require(
844       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
845       "ERC721A: approve caller is not owner nor approved for all"
846     );
847 
848     _approve(to, tokenId, owner);
849   }
850 
851   /**
852    * @dev See {IERC721-getApproved}.
853    */
854   function getApproved(uint256 tokenId) public view override returns (address) {
855     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
856 
857     return _tokenApprovals[tokenId];
858   }
859 
860   /**
861    * @dev See {IERC721-setApprovalForAll}.
862    */
863   function setApprovalForAll(address operator, bool approved) public override {
864     require(operator != _msgSender(), "ERC721A: approve to caller");
865 
866     _operatorApprovals[_msgSender()][operator] = approved;
867     emit ApprovalForAll(_msgSender(), operator, approved);
868   }
869 
870   /**
871    * @dev See {IERC721-isApprovedForAll}.
872    */
873   function isApprovedForAll(address owner, address operator)
874     public
875     view
876     virtual
877     override
878     returns (bool)
879   {
880     return _operatorApprovals[owner][operator];
881   }
882 
883   /**
884    * @dev See {IERC721-transferFrom}.
885    */
886   function transferFrom(
887     address from,
888     address to,
889     uint256 tokenId
890   ) public override {
891     _transfer(from, to, tokenId);
892   }
893 
894   /**
895    * @dev See {IERC721-safeTransferFrom}.
896    */
897   function safeTransferFrom(
898     address from,
899     address to,
900     uint256 tokenId
901   ) public override {
902     safeTransferFrom(from, to, tokenId, "");
903   }
904 
905   /**
906    * @dev See {IERC721-safeTransferFrom}.
907    */
908   function safeTransferFrom(
909     address from,
910     address to,
911     uint256 tokenId,
912     bytes memory _data
913   ) public override {
914     _transfer(from, to, tokenId);
915     require(
916       _checkOnERC721Received(from, to, tokenId, _data),
917       "ERC721A: transfer to non ERC721Receiver implementer"
918     );
919   }
920 
921   /**
922    * @dev Returns whether `tokenId` exists.
923    *
924    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
925    *
926    * Tokens start existing when they are minted (`_mint`),
927    */
928   function _exists(uint256 tokenId) internal view returns (bool) {
929     return tokenId < currentIndex;
930   }
931 
932   function _safeMint(address to, uint256 quantity) internal {
933     _safeMint(to, quantity, "");
934   }
935 
936   /**
937    * @dev Mints `quantity` tokens and transfers them to `to`.
938    *
939    * Requirements:
940    *
941    * - `to` cannot be the zero address.
942    * - `quantity` cannot be larger than the max batch size.
943    *
944    * Emits a {Transfer} event.
945    */
946   function _safeMint(
947     address to,
948     uint256 quantity,
949     bytes memory _data
950   ) internal {
951     uint256 startTokenId = currentIndex;
952     require(to != address(0), "ERC721A: mint to the zero address");
953     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
954     require(!_exists(startTokenId), "ERC721A: token already minted");
955     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
956 
957     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
958 
959     AddressData memory addressData = _addressData[to];
960     _addressData[to] = AddressData(
961       addressData.balance + uint128(quantity),
962       addressData.numberMinted + uint128(quantity)
963     );
964     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
965 
966     uint256 updatedIndex = startTokenId;
967 
968     for (uint256 i = 0; i < quantity; i++) {
969       emit Transfer(address(0), to, updatedIndex);
970       require(
971         _checkOnERC721Received(address(0), to, updatedIndex, _data),
972         "ERC721A: transfer to non ERC721Receiver implementer"
973       );
974       updatedIndex++;
975     }
976 
977     currentIndex = updatedIndex;
978     _afterTokenTransfers(address(0), to, startTokenId, quantity);
979   }
980 
981   /**
982    * @dev Transfers `tokenId` from `from` to `to`.
983    *
984    * Requirements:
985    *
986    * - `to` cannot be the zero address.
987    * - `tokenId` token must be owned by `from`.
988    *
989    * Emits a {Transfer} event.
990    */
991   function _transfer(
992     address from,
993     address to,
994     uint256 tokenId
995   ) private {
996     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
997 
998     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
999       getApproved(tokenId) == _msgSender() ||
1000       isApprovedForAll(prevOwnership.addr, _msgSender()));
1001 
1002     require(
1003       isApprovedOrOwner,
1004       "ERC721A: transfer caller is not owner nor approved"
1005     );
1006 
1007     require(
1008       prevOwnership.addr == from,
1009       "ERC721A: transfer from incorrect owner"
1010     );
1011     require(to != address(0), "ERC721A: transfer to the zero address");
1012 
1013     _beforeTokenTransfers(from, to, tokenId, 1);
1014 
1015     // Clear approvals from the previous owner
1016     _approve(address(0), tokenId, prevOwnership.addr);
1017 
1018     _addressData[from].balance -= 1;
1019     _addressData[to].balance += 1;
1020     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1021 
1022     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1023     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1024     uint256 nextTokenId = tokenId + 1;
1025     if (_ownerships[nextTokenId].addr == address(0)) {
1026       if (_exists(nextTokenId)) {
1027         _ownerships[nextTokenId] = TokenOwnership(
1028           prevOwnership.addr,
1029           prevOwnership.startTimestamp
1030         );
1031       }
1032     }
1033 
1034     emit Transfer(from, to, tokenId);
1035     _afterTokenTransfers(from, to, tokenId, 1);
1036   }
1037 
1038   /**
1039    * @dev Approve `to` to operate on `tokenId`
1040    *
1041    * Emits a {Approval} event.
1042    */
1043   function _approve(
1044     address to,
1045     uint256 tokenId,
1046     address owner
1047   ) private {
1048     _tokenApprovals[tokenId] = to;
1049     emit Approval(owner, to, tokenId);
1050   }
1051 
1052   uint256 public nextOwnerToExplicitlySet = 0;
1053 
1054   /**
1055    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1056    */
1057   function _setOwnersExplicit(uint256 quantity) internal {
1058     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1059     require(quantity > 0, "quantity must be nonzero");
1060     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1061     if (endIndex > currentIndex - 1) {
1062       endIndex = currentIndex - 1;
1063     }
1064     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1065     require(_exists(endIndex), "not enough minted yet for this cleanup");
1066     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1067       if (_ownerships[i].addr == address(0)) {
1068         TokenOwnership memory ownership = ownershipOf(i);
1069         _ownerships[i] = TokenOwnership(
1070           ownership.addr,
1071           ownership.startTimestamp
1072         );
1073       }
1074     }
1075     nextOwnerToExplicitlySet = endIndex + 1;
1076   }
1077 
1078   /**
1079    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1080    * The call is not executed if the target address is not a contract.
1081    *
1082    * @param from address representing the previous owner of the given token ID
1083    * @param to target address that will receive the tokens
1084    * @param tokenId uint256 ID of the token to be transferred
1085    * @param _data bytes optional data to send along with the call
1086    * @return bool whether the call correctly returned the expected magic value
1087    */
1088   function _checkOnERC721Received(
1089     address from,
1090     address to,
1091     uint256 tokenId,
1092     bytes memory _data
1093   ) private returns (bool) {
1094     if (to.isContract()) {
1095       try
1096         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1097       returns (bytes4 retval) {
1098         return retval == IERC721Receiver(to).onERC721Received.selector;
1099       } catch (bytes memory reason) {
1100         if (reason.length == 0) {
1101           revert("ERC721A: transfer to non ERC721Receiver implementer");
1102         } else {
1103           assembly {
1104             revert(add(32, reason), mload(reason))
1105           }
1106         }
1107       }
1108     } else {
1109       return true;
1110     }
1111   }
1112 
1113   /**
1114    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1115    *
1116    * startTokenId - the first token id to be transferred
1117    * quantity - the amount to be transferred
1118    *
1119    * Calling conditions:
1120    *
1121    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1122    * transferred to `to`.
1123    * - When `from` is zero, `tokenId` will be minted for `to`.
1124    */
1125   function _beforeTokenTransfers(
1126     address from,
1127     address to,
1128     uint256 startTokenId,
1129     uint256 quantity
1130   ) internal virtual {}
1131 
1132   /**
1133    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1134    * minting.
1135    *
1136    * startTokenId - the first token id to be transferred
1137    * quantity - the amount to be transferred
1138    *
1139    * Calling conditions:
1140    *
1141    * - when `from` and `to` are both non-zero.
1142    * - `from` and `to` are never both zero.
1143    */
1144   function _afterTokenTransfers(
1145     address from,
1146     address to,
1147     uint256 startTokenId,
1148     uint256 quantity
1149   ) internal virtual {}
1150 }
1151 // File: @openzeppelin/contracts/access/Ownable.sol
1152 
1153 
1154 
1155 pragma solidity ^0.8.0;
1156 
1157 
1158 /**
1159  * @dev Contract module which provides a basic access control mechanism, where
1160  * there is an account (an owner) that can be granted exclusive access to
1161  * specific functions.
1162  *
1163  * By default, the owner account will be the one that deploys the contract. This
1164  * can later be changed with {transferOwnership}.
1165  *
1166  * This module is used through inheritance. It will make available the modifier
1167  * `onlyOwner`, which can be applied to your functions to restrict their use to
1168  * the owner.
1169  */
1170 abstract contract Ownable is Context {
1171     address private _owner;
1172 
1173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1174 
1175     /**
1176      * @dev Initializes the contract setting the deployer as the initial owner.
1177      */
1178     constructor() {
1179         _setOwner(_msgSender());
1180     }
1181 
1182     /**
1183      * @dev Returns the address of the current owner.
1184      */
1185     function owner() public view virtual returns (address) {
1186         return _owner;
1187     }
1188 
1189     /**
1190      * @dev Throws if called by any account other than the owner.
1191      */
1192     modifier onlyOwner() {
1193         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1194         _;
1195     }
1196 
1197     /**
1198      * @dev Leaves the contract without owner. It will not be possible to call
1199      * `onlyOwner` functions anymore. Can only be called by the current owner.
1200      *
1201      * NOTE: Renouncing ownership will leave the contract without an owner,
1202      * thereby removing any functionality that is only available to the owner.
1203      */
1204     function renounceOwnership() public virtual onlyOwner {
1205         _setOwner(address(0));
1206     }
1207 
1208     /**
1209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1210      * Can only be called by the current owner.
1211      */
1212     function transferOwnership(address newOwner) public virtual onlyOwner {
1213         require(newOwner != address(0), "Ownable: new owner is the zero address");
1214         _setOwner(newOwner);
1215     }
1216 
1217     function _setOwner(address newOwner) private {
1218         address oldOwner = _owner;
1219         _owner = newOwner;
1220         emit OwnershipTransferred(oldOwner, newOwner);
1221     }
1222 }
1223 
1224 // File: contracts/PV2.sol
1225 
1226 
1227 pragma solidity ^0.8.0;
1228 
1229 
1230 
1231 contract PV2 is Ownable, ERC721A {
1232 
1233     // constants
1234     uint256 constant MAX_ELEMENTS = 3333;
1235     uint256 constant MAX_ELEMENTS_TX = 10;
1236     uint256 constant PUBLIC_PRICE = 0.003 ether;
1237 
1238     string public baseTokenURI;
1239     bool public paused = false;
1240 
1241     constructor() ERC721A("PV2 by beeple", "PV2", 10) {}
1242 
1243     function mint(uint256 _mintAmount) public payable {
1244         uint256 supply = totalSupply();
1245         require(_mintAmount > 0,"No 0 mints");
1246         require(_mintAmount <= MAX_ELEMENTS_TX,"Exceeds max per tx");
1247         require(!paused, "Paused");
1248 
1249         require(supply + _mintAmount <= MAX_ELEMENTS,"Exceeds max supply");
1250         require(msg.value >= (_mintAmount - 1)* PUBLIC_PRICE,"Invalid funds provided");
1251         _safeMint(msg.sender,_mintAmount);
1252     }
1253 
1254     function withdraw() public payable onlyOwner {
1255         require(payable(msg.sender).send(address(this).balance));
1256     }
1257 
1258     function pause(bool _state) external onlyOwner {
1259         paused = _state;
1260     }
1261 
1262     function _baseURI() internal view virtual override returns (string memory) {
1263         return baseTokenURI;
1264     }
1265 
1266     function setBaseURI(string calldata baseURI) public onlyOwner {
1267         baseTokenURI = baseURI;
1268     }
1269 }