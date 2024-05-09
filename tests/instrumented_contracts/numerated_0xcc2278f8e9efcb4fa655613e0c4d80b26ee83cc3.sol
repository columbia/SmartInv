1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59     uint8 private constant _ADDRESS_LENGTH = 20;
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
119      */
120     function toHexString(address addr) internal pure returns (string memory) {
121         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Context.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Provides information about the current execution context, including the
134  * sender of the transaction and its data. While these are generally available
135  * via msg.sender and msg.data, they should not be accessed in such a direct
136  * manner, since when dealing with meta-transactions the account sending and
137  * paying for execution may not be the actual sender (as far as an application
138  * is concerned).
139  *
140  * This contract is only required for intermediate, library-like contracts.
141  */
142 abstract contract Context {
143     function _msgSender() internal view virtual returns (address) {
144         return msg.sender;
145     }
146 
147     function _msgData() internal view virtual returns (bytes calldata) {
148         return msg.data;
149     }
150 }
151 
152 // File: @openzeppelin/contracts/access/Ownable.sol
153 
154 
155 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 
160 /**
161  * @dev Contract module which provides a basic access control mechanism, where
162  * there is an account (an owner) that can be granted exclusive access to
163  * specific functions.
164  *
165  * By default, the owner account will be the one that deploys the contract. This
166  * can later be changed with {transferOwnership}.
167  *
168  * This module is used through inheritance. It will make available the modifier
169  * `onlyOwner`, which can be applied to your functions to restrict their use to
170  * the owner.
171  */
172 abstract contract Ownable is Context {
173     address private _owner;
174 
175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177     /**
178      * @dev Initializes the contract setting the deployer as the initial owner.
179      */
180     constructor() {
181         _transferOwnership(_msgSender());
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         _checkOwner();
189         _;
190     }
191 
192     /**
193      * @dev Returns the address of the current owner.
194      */
195     function owner() public view virtual returns (address) {
196         return _owner;
197     }
198 
199     /**
200      * @dev Throws if the sender is not the owner.
201      */
202     function _checkOwner() internal view virtual {
203         require(owner() == _msgSender(), "Ownable: caller is not the owner");
204     }
205 
206     /**
207      * @dev Leaves the contract without owner. It will not be possible to call
208      * `onlyOwner` functions anymore. Can only be called by the current owner.
209      *
210      * NOTE: Renouncing ownership will leave the contract without an owner,
211      * thereby removing any functionality that is only available to the owner.
212      */
213     function renounceOwnership() public virtual onlyOwner {
214         _transferOwnership(address(0));
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Can only be called by the current owner.
220      */
221     function transferOwnership(address newOwner) public virtual onlyOwner {
222         require(newOwner != address(0), "Ownable: new owner is the zero address");
223         _transferOwnership(newOwner);
224     }
225 
226     /**
227      * @dev Transfers ownership of the contract to a new account (`newOwner`).
228      * Internal function without access restriction.
229      */
230     function _transferOwnership(address newOwner) internal virtual {
231         address oldOwner = _owner;
232         _owner = newOwner;
233         emit OwnershipTransferred(oldOwner, newOwner);
234     }
235 }
236 
237 // File: @openzeppelin/contracts/utils/Address.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
241 
242 pragma solidity ^0.8.1;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      *
265      * [IMPORTANT]
266      * ====
267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
268      *
269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
271      * constructor.
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize/address.code.length, which returns 0
276         // for contracts in construction, since the code is only stored at the end
277         // of the constructor execution.
278 
279         return account.code.length > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450                 /// @solidity memory-safe-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @title ERC721 token receiver interface
471  * @dev Interface for any contract that wants to support safeTransfers
472  * from ERC721 asset contracts.
473  */
474 interface IERC721Receiver {
475     /**
476      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
477      * by `operator` from `from`, this function is called.
478      *
479      * It must return its Solidity selector to confirm the token transfer.
480      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
481      *
482      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
483      */
484     function onERC721Received(
485         address operator,
486         address from,
487         uint256 tokenId,
488         bytes calldata data
489     ) external returns (bytes4);
490 }
491 
492 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev Interface of the ERC165 standard, as defined in the
501  * https://eips.ethereum.org/EIPS/eip-165[EIP].
502  *
503  * Implementers can declare support of contract interfaces, which can then be
504  * queried by others ({ERC165Checker}).
505  *
506  * For an implementation, see {ERC165}.
507  */
508 interface IERC165 {
509     /**
510      * @dev Returns true if this contract implements the interface defined by
511      * `interfaceId`. See the corresponding
512      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
513      * to learn more about how these ids are created.
514      *
515      * This function call must use less than 30 000 gas.
516      */
517     function supportsInterface(bytes4 interfaceId) external view returns (bool);
518 }
519 
520 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Implementation of the {IERC165} interface.
530  *
531  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
532  * for the additional interface id that will be supported. For example:
533  *
534  * ```solidity
535  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
537  * }
538  * ```
539  *
540  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
541  */
542 abstract contract ERC165 is IERC165 {
543     /**
544      * @dev See {IERC165-supportsInterface}.
545      */
546     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547         return interfaceId == type(IERC165).interfaceId;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
552 
553 
554 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Required interface of an ERC721 compliant contract.
561  */
562 interface IERC721 is IERC165 {
563     /**
564      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
565      */
566     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
567 
568     /**
569      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
570      */
571     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
572 
573     /**
574      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
575      */
576     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
577 
578     /**
579      * @dev Returns the number of tokens in ``owner``'s account.
580      */
581     function balanceOf(address owner) external view returns (uint256 balance);
582 
583     /**
584      * @dev Returns the owner of the `tokenId` token.
585      *
586      * Requirements:
587      *
588      * - `tokenId` must exist.
589      */
590     function ownerOf(uint256 tokenId) external view returns (address owner);
591 
592     /**
593      * @dev Safely transfers `tokenId` token from `from` to `to`.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must exist and be owned by `from`.
600      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
602      *
603      * Emits a {Transfer} event.
604      */
605     function safeTransferFrom(
606         address from,
607         address to,
608         uint256 tokenId,
609         bytes calldata data
610     ) external;
611 
612     /**
613      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
614      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId
630     ) external;
631 
632     /**
633      * @dev Transfers `tokenId` token from `from` to `to`.
634      *
635      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
636      *
637      * Requirements:
638      *
639      * - `from` cannot be the zero address.
640      * - `to` cannot be the zero address.
641      * - `tokenId` token must be owned by `from`.
642      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
643      *
644      * Emits a {Transfer} event.
645      */
646     function transferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) external;
651 
652     /**
653      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
654      * The approval is cleared when the token is transferred.
655      *
656      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
657      *
658      * Requirements:
659      *
660      * - The caller must own the token or be an approved operator.
661      * - `tokenId` must exist.
662      *
663      * Emits an {Approval} event.
664      */
665     function approve(address to, uint256 tokenId) external;
666 
667     /**
668      * @dev Approve or remove `operator` as an operator for the caller.
669      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
670      *
671      * Requirements:
672      *
673      * - The `operator` cannot be the caller.
674      *
675      * Emits an {ApprovalForAll} event.
676      */
677     function setApprovalForAll(address operator, bool _approved) external;
678 
679     /**
680      * @dev Returns the account approved for `tokenId` token.
681      *
682      * Requirements:
683      *
684      * - `tokenId` must exist.
685      */
686     function getApproved(uint256 tokenId) external view returns (address operator);
687 
688     /**
689      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
690      *
691      * See {setApprovalForAll}
692      */
693     function isApprovedForAll(address owner, address operator) external view returns (bool);
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 interface IERC721Metadata is IERC721 {
709     /**
710      * @dev Returns the token collection name.
711      */
712     function name() external view returns (string memory);
713 
714     /**
715      * @dev Returns the token collection symbol.
716      */
717     function symbol() external view returns (string memory);
718 
719     /**
720      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
721      */
722     function tokenURI(uint256 tokenId) external view returns (string memory);
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
726 
727 
728 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 
733 
734 
735 
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
755     mapping(uint256 => address) private _owners;
756 
757     // Mapping owner address to token count
758     mapping(address => uint256) private _balances;
759 
760     // Mapping from token ID to approved address
761     mapping(uint256 => address) private _tokenApprovals;
762 
763     // Mapping from owner to operator approvals
764     mapping(address => mapping(address => bool)) private _operatorApprovals;
765 
766     /**
767      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
768      */
769     constructor(string memory name_, string memory symbol_) {
770         _name = name_;
771         _symbol = symbol_;
772     }
773 
774     /**
775      * @dev See {IERC165-supportsInterface}.
776      */
777     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
778         return
779             interfaceId == type(IERC721).interfaceId ||
780             interfaceId == type(IERC721Metadata).interfaceId ||
781             super.supportsInterface(interfaceId);
782     }
783 
784     /**
785      * @dev See {IERC721-balanceOf}.
786      */
787     function balanceOf(address owner) public view virtual override returns (uint256) {
788         require(owner != address(0), "ERC721: address zero is not a valid owner");
789         return _balances[owner];
790     }
791 
792     /**
793      * @dev See {IERC721-ownerOf}.
794      */
795     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
796         address owner = _owners[tokenId];
797         require(owner != address(0), "ERC721: invalid token ID");
798         return owner;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-name}.
803      */
804     function name() public view virtual override returns (string memory) {
805         return _name;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-symbol}.
810      */
811     function symbol() public view virtual override returns (string memory) {
812         return _symbol;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-tokenURI}.
817      */
818     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
819         _requireMinted(tokenId);
820 
821         string memory baseURI = _baseURI();
822         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
823     }
824 
825     /**
826      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
827      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
828      * by default, can be overridden in child contracts.
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
841         require(
842             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
843             "ERC721: approve caller is not token owner nor approved for all"
844         );
845 
846         _approve(to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-getApproved}.
851      */
852     function getApproved(uint256 tokenId) public view virtual override returns (address) {
853         _requireMinted(tokenId);
854 
855         return _tokenApprovals[tokenId];
856     }
857 
858     /**
859      * @dev See {IERC721-setApprovalForAll}.
860      */
861     function setApprovalForAll(address operator, bool approved) public virtual override {
862         _setApprovalForAll(_msgSender(), operator, approved);
863     }
864 
865     /**
866      * @dev See {IERC721-isApprovedForAll}.
867      */
868     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
869         return _operatorApprovals[owner][operator];
870     }
871 
872     /**
873      * @dev See {IERC721-transferFrom}.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         //solhint-disable-next-line max-line-length
881         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
882 
883         _transfer(from, to, tokenId);
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public virtual override {
894         safeTransferFrom(from, to, tokenId, "");
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory data
905     ) public virtual override {
906         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
907         _safeTransfer(from, to, tokenId, data);
908     }
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
912      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
913      *
914      * `data` is additional data, it has no specified format and it is sent in call to `to`.
915      *
916      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
917      * implement alternative mechanisms to perform token transfer, such as signature-based.
918      *
919      * Requirements:
920      *
921      * - `from` cannot be the zero address.
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must exist and be owned by `from`.
924      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _safeTransfer(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory data
933     ) internal virtual {
934         _transfer(from, to, tokenId);
935         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
936     }
937 
938     /**
939      * @dev Returns whether `tokenId` exists.
940      *
941      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
942      *
943      * Tokens start existing when they are minted (`_mint`),
944      * and stop existing when they are burned (`_burn`).
945      */
946     function _exists(uint256 tokenId) internal view virtual returns (bool) {
947         return _owners[tokenId] != address(0);
948     }
949 
950     /**
951      * @dev Returns whether `spender` is allowed to manage `tokenId`.
952      *
953      * Requirements:
954      *
955      * - `tokenId` must exist.
956      */
957     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
958         address owner = ERC721.ownerOf(tokenId);
959         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
960     }
961 
962     /**
963      * @dev Safely mints `tokenId` and transfers it to `to`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must not exist.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeMint(address to, uint256 tokenId) internal virtual {
973         _safeMint(to, tokenId, "");
974     }
975 
976     /**
977      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
978      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
979      */
980     function _safeMint(
981         address to,
982         uint256 tokenId,
983         bytes memory data
984     ) internal virtual {
985         _mint(to, tokenId);
986         require(
987             _checkOnERC721Received(address(0), to, tokenId, data),
988             "ERC721: transfer to non ERC721Receiver implementer"
989         );
990     }
991 
992     /**
993      * @dev Mints `tokenId` and transfers it to `to`.
994      *
995      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
996      *
997      * Requirements:
998      *
999      * - `tokenId` must not exist.
1000      * - `to` cannot be the zero address.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _mint(address to, uint256 tokenId) internal virtual {
1005         require(to != address(0), "ERC721: mint to the zero address");
1006         require(!_exists(tokenId), "ERC721: token already minted");
1007 
1008         _beforeTokenTransfer(address(0), to, tokenId);
1009 
1010         _balances[to] += 1;
1011         _owners[tokenId] = to;
1012 
1013         emit Transfer(address(0), to, tokenId);
1014 
1015         _afterTokenTransfer(address(0), to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Destroys `tokenId`.
1020      * The approval is cleared when the token is burned.
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must exist.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _burn(uint256 tokenId) internal virtual {
1029         address owner = ERC721.ownerOf(tokenId);
1030 
1031         _beforeTokenTransfer(owner, address(0), tokenId);
1032 
1033         // Clear approvals
1034         _approve(address(0), tokenId);
1035 
1036         _balances[owner] -= 1;
1037         delete _owners[tokenId];
1038 
1039         emit Transfer(owner, address(0), tokenId);
1040 
1041         _afterTokenTransfer(owner, address(0), tokenId);
1042     }
1043 
1044     /**
1045      * @dev Transfers `tokenId` from `from` to `to`.
1046      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1047      *
1048      * Requirements:
1049      *
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) internal virtual {
1060         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1061         require(to != address(0), "ERC721: transfer to the zero address");
1062 
1063         _beforeTokenTransfer(from, to, tokenId);
1064 
1065         // Clear approvals from the previous owner
1066         _approve(address(0), tokenId);
1067 
1068         _balances[from] -= 1;
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(from, to, tokenId);
1073 
1074         _afterTokenTransfer(from, to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev Approve `to` to operate on `tokenId`
1079      *
1080      * Emits an {Approval} event.
1081      */
1082     function _approve(address to, uint256 tokenId) internal virtual {
1083         _tokenApprovals[tokenId] = to;
1084         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Approve `operator` to operate on all of `owner` tokens
1089      *
1090      * Emits an {ApprovalForAll} event.
1091      */
1092     function _setApprovalForAll(
1093         address owner,
1094         address operator,
1095         bool approved
1096     ) internal virtual {
1097         require(owner != operator, "ERC721: approve to caller");
1098         _operatorApprovals[owner][operator] = approved;
1099         emit ApprovalForAll(owner, operator, approved);
1100     }
1101 
1102     /**
1103      * @dev Reverts if the `tokenId` has not been minted yet.
1104      */
1105     function _requireMinted(uint256 tokenId) internal view virtual {
1106         require(_exists(tokenId), "ERC721: invalid token ID");
1107     }
1108 
1109     /**
1110      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1111      * The call is not executed if the target address is not a contract.
1112      *
1113      * @param from address representing the previous owner of the given token ID
1114      * @param to target address that will receive the tokens
1115      * @param tokenId uint256 ID of the token to be transferred
1116      * @param data bytes optional data to send along with the call
1117      * @return bool whether the call correctly returned the expected magic value
1118      */
1119     function _checkOnERC721Received(
1120         address from,
1121         address to,
1122         uint256 tokenId,
1123         bytes memory data
1124     ) private returns (bool) {
1125         if (to.isContract()) {
1126             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1127                 return retval == IERC721Receiver.onERC721Received.selector;
1128             } catch (bytes memory reason) {
1129                 if (reason.length == 0) {
1130                     revert("ERC721: transfer to non ERC721Receiver implementer");
1131                 } else {
1132                     /// @solidity memory-safe-assembly
1133                     assembly {
1134                         revert(add(32, reason), mload(reason))
1135                     }
1136                 }
1137             }
1138         } else {
1139             return true;
1140         }
1141     }
1142 
1143     /**
1144      * @dev Hook that is called before any token transfer. This includes minting
1145      * and burning.
1146      *
1147      * Calling conditions:
1148      *
1149      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1150      * transferred to `to`.
1151      * - When `from` is zero, `tokenId` will be minted for `to`.
1152      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1153      * - `from` and `to` are never both zero.
1154      *
1155      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1156      */
1157     function _beforeTokenTransfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) internal virtual {}
1162 
1163     /**
1164      * @dev Hook that is called after any transfer of tokens. This includes
1165      * minting and burning.
1166      *
1167      * Calling conditions:
1168      *
1169      * - when `from` and `to` are both non-zero.
1170      * - `from` and `to` are never both zero.
1171      *
1172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1173      */
1174     function _afterTokenTransfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) internal virtual {}
1179 }
1180 
1181 // File: Test4.sol
1182 
1183 
1184 
1185 
1186 pragma solidity >=0.7.0 <0.9.0;
1187 
1188 
1189 
1190 
1191 contract VampireMeta is ERC721, Ownable {
1192   using Strings for uint256;
1193   using Counters for Counters.Counter;
1194 
1195   Counters.Counter private supply;
1196 
1197   string public uriPrefix = "";
1198   string public uriSuffix = ".json";
1199   string public hiddenMetadataUri;
1200   
1201   uint256 public cost = 0 ether;
1202   uint256 public maxSupply = 2000;
1203   uint256 public maxMintAmountPerTx = 5;
1204 
1205   bool public paused = true;
1206   bool public revealed = false;
1207 
1208   constructor() ERC721("Vampire Meta", "VAMPIRE") {
1209     setHiddenMetadataUri("ipfs://QmUJyA7HSJbwkLihULXBM296uAX9WNn9W16RGPjBx45msa/hidden.json");
1210   }
1211 
1212   modifier mintCompliance(uint256 _mintAmount) {
1213     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1214     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1215     _;
1216   }
1217 
1218   function totalSupply() public view returns (uint256) {
1219     return supply.current();
1220   }
1221 
1222   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1223     require(!paused, "The contract is paused!");
1224     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1225 
1226     _mintLoop(msg.sender, _mintAmount);
1227   }
1228   
1229   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1230     _mintLoop(_receiver, _mintAmount);
1231   }
1232 
1233   function walletOfOwner(address _owner)
1234     public
1235     view
1236     returns (uint256[] memory)
1237   {
1238     uint256 ownerTokenCount = balanceOf(_owner);
1239     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1240     uint256 currentTokenId = 1;
1241     uint256 ownedTokenIndex = 0;
1242 
1243     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1244       address currentTokenOwner = ownerOf(currentTokenId);
1245 
1246       if (currentTokenOwner == _owner) {
1247         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1248 
1249         ownedTokenIndex++;
1250       }
1251 
1252       currentTokenId++;
1253     }
1254 
1255     return ownedTokenIds;
1256   }
1257 
1258   function tokenURI(uint256 _tokenId)
1259     public
1260     view
1261     virtual
1262     override
1263     returns (string memory)
1264   {
1265     require(
1266       _exists(_tokenId),
1267       "ERC721Metadata: URI query for nonexistent token"
1268     );
1269 
1270     if (revealed == false) {
1271       return hiddenMetadataUri;
1272     }
1273 
1274     string memory currentBaseURI = _baseURI();
1275     return bytes(currentBaseURI).length > 0
1276         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1277         : "";
1278   }
1279 
1280   function setRevealed(bool _state) public onlyOwner {
1281     revealed = _state;
1282   }
1283 
1284   function setCost(uint256 _cost) public onlyOwner {
1285     cost = _cost;
1286   }
1287 
1288   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1289     maxMintAmountPerTx = _maxMintAmountPerTx;
1290   }
1291 
1292   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1293     hiddenMetadataUri = _hiddenMetadataUri;
1294   }
1295 
1296   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1297     uriPrefix = _uriPrefix;
1298   }
1299 
1300   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1301     uriSuffix = _uriSuffix;
1302   }
1303 
1304   function setPaused(bool _state) public onlyOwner {
1305     paused = _state;
1306   }
1307 
1308   function withdraw() public onlyOwner {
1309     // This will pay HashLips 5% of the initial sale.
1310     
1311     // This will transfer the remaining contract balance to the owner.
1312     // Do not remove this otherwise you will not be able to withdraw the funds.
1313     // =============================================================================
1314     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1315     require(os);
1316     // =============================================================================
1317   }
1318 
1319   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1320     for (uint256 i = 0; i < _mintAmount; i++) {
1321       supply.increment();
1322       _safeMint(_receiver, supply.current());
1323     }
1324   }
1325 
1326   function _baseURI() internal view virtual override returns (string memory) {
1327     return uriPrefix;
1328   }
1329 }