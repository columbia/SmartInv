1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 pragma solidity >=0.7.0 <0.9.0;
5 
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _transferOwnership(_msgSender());
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         _checkOwner();
56         _;
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if the sender is not the owner.
68      */
69     function _checkOwner() internal view virtual {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 /**
127  * @dev Implementation of the {IERC165} interface.
128  *
129  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
130  * for the additional interface id that will be supported. For example:
131  *
132  * ```solidity
133  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
134  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
135  * }
136  * ```
137  *
138  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
139  */
140 abstract contract ERC165 is IERC165 {
141     /**
142      * @dev See {IERC165-supportsInterface}.
143      */
144     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
145         return interfaceId == type(IERC165).interfaceId;
146     }
147 }
148 
149 /**
150  * @dev Required interface of an ERC721 compliant contract.
151  */
152 interface IERC721 is IERC165 {
153     /**
154      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
157 
158     /**
159      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
160      */
161     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
162 
163     /**
164      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
165      */
166     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
167 
168     /**
169      * @dev Returns the number of tokens in ``owner``'s account.
170      */
171     function balanceOf(address owner) external view returns (uint256 balance);
172 
173     /**
174      * @dev Returns the owner of the `tokenId` token.
175      *
176      * Requirements:
177      *
178      * - `tokenId` must exist.
179      */
180     function ownerOf(uint256 tokenId) external view returns (address owner);
181 
182     /**
183      * @dev Safely transfers `tokenId` token from `from` to `to`.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId,
199         bytes calldata data
200     ) external;
201 
202     /**
203      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
204      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must exist and be owned by `from`.
211      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId
220     ) external;
221 
222     /**
223      * @dev Transfers `tokenId` token from `from` to `to`.
224      *
225      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must be owned by `from`.
232      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transferFrom(
237         address from,
238         address to,
239         uint256 tokenId
240     ) external;
241 
242     /**
243      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
244      * The approval is cleared when the token is transferred.
245      *
246      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
247      *
248      * Requirements:
249      *
250      * - The caller must own the token or be an approved operator.
251      * - `tokenId` must exist.
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address to, uint256 tokenId) external;
256 
257     /**
258      * @dev Approve or remove `operator` as an operator for the caller.
259      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
260      *
261      * Requirements:
262      *
263      * - The `operator` cannot be the caller.
264      *
265      * Emits an {ApprovalForAll} event.
266      */
267     function setApprovalForAll(address operator, bool _approved) external;
268 
269     /**
270      * @dev Returns the account approved for `tokenId` token.
271      *
272      * Requirements:
273      *
274      * - `tokenId` must exist.
275      */
276     function getApproved(uint256 tokenId) external view returns (address operator);
277 
278     /**
279      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
280      *
281      * See {setApprovalForAll}
282      */
283     function isApprovedForAll(address owner, address operator) external view returns (bool);
284 }
285 
286 
287 
288 
289 
290 /**
291  * @title ERC721 token receiver interface
292  * @dev Interface for any contract that wants to support safeTransfers
293  * from ERC721 asset contracts.
294  */
295 interface IERC721Receiver {
296     /**
297      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
298      * by `operator` from `from`, this function is called.
299      *
300      * It must return its Solidity selector to confirm the token transfer.
301      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
302      *
303      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
304      */
305     function onERC721Received(
306         address operator,
307         address from,
308         uint256 tokenId,
309         bytes calldata data
310     ) external returns (bytes4);
311 }
312 
313 
314 /**
315  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
316  * @dev See https://eips.ethereum.org/EIPS/eip-721
317  */
318 interface IERC721Metadata is IERC721 {
319     /**
320      * @dev Returns the token collection name.
321      */
322     function name() external view returns (string memory);
323 
324     /**
325      * @dev Returns the token collection symbol.
326      */
327     function symbol() external view returns (string memory);
328 
329     /**
330      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
331      */
332     function tokenURI(uint256 tokenId) external view returns (string memory);
333 }
334 
335 
336 /**
337  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
338  * @dev See https://eips.ethereum.org/EIPS/eip-721
339  */
340 interface IERC721Enumerable is IERC721 {
341     /**
342      * @dev Returns the total amount of tokens stored by the contract.
343      */
344     function totalSupply() external view returns (uint256);
345 
346     /**
347      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
348      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
349      */
350     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
351 
352     /**
353      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
354      * Use along with {totalSupply} to enumerate all tokens.
355      */
356     function tokenByIndex(uint256 index) external view returns (uint256);
357 }
358 
359 
360 /**
361  * @dev Collection of functions related to the address type
362  */
363 library Address {
364     /**
365      * @dev Returns true if `account` is a contract.
366      *
367      * [IMPORTANT]
368      * ====
369      * It is unsafe to assume that an address for which this function returns
370      * false is an externally-owned account (EOA) and not a contract.
371      *
372      * Among others, `isContract` will return false for the following
373      * types of addresses:
374      *
375      *  - an externally-owned account
376      *  - a contract in construction
377      *  - an address where a contract will be created
378      *  - an address where a contract lived, but was destroyed
379      * ====
380      *
381      * [IMPORTANT]
382      * ====
383      * You shouldn't rely on `isContract` to protect against flash loan attacks!
384      *
385      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
386      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
387      * constructor.
388      * ====
389      */
390     function isContract(address account) internal view returns (bool) {
391         // This method relies on extcodesize/address.code.length, which returns 0
392         // for contracts in construction, since the code is only stored at the end
393         // of the constructor execution.
394 
395         return account.code.length > 0;
396     }
397 
398     /**
399      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
400      * `recipient`, forwarding all available gas and reverting on errors.
401      *
402      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
403      * of certain opcodes, possibly making contracts go over the 2300 gas limit
404      * imposed by `transfer`, making them unable to receive funds via
405      * `transfer`. {sendValue} removes this limitation.
406      *
407      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
408      *
409      * IMPORTANT: because control is transferred to `recipient`, care must be
410      * taken to not create reentrancy vulnerabilities. Consider using
411      * {ReentrancyGuard} or the
412      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
413      */
414     function sendValue(address payable recipient, uint256 amount) internal {
415         require(address(this).balance >= amount, "Address: insufficient balance");
416 
417         (bool success, ) = recipient.call{value: amount}("");
418         require(success, "Address: unable to send value, recipient may have reverted");
419     }
420 
421     /**
422      * @dev Performs a Solidity function call using a low level `call`. A
423      * plain `call` is an unsafe replacement for a function call: use this
424      * function instead.
425      *
426      * If `target` reverts with a revert reason, it is bubbled up by this
427      * function (like regular Solidity function calls).
428      *
429      * Returns the raw returned data. To convert to the expected return value,
430      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
431      *
432      * Requirements:
433      *
434      * - `target` must be a contract.
435      * - calling `target` with `data` must not revert.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionCall(target, data, "Address: low-level call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
445      * `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         return functionCallWithValue(target, data, 0, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but also transferring `value` wei to `target`.
460      *
461      * Requirements:
462      *
463      * - the calling contract must have an ETH balance of at least `value`.
464      * - the called Solidity function must be `payable`.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(
469         address target,
470         bytes memory data,
471         uint256 value
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
478      * with `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(address(this).balance >= value, "Address: insufficient balance for call");
489         require(isContract(target), "Address: call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.call{value: value}(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a static call.
498      *
499      * _Available since v3.3._
500      */
501     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
502         return functionStaticCall(target, data, "Address: low-level static call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
507      * but performing a static call.
508      *
509      * _Available since v3.3._
510      */
511     function functionStaticCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal view returns (bytes memory) {
516         require(isContract(target), "Address: static call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.staticcall(data);
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but performing a delegate call.
525      *
526      * _Available since v3.4._
527      */
528     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
529         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
534      * but performing a delegate call.
535      *
536      * _Available since v3.4._
537      */
538     function functionDelegateCall(
539         address target,
540         bytes memory data,
541         string memory errorMessage
542     ) internal returns (bytes memory) {
543         require(isContract(target), "Address: delegate call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.delegatecall(data);
546         return verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
551      * revert reason using the provided one.
552      *
553      * _Available since v4.3._
554      */
555     function verifyCallResult(
556         bool success,
557         bytes memory returndata,
558         string memory errorMessage
559     ) internal pure returns (bytes memory) {
560         if (success) {
561             return returndata;
562         } else {
563             // Look for revert reason and bubble it up if present
564             if (returndata.length > 0) {
565                 // The easiest way to bubble the revert reason is using memory via assembly
566                 /// @solidity memory-safe-assembly
567                 assembly {
568                     let returndata_size := mload(returndata)
569                     revert(add(32, returndata), returndata_size)
570                 }
571             } else {
572                 revert(errorMessage);
573             }
574         }
575     }
576 }
577 
578 
579 
580 
581 
582 /**
583  * @dev String operations.
584  */
585 library Strings {
586     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
587     uint8 private constant _ADDRESS_LENGTH = 20;
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
591      */
592     function toString(uint256 value) internal pure returns (string memory) {
593         // Inspired by OraclizeAPI's implementation - MIT licence
594         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
595 
596         if (value == 0) {
597             return "0";
598         }
599         uint256 temp = value;
600         uint256 digits;
601         while (temp != 0) {
602             digits++;
603             temp /= 10;
604         }
605         bytes memory buffer = new bytes(digits);
606         while (value != 0) {
607             digits -= 1;
608             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
609             value /= 10;
610         }
611         return string(buffer);
612     }
613 
614     /**
615      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
616      */
617     function toHexString(uint256 value) internal pure returns (string memory) {
618         if (value == 0) {
619             return "0x00";
620         }
621         uint256 temp = value;
622         uint256 length = 0;
623         while (temp != 0) {
624             length++;
625             temp >>= 8;
626         }
627         return toHexString(value, length);
628     }
629 
630     /**
631      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
632      */
633     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
634         bytes memory buffer = new bytes(2 * length + 2);
635         buffer[0] = "0";
636         buffer[1] = "x";
637         for (uint256 i = 2 * length + 1; i > 1; --i) {
638             buffer[i] = _HEX_SYMBOLS[value & 0xf];
639             value >>= 4;
640         }
641         require(value == 0, "Strings: hex length insufficient");
642         return string(buffer);
643     }
644 
645     /**
646      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
647      */
648     function toHexString(address addr) internal pure returns (string memory) {
649         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
650     }
651 }
652 
653 
654 
655 
656 
657 /**
658  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
659  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
660  *
661  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
662  *
663  * Does not support burning tokens to address(0).
664  */
665 contract ERC721A is
666   Context,
667   ERC165,
668   IERC721,
669   IERC721Metadata,
670   IERC721Enumerable
671 {
672   using Address for address;
673   using Strings for uint256;
674 
675   struct TokenOwnership {
676     address addr;
677     uint64 startTimestamp;
678   }
679 
680   struct AddressData {
681     uint128 balance;
682     uint128 numberMinted;
683   }
684 
685   uint256 private currentIndex = 1;
686 
687   uint256 public immutable maxBatchSize;
688 
689   // Token name
690   string private _name;
691 
692   // Token symbol
693   string private _symbol;
694 
695   // Mapping from token ID to ownership details
696   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
697   mapping(uint256 => TokenOwnership) private _ownerships;
698 
699   // Mapping owner address to address data
700   mapping(address => AddressData) private _addressData;
701 
702   // Mapping from token ID to approved address
703   mapping(uint256 => address) private _tokenApprovals;
704 
705   // Mapping from owner to operator approvals
706   mapping(address => mapping(address => bool)) private _operatorApprovals;
707 
708   /**
709    * @dev
710    * `maxBatchSize` refers to how much a minter can mint at a time.
711    */
712   constructor(
713     string memory name_,
714     string memory symbol_,
715     uint256 maxBatchSize_
716   ) {
717     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
718     _name = name_;
719     _symbol = symbol_;
720     maxBatchSize = maxBatchSize_;
721   }
722 
723   /**
724    * @dev See {IERC721Enumerable-totalSupply}.
725    */
726   function totalSupply() public view override returns (uint256) {
727     return currentIndex - 1;
728   }
729 
730   /**
731    * @dev See {IERC721Enumerable-tokenByIndex}.
732    */
733   function tokenByIndex(uint256 index) public view override returns (uint256) {
734     require(index < totalSupply(), "ERC721A: global index out of bounds");
735     return index;
736   }
737 
738   /**
739    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
740    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
741    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
742    */
743   function tokenOfOwnerByIndex(address owner, uint256 index)
744     public
745     view
746     override
747     returns (uint256)
748   {
749     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
750     uint256 numMintedSoFar = totalSupply();
751     uint256 tokenIdsIdx = 0;
752     address currOwnershipAddr = address(0);
753     for (uint256 i = 0; i < numMintedSoFar; i++) {
754       TokenOwnership memory ownership = _ownerships[i];
755       if (ownership.addr != address(0)) {
756         currOwnershipAddr = ownership.addr;
757       }
758       if (currOwnershipAddr == owner) {
759         if (tokenIdsIdx == index) {
760           return i;
761         }
762         tokenIdsIdx++;
763       }
764     }
765     revert("ERC721A: unable to get token of owner by index");
766   }
767 
768   /**
769    * @dev See {IERC165-supportsInterface}.
770    */
771   function supportsInterface(bytes4 interfaceId)
772     public
773     view
774     virtual
775     override(ERC165, IERC165)
776     returns (bool)
777   {
778     return
779       interfaceId == type(IERC721).interfaceId ||
780       interfaceId == type(IERC721Metadata).interfaceId ||
781       interfaceId == type(IERC721Enumerable).interfaceId ||
782       super.supportsInterface(interfaceId);
783   }
784 
785   /**
786    * @dev See {IERC721-balanceOf}.
787    */
788   function balanceOf(address owner) public view override returns (uint256) {
789     require(owner != address(0), "ERC721A: balance query for the zero address");
790     return uint256(_addressData[owner].balance);
791   }
792 
793   function _numberMinted(address owner) internal view returns (uint256) {
794     require(
795       owner != address(0),
796       "ERC721A: number minted query for the zero address"
797     );
798     return uint256(_addressData[owner].numberMinted);
799   }
800 
801   function ownershipOf(uint256 tokenId)
802     internal
803     view
804     returns (TokenOwnership memory)
805   {
806     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
807 
808     uint256 lowestTokenToCheck;
809     if (tokenId >= maxBatchSize) {
810       lowestTokenToCheck = tokenId - maxBatchSize + 1;
811     }
812 
813     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
814       TokenOwnership memory ownership = _ownerships[curr];
815       if (ownership.addr != address(0)) {
816         return ownership;
817       }
818     }
819 
820     revert("ERC721A: unable to determine the owner of token");
821   }
822 
823   /**
824    * @dev See {IERC721-ownerOf}.
825    */
826   function ownerOf(uint256 tokenId) public view override returns (address) {
827     return ownershipOf(tokenId).addr;
828   }
829 
830   /**
831    * @dev See {IERC721Metadata-name}.
832    */
833   function name() public view virtual override returns (string memory) {
834     return _name;
835   }
836 
837   /**
838    * @dev See {IERC721Metadata-symbol}.
839    */
840   function symbol() public view virtual override returns (string memory) {
841     return _symbol;
842   }
843 
844   /**
845    * @dev See {IERC721Metadata-tokenURI}.
846    */
847   function tokenURI(uint256 tokenId)
848     public
849     view
850     virtual
851     override
852     returns (string memory)
853   {
854     require(
855       _exists(tokenId),
856       "ERC721Metadata: URI query for nonexistent token"
857     );
858 
859     string memory baseURI = _baseURI();
860     return
861       bytes(baseURI).length > 0
862         ? string(abi.encodePacked(baseURI, tokenId.toString()))
863         : "";
864   }
865 
866   /**
867    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
868    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
869    * by default, can be overriden in child contracts.
870    */
871   function _baseURI() internal view virtual returns (string memory) {
872     return "";
873   }
874 
875   /**
876    * @dev See {IERC721-approve}.
877    */
878   function approve(address to, uint256 tokenId) public override {
879     address owner = ERC721A.ownerOf(tokenId);
880     require(to != owner, "ERC721A: approval to current owner");
881 
882     require(
883       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
884       "ERC721A: approve caller is not owner nor approved for all"
885     );
886 
887     _approve(to, tokenId, owner);
888   }
889 
890   /**
891    * @dev See {IERC721-getApproved}.
892    */
893   function getApproved(uint256 tokenId) public view override returns (address) {
894     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
895 
896     return _tokenApprovals[tokenId];
897   }
898 
899   /**
900    * @dev See {IERC721-setApprovalForAll}.
901    */
902   function setApprovalForAll(address operator, bool approved) public override {
903     require(operator != _msgSender(), "ERC721A: approve to caller");
904 
905     _operatorApprovals[_msgSender()][operator] = approved;
906     emit ApprovalForAll(_msgSender(), operator, approved);
907   }
908 
909   /**
910    * @dev See {IERC721-isApprovedForAll}.
911    */
912   function isApprovedForAll(address owner, address operator)
913     public
914     view
915     virtual
916     override
917     returns (bool)
918   {
919     return _operatorApprovals[owner][operator];
920   }
921 
922   /**
923    * @dev See {IERC721-transferFrom}.
924    */
925   function transferFrom(
926     address from,
927     address to,
928     uint256 tokenId
929   ) public override {
930     _transfer(from, to, tokenId);
931   }
932 
933   /**
934    * @dev See {IERC721-safeTransferFrom}.
935    */
936   function safeTransferFrom(
937     address from,
938     address to,
939     uint256 tokenId
940   ) public override {
941     safeTransferFrom(from, to, tokenId, "");
942   }
943 
944   /**
945    * @dev See {IERC721-safeTransferFrom}.
946    */
947   function safeTransferFrom(
948     address from,
949     address to,
950     uint256 tokenId,
951     bytes memory _data
952   ) public override {
953     _transfer(from, to, tokenId);
954     require(
955       _checkOnERC721Received(from, to, tokenId, _data),
956       "ERC721A: transfer to non ERC721Receiver implementer"
957     );
958   }
959 
960   /**
961    * @dev Returns whether `tokenId` exists.
962    *
963    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964    *
965    * Tokens start existing when they are minted (`_mint`),
966    */
967   function _exists(uint256 tokenId) internal view returns (bool) {
968     return tokenId < currentIndex;
969   }
970 
971   function _safeMint(address to, uint256 quantity) internal {
972     _safeMint(to, quantity, "");
973   }
974 
975   /**
976    * @dev Mints `quantity` tokens and transfers them to `to`.
977    *
978    * Requirements:
979    *
980    * - `to` cannot be the zero address.
981    * - `quantity` cannot be larger than the max batch size.
982    *
983    * Emits a {Transfer} event.
984    */
985   function _safeMint(
986     address to,
987     uint256 quantity,
988     bytes memory _data
989   ) internal {
990     uint256 startTokenId = currentIndex;
991     require(to != address(0), "ERC721A: mint to the zero address");
992     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
993     require(!_exists(startTokenId), "ERC721A: token already minted");
994     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
995 
996     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
997 
998     AddressData memory addressData = _addressData[to];
999     _addressData[to] = AddressData(
1000       addressData.balance + uint128(quantity),
1001       addressData.numberMinted + uint128(quantity)
1002     );
1003     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1004 
1005     uint256 updatedIndex = startTokenId;
1006 
1007     for (uint256 i = 0; i < quantity; i++) {
1008       emit Transfer(address(0), to, updatedIndex);
1009       require(
1010         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1011         "ERC721A: transfer to non ERC721Receiver implementer"
1012       );
1013       updatedIndex++;
1014     }
1015 
1016     currentIndex = updatedIndex;
1017     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1018   }
1019 
1020   /**
1021    * @dev Transfers `tokenId` from `from` to `to`.
1022    *
1023    * Requirements:
1024    *
1025    * - `to` cannot be the zero address.
1026    * - `tokenId` token must be owned by `from`.
1027    *
1028    * Emits a {Transfer} event.
1029    */
1030   function _transfer(
1031     address from,
1032     address to,
1033     uint256 tokenId
1034   ) private {
1035     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1036 
1037     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1038       getApproved(tokenId) == _msgSender() ||
1039       isApprovedForAll(prevOwnership.addr, _msgSender()));
1040 
1041     require(
1042       isApprovedOrOwner,
1043       "ERC721A: transfer caller is not owner nor approved"
1044     );
1045 
1046     require(
1047       prevOwnership.addr == from,
1048       "ERC721A: transfer from incorrect owner"
1049     );
1050     require(to != address(0), "ERC721A: transfer to the zero address");
1051 
1052     _beforeTokenTransfers(from, to, tokenId, 1);
1053 
1054     // Clear approvals from the previous owner
1055     _approve(address(0), tokenId, prevOwnership.addr);
1056 
1057     _addressData[from].balance -= 1;
1058     _addressData[to].balance += 1;
1059     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1060 
1061     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1062     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063     uint256 nextTokenId = tokenId + 1;
1064     if (_ownerships[nextTokenId].addr == address(0)) {
1065       if (_exists(nextTokenId)) {
1066         _ownerships[nextTokenId] = TokenOwnership(
1067           prevOwnership.addr,
1068           prevOwnership.startTimestamp
1069         );
1070       }
1071     }
1072 
1073     emit Transfer(from, to, tokenId);
1074     _afterTokenTransfers(from, to, tokenId, 1);
1075   }
1076 
1077   /**
1078    * @dev Approve `to` to operate on `tokenId`
1079    *
1080    * Emits a {Approval} event.
1081    */
1082   function _approve(
1083     address to,
1084     uint256 tokenId,
1085     address owner
1086   ) private {
1087     _tokenApprovals[tokenId] = to;
1088     emit Approval(owner, to, tokenId);
1089   }
1090 
1091   uint256 public nextOwnerToExplicitlySet = 0;
1092 
1093   /**
1094    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1095    */
1096   function _setOwnersExplicit(uint256 quantity) internal {
1097     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1098     require(quantity > 0, "quantity must be nonzero");
1099     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1100     if (endIndex > currentIndex - 1) {
1101       endIndex = currentIndex - 1;
1102     }
1103     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1104     require(_exists(endIndex), "not enough minted yet for this cleanup");
1105     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1106       if (_ownerships[i].addr == address(0)) {
1107         TokenOwnership memory ownership = ownershipOf(i);
1108         _ownerships[i] = TokenOwnership(
1109           ownership.addr,
1110           ownership.startTimestamp
1111         );
1112       }
1113     }
1114     nextOwnerToExplicitlySet = endIndex + 1;
1115   }
1116 
1117   /**
1118    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1119    * The call is not executed if the target address is not a contract.
1120    *
1121    * @param from address representing the previous owner of the given token ID
1122    * @param to target address that will receive the tokens
1123    * @param tokenId uint256 ID of the token to be transferred
1124    * @param _data bytes optional data to send along with the call
1125    * @return bool whether the call correctly returned the expected magic value
1126    */
1127   function _checkOnERC721Received(
1128     address from,
1129     address to,
1130     uint256 tokenId,
1131     bytes memory _data
1132   ) private returns (bool) {
1133     if (to.isContract()) {
1134       try
1135         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1136       returns (bytes4 retval) {
1137         return retval == IERC721Receiver(to).onERC721Received.selector;
1138       } catch (bytes memory reason) {
1139         if (reason.length == 0) {
1140           revert("ERC721A: transfer to non ERC721Receiver implementer");
1141         } else {
1142           assembly {
1143             revert(add(32, reason), mload(reason))
1144           }
1145         }
1146       }
1147     } else {
1148       return true;
1149     }
1150   }
1151 
1152   /**
1153    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1154    *
1155    * startTokenId - the first token id to be transferred
1156    * quantity - the amount to be transferred
1157    *
1158    * Calling conditions:
1159    *
1160    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1161    * transferred to `to`.
1162    * - When `from` is zero, `tokenId` will be minted for `to`.
1163    */
1164   function _beforeTokenTransfers(
1165     address from,
1166     address to,
1167     uint256 startTokenId,
1168     uint256 quantity
1169   ) internal virtual {}
1170 
1171   /**
1172    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1173    * minting.
1174    *
1175    * startTokenId - the first token id to be transferred
1176    * quantity - the amount to be transferred
1177    *
1178    * Calling conditions:
1179    *
1180    * - when `from` and `to` are both non-zero.
1181    * - `from` and `to` are never both zero.
1182    */
1183   function _afterTokenTransfers(
1184     address from,
1185     address to,
1186     uint256 startTokenId,
1187     uint256 quantity
1188   ) internal virtual {}
1189 }
1190 
1191 
1192 
1193 
1194 contract PunksV420 is ERC721A, Ownable {
1195   using Strings for uint256;
1196 
1197   string public baseURI;
1198   string public baseExtension = ".json";
1199   uint256 public cost = 0.0042 ether;
1200   uint256 public maxSupply = 10000;
1201   uint256 public maxsize = 10 ; // max mint per tx
1202   bool public paused = true;
1203 
1204   constructor() ERC721A("PunksV420", "Pv420", maxsize) {
1205     setBaseURI("ipfs://Qmavwfzq8YgeKLFUyu16wbYj81PyuotSMt3xciGoB59Sn8/");
1206   }
1207 
1208   // internal
1209   function _baseURI() internal view virtual override returns (string memory) {
1210     return baseURI;
1211   }
1212 
1213   // public
1214   function mint(uint256 tokens) public payable {
1215     require(!paused, "PunksV420: oops contract is paused");
1216     uint256 supply = totalSupply();
1217     require(tokens > 0, "PunksV420: need to mint at least 1 NFT");
1218     require(tokens <= maxsize, "PunksV420: max mint amount per tx exceeded");
1219     require(supply + tokens <= maxSupply, "PunksV420: We Soldout");
1220     if (supply < 1500) {
1221       require(msg.value >= 0 * tokens, "PunksV420: It's Free Mint");
1222     } else {
1223 
1224     require(msg.value >= cost * tokens, "PunksV420: insufficient funds");
1225     }
1226 
1227       _safeMint(_msgSender(), tokens);
1228     
1229   }
1230 
1231 
1232 
1233   /// @dev use it for giveaway and mint for yourself
1234      function gift(uint256 _mintAmount, address destination) public onlyOwner {
1235     require(_mintAmount > 0, "need to mint at least 1 NFT");
1236     uint256 supply = totalSupply();
1237     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1238 
1239       _safeMint(destination, _mintAmount);
1240     
1241   }
1242 
1243   
1244 
1245 
1246   function walletOfOwner(address _owner)
1247     public
1248     view
1249     returns (uint256[] memory)
1250   {
1251     uint256 ownerTokenCount = balanceOf(_owner);
1252     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1253     for (uint256 i; i < ownerTokenCount; i++) {
1254       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1255     }
1256     return tokenIds;
1257   }
1258 
1259   function tokenURI(uint256 tokenId)
1260     public
1261     view
1262     virtual
1263     override
1264     returns (string memory)
1265   {
1266     require(
1267       _exists(tokenId),
1268       "ERC721AMetadata: URI query for nonexistent token"
1269     );
1270     
1271 
1272     string memory currentBaseURI = _baseURI();
1273     return bytes(currentBaseURI).length > 0
1274         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1275         : "";
1276   }
1277 
1278   //only owner
1279 
1280   function setCost(uint256 _newCost) public onlyOwner {
1281     cost = _newCost;
1282   }
1283 
1284     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1285     maxSupply = _newsupply;
1286   }
1287 
1288 
1289   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1290     baseURI = _newBaseURI;
1291   }
1292 
1293   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1294     baseExtension = _newBaseExtension;
1295   }
1296   
1297 
1298   function pause(bool _state) public onlyOwner {
1299     paused = _state;
1300   }
1301  
1302   function withdraw() public payable onlyOwner {
1303     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1304     require(success);
1305   }
1306 }