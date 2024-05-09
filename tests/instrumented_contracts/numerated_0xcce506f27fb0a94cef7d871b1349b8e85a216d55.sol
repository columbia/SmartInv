1 /**
2 NAGA NAGA NAGA
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10 NAGA NAGA NAGA
11 */
12  
13 library Counters {
14     struct Counter {
15         // This variable should never be directly accessed by users of the library: interactions must be restricted to
16         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
17         // this feature: see https://github.com/ethereum/solidity/issues/4637
18         uint256 _value; // default: 0
19     }
20 
21     function current(Counter storage counter) internal view returns (uint256) {
22         return counter._value;
23     }
24 
25     function increment(Counter storage counter) internal {
26         unchecked {
27             counter._value += 1;
28         }
29     }
30 
31     function decrement(Counter storage counter) internal {
32         uint256 value = counter._value;
33         require(value > 0, "Counter: decrement overflow");
34         unchecked {
35             counter._value = value - 1;
36         }
37     }
38 
39     function reset(Counter storage counter) internal {
40         counter._value = 0;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/utils/Strings.sol
45 
46 
47 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
48 
49 pragma solidity ^0.8.0;
50 
51 /**
52  * @dev String operations.
53  */
54 library Strings {
55     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
56     uint8 private constant _ADDRESS_LENGTH = 20;
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 
114     /**
115      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
116      */
117     function toHexString(address addr) internal pure returns (string memory) {
118         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Context.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Provides information about the current execution context, including the
131  * sender of the transaction and its data. While these are generally available
132  * via msg.sender and msg.data, they should not be accessed in such a direct
133  * manner, since when dealing with meta-transactions the account sending and
134  * paying for execution may not be the actual sender (as far as an application
135  * is concerned).
136  *
137  * This contract is only required for intermediate, library-like contracts.
138  */
139 abstract contract Context {
140     function _msgSender() internal view virtual returns (address) {
141         return msg.sender;
142     }
143 
144     function _msgData() internal view virtual returns (bytes calldata) {
145         return msg.data;
146     }
147 }
148 
149 // File: @openzeppelin/contracts/access/Ownable.sol
150 
151 
152 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 
157 /**
158  * @dev Contract module which provides a basic access control mechanism, where
159  * there is an account (an owner) that can be granted exclusive access to
160  * specific functions.
161  *
162  * By default, the owner account will be the one that deploys the contract. This
163  * can later be changed with {transferOwnership}.
164  *
165  * This module is used through inheritance. It will make available the modifier
166  * `onlyOwner`, which can be applied to your functions to restrict their use to
167  * the owner.
168  */
169 abstract contract Ownable is Context {
170     address private _owner;
171 
172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174     /**
175      * @dev Initializes the contract setting the deployer as the initial owner.
176      */
177     constructor() {
178         _transferOwnership(_msgSender());
179     }
180 
181     /**
182      * @dev Throws if called by any account other than the owner.
183      */
184     modifier onlyOwner() {
185         _checkOwner();
186         _;
187     }
188 
189     /**
190      * @dev Returns the address of the current owner.
191      */
192     function owner() public view virtual returns (address) {
193         return _owner;
194     }
195 
196     /**
197      * @dev Throws if the sender is not the owner.
198      */
199     function _checkOwner() internal view virtual {
200         require(owner() == _msgSender(), "Ownable: caller is not the owner");
201     }
202 
203     /**
204      * @dev Leaves the contract without owner. It will not be possible to call
205      * `onlyOwner` functions anymore. Can only be called by the current owner.
206      *
207      * NOTE: Renouncing ownership will leave the contract without an owner,
208      * thereby removing any functionality that is only available to the owner.
209      */
210     function renounceOwnership() public virtual onlyOwner {
211         _transferOwnership(address(0));
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Can only be called by the current owner.
217      */
218     function transferOwnership(address newOwner) public virtual onlyOwner {
219         require(newOwner != address(0), "Ownable: new owner is the zero address");
220         _transferOwnership(newOwner);
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Internal function without access restriction.
226      */
227     function _transferOwnership(address newOwner) internal virtual {
228         address oldOwner = _owner;
229         _owner = newOwner;
230         emit OwnershipTransferred(oldOwner, newOwner);
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Address.sol
235 
236 
237 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
238 
239 pragma solidity ^0.8.1;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      *
262      * [IMPORTANT]
263      * ====
264      * You shouldn't rely on `isContract` to protect against flash loan attacks!
265      *
266      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
267      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
268      * constructor.
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize/address.code.length, which returns 0
273         // for contracts in construction, since the code is only stored at the end
274         // of the constructor execution.
275 
276         return account.code.length > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain `call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.call{value: value}(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
383         return functionStaticCall(target, data, "Address: low-level static call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal view returns (bytes memory) {
397         require(isContract(target), "Address: static call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.staticcall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(isContract(target), "Address: delegate call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447                 /// @solidity memory-safe-assembly
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
460 
461 
462 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @title ERC721 token receiver interface
468  * @dev Interface for any contract that wants to support safeTransfers
469  * from ERC721 asset contracts.
470  */
471 interface IERC721Receiver {
472     /**
473      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
474      * by `operator` from `from`, this function is called.
475      *
476      * It must return its Solidity selector to confirm the token transfer.
477      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
478      *
479      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
480      */
481     function onERC721Received(
482         address operator,
483         address from,
484         uint256 tokenId,
485         bytes calldata data
486     ) external returns (bytes4);
487 }
488 
489 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Interface of the ERC165 standard, as defined in the
498  * https://eips.ethereum.org/EIPS/eip-165[EIP].
499  *
500  * Implementers can declare support of contract interfaces, which can then be
501  * queried by others ({ERC165Checker}).
502  *
503  * For an implementation, see {ERC165}.
504  */
505 interface IERC165 {
506     /**
507      * @dev Returns true if this contract implements the interface defined by
508      * `interfaceId`. See the corresponding
509      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
510      * to learn more about how these ids are created.
511      *
512      * This function call must use less than 30 000 gas.
513      */
514     function supportsInterface(bytes4 interfaceId) external view returns (bool);
515 }
516 
517 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Implementation of the {IERC165} interface.
527  *
528  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
529  * for the additional interface id that will be supported. For example:
530  *
531  * ```solidity
532  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
534  * }
535  * ```
536  *
537  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
538  */
539 abstract contract ERC165 is IERC165 {
540     /**
541      * @dev See {IERC165-supportsInterface}.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         return interfaceId == type(IERC165).interfaceId;
545     }
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
549 
550 
551 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Required interface of an ERC721 compliant contract.
558  */
559 interface IERC721 is IERC165 {
560     /**
561      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
562      */
563     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
567      */
568     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
572      */
573     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
574 
575     /**
576      * @dev Returns the number of tokens in ``owner``'s account.
577      */
578     function balanceOf(address owner) external view returns (uint256 balance);
579 
580     /**
581      * @dev Returns the owner of the `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function ownerOf(uint256 tokenId) external view returns (address owner);
588 
589     /**
590      * @dev Safely transfers `tokenId` token from `from` to `to`.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must exist and be owned by `from`.
597      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
598      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
599      *
600      * Emits a {Transfer} event.
601      */
602     function safeTransferFrom(
603         address from,
604         address to,
605         uint256 tokenId,
606         bytes calldata data
607     ) external;
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Transfers `tokenId` token from `from` to `to`.
631      *
632      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
633      *
634      * Requirements:
635      *
636      * - `from` cannot be the zero address.
637      * - `to` cannot be the zero address.
638      * - `tokenId` token must be owned by `from`.
639      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
648 
649     /**
650      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
651      * The approval is cleared when the token is transferred.
652      *
653      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
654      *
655      * Requirements:
656      *
657      * - The caller must own the token or be an approved operator.
658      * - `tokenId` must exist.
659      *
660      * Emits an {Approval} event.
661      */
662     function approve(address to, uint256 tokenId) external;
663 
664     /**
665      * @dev Approve or remove `operator` as an operator for the caller.
666      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
667      *
668      * Requirements:
669      *
670      * - The `operator` cannot be the caller.
671      *
672      * Emits an {ApprovalForAll} event.
673      */
674     function setApprovalForAll(address operator, bool _approved) external;
675 
676     /**
677      * @dev Returns the account approved for `tokenId` token.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      */
683     function getApproved(uint256 tokenId) external view returns (address operator);
684 
685     /**
686      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
687      *
688      * See {setApprovalForAll}
689      */
690     function isApprovedForAll(address owner, address operator) external view returns (bool);
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
703  * @dev See https://eips.ethereum.org/EIPS/eip-721
704  */
705 interface IERC721Metadata is IERC721 {
706     /**
707      * @dev Returns the token collection name.
708      */
709     function name() external view returns (string memory);
710 
711     /**
712      * @dev Returns the token collection symbol.
713      */
714     function symbol() external view returns (string memory);
715 
716     /**
717      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
718      */
719     function tokenURI(uint256 tokenId) external view returns (string memory);
720 }
721 
722 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
723 
724 
725 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 
730 
731 
732 
733 
734 
735 
736 /**
737  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
738  * the Metadata extension, but not including the Enumerable extension, which is available separately as
739  * {ERC721Enumerable}.
740  */
741 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
742     using Address for address;
743     using Strings for uint256;
744 
745     // Token name
746     string private _name;
747 
748     // Token symbol
749     string private _symbol;
750 
751     // Mapping from token ID to owner address
752     mapping(uint256 => address) private _owners;
753 
754     // Mapping owner address to token count
755     mapping(address => uint256) private _balances;
756 
757     // Mapping from token ID to approved address
758     mapping(uint256 => address) private _tokenApprovals;
759 
760     // Mapping from owner to operator approvals
761     mapping(address => mapping(address => bool)) private _operatorApprovals;
762 
763     /**
764      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
765      */
766     constructor(string memory name_, string memory symbol_) {
767         _name = name_;
768         _symbol = symbol_;
769     }
770 
771     /**
772      * @dev See {IERC165-supportsInterface}.
773      */
774     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
775         return
776             interfaceId == type(IERC721).interfaceId ||
777             interfaceId == type(IERC721Metadata).interfaceId ||
778             super.supportsInterface(interfaceId);
779     }
780 
781     /**
782      * @dev See {IERC721-balanceOf}.
783      */
784     function balanceOf(address owner) public view virtual override returns (uint256) {
785         require(owner != address(0), "ERC721: address zero is not a valid owner");
786         return _balances[owner];
787     }
788 
789     /**
790      * @dev See {IERC721-ownerOf}.
791      */
792     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
793         address owner = _owners[tokenId];
794         require(owner != address(0), "ERC721: invalid token ID");
795         return owner;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-name}.
800      */
801     function name() public view virtual override returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-symbol}.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-tokenURI}.
814      */
815     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
816         _requireMinted(tokenId);
817 
818         string memory baseURI = _baseURI();
819         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
820     }
821 
822     /**
823      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
824      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
825      * by default, can be overridden in child contracts.
826      */
827     function _baseURI() internal view virtual returns (string memory) {
828         return "";
829     }
830 
831     /**
832      * @dev See {IERC721-approve}.
833      */
834     function approve(address to, uint256 tokenId) public virtual override {
835         address owner = ERC721.ownerOf(tokenId);
836         require(to != owner, "ERC721: approval to current owner");
837 
838         require(
839             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
840             "ERC721: approve caller is not token owner nor approved for all"
841         );
842 
843         _approve(to, tokenId);
844     }
845 
846     /**
847      * @dev See {IERC721-getApproved}.
848      */
849     function getApproved(uint256 tokenId) public view virtual override returns (address) {
850         _requireMinted(tokenId);
851 
852         return _tokenApprovals[tokenId];
853     }
854 
855     /**
856      * @dev See {IERC721-setApprovalForAll}.
857      */
858     function setApprovalForAll(address operator, bool approved) public virtual override {
859         _setApprovalForAll(_msgSender(), operator, approved);
860     }
861 
862     /**
863      * @dev See {IERC721-isApprovedForAll}.
864      */
865     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
866         return _operatorApprovals[owner][operator];
867     }
868 
869     /**
870      * @dev See {IERC721-transferFrom}.
871      */
872     function transferFrom(
873         address from,
874         address to,
875         uint256 tokenId
876     ) public virtual override {
877         //solhint-disable-next-line max-line-length
878         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
879 
880         _transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, "");
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory data
902     ) public virtual override {
903         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
904         _safeTransfer(from, to, tokenId, data);
905     }
906 
907     /**
908      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
909      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
910      *
911      * `data` is additional data, it has no specified format and it is sent in call to `to`.
912      *
913      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
914      * implement alternative mechanisms to perform token transfer, such as signature-based.
915      *
916      * Requirements:
917      *
918      * - `from` cannot be the zero address.
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must exist and be owned by `from`.
921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _safeTransfer(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory data
930     ) internal virtual {
931         _transfer(from, to, tokenId);
932         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
933     }
934 
935     /**
936      * @dev Returns whether `tokenId` exists.
937      *
938      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
939      *
940      * Tokens start existing when they are minted (`_mint`),
941      * and stop existing when they are burned (`_burn`).
942      */
943     function _exists(uint256 tokenId) internal view virtual returns (bool) {
944         return _owners[tokenId] != address(0);
945     }
946 
947     /**
948      * @dev Returns whether `spender` is allowed to manage `tokenId`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      */
954     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
955         address owner = ERC721.ownerOf(tokenId);
956         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
957     }
958 
959     /**
960      * @dev Safely mints `tokenId` and transfers it to `to`.
961      *
962      * Requirements:
963      *
964      * - `tokenId` must not exist.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeMint(address to, uint256 tokenId) internal virtual {
970         _safeMint(to, tokenId, "");
971     }
972 
973     /**
974      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
975      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
976      */
977     function _safeMint(
978         address to,
979         uint256 tokenId,
980         bytes memory data
981     ) internal virtual {
982         _mint(to, tokenId);
983         require(
984             _checkOnERC721Received(address(0), to, tokenId, data),
985             "ERC721: transfer to non ERC721Receiver implementer"
986         );
987     }
988 
989     /**
990      * @dev Mints `tokenId` and transfers it to `to`.
991      *
992      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
993      *
994      * Requirements:
995      *
996      * - `tokenId` must not exist.
997      * - `to` cannot be the zero address.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _mint(address to, uint256 tokenId) internal virtual {
1002         require(to != address(0), "ERC721: mint to the zero address");
1003         require(!_exists(tokenId), "ERC721: token already minted");
1004 
1005         _beforeTokenTransfer(address(0), to, tokenId);
1006 
1007         _balances[to] += 1;
1008         _owners[tokenId] = to;
1009 
1010         emit Transfer(address(0), to, tokenId);
1011 
1012         _afterTokenTransfer(address(0), to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev Destroys `tokenId`.
1017      * The approval is cleared when the token is burned.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _burn(uint256 tokenId) internal virtual {
1026         address owner = ERC721.ownerOf(tokenId);
1027 
1028         _beforeTokenTransfer(owner, address(0), tokenId);
1029 
1030         // Clear approvals
1031         _approve(address(0), tokenId);
1032 
1033         _balances[owner] -= 1;
1034         delete _owners[tokenId];
1035 
1036         emit Transfer(owner, address(0), tokenId);
1037 
1038         _afterTokenTransfer(owner, address(0), tokenId);
1039     }
1040 
1041     /**
1042      * @dev Transfers `tokenId` from `from` to `to`.
1043      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1044      *
1045      * Requirements:
1046      *
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must be owned by `from`.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _transfer(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) internal virtual {
1057         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1058         require(to != address(0), "ERC721: transfer to the zero address");
1059 
1060         _beforeTokenTransfer(from, to, tokenId);
1061 
1062         // Clear approvals from the previous owner
1063         _approve(address(0), tokenId);
1064 
1065         _balances[from] -= 1;
1066         _balances[to] += 1;
1067         _owners[tokenId] = to;
1068 
1069         emit Transfer(from, to, tokenId);
1070 
1071         _afterTokenTransfer(from, to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev Approve `to` to operate on `tokenId`
1076      *
1077      * Emits an {Approval} event.
1078      */
1079     function _approve(address to, uint256 tokenId) internal virtual {
1080         _tokenApprovals[tokenId] = to;
1081         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev Approve `operator` to operate on all of `owner` tokens
1086      *
1087      * Emits an {ApprovalForAll} event.
1088      */
1089     function _setApprovalForAll(
1090         address owner,
1091         address operator,
1092         bool approved
1093     ) internal virtual {
1094         require(owner != operator, "ERC721: approve to caller");
1095         _operatorApprovals[owner][operator] = approved;
1096         emit ApprovalForAll(owner, operator, approved);
1097     }
1098 
1099     /**
1100      * @dev Reverts if the `tokenId` has not been minted yet.
1101      */
1102     function _requireMinted(uint256 tokenId) internal view virtual {
1103         require(_exists(tokenId), "ERC721: invalid token ID");
1104     }
1105 
1106     /**
1107      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1108      * The call is not executed if the target address is not a contract.
1109      *
1110      * @param from address representing the previous owner of the given token ID
1111      * @param to target address that will receive the tokens
1112      * @param tokenId uint256 ID of the token to be transferred
1113      * @param data bytes optional data to send along with the call
1114      * @return bool whether the call correctly returned the expected magic value
1115      */
1116     function _checkOnERC721Received(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes memory data
1121     ) private returns (bool) {
1122         if (to.isContract()) {
1123             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1124                 return retval == IERC721Receiver.onERC721Received.selector;
1125             } catch (bytes memory reason) {
1126                 if (reason.length == 0) {
1127                     revert("ERC721: transfer to non ERC721Receiver implementer");
1128                 } else {
1129                     /// @solidity memory-safe-assembly
1130                     assembly {
1131                         revert(add(32, reason), mload(reason))
1132                     }
1133                 }
1134             }
1135         } else {
1136             return true;
1137         }
1138     }
1139 
1140     /**
1141      * @dev Hook that is called before any token transfer. This includes minting
1142      * and burning.
1143      *
1144      * Calling conditions:
1145      *
1146      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1147      * transferred to `to`.
1148      * - When `from` is zero, `tokenId` will be minted for `to`.
1149      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1150      * - `from` and `to` are never both zero.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _beforeTokenTransfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) internal virtual {}
1159 
1160     /**
1161      * @dev Hook that is called after any transfer of tokens. This includes
1162      * minting and burning.
1163      *
1164      * Calling conditions:
1165      *
1166      * - when `from` and `to` are both non-zero.
1167      * - `from` and `to` are never both zero.
1168      *
1169      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1170      */
1171     function _afterTokenTransfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) internal virtual {}
1176 }
1177 /**
1178 NAGA NAGA NAGA
1179 */
1180 
1181 pragma solidity >=0.7.0 <0.9.0;
1182 
1183 contract NAGANAGANAGA is ERC721, Ownable {
1184   using Strings for uint256;
1185   using Counters for Counters.Counter;
1186 
1187   Counters.Counter private supply;
1188 
1189   string public uriPrefix = "ipfs://QmTxheAWhtZH2yrrzdhrrm8KTMgb1o44R6CGJZcde2GjVX/";
1190   string public uriSuffix = ".json";
1191   string public hiddenMetadataUri;
1192   
1193   uint256 public cost = 0.00333 ether;
1194   uint256 public maxSupply = 999;
1195   uint256 public maxMintAmountPerTx = 3;
1196 
1197   bool public paused = false;
1198   bool public revealed = true;
1199 
1200   constructor() ERC721("NAGA NAGA NAGA", "NAGA") {
1201     setHiddenMetadataUri("ipfs://___NoHiddenArts___/hidden.json");
1202   }
1203 
1204   modifier mintCompliance(uint256 _mintAmount) {
1205     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1206     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1207     _;
1208   }
1209 
1210   function totalSupply() public view returns (uint256) {
1211     return supply.current();
1212   }
1213 
1214   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1215     require(!paused, "The contract is paused!");
1216     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1217 
1218     _mintLoop(msg.sender, _mintAmount);
1219   }
1220   
1221   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1222     _mintLoop(_receiver, _mintAmount);
1223   }
1224 
1225   function walletOfOwner(address _owner)
1226     public
1227     view
1228     returns (uint256[] memory)
1229   {
1230     uint256 ownerTokenCount = balanceOf(_owner);
1231     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1232     uint256 currentTokenId = 1;
1233     uint256 ownedTokenIndex = 0;
1234 
1235     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1236       address currentTokenOwner = ownerOf(currentTokenId);
1237 
1238       if (currentTokenOwner == _owner) {
1239         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1240 
1241         ownedTokenIndex++;
1242       }
1243 
1244       currentTokenId++;
1245     }
1246 
1247     return ownedTokenIds;
1248   }
1249 
1250   function tokenURI(uint256 _tokenId)
1251     public
1252     view
1253     virtual
1254     override
1255     returns (string memory)
1256   {
1257     require(
1258       _exists(_tokenId),
1259       "ERC721Metadata: URI query for nonexistent token"
1260     );
1261 
1262     if (revealed == false) {
1263       return hiddenMetadataUri;
1264     }
1265 
1266     string memory currentBaseURI = _baseURI();
1267     return bytes(currentBaseURI).length > 0
1268         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1269         : "";
1270   }
1271 
1272   function setRevealed(bool _state) public onlyOwner {
1273     revealed = _state;
1274   }
1275 
1276   function setCost(uint256 _cost) public onlyOwner {
1277     cost = _cost;
1278   }
1279 
1280   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1281     maxMintAmountPerTx = _maxMintAmountPerTx;
1282   }
1283 
1284   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1285     hiddenMetadataUri = _hiddenMetadataUri;
1286   }
1287 
1288   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1289     uriPrefix = _uriPrefix;
1290   }
1291 
1292   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1293     uriSuffix = _uriSuffix;
1294   }
1295 
1296   function setPaused(bool _state) public onlyOwner {
1297     paused = _state;
1298   }
1299 
1300   function withdraw() public onlyOwner {
1301 
1302 
1303     // This will transfer the remaining contract balance to the owner.
1304     // Do not remove this otherwise you will not be able to withdraw the funds.
1305     // =============================================================================
1306     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1307     require(os);
1308     // =============================================================================
1309   }
1310 
1311   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1312     for (uint256 i = 0; i < _mintAmount; i++) {
1313       supply.increment();
1314       _safeMint(_receiver, supply.current());
1315     }
1316   }
1317 
1318   function _baseURI() internal view virtual override returns (string memory) {
1319     return uriPrefix;
1320   }
1321 }