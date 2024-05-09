1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/Counters.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @title Counters
16  * @author Matt Condon (@shrugs)
17  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
18  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
19  *
20  * Include with `using Counters for Counters.Counter;`
21  */
22 library Counters {
23     struct Counter {
24         // This variable should never be directly accessed by users of the library: interactions must be restricted to
25         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
26         // this feature: see https://github.com/ethereum/solidity/issues/4637
27         uint256 _value; // default: 0
28     }
29 
30     function current(Counter storage counter) internal view returns (uint256) {
31         return counter._value;
32     }
33 
34     function increment(Counter storage counter) internal {
35         unchecked {
36             counter._value += 1;
37         }
38     }
39 
40     function decrement(Counter storage counter) internal {
41         uint256 value = counter._value;
42         require(value > 0, "Counter: decrement overflow");
43         unchecked {
44             counter._value = value - 1;
45         }
46     }
47 
48     function reset(Counter storage counter) internal {
49         counter._value = 0;
50     }
51 }
52 
53 // File: @openzeppelin/contracts/utils/Strings.sol
54 
55 
56 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
68      */
69     function toString(uint256 value) internal pure returns (string memory) {
70         // Inspired by OraclizeAPI's implementation - MIT licence
71         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
72 
73         if (value == 0) {
74             return "0";
75         }
76         uint256 temp = value;
77         uint256 digits;
78         while (temp != 0) {
79             digits++;
80             temp /= 10;
81         }
82         bytes memory buffer = new bytes(digits);
83         while (value != 0) {
84             digits -= 1;
85             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
86             value /= 10;
87         }
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
93      */
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
109      */
110     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = _HEX_SYMBOLS[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Context.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Provides information about the current execution context, including the
132  * sender of the transaction and its data. While these are generally available
133  * via msg.sender and msg.data, they should not be accessed in such a direct
134  * manner, since when dealing with meta-transactions the account sending and
135  * paying for execution may not be the actual sender (as far as an application
136  * is concerned).
137  *
138  * This contract is only required for intermediate, library-like contracts.
139  */
140 abstract contract Context {
141     function _msgSender() internal view virtual returns (address) {
142         return msg.sender;
143     }
144 
145     function _msgData() internal view virtual returns (bytes calldata) {
146         return msg.data;
147     }
148 }
149 
150 // File: @openzeppelin/contracts/access/Ownable.sol
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 
158 /**
159  * @dev Contract module which provides a basic access control mechanism, where
160  * there is an account (an owner) that can be granted exclusive access to
161  * specific functions.
162  *
163  * By default, the owner account will be the one that deploys the contract. This
164  * can later be changed with {transferOwnership}.
165  *
166  * This module is used through inheritance. It will make available the modifier
167  * `onlyOwner`, which can be applied to your functions to restrict their use to
168  * the owner.
169  */
170 abstract contract Ownable is Context {
171     address private _owner;
172 
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     /**
176      * @dev Initializes the contract setting the deployer as the initial owner.
177      */
178     constructor() {
179         _transferOwnership(_msgSender());
180     }
181 
182     /**
183      * @dev Returns the address of the current owner.
184      */
185     function owner() public view virtual returns (address) {
186         return _owner;
187     }
188 
189     /**
190      * @dev Throws if called by any account other than the owner.
191      */
192     modifier onlyOwner() {
193         require(owner() == _msgSender(), "Ownable: caller is not the owner");
194         _;
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
231 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
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
441 
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
456 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
473      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
545 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
584      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
585      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     /**
604      * @dev Transfers `tokenId` token from `from` to `to`.
605      *
606      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      *
615      * Emits a {Transfer} event.
616      */
617     function transferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
625      * The approval is cleared when the token is transferred.
626      *
627      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
628      *
629      * Requirements:
630      *
631      * - The caller must own the token or be an approved operator.
632      * - `tokenId` must exist.
633      *
634      * Emits an {Approval} event.
635      */
636     function approve(address to, uint256 tokenId) external;
637 
638     /**
639      * @dev Returns the account approved for `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function getApproved(uint256 tokenId) external view returns (address operator);
646 
647     /**
648      * @dev Approve or remove `operator` as an operator for the caller.
649      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
650      *
651      * Requirements:
652      *
653      * - The `operator` cannot be the caller.
654      *
655      * Emits an {ApprovalForAll} event.
656      */
657     function setApprovalForAll(address operator, bool _approved) external;
658 
659     /**
660      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
661      *
662      * See {setApprovalForAll}
663      */
664     function isApprovedForAll(address owner, address operator) external view returns (bool);
665 
666     /**
667      * @dev Safely transfers `tokenId` token from `from` to `to`.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes calldata data
684     ) external;
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
719 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
779         require(owner != address(0), "ERC721: balance query for the zero address");
780         return _balances[owner];
781     }
782 
783     /**
784      * @dev See {IERC721-ownerOf}.
785      */
786     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
787         address owner = _owners[tokenId];
788         require(owner != address(0), "ERC721: owner query for nonexistent token");
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
810         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
811 
812         string memory baseURI = _baseURI();
813         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
814     }
815 
816     /**
817      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
818      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
819      * by default, can be overriden in child contracts.
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
834             "ERC721: approve caller is not owner nor approved for all"
835         );
836 
837         _approve(to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-getApproved}.
842      */
843     function getApproved(uint256 tokenId) public view virtual override returns (address) {
844         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
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
872         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
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
895         bytes memory _data
896     ) public virtual override {
897         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
898         _safeTransfer(from, to, tokenId, _data);
899     }
900 
901     /**
902      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
903      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
904      *
905      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
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
923         bytes memory _data
924     ) internal virtual {
925         _transfer(from, to, tokenId);
926         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
927     }
928 
929     /**
930      * @dev Returns whether `tokenId` exists.
931      *
932      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
933      *
934      * Tokens start existing when they are minted (`_mint`),
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
949         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
950         address owner = ERC721.ownerOf(tokenId);
951         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
952     }
953 
954     /**
955      * @dev Safely mints `tokenId` and transfers it to `to`.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must not exist.
960      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _safeMint(address to, uint256 tokenId) internal virtual {
965         _safeMint(to, tokenId, "");
966     }
967 
968     /**
969      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
970      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
971      */
972     function _safeMint(
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) internal virtual {
977         _mint(to, tokenId);
978         require(
979             _checkOnERC721Received(address(0), to, tokenId, _data),
980             "ERC721: transfer to non ERC721Receiver implementer"
981         );
982     }
983 
984     /**
985      * @dev Mints `tokenId` and transfers it to `to`.
986      *
987      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
988      *
989      * Requirements:
990      *
991      * - `tokenId` must not exist.
992      * - `to` cannot be the zero address.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _mint(address to, uint256 tokenId) internal virtual {
997         require(to != address(0), "ERC721: mint to the zero address");
998         require(!_exists(tokenId), "ERC721: token already minted");
999 
1000         _beforeTokenTransfer(address(0), to, tokenId);
1001 
1002         _balances[to] += 1;
1003         _owners[tokenId] = to;
1004 
1005         emit Transfer(address(0), to, tokenId);
1006 
1007         _afterTokenTransfer(address(0), to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev Destroys `tokenId`.
1012      * The approval is cleared when the token is burned.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _burn(uint256 tokenId) internal virtual {
1021         address owner = ERC721.ownerOf(tokenId);
1022 
1023         _beforeTokenTransfer(owner, address(0), tokenId);
1024 
1025         // Clear approvals
1026         _approve(address(0), tokenId);
1027 
1028         _balances[owner] -= 1;
1029         delete _owners[tokenId];
1030 
1031         emit Transfer(owner, address(0), tokenId);
1032 
1033         _afterTokenTransfer(owner, address(0), tokenId);
1034     }
1035 
1036     /**
1037      * @dev Transfers `tokenId` from `from` to `to`.
1038      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1039      *
1040      * Requirements:
1041      *
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must be owned by `from`.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) internal virtual {
1052         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1053         require(to != address(0), "ERC721: transfer to the zero address");
1054 
1055         _beforeTokenTransfer(from, to, tokenId);
1056 
1057         // Clear approvals from the previous owner
1058         _approve(address(0), tokenId);
1059 
1060         _balances[from] -= 1;
1061         _balances[to] += 1;
1062         _owners[tokenId] = to;
1063 
1064         emit Transfer(from, to, tokenId);
1065 
1066         _afterTokenTransfer(from, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Approve `to` to operate on `tokenId`
1071      *
1072      * Emits a {Approval} event.
1073      */
1074     function _approve(address to, uint256 tokenId) internal virtual {
1075         _tokenApprovals[tokenId] = to;
1076         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `operator` to operate on all of `owner` tokens
1081      *
1082      * Emits a {ApprovalForAll} event.
1083      */
1084     function _setApprovalForAll(
1085         address owner,
1086         address operator,
1087         bool approved
1088     ) internal virtual {
1089         require(owner != operator, "ERC721: approve to caller");
1090         _operatorApprovals[owner][operator] = approved;
1091         emit ApprovalForAll(owner, operator, approved);
1092     }
1093 
1094     /**
1095      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1096      * The call is not executed if the target address is not a contract.
1097      *
1098      * @param from address representing the previous owner of the given token ID
1099      * @param to target address that will receive the tokens
1100      * @param tokenId uint256 ID of the token to be transferred
1101      * @param _data bytes optional data to send along with the call
1102      * @return bool whether the call correctly returned the expected magic value
1103      */
1104     function _checkOnERC721Received(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) private returns (bool) {
1110         if (to.isContract()) {
1111             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1112                 return retval == IERC721Receiver.onERC721Received.selector;
1113             } catch (bytes memory reason) {
1114                 if (reason.length == 0) {
1115                     revert("ERC721: transfer to non ERC721Receiver implementer");
1116                 } else {
1117                     assembly {
1118                         revert(add(32, reason), mload(reason))
1119                     }
1120                 }
1121             }
1122         } else {
1123             return true;
1124         }
1125     }
1126 
1127     /**
1128      * @dev Hook that is called before any token transfer. This includes minting
1129      * and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1134      * transferred to `to`.
1135      * - When `from` is zero, `tokenId` will be minted for `to`.
1136      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1137      * - `from` and `to` are never both zero.
1138      *
1139      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1140      */
1141     function _beforeTokenTransfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after any transfer of tokens. This includes
1149      * minting and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - when `from` and `to` are both non-zero.
1154      * - `from` and `to` are never both zero.
1155      *
1156      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1157      */
1158     function _afterTokenTransfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) internal virtual {}
1163 }
1164 
1165 // File: contracts/larvacucks.sol
1166 
1167 
1168 
1169 pragma solidity >=0.7.0 <0.9.0;
1170 
1171 
1172 
1173 
1174 contract CryptLarvas is ERC721, Ownable {
1175   using Strings for uint256;
1176   using Counters for Counters.Counter;
1177 
1178   Counters.Counter private _totalsupply;
1179 
1180   string uriPrefix = "";
1181   string public uriSuffix = ".json";
1182   string public hiddenMetadataUri;
1183   
1184   uint256 public cost = 0.005 ether;
1185   uint256 public maxSupply = 5000;
1186   uint256 public maxMintAmountPerTx = 20;
1187 
1188   bool public paused = true;
1189   bool public revealed = true;
1190   bool public dynamicCost = true;
1191 
1192   constructor() ERC721("CryptoLarvas", "CrypLar") {
1193     setHiddenMetadataUri("ipfs://QmQG6HCKFYFTTxVRANhvmMhnaCN3yWppinuEcwdPVsZyVg/Hidden.json");
1194   }
1195 
1196   modifier mintCompliance(uint256 _mintAmount) {
1197     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1198     require(_totalsupply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1199     _;
1200   }
1201 
1202   function totalSupply() public view returns (uint256) {
1203     return _totalsupply.current();
1204   }
1205 
1206    function calculateDynamicCost() internal view returns (uint256 _cost) {
1207      uint256 supply = totalSupply();
1208     if (supply < 2000){
1209         return 0 ether;
1210     }
1211     if (supply <= maxSupply){
1212         return 0.0069 ether;
1213     }
1214   } 
1215 
1216   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1217     require(!paused, "The contract is paused!");
1218     if(dynamicCost== true){
1219         require( msg.value >= calculateDynamicCost() * _mintAmount, "Insufficient funds!");
1220     } else{
1221         require( msg.value >= cost * _mintAmount, "Insufficient funds!");
1222 
1223 }
1224 
1225     _mintLoop(msg.sender, _mintAmount);
1226   }
1227   
1228   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1229     _mintLoop(_receiver, _mintAmount);
1230   }
1231 
1232   function walletOfOwner(address _owner)
1233     public
1234     view
1235     returns (uint256[] memory)
1236   {
1237     uint256 ownerTokenCount = balanceOf(_owner);
1238     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1239     uint256 currentTokenId = 1;
1240     uint256 ownedTokenIndex = 0;
1241 
1242     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1243       address currentTokenOwner = ownerOf(currentTokenId);
1244 
1245       if (currentTokenOwner == _owner) {
1246         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1247 
1248         ownedTokenIndex++;
1249       }
1250 
1251       currentTokenId++;
1252     }
1253 
1254     return ownedTokenIds;
1255   }
1256 
1257   function tokenURI(uint256 _tokenId)
1258     public
1259     view
1260     virtual
1261     override
1262     returns (string memory)
1263   {
1264     require(
1265       _exists(_tokenId),
1266       "ERC721Metadata: URI query for nonexistent token"
1267     );
1268 
1269     if (revealed == false) {
1270       return hiddenMetadataUri;
1271     }
1272 
1273     string memory currentBaseURI = _baseURI();
1274     return bytes(currentBaseURI).length > 0
1275         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1276         : "";
1277   }
1278 
1279   function setRevealed(bool _state) public onlyOwner {
1280     revealed = _state;
1281   }
1282 
1283   function setCost(uint256 _cost) public onlyOwner {
1284     cost = _cost;
1285   }
1286 
1287   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1288     maxMintAmountPerTx = _maxMintAmountPerTx;
1289   }
1290 
1291   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1292     hiddenMetadataUri = _hiddenMetadataUri;
1293   }
1294 
1295   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1296     uriPrefix = _uriPrefix;
1297   }
1298 
1299   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1300     uriSuffix = _uriSuffix;
1301   }
1302 
1303    function setDynamicCost(bool _state) public onlyOwner {
1304     dynamicCost = _state;
1305   }
1306 
1307   function setPaused(bool _state) public onlyOwner {
1308     paused = _state;
1309   }
1310 
1311   function withdraw() public onlyOwner {
1312    
1313     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1314     require(os);
1315     
1316   }
1317 
1318   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1319     for (uint256 i = 0; i < _mintAmount; i++) {
1320       _totalsupply.increment();
1321       _safeMint(_receiver, _totalsupply.current());
1322     }
1323   }
1324 
1325   function _baseURI() internal view virtual override returns (string memory) {
1326     return uriPrefix;
1327   }
1328 }