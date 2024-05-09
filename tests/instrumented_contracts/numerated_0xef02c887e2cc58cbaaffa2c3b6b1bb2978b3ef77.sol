1 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Context.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Provides information about the current execution context, including the
77  * sender of the transaction and its data. While these are generally available
78  * via msg.sender and msg.data, they should not be accessed in such a direct
79  * manner, since when dealing with meta-transactions the account sending and
80  * paying for execution may not be the actual sender (as far as an application
81  * is concerned).
82  *
83  * This contract is only required for intermediate, library-like contracts.
84  */
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89 
90     function _msgData() internal view virtual returns (bytes calldata) {
91         return msg.data;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/access/Ownable.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() {
124         _transferOwnership(_msgSender());
125     }
126 
127     /**
128      * @dev Returns the address of the current owner.
129      */
130     function owner() public view virtual returns (address) {
131         return _owner;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     /**
143      * @dev Leaves the contract without owner. It will not be possible to call
144      * `onlyOwner` functions anymore. Can only be called by the current owner.
145      *
146      * NOTE: Renouncing ownership will leave the contract without an owner,
147      * thereby removing any functionality that is only available to the owner.
148      */
149     function renounceOwnership() public virtual onlyOwner {
150         _transferOwnership(address(0));
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _transferOwnership(newOwner);
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Internal function without access restriction.
165      */
166     function _transferOwnership(address newOwner) internal virtual {
167         address oldOwner = _owner;
168         _owner = newOwner;
169         emit OwnershipTransferred(oldOwner, newOwner);
170     }
171 }
172 
173 // File: @openzeppelin/contracts/utils/Address.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Collection of functions related to the address type
182  */
183 library Address {
184     /**
185      * @dev Returns true if `account` is a contract.
186      *
187      * [IMPORTANT]
188      * ====
189      * It is unsafe to assume that an address for which this function returns
190      * false is an externally-owned account (EOA) and not a contract.
191      *
192      * Among others, `isContract` will return false for the following
193      * types of addresses:
194      *
195      *  - an externally-owned account
196      *  - a contract in construction
197      *  - an address where a contract will be created
198      *  - an address where a contract lived, but was destroyed
199      * ====
200      */
201     function isContract(address account) internal view returns (bool) {
202         // This method relies on extcodesize, which returns 0 for contracts in
203         // construction, since the code is only stored at the end of the
204         // constructor execution.
205 
206         uint256 size;
207         assembly {
208             size := extcodesize(account)
209         }
210         return size > 0;
211     }
212 
213     /**
214      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
215      * `recipient`, forwarding all available gas and reverting on errors.
216      *
217      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
218      * of certain opcodes, possibly making contracts go over the 2300 gas limit
219      * imposed by `transfer`, making them unable to receive funds via
220      * `transfer`. {sendValue} removes this limitation.
221      *
222      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
223      *
224      * IMPORTANT: because control is transferred to `recipient`, care must be
225      * taken to not create reentrancy vulnerabilities. Consider using
226      * {ReentrancyGuard} or the
227      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
228      */
229     function sendValue(address payable recipient, uint256 amount) internal {
230         require(address(this).balance >= amount, "Address: insufficient balance");
231 
232         (bool success, ) = recipient.call{value: amount}("");
233         require(success, "Address: unable to send value, recipient may have reverted");
234     }
235 
236     /**
237      * @dev Performs a Solidity function call using a low level `call`. A
238      * plain `call` is an unsafe replacement for a function call: use this
239      * function instead.
240      *
241      * If `target` reverts with a revert reason, it is bubbled up by this
242      * function (like regular Solidity function calls).
243      *
244      * Returns the raw returned data. To convert to the expected return value,
245      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
246      *
247      * Requirements:
248      *
249      * - `target` must be a contract.
250      * - calling `target` with `data` must not revert.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionCall(target, data, "Address: low-level call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
260      * `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
293      * with `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(address(this).balance >= value, "Address: insufficient balance for call");
304         require(isContract(target), "Address: call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.call{value: value}(data);
307         return verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but performing a static call.
313      *
314      * _Available since v3.3._
315      */
316     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
317         return functionStaticCall(target, data, "Address: low-level static call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal view returns (bytes memory) {
331         require(isContract(target), "Address: static call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.staticcall(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a delegate call.
340      *
341      * _Available since v3.4._
342      */
343     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(isContract(target), "Address: delegate call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.delegatecall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
366      * revert reason using the provided one.
367      *
368      * _Available since v4.3._
369      */
370     function verifyCallResult(
371         bool success,
372         bytes memory returndata,
373         string memory errorMessage
374     ) internal pure returns (bytes memory) {
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @title ERC721 token receiver interface
402  * @dev Interface for any contract that wants to support safeTransfers
403  * from ERC721 asset contracts.
404  */
405 interface IERC721Receiver {
406     /**
407      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
408      * by `operator` from `from`, this function is called.
409      *
410      * It must return its Solidity selector to confirm the token transfer.
411      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
412      *
413      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
414      */
415     function onERC721Received(
416         address operator,
417         address from,
418         uint256 tokenId,
419         bytes calldata data
420     ) external returns (bytes4);
421 }
422 
423 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Interface of the ERC165 standard, as defined in the
432  * https://eips.ethereum.org/EIPS/eip-165[EIP].
433  *
434  * Implementers can declare support of contract interfaces, which can then be
435  * queried by others ({ERC165Checker}).
436  *
437  * For an implementation, see {ERC165}.
438  */
439 interface IERC165 {
440     /**
441      * @dev Returns true if this contract implements the interface defined by
442      * `interfaceId`. See the corresponding
443      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
444      * to learn more about how these ids are created.
445      *
446      * This function call must use less than 30 000 gas.
447      */
448     function supportsInterface(bytes4 interfaceId) external view returns (bool);
449 }
450 
451 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 
459 /**
460  * @dev Implementation of the {IERC165} interface.
461  *
462  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
463  * for the additional interface id that will be supported. For example:
464  *
465  * ```solidity
466  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
467  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
468  * }
469  * ```
470  *
471  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
472  */
473 abstract contract ERC165 is IERC165 {
474     /**
475      * @dev See {IERC165-supportsInterface}.
476      */
477     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478         return interfaceId == type(IERC165).interfaceId;
479     }
480 }
481 
482 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 
490 /**
491  * @dev Required interface of an ERC721 compliant contract.
492  */
493 interface IERC721 is IERC165 {
494     /**
495      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
496      */
497     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
498 
499     /**
500      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
501      */
502     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
506      */
507     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
508 
509     /**
510      * @dev Returns the number of tokens in ``owner``'s account.
511      */
512     function balanceOf(address owner) external view returns (uint256 balance);
513 
514     /**
515      * @dev Returns the owner of the `tokenId` token.
516      *
517      * Requirements:
518      *
519      * - `tokenId` must exist.
520      */
521     function ownerOf(uint256 tokenId) external view returns (address owner);
522 
523     /**
524      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
525      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must exist and be owned by `from`.
532      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
533      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
534      *
535      * Emits a {Transfer} event.
536      */
537     function safeTransferFrom(
538         address from,
539         address to,
540         uint256 tokenId
541     ) external;
542 
543     /**
544      * @dev Transfers `tokenId` token from `from` to `to`.
545      *
546      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
547      *
548      * Requirements:
549      *
550      * - `from` cannot be the zero address.
551      * - `to` cannot be the zero address.
552      * - `tokenId` token must be owned by `from`.
553      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
554      *
555      * Emits a {Transfer} event.
556      */
557     function transferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) external;
562 
563     /**
564      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
565      * The approval is cleared when the token is transferred.
566      *
567      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
568      *
569      * Requirements:
570      *
571      * - The caller must own the token or be an approved operator.
572      * - `tokenId` must exist.
573      *
574      * Emits an {Approval} event.
575      */
576     function approve(address to, uint256 tokenId) external;
577 
578     /**
579      * @dev Returns the account approved for `tokenId` token.
580      *
581      * Requirements:
582      *
583      * - `tokenId` must exist.
584      */
585     function getApproved(uint256 tokenId) external view returns (address operator);
586 
587     /**
588      * @dev Approve or remove `operator` as an operator for the caller.
589      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
590      *
591      * Requirements:
592      *
593      * - The `operator` cannot be the caller.
594      *
595      * Emits an {ApprovalForAll} event.
596      */
597     function setApprovalForAll(address operator, bool _approved) external;
598 
599     /**
600      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
601      *
602      * See {setApprovalForAll}
603      */
604     function isApprovedForAll(address owner, address operator) external view returns (bool);
605 
606     /**
607      * @dev Safely transfers `tokenId` token from `from` to `to`.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId,
623         bytes calldata data
624     ) external;
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 
635 /**
636  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
637  * @dev See https://eips.ethereum.org/EIPS/eip-721
638  */
639 interface IERC721Enumerable is IERC721 {
640     /**
641      * @dev Returns the total amount of tokens stored by the contract.
642      */
643     function totalSupply() external view returns (uint256);
644 
645     /**
646      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
647      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
648      */
649     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
650 
651     /**
652      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
653      * Use along with {totalSupply} to enumerate all tokens.
654      */
655     function tokenByIndex(uint256 index) external view returns (uint256);
656 }
657 
658 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
668  * @dev See https://eips.ethereum.org/EIPS/eip-721
669  */
670 interface IERC721Metadata is IERC721 {
671     /**
672      * @dev Returns the token collection name.
673      */
674     function name() external view returns (string memory);
675 
676     /**
677      * @dev Returns the token collection symbol.
678      */
679     function symbol() external view returns (string memory);
680 
681     /**
682      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
683      */
684     function tokenURI(uint256 tokenId) external view returns (string memory);
685 }
686 
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
693  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
694  *
695  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
696  *
697  * Does not support burning tokens to address(0).
698  *
699  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
700  */
701 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
702     using Address for address;
703     using Strings for uint256;
704 
705     struct TokenOwnership {
706         address addr;
707         uint64 startTimestamp;
708     }
709 
710     struct AddressData {
711         uint128 balance;
712         uint128 numberMinted;
713     }
714 
715     uint256 internal currentIndex = 0;
716 
717     uint256 internal immutable maxBatchSize;
718 
719     // Token name
720     string private _name;
721 
722     // Token symbol
723     string private _symbol;
724 
725     // Mapping from token ID to ownership details
726     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
727     mapping(uint256 => TokenOwnership) internal _ownerships;
728 
729     // Mapping owner address to address data
730     mapping(address => AddressData) private _addressData;
731 
732     // Mapping from token ID to approved address
733     mapping(uint256 => address) private _tokenApprovals;
734 
735     // Mapping from owner to operator approvals
736     mapping(address => mapping(address => bool)) private _operatorApprovals;
737 
738     /**
739      * @dev
740      * `maxBatchSize` refers to how much a minter can mint at a time.
741      */
742     constructor(
743         string memory name_,
744         string memory symbol_,
745         uint256 maxBatchSize_
746     ) {
747         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
748         _name = name_;
749         _symbol = symbol_;
750         maxBatchSize = maxBatchSize_;
751     }
752 
753     /**
754      * @dev See {IERC721Enumerable-totalSupply}.
755      */
756     function totalSupply() public view override returns (uint256) {
757         return currentIndex;
758     }
759 
760     /**
761      * @dev See {IERC721Enumerable-tokenByIndex}.
762      */
763     function tokenByIndex(uint256 index) public view override returns (uint256) {
764         require(index < totalSupply(), 'ERC721A: global index out of bounds');
765         return index;
766     }
767 
768     /**
769      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
770      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
771      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
772      */
773     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
774         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
775         uint256 numMintedSoFar = totalSupply();
776         uint256 tokenIdsIdx = 0;
777         address currOwnershipAddr = address(0);
778         for (uint256 i = 0; i < numMintedSoFar; i++) {
779             TokenOwnership memory ownership = _ownerships[i];
780             if (ownership.addr != address(0)) {
781                 currOwnershipAddr = ownership.addr;
782             }
783             if (currOwnershipAddr == owner) {
784                 if (tokenIdsIdx == index) {
785                     return i;
786                 }
787                 tokenIdsIdx++;
788             }
789         }
790         revert('ERC721A: unable to get token of owner by index');
791     }
792 
793     /**
794      * @dev See {IERC165-supportsInterface}.
795      */
796     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
797         return
798             interfaceId == type(IERC721).interfaceId ||
799             interfaceId == type(IERC721Metadata).interfaceId ||
800             interfaceId == type(IERC721Enumerable).interfaceId ||
801             super.supportsInterface(interfaceId);
802     }
803 
804     /**
805      * @dev See {IERC721-balanceOf}.
806      */
807     function balanceOf(address owner) public view override returns (uint256) {
808         require(owner != address(0), 'ERC721A: balance query for the zero address');
809         return uint256(_addressData[owner].balance);
810     }
811 
812     function _numberMinted(address owner) internal view returns (uint256) {
813         require(owner != address(0), 'ERC721A: number minted query for the zero address');
814         return uint256(_addressData[owner].numberMinted);
815     }
816 
817     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
818         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
819 
820         uint256 lowestTokenToCheck;
821         if (tokenId >= maxBatchSize) {
822             lowestTokenToCheck = tokenId - maxBatchSize + 1;
823         }
824 
825         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
826             TokenOwnership memory ownership = _ownerships[curr];
827             if (ownership.addr != address(0)) {
828                 return ownership;
829             }
830         }
831 
832         revert('ERC721A: unable to determine the owner of token');
833     }
834 
835     /**
836      * @dev See {IERC721-ownerOf}.
837      */
838     function ownerOf(uint256 tokenId) public view override returns (address) {
839         return ownershipOf(tokenId).addr;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
860         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
861 
862         string memory baseURI = _baseURI();
863         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
864     }
865 
866     /**
867      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
868      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
869      * by default, can be overriden in child contracts.
870      */
871     function _baseURI() internal view virtual returns (string memory) {
872         return '';
873     }
874 
875     /**
876      * @dev See {IERC721-approve}.
877      */
878     function approve(address to, uint256 tokenId) public override {
879         address owner = ERC721A.ownerOf(tokenId);
880         require(to != owner, 'ERC721A: approval to current owner');
881 
882         require(
883             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
884             'ERC721A: approve caller is not owner nor approved for all'
885         );
886 
887         _approve(to, tokenId, owner);
888     }
889 
890     /**
891      * @dev See {IERC721-getApproved}.
892      */
893     function getApproved(uint256 tokenId) public view override returns (address) {
894         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
895 
896         return _tokenApprovals[tokenId];
897     }
898 
899     /**
900      * @dev See {IERC721-setApprovalForAll}.
901      */
902     function setApprovalForAll(address operator, bool approved) public override {
903         require(operator != _msgSender(), 'ERC721A: approve to caller');
904 
905         _operatorApprovals[_msgSender()][operator] = approved;
906         emit ApprovalForAll(_msgSender(), operator, approved);
907     }
908 
909     /**
910      * @dev See {IERC721-isApprovedForAll}.
911      */
912     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
913         return _operatorApprovals[owner][operator];
914     }
915 
916     /**
917      * @dev See {IERC721-transferFrom}.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public override {
924         _transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public override {
935         safeTransferFrom(from, to, tokenId, '');
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) public override {
947         _transfer(from, to, tokenId);
948         require(
949             _checkOnERC721Received(from, to, tokenId, _data),
950             'ERC721A: transfer to non ERC721Receiver implementer'
951         );
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      */
961     function _exists(uint256 tokenId) internal view returns (bool) {
962         return tokenId < currentIndex;
963     }
964 
965     function _safeMint(address to, uint256 quantity) internal {
966         _safeMint(to, quantity, '');
967     }
968 
969     /**
970      * @dev Mints `quantity` tokens and transfers them to `to`.
971      *
972      * Requirements:
973      *
974      * - `to` cannot be the zero address.
975      * - `quantity` cannot be larger than the max batch size.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _safeMint(
980         address to,
981         uint256 quantity,
982         bytes memory _data
983     ) internal {
984         uint256 startTokenId = currentIndex;
985         require(to != address(0), 'ERC721A: mint to the zero address');
986         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
987         require(!_exists(startTokenId), 'ERC721A: token already minted');
988         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
989         require(quantity > 0, 'ERC721A: quantity must be greater 0');
990 
991         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
992 
993         AddressData memory addressData = _addressData[to];
994         _addressData[to] = AddressData(
995             addressData.balance + uint128(quantity),
996             addressData.numberMinted + uint128(quantity)
997         );
998         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
999 
1000         uint256 updatedIndex = startTokenId;
1001 
1002         for (uint256 i = 0; i < quantity; i++) {
1003             emit Transfer(address(0), to, updatedIndex);
1004             require(
1005                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1006                 'ERC721A: transfer to non ERC721Receiver implementer'
1007             );
1008             updatedIndex++;
1009         }
1010 
1011         currentIndex = updatedIndex;
1012         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _transfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) private {
1030         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1031 
1032         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1033             getApproved(tokenId) == _msgSender() ||
1034             isApprovedForAll(prevOwnership.addr, _msgSender()));
1035 
1036         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1037 
1038         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1039         require(to != address(0), 'ERC721A: transfer to the zero address');
1040 
1041         _beforeTokenTransfers(from, to, tokenId, 1);
1042 
1043         // Clear approvals from the previous owner
1044         _approve(address(0), tokenId, prevOwnership.addr);
1045 
1046         // Underflow of the sender's balance is impossible because we check for
1047         // ownership above and the recipient's balance can't realistically overflow.
1048         unchecked {
1049             _addressData[from].balance -= 1;
1050             _addressData[to].balance += 1;
1051         }
1052 
1053         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1054 
1055         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1056         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1057         uint256 nextTokenId = tokenId + 1;
1058         if (_ownerships[nextTokenId].addr == address(0)) {
1059             if (_exists(nextTokenId)) {
1060                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1061             }
1062         }
1063 
1064         emit Transfer(from, to, tokenId);
1065         _afterTokenTransfers(from, to, tokenId, 1);
1066     }
1067 
1068     /**
1069      * @dev Approve `to` to operate on `tokenId`
1070      *
1071      * Emits a {Approval} event.
1072      */
1073     function _approve(
1074         address to,
1075         uint256 tokenId,
1076         address owner
1077     ) private {
1078         _tokenApprovals[tokenId] = to;
1079         emit Approval(owner, to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1084      * The call is not executed if the target address is not a contract.
1085      *
1086      * @param from address representing the previous owner of the given token ID
1087      * @param to target address that will receive the tokens
1088      * @param tokenId uint256 ID of the token to be transferred
1089      * @param _data bytes optional data to send along with the call
1090      * @return bool whether the call correctly returned the expected magic value
1091      */
1092     function _checkOnERC721Received(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) private returns (bool) {
1098         if (to.isContract()) {
1099             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1100                 return retval == IERC721Receiver(to).onERC721Received.selector;
1101             } catch (bytes memory reason) {
1102                 if (reason.length == 0) {
1103                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1104                 } else {
1105                     assembly {
1106                         revert(add(32, reason), mload(reason))
1107                     }
1108                 }
1109             }
1110         } else {
1111             return true;
1112         }
1113     }
1114 
1115     /**
1116      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1117      *
1118      * startTokenId - the first token id to be transferred
1119      * quantity - the amount to be transferred
1120      *
1121      * Calling conditions:
1122      *
1123      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1124      * transferred to `to`.
1125      * - When `from` is zero, `tokenId` will be minted for `to`.
1126      */
1127     function _beforeTokenTransfers(
1128         address from,
1129         address to,
1130         uint256 startTokenId,
1131         uint256 quantity
1132     ) internal virtual {}
1133 
1134     /**
1135      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1136      * minting.
1137      *
1138      * startTokenId - the first token id to be transferred
1139      * quantity - the amount to be transferred
1140      *
1141      * Calling conditions:
1142      *
1143      * - when `from` and `to` are both non-zero.
1144      * - `from` and `to` are never both zero.
1145      */
1146     function _afterTokenTransfers(
1147         address from,
1148         address to,
1149         uint256 startTokenId,
1150         uint256 quantity
1151     ) internal virtual {}
1152 }
1153 
1154 
1155 pragma solidity ^0.8.0;
1156 
1157 contract whitepage is ERC721A, Ownable {
1158   using Strings for uint256;
1159 
1160   string private uriPrefix = "";
1161   string private uriSuffix = ".json";
1162   string public hiddenMetadataUri;
1163   
1164   uint256 public price = 0 ether; 
1165   uint256 public maxSupply = 500; 
1166   uint256 public maxMintAmountPerTx = 1; 
1167   
1168   bool public paused = true;
1169   bool public revealed = false;
1170   mapping(address => uint256) public addressMintedBalance;
1171 
1172 
1173   constructor() ERC721A("whitepage", "wp", maxMintAmountPerTx) {
1174     setHiddenMetadataUri("ipfs://QmeMz67zSFPupA1mC9zeyiAQNi5kkAqcqHtEUp654by7f9");
1175   }
1176 
1177   modifier mintCompliance(uint256 _mintAmount) {
1178     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1179     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1180     _;
1181   }
1182 
1183   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1184    {
1185     require(!paused, "The contract is paused!");
1186     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1187     
1188     
1189     _safeMint(msg.sender, _mintAmount);
1190   }
1191 
1192    
1193   function whitepagetoAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1194     _safeMint(_to, _mintAmount);
1195   }
1196 
1197  
1198   function walletOfOwner(address _owner)
1199     public
1200     view
1201     returns (uint256[] memory)
1202   {
1203     uint256 ownerTokenCount = balanceOf(_owner);
1204     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1205     uint256 currentTokenId = 0;
1206     uint256 ownedTokenIndex = 0;
1207 
1208     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1209       address currentTokenOwner = ownerOf(currentTokenId);
1210 
1211       if (currentTokenOwner == _owner) {
1212         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1213 
1214         ownedTokenIndex++;
1215       }
1216 
1217       currentTokenId++;
1218     }
1219 
1220     return ownedTokenIds;
1221   }
1222 
1223   function tokenURI(uint256 _tokenId)
1224     public
1225     view
1226     virtual
1227     override
1228     returns (string memory)
1229   {
1230     require(
1231       _exists(_tokenId),
1232       "ERC721Metadata: URI query for nonexistent token"
1233     );
1234 
1235     if (revealed == false) {
1236       return hiddenMetadataUri;
1237     }
1238 
1239     string memory currentBaseURI = _baseURI();
1240     return bytes(currentBaseURI).length > 0
1241         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1242         : "";
1243   }
1244 
1245   function setRevealed(bool _state) public onlyOwner {
1246     revealed = _state;
1247   
1248   }
1249 
1250   function setPrice(uint256 _price) public onlyOwner {
1251     price = _price;
1252 
1253   }
1254  
1255   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1256     hiddenMetadataUri = _hiddenMetadataUri;
1257   }
1258 
1259 
1260 
1261   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1262     uriPrefix = _uriPrefix;
1263   }
1264 
1265   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1266     uriSuffix = _uriSuffix;
1267   }
1268 
1269   function setPaused(bool _state) public onlyOwner {
1270     paused = _state;
1271   }
1272 
1273   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1274       _safeMint(_receiver, _mintAmount);
1275   }
1276 
1277   function _baseURI() internal view virtual override returns (string memory) {
1278     return uriPrefix;
1279     
1280   }
1281 
1282     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1283     maxMintAmountPerTx = _maxMintAmountPerTx;
1284 
1285   }
1286 
1287     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1288     maxSupply = _maxSupply;
1289 
1290   }
1291 
1292 
1293   // withdrawall addresses
1294   address t1 = 0xE27976dcFB068a7a9eA1803E70651D84070Eb957; 
1295   
1296 
1297   function withdrawall() public onlyOwner {
1298         uint256 _balance = address(this).balance;
1299         
1300         require(payable(t1).send(_balance * 100 / 100 ));
1301         
1302     }
1303 
1304   function withdraw() public onlyOwner {
1305     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1306     require(os);
1307     
1308 
1309  
1310   }
1311   
1312 }