1 // File: contracts/sada.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/Counters.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @title Counters
14  * @author Matt Condon (@shrugs)
15  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
16  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
17  *
18  * Include with `using Counters for Counters.Counter;`
19  */
20 library Counters {
21     struct Counter {
22         // This variable should never be directly accessed by users of the library: interactions must be restricted to
23         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
24         // this feature: see https://github.com/ethereum/solidity/issues/4637
25         uint256 _value; // default: 0
26     }
27 
28     function current(Counter storage counter) internal view returns (uint256) {
29         return counter._value;
30     }
31 
32     function increment(Counter storage counter) internal {
33         unchecked {
34             counter._value += 1;
35         }
36     }
37 
38     function decrement(Counter storage counter) internal {
39         uint256 value = counter._value;
40         require(value > 0, "Counter: decrement overflow");
41         unchecked {
42             counter._value = value - 1;
43         }
44     }
45 
46     function reset(Counter storage counter) internal {
47         counter._value = 0;
48     }
49 }
50 
51 // File: @openzeppelin/contracts/utils/Strings.sol
52 
53 
54 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev String operations.
60  */
61 library Strings {
62     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
66      */
67     function toString(uint256 value) internal pure returns (string memory) {
68         // Inspired by OraclizeAPI's implementation - MIT licence
69         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
70 
71         if (value == 0) {
72             return "0";
73         }
74         uint256 temp = value;
75         uint256 digits;
76         while (temp != 0) {
77             digits++;
78             temp /= 10;
79         }
80         bytes memory buffer = new bytes(digits);
81         while (value != 0) {
82             digits -= 1;
83             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
84             value /= 10;
85         }
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
91      */
92     function toHexString(uint256 value) internal pure returns (string memory) {
93         if (value == 0) {
94             return "0x00";
95         }
96         uint256 temp = value;
97         uint256 length = 0;
98         while (temp != 0) {
99             length++;
100             temp >>= 8;
101         }
102         return toHexString(value, length);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
107      */
108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = _HEX_SYMBOLS[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 
121 // File: @openzeppelin/contracts/utils/Context.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Provides information about the current execution context, including the
130  * sender of the transaction and its data. While these are generally available
131  * via msg.sender and msg.data, they should not be accessed in such a direct
132  * manner, since when dealing with meta-transactions the account sending and
133  * paying for execution may not be the actual sender (as far as an application
134  * is concerned).
135  *
136  * This contract is only required for intermediate, library-like contracts.
137  */
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes calldata) {
144         return msg.data;
145     }
146 }
147 
148 // File: @openzeppelin/contracts/access/Ownable.sol
149 
150 
151 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
152 
153 pragma solidity ^0.8.0;
154 
155 
156 /**
157  * @dev Contract module which provides a basic access control mechanism, where
158  * there is an account (an owner) that can be granted exclusive access to
159  * specific functions.
160  *
161  * By default, the owner account will be the one that deploys the contract. This
162  * can later be changed with {transferOwnership}.
163  *
164  * This module is used through inheritance. It will make available the modifier
165  * `onlyOwner`, which can be applied to your functions to restrict their use to
166  * the owner.
167  */
168 abstract contract Ownable is Context {
169     address private _owner;
170 
171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
172 
173     /**
174      * @dev Initializes the contract setting the deployer as the initial owner.
175      */
176     constructor() {
177         _transferOwnership(_msgSender());
178     }
179 
180     /**
181      * @dev Returns the address of the current owner.
182      */
183     function owner() public view virtual returns (address) {
184         return _owner;
185     }
186 
187     /**
188      * @dev Throws if called by any account other than the owner.
189      */
190     modifier onlyOwner() {
191         require(owner() == _msgSender(), "Ownable: caller is not the owner");
192         _;
193     }
194 
195     /**
196      * @dev Leaves the contract without owner. It will not be possible to call
197      * `onlyOwner` functions anymore. Can only be called by the current owner.
198      *
199      * NOTE: Renouncing ownership will leave the contract without an owner,
200      * thereby removing any functionality that is only available to the owner.
201      */
202     function renounceOwnership() public virtual onlyOwner {
203         _transferOwnership(address(0));
204     }
205 
206     /**
207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
208      * Can only be called by the current owner.
209      */
210     function transferOwnership(address newOwner) public virtual onlyOwner {
211         require(newOwner != address(0), "Ownable: new owner is the zero address");
212         _transferOwnership(newOwner);
213     }
214 
215     /**
216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
217      * Internal function without access restriction.
218      */
219     function _transferOwnership(address newOwner) internal virtual {
220         address oldOwner = _owner;
221         _owner = newOwner;
222         emit OwnershipTransferred(oldOwner, newOwner);
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/Address.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
230 
231 pragma solidity ^0.8.1;
232 
233 /**
234  * @dev Collection of functions related to the address type
235  */
236 library Address {
237     /**
238      * @dev Returns true if `account` is a contract.
239      *
240      * [IMPORTANT]
241      * ====
242      * It is unsafe to assume that an address for which this function returns
243      * false is an externally-owned account (EOA) and not a contract.
244      *
245      * Among others, `isContract` will return false for the following
246      * types of addresses:
247      *
248      *  - an externally-owned account
249      *  - a contract in construction
250      *  - an address where a contract will be created
251      *  - an address where a contract lived, but was destroyed
252      * ====
253      *
254      * [IMPORTANT]
255      * ====
256      * You shouldn't rely on `isContract` to protect against flash loan attacks!
257      *
258      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
259      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
260      * constructor.
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // This method relies on extcodesize/address.code.length, which returns 0
265         // for contracts in construction, since the code is only stored at the end
266         // of the constructor execution.
267 
268         return account.code.length > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain `call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         require(isContract(target), "Address: call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.staticcall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(isContract(target), "Address: delegate call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason using the provided one.
425      *
426      * _Available since v4.3._
427      */
428     function verifyCallResult(
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal pure returns (bytes memory) {
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
452 
453 
454 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @title ERC721 token receiver interface
460  * @dev Interface for any contract that wants to support safeTransfers
461  * from ERC721 asset contracts.
462  */
463 interface IERC721Receiver {
464     /**
465      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
466      * by `operator` from `from`, this function is called.
467      *
468      * It must return its Solidity selector to confirm the token transfer.
469      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
470      *
471      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
472      */
473     function onERC721Received(
474         address operator,
475         address from,
476         uint256 tokenId,
477         bytes calldata data
478     ) external returns (bytes4);
479 }
480 
481 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @dev Interface of the ERC165 standard, as defined in the
490  * https://eips.ethereum.org/EIPS/eip-165[EIP].
491  *
492  * Implementers can declare support of contract interfaces, which can then be
493  * queried by others ({ERC165Checker}).
494  *
495  * For an implementation, see {ERC165}.
496  */
497 interface IERC165 {
498     /**
499      * @dev Returns true if this contract implements the interface defined by
500      * `interfaceId`. See the corresponding
501      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
502      * to learn more about how these ids are created.
503      *
504      * This function call must use less than 30 000 gas.
505      */
506     function supportsInterface(bytes4 interfaceId) external view returns (bool);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
541 
542 
543 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Required interface of an ERC721 compliant contract.
550  */
551 interface IERC721 is IERC165 {
552     /**
553      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
554      */
555     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
556 
557     /**
558      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
559      */
560     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
561 
562     /**
563      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
564      */
565     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
566 
567     /**
568      * @dev Returns the number of tokens in ``owner``'s account.
569      */
570     function balanceOf(address owner) external view returns (uint256 balance);
571 
572     /**
573      * @dev Returns the owner of the `tokenId` token.
574      *
575      * Requirements:
576      *
577      * - `tokenId` must exist.
578      */
579     function ownerOf(uint256 tokenId) external view returns (address owner);
580 
581     /**
582      * @dev Safely transfers `tokenId` token from `from` to `to`.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must exist and be owned by `from`.
589      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
591      *
592      * Emits a {Transfer} event.
593      */
594     function safeTransferFrom(
595         address from,
596         address to,
597         uint256 tokenId,
598         bytes calldata data
599     ) external;
600 
601     /**
602      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
603      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must exist and be owned by `from`.
610      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
611      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
612      *
613      * Emits a {Transfer} event.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Transfers `tokenId` token from `from` to `to`.
623      *
624      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
625      *
626      * Requirements:
627      *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630      * - `tokenId` token must be owned by `from`.
631      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
632      *
633      * Emits a {Transfer} event.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external;
640 
641     /**
642      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
643      * The approval is cleared when the token is transferred.
644      *
645      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
646      *
647      * Requirements:
648      *
649      * - The caller must own the token or be an approved operator.
650      * - `tokenId` must exist.
651      *
652      * Emits an {Approval} event.
653      */
654     function approve(address to, uint256 tokenId) external;
655 
656     /**
657      * @dev Approve or remove `operator` as an operator for the caller.
658      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
659      *
660      * Requirements:
661      *
662      * - The `operator` cannot be the caller.
663      *
664      * Emits an {ApprovalForAll} event.
665      */
666     function setApprovalForAll(address operator, bool _approved) external;
667 
668     /**
669      * @dev Returns the account approved for `tokenId` token.
670      *
671      * Requirements:
672      *
673      * - `tokenId` must exist.
674      */
675     function getApproved(uint256 tokenId) external view returns (address operator);
676 
677     /**
678      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
679      *
680      * See {setApprovalForAll}
681      */
682     function isApprovedForAll(address owner, address operator) external view returns (bool);
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
695  * @dev See https://eips.ethereum.org/EIPS/eip-721
696  */
697 interface IERC721Metadata is IERC721 {
698     /**
699      * @dev Returns the token collection name.
700      */
701     function name() external view returns (string memory);
702 
703     /**
704      * @dev Returns the token collection symbol.
705      */
706     function symbol() external view returns (string memory);
707 
708     /**
709      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
710      */
711     function tokenURI(uint256 tokenId) external view returns (string memory);
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
715 
716 
717 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 
723 
724 
725 
726 
727 
728 /**
729  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
730  * the Metadata extension, but not including the Enumerable extension, which is available separately as
731  * {ERC721Enumerable}.
732  */
733 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
734     using Address for address;
735     using Strings for uint256;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to owner address
744     mapping(uint256 => address) private _owners;
745 
746     // Mapping owner address to token count
747     mapping(address => uint256) private _balances;
748 
749     // Mapping from token ID to approved address
750     mapping(uint256 => address) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     /**
756      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
757      */
758     constructor(string memory name_, string memory symbol_) {
759         _name = name_;
760         _symbol = symbol_;
761     }
762 
763     /**
764      * @dev See {IERC165-supportsInterface}.
765      */
766     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
767         return
768             interfaceId == type(IERC721).interfaceId ||
769             interfaceId == type(IERC721Metadata).interfaceId ||
770             super.supportsInterface(interfaceId);
771     }
772 
773     /**
774      * @dev See {IERC721-balanceOf}.
775      */
776     function balanceOf(address owner) public view virtual override returns (uint256) {
777         require(owner != address(0), "ERC721: balance query for the zero address");
778         return _balances[owner];
779     }
780 
781     /**
782      * @dev See {IERC721-ownerOf}.
783      */
784     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
785         address owner = _owners[tokenId];
786         require(owner != address(0), "ERC721: owner query for nonexistent token");
787         return owner;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-name}.
792      */
793     function name() public view virtual override returns (string memory) {
794         return _name;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-symbol}.
799      */
800     function symbol() public view virtual override returns (string memory) {
801         return _symbol;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-tokenURI}.
806      */
807     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
808         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
809 
810         string memory baseURI = _baseURI();
811         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
812     }
813 
814     /**
815      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
816      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
817      * by default, can be overridden in child contracts.
818      */
819     function _baseURI() internal view virtual returns (string memory) {
820         return "";
821     }
822 
823     /**
824      * @dev See {IERC721-approve}.
825      */
826     function approve(address to, uint256 tokenId) public virtual override {
827         address owner = ERC721.ownerOf(tokenId);
828         require(to != owner, "ERC721: approval to current owner");
829 
830         require(
831             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
832             "ERC721: approve caller is not owner nor approved for all"
833         );
834 
835         _approve(to, tokenId);
836     }
837 
838     /**
839      * @dev See {IERC721-getApproved}.
840      */
841     function getApproved(uint256 tokenId) public view virtual override returns (address) {
842         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
843 
844         return _tokenApprovals[tokenId];
845     }
846 
847     /**
848      * @dev See {IERC721-setApprovalForAll}.
849      */
850     function setApprovalForAll(address operator, bool approved) public virtual override {
851         _setApprovalForAll(_msgSender(), operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     /**
862      * @dev See {IERC721-transferFrom}.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         //solhint-disable-next-line max-line-length
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
871 
872         _transfer(from, to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         safeTransferFrom(from, to, tokenId, "");
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) public virtual override {
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
917     function _safeTransfer(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) internal virtual {
923         _transfer(from, to, tokenId);
924         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
925     }
926 
927     /**
928      * @dev Returns whether `tokenId` exists.
929      *
930      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
931      *
932      * Tokens start existing when they are minted (`_mint`),
933      * and stop existing when they are burned (`_burn`).
934      */
935     function _exists(uint256 tokenId) internal view virtual returns (bool) {
936         return _owners[tokenId] != address(0);
937     }
938 
939     /**
940      * @dev Returns whether `spender` is allowed to manage `tokenId`.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      */
946     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
947         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
948         address owner = ERC721.ownerOf(tokenId);
949         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
950     }
951 
952     /**
953      * @dev Safely mints `tokenId` and transfers it to `to`.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must not exist.
958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _safeMint(address to, uint256 tokenId) internal virtual {
963         _safeMint(to, tokenId, "");
964     }
965 
966     /**
967      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
968      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
969      */
970     function _safeMint(
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) internal virtual {
975         _mint(to, tokenId);
976         require(
977             _checkOnERC721Received(address(0), to, tokenId, _data),
978             "ERC721: transfer to non ERC721Receiver implementer"
979         );
980     }
981 
982     /**
983      * @dev Mints `tokenId` and transfers it to `to`.
984      *
985      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
986      *
987      * Requirements:
988      *
989      * - `tokenId` must not exist.
990      * - `to` cannot be the zero address.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _mint(address to, uint256 tokenId) internal virtual {
995         require(to != address(0), "ERC721: mint to the zero address");
996         require(!_exists(tokenId), "ERC721: token already minted");
997 
998         _beforeTokenTransfer(address(0), to, tokenId);
999 
1000         _balances[to] += 1;
1001         _owners[tokenId] = to;
1002 
1003         emit Transfer(address(0), to, tokenId);
1004 
1005         _afterTokenTransfer(address(0), to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev Destroys `tokenId`.
1010      * The approval is cleared when the token is burned.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _burn(uint256 tokenId) internal virtual {
1019         address owner = ERC721.ownerOf(tokenId);
1020 
1021         _beforeTokenTransfer(owner, address(0), tokenId);
1022 
1023         // Clear approvals
1024         _approve(address(0), tokenId);
1025 
1026         _balances[owner] -= 1;
1027         delete _owners[tokenId];
1028 
1029         emit Transfer(owner, address(0), tokenId);
1030 
1031         _afterTokenTransfer(owner, address(0), tokenId);
1032     }
1033 
1034     /**
1035      * @dev Transfers `tokenId` from `from` to `to`.
1036      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1037      *
1038      * Requirements:
1039      *
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must be owned by `from`.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _transfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) internal virtual {
1050         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1051         require(to != address(0), "ERC721: transfer to the zero address");
1052 
1053         _beforeTokenTransfer(from, to, tokenId);
1054 
1055         // Clear approvals from the previous owner
1056         _approve(address(0), tokenId);
1057 
1058         _balances[from] -= 1;
1059         _balances[to] += 1;
1060         _owners[tokenId] = to;
1061 
1062         emit Transfer(from, to, tokenId);
1063 
1064         _afterTokenTransfer(from, to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev Approve `to` to operate on `tokenId`
1069      *
1070      * Emits a {Approval} event.
1071      */
1072     function _approve(address to, uint256 tokenId) internal virtual {
1073         _tokenApprovals[tokenId] = to;
1074         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev Approve `operator` to operate on all of `owner` tokens
1079      *
1080      * Emits a {ApprovalForAll} event.
1081      */
1082     function _setApprovalForAll(
1083         address owner,
1084         address operator,
1085         bool approved
1086     ) internal virtual {
1087         require(owner != operator, "ERC721: approve to caller");
1088         _operatorApprovals[owner][operator] = approved;
1089         emit ApprovalForAll(owner, operator, approved);
1090     }
1091 
1092     /**
1093      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1094      * The call is not executed if the target address is not a contract.
1095      *
1096      * @param from address representing the previous owner of the given token ID
1097      * @param to target address that will receive the tokens
1098      * @param tokenId uint256 ID of the token to be transferred
1099      * @param _data bytes optional data to send along with the call
1100      * @return bool whether the call correctly returned the expected magic value
1101      */
1102     function _checkOnERC721Received(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) private returns (bool) {
1108         if (to.isContract()) {
1109             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1110                 return retval == IERC721Receiver.onERC721Received.selector;
1111             } catch (bytes memory reason) {
1112                 if (reason.length == 0) {
1113                     revert("ERC721: transfer to non ERC721Receiver implementer");
1114                 } else {
1115                     assembly {
1116                         revert(add(32, reason), mload(reason))
1117                     }
1118                 }
1119             }
1120         } else {
1121             return true;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Hook that is called before any token transfer. This includes minting
1127      * and burning.
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1135      * - `from` and `to` are never both zero.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _beforeTokenTransfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) internal virtual {}
1144 
1145     /**
1146      * @dev Hook that is called after any transfer of tokens. This includes
1147      * minting and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - when `from` and `to` are both non-zero.
1152      * - `from` and `to` are never both zero.
1153      *
1154      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1155      */
1156     function _afterTokenTransfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual {}
1161 }
1162 
1163 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1164 
1165 
1166 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 
1171 /**
1172  * @dev ERC721 token with storage based token URI management.
1173  */
1174 abstract contract ERC721URIStorage is ERC721 {
1175     using Strings for uint256;
1176 
1177     // Optional mapping for token URIs
1178     mapping(uint256 => string) private _tokenURIs;
1179 
1180     /**
1181      * @dev See {IERC721Metadata-tokenURI}.
1182      */
1183     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1184         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1185 
1186         string memory _tokenURI = _tokenURIs[tokenId];
1187         string memory base = _baseURI();
1188 
1189         // If there is no base URI, return the token URI.
1190         if (bytes(base).length == 0) {
1191             return _tokenURI;
1192         }
1193         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1194         if (bytes(_tokenURI).length > 0) {
1195             return string(abi.encodePacked(base, _tokenURI));
1196         }
1197 
1198         return super.tokenURI(tokenId);
1199     }
1200 
1201     /**
1202      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must exist.
1207      */
1208     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1209         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1210         _tokenURIs[tokenId] = _tokenURI;
1211     }
1212 
1213     /**
1214      * @dev Destroys `tokenId`.
1215      * The approval is cleared when the token is burned.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function _burn(uint256 tokenId) internal virtual override {
1224         super._burn(tokenId);
1225 
1226         if (bytes(_tokenURIs[tokenId]).length != 0) {
1227             delete _tokenURIs[tokenId];
1228         }
1229     }
1230 }
1231 
1232 // File: contracts/CVBFDB.sol
1233 
1234 
1235 pragma solidity ^0.8.2;
1236 
1237 
1238 
1239 
1240 
1241 
1242 contract CCContract is ERC721, ERC721URIStorage, Ownable {
1243     using Counters for Counters.Counter;
1244     Counters.Counter private _total;
1245      bool public openPublic = false;
1246   string public baseURI = "https://GGGG.com/";
1247     string  public baseExtension = ".json";
1248 	constructor() ERC721("TCC", "CCC") {
1249      
1250     }
1251 	function mintPublic(uint256 amount) public payable {
1252         require(openPublic, "Public phase is closed.");
1253         
1254       
1255         for (uint256 i = 0; i < amount; i++) {
1256             uint256 tokenId = _total.current();
1257        
1258                 _total.increment();
1259                 _safeMint(msg.sender, tokenId);
1260                 string memory uri = string(
1261                     abi.encodePacked(
1262                         baseURI,
1263                         Strings.toString(tokenId),
1264                         baseExtension
1265                     )
1266                 );
1267                 _setTokenURI(tokenId, uri);
1268                
1269             
1270         }
1271     }
1272 	 function update(bool status) public onlyOwner {
1273    
1274             openPublic = status;
1275         
1276     }
1277      function _burn(uint256 tokenId)
1278         internal
1279         override(ERC721, ERC721URIStorage)
1280     {
1281         super._burn(tokenId);
1282     }
1283 
1284     function tokenURI(uint256 tokenId)
1285         public
1286         view
1287         override(ERC721, ERC721URIStorage)
1288         returns (string memory)
1289     {
1290         return super.tokenURI(tokenId);
1291     }
1292 	}