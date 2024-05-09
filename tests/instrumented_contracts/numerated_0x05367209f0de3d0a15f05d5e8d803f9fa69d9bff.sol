1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/Okay Pumpkins.sol
4 
5 
6 
7 // File: @openzeppelin/contracts/utils/Counters.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/Strings.sol
47 
48 
49 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev String operations.
55  */
56 library Strings {
57     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
58     uint8 private constant _ADDRESS_LENGTH = 20;
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 
116     /**
117      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
118      */
119     function toHexString(address addr) internal pure returns (string memory) {
120         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
121     }
122 }
123 
124 // File: @openzeppelin/contracts/utils/Context.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @dev Provides information about the current execution context, including the
133  * sender of the transaction and its data. While these are generally available
134  * via msg.sender and msg.data, they should not be accessed in such a direct
135  * manner, since when dealing with meta-transactions the account sending and
136  * paying for execution may not be the actual sender (as far as an application
137  * is concerned).
138  *
139  * This contract is only required for intermediate, library-like contracts.
140  */
141 abstract contract Context {
142     function _msgSender() internal view virtual returns (address) {
143         return msg.sender;
144     }
145 
146     function _msgData() internal view virtual returns (bytes calldata) {
147         return msg.data;
148     }
149 }
150 
151 // File: @openzeppelin/contracts/access/Ownable.sol
152 
153 
154 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 
159 /**
160  * @dev Contract module which provides a basic access control mechanism, where
161  * there is an account (an owner) that can be granted exclusive access to
162  * specific functions.
163  *
164  * By default, the owner account will be the one that deploys the contract. This
165  * can later be changed with {transferOwnership}.
166  *
167  * This module is used through inheritance. It will make available the modifier
168  * `onlyOwner`, which can be applied to your functions to restrict their use to
169  * the owner.
170  */
171 abstract contract Ownable is Context {
172     address private _owner;
173 
174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
175 
176     /**
177      * @dev Initializes the contract setting the deployer as the initial owner.
178      */
179     constructor() {
180         _transferOwnership(_msgSender());
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         _checkOwner();
188         _;
189     }
190 
191     /**
192      * @dev Returns the address of the current owner.
193      */
194     function owner() public view virtual returns (address) {
195         return _owner;
196     }
197 
198     /**
199      * @dev Throws if the sender is not the owner.
200      */
201     function _checkOwner() internal view virtual {
202         require(owner() == _msgSender(), "Ownable: caller is not the owner");
203     }
204 
205     /**
206      * @dev Leaves the contract without owner. It will not be possible to call
207      * `onlyOwner` functions anymore. Can only be called by the current owner.
208      *
209      * NOTE: Renouncing ownership will leave the contract without an owner,
210      * thereby removing any functionality that is only available to the owner.
211      */
212     function renounceOwnership() public virtual onlyOwner {
213         _transferOwnership(address(0));
214     }
215 
216     /**
217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
218      * Can only be called by the current owner.
219      */
220     function transferOwnership(address newOwner) public virtual onlyOwner {
221         require(newOwner != address(0), "Ownable: new owner is the zero address");
222         _transferOwnership(newOwner);
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Internal function without access restriction.
228      */
229     function _transferOwnership(address newOwner) internal virtual {
230         address oldOwner = _owner;
231         _owner = newOwner;
232         emit OwnershipTransferred(oldOwner, newOwner);
233     }
234 }
235 
236 // File: @openzeppelin/contracts/utils/Address.sol
237 
238 
239 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
240 
241 pragma solidity ^0.8.1;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      *
264      * [IMPORTANT]
265      * ====
266      * You shouldn't rely on `isContract` to protect against flash loan attacks!
267      *
268      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
269      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
270      * constructor.
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies on extcodesize/address.code.length, which returns 0
275         // for contracts in construction, since the code is only stored at the end
276         // of the constructor execution.
277 
278         return account.code.length > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         (bool success, ) = recipient.call{value: amount}("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain `call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         require(isContract(target), "Address: call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.call{value: value}(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
385         return functionStaticCall(target, data, "Address: low-level static call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal view returns (bytes memory) {
399         require(isContract(target), "Address: static call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.staticcall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
412         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(isContract(target), "Address: delegate call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.delegatecall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
434      * revert reason using the provided one.
435      *
436      * _Available since v4.3._
437      */
438     function verifyCallResult(
439         bool success,
440         bytes memory returndata,
441         string memory errorMessage
442     ) internal pure returns (bytes memory) {
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449                 /// @solidity memory-safe-assembly
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @title ERC721 token receiver interface
470  * @dev Interface for any contract that wants to support safeTransfers
471  * from ERC721 asset contracts.
472  */
473 interface IERC721Receiver {
474     /**
475      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
476      * by `operator` from `from`, this function is called.
477      *
478      * It must return its Solidity selector to confirm the token transfer.
479      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
480      *
481      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
482      */
483     function onERC721Received(
484         address operator,
485         address from,
486         uint256 tokenId,
487         bytes calldata data
488     ) external returns (bytes4);
489 }
490 
491 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Interface of the ERC165 standard, as defined in the
500  * https://eips.ethereum.org/EIPS/eip-165[EIP].
501  *
502  * Implementers can declare support of contract interfaces, which can then be
503  * queried by others ({ERC165Checker}).
504  *
505  * For an implementation, see {ERC165}.
506  */
507 interface IERC165 {
508     /**
509      * @dev Returns true if this contract implements the interface defined by
510      * `interfaceId`. See the corresponding
511      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
512      * to learn more about how these ids are created.
513      *
514      * This function call must use less than 30 000 gas.
515      */
516     function supportsInterface(bytes4 interfaceId) external view returns (bool);
517 }
518 
519 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @dev Implementation of the {IERC165} interface.
529  *
530  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
531  * for the additional interface id that will be supported. For example:
532  *
533  * ```solidity
534  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
536  * }
537  * ```
538  *
539  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
540  */
541 abstract contract ERC165 is IERC165 {
542     /**
543      * @dev See {IERC165-supportsInterface}.
544      */
545     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546         return interfaceId == type(IERC165).interfaceId;
547     }
548 }
549 
550 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
551 
552 
553 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Required interface of an ERC721 compliant contract.
560  */
561 interface IERC721 is IERC165 {
562     /**
563      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
564      */
565     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
566 
567     /**
568      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
569      */
570     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
574      */
575     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
576 
577     /**
578      * @dev Returns the number of tokens in ``owner``'s account.
579      */
580     function balanceOf(address owner) external view returns (uint256 balance);
581 
582     /**
583      * @dev Returns the owner of the `tokenId` token.
584      *
585      * Requirements:
586      *
587      * - `tokenId` must exist.
588      */
589     function ownerOf(uint256 tokenId) external view returns (address owner);
590 
591     /**
592      * @dev Safely transfers `tokenId` token from `from` to `to`.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must exist and be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
601      *
602      * Emits a {Transfer} event.
603      */
604     function safeTransferFrom(
605         address from,
606         address to,
607         uint256 tokenId,
608         bytes calldata data
609     ) external;
610 
611     /**
612      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
613      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId
629     ) external;
630 
631     /**
632      * @dev Transfers `tokenId` token from `from` to `to`.
633      *
634      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must be owned by `from`.
641      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
642      *
643      * Emits a {Transfer} event.
644      */
645     function transferFrom(
646         address from,
647         address to,
648         uint256 tokenId
649     ) external;
650 
651     /**
652      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
653      * The approval is cleared when the token is transferred.
654      *
655      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
656      *
657      * Requirements:
658      *
659      * - The caller must own the token or be an approved operator.
660      * - `tokenId` must exist.
661      *
662      * Emits an {Approval} event.
663      */
664     function approve(address to, uint256 tokenId) external;
665 
666     /**
667      * @dev Approve or remove `operator` as an operator for the caller.
668      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
669      *
670      * Requirements:
671      *
672      * - The `operator` cannot be the caller.
673      *
674      * Emits an {ApprovalForAll} event.
675      */
676     function setApprovalForAll(address operator, bool _approved) external;
677 
678     /**
679      * @dev Returns the account approved for `tokenId` token.
680      *
681      * Requirements:
682      *
683      * - `tokenId` must exist.
684      */
685     function getApproved(uint256 tokenId) external view returns (address operator);
686 
687     /**
688      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
689      *
690      * See {setApprovalForAll}
691      */
692     function isApprovedForAll(address owner, address operator) external view returns (bool);
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
696 
697 
698 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
705  * @dev See https://eips.ethereum.org/EIPS/eip-721
706  */
707 interface IERC721Metadata is IERC721 {
708     /**
709      * @dev Returns the token collection name.
710      */
711     function name() external view returns (string memory);
712 
713     /**
714      * @dev Returns the token collection symbol.
715      */
716     function symbol() external view returns (string memory);
717 
718     /**
719      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
720      */
721     function tokenURI(uint256 tokenId) external view returns (string memory);
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
725 
726 
727 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 
733 
734 
735 
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
754     mapping(uint256 => address) private _owners;
755 
756     // Mapping owner address to token count
757     mapping(address => uint256) private _balances;
758 
759     // Mapping from token ID to approved address
760     mapping(uint256 => address) private _tokenApprovals;
761 
762     // Mapping from owner to operator approvals
763     mapping(address => mapping(address => bool)) private _operatorApprovals;
764 
765     /**
766      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
767      */
768     constructor(string memory name_, string memory symbol_) {
769         _name = name_;
770         _symbol = symbol_;
771     }
772 
773     /**
774      * @dev See {IERC165-supportsInterface}.
775      */
776     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
777         return
778             interfaceId == type(IERC721).interfaceId ||
779             interfaceId == type(IERC721Metadata).interfaceId ||
780             super.supportsInterface(interfaceId);
781     }
782 
783     /**
784      * @dev See {IERC721-balanceOf}.
785      */
786     function balanceOf(address owner) public view virtual override returns (uint256) {
787         require(owner != address(0), "ERC721: address zero is not a valid owner");
788         return _balances[owner];
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
795         address owner = _owners[tokenId];
796         require(owner != address(0), "ERC721: invalid token ID");
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
818         _requireMinted(tokenId);
819 
820         string memory baseURI = _baseURI();
821         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
822     }
823 
824     /**
825      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
826      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
827      * by default, can be overridden in child contracts.
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
840         require(
841             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
842             "ERC721: approve caller is not token owner nor approved for all"
843         );
844 
845         _approve(to, tokenId);
846     }
847 
848     /**
849      * @dev See {IERC721-getApproved}.
850      */
851     function getApproved(uint256 tokenId) public view virtual override returns (address) {
852         _requireMinted(tokenId);
853 
854         return _tokenApprovals[tokenId];
855     }
856 
857     /**
858      * @dev See {IERC721-setApprovalForAll}.
859      */
860     function setApprovalForAll(address operator, bool approved) public virtual override {
861         _setApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     /**
865      * @dev See {IERC721-isApprovedForAll}.
866      */
867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
868         return _operatorApprovals[owner][operator];
869     }
870 
871     /**
872      * @dev See {IERC721-transferFrom}.
873      */
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         //solhint-disable-next-line max-line-length
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
881 
882         _transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         safeTransferFrom(from, to, tokenId, "");
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory data
904     ) public virtual override {
905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
906         _safeTransfer(from, to, tokenId, data);
907     }
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
911      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
912      *
913      * `data` is additional data, it has no specified format and it is sent in call to `to`.
914      *
915      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
916      * implement alternative mechanisms to perform token transfer, such as signature-based.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeTransfer(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory data
932     ) internal virtual {
933         _transfer(from, to, tokenId);
934         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      * and stop existing when they are burned (`_burn`).
944      */
945     function _exists(uint256 tokenId) internal view virtual returns (bool) {
946         return _owners[tokenId] != address(0);
947     }
948 
949     /**
950      * @dev Returns whether `spender` is allowed to manage `tokenId`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      */
956     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
957         address owner = ERC721.ownerOf(tokenId);
958         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
959     }
960 
961     /**
962      * @dev Safely mints `tokenId` and transfers it to `to`.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must not exist.
967      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _safeMint(address to, uint256 tokenId) internal virtual {
972         _safeMint(to, tokenId, "");
973     }
974 
975     /**
976      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
977      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
978      */
979     function _safeMint(
980         address to,
981         uint256 tokenId,
982         bytes memory data
983     ) internal virtual {
984         _mint(to, tokenId);
985         require(
986             _checkOnERC721Received(address(0), to, tokenId, data),
987             "ERC721: transfer to non ERC721Receiver implementer"
988         );
989     }
990 
991     /**
992      * @dev Mints `tokenId` and transfers it to `to`.
993      *
994      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
995      *
996      * Requirements:
997      *
998      * - `tokenId` must not exist.
999      * - `to` cannot be the zero address.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _mint(address to, uint256 tokenId) internal virtual {
1004         require(to != address(0), "ERC721: mint to the zero address");
1005         require(!_exists(tokenId), "ERC721: token already minted");
1006 
1007         _beforeTokenTransfer(address(0), to, tokenId);
1008 
1009         _balances[to] += 1;
1010         _owners[tokenId] = to;
1011 
1012         emit Transfer(address(0), to, tokenId);
1013 
1014         _afterTokenTransfer(address(0), to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev Destroys `tokenId`.
1019      * The approval is cleared when the token is burned.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _burn(uint256 tokenId) internal virtual {
1028         address owner = ERC721.ownerOf(tokenId);
1029 
1030         _beforeTokenTransfer(owner, address(0), tokenId);
1031 
1032         // Clear approvals
1033         _approve(address(0), tokenId);
1034 
1035         _balances[owner] -= 1;
1036         delete _owners[tokenId];
1037 
1038         emit Transfer(owner, address(0), tokenId);
1039 
1040         _afterTokenTransfer(owner, address(0), tokenId);
1041     }
1042 
1043     /**
1044      * @dev Transfers `tokenId` from `from` to `to`.
1045      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1046      *
1047      * Requirements:
1048      *
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must be owned by `from`.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _transfer(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) internal virtual {
1059         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1060         require(to != address(0), "ERC721: transfer to the zero address");
1061 
1062         _beforeTokenTransfer(from, to, tokenId);
1063 
1064         // Clear approvals from the previous owner
1065         _approve(address(0), tokenId);
1066 
1067         _balances[from] -= 1;
1068         _balances[to] += 1;
1069         _owners[tokenId] = to;
1070 
1071         emit Transfer(from, to, tokenId);
1072 
1073         _afterTokenTransfer(from, to, tokenId);
1074     }
1075 
1076     /**
1077      * @dev Approve `to` to operate on `tokenId`
1078      *
1079      * Emits an {Approval} event.
1080      */
1081     function _approve(address to, uint256 tokenId) internal virtual {
1082         _tokenApprovals[tokenId] = to;
1083         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev Approve `operator` to operate on all of `owner` tokens
1088      *
1089      * Emits an {ApprovalForAll} event.
1090      */
1091     function _setApprovalForAll(
1092         address owner,
1093         address operator,
1094         bool approved
1095     ) internal virtual {
1096         require(owner != operator, "ERC721: approve to caller");
1097         _operatorApprovals[owner][operator] = approved;
1098         emit ApprovalForAll(owner, operator, approved);
1099     }
1100 
1101     /**
1102      * @dev Reverts if the `tokenId` has not been minted yet.
1103      */
1104     function _requireMinted(uint256 tokenId) internal view virtual {
1105         require(_exists(tokenId), "ERC721: invalid token ID");
1106     }
1107 
1108     /**
1109      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1110      * The call is not executed if the target address is not a contract.
1111      *
1112      * @param from address representing the previous owner of the given token ID
1113      * @param to target address that will receive the tokens
1114      * @param tokenId uint256 ID of the token to be transferred
1115      * @param data bytes optional data to send along with the call
1116      * @return bool whether the call correctly returned the expected magic value
1117      */
1118     function _checkOnERC721Received(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory data
1123     ) private returns (bool) {
1124         if (to.isContract()) {
1125             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1126                 return retval == IERC721Receiver.onERC721Received.selector;
1127             } catch (bytes memory reason) {
1128                 if (reason.length == 0) {
1129                     revert("ERC721: transfer to non ERC721Receiver implementer");
1130                 } else {
1131                     /// @solidity memory-safe-assembly
1132                     assembly {
1133                         revert(add(32, reason), mload(reason))
1134                     }
1135                 }
1136             }
1137         } else {
1138             return true;
1139         }
1140     }
1141 
1142     /**
1143      * @dev Hook that is called before any token transfer. This includes minting
1144      * and burning.
1145      *
1146      * Calling conditions:
1147      *
1148      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1149      * transferred to `to`.
1150      * - When `from` is zero, `tokenId` will be minted for `to`.
1151      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1152      * - `from` and `to` are never both zero.
1153      *
1154      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1155      */
1156     function _beforeTokenTransfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual {}
1161 
1162     /**
1163      * @dev Hook that is called after any transfer of tokens. This includes
1164      * minting and burning.
1165      *
1166      * Calling conditions:
1167      *
1168      * - when `from` and `to` are both non-zero.
1169      * - `from` and `to` are never both zero.
1170      *
1171      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1172      */
1173     function _afterTokenTransfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) internal virtual {}
1178 }
1179 
1180 // File: contracts/SpaceRocket999.sol
1181 
1182 
1183 
1184 
1185 
1186 pragma solidity >=0.7.0 <0.9.0;
1187 
1188 
1189 
1190 
1191 contract OkayPumpkins is ERC721, Ownable {
1192   using Strings for uint256;
1193   using Counters for Counters.Counter;
1194 
1195   Counters.Counter private supply;
1196 
1197   string public uriPrefix = "";
1198   string public uriSuffix = "";
1199   string public hiddenMetadataUri;
1200   
1201   uint256 public cost = 0 ether;
1202   uint256 public finalMaxSupply = 2222;
1203   uint256 public currentMaxSupply = 2;
1204   uint256 public maxMintAmountPerTx = 3;
1205 
1206   bool public paused = true;
1207   bool public revealed = false;
1208 
1209   constructor() ERC721("Okay Pumpkins", "Pumpkins") {
1210     setHiddenMetadataUri("ipfs://bafybeie3fvpmwnhu7ha4dwwla7h2thzsodetwnjm7dll33tvh5gpfajy4m/");
1211   }
1212 
1213   modifier mintCompliance(uint256 _mintAmount) {
1214     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1215     require(supply.current() + _mintAmount <= currentMaxSupply, "Max supply exceeded!");
1216     _;
1217   }
1218 
1219   function totalSupply() public view returns (uint256) {
1220     return supply.current();
1221   }
1222 
1223   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1224     require(!paused, "The contract is paused!");
1225     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1226 
1227     _mintLoop(msg.sender, _mintAmount);
1228   }
1229   
1230   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1231     _mintLoop(_receiver, _mintAmount);
1232   }
1233 
1234   function walletOfOwner(address _owner)
1235     public
1236     view
1237     returns (uint256[] memory)
1238   {
1239     uint256 ownerTokenCount = balanceOf(_owner);
1240     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1241     uint256 currentTokenId = 1;
1242     uint256 ownedTokenIndex = 0;
1243 
1244     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= currentMaxSupply) {
1245       address currentTokenOwner = ownerOf(currentTokenId);
1246 
1247       if (currentTokenOwner == _owner) {
1248         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1249 
1250         ownedTokenIndex++;
1251       }
1252 
1253       currentTokenId++;
1254     }
1255 
1256     return ownedTokenIds;
1257   }
1258 
1259   function tokenURI(uint256 _tokenId)
1260     public
1261     view
1262     virtual
1263     override
1264     returns (string memory)
1265   {
1266     require(
1267       _exists(_tokenId),
1268       "ERC721Metadata: URI query for nonexistent token"
1269     );
1270 
1271     if (revealed == false) {
1272       return hiddenMetadataUri;
1273     }
1274 
1275     string memory currentBaseURI = _baseURI();
1276     return bytes(currentBaseURI).length > 0
1277         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1278         : "";
1279   }
1280 
1281   function setCurrentMaxSupply(uint256 _supply) public onlyOwner { 
1282     require (_supply <= finalMaxSupply && _supply >= totalSupply());  
1283     currentMaxSupply = _supply;
1284   }
1285 
1286   function resetFinalMaxSupply() public onlyOwner {
1287       finalMaxSupply = currentMaxSupply;
1288   }
1289 
1290   function setRevealed(bool _state) public onlyOwner {
1291     revealed = _state;
1292   }
1293 
1294   function setCost(uint256 _cost) public onlyOwner {
1295     cost = _cost;
1296   }
1297 
1298   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1299     maxMintAmountPerTx = _maxMintAmountPerTx;
1300   }
1301 
1302   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1303     hiddenMetadataUri = _hiddenMetadataUri;
1304   }
1305 
1306   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1307     uriPrefix = _uriPrefix;
1308   }
1309 
1310   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1311     uriSuffix = _uriSuffix;
1312   }
1313 
1314   function setPaused(bool _state) public onlyOwner {
1315     paused = _state;
1316   }
1317 
1318   function withdraw() public onlyOwner {
1319    
1320     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1321     require(os);
1322     // =============================================================================
1323   }
1324 
1325   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1326     for (uint256 i = 0; i < _mintAmount; i++) {
1327       supply.increment();
1328       _safeMint(_receiver, supply.current());
1329     }
1330   }
1331 
1332   function _baseURI() internal view virtual override returns (string memory) {
1333     return uriPrefix;
1334   }
1335 }