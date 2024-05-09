1 // File: contracts/YugaPunks.sol
2 
3 // SPDX-License-Identifier: MIT
4 // File: @openzeppelin/contracts/utils/Counters.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @title Counters
13  * @author Matt Condon (@shrugs)
14  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
15  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
16  *
17  * Include with `using Counters for Counters.Counter;`
18  */
19 library Counters {
20     struct Counter {
21         // This variable should never be directly accessed by users of the library: interactions must be restricted to
22         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
23         // this feature: see https://github.com/ethereum/solidity/issues/4637
24         uint256 _value; // default: 0
25     }
26 
27     function current(Counter storage counter) internal view returns (uint256) {
28         return counter._value;
29     }
30 
31     function increment(Counter storage counter) internal {
32         unchecked {
33             counter._value += 1;
34         }
35     }
36 
37     function decrement(Counter storage counter) internal {
38         uint256 value = counter._value;
39         require(value > 0, "Counter: decrement overflow");
40         unchecked {
41             counter._value = value - 1;
42         }
43     }
44 
45     function reset(Counter storage counter) internal {
46         counter._value = 0;
47     }
48 }
49 
50 // File: @openzeppelin/contracts/utils/Strings.sol
51 
52 
53 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev String operations.
59  */
60 library Strings {
61     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
118 }
119 
120 // File: @openzeppelin/contracts/utils/Context.sol
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev Provides information about the current execution context, including the
129  * sender of the transaction and its data. While these are generally available
130  * via msg.sender and msg.data, they should not be accessed in such a direct
131  * manner, since when dealing with meta-transactions the account sending and
132  * paying for execution may not be the actual sender (as far as an application
133  * is concerned).
134  *
135  * This contract is only required for intermediate, library-like contracts.
136  */
137 abstract contract Context {
138     function _msgSender() internal view virtual returns (address) {
139         return msg.sender;
140     }
141 
142     function _msgData() internal view virtual returns (bytes calldata) {
143         return msg.data;
144     }
145 }
146 
147 // File: @openzeppelin/contracts/access/Ownable.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 
155 /**
156  * @dev Contract module which provides a basic access control mechanism, where
157  * there is an account (an owner) that can be granted exclusive access to
158  * specific functions.
159  *
160  * By default, the owner account will be the one that deploys the contract. This
161  * can later be changed with {transferOwnership}.
162  *
163  * This module is used through inheritance. It will make available the modifier
164  * `onlyOwner`, which can be applied to your functions to restrict their use to
165  * the owner.
166  */
167 abstract contract Ownable is Context {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor() {
176         _transferOwnership(_msgSender());
177     }
178 
179     /**
180      * @dev Returns the address of the current owner.
181      */
182     function owner() public view virtual returns (address) {
183         return _owner;
184     }
185 
186     /**
187      * @dev Throws if called by any account other than the owner.
188      */
189     modifier onlyOwner() {
190         require(owner() == _msgSender(), "Ownable: caller is not the owner");
191         _;
192     }
193 
194     /**
195      * @dev Leaves the contract without owner. It will not be possible to call
196      * `onlyOwner` functions anymore. Can only be called by the current owner.
197      *
198      * NOTE: Renouncing ownership will leave the contract without an owner,
199      * thereby removing any functionality that is only available to the owner.
200      */
201     function renounceOwnership() public virtual onlyOwner {
202         _transferOwnership(address(0));
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      * Can only be called by the current owner.
208      */
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(newOwner != address(0), "Ownable: new owner is the zero address");
211         _transferOwnership(newOwner);
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Internal function without access restriction.
217      */
218     function _transferOwnership(address newOwner) internal virtual {
219         address oldOwner = _owner;
220         _owner = newOwner;
221         emit OwnershipTransferred(oldOwner, newOwner);
222     }
223 }
224 
225 // File: @openzeppelin/contracts/utils/Address.sol
226 
227 
228 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
229 
230 pragma solidity ^0.8.1;
231 
232 /**
233  * @dev Collection of functions related to the address type
234  */
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * [IMPORTANT]
240      * ====
241      * It is unsafe to assume that an address for which this function returns
242      * false is an externally-owned account (EOA) and not a contract.
243      *
244      * Among others, `isContract` will return false for the following
245      * types of addresses:
246      *
247      *  - an externally-owned account
248      *  - a contract in construction
249      *  - an address where a contract will be created
250      *  - an address where a contract lived, but was destroyed
251      * ====
252      *
253      * [IMPORTANT]
254      * ====
255      * You shouldn't rely on `isContract` to protect against flash loan attacks!
256      *
257      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
258      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
259      * constructor.
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies on extcodesize/address.code.length, which returns 0
264         // for contracts in construction, since the code is only stored at the end
265         // of the constructor execution.
266 
267         return account.code.length > 0;
268     }
269 
270     /**
271      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
272      * `recipient`, forwarding all available gas and reverting on errors.
273      *
274      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
275      * of certain opcodes, possibly making contracts go over the 2300 gas limit
276      * imposed by `transfer`, making them unable to receive funds via
277      * `transfer`. {sendValue} removes this limitation.
278      *
279      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
280      *
281      * IMPORTANT: because control is transferred to `recipient`, care must be
282      * taken to not create reentrancy vulnerabilities. Consider using
283      * {ReentrancyGuard} or the
284      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
285      */
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         (bool success, ) = recipient.call{value: amount}("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain `call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         require(isContract(target), "Address: call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.call{value: value}(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal view returns (bytes memory) {
388         require(isContract(target), "Address: static call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.4._
409      */
410     function functionDelegateCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(isContract(target), "Address: delegate call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.delegatecall(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
423      * revert reason using the provided one.
424      *
425      * _Available since v4.3._
426      */
427     function verifyCallResult(
428         bool success,
429         bytes memory returndata,
430         string memory errorMessage
431     ) internal pure returns (bytes memory) {
432         if (success) {
433             return returndata;
434         } else {
435             // Look for revert reason and bubble it up if present
436             if (returndata.length > 0) {
437                 // The easiest way to bubble the revert reason is using memory via assembly
438 
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449 
450 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @title ERC721 token receiver interface
459  * @dev Interface for any contract that wants to support safeTransfers
460  * from ERC721 asset contracts.
461  */
462 interface IERC721Receiver {
463     /**
464      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
465      * by `operator` from `from`, this function is called.
466      *
467      * It must return its Solidity selector to confirm the token transfer.
468      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
469      *
470      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
471      */
472     function onERC721Received(
473         address operator,
474         address from,
475         uint256 tokenId,
476         bytes calldata data
477     ) external returns (bytes4);
478 }
479 
480 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev Interface of the ERC165 standard, as defined in the
489  * https://eips.ethereum.org/EIPS/eip-165[EIP].
490  *
491  * Implementers can declare support of contract interfaces, which can then be
492  * queried by others ({ERC165Checker}).
493  *
494  * For an implementation, see {ERC165}.
495  */
496 interface IERC165 {
497     /**
498      * @dev Returns true if this contract implements the interface defined by
499      * `interfaceId`. See the corresponding
500      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
501      * to learn more about how these ids are created.
502      *
503      * This function call must use less than 30 000 gas.
504      */
505     function supportsInterface(bytes4 interfaceId) external view returns (bool);
506 }
507 
508 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Implementation of the {IERC165} interface.
518  *
519  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
520  * for the additional interface id that will be supported. For example:
521  *
522  * ```solidity
523  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
525  * }
526  * ```
527  *
528  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
529  */
530 abstract contract ERC165 is IERC165 {
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return interfaceId == type(IERC165).interfaceId;
536     }
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @dev Required interface of an ERC721 compliant contract.
549  */
550 interface IERC721 is IERC165 {
551     /**
552      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
553      */
554     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
558      */
559     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
563      */
564     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
565 
566     /**
567      * @dev Returns the number of tokens in ``owner``'s account.
568      */
569     function balanceOf(address owner) external view returns (uint256 balance);
570 
571     /**
572      * @dev Returns the owner of the `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function ownerOf(uint256 tokenId) external view returns (address owner);
579 
580     /**
581      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
582      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must exist and be owned by `from`.
589      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
591      *
592      * Emits a {Transfer} event.
593      */
594     function safeTransferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Transfers `tokenId` token from `from` to `to`.
602      *
603      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      *
612      * Emits a {Transfer} event.
613      */
614     function transferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
622      * The approval is cleared when the token is transferred.
623      *
624      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
625      *
626      * Requirements:
627      *
628      * - The caller must own the token or be an approved operator.
629      * - `tokenId` must exist.
630      *
631      * Emits an {Approval} event.
632      */
633     function approve(address to, uint256 tokenId) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Approve or remove `operator` as an operator for the caller.
646      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
647      *
648      * Requirements:
649      *
650      * - The `operator` cannot be the caller.
651      *
652      * Emits an {ApprovalForAll} event.
653      */
654     function setApprovalForAll(address operator, bool _approved) external;
655 
656     /**
657      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
658      *
659      * See {setApprovalForAll}
660      */
661     function isApprovedForAll(address owner, address operator) external view returns (bool);
662 
663     /**
664      * @dev Safely transfers `tokenId` token from `from` to `to`.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId,
680         bytes calldata data
681     ) external;
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
694  * @dev See https://eips.ethereum.org/EIPS/eip-721
695  */
696 interface IERC721Metadata is IERC721 {
697     /**
698      * @dev Returns the token collection name.
699      */
700     function name() external view returns (string memory);
701 
702     /**
703      * @dev Returns the token collection symbol.
704      */
705     function symbol() external view returns (string memory);
706 
707     /**
708      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
709      */
710     function tokenURI(uint256 tokenId) external view returns (string memory);
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
714 
715 
716 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 
722 
723 
724 
725 
726 
727 /**
728  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
729  * the Metadata extension, but not including the Enumerable extension, which is available separately as
730  * {ERC721Enumerable}.
731  */
732 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
733     using Address for address;
734     using Strings for uint256;
735 
736     // Token name
737     string private _name;
738 
739     // Token symbol
740     string private _symbol;
741 
742     // Mapping from token ID to owner address
743     mapping(uint256 => address) private _owners;
744 
745     // Mapping owner address to token count
746     mapping(address => uint256) private _balances;
747 
748     // Mapping from token ID to approved address
749     mapping(uint256 => address) private _tokenApprovals;
750 
751     // Mapping from owner to operator approvals
752     mapping(address => mapping(address => bool)) private _operatorApprovals;
753 
754     /**
755      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
756      */
757     constructor(string memory name_, string memory symbol_) {
758         _name = name_;
759         _symbol = symbol_;
760     }
761 
762     /**
763      * @dev See {IERC165-supportsInterface}.
764      */
765     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
766         return
767             interfaceId == type(IERC721).interfaceId ||
768             interfaceId == type(IERC721Metadata).interfaceId ||
769             super.supportsInterface(interfaceId);
770     }
771 
772     /**
773      * @dev See {IERC721-balanceOf}.
774      */
775     function balanceOf(address owner) public view virtual override returns (uint256) {
776         require(owner != address(0), "ERC721: balance query for the zero address");
777         return _balances[owner];
778     }
779 
780     /**
781      * @dev See {IERC721-ownerOf}.
782      */
783     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
784         address owner = _owners[tokenId];
785         require(owner != address(0), "ERC721: owner query for nonexistent token");
786         return owner;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-name}.
791      */
792     function name() public view virtual override returns (string memory) {
793         return _name;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-symbol}.
798      */
799     function symbol() public view virtual override returns (string memory) {
800         return _symbol;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-tokenURI}.
805      */
806     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
807         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
808 
809         string memory baseURI = _baseURI();
810         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
811     }
812 
813     /**
814      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
815      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
816      * by default, can be overriden in child contracts.
817      */
818     function _baseURI() internal view virtual returns (string memory) {
819         return "";
820     }
821 
822     /**
823      * @dev See {IERC721-approve}.
824      */
825     function approve(address to, uint256 tokenId) public virtual override {
826         address owner = ERC721.ownerOf(tokenId);
827         require(to != owner, "ERC721: approval to current owner");
828 
829         require(
830             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
831             "ERC721: approve caller is not owner nor approved for all"
832         );
833 
834         _approve(to, tokenId);
835     }
836 
837     /**
838      * @dev See {IERC721-getApproved}.
839      */
840     function getApproved(uint256 tokenId) public view virtual override returns (address) {
841         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
842 
843         return _tokenApprovals[tokenId];
844     }
845 
846     /**
847      * @dev See {IERC721-setApprovalForAll}.
848      */
849     function setApprovalForAll(address operator, bool approved) public virtual override {
850         _setApprovalForAll(_msgSender(), operator, approved);
851     }
852 
853     /**
854      * @dev See {IERC721-isApprovedForAll}.
855      */
856     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
857         return _operatorApprovals[owner][operator];
858     }
859 
860     /**
861      * @dev See {IERC721-transferFrom}.
862      */
863     function transferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) public virtual override {
868         //solhint-disable-next-line max-line-length
869         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
870 
871         _transfer(from, to, tokenId);
872     }
873 
874     /**
875      * @dev See {IERC721-safeTransferFrom}.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId
881     ) public virtual override {
882         safeTransferFrom(from, to, tokenId, "");
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId,
892         bytes memory _data
893     ) public virtual override {
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
916     function _safeTransfer(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) internal virtual {
922         _transfer(from, to, tokenId);
923         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
924     }
925 
926     /**
927      * @dev Returns whether `tokenId` exists.
928      *
929      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
930      *
931      * Tokens start existing when they are minted (`_mint`),
932      * and stop existing when they are burned (`_burn`).
933      */
934     function _exists(uint256 tokenId) internal view virtual returns (bool) {
935         return _owners[tokenId] != address(0);
936     }
937 
938     /**
939      * @dev Returns whether `spender` is allowed to manage `tokenId`.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must exist.
944      */
945     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
946         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
947         address owner = ERC721.ownerOf(tokenId);
948         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
949     }
950 
951     /**
952      * @dev Safely mints `tokenId` and transfers it to `to`.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must not exist.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeMint(address to, uint256 tokenId) internal virtual {
962         _safeMint(to, tokenId, "");
963     }
964 
965     /**
966      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
967      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
968      */
969     function _safeMint(
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) internal virtual {
974         _mint(to, tokenId);
975         require(
976             _checkOnERC721Received(address(0), to, tokenId, _data),
977             "ERC721: transfer to non ERC721Receiver implementer"
978         );
979     }
980 
981     /**
982      * @dev Mints `tokenId` and transfers it to `to`.
983      *
984      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
985      *
986      * Requirements:
987      *
988      * - `tokenId` must not exist.
989      * - `to` cannot be the zero address.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _mint(address to, uint256 tokenId) internal virtual {
994         require(to != address(0), "ERC721: mint to the zero address");
995         require(!_exists(tokenId), "ERC721: token already minted");
996 
997         _beforeTokenTransfer(address(0), to, tokenId);
998 
999         _balances[to] += 1;
1000         _owners[tokenId] = to;
1001 
1002         emit Transfer(address(0), to, tokenId);
1003 
1004         _afterTokenTransfer(address(0), to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Destroys `tokenId`.
1009      * The approval is cleared when the token is burned.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _burn(uint256 tokenId) internal virtual {
1018         address owner = ERC721.ownerOf(tokenId);
1019 
1020         _beforeTokenTransfer(owner, address(0), tokenId);
1021 
1022         // Clear approvals
1023         _approve(address(0), tokenId);
1024 
1025         _balances[owner] -= 1;
1026         delete _owners[tokenId];
1027 
1028         emit Transfer(owner, address(0), tokenId);
1029 
1030         _afterTokenTransfer(owner, address(0), tokenId);
1031     }
1032 
1033     /**
1034      * @dev Transfers `tokenId` from `from` to `to`.
1035      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual {
1049         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1050         require(to != address(0), "ERC721: transfer to the zero address");
1051 
1052         _beforeTokenTransfer(from, to, tokenId);
1053 
1054         // Clear approvals from the previous owner
1055         _approve(address(0), tokenId);
1056 
1057         _balances[from] -= 1;
1058         _balances[to] += 1;
1059         _owners[tokenId] = to;
1060 
1061         emit Transfer(from, to, tokenId);
1062 
1063         _afterTokenTransfer(from, to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Approve `to` to operate on `tokenId`
1068      *
1069      * Emits a {Approval} event.
1070      */
1071     function _approve(address to, uint256 tokenId) internal virtual {
1072         _tokenApprovals[tokenId] = to;
1073         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1074     }
1075 
1076     /**
1077      * @dev Approve `operator` to operate on all of `owner` tokens
1078      *
1079      * Emits a {ApprovalForAll} event.
1080      */
1081     function _setApprovalForAll(
1082         address owner,
1083         address operator,
1084         bool approved
1085     ) internal virtual {
1086         require(owner != operator, "ERC721: approve to caller");
1087         _operatorApprovals[owner][operator] = approved;
1088         emit ApprovalForAll(owner, operator, approved);
1089     }
1090 
1091     /**
1092      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1093      * The call is not executed if the target address is not a contract.
1094      *
1095      * @param from address representing the previous owner of the given token ID
1096      * @param to target address that will receive the tokens
1097      * @param tokenId uint256 ID of the token to be transferred
1098      * @param _data bytes optional data to send along with the call
1099      * @return bool whether the call correctly returned the expected magic value
1100      */
1101     function _checkOnERC721Received(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory _data
1106     ) private returns (bool) {
1107         if (to.isContract()) {
1108             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1109                 return retval == IERC721Receiver.onERC721Received.selector;
1110             } catch (bytes memory reason) {
1111                 if (reason.length == 0) {
1112                     revert("ERC721: transfer to non ERC721Receiver implementer");
1113                 } else {
1114                     assembly {
1115                         revert(add(32, reason), mload(reason))
1116                     }
1117                 }
1118             }
1119         } else {
1120             return true;
1121         }
1122     }
1123 
1124     /**
1125      * @dev Hook that is called before any token transfer. This includes minting
1126      * and burning.
1127      *
1128      * Calling conditions:
1129      *
1130      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1131      * transferred to `to`.
1132      * - When `from` is zero, `tokenId` will be minted for `to`.
1133      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1134      * - `from` and `to` are never both zero.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _beforeTokenTransfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) internal virtual {}
1143 
1144     /**
1145      * @dev Hook that is called after any transfer of tokens. This includes
1146      * minting and burning.
1147      *
1148      * Calling conditions:
1149      *
1150      * - when `from` and `to` are both non-zero.
1151      * - `from` and `to` are never both zero.
1152      *
1153      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1154      */
1155     function _afterTokenTransfer(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) internal virtual {}
1160 }
1161 
1162 // File: YugaPunks.sol
1163 
1164 
1165 
1166 pragma solidity ^0.8.2;
1167 
1168 
1169 
1170 
1171 
1172 contract YugaPunks is ERC721, Ownable {
1173 
1174     using Strings for uint256;
1175 
1176     using Counters for Counters.Counter;
1177 
1178     Counters.Counter private supply;
1179 
1180     string public uriPrefix = "ipfs://QmYrct91FPcanjDAaCeBATQK9bkG1MZAFKvYjbbUQGwkXd/";
1181     string public uriSuffix = ".json";
1182     string public hiddenMetadataUri;
1183 
1184     uint256 public cost = 0 ether;
1185     uint256 public maxSupply = 666;
1186     uint256 public maxMintAmountPerTx = 3;
1187 
1188     bool public paused = false;
1189     bool public revealed = true;
1190 
1191     constructor() ERC721("Yuga Punks", "YPUNK") {
1192         setHiddenMetadataUri("ipfs://QmYrct91FPcanjDAaCeBATQK9bkG1MZAFKvYjbbUQGwkXd/");
1193     }
1194 
1195      modifier mintCompliance(uint256 _mintAmount) {
1196         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1197         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1198         _;
1199     }
1200 
1201     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1202         require(!paused, "The contract is paused!");
1203 
1204         if(supply.current() < 666) {
1205             require(total_nft(msg.sender) < 6,  "NFT Per Wallet Limit Exceeds!!");
1206             _mintLoop(msg.sender, _mintAmount);
1207         }
1208         else{
1209             require(total_nft(msg.sender) < 6,  "NFT Per Wallet Limit Exceeds!!");
1210             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1211             _mintLoop(msg.sender, _mintAmount);
1212         }
1213     }
1214 
1215     
1216     function total_nft(address _buyer) public view returns (uint256) {
1217        uint256[] memory _num = walletOfOwner(_buyer);
1218        return _num.length;
1219     }
1220 
1221     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1222         for (uint256 i = 0; i < _mintAmount; i++) {
1223             supply.increment();
1224             _safeMint(_receiver, supply.current());
1225         }
1226     }
1227 
1228     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
1229         require(
1230         _exists(_tokenId),
1231         "ERC721Metadata: URI query for nonexistent token"
1232         );
1233 
1234         if (revealed == false) {
1235             return hiddenMetadataUri;
1236         }
1237 
1238         string memory currentBaseURI = _baseURI();
1239         return bytes(currentBaseURI).length > 0
1240             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1241             : "";
1242     }
1243 
1244     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1245         uint256 ownerTokenCount = balanceOf(_owner);
1246         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1247         uint256 currentTokenId = 1;
1248         uint256 ownedTokenIndex = 0;
1249 
1250         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1251 
1252             address currentTokenOwner = ownerOf(currentTokenId);
1253 
1254             if (currentTokenOwner == _owner) {
1255                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1256 
1257                 ownedTokenIndex++;
1258             }
1259 
1260             currentTokenId++;
1261         }
1262 
1263         return ownedTokenIds;
1264     }
1265 
1266 
1267     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1268         uriPrefix = _uriPrefix;
1269     }
1270 
1271     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1272         uriSuffix = _uriSuffix;
1273     }
1274 
1275     function setPaused(bool _state) public onlyOwner {
1276         paused = _state;
1277     }
1278 
1279     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1280 		hiddenMetadataUri = _hiddenMetadataUri;
1281 	}
1282 
1283     function setRevealed(bool _state) public onlyOwner {
1284         revealed = _state;
1285     }
1286 
1287     function setCost(uint256 _cost) public onlyOwner {
1288         cost = _cost;
1289     }
1290 
1291     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1292         maxMintAmountPerTx = _maxMintAmountPerTx;
1293     }
1294 
1295     function totalSupply() public view returns (uint256) {
1296         return supply.current();
1297     }
1298 
1299     function _baseURI() internal view virtual override returns (string memory) {
1300         return uriPrefix;
1301     }
1302 
1303     function withdraw() public onlyOwner {
1304         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1305         require(os);
1306     }    
1307    
1308 }