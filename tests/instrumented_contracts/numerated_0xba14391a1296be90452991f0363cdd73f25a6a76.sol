1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6  
7 library Counters {
8     struct Counter {
9         // This variable should never be directly accessed by users of the library: interactions must be restricted to
10         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
11         // this feature: see https://github.com/ethereum/solidity/issues/4637
12         uint256 _value; // default: 0
13     }
14 
15     function current(Counter storage counter) internal view returns (uint256) {
16         return counter._value;
17     }
18 
19     function increment(Counter storage counter) internal {
20         unchecked {
21             counter._value += 1;
22         }
23     }
24 
25     function decrement(Counter storage counter) internal {
26         uint256 value = counter._value;
27         require(value > 0, "Counter: decrement overflow");
28         unchecked {
29             counter._value = value - 1;
30         }
31     }
32 
33     function reset(Counter storage counter) internal {
34         counter._value = 0;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/utils/Strings.sol
39 
40 
41 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev String operations.
47  */
48 library Strings {
49     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
50     uint8 private constant _ADDRESS_LENGTH = 20;
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
54      */
55     function toString(uint256 value) internal pure returns (string memory) {
56         // Inspired by OraclizeAPI's implementation - MIT licence
57         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
58 
59         if (value == 0) {
60             return "0";
61         }
62         uint256 temp = value;
63         uint256 digits;
64         while (temp != 0) {
65             digits++;
66             temp /= 10;
67         }
68         bytes memory buffer = new bytes(digits);
69         while (value != 0) {
70             digits -= 1;
71             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
72             value /= 10;
73         }
74         return string(buffer);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
79      */
80     function toHexString(uint256 value) internal pure returns (string memory) {
81         if (value == 0) {
82             return "0x00";
83         }
84         uint256 temp = value;
85         uint256 length = 0;
86         while (temp != 0) {
87             length++;
88             temp >>= 8;
89         }
90         return toHexString(value, length);
91     }
92 
93     /**
94      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
95      */
96     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
97         bytes memory buffer = new bytes(2 * length + 2);
98         buffer[0] = "0";
99         buffer[1] = "x";
100         for (uint256 i = 2 * length + 1; i > 1; --i) {
101             buffer[i] = _HEX_SYMBOLS[value & 0xf];
102             value >>= 4;
103         }
104         require(value == 0, "Strings: hex length insufficient");
105         return string(buffer);
106     }
107 
108     /**
109      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
110      */
111     function toHexString(address addr) internal pure returns (string memory) {
112         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
113     }
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/access/Ownable.sol
144 
145 
146 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 /**
152  * @dev Contract module which provides a basic access control mechanism, where
153  * there is an account (an owner) that can be granted exclusive access to
154  * specific functions.
155  *
156  * By default, the owner account will be the one that deploys the contract. This
157  * can later be changed with {transferOwnership}.
158  *
159  * This module is used through inheritance. It will make available the modifier
160  * `onlyOwner`, which can be applied to your functions to restrict their use to
161  * the owner.
162  */
163 abstract contract Ownable is Context {
164     address private _owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168     /**
169      * @dev Initializes the contract setting the deployer as the initial owner.
170      */
171     constructor() {
172         _transferOwnership(_msgSender());
173     }
174 
175     /**
176      * @dev Throws if called by any account other than the owner.
177      */
178     modifier onlyOwner() {
179         _checkOwner();
180         _;
181     }
182 
183     /**
184      * @dev Returns the address of the current owner.
185      */
186     function owner() public view virtual returns (address) {
187         return _owner;
188     }
189 
190     /**
191      * @dev Throws if the sender is not the owner.
192      */
193     function _checkOwner() internal view virtual {
194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
195     }
196 
197     /**
198      * @dev Leaves the contract without owner. It will not be possible to call
199      * `onlyOwner` functions anymore. Can only be called by the current owner.
200      *
201      * NOTE: Renouncing ownership will leave the contract without an owner,
202      * thereby removing any functionality that is only available to the owner.
203      */
204     function renounceOwnership() public virtual onlyOwner {
205         _transferOwnership(address(0));
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public virtual onlyOwner {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         _transferOwnership(newOwner);
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Internal function without access restriction.
220      */
221     function _transferOwnership(address newOwner) internal virtual {
222         address oldOwner = _owner;
223         _owner = newOwner;
224         emit OwnershipTransferred(oldOwner, newOwner);
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Address.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
232 
233 pragma solidity ^0.8.1;
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      *
256      * [IMPORTANT]
257      * ====
258      * You shouldn't rely on `isContract` to protect against flash loan attacks!
259      *
260      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
261      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
262      * constructor.
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize/address.code.length, which returns 0
267         // for contracts in construction, since the code is only stored at the end
268         // of the constructor execution.
269 
270         return account.code.length > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas mintNFTPrice
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441                 /// @solidity memory-safe-assembly
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
454 
455 
456 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @title ERC721 token receiver interface
462  * @dev Interface for any contract that wants to support safeTransfers
463  * from ERC721 asset contracts.
464  */
465 interface IERC721Receiver {
466     /**
467      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
468      * by `operator` from `from`, this function is called.
469      *
470      * It must return its Solidity selector to confirm the token transfer.
471      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
472      *
473      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
474      */
475     function onERC721Received(
476         address operator,
477         address from,
478         uint256 tokenId,
479         bytes calldata data
480     ) external returns (bytes4);
481 }
482 
483 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Interface of the ERC165 standard, as defined in the
492  * https://eips.ethereum.org/EIPS/eip-165[EIP].
493  *
494  * Implementers can declare support of contract interfaces, which can then be
495  * queried by others ({ERC165Checker}).
496  *
497  * For an implementation, see {ERC165}.
498  */
499 interface IERC165 {
500     /**
501      * @dev Returns true if this contract implements the interface defined by
502      * `interfaceId`. See the corresponding
503      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
504      * to learn more about how these ids are created.
505      *
506      * This function call must use less than 30 000 gas.
507      */
508     function supportsInterface(bytes4 interfaceId) external view returns (bool);
509 }
510 
511 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @dev Implementation of the {IERC165} interface.
521  *
522  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
523  * for the additional interface id that will be supported. For example:
524  *
525  * ```solidity
526  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
528  * }
529  * ```
530  *
531  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
532  */
533 abstract contract ERC165 is IERC165 {
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538         return interfaceId == type(IERC165).interfaceId;
539     }
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
543 
544 
545 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Required interface of an ERC721 compliant contract.
552  */
553 interface IERC721 is IERC165 {
554     /**
555      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
556      */
557     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
561      */
562     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
563 
564     /**
565      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
566      */
567     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
568 
569     /**
570      * @dev Returns the number of tokens in ``owner``'s account.
571      */
572     function balanceOf(address owner) external view returns (uint256 balance);
573 
574     /**
575      * @dev Returns the owner of the `tokenId` token.
576      *
577      * Requirements:
578      *
579      * - `tokenId` must exist.
580      */
581     function ownerOf(uint256 tokenId) external view returns (address owner);
582 
583     /**
584      * @dev Safely transfers `tokenId` token from `from` to `to`.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must exist and be owned by `from`.
591      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
593      *
594      * Emits a {Transfer} event.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId,
600         bytes calldata data
601     ) external;
602 
603     /**
604      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
605      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must exist and be owned by `from`.
612      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
613      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
614      *
615      * Emits a {Transfer} event.
616      */
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Transfers `tokenId` token from `from` to `to`.
625      *
626      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must be owned by `from`.
633      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
634      *
635      * Emits a {Transfer} event.
636      */
637     function transferFrom(
638         address from,
639         address to,
640         uint256 tokenId
641     ) external;
642 
643     /**
644      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
645      * The approval is cleared when the token is transferred.
646      *
647      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
648      *
649      * Requirements:
650      *
651      * - The caller must own the token or be an approved operator.
652      * - `tokenId` must exist.
653      *
654      * Emits an {Approval} event.
655      */
656     function approve(address to, uint256 tokenId) external;
657 
658     /**
659      * @dev Approve or remove `operator` as an operator for the caller.
660      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
661      *
662      * Requirements:
663      *
664      * - The `operator` cannot be the caller.
665      *
666      * Emits an {ApprovalForAll} event.
667      */
668     function setApprovalForAll(address operator, bool _approved) external;
669 
670     /**
671      * @dev Returns the account approved for `tokenId` token.
672      *
673      * Requirements:
674      *
675      * - `tokenId` must exist.
676      */
677     function getApproved(uint256 tokenId) external view returns (address operator);
678 
679     /**
680      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
681      *
682      * See {setApprovalForAll}
683      */
684     function isApprovedForAll(address owner, address operator) external view returns (bool);
685 }
686 
687 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
697  * @dev See https://eips.ethereum.org/EIPS/eip-721
698  */
699 interface IERC721Metadata is IERC721 {
700     /**
701      * @dev Returns the token collection name.
702      */
703     function name() external view returns (string memory);
704 
705     /**
706      * @dev Returns the token collection symbol.
707      */
708     function symbol() external view returns (string memory);
709 
710     /**
711      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
712      */
713     function tokenURI(uint256 tokenId) external view returns (string memory);
714 }
715 
716 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
717 
718 
719 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 
725 
726 
727 
728 
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension, but not including the Enumerable extension, which is available separately as
733  * {ERC721Enumerable}.
734  */
735 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
736     using Address for address;
737     using Strings for uint256;
738 
739     // Token name
740     string private _name;
741 
742     // Token symbol
743     string private _symbol;
744 
745     // Mapping from token ID to owner address
746     mapping(uint256 => address) private _owners;
747 
748     // Mapping owner address to token count
749     mapping(address => uint256) private _balances;
750 
751     // Mapping from token ID to approved address
752     mapping(uint256 => address) private _tokenApprovals;
753 
754     // Mapping from owner to operator approvals
755     mapping(address => mapping(address => bool)) private _operatorApprovals;
756 
757     /**
758      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
759      */
760     constructor(string memory name_, string memory symbol_) {
761         _name = name_;
762         _symbol = symbol_;
763     }
764 
765     /**
766      * @dev See {IERC165-supportsInterface}.
767      */
768     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
769         return
770             interfaceId == type(IERC721).interfaceId ||
771             interfaceId == type(IERC721Metadata).interfaceId ||
772             super.supportsInterface(interfaceId);
773     }
774 
775     /**
776      * @dev See {IERC721-balanceOf}.
777      */
778     function balanceOf(address owner) public view virtual override returns (uint256) {
779         require(owner != address(0), "ERC721: address zero is not a valid owner");
780         return _balances[owner];
781     }
782 
783     /**
784      * @dev See {IERC721-ownerOf}.
785      */
786     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
787         address owner = _owners[tokenId];
788         require(owner != address(0), "ERC721: invalid token ID");
789         return owner;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-name}.
794      */
795     function name() public view virtual override returns (string memory) {
796         return _name;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-symbol}.
801      */
802     function symbol() public view virtual override returns (string memory) {
803         return _symbol;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-tokenURI}.
808      */
809     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
810         _requiremintNFTed(tokenId);
811 
812         string memory baseURI = _baseURI();
813         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
814     }
815 
816     /**
817      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
818      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
819      * by default, can be overridden in child contracts.
820      */
821     function _baseURI() internal view virtual returns (string memory) {
822         return "";
823     }
824 
825     /**
826      * @dev See {IERC721-approve}.
827      */
828     function approve(address to, uint256 tokenId) public virtual override {
829         address owner = ERC721.ownerOf(tokenId);
830         require(to != owner, "ERC721: approval to current owner");
831 
832         require(
833             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
834             "ERC721: approve caller is not token owner nor approved for all"
835         );
836 
837         _approve(to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-getApproved}.
842      */
843     function getApproved(uint256 tokenId) public view virtual override returns (address) {
844         _requiremintNFTed(tokenId);
845 
846         return _tokenApprovals[tokenId];
847     }
848 
849     /**
850      * @dev See {IERC721-setApprovalForAll}.
851      */
852     function setApprovalForAll(address operator, bool approved) public virtual override {
853         _setApprovalForAll(_msgSender(), operator, approved);
854     }
855 
856     /**
857      * @dev See {IERC721-isApprovedForAll}.
858      */
859     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
860         return _operatorApprovals[owner][operator];
861     }
862 
863     /**
864      * @dev See {IERC721-transferFrom}.
865      */
866     function transferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         //solhint-disable-next-line max-line-length
872         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
873 
874         _transfer(from, to, tokenId);
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         safeTransferFrom(from, to, tokenId, "");
886     }
887 
888     /**
889      * @dev See {IERC721-safeTransferFrom}.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory data
896     ) public virtual override {
897         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
898         _safeTransfer(from, to, tokenId, data);
899     }
900 
901     /**
902      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
903      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
904      *
905      * `data` is additional data, it has no specified format and it is sent in call to `to`.
906      *
907      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
908      * implement alternative mechanisms to perform token transfer, such as signature-based.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeTransfer(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory data
924     ) internal virtual {
925         _transfer(from, to, tokenId);
926         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
927     }
928 
929     /**
930      * @dev Returns whether `tokenId` exists.
931      *
932      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
933      *
934      * Tokens start existing when they are mintNFTed (`_mintNFT`),
935      * and stop existing when they are burned (`_burn`).
936      */
937     function _exists(uint256 tokenId) internal view virtual returns (bool) {
938         return _owners[tokenId] != address(0);
939     }
940 
941     /**
942      * @dev Returns whether `spender` is allowed to manage `tokenId`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      */
948     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
949         address owner = ERC721.ownerOf(tokenId);
950         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
951     }
952 
953     /**
954      * @dev Safely mintNFTs `tokenId` and transfers it to `to`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must not exist.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safemintNFT(address to, uint256 tokenId) internal virtual {
964         _safemintNFT(to, tokenId, "");
965     }
966 
967     /**
968      * @dev Same as {xref-ERC721-_safemintNFT-address-uint256-}[`_safemintNFT`], with an additional `data` parameter which is
969      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
970      */
971     function _safemintNFT(
972         address to,
973         uint256 tokenId,
974         bytes memory data
975     ) internal virtual {
976         _mintNFT(to, tokenId);
977         require(
978             _checkOnERC721Received(address(0), to, tokenId, data),
979             "ERC721: transfer to non ERC721Receiver implementer"
980         );
981     }
982 
983     /**
984      * @dev mintNFTs `tokenId` and transfers it to `to`.
985      *
986      * WARNING: Usage of this method is discouraged, use {_safemintNFT} whenever possible
987      *
988      * Requirements:
989      *
990      * - `tokenId` must not exist.
991      * - `to` cannot be the zero address.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _mintNFT(address to, uint256 tokenId) internal virtual {
996         require(to != address(0), "ERC721: mintNFT to the zero address");
997         require(!_exists(tokenId), "ERC721: token already mintNFTed");
998 
999         _beforeTokenTransfer(address(0), to, tokenId);
1000 
1001         _balances[to] += 1;
1002         _owners[tokenId] = to;
1003 
1004         emit Transfer(address(0), to, tokenId);
1005 
1006         _afterTokenTransfer(address(0), to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev Destroys `tokenId`.
1011      * The approval is cleared when the token is burned.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _burn(uint256 tokenId) internal virtual {
1020         address owner = ERC721.ownerOf(tokenId);
1021 
1022         _beforeTokenTransfer(owner, address(0), tokenId);
1023 
1024         // Clear approvals
1025         _approve(address(0), tokenId);
1026 
1027         _balances[owner] -= 1;
1028         delete _owners[tokenId];
1029 
1030         emit Transfer(owner, address(0), tokenId);
1031 
1032         _afterTokenTransfer(owner, address(0), tokenId);
1033     }
1034 
1035     /**
1036      * @dev Transfers `tokenId` from `from` to `to`.
1037      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1038      *
1039      * Requirements:
1040      *
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must be owned by `from`.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _transfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual {
1051         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1052         require(to != address(0), "ERC721: transfer to the zero address");
1053 
1054         _beforeTokenTransfer(from, to, tokenId);
1055 
1056         // Clear approvals from the previous owner
1057         _approve(address(0), tokenId);
1058 
1059         _balances[from] -= 1;
1060         _balances[to] += 1;
1061         _owners[tokenId] = to;
1062 
1063         emit Transfer(from, to, tokenId);
1064 
1065         _afterTokenTransfer(from, to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Approve `to` to operate on `tokenId`
1070      *
1071      * Emits an {Approval} event.
1072      */
1073     function _approve(address to, uint256 tokenId) internal virtual {
1074         _tokenApprovals[tokenId] = to;
1075         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Approve `operator` to operate on all of `owner` tokens
1080      *
1081      * Emits an {ApprovalForAll} event.
1082      */
1083     function _setApprovalForAll(
1084         address owner,
1085         address operator,
1086         bool approved
1087     ) internal virtual {
1088         require(owner != operator, "ERC721: approve to caller");
1089         _operatorApprovals[owner][operator] = approved;
1090         emit ApprovalForAll(owner, operator, approved);
1091     }
1092 
1093     /**
1094      * @dev Reverts if the `tokenId` has not been mintNFTed yet.
1095      */
1096     function _requiremintNFTed(uint256 tokenId) internal view virtual {
1097         require(_exists(tokenId), "ERC721: invalid token ID");
1098     }
1099 
1100     /**
1101      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1102      * The call is not executed if the target address is not a contract.
1103      *
1104      * @param from address representing the previous owner of the given token ID
1105      * @param to target address that will receive the tokens
1106      * @param tokenId uint256 ID of the token to be transferred
1107      * @param data bytes optional data to send along with the call
1108      * @return bool whether the call correctly returned the expected magic value
1109      */
1110     function _checkOnERC721Received(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes memory data
1115     ) private returns (bool) {
1116         if (to.isContract()) {
1117             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1118                 return retval == IERC721Receiver.onERC721Received.selector;
1119             } catch (bytes memory reason) {
1120                 if (reason.length == 0) {
1121                     revert("ERC721: transfer to non ERC721Receiver implementer");
1122                 } else {
1123                     /// @solidity memory-safe-assembly
1124                     assembly {
1125                         revert(add(32, reason), mload(reason))
1126                     }
1127                 }
1128             }
1129         } else {
1130             return true;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Hook that is called before any token transfer. This includes mintNFTing
1136      * and burning.
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` will be mintNFTed for `to`.
1143      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1144      * - `from` and `to` are never both zero.
1145      *
1146      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1147      */
1148     function _beforeTokenTransfer(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) internal virtual {}
1153 
1154     /**
1155      * @dev Hook that is called after any transfer of tokens. This includes
1156      * mintNFTing and burning.
1157      *
1158      * Calling conditions:
1159      *
1160      * - when `from` and `to` are both non-zero.
1161      * - `from` and `to` are never both zero.
1162      *
1163      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1164      */
1165     function _afterTokenTransfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {}
1170 }
1171 
1172 
1173 pragma solidity >=0.7.0 <0.9.0;
1174 
1175 contract GUUGUUGAGA is ERC721, Ownable {
1176   using Strings for uint256;
1177   using Counters for Counters.Counter;
1178 
1179   Counters.Counter private supply;
1180 
1181   string public uriPrefix = "ipfs://QmW3gGfBGFEtFk6SbbRVF1vxq5c2f89eymacuefgbB2d6R/";
1182   string public uriSuffix = ".json";
1183   string public hiddenMetadataUri;
1184   
1185   uint256 public mintNFTPrice = 0.01 ether;
1186   uint256 public maxmintNFTSupply = 1000;
1187   uint256 public maxmintNFTAmountPerTx = 3;
1188 
1189   bool public paused = false;
1190   bool public revealed = true;
1191 
1192   constructor() ERC721("GUUGUUGAGA", "GUUGUU") {
1193     setHiddenMetadataUri("ipfs://___Nohidden___/hidden.json");
1194   }
1195 
1196   modifier mintNFTCompliance(uint256 _mintNFTAmount) {
1197     require(_mintNFTAmount > 0 && _mintNFTAmount <= maxmintNFTAmountPerTx, "Invalid mintNFT amount!");
1198     require(supply.current() + _mintNFTAmount <= maxmintNFTSupply, "Max supply exceeded!");
1199     _;
1200   }
1201 
1202   function NftMinted() public view returns (uint256) {
1203     return supply.current();
1204   }
1205 
1206   function mintNFT(uint256 _mintNFTAmount) public payable mintNFTCompliance(_mintNFTAmount) {
1207     require(!paused, "The contract is paused!");
1208     require(msg.value >= mintNFTPrice * _mintNFTAmount, "Insufficient funds!");
1209 
1210     _mintNFTLoop(msg.sender, _mintNFTAmount);
1211   }
1212   
1213   function mintNFTForAddress(uint256 _mintNFTAmount, address _receiver) public mintNFTCompliance(_mintNFTAmount) onlyOwner {
1214     _mintNFTLoop(_receiver, _mintNFTAmount);
1215   }
1216 
1217   function walletOfOwner(address _owner)
1218     public
1219     view
1220     returns (uint256[] memory)
1221   {
1222     uint256 ownerTokenCount = balanceOf(_owner);
1223     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1224     uint256 currentTokenId = 1;
1225     uint256 ownedTokenIndex = 0;
1226 
1227     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxmintNFTSupply) {
1228       address currentTokenOwner = ownerOf(currentTokenId);
1229 
1230       if (currentTokenOwner == _owner) {
1231         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1232 
1233         ownedTokenIndex++;
1234       }
1235 
1236       currentTokenId++;
1237     }
1238 
1239     return ownedTokenIds;
1240   }
1241 
1242   function tokenURI(uint256 _tokenId)
1243     public
1244     view
1245     virtual
1246     override
1247     returns (string memory)
1248   {
1249     require(
1250       _exists(_tokenId),
1251       "ERC721Metadata: URI query for nonexistent token"
1252     );
1253 
1254     if (revealed == false) {
1255       return hiddenMetadataUri;
1256     }
1257 
1258     string memory currentBaseURI = _baseURI();
1259     return bytes(currentBaseURI).length > 0
1260         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1261         : "";
1262   }
1263 
1264   function setRevealed(bool _state) public onlyOwner {
1265     revealed = _state;
1266   }
1267 
1268   function setmintNFTPrice(uint256 _mintNFTPrice) public onlyOwner {
1269     mintNFTPrice = _mintNFTPrice;
1270   }
1271 
1272   function setMaxmintNFTAmountPerTx(uint256 _maxmintNFTAmountPerTx) public onlyOwner {
1273     maxmintNFTAmountPerTx = _maxmintNFTAmountPerTx;
1274   }
1275 
1276   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1277     hiddenMetadataUri = _hiddenMetadataUri;
1278   }
1279 
1280   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1281     uriPrefix = _uriPrefix;
1282   }
1283 
1284   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1285     uriSuffix = _uriSuffix;
1286   }
1287 
1288   function setPaused(bool _state) public onlyOwner {
1289     paused = _state;
1290   }
1291 
1292   function withdraw() public onlyOwner {
1293 
1294 
1295     // This will transfer the remaining contract balance to the owner.
1296     // Do not remove this otherwise you will not be able to withdraw the funds.
1297     // =============================================================================
1298     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1299     require(os);
1300     // =============================================================================
1301   }
1302 
1303   function _mintNFTLoop(address _receiver, uint256 _mintNFTAmount) internal {
1304     for (uint256 i = 0; i < _mintNFTAmount; i++) {
1305       supply.increment();
1306       _safemintNFT(_receiver, supply.current());
1307     }
1308   }
1309 
1310   function _baseURI() internal view virtual override returns (string memory) {
1311     return uriPrefix;
1312   }
1313 }