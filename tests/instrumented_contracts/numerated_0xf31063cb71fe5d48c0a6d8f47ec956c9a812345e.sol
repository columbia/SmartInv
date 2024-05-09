1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
531 
532 
533 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Enumerable is IERC721 {
543     /**
544      * @dev Returns the total amount of tokens stored by the contract.
545      */
546     function totalSupply() external view returns (uint256);
547 
548     /**
549      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
550      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
551      */
552     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
553 
554     /**
555      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
556      * Use along with {totalSupply} to enumerate all tokens.
557      */
558     function tokenByIndex(uint256 index) external view returns (uint256);
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Metadata is IERC721 {
574     /**
575      * @dev Returns the token collection name.
576      */
577     function name() external view returns (string memory);
578 
579     /**
580      * @dev Returns the token collection symbol.
581      */
582     function symbol() external view returns (string memory);
583 
584     /**
585      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
586      */
587     function tokenURI(uint256 tokenId) external view returns (string memory);
588 }
589 
590 // File: @openzeppelin/contracts/utils/Context.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Provides information about the current execution context, including the
599  * sender of the transaction and its data. While these are generally available
600  * via msg.sender and msg.data, they should not be accessed in such a direct
601  * manner, since when dealing with meta-transactions the account sending and
602  * paying for execution may not be the actual sender (as far as an application
603  * is concerned).
604  *
605  * This contract is only required for intermediate, library-like contracts.
606  */
607 abstract contract Context {
608     function _msgSender() internal view virtual returns (address) {
609         return msg.sender;
610     }
611 
612     function _msgData() internal view virtual returns (bytes calldata) {
613         return msg.data;
614     }
615 }
616 
617 // File: ERC721A.sol
618 
619 
620 // Creators: locationtba.eth, 2pmflow.eth
621 
622 pragma solidity ^0.8.0;
623 
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
1165 // File: @openzeppelin/contracts/access/Ownable.sol
1166 
1167 
1168 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 
1173 /**
1174  * @dev Contract module which provides a basic access control mechanism, where
1175  * there is an account (an owner) that can be granted exclusive access to
1176  * specific functions.
1177  *
1178  * By default, the owner account will be the one that deploys the contract. This
1179  * can later be changed with {transferOwnership}.
1180  *
1181  * This module is used through inheritance. It will make available the modifier
1182  * `onlyOwner`, which can be applied to your functions to restrict their use to
1183  * the owner.
1184  */
1185 abstract contract Ownable is Context {
1186     address private _owner;
1187 
1188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1189 
1190     /**
1191      * @dev Initializes the contract setting the deployer as the initial owner.
1192      */
1193     constructor() {
1194         _transferOwnership(_msgSender());
1195     }
1196 
1197     /**
1198      * @dev Returns the address of the current owner.
1199      */
1200     function owner() public view virtual returns (address) {
1201         return _owner;
1202     }
1203 
1204     /**
1205      * @dev Throws if called by any account other than the owner.
1206      */
1207     modifier onlyOwner() {
1208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1209         _;
1210     }
1211 
1212     /**
1213      * @dev Leaves the contract without owner. It will not be possible to call
1214      * `onlyOwner` functions anymore. Can only be called by the current owner.
1215      *
1216      * NOTE: Renouncing ownership will leave the contract without an owner,
1217      * thereby removing any functionality that is only available to the owner.
1218      */
1219     function renounceOwnership() public virtual onlyOwner {
1220         _transferOwnership(address(0));
1221     }
1222 
1223     /**
1224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1225      * Can only be called by the current owner.
1226      */
1227     function transferOwnership(address newOwner) public virtual onlyOwner {
1228         require(newOwner != address(0), "Ownable: new owner is the zero address");
1229         _transferOwnership(newOwner);
1230     }
1231 
1232     /**
1233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1234      * Internal function without access restriction.
1235      */
1236     function _transferOwnership(address newOwner) internal virtual {
1237         address oldOwner = _owner;
1238         _owner = newOwner;
1239         emit OwnershipTransferred(oldOwner, newOwner);
1240     }
1241 }
1242 
1243 // File: 8sianwomen.sol
1244 
1245 
1246 
1247 
1248  
1249  /*
1250 
1251 ============================================== 8Sian Women ==============================================
1252 */                                                                                                         
1253 
1254 
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 
1259 /**
1260  * @title 8Sian Women
1261  */
1262                                                                                                      
1263                                                                                             
1264 
1265  contract OwnableDelegateProxy {}
1266 
1267 contract ProxyRegistry {
1268     mapping(address => OwnableDelegateProxy) public proxies;
1269 }
1270  
1271 contract ASianWomen is ERC721A, Ownable {
1272 
1273     bool public saleIsActive = false;
1274     string private _baseURIextended = "https://8sianwomen.s3.us-west-1.amazonaws.com/metadata/8sianwomen-metadata-";
1275 
1276     uint256 public Price1 = 0.03 ether;
1277     uint256 public Price2 = 0.05 ether;
1278 	
1279 	uint public maxSupply = 3333;
1280 	address proxyRegistryAddress ; 
1281 	mapping(address => uint) public addressFreeMinted;
1282 	
1283 
1284     constructor() ERC721A("8Sian Women", "8w", 500) {
1285        
1286     }
1287 
1288     function setBaseURI(string memory baseURI_) external onlyOwner() {
1289         _baseURIextended = baseURI_;
1290     }
1291 
1292     function _baseURI() internal view virtual override returns (string memory) {
1293         return _baseURIextended;
1294     }
1295 
1296     function setSaleState(bool newState) public onlyOwner {
1297         saleIsActive = newState;
1298     }
1299 
1300     function setPrice(uint256 newPrice1,uint256 newPrice2) public onlyOwner {
1301         Price1 = newPrice1;
1302         Price2 = newPrice2;
1303     }
1304 
1305     function setProxyRegistryAddress(address proxyAddress) external onlyOwner {
1306         proxyRegistryAddress = proxyAddress;
1307     }
1308 
1309     function isApprovedForAll(address owner, address operator)
1310         public
1311         view
1312         override
1313         returns (bool)
1314     {
1315         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1316         if (address(proxyRegistry.proxies(owner)) == operator) {
1317             return true;
1318         }
1319 
1320         return super.isApprovedForAll(owner, operator);
1321     }
1322 
1323     function mint(uint numberOfTokens) external payable {
1324         
1325         uint amountAvailableFreeMint = 1000;
1326         uint maxPerTx = 5;
1327 	    uint maxFreeMintPerWallet = 10;
1328 
1329         require(saleIsActive, "Sale is inactive.");
1330         require(numberOfTokens <= maxPerTx, "You can only mint maxPerTx at a time.");
1331         require(totalSupply() + numberOfTokens <= maxSupply, "Purchase would exceed max supply of tokens");            
1332 
1333         if (totalSupply() + numberOfTokens > amountAvailableFreeMint) {
1334             if (totalSupply() + numberOfTokens <= 2000){
1335                 require((Price1 * numberOfTokens) <= msg.value, "Don't send under (in ETH).");
1336             }else {
1337                 require((Price2 * numberOfTokens) <= msg.value, "Don't send under (in ETH).");
1338             }
1339         } else {
1340 			require(msg.value == 0, "Don't send ether for the free mint.");
1341 			require(addressFreeMinted[msg.sender] < maxFreeMintPerWallet, "You can only adopt 10 free nfts per wallet. Wait for the paid adoption.");
1342 		}			
1343         _safeMint(msg.sender, numberOfTokens);
1344         addressFreeMinted[msg.sender] += numberOfTokens;
1345     }
1346 
1347      function gift(address _to,uint numberOfTokens) external onlyOwner {
1348          require(totalSupply() + numberOfTokens <= maxSupply, "Purchase would exceed max supply of tokens");
1349         _safeMint(_to, numberOfTokens);
1350     }
1351 
1352     function withdraw() public onlyOwner {
1353         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1354         require(
1355             success,
1356             "Address: unable to send value, recipient may have reverted"
1357         );
1358     }
1359 
1360 }