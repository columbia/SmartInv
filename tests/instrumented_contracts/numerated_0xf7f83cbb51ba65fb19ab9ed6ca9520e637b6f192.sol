1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(address from, address to, uint256 tokenId) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address from, address to, uint256 tokenId) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144       * @dev Safely transfers `tokenId` token from `from` to `to`.
145       *
146       * Requirements:
147       *
148       * - `from` cannot be the zero address.
149       * - `to` cannot be the zero address.
150       * - `tokenId` token must exist and be owned by `from`.
151       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153       *
154       * Emits a {Transfer} event.
155       */
156     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
157 }
158 
159 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
160 
161 
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @title ERC721 token receiver interface
167  * @dev Interface for any contract that wants to support safeTransfers
168  * from ERC721 asset contracts.
169  */
170 interface IERC721Receiver {
171     /**
172      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
173      * by `operator` from `from`, this function is called.
174      *
175      * It must return its Solidity selector to confirm the token transfer.
176      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
177      *
178      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
179      */
180     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
181 }
182 
183 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
184 
185 
186 
187 pragma solidity ^0.8.0;
188 
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195 
196     /**
197      * @dev Returns the token collection name.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the token collection symbol.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
208      */
209     function tokenURI(uint256 tokenId) external view returns (string memory);
210 }
211 
212 // File: @openzeppelin/contracts/utils/Address.sol
213 
214 
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @dev Collection of functions related to the address type
220  */
221 library Address {
222     /**
223      * @dev Returns true if `account` is a contract.
224      *
225      * [IMPORTANT]
226      * ====
227      * It is unsafe to assume that an address for which this function returns
228      * false is an externally-owned account (EOA) and not a contract.
229      *
230      * Among others, `isContract` will return false for the following
231      * types of addresses:
232      *
233      *  - an externally-owned account
234      *  - a contract in construction
235      *  - an address where a contract will be created
236      *  - an address where a contract lived, but was destroyed
237      * ====
238      */
239     function isContract(address account) internal view returns (bool) {
240         // This method relies on extcodesize, which returns 0 for contracts in
241         // construction, since the code is only stored at the end of the
242         // constructor execution.
243 
244         uint256 size;
245         // solhint-disable-next-line no-inline-assembly
246         assembly { size := extcodesize(account) }
247         return size > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
270         (bool success, ) = recipient.call{ value: amount }("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain`call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
293       return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, 0, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but also transferring `value` wei to `target`.
309      *
310      * Requirements:
311      *
312      * - the calling contract must have an ETH balance of at least `value`.
313      * - the called Solidity function must be `payable`.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
328         require(address(this).balance >= value, "Address: insufficient balance for call");
329         require(isContract(target), "Address: call to non-contract");
330 
331         // solhint-disable-next-line avoid-low-level-calls
332         (bool success, bytes memory returndata) = target.call{ value: value }(data);
333         return _verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         // solhint-disable-next-line avoid-low-level-calls
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return _verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.delegatecall(data);
381         return _verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts/utils/Context.sol
405 
406 
407 
408 pragma solidity ^0.8.0;
409 
410 /*
411  * @dev Provides information about the current execution context, including the
412  * sender of the transaction and its data. While these are generally available
413  * via msg.sender and msg.data, they should not be accessed in such a direct
414  * manner, since when dealing with meta-transactions the account sending and
415  * paying for execution may not be the actual sender (as far as an application
416  * is concerned).
417  *
418  * This contract is only required for intermediate, library-like contracts.
419  */
420 abstract contract Context {
421     function _msgSender() internal view virtual returns (address) {
422         return msg.sender;
423     }
424 
425     function _msgData() internal view virtual returns (bytes calldata) {
426         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
427         return msg.data;
428     }
429 }
430 
431 // File: @openzeppelin/contracts/utils/Strings.sol
432 
433 
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev String operations.
439  */
440 library Strings {
441     bytes16 private constant alphabet = "0123456789abcdef";
442 
443     /**
444      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
445      */
446     function toString(uint256 value) internal pure returns (string memory) {
447         // Inspired by OraclizeAPI's implementation - MIT licence
448         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
449 
450         if (value == 0) {
451             return "0";
452         }
453         uint256 temp = value;
454         uint256 digits;
455         while (temp != 0) {
456             digits++;
457             temp /= 10;
458         }
459         bytes memory buffer = new bytes(digits);
460         while (value != 0) {
461             digits -= 1;
462             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
463             value /= 10;
464         }
465         return string(buffer);
466     }
467 
468     /**
469      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
470      */
471     function toHexString(uint256 value) internal pure returns (string memory) {
472         if (value == 0) {
473             return "0x00";
474         }
475         uint256 temp = value;
476         uint256 length = 0;
477         while (temp != 0) {
478             length++;
479             temp >>= 8;
480         }
481         return toHexString(value, length);
482     }
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
486      */
487     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
488         bytes memory buffer = new bytes(2 * length + 2);
489         buffer[0] = "0";
490         buffer[1] = "x";
491         for (uint256 i = 2 * length + 1; i > 1; --i) {
492             buffer[i] = alphabet[value & 0xf];
493             value >>= 4;
494         }
495         require(value == 0, "Strings: hex length insufficient");
496         return string(buffer);
497     }
498 
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
502 
503 
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Implementation of the {IERC165} interface.
510  *
511  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
512  * for the additional interface id that will be supported. For example:
513  *
514  * ```solidity
515  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
517  * }
518  * ```
519  *
520  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
521  */
522 abstract contract ERC165 is IERC165 {
523     /**
524      * @dev See {IERC165-supportsInterface}.
525      */
526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527         return interfaceId == type(IERC165).interfaceId;
528     }
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
532 
533 
534 
535 
536 
537 
538 
539 
540 
541 
542 
543 
544 
545 
546 
547 
548 
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @title Counters
554  * @author Matt Condon (@shrugs)
555  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
556  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
557  *
558  * Include with `using Counters for Counters.Counter;`
559  */
560 library Counters {
561     struct Counter {
562         // This variable should never be directly accessed by users of the library: interactions must be restricted to
563         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
564         // this feature: see https://github.com/ethereum/solidity/issues/4637
565         uint256 _value; // default: 0
566     }
567 
568     function current(Counter storage counter) internal view returns (uint256) {
569         return counter._value;
570     }
571 
572     function increment(Counter storage counter) internal {
573         unchecked {
574             counter._value += 1;
575         }
576     }
577 
578     function decrement(Counter storage counter) internal {
579         uint256 value = counter._value;
580         require(value > 0, "Counter: decrement overflow");
581         unchecked {
582             counter._value = value - 1;
583         }
584     }
585 
586     function reset(Counter storage counter) internal {
587         counter._value = 0;
588     }
589 }
590 
591 // File: contracts/WithLimitedSupply.sol
592 
593 
594 pragma solidity ^0.8.0;
595 
596 
597 /// @author 1001.digital 
598 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
599 abstract contract WithLimitedSupply {
600     using Counters for Counters.Counter;
601 
602     // Keeps track of how many we have minted
603     Counters.Counter private _tokenCount;
604 
605     /// @dev The maximum count of tokens this token tracker will hold.
606     uint256 private _maxSupply;
607 
608     /// Instanciate the contract
609     /// @param totalSupply_ how many tokens this collection should hold
610     constructor (uint256 totalSupply_) {
611         _maxSupply = totalSupply_;
612     }
613 
614     /// @dev Get the max Supply
615     /// @return the maximum token count
616     function maxSupply() public view returns (uint256) {
617         return _maxSupply;
618     }
619 
620     /// @dev Get the current token count
621     /// @return the created token count
622     function tokenCount() public view returns (uint256) {
623         return _tokenCount.current();
624     }
625 
626     /// @dev Check whether tokens are still available
627     /// @return the available token count
628     function availableTokenCount() public view returns (uint256) {
629         return maxSupply() - tokenCount();
630     }
631 
632     /// @dev Increment the token count and fetch the latest count
633     /// @return the next token id
634     function nextToken() internal virtual ensureAvailability returns (uint256) {
635         uint256 token = _tokenCount.current();
636 
637         _tokenCount.increment();
638 
639         return token;
640     }
641 
642     /// @dev Check whether another token is still available
643     modifier ensureAvailability() {
644         require(availableTokenCount() > 0, "No more tokens available");
645         _;
646     }
647 
648     /// @param amount Check whether number of tokens are still available
649     /// @dev Check whether tokens are still available
650     modifier ensureAvailabilityFor(uint256 amount) {
651         require(availableTokenCount() >= amount, "Requested number of tokens not available");
652         _;
653     }
654 }
655 // File: contracts/RandomlyAssigned.sol
656 
657 
658 pragma solidity ^0.8.0;
659 
660 
661 /// @author 1001.digital
662 /// @title Randomly assign tokenIDs from a given set of tokens.
663 abstract contract RandomlyAssigned is WithLimitedSupply {
664     // Used for random index assignment
665     mapping(uint256 => uint256) private tokenMatrix;
666 
667     // The initial token ID
668     uint256 private startFrom;
669 
670     /// Instanciate the contract
671     /// @param _maxSupply how many tokens this collection should hold
672     /// @param _startFrom the tokenID with which to start counting
673     constructor (uint256 _maxSupply, uint256 _startFrom)
674         WithLimitedSupply(_maxSupply)
675     {
676         startFrom = _startFrom;
677     }
678 
679     /// Get the next token ID
680     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
681     /// @return the next token ID
682     function nextToken() internal override ensureAvailability returns (uint256) {
683         uint256 maxIndex = maxSupply() - tokenCount();
684         uint256 random = uint256(keccak256(
685             abi.encodePacked(
686                 msg.sender,
687                 block.coinbase,
688                 block.difficulty,
689                 block.gaslimit,
690                 block.timestamp
691             )
692         )) % maxIndex;
693 
694         uint256 value = 0;
695         if (tokenMatrix[random] == 0) {
696             // If this matrix position is empty, set the value to the generated random number.
697             value = random;
698         } else {
699             // Otherwise, use the previously stored number from the matrix.
700             value = tokenMatrix[random];
701         }
702 
703         // If the last available tokenID is still unused...
704         if (tokenMatrix[maxIndex - 1] == 0) {
705             // ...store that ID in the current matrix position.
706             tokenMatrix[random] = maxIndex - 1;
707         } else {
708             // ...otherwise copy over the stored number to the current matrix position.
709             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
710         }
711 
712         // Increment counts
713         super.nextToken();
714 
715         return value + startFrom;
716     }
717 }
718 
719 
720 
721 
722 
723 
724 
725 
726 
727 
728 
729 
730 
731 
732 
733 
734 
735 pragma solidity ^0.8.0;
736 
737 
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata extension, but not including the Enumerable extension, which is available separately as
742  * {ERC721Enumerable}.
743  */
744 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
745     using Address for address;
746     using Strings for uint256;
747 
748     // Token name
749     string private _name;
750 
751     // Token symbol
752     string private _symbol;
753 
754     // Mapping from token ID to owner address
755     mapping (uint256 => address) private _owners;
756 
757     // Mapping owner address to token count
758     mapping (address => uint256) private _balances;
759 
760     // Mapping from token ID to approved address
761     mapping (uint256 => address) private _tokenApprovals;
762 
763     // Mapping from owner to operator approvals
764     mapping (address => mapping (address => bool)) private _operatorApprovals;
765 
766     /**
767      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
768      */
769     constructor (string memory name_, string memory symbol_) {
770         _name = name_;
771         _symbol = symbol_;
772     }
773 
774     /**
775      * @dev See {IERC165-supportsInterface}.
776      */
777     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
778         return interfaceId == type(IERC721).interfaceId
779             || interfaceId == type(IERC721Metadata).interfaceId
780             || super.supportsInterface(interfaceId);
781     }
782 
783     /**
784      * @dev See {IERC721-balanceOf}.
785      */
786     function balanceOf(address owner) public view virtual override returns (uint256) {
787         require(owner != address(0), "ERC721: balance query for the zero address");
788         return _balances[owner];
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
795         address owner = _owners[tokenId];
796         require(owner != address(0), "ERC721: owner query for nonexistent token");
797         return owner;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-name}.
802      */
803     function name() public view virtual override returns (string memory) {
804         return _name;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-symbol}.
809      */
810     function symbol() public view virtual override returns (string memory) {
811         return _symbol;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-tokenURI}.
816      */
817     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
818         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
819 
820         string memory baseURI = _baseURI();
821         return bytes(baseURI).length > 0
822             ? string(abi.encodePacked(baseURI, tokenId.toString()))
823             : '';
824     }
825 
826     /**
827      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
828      * in child contracts.
829      */
830     function _baseURI() internal view virtual returns (string memory) {
831         return "";
832     }
833 
834     /**
835      * @dev See {IERC721-approve}.
836      */
837     function approve(address to, uint256 tokenId) public virtual override {
838         address owner = ERC721.ownerOf(tokenId);
839         require(to != owner, "ERC721: approval to current owner");
840 
841         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
842             "ERC721: approve caller is not owner nor approved for all"
843         );
844 
845         _approve(to, tokenId);
846     }
847 
848     /**
849      * @dev See {IERC721-getApproved}.
850      */
851     function getApproved(uint256 tokenId) public view virtual override returns (address) {
852         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
853 
854         return _tokenApprovals[tokenId];
855     }
856 
857     /**
858      * @dev See {IERC721-setApprovalForAll}.
859      */
860     function setApprovalForAll(address operator, bool approved) public virtual override {
861         require(operator != _msgSender(), "ERC721: approve to caller");
862 
863         _operatorApprovals[_msgSender()][operator] = approved;
864         emit ApprovalForAll(_msgSender(), operator, approved);
865     }
866 
867     /**
868      * @dev See {IERC721-isApprovedForAll}.
869      */
870     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
871         return _operatorApprovals[owner][operator];
872     }
873 
874     /**
875      * @dev See {IERC721-transferFrom}.
876      */
877     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
878         //solhint-disable-next-line max-line-length
879         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
880 
881         _transfer(from, to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
888         safeTransferFrom(from, to, tokenId, "");
889     }
890 
891     /**
892      * @dev See {IERC721-safeTransferFrom}.
893      */
894     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
895         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
896         _safeTransfer(from, to, tokenId, _data);
897     }
898 
899     /**
900      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
901      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
902      *
903      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
904      *
905      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
906      * implement alternative mechanisms to perform token transfer, such as signature-based.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
918         _transfer(from, to, tokenId);
919         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
920     }
921 
922     /**
923      * @dev Returns whether `tokenId` exists.
924      *
925      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
926      *
927      * Tokens start existing when they are minted (`_mint`),
928      * and stop existing when they are burned (`_burn`).
929      */
930     function _exists(uint256 tokenId) internal view virtual returns (bool) {
931         return _owners[tokenId] != address(0);
932     }
933 
934     /**
935      * @dev Returns whether `spender` is allowed to manage `tokenId`.
936      *
937      * Requirements:
938      *
939      * - `tokenId` must exist.
940      */
941     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
942         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
943         address owner = ERC721.ownerOf(tokenId);
944         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
945     }
946 
947     /**
948      * @dev Safely mints `tokenId` and transfers it to `to`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(address to, uint256 tokenId) internal virtual {
958         _safeMint(to, tokenId, "");
959     }
960 
961     /**
962      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
963      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
964      */
965     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
966         _mint(to, tokenId);
967         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
968     }
969 
970     /**
971      * @dev Mints `tokenId` and transfers it to `to`.
972      *
973      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
974      *
975      * Requirements:
976      *
977      * - `tokenId` must not exist.
978      * - `to` cannot be the zero address.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _mint(address to, uint256 tokenId) internal virtual {
983         require(to != address(0), "ERC721: mint to the zero address");
984         require(!_exists(tokenId), "ERC721: token already minted");
985 
986         _beforeTokenTransfer(address(0), to, tokenId);
987 
988         _balances[to] += 1;
989         _owners[tokenId] = to;
990 
991         emit Transfer(address(0), to, tokenId);
992     }
993 
994     /**
995      * @dev Destroys `tokenId`.
996      * The approval is cleared when the token is burned.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _burn(uint256 tokenId) internal virtual {
1005         address owner = ERC721.ownerOf(tokenId);
1006 
1007         _beforeTokenTransfer(owner, address(0), tokenId);
1008 
1009         // Clear approvals
1010         _approve(address(0), tokenId);
1011 
1012         _balances[owner] -= 1;
1013         delete _owners[tokenId];
1014 
1015         emit Transfer(owner, address(0), tokenId);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1030         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1031         require(to != address(0), "ERC721: transfer to the zero address");
1032 
1033         _beforeTokenTransfer(from, to, tokenId);
1034 
1035         // Clear approvals from the previous owner
1036         _approve(address(0), tokenId);
1037 
1038         _balances[from] -= 1;
1039         _balances[to] += 1;
1040         _owners[tokenId] = to;
1041 
1042         emit Transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Approve `to` to operate on `tokenId`
1047      *
1048      * Emits a {Approval} event.
1049      */
1050     function _approve(address to, uint256 tokenId) internal virtual {
1051         _tokenApprovals[tokenId] = to;
1052         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1057      * The call is not executed if the target address is not a contract.
1058      *
1059      * @param from address representing the previous owner of the given token ID
1060      * @param to target address that will receive the tokens
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @param _data bytes optional data to send along with the call
1063      * @return bool whether the call correctly returned the expected magic value
1064      */
1065     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1066         private returns (bool)
1067     {
1068         if (to.isContract()) {
1069             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1070                 return retval == IERC721Receiver(to).onERC721Received.selector;
1071             } catch (bytes memory reason) {
1072                 if (reason.length == 0) {
1073                     revert("ERC721: transfer to non ERC721Receiver implementer");
1074                 } else {
1075                     // solhint-disable-next-line no-inline-assembly
1076                     assembly {
1077                         revert(add(32, reason), mload(reason))
1078                     }
1079                 }
1080             }
1081         } else {
1082             return true;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before any token transfer. This includes minting
1088      * and burning.
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` will be minted for `to`.
1095      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1096      * - `from` cannot be the zero address.
1097      * - `to` cannot be the zero address.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1102 }
1103 
1104 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1105 
1106 
1107 
1108 pragma solidity ^0.8.0;
1109 
1110 
1111 /**
1112  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1113  * @dev See https://eips.ethereum.org/EIPS/eip-721
1114  */
1115 interface IERC721Enumerable is IERC721 {
1116 
1117     /**
1118      * @dev Returns the total amount of tokens stored by the contract.
1119      */
1120     function totalSupply() external view returns (uint256);
1121 
1122     /**
1123      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1124      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1125      */
1126     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1127 
1128     /**
1129      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1130      * Use along with {totalSupply} to enumerate all tokens.
1131      */
1132     function tokenByIndex(uint256 index) external view returns (uint256);
1133 }
1134 
1135 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1136 
1137 
1138 
1139 pragma solidity ^0.8.0;
1140 
1141 
1142 
1143 /**
1144  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1145  * enumerability of all the token ids in the contract as well as all token ids owned by each
1146  * account.
1147  */
1148 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1149     // Mapping from owner to list of owned token IDs
1150     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1151 
1152     // Mapping from token ID to index of the owner tokens list
1153     mapping(uint256 => uint256) private _ownedTokensIndex;
1154 
1155     // Array with all token ids, used for enumeration
1156     uint256[] private _allTokens;
1157 
1158     // Mapping from token id to position in the allTokens array
1159     mapping(uint256 => uint256) private _allTokensIndex;
1160 
1161     /**
1162      * @dev See {IERC165-supportsInterface}.
1163      */
1164     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1165         return interfaceId == type(IERC721Enumerable).interfaceId
1166             || super.supportsInterface(interfaceId);
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1171      */
1172     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1173         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1174         return _ownedTokens[owner][index];
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Enumerable-totalSupply}.
1179      */
1180     function totalSupply() public view virtual override returns (uint256) {
1181         return _allTokens.length;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Enumerable-tokenByIndex}.
1186      */
1187     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1188         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1189         return _allTokens[index];
1190     }
1191 
1192     /**
1193      * @dev Hook that is called before any token transfer. This includes minting
1194      * and burning.
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1202      * - `from` cannot be the zero address.
1203      * - `to` cannot be the zero address.
1204      *
1205      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1206      */
1207     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1208         super._beforeTokenTransfer(from, to, tokenId);
1209 
1210         if (from == address(0)) {
1211             _addTokenToAllTokensEnumeration(tokenId);
1212         } else if (from != to) {
1213             _removeTokenFromOwnerEnumeration(from, tokenId);
1214         }
1215         if (to == address(0)) {
1216             _removeTokenFromAllTokensEnumeration(tokenId);
1217         } else if (to != from) {
1218             _addTokenToOwnerEnumeration(to, tokenId);
1219         }
1220     }
1221 
1222     /**
1223      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1224      * @param to address representing the new owner of the given token ID
1225      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1226      */
1227     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1228         uint256 length = ERC721.balanceOf(to);
1229         _ownedTokens[to][length] = tokenId;
1230         _ownedTokensIndex[tokenId] = length;
1231     }
1232 
1233     /**
1234      * @dev Private function to add a token to this extension's token tracking data structures.
1235      * @param tokenId uint256 ID of the token to be added to the tokens list
1236      */
1237     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1238         _allTokensIndex[tokenId] = _allTokens.length;
1239         _allTokens.push(tokenId);
1240     }
1241 
1242     /**
1243      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1244      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1245      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1246      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1247      * @param from address representing the previous owner of the given token ID
1248      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1249      */
1250     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1251         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1252         // then delete the last slot (swap and pop).
1253 
1254         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1255         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1256 
1257         // When the token to delete is the last token, the swap operation is unnecessary
1258         if (tokenIndex != lastTokenIndex) {
1259             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1260 
1261             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1262             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1263         }
1264 
1265         // This also deletes the contents at the last position of the array
1266         delete _ownedTokensIndex[tokenId];
1267         delete _ownedTokens[from][lastTokenIndex];
1268     }
1269 
1270     /**
1271      * @dev Private function to remove a token from this extension's token tracking data structures.
1272      * This has O(1) time complexity, but alters the order of the _allTokens array.
1273      * @param tokenId uint256 ID of the token to be removed from the tokens list
1274      */
1275     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1276         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1277         // then delete the last slot (swap and pop).
1278 
1279         uint256 lastTokenIndex = _allTokens.length - 1;
1280         uint256 tokenIndex = _allTokensIndex[tokenId];
1281 
1282         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1283         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1284         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1285         uint256 lastTokenId = _allTokens[lastTokenIndex];
1286 
1287         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1288         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1289 
1290         // This also deletes the contents at the last position of the array
1291         delete _allTokensIndex[tokenId];
1292         _allTokens.pop();
1293     }
1294 }
1295 
1296 // File: @openzeppelin/contracts/access/Ownable.sol
1297 
1298 
1299 
1300 pragma solidity ^0.8.0;
1301 
1302 /**
1303  * @dev Contract module which provides a basic access control mechanism, where
1304  * there is an account (an owner) that can be granted exclusive access to
1305  * specific functions.
1306  *
1307  * By default, the owner account will be the one that deploys the contract. This
1308  * can later be changed with {transferOwnership}.
1309  *
1310  * This module is used through inheritance. It will make available the modifier
1311  * `onlyOwner`, which can be applied to your functions to restrict their use to
1312  * the owner.
1313  */
1314 abstract contract Ownable is Context {
1315     address private _owner;
1316 
1317     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1318 
1319     /**
1320      * @dev Initializes the contract setting the deployer as the initial owner.
1321      */
1322     constructor () {
1323         address msgSender = _msgSender();
1324         _owner = msgSender;
1325         emit OwnershipTransferred(address(0), msgSender);
1326     }
1327 
1328     /**
1329      * @dev Returns the address of the current owner.
1330      */
1331     function owner() public view virtual returns (address) {
1332         return _owner;
1333     }
1334 
1335     /**
1336      * @dev Throws if called by any account other than the owner.
1337      */
1338     modifier onlyOwner() {
1339         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1340         _;
1341     }
1342 
1343     /**
1344      * @dev Leaves the contract without owner. It will not be possible to call
1345      * `onlyOwner` functions anymore. Can only be called by the current owner.
1346      *
1347      * NOTE: Renouncing ownership will leave the contract without an owner,
1348      * thereby removing any functionality that is only available to the owner.
1349      */
1350     function renounceOwnership() public virtual onlyOwner {
1351         emit OwnershipTransferred(_owner, address(0));
1352         _owner = address(0);
1353     }
1354 
1355     /**
1356      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1357      * Can only be called by the current owner.
1358      */
1359     function transferOwnership(address newOwner) public virtual onlyOwner {
1360         require(newOwner != address(0), "Ownable: new owner is the zero address");
1361         emit OwnershipTransferred(_owner, newOwner);
1362         _owner = newOwner;
1363     }
1364 }
1365 
1366 
1367 // File: contracts/DraGONS.sol
1368 
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 
1373 abstract contract GONS {
1374   function ownerOf(uint256 tokenId) public virtual view returns (address);
1375   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1376   function balanceOf(address owner) external virtual view returns (uint256 balance);
1377 }
1378 
1379 contract DraGONS is ERC721Enumerable, Ownable, RandomlyAssigned {
1380 
1381   GONS private gons;
1382   uint constant public MAX_DRAGONS_MINT = 5000;
1383   uint constant public MAX_DRAGONS_AIRDROP = 904; 
1384   uint256 public constant dragonPrice = 70000000000000000; //0.07 ETH
1385 
1386   address private gonsContract = 0x984EEA281Bf65638ac6ed30C4FF7977EA7fe0433; // GONS SC
1387   bool public saleIsActive = false;
1388   bool public airdropIsActive = false;
1389   uint256 public maxDragons;
1390   string private baseURI;
1391 
1392   uint256 public totalDragonsMinted = 0;
1393   uint256 public totalDragonsAirdropped = 0; 
1394 
1395   mapping(uint256 => uint256) public mintedIDs;
1396 
1397   constructor() ERC721("DraGONS 2171", "DRAGONS") RandomlyAssigned (MAX_DRAGONS_MINT+MAX_DRAGONS_AIRDROP,0) {
1398     maxDragons = MAX_DRAGONS_MINT;
1399     gons = GONS(gonsContract);
1400   }
1401 
1402   function _baseURI() internal view override returns (string memory) {
1403     return baseURI;
1404   }
1405   
1406   function setBaseURI(string memory uri) public onlyOwner {
1407     baseURI = uri;
1408   }
1409 
1410   function flipSaleState() public onlyOwner {
1411     saleIsActive = !saleIsActive;
1412   }
1413 
1414   function flipAirdropState() public onlyOwner {
1415     airdropIsActive = !airdropIsActive;
1416   }
1417 
1418   // Shows if a GON can mint a DraGON
1419   function canMint(uint256 tokenId) view public returns (bool) {
1420         bool res = true;
1421         if (mintedIDs[tokenId] == 1){
1422             res = false;
1423         }
1424       return res;
1425   }
1426 
1427   // Returns the amount of DraGONS available to be minted
1428   function getMintableTokenNumber(address user) view public returns (uint256 mintableTokenNumber) {
1429       mintableTokenNumber = 0;
1430       for (uint256 i = 0; i < gons.balanceOf(user); i++) {
1431           uint256 tokenId = gons.tokenOfOwnerByIndex(user, i);
1432           if (canMint(tokenId))
1433               mintableTokenNumber++;
1434       }
1435       return mintableTokenNumber;
1436   }
1437 
1438 
1439   function getAvailableIDs() public view returns (uint256[] memory) {
1440       uint256[] memory availableIDs = new uint256[](MAX_DRAGONS_MINT);
1441       for (uint256 i = 0; i < MAX_DRAGONS_MINT; i++) {
1442          if (mintedIDs[i] != 1){
1443             availableIDs[i] = i;
1444          } else {
1445             availableIDs[i] = MAX_DRAGONS_MINT; 
1446          }
1447         
1448       }
1449       return availableIDs;
1450   }
1451 
1452   /**
1453     * Mint a DraGON
1454     */
1455   function mintDragon(uint256 gonsTokenId) public payable {
1456     require(saleIsActive, "The sale must be active to mint a DraGON");
1457     require(totalDragonsMinted < maxDragons, "The purchase would exceed the max supply of DraGONS");
1458     require(gonsTokenId < maxDragons, "The requested tokenId exceeds upper bound");
1459     require(gons.ownerOf(gonsTokenId) == msg.sender, "Must own the specific Gorilla Nemesis with the requested tokenId to mint this DraGON");
1460     require(dragonPrice <= msg.value, "Ether value sent is not correct");
1461     require(canMint(gonsTokenId), "DraGON already minted");
1462 
1463     uint256 mintIndex = nextToken();
1464     _safeMint(msg.sender, mintIndex);
1465      mintedIDs[gonsTokenId] = 1;
1466     totalDragonsMinted++;
1467   }
1468 
1469   /**
1470     * Mint N DraGONS
1471   */
1472   function mintNDragons(uint256 numDragons) public payable {
1473       require(saleIsActive, "The sale must be active to mint a DraGON");
1474       require(numDragons > 0, "Must mint at least one DraGON");
1475       require(totalDragonsMinted + numDragons <= MAX_DRAGONS_MINT, "The purchase would exceed the max supply of DraGONS");
1476       uint balanceGons = gons.balanceOf(msg.sender);
1477       require(balanceGons >= numDragons, "Must hold N Gorilla Nemesis to mint N DraGONS");
1478       uint256 toBeMinted = getMintableTokenNumber(msg.sender);
1479       require(toBeMinted > 0, "You must have at least one Gorilla Nemesis elegible to mint");
1480       if (toBeMinted > numDragons)
1481       {
1482           toBeMinted = numDragons;
1483       }
1484       require(dragonPrice * toBeMinted <= msg.value, "Ether value sent is not correct");
1485 
1486       uint256 minted = 0;
1487       for (uint256 i = 0; i < balanceGons; i++) {
1488           uint256 tokenId = gons.tokenOfOwnerByIndex(msg.sender, i);
1489 
1490           if (canMint(tokenId)) {
1491               uint256 mintIndex = nextToken();
1492               _safeMint(msg.sender, mintIndex);
1493               mintedIDs[tokenId] = 1;
1494               minted++;
1495               totalDragonsMinted++;
1496           }
1497           if (minted == toBeMinted) {
1498               break;
1499           }
1500       }
1501   }
1502 
1503     /**
1504      * Airdrop-phase: DraGONS assigned to MK owners [1 : 1] (500) + GONS Character owners [1 : 1] (404)
1505      * We take care of the transaction fees.
1506      */
1507     function airdropDragons(address to, uint count) public onlyOwner{
1508         require(airdropIsActive, "Airdrop-phase must be active to airdrop a DraGON");
1509         require(totalDragonsAirdropped + count <= MAX_DRAGONS_AIRDROP, "The number of dragons would exceed the maximum airdrop supply");
1510 
1511         for(uint i = 0; i < count; i++) {
1512             uint mintIndex = nextToken();
1513             _safeMint(to, mintIndex);
1514             totalDragonsAirdropped++;
1515         } 
1516     }
1517 
1518   /*
1519   * Withdraw from the contract
1520   */
1521  function withdrawAll() public payable onlyOwner {
1522         require(payable(msg.sender).send(address(this).balance));
1523     }
1524 
1525 }