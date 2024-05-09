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
501 
502 
503 
504 
505 
506 
507 
508 
509 
510 
511 
512 
513 
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @title Counters
521  * @author Matt Condon (@shrugs)
522  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
523  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
524  *
525  * Include with `using Counters for Counters.Counter;`
526  */
527 library Counters {
528     struct Counter {
529         // This variable should never be directly accessed by users of the library: interactions must be restricted to
530         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
531         // this feature: see https://github.com/ethereum/solidity/issues/4637
532         uint256 _value; // default: 0
533     }
534 
535     function current(Counter storage counter) internal view returns (uint256) {
536         return counter._value;
537     }
538 
539     function increment(Counter storage counter) internal {
540         unchecked {
541             counter._value += 1;
542         }
543     }
544 
545     function decrement(Counter storage counter) internal {
546         uint256 value = counter._value;
547         require(value > 0, "Counter: decrement overflow");
548         unchecked {
549             counter._value = value - 1;
550         }
551     }
552 
553     function reset(Counter storage counter) internal {
554         counter._value = 0;
555     }
556 }
557 
558 // File: contracts/WithLimitedSupply.sol
559 
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /// @author 1001.digital 
565 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
566 abstract contract WithLimitedSupply {
567     using Counters for Counters.Counter;
568 
569     // Keeps track of how many we have minted
570     Counters.Counter private _tokenCount;
571 
572     /// @dev The maximum count of tokens this token tracker will hold.
573     uint256 private _maxSupply;
574 
575     /// Instanciate the contract
576     /// @param totalSupply_ how many tokens this collection should hold
577     constructor (uint256 totalSupply_) {
578         _maxSupply = totalSupply_;
579     }
580 
581     /// @dev Get the max Supply
582     /// @return the maximum token count
583     function maxSupply() public view returns (uint256) {
584         return _maxSupply;
585     }
586 
587     /// @dev Get the current token count
588     /// @return the created token count
589     function tokenCount() public view returns (uint256) {
590         return _tokenCount.current();
591     }
592 
593     /// @dev Check whether tokens are still available
594     /// @return the available token count
595     function availableTokenCount() public view returns (uint256) {
596         return maxSupply() - tokenCount();
597     }
598 
599     /// @dev Increment the token count and fetch the latest count
600     /// @return the next token id
601     function nextToken() internal virtual ensureAvailability returns (uint256) {
602         uint256 token = _tokenCount.current();
603 
604         _tokenCount.increment();
605 
606         return token;
607     }
608 
609     /// @dev Check whether another token is still available
610     modifier ensureAvailability() {
611         require(availableTokenCount() > 0, "No more tokens available");
612         _;
613     }
614 
615     /// @param amount Check whether number of tokens are still available
616     /// @dev Check whether tokens are still available
617     modifier ensureAvailabilityFor(uint256 amount) {
618         require(availableTokenCount() >= amount, "Requested number of tokens not available");
619         _;
620     }
621 }
622 // File: contracts/RandomlyAssigned.sol
623 
624 
625 pragma solidity ^0.8.0;
626 
627 
628 /// @author 1001.digital
629 /// @title Randomly assign tokenIDs from a given set of tokens.
630 abstract contract RandomlyAssigned is WithLimitedSupply {
631     // Used for random index assignment
632     mapping(uint256 => uint256) private tokenMatrix;
633 
634     // The initial token ID
635     uint256 private startFrom;
636 
637     /// Instanciate the contract
638     /// @param _maxSupply how many tokens this collection should hold
639     /// @param _startFrom the tokenID with which to start counting
640     constructor (uint256 _maxSupply, uint256 _startFrom)
641         WithLimitedSupply(_maxSupply)
642     {
643         startFrom = _startFrom;
644     }
645 
646     /// Get the next token ID
647     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
648     /// @return the next token ID
649     function nextToken() internal override ensureAvailability returns (uint256) {
650         uint256 maxIndex = maxSupply() - tokenCount();
651         uint256 random = uint256(keccak256(
652             abi.encodePacked(
653                 msg.sender,
654                 block.coinbase,
655                 block.difficulty,
656                 block.gaslimit,
657                 block.timestamp
658             )
659         )) % maxIndex;
660 
661         uint256 value = 0;
662         if (tokenMatrix[random] == 0) {
663             // If this matrix position is empty, set the value to the generated random number.
664             value = random;
665         } else {
666             // Otherwise, use the previously stored number from the matrix.
667             value = tokenMatrix[random];
668         }
669 
670         // If the last available tokenID is still unused...
671         if (tokenMatrix[maxIndex - 1] == 0) {
672             // ...store that ID in the current matrix position.
673             tokenMatrix[random] = maxIndex - 1;
674         } else {
675             // ...otherwise copy over the stored number to the current matrix position.
676             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
677         }
678 
679         // Increment counts
680         super.nextToken();
681 
682         return value + startFrom;
683     }
684 }
685 
686 
687 
688 
689 
690 
691 
692 
693 
694 
695 
696 
697 
698 
699 
700 
701 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
702 
703 
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @dev Implementation of the {IERC165} interface.
710  *
711  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
712  * for the additional interface id that will be supported. For example:
713  *
714  * ```solidity
715  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
716  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
717  * }
718  * ```
719  *
720  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
721  */
722 abstract contract ERC165 is IERC165 {
723     /**
724      * @dev See {IERC165-supportsInterface}.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727         return interfaceId == type(IERC165).interfaceId;
728     }
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
732 
733 
734 
735 pragma solidity ^0.8.0;
736 
737 
738 /**
739  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
740  * the Metadata extension, but not including the Enumerable extension, which is available separately as
741  * {ERC721Enumerable}.
742  */
743 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
744     using Address for address;
745     using Strings for uint256;
746 
747     // Token name
748     string private _name;
749 
750     // Token symbol
751     string private _symbol;
752 
753     // Mapping from token ID to owner address
754     mapping (uint256 => address) private _owners;
755 
756     // Mapping owner address to token count
757     mapping (address => uint256) private _balances;
758 
759     // Mapping from token ID to approved address
760     mapping (uint256 => address) private _tokenApprovals;
761 
762     // Mapping from owner to operator approvals
763     mapping (address => mapping (address => bool)) private _operatorApprovals;
764 
765     /**
766      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
767      */
768     constructor (string memory name_, string memory symbol_) {
769         _name = name_;
770         _symbol = symbol_;
771     }
772 
773     /**
774      * @dev See {IERC165-supportsInterface}.
775      */
776     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
777         return interfaceId == type(IERC721).interfaceId
778             || interfaceId == type(IERC721Metadata).interfaceId
779             || super.supportsInterface(interfaceId);
780     }
781 
782     /**
783      * @dev See {IERC721-balanceOf}.
784      */
785     function balanceOf(address owner) public view virtual override returns (uint256) {
786         require(owner != address(0), "ERC721: balance query for the zero address");
787         return _balances[owner];
788     }
789 
790     /**
791      * @dev See {IERC721-ownerOf}.
792      */
793     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
794         address owner = _owners[tokenId];
795         require(owner != address(0), "ERC721: owner query for nonexistent token");
796         return owner;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-name}.
801      */
802     function name() public view virtual override returns (string memory) {
803         return _name;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-symbol}.
808      */
809     function symbol() public view virtual override returns (string memory) {
810         return _symbol;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-tokenURI}.
815      */
816     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
817         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
818 
819         string memory baseURI = _baseURI();
820         return bytes(baseURI).length > 0
821             ? string(abi.encodePacked(baseURI, tokenId.toString()))
822             : '';
823     }
824 
825     /**
826      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
827      * in child contracts.
828      */
829     function _baseURI() internal view virtual returns (string memory) {
830         return "";
831     }
832 
833     /**
834      * @dev See {IERC721-approve}.
835      */
836     function approve(address to, uint256 tokenId) public virtual override {
837         address owner = ERC721.ownerOf(tokenId);
838         require(to != owner, "ERC721: approval to current owner");
839 
840         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
841             "ERC721: approve caller is not owner nor approved for all"
842         );
843 
844         _approve(to, tokenId);
845     }
846 
847     /**
848      * @dev See {IERC721-getApproved}.
849      */
850     function getApproved(uint256 tokenId) public view virtual override returns (address) {
851         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
852 
853         return _tokenApprovals[tokenId];
854     }
855 
856     /**
857      * @dev See {IERC721-setApprovalForAll}.
858      */
859     function setApprovalForAll(address operator, bool approved) public virtual override {
860         require(operator != _msgSender(), "ERC721: approve to caller");
861 
862         _operatorApprovals[_msgSender()][operator] = approved;
863         emit ApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
877         //solhint-disable-next-line max-line-length
878         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
879 
880         _transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
887         safeTransferFrom(from, to, tokenId, "");
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
894         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
895         _safeTransfer(from, to, tokenId, _data);
896     }
897 
898     /**
899      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
900      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
901      *
902      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
903      *
904      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
905      * implement alternative mechanisms to perform token transfer, such as signature-based.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
917         _transfer(from, to, tokenId);
918         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
919     }
920 
921     /**
922      * @dev Returns whether `tokenId` exists.
923      *
924      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
925      *
926      * Tokens start existing when they are minted (`_mint`),
927      * and stop existing when they are burned (`_burn`).
928      */
929     function _exists(uint256 tokenId) internal view virtual returns (bool) {
930         return _owners[tokenId] != address(0);
931     }
932 
933     /**
934      * @dev Returns whether `spender` is allowed to manage `tokenId`.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      */
940     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
941         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
942         address owner = ERC721.ownerOf(tokenId);
943         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
944     }
945 
946     /**
947      * @dev Safely mints `tokenId` and transfers it to `to`.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must not exist.
952      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _safeMint(address to, uint256 tokenId) internal virtual {
957         _safeMint(to, tokenId, "");
958     }
959 
960     /**
961      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
962      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
963      */
964     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
965         _mint(to, tokenId);
966         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
967     }
968 
969     /**
970      * @dev Mints `tokenId` and transfers it to `to`.
971      *
972      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
973      *
974      * Requirements:
975      *
976      * - `tokenId` must not exist.
977      * - `to` cannot be the zero address.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _mint(address to, uint256 tokenId) internal virtual {
982         require(to != address(0), "ERC721: mint to the zero address");
983         require(!_exists(tokenId), "ERC721: token already minted");
984 
985         _beforeTokenTransfer(address(0), to, tokenId);
986 
987         _balances[to] += 1;
988         _owners[tokenId] = to;
989 
990         emit Transfer(address(0), to, tokenId);
991     }
992 
993     /**
994      * @dev Destroys `tokenId`.
995      * The approval is cleared when the token is burned.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _burn(uint256 tokenId) internal virtual {
1004         address owner = ERC721.ownerOf(tokenId);
1005 
1006         _beforeTokenTransfer(owner, address(0), tokenId);
1007 
1008         // Clear approvals
1009         _approve(address(0), tokenId);
1010 
1011         _balances[owner] -= 1;
1012         delete _owners[tokenId];
1013 
1014         emit Transfer(owner, address(0), tokenId);
1015     }
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1029         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1030         require(to != address(0), "ERC721: transfer to the zero address");
1031 
1032         _beforeTokenTransfer(from, to, tokenId);
1033 
1034         // Clear approvals from the previous owner
1035         _approve(address(0), tokenId);
1036 
1037         _balances[from] -= 1;
1038         _balances[to] += 1;
1039         _owners[tokenId] = to;
1040 
1041         emit Transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Approve `to` to operate on `tokenId`
1046      *
1047      * Emits a {Approval} event.
1048      */
1049     function _approve(address to, uint256 tokenId) internal virtual {
1050         _tokenApprovals[tokenId] = to;
1051         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1056      * The call is not executed if the target address is not a contract.
1057      *
1058      * @param from address representing the previous owner of the given token ID
1059      * @param to target address that will receive the tokens
1060      * @param tokenId uint256 ID of the token to be transferred
1061      * @param _data bytes optional data to send along with the call
1062      * @return bool whether the call correctly returned the expected magic value
1063      */
1064     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1065         private returns (bool)
1066     {
1067         if (to.isContract()) {
1068             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1069                 return retval == IERC721Receiver(to).onERC721Received.selector;
1070             } catch (bytes memory reason) {
1071                 if (reason.length == 0) {
1072                     revert("ERC721: transfer to non ERC721Receiver implementer");
1073                 } else {
1074                     // solhint-disable-next-line no-inline-assembly
1075                     assembly {
1076                         revert(add(32, reason), mload(reason))
1077                     }
1078                 }
1079             }
1080         } else {
1081             return true;
1082         }
1083     }
1084 
1085     /**
1086      * @dev Hook that is called before any token transfer. This includes minting
1087      * and burning.
1088      *
1089      * Calling conditions:
1090      *
1091      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1092      * transferred to `to`.
1093      * - When `from` is zero, `tokenId` will be minted for `to`.
1094      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1095      * - `from` cannot be the zero address.
1096      * - `to` cannot be the zero address.
1097      *
1098      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1099      */
1100     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1101 }
1102 
1103 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1104 
1105 
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Enumerable is IERC721 {
1115 
1116     /**
1117      * @dev Returns the total amount of tokens stored by the contract.
1118      */
1119     function totalSupply() external view returns (uint256);
1120 
1121     /**
1122      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1123      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1124      */
1125     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1126 
1127     /**
1128      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1129      * Use along with {totalSupply} to enumerate all tokens.
1130      */
1131     function tokenByIndex(uint256 index) external view returns (uint256);
1132 }
1133 
1134 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1135 
1136 
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 
1142 /**
1143  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1144  * enumerability of all the token ids in the contract as well as all token ids owned by each
1145  * account.
1146  */
1147 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1148     // Mapping from owner to list of owned token IDs
1149     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1150 
1151     // Mapping from token ID to index of the owner tokens list
1152     mapping(uint256 => uint256) private _ownedTokensIndex;
1153 
1154     // Array with all token ids, used for enumeration
1155     uint256[] private _allTokens;
1156 
1157     // Mapping from token id to position in the allTokens array
1158     mapping(uint256 => uint256) private _allTokensIndex;
1159 
1160     /**
1161      * @dev See {IERC165-supportsInterface}.
1162      */
1163     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1164         return interfaceId == type(IERC721Enumerable).interfaceId
1165             || super.supportsInterface(interfaceId);
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1170      */
1171     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1172         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1173         return _ownedTokens[owner][index];
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Enumerable-totalSupply}.
1178      */
1179     function totalSupply() public view virtual override returns (uint256) {
1180         return _allTokens.length;
1181     }
1182 
1183     /**
1184      * @dev See {IERC721Enumerable-tokenByIndex}.
1185      */
1186     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1187         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1188         return _allTokens[index];
1189     }
1190 
1191     /**
1192      * @dev Hook that is called before any token transfer. This includes minting
1193      * and burning.
1194      *
1195      * Calling conditions:
1196      *
1197      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1198      * transferred to `to`.
1199      * - When `from` is zero, `tokenId` will be minted for `to`.
1200      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1201      * - `from` cannot be the zero address.
1202      * - `to` cannot be the zero address.
1203      *
1204      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1205      */
1206     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1207         super._beforeTokenTransfer(from, to, tokenId);
1208 
1209         if (from == address(0)) {
1210             _addTokenToAllTokensEnumeration(tokenId);
1211         } else if (from != to) {
1212             _removeTokenFromOwnerEnumeration(from, tokenId);
1213         }
1214         if (to == address(0)) {
1215             _removeTokenFromAllTokensEnumeration(tokenId);
1216         } else if (to != from) {
1217             _addTokenToOwnerEnumeration(to, tokenId);
1218         }
1219     }
1220 
1221     /**
1222      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1223      * @param to address representing the new owner of the given token ID
1224      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1225      */
1226     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1227         uint256 length = ERC721.balanceOf(to);
1228         _ownedTokens[to][length] = tokenId;
1229         _ownedTokensIndex[tokenId] = length;
1230     }
1231 
1232     /**
1233      * @dev Private function to add a token to this extension's token tracking data structures.
1234      * @param tokenId uint256 ID of the token to be added to the tokens list
1235      */
1236     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1237         _allTokensIndex[tokenId] = _allTokens.length;
1238         _allTokens.push(tokenId);
1239     }
1240 
1241     /**
1242      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1243      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1244      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1245      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1246      * @param from address representing the previous owner of the given token ID
1247      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1248      */
1249     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1250         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1251         // then delete the last slot (swap and pop).
1252 
1253         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1254         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1255 
1256         // When the token to delete is the last token, the swap operation is unnecessary
1257         if (tokenIndex != lastTokenIndex) {
1258             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1259 
1260             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1261             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1262         }
1263 
1264         // This also deletes the contents at the last position of the array
1265         delete _ownedTokensIndex[tokenId];
1266         delete _ownedTokens[from][lastTokenIndex];
1267     }
1268 
1269     /**
1270      * @dev Private function to remove a token from this extension's token tracking data structures.
1271      * This has O(1) time complexity, but alters the order of the _allTokens array.
1272      * @param tokenId uint256 ID of the token to be removed from the tokens list
1273      */
1274     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1275         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1276         // then delete the last slot (swap and pop).
1277 
1278         uint256 lastTokenIndex = _allTokens.length - 1;
1279         uint256 tokenIndex = _allTokensIndex[tokenId];
1280 
1281         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1282         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1283         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1284         uint256 lastTokenId = _allTokens[lastTokenIndex];
1285 
1286         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1287         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1288 
1289         // This also deletes the contents at the last position of the array
1290         delete _allTokensIndex[tokenId];
1291         _allTokens.pop();
1292     }
1293 }
1294 
1295 // File: @openzeppelin/contracts/access/Ownable.sol
1296 
1297 
1298 
1299 pragma solidity ^0.8.0;
1300 
1301 /**
1302  * @dev Contract module which provides a basic access control mechanism, where
1303  * there is an account (an owner) that can be granted exclusive access to
1304  * specific functions.
1305  *
1306  * By default, the owner account will be the one that deploys the contract. This
1307  * can later be changed with {transferOwnership}.
1308  *
1309  * This module is used through inheritance. It will make available the modifier
1310  * `onlyOwner`, which can be applied to your functions to restrict their use to
1311  * the owner.
1312  */
1313 abstract contract Ownable is Context {
1314     address private _owner;
1315 
1316     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1317 
1318     /**
1319      * @dev Initializes the contract setting the deployer as the initial owner.
1320      */
1321     constructor () {
1322         address msgSender = _msgSender();
1323         _owner = msgSender;
1324         emit OwnershipTransferred(address(0), msgSender);
1325     }
1326 
1327     /**
1328      * @dev Returns the address of the current owner.
1329      */
1330     function owner() public view virtual returns (address) {
1331         return _owner;
1332     }
1333 
1334     /**
1335      * @dev Throws if called by any account other than the owner.
1336      */
1337     modifier onlyOwner() {
1338         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1339         _;
1340     }
1341 
1342     /**
1343      * @dev Leaves the contract without owner. It will not be possible to call
1344      * `onlyOwner` functions anymore. Can only be called by the current owner.
1345      *
1346      * NOTE: Renouncing ownership will leave the contract without an owner,
1347      * thereby removing any functionality that is only available to the owner.
1348      */
1349     function renounceOwnership() public virtual onlyOwner {
1350         emit OwnershipTransferred(_owner, address(0));
1351         _owner = address(0);
1352     }
1353 
1354     /**
1355      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1356      * Can only be called by the current owner.
1357      */
1358     function transferOwnership(address newOwner) public virtual onlyOwner {
1359         require(newOwner != address(0), "Ownable: new owner is the zero address");
1360         emit OwnershipTransferred(_owner, newOwner);
1361         _owner = newOwner;
1362     }
1363 }
1364 
1365 // File: contracts/AlienKimeras.sol
1366 
1367 pragma solidity ^0.8.0;
1368 
1369 
1370 abstract contract DraGONS {
1371   function ownerOf(uint256 tokenId) public virtual view returns (address);
1372   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1373   function balanceOf(address owner) external virtual view returns (uint256 balance);
1374 }
1375 
1376 abstract contract AmberToken {
1377   function burn(address _from, uint256 _amount) external virtual;
1378   function balanceOf(address owner) external virtual view returns (uint256 balance);
1379 }
1380 
1381 contract AlienKimeraProtocol is ERC721Enumerable, Ownable, RandomlyAssigned { 
1382   DraGONS private dragons;
1383 
1384   mapping(address => uint256) public lastKimera;
1385 
1386   uint constant public MAX_KIMERAS = 5000;
1387   uint256 public constant kimeraPrice = 60000000000000000000; //60 AMBER
1388 
1389   address private dragonsContract = 0xF7f83CbB51BA65FB19AB9ED6ca9520E637b6f192;
1390   bool public AkpIsActive = false;
1391   uint256 public maxKimeras;
1392   string private baseURI;
1393 
1394   AmberToken public amberToken;
1395 
1396   constructor() ERC721("Alien Kimera Protocol", "AKP") RandomlyAssigned(MAX_KIMERAS, 0) {
1397     maxKimeras = MAX_KIMERAS;
1398     dragons = DraGONS(dragonsContract);
1399   }
1400 
1401   function setAmberToken(address _amber) external onlyOwner {
1402     amberToken = AmberToken(_amber);
1403   }
1404 
1405 
1406   function _baseURI() internal view override returns (string memory) {
1407     return baseURI;
1408   }
1409   
1410   function setBaseURI(string memory uri) public onlyOwner {
1411     baseURI = uri;
1412   }
1413 
1414   function flipAkpState() public onlyOwner {
1415     AkpIsActive = !AkpIsActive;
1416   }
1417 
1418   /**
1419     * Mint an Alien Kimera
1420     */
1421   function AKProtocol() public {
1422     require(AkpIsActive, "AK Protocol must be active to mint an Alien Kimera");
1423     require(totalSupply() < maxKimeras, "Purchase would exceed the max supply of Alien Kimeras");
1424     uint balanceDraGONS = dragons.balanceOf(msg.sender);
1425     uint balanceAmberToken = amberToken.balanceOf(msg.sender);
1426     require(balanceDraGONS > 0, "Must own at least one DraGON to mint an Alien Kimera");
1427     require(balanceAmberToken >= kimeraPrice, "Insufficient amount of $AMBER");
1428     uint256 time = block.timestamp;
1429     uint256 timerUser = lastKimera[msg.sender];
1430     require(time - timerUser >= 864000, "You can mint only 1 Alien Kimera every 10 days");
1431 
1432     uint256 mintIndex = nextToken();
1433     _safeMint(msg.sender, mintIndex);
1434     amberToken.burn(msg.sender, kimeraPrice);
1435     lastKimera[msg.sender] = time;
1436   }
1437 
1438   function getLastKimera(address user) external view returns(uint256) {
1439     uint256 lastK = lastKimera[user];
1440     return lastK;
1441   }
1442 
1443 }