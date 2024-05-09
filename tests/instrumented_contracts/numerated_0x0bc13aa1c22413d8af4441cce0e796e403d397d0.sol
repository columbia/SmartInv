1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/Strings.sol
50 
51 
52 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev String operations.
58  */
59 library Strings {
60     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
61     uint8 private constant _ADDRESS_LENGTH = 20;
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
65      */
66     function toString(uint256 value) internal pure returns (string memory) {
67         // Inspired by OraclizeAPI's implementation - MIT licence
68         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
69 
70         if (value == 0) {
71             return "0";
72         }
73         uint256 temp = value;
74         uint256 digits;
75         while (temp != 0) {
76             digits++;
77             temp /= 10;
78         }
79         bytes memory buffer = new bytes(digits);
80         while (value != 0) {
81             digits -= 1;
82             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
83             value /= 10;
84         }
85         return string(buffer);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
90      */
91     function toHexString(uint256 value) internal pure returns (string memory) {
92         if (value == 0) {
93             return "0x00";
94         }
95         uint256 temp = value;
96         uint256 length = 0;
97         while (temp != 0) {
98             length++;
99             temp >>= 8;
100         }
101         return toHexString(value, length);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
106      */
107     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = _HEX_SYMBOLS[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 
119     /**
120      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
121      */
122     function toHexString(address addr) internal pure returns (string memory) {
123         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
124     }
125 }
126 
127 // File: @openzeppelin/contracts/utils/Context.sol
128 
129 
130 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Provides information about the current execution context, including the
136  * sender of the transaction and its data. While these are generally available
137  * via msg.sender and msg.data, they should not be accessed in such a direct
138  * manner, since when dealing with meta-transactions the account sending and
139  * paying for execution may not be the actual sender (as far as an application
140  * is concerned).
141  *
142  * This contract is only required for intermediate, library-like contracts.
143  */
144 abstract contract Context {
145     function _msgSender() internal view virtual returns (address) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view virtual returns (bytes calldata) {
150         return msg.data;
151     }
152 }
153 
154 // File: @openzeppelin/contracts/access/Ownable.sol
155 
156 
157 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 /**
163  * @dev Contract module which provides a basic access control mechanism, where
164  * there is an account (an owner) that can be granted exclusive access to
165  * specific functions.
166  *
167  * By default, the owner account will be the one that deploys the contract. This
168  * can later be changed with {transferOwnership}.
169  *
170  * This module is used through inheritance. It will make available the modifier
171  * `onlyOwner`, which can be applied to your functions to restrict their use to
172  * the owner.
173  */
174 abstract contract Ownable is Context {
175     address private _owner;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178 
179     /**
180      * @dev Initializes the contract setting the deployer as the initial owner.
181      */
182     constructor() {
183         _transferOwnership(_msgSender());
184     }
185 
186     /**
187      * @dev Throws if called by any account other than the owner.
188      */
189     modifier onlyOwner() {
190         _checkOwner();
191         _;
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if the sender is not the owner.
203      */
204     function _checkOwner() internal view virtual {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206     }
207 
208     /**
209      * @dev Leaves the contract without owner. It will not be possible to call
210      * `onlyOwner` functions anymore. Can only be called by the current owner.
211      *
212      * NOTE: Renouncing ownership will leave the contract without an owner,
213      * thereby removing any functionality that is only available to the owner.
214      */
215     function renounceOwnership() public virtual onlyOwner {
216         _transferOwnership(address(0));
217     }
218 
219     /**
220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
221      * Can only be called by the current owner.
222      */
223     function transferOwnership(address newOwner) public virtual onlyOwner {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         _transferOwnership(newOwner);
226     }
227 
228     /**
229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
230      * Internal function without access restriction.
231      */
232     function _transferOwnership(address newOwner) internal virtual {
233         address oldOwner = _owner;
234         _owner = newOwner;
235         emit OwnershipTransferred(oldOwner, newOwner);
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 
242 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
243 
244 pragma solidity ^0.8.1;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      *
267      * [IMPORTANT]
268      * ====
269      * You shouldn't rely on `isContract` to protect against flash loan attacks!
270      *
271      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
272      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
273      * constructor.
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // This method relies on extcodesize/address.code.length, which returns 0
278         // for contracts in construction, since the code is only stored at the end
279         // of the constructor execution.
280 
281         return account.code.length > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         (bool success, ) = recipient.call{value: amount}("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain `call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(
369         address target,
370         bytes memory data,
371         uint256 value,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         require(isContract(target), "Address: call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.call{value: value}(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
388         return functionStaticCall(target, data, "Address: low-level static call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal view returns (bytes memory) {
402         require(isContract(target), "Address: static call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.staticcall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
415         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a delegate call.
421      *
422      * _Available since v3.4._
423      */
424     function functionDelegateCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(isContract(target), "Address: delegate call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.delegatecall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
437      * revert reason using the provided one.
438      *
439      * _Available since v4.3._
440      */
441     function verifyCallResult(
442         bool success,
443         bytes memory returndata,
444         string memory errorMessage
445     ) internal pure returns (bytes memory) {
446         if (success) {
447             return returndata;
448         } else {
449             // Look for revert reason and bubble it up if present
450             if (returndata.length > 0) {
451                 // The easiest way to bubble the revert reason is using memory via assembly
452                 /// @solidity memory-safe-assembly
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
465 
466 
467 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @title ERC721 token receiver interface
473  * @dev Interface for any contract that wants to support safeTransfers
474  * from ERC721 asset contracts.
475  */
476 interface IERC721Receiver {
477     /**
478      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
479      * by `operator` from `from`, this function is called.
480      *
481      * It must return its Solidity selector to confirm the token transfer.
482      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
483      *
484      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
485      */
486     function onERC721Received(
487         address operator,
488         address from,
489         uint256 tokenId,
490         bytes calldata data
491     ) external returns (bytes4);
492 }
493 
494 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Interface of the ERC165 standard, as defined in the
503  * https://eips.ethereum.org/EIPS/eip-165[EIP].
504  *
505  * Implementers can declare support of contract interfaces, which can then be
506  * queried by others ({ERC165Checker}).
507  *
508  * For an implementation, see {ERC165}.
509  */
510 interface IERC165 {
511     /**
512      * @dev Returns true if this contract implements the interface defined by
513      * `interfaceId`. See the corresponding
514      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
515      * to learn more about how these ids are created.
516      *
517      * This function call must use less than 30 000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool);
520 }
521 
522 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Implementation of the {IERC165} interface.
532  *
533  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
534  * for the additional interface id that will be supported. For example:
535  *
536  * ```solidity
537  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
539  * }
540  * ```
541  *
542  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
543  */
544 abstract contract ERC165 is IERC165 {
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         return interfaceId == type(IERC165).interfaceId;
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
554 
555 
556 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Required interface of an ERC721 compliant contract.
563  */
564 interface IERC721 is IERC165 {
565     /**
566      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
567      */
568     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
572      */
573     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
574 
575     /**
576      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
577      */
578     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
579 
580     /**
581      * @dev Returns the number of tokens in ``owner``'s account.
582      */
583     function balanceOf(address owner) external view returns (uint256 balance);
584 
585     /**
586      * @dev Returns the owner of the `tokenId` token.
587      *
588      * Requirements:
589      *
590      * - `tokenId` must exist.
591      */
592     function ownerOf(uint256 tokenId) external view returns (address owner);
593 
594     /**
595      * @dev Safely transfers `tokenId` token from `from` to `to`.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId,
611         bytes calldata data
612     ) external;
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
616      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Transfers `tokenId` token from `from` to `to`.
636      *
637      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must be owned by `from`.
644      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
645      *
646      * Emits a {Transfer} event.
647      */
648     function transferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
656      * The approval is cleared when the token is transferred.
657      *
658      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
659      *
660      * Requirements:
661      *
662      * - The caller must own the token or be an approved operator.
663      * - `tokenId` must exist.
664      *
665      * Emits an {Approval} event.
666      */
667     function approve(address to, uint256 tokenId) external;
668 
669     /**
670      * @dev Approve or remove `operator` as an operator for the caller.
671      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
672      *
673      * Requirements:
674      *
675      * - The `operator` cannot be the caller.
676      *
677      * Emits an {ApprovalForAll} event.
678      */
679     function setApprovalForAll(address operator, bool _approved) external;
680 
681     /**
682      * @dev Returns the account approved for `tokenId` token.
683      *
684      * Requirements:
685      *
686      * - `tokenId` must exist.
687      */
688     function getApproved(uint256 tokenId) external view returns (address operator);
689 
690     /**
691      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
692      *
693      * See {setApprovalForAll}
694      */
695     function isApprovedForAll(address owner, address operator) external view returns (bool);
696 }
697 
698 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Metadata is IERC721 {
711     /**
712      * @dev Returns the token collection name.
713      */
714     function name() external view returns (string memory);
715 
716     /**
717      * @dev Returns the token collection symbol.
718      */
719     function symbol() external view returns (string memory);
720 
721     /**
722      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
723      */
724     function tokenURI(uint256 tokenId) external view returns (string memory);
725 }
726 
727 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
728 
729 
730 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 
735 
736 
737 
738 
739 
740 
741 /**
742  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
743  * the Metadata extension, but not including the Enumerable extension, which is available separately as
744  * {ERC721Enumerable}.
745  */
746 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
747     using Address for address;
748     using Strings for uint256;
749 
750     // Token name
751     string private _name;
752 
753     // Token symbol
754     string private _symbol;
755 
756     // Mapping from token ID to owner address
757     mapping(uint256 => address) private _owners;
758 
759     // Mapping owner address to token count
760     mapping(address => uint256) private _balances;
761 
762     // Mapping from token ID to approved address
763     mapping(uint256 => address) private _tokenApprovals;
764 
765     // Mapping from owner to operator approvals
766     mapping(address => mapping(address => bool)) private _operatorApprovals;
767 
768     /**
769      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
770      */
771     constructor(string memory name_, string memory symbol_) {
772         _name = name_;
773         _symbol = symbol_;
774     }
775 
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
780         return
781             interfaceId == type(IERC721).interfaceId ||
782             interfaceId == type(IERC721Metadata).interfaceId ||
783             super.supportsInterface(interfaceId);
784     }
785 
786     /**
787      * @dev See {IERC721-balanceOf}.
788      */
789     function balanceOf(address owner) public view virtual override returns (uint256) {
790         require(owner != address(0), "ERC721: address zero is not a valid owner");
791         return _balances[owner];
792     }
793 
794     /**
795      * @dev See {IERC721-ownerOf}.
796      */
797     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
798         address owner = _owners[tokenId];
799         require(owner != address(0), "ERC721: invalid token ID");
800         return owner;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-name}.
805      */
806     function name() public view virtual override returns (string memory) {
807         return _name;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-symbol}.
812      */
813     function symbol() public view virtual override returns (string memory) {
814         return _symbol;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-tokenURI}.
819      */
820     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
821         _requireMinted(tokenId);
822 
823         string memory baseURI = _baseURI();
824         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
825     }
826 
827     /**
828      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
829      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
830      * by default, can be overridden in child contracts.
831      */
832     function _baseURI() internal view virtual returns (string memory) {
833         return "";
834     }
835 
836     /**
837      * @dev See {IERC721-approve}.
838      */
839     function approve(address to, uint256 tokenId) public virtual override {
840         address owner = ERC721.ownerOf(tokenId);
841         require(to != owner, "ERC721: approval to current owner");
842 
843         require(
844             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
845             "ERC721: approve caller is not token owner nor approved for all"
846         );
847 
848         _approve(to, tokenId);
849     }
850 
851     /**
852      * @dev See {IERC721-getApproved}.
853      */
854     function getApproved(uint256 tokenId) public view virtual override returns (address) {
855         _requireMinted(tokenId);
856 
857         return _tokenApprovals[tokenId];
858     }
859 
860     /**
861      * @dev See {IERC721-setApprovalForAll}.
862      */
863     function setApprovalForAll(address operator, bool approved) public virtual override {
864         _setApprovalForAll(_msgSender(), operator, approved);
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
877     function transferFrom(
878         address from,
879         address to,
880         uint256 tokenId
881     ) public virtual override {
882         //solhint-disable-next-line max-line-length
883         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
884 
885         _transfer(from, to, tokenId);
886     }
887 
888     /**
889      * @dev See {IERC721-safeTransferFrom}.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) public virtual override {
896         safeTransferFrom(from, to, tokenId, "");
897     }
898 
899     /**
900      * @dev See {IERC721-safeTransferFrom}.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId,
906         bytes memory data
907     ) public virtual override {
908         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
909         _safeTransfer(from, to, tokenId, data);
910     }
911 
912     /**
913      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
914      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
915      *
916      * `data` is additional data, it has no specified format and it is sent in call to `to`.
917      *
918      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
919      * implement alternative mechanisms to perform token transfer, such as signature-based.
920      *
921      * Requirements:
922      *
923      * - `from` cannot be the zero address.
924      * - `to` cannot be the zero address.
925      * - `tokenId` token must exist and be owned by `from`.
926      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _safeTransfer(
931         address from,
932         address to,
933         uint256 tokenId,
934         bytes memory data
935     ) internal virtual {
936         _transfer(from, to, tokenId);
937         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
938     }
939 
940     /**
941      * @dev Returns whether `tokenId` exists.
942      *
943      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
944      *
945      * Tokens start existing when they are minted (`_mint`),
946      * and stop existing when they are burned (`_burn`).
947      */
948     function _exists(uint256 tokenId) internal view virtual returns (bool) {
949         return _owners[tokenId] != address(0);
950     }
951 
952     /**
953      * @dev Returns whether `spender` is allowed to manage `tokenId`.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      */
959     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
960         address owner = ERC721.ownerOf(tokenId);
961         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
962     }
963 
964     /**
965      * @dev Safely mints `tokenId` and transfers it to `to`.
966      *
967      * Requirements:
968      *
969      * - `tokenId` must not exist.
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _safeMint(address to, uint256 tokenId) internal virtual {
975         _safeMint(to, tokenId, "");
976     }
977 
978     /**
979      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
980      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
981      */
982     function _safeMint(
983         address to,
984         uint256 tokenId,
985         bytes memory data
986     ) internal virtual {
987         _mint(to, tokenId);
988         require(
989             _checkOnERC721Received(address(0), to, tokenId, data),
990             "ERC721: transfer to non ERC721Receiver implementer"
991         );
992     }
993 
994     /**
995      * @dev Mints `tokenId` and transfers it to `to`.
996      *
997      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - `to` cannot be the zero address.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _mint(address to, uint256 tokenId) internal virtual {
1007         require(to != address(0), "ERC721: mint to the zero address");
1008         require(!_exists(tokenId), "ERC721: token already minted");
1009 
1010         _beforeTokenTransfer(address(0), to, tokenId);
1011 
1012         _balances[to] += 1;
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(address(0), to, tokenId);
1016 
1017         _afterTokenTransfer(address(0), to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev Destroys `tokenId`.
1022      * The approval is cleared when the token is burned.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must exist.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _burn(uint256 tokenId) internal virtual {
1031         address owner = ERC721.ownerOf(tokenId);
1032 
1033         _beforeTokenTransfer(owner, address(0), tokenId);
1034 
1035         // Clear approvals
1036         _approve(address(0), tokenId);
1037 
1038         _balances[owner] -= 1;
1039         delete _owners[tokenId];
1040 
1041         emit Transfer(owner, address(0), tokenId);
1042 
1043         _afterTokenTransfer(owner, address(0), tokenId);
1044     }
1045 
1046     /**
1047      * @dev Transfers `tokenId` from `from` to `to`.
1048      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must be owned by `from`.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _transfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) internal virtual {
1062         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1063         require(to != address(0), "ERC721: transfer to the zero address");
1064 
1065         _beforeTokenTransfer(from, to, tokenId);
1066 
1067         // Clear approvals from the previous owner
1068         _approve(address(0), tokenId);
1069 
1070         _balances[from] -= 1;
1071         _balances[to] += 1;
1072         _owners[tokenId] = to;
1073 
1074         emit Transfer(from, to, tokenId);
1075 
1076         _afterTokenTransfer(from, to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `to` to operate on `tokenId`
1081      *
1082      * Emits an {Approval} event.
1083      */
1084     function _approve(address to, uint256 tokenId) internal virtual {
1085         _tokenApprovals[tokenId] = to;
1086         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Approve `operator` to operate on all of `owner` tokens
1091      *
1092      * Emits an {ApprovalForAll} event.
1093      */
1094     function _setApprovalForAll(
1095         address owner,
1096         address operator,
1097         bool approved
1098     ) internal virtual {
1099         require(owner != operator, "ERC721: approve to caller");
1100         _operatorApprovals[owner][operator] = approved;
1101         emit ApprovalForAll(owner, operator, approved);
1102     }
1103 
1104     /**
1105      * @dev Reverts if the `tokenId` has not been minted yet.
1106      */
1107     function _requireMinted(uint256 tokenId) internal view virtual {
1108         require(_exists(tokenId), "ERC721: invalid token ID");
1109     }
1110 
1111     /**
1112      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1113      * The call is not executed if the target address is not a contract.
1114      *
1115      * @param from address representing the previous owner of the given token ID
1116      * @param to target address that will receive the tokens
1117      * @param tokenId uint256 ID of the token to be transferred
1118      * @param data bytes optional data to send along with the call
1119      * @return bool whether the call correctly returned the expected magic value
1120      */
1121     function _checkOnERC721Received(
1122         address from,
1123         address to,
1124         uint256 tokenId,
1125         bytes memory data
1126     ) private returns (bool) {
1127         if (to.isContract()) {
1128             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1129                 return retval == IERC721Receiver.onERC721Received.selector;
1130             } catch (bytes memory reason) {
1131                 if (reason.length == 0) {
1132                     revert("ERC721: transfer to non ERC721Receiver implementer");
1133                 } else {
1134                     /// @solidity memory-safe-assembly
1135                     assembly {
1136                         revert(add(32, reason), mload(reason))
1137                     }
1138                 }
1139             }
1140         } else {
1141             return true;
1142         }
1143     }
1144 
1145     /**
1146      * @dev Hook that is called before any token transfer. This includes minting
1147      * and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` will be minted for `to`.
1154      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1155      * - `from` and `to` are never both zero.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _beforeTokenTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual {}
1164 
1165     /**
1166      * @dev Hook that is called after any transfer of tokens. This includes
1167      * minting and burning.
1168      *
1169      * Calling conditions:
1170      *
1171      * - when `from` and `to` are both non-zero.
1172      * - `from` and `to` are never both zero.
1173      *
1174      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1175      */
1176     function _afterTokenTransfer(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) internal virtual {}
1181 }
1182 
1183 // File: contracts/LowGas.sol
1184 
1185 
1186 
1187 // Amended by HashLips
1188 /**
1189     !Disclaimer!
1190 
1191     These contracts have been used to create tutorials,
1192     and was created for the purpose to teach people
1193     how to create smart contracts on the blockchain.
1194     please review this code on your own before using any of
1195     the following code for production.
1196     The developer will not be responsible or liable for all loss or 
1197     damage whatsoever caused by you participating in any way in the 
1198     experimental code, whether putting money into the contract or 
1199     using the code for your own project.
1200 */
1201 
1202 pragma solidity >=0.7.0 <0.9.0;
1203 
1204 
1205 
1206 
1207 contract WhalesOfEther is ERC721, Ownable {
1208   using Strings for uint256;
1209   using Counters for Counters.Counter;
1210 
1211   Counters.Counter private supply;
1212 
1213   string public uriPrefix = "";
1214   string public uriSuffix = ".json";
1215   string public hiddenMetadataUri;
1216   
1217   uint256 public cost = 0.00 ether;
1218   uint256 public maxSupply = 3333;
1219   uint256 public maxMintAmountPerTx = 5;
1220 
1221   bool public paused = true;
1222   bool public revealed = true;
1223 
1224   constructor() ERC721("Whales of Ether", "WoE") {
1225     setHiddenMetadataUri("ipfs://QmSvpvoCpjYfuPXKD327bXkAoQiAJQWVrATKXHBXjtw5kU");
1226   }
1227 
1228   modifier mintCompliance(uint256 _mintAmount) {
1229     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1230     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1231     _;
1232   }
1233 
1234   function totalSupply() public view returns (uint256) {
1235     return supply.current();
1236   }
1237 
1238   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1239     require(!paused, "The contract is paused!");
1240     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1241 
1242     _mintLoop(msg.sender, _mintAmount);
1243   }
1244   
1245   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1246     _mintLoop(_receiver, _mintAmount);
1247   }
1248 
1249   function walletOfOwner(address _owner)
1250     public
1251     view
1252     returns (uint256[] memory)
1253   {
1254     uint256 ownerTokenCount = balanceOf(_owner);
1255     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1256     uint256 currentTokenId = 1;
1257     uint256 ownedTokenIndex = 0;
1258 
1259     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1260       address currentTokenOwner = ownerOf(currentTokenId);
1261 
1262       if (currentTokenOwner == _owner) {
1263         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1264 
1265         ownedTokenIndex++;
1266       }
1267 
1268       currentTokenId++;
1269     }
1270 
1271     return ownedTokenIds;
1272   }
1273 
1274   function tokenURI(uint256 _tokenId)
1275     public
1276     view
1277     virtual
1278     override
1279     returns (string memory)
1280   {
1281     require(
1282       _exists(_tokenId),
1283       "ERC721Metadata: URI query for nonexistent token"
1284     );
1285 
1286     if (revealed == false) {
1287       return hiddenMetadataUri;
1288     }
1289 
1290     string memory currentBaseURI = _baseURI();
1291     return bytes(currentBaseURI).length > 0
1292         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1293         : "";
1294   }
1295 
1296   function setRevealed(bool _state) public onlyOwner {
1297     revealed = _state;
1298   }
1299 
1300   function setCost(uint256 _cost) public onlyOwner {
1301     cost = _cost;
1302   }
1303 
1304   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1305     maxMintAmountPerTx = _maxMintAmountPerTx;
1306   }
1307 
1308   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1309     hiddenMetadataUri = _hiddenMetadataUri;
1310   }
1311 
1312   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1313     uriPrefix = _uriPrefix;
1314   }
1315 
1316   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1317     uriSuffix = _uriSuffix;
1318   }
1319 
1320   function setPaused(bool _state) public onlyOwner {
1321     paused = _state;
1322   }
1323 
1324   function withdraw() public onlyOwner {
1325     // This will transfer the remaining contract balance to the owner.
1326     // Do not remove this otherwise you will not be able to withdraw the funds.
1327     // =============================================================================
1328     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1329     require(os);
1330     // =============================================================================
1331   }
1332 
1333   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1334     for (uint256 i = 0; i < _mintAmount; i++) {
1335       supply.increment();
1336       _safeMint(_receiver, supply.current());
1337     }
1338   }
1339 
1340   function _baseURI() internal view virtual override returns (string memory) {
1341     return uriPrefix;
1342   }
1343 }