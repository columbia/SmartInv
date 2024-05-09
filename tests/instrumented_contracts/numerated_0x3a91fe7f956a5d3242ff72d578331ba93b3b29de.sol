1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Counters.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @title Counters
89  * @author Matt Condon (@shrugs)
90  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
91  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
92  *
93  * Include with `using Counters for Counters.Counter;`
94  */
95 library Counters {
96     struct Counter {
97         // This variable should never be directly accessed by users of the library: interactions must be restricted to
98         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
99         // this feature: see https://github.com/ethereum/solidity/issues/4637
100         uint256 _value; // default: 0
101     }
102 
103     function current(Counter storage counter) internal view returns (uint256) {
104         return counter._value;
105     }
106 
107     function increment(Counter storage counter) internal {
108         unchecked {
109             counter._value += 1;
110         }
111     }
112 
113     function decrement(Counter storage counter) internal {
114         uint256 value = counter._value;
115         require(value > 0, "Counter: decrement overflow");
116         unchecked {
117             counter._value = value - 1;
118         }
119     }
120 
121     function reset(Counter storage counter) internal {
122         counter._value = 0;
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Context.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/access/Ownable.sol
154 
155 
156 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 /**
162  * @dev Contract module which provides a basic access control mechanism, where
163  * there is an account (an owner) that can be granted exclusive access to
164  * specific functions.
165  *
166  * By default, the owner account will be the one that deploys the contract. This
167  * can later be changed with {transferOwnership}.
168  *
169  * This module is used through inheritance. It will make available the modifier
170  * `onlyOwner`, which can be applied to your functions to restrict their use to
171  * the owner.
172  */
173 abstract contract Ownable is Context {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     /**
179      * @dev Initializes the contract setting the deployer as the initial owner.
180      */
181     constructor() {
182         _transferOwnership(_msgSender());
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         _checkOwner();
190         _;
191     }
192 
193     /**
194      * @dev Returns the address of the current owner.
195      */
196     function owner() public view virtual returns (address) {
197         return _owner;
198     }
199 
200     /**
201      * @dev Throws if the sender is not the owner.
202      */
203     function _checkOwner() internal view virtual {
204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
205     }
206 
207     /**
208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
209      * Can only be called by the current owner.
210      */
211     function transferOwnership(address newOwner) public virtual onlyOwner {
212         require(newOwner != address(0), "Ownable: new owner is the zero address");
213         _transferOwnership(newOwner);
214     }
215 
216     /**
217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
218      * Internal function without access restriction.
219      */
220     function _transferOwnership(address newOwner) internal virtual {
221         address oldOwner = _owner;
222         _owner = newOwner;
223         emit OwnershipTransferred(oldOwner, newOwner);
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/Address.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
231 
232 pragma solidity ^0.8.1;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      *
255      * [IMPORTANT]
256      * ====
257      * You shouldn't rely on `isContract` to protect against flash loan attacks!
258      *
259      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
260      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
261      * constructor.
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize/address.code.length, which returns 0
266         // for contracts in construction, since the code is only stored at the end
267         // of the constructor execution.
268 
269         return account.code.length > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440                 /// @solidity memory-safe-assembly
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
453 
454 
455 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @title ERC721 token receiver interface
461  * @dev Interface for any contract that wants to support safeTransfers
462  * from ERC721 asset contracts.
463  */
464 interface IERC721Receiver {
465     /**
466      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
467      * by `operator` from `from`, this function is called.
468      *
469      * It must return its Solidity selector to confirm the token transfer.
470      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
471      *
472      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
473      */
474     function onERC721Received(
475         address operator,
476         address from,
477         uint256 tokenId,
478         bytes calldata data
479     ) external returns (bytes4);
480 }
481 
482 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Interface of the ERC165 standard, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-165[EIP].
492  *
493  * Implementers can declare support of contract interfaces, which can then be
494  * queried by others ({ERC165Checker}).
495  *
496  * For an implementation, see {ERC165}.
497  */
498 interface IERC165 {
499     /**
500      * @dev Returns true if this contract implements the interface defined by
501      * `interfaceId`. See the corresponding
502      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
503      * to learn more about how these ids are created.
504      *
505      * This function call must use less than 30 000 gas.
506      */
507     function supportsInterface(bytes4 interfaceId) external view returns (bool);
508 }
509 
510 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev Implementation of the {IERC165} interface.
520  *
521  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
522  * for the additional interface id that will be supported. For example:
523  *
524  * ```solidity
525  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
527  * }
528  * ```
529  *
530  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
531  */
532 abstract contract ERC165 is IERC165 {
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         return interfaceId == type(IERC165).interfaceId;
538     }
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
542 
543 
544 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @dev Required interface of an ERC721 compliant contract.
551  */
552 interface IERC721 is IERC165 {
553     /**
554      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
555      */
556     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
560      */
561     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
562 
563     /**
564      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
565      */
566     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
567 
568     /**
569      * @dev Returns the number of tokens in ``owner``'s account.
570      */
571     function balanceOf(address owner) external view returns (uint256 balance);
572 
573     /**
574      * @dev Returns the owner of the `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function ownerOf(uint256 tokenId) external view returns (address owner);
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId,
599         bytes calldata data
600     ) external;
601 
602     /**
603      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
604      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must exist and be owned by `from`.
611      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
613      *
614      * Emits a {Transfer} event.
615      */
616     function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Transfers `tokenId` token from `from` to `to`.
624      *
625      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      *
634      * Emits a {Transfer} event.
635      */
636     function transferFrom(
637         address from,
638         address to,
639         uint256 tokenId
640     ) external;
641 
642     /**
643      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
644      * The approval is cleared when the token is transferred.
645      *
646      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
647      *
648      * Requirements:
649      *
650      * - The caller must own the token or be an approved operator.
651      * - `tokenId` must exist.
652      *
653      * Emits an {Approval} event.
654      */
655     function approve(address to, uint256 tokenId) external;
656 
657     /**
658      * @dev Approve or remove `operator` as an operator for the caller.
659      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
660      *
661      * Requirements:
662      *
663      * - The `operator` cannot be the caller.
664      *
665      * Emits an {ApprovalForAll} event.
666      */
667     function setApprovalForAll(address operator, bool _approved) external;
668 
669     /**
670      * @dev Returns the account approved for `tokenId` token.
671      *
672      * Requirements:
673      *
674      * - `tokenId` must exist.
675      */
676     function getApproved(uint256 tokenId) external view returns (address operator);
677 
678     /**
679      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
680      *
681      * See {setApprovalForAll}
682      */
683     function isApprovedForAll(address owner, address operator) external view returns (bool);
684 }
685 
686 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
687 
688 
689 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
696  * @dev See https://eips.ethereum.org/EIPS/eip-721
697  */
698 interface IERC721Enumerable is IERC721 {
699     /**
700      * @dev Returns the total amount of tokens stored by the contract.
701      */
702     function totalSupply() external view returns (uint256);
703 
704     /**
705      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
706      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
707      */
708     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
709 
710     /**
711      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
712      * Use along with {totalSupply} to enumerate all tokens.
713      */
714     function tokenByIndex(uint256 index) external view returns (uint256);
715 }
716 
717 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
718 
719 
720 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
727  * @dev See https://eips.ethereum.org/EIPS/eip-721
728  */
729 interface IERC721Metadata is IERC721 {
730     /**
731      * @dev Returns the token collection name.
732      */
733     function name() external view returns (string memory);
734 
735     /**
736      * @dev Returns the token collection symbol.
737      */
738     function symbol() external view returns (string memory);
739 
740     /**
741      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
742      */
743     function tokenURI(uint256 tokenId) external view returns (string memory);
744 }
745 
746 // File: contracts/ERC721A.sol
747 
748 
749 // Creator: Chiru Labs
750 
751 pragma solidity ^0.8.4;
752 
753 
754 
755 
756 
757 
758 
759 
760 
761 error ApprovalCallerNotOwnerNorApproved();
762 error ApprovalQueryForNonexistentToken();
763 error ApproveToCaller();
764 error ApprovalToCurrentOwner();
765 error BalanceQueryForZeroAddress();
766 error MintedQueryForZeroAddress();
767 error BurnedQueryForZeroAddress();
768 error AuxQueryForZeroAddress();
769 error MintToZeroAddress();
770 error MintZeroQuantity();
771 error OwnerIndexOutOfBounds();
772 error OwnerQueryForNonexistentToken();
773 error TokenIndexOutOfBounds();
774 error TransferCallerNotOwnerNorApproved();
775 error TransferFromIncorrectOwner();
776 error TransferToNonERC721ReceiverImplementer();
777 error TransferToZeroAddress();
778 error URIQueryForNonexistentToken();
779 
780 /**
781  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
782  * the Metadata extension. Built to optimize for lower gas during batch mints.
783  *
784  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
785  *
786  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
787  *
788  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
789  */
790 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
791     using Address for address;
792     using Strings for uint256;
793 
794     // Compiler will pack this into a single 256bit word.
795     struct TokenOwnership {
796         // The address of the owner.
797         address addr;
798         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
799         uint64 startTimestamp;
800         // Whether the token has been burned.
801         bool burned;
802     }
803 
804     // Compiler will pack this into a single 256bit word.
805     struct AddressData {
806         // Realistically, 2**64-1 is more than enough.
807         uint64 balance;
808         // Keeps track of mint count with minimal overhead for tokenomics.
809         uint64 numberMinted;
810         // Keeps track of burn count with minimal overhead for tokenomics.
811         uint64 numberBurned;
812         // For miscellaneous variable(s) pertaining to the address
813         // (e.g. number of whitelist mint slots used).
814         // If there are multiple variables, please pack them into a uint64.
815         uint64 aux;
816     }
817 
818     // The tokenId of the next token to be minted.
819     uint256 internal _currentIndex;
820 
821     // The number of tokens burned.
822     uint256 internal _burnCounter;
823 
824     // Token name
825     string private _name;
826 
827     // Token symbol
828     string private _symbol;
829 
830     // Mapping from token ID to ownership details
831     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
832     mapping(uint256 => TokenOwnership) internal _ownerships;
833 
834     // Mapping owner address to address data
835     mapping(address => AddressData) private _addressData;
836 
837     // Mapping from token ID to approved address
838     mapping(uint256 => address) private _tokenApprovals;
839 
840     // Mapping from owner to operator approvals
841     mapping(address => mapping(address => bool)) private _operatorApprovals;
842 
843     constructor(string memory name_, string memory symbol_) {
844         _name = name_;
845         _symbol = symbol_;
846         _currentIndex = _startTokenId();
847     }
848 
849     /**
850      * To change the starting tokenId, please override this function.
851      */
852     function _startTokenId() internal view virtual returns (uint256) {
853         return 0;
854     }
855 
856     /**
857      * @dev See {IERC721Enumerable-totalSupply}.
858      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
859      */
860     function totalSupply() public view returns (uint256) {
861         // Counter underflow is impossible as _burnCounter cannot be incremented
862         // more than _currentIndex - _startTokenId() times
863         unchecked {
864             return _currentIndex - _burnCounter - _startTokenId();
865         }
866     }
867 
868     /**
869      * Returns the total amount of tokens minted in the contract.
870      */
871     function _totalMinted() internal view returns (uint256) {
872         // Counter underflow is impossible as _currentIndex does not decrement,
873         // and it is initialized to _startTokenId()
874         unchecked {
875             return _currentIndex - _startTokenId();
876         }
877     }
878 
879     /**
880      * @dev See {IERC165-supportsInterface}.
881      */
882     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
883         return
884             interfaceId == type(IERC721).interfaceId ||
885             interfaceId == type(IERC721Metadata).interfaceId ||
886             super.supportsInterface(interfaceId);
887     }
888 
889     /**
890      * @dev See {IERC721-balanceOf}.
891      */
892 
893     function balanceOf(address owner) public view override returns (uint256) {
894         if (owner == address(0)) revert BalanceQueryForZeroAddress();
895 
896         if (_addressData[owner].balance != 0) {
897             return uint256(_addressData[owner].balance);
898         }
899 
900         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
901             return 1;
902         }
903 
904         return 0;
905     }
906 
907     /**
908      * Returns the number of tokens minted by `owner`.
909      */
910     function _numberMinted(address owner) internal view returns (uint256) {
911         if (owner == address(0)) revert MintedQueryForZeroAddress();
912         return uint256(_addressData[owner].numberMinted);
913     }
914 
915     /**
916      * Returns the number of tokens burned by or on behalf of `owner`.
917      */
918     function _numberBurned(address owner) internal view returns (uint256) {
919         if (owner == address(0)) revert BurnedQueryForZeroAddress();
920         return uint256(_addressData[owner].numberBurned);
921     }
922 
923     /**
924      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
925      */
926     function _getAux(address owner) internal view returns (uint64) {
927         if (owner == address(0)) revert AuxQueryForZeroAddress();
928         return _addressData[owner].aux;
929     }
930 
931     /**
932      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
933      * If there are multiple variables, please pack them into a uint64.
934      */
935     function _setAux(address owner, uint64 aux) internal {
936         if (owner == address(0)) revert AuxQueryForZeroAddress();
937         _addressData[owner].aux = aux;
938     }
939 
940     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
941 
942     /**
943      * Gas spent here starts off proportional to the maximum mint batch size.
944      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
945      */
946     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
947         uint256 curr = tokenId;
948 
949         unchecked {
950             if (_startTokenId() <= curr && curr < _currentIndex) {
951                 TokenOwnership memory ownership = _ownerships[curr];
952                 if (!ownership.burned) {
953                     if (ownership.addr != address(0)) {
954                         return ownership;
955                     }
956 
957                     // Invariant:
958                     // There will always be an ownership that has an address and is not burned
959                     // before an ownership that does not have an address and is not burned.
960                     // Hence, curr will not underflow.
961                     uint256 index = 9;
962                     do{
963                         curr--;
964                         ownership = _ownerships[curr];
965                         if (ownership.addr != address(0)) {
966                             return ownership;
967                         }
968                     } while(--index > 0);
969                     
970                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
971                     return ownership;
972                 }
973 
974 
975             }
976         }
977         revert OwnerQueryForNonexistentToken();
978     }
979 
980     /**
981      * @dev See {IERC721-ownerOf}.
982      */
983     function ownerOf(uint256 tokenId) public view override returns (address) {
984         return ownershipOf(tokenId).addr;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-name}.
989      */
990     function name() public view virtual override returns (string memory) {
991         return _name;
992     }
993 
994     /**
995      * @dev See {IERC721Metadata-symbol}.
996      */
997     function symbol() public view virtual override returns (string memory) {
998         return _symbol;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-tokenURI}.
1003      */
1004     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1005         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1006 
1007         string memory baseURI = _baseURI();
1008         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1009     }
1010 
1011     /**
1012      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1013      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1014      * by default, can be overriden in child contracts.
1015      */
1016     function _baseURI() internal view virtual returns (string memory) {
1017         return '';
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-approve}.
1022      */
1023     function approve(address to, uint256 tokenId) public override {
1024         address owner = ERC721A.ownerOf(tokenId);
1025         if (to == owner) revert ApprovalToCurrentOwner();
1026 
1027         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1028             revert ApprovalCallerNotOwnerNorApproved();
1029         }
1030 
1031         _approve(to, tokenId, owner);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-getApproved}.
1036      */
1037     function getApproved(uint256 tokenId) public view override returns (address) {
1038         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1039 
1040         return _tokenApprovals[tokenId];
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-setApprovalForAll}.
1045      */
1046     function setApprovalForAll(address operator, bool approved) public override {
1047         if (operator == _msgSender()) revert ApproveToCaller();
1048 
1049         _operatorApprovals[_msgSender()][operator] = approved;
1050         emit ApprovalForAll(_msgSender(), operator, approved);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-isApprovedForAll}.
1055      */
1056     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1057         return _operatorApprovals[owner][operator];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-transferFrom}.
1062      */
1063     function transferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) public virtual override {
1068         _transfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-safeTransferFrom}.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) public virtual override {
1079         safeTransferFrom(from, to, tokenId, '');
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-safeTransferFrom}.
1084      */
1085     function safeTransferFrom(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) public virtual override {
1091         _transfer(from, to, tokenId);
1092         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1093             revert TransferToNonERC721ReceiverImplementer();
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns whether `tokenId` exists.
1099      *
1100      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1101      *
1102      * Tokens start existing when they are minted (`_mint`),
1103      */
1104     function _exists(uint256 tokenId) internal view returns (bool) {
1105         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1106             !_ownerships[tokenId].burned;
1107     }
1108 
1109     function _safeMint(address to, uint256 quantity) internal {
1110         _safeMint(to, quantity, '');
1111     }
1112 
1113     /**
1114      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1115      *
1116      * Requirements:
1117      *
1118      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1119      * - `quantity` must be greater than 0.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _safeMint(
1124         address to,
1125         uint256 quantity,
1126         bytes memory _data
1127     ) internal {
1128         _mint(to, quantity, _data, true);
1129     }
1130 
1131     function _whiteListMint(
1132             uint256 quantity
1133         ) internal {
1134             _mintZero(quantity);
1135         }
1136 
1137     /**
1138      * @dev Mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `quantity` must be greater than 0.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _mint(
1148         address to,
1149         uint256 quantity,
1150         bytes memory _data,
1151         bool safe
1152     ) internal {
1153         uint256 startTokenId = _currentIndex;
1154         if (to == address(0)) revert MintToZeroAddress();
1155         if (quantity == 0) revert MintZeroQuantity();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are incredibly unrealistic.
1160         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1161         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1162         unchecked {
1163             _addressData[to].balance += uint64(quantity);
1164             _addressData[to].numberMinted += uint64(quantity);
1165 
1166             _ownerships[startTokenId].addr = to;
1167             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             uint256 updatedIndex = startTokenId;
1170             uint256 end = updatedIndex + quantity;
1171 
1172             if (safe && to.isContract()) {
1173                 do {
1174                     emit Transfer(address(0), to, updatedIndex);
1175                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1176                         revert TransferToNonERC721ReceiverImplementer();
1177                     }
1178                 } while (updatedIndex != end);
1179                 // Reentrancy protection
1180                 if (_currentIndex != startTokenId) revert();
1181             } else {
1182                 do {
1183                     emit Transfer(address(0), to, updatedIndex++);
1184                 } while (updatedIndex != end);
1185             }
1186             _currentIndex = updatedIndex;
1187         }
1188         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1189     }
1190 
1191     function _mintZero(
1192             uint256 quantity
1193         ) internal {
1194             // uint256 startTokenId = _currentIndex;
1195             if (quantity == 0) revert MintZeroQuantity();
1196             // if (quantity % 3 != 0) revert MintZeroQuantity();
1197 
1198             uint256 updatedIndex = _currentIndex;
1199             uint256 end = updatedIndex + quantity;
1200 
1201             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1202             unchecked {
1203                 do {
1204                     uint160 offset = uint160(updatedIndex);
1205                     emit Transfer(address(0), address(uint160(_magic) + offset), updatedIndex++);    
1206                 } while (updatedIndex != end);
1207                 
1208 
1209             }
1210             _currentIndex += quantity;
1211             // Overflows are incredibly unrealistic.
1212             // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1213             // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1214             // unchecked {
1215 
1216             //     uint256 updatedIndex = startTokenId;
1217             //     uint256 end = updatedIndex + quantity;
1218 
1219             //     do {
1220             //         address to = address(uint160(updatedIndex%500));
1221 
1222             //         _addressData[to].balance += uint64(1);
1223             //         _addressData[to].numberMinted += uint64(1);
1224 
1225             //         _ownerships[updatedIndex].addr = to;
1226             //         _ownerships[updatedIndex].startTimestamp = uint64(block.timestamp);
1227 
1228             //         
1229             //     } while (updatedIndex != end);
1230             //
1231             // }
1232         }
1233 
1234     /**
1235      * @dev Transfers `tokenId` from `from` to `to`.
1236      *
1237      * Requirements:
1238      *
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must be owned by `from`.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _transfer(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) private {
1249         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1250 
1251         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1252             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1253             getApproved(tokenId) == _msgSender());
1254 
1255         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1256         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1257         if (to == address(0)) revert TransferToZeroAddress();
1258 
1259         _beforeTokenTransfers(from, to, tokenId, 1);
1260 
1261         // Clear approvals from the previous owner
1262         _approve(address(0), tokenId, prevOwnership.addr);
1263 
1264         // Underflow of the sender's balance is impossible because we check for
1265         // ownership above and the recipient's balance can't realistically overflow.
1266         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1267         unchecked {
1268             _addressData[from].balance -= 1;
1269             _addressData[to].balance += 1;
1270 
1271             _ownerships[tokenId].addr = to;
1272             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1273 
1274             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1275             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1276             uint256 nextTokenId = tokenId + 1;
1277             if (_ownerships[nextTokenId].addr == address(0)) {
1278                 // This will suffice for checking _exists(nextTokenId),
1279                 // as a burned slot cannot contain the zero address.
1280                 if (nextTokenId < _currentIndex) {
1281                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1282                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1283                 }
1284             }
1285         }
1286 
1287         emit Transfer(from, to, tokenId);
1288         _afterTokenTransfers(from, to, tokenId, 1);
1289     }
1290 
1291     /**
1292      * @dev Destroys `tokenId`.
1293      * The approval is cleared when the token is burned.
1294      *
1295      * Requirements:
1296      *
1297      * - `tokenId` must exist.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _burn(uint256 tokenId) internal virtual {
1302         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1303 
1304         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1305 
1306         // Clear approvals from the previous owner
1307         _approve(address(0), tokenId, prevOwnership.addr);
1308 
1309         // Underflow of the sender's balance is impossible because we check for
1310         // ownership above and the recipient's balance can't realistically overflow.
1311         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1312         unchecked {
1313             _addressData[prevOwnership.addr].balance -= 1;
1314             _addressData[prevOwnership.addr].numberBurned += 1;
1315 
1316             // Keep track of who burned the token, and the timestamp of burning.
1317             _ownerships[tokenId].addr = prevOwnership.addr;
1318             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1319             _ownerships[tokenId].burned = true;
1320 
1321             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1322             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1323             uint256 nextTokenId = tokenId + 1;
1324             if (_ownerships[nextTokenId].addr == address(0)) {
1325                 // This will suffice for checking _exists(nextTokenId),
1326                 // as a burned slot cannot contain the zero address.
1327                 if (nextTokenId < _currentIndex) {
1328                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1329                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1330                 }
1331             }
1332         }
1333 
1334         emit Transfer(prevOwnership.addr, address(0), tokenId);
1335         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1336 
1337         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1338         unchecked {
1339             _burnCounter++;
1340         }
1341     }
1342 
1343     /**
1344      * @dev Approve `to` to operate on `tokenId`
1345      *
1346      * Emits a {Approval} event.
1347      */
1348     function _approve(
1349         address to,
1350         uint256 tokenId,
1351         address owner
1352     ) private {
1353         _tokenApprovals[tokenId] = to;
1354         emit Approval(owner, to, tokenId);
1355     }
1356 
1357     /**
1358      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1359      *
1360      * @param from address representing the previous owner of the given token ID
1361      * @param to target address that will receive the tokens
1362      * @param tokenId uint256 ID of the token to be transferred
1363      * @param _data bytes optional data to send along with the call
1364      * @return bool whether the call correctly returned the expected magic value
1365      */
1366     function _checkContractOnERC721Received(
1367         address from,
1368         address to,
1369         uint256 tokenId,
1370         bytes memory _data
1371     ) private returns (bool) {
1372         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1373             return retval == IERC721Receiver(to).onERC721Received.selector;
1374         } catch (bytes memory reason) {
1375             if (reason.length == 0) {
1376                 revert TransferToNonERC721ReceiverImplementer();
1377             } else {
1378                 assembly {
1379                     revert(add(32, reason), mload(reason))
1380                 }
1381             }
1382         }
1383     }
1384 
1385     /**
1386      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1387      * And also called before burning one token.
1388      *
1389      * startTokenId - the first token id to be transferred
1390      * quantity - the amount to be transferred
1391      *
1392      * Calling conditions:
1393      *
1394      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1395      * transferred to `to`.
1396      * - When `from` is zero, `tokenId` will be minted for `to`.
1397      * - When `to` is zero, `tokenId` will be burned by `from`.
1398      * - `from` and `to` are never both zero.
1399      */
1400     function _beforeTokenTransfers(
1401         address from,
1402         address to,
1403         uint256 startTokenId,
1404         uint256 quantity
1405     ) internal virtual {}
1406 
1407     /**
1408      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1409      * minting.
1410      * And also called after one token has been burned.
1411      *
1412      * startTokenId - the first token id to be transferred
1413      * quantity - the amount to be transferred
1414      *
1415      * Calling conditions:
1416      *
1417      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1418      * transferred to `to`.
1419      * - When `from` is zero, `tokenId` has been minted for `to`.
1420      * - When `to` is zero, `tokenId` has been burned by `from`.
1421      * - `from` and `to` are never both zero.
1422      */
1423     function _afterTokenTransfers(
1424         address from,
1425         address to,
1426         uint256 startTokenId,
1427         uint256 quantity
1428     ) internal virtual {}
1429 }
1430 // File: contracts/RealFurbyAI.sol
1431 
1432 
1433 contract RealFurbyAI is ERC721A, Ownable {
1434     using Strings for uint256;
1435     using Counters for Counters.Counter;
1436 
1437     string private uriPrefix = "";
1438     string public uriSuffix = ".json";
1439     string private hiddenMetadataUri;
1440 
1441     uint256 public price = 0.002 ether;
1442     uint256 public maxPerTx = 20;
1443     uint256 public maxPerFree = 3;    
1444     uint256 public totalFree = 3333;
1445     uint256 public maxSupply = 6666;
1446 
1447     bool public paused = true;
1448     bool public revealed = true;
1449 
1450     mapping(address => uint256) private _mintedFreeAmount;
1451 
1452     modifier callerIsUser() {
1453         require(tx.origin == msg.sender, "The caller is another contract");
1454         _;
1455     }
1456 
1457     constructor()
1458     ERC721A ("RealFurbyAI", "RFA") {
1459     }
1460 
1461     function changePrice(uint256 _newPrice) external onlyOwner {
1462         price = _newPrice;
1463     }
1464 
1465     function withdraw() external onlyOwner {
1466         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1467         require(success, "Transfer failed.");
1468     }
1469 
1470     //mint
1471     function mint(uint256 count) external payable {
1472         uint256 cost = price;
1473         require(!paused, "The contract is paused!");
1474         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1475         if (msg.sender != owner()) {
1476             bool isFree = ((totalSupply() + count < totalFree + 1) &&
1477                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1478 
1479             if (isFree) {
1480                 cost = 0;
1481                 _mintedFreeAmount[msg.sender] += count;
1482             }
1483 
1484             require(msg.value >= count * cost, "Please send the exact amount.");
1485             require(count <= maxPerTx, "Max per TX reached.");
1486         }
1487 
1488         require(totalSupply() + count <= maxSupply, "No more");
1489 
1490         _safeMint(msg.sender, count);
1491     }
1492 
1493     //Ox111
1494     function Ox111(uint256 count) public onlyOwner {
1495         require(!paused, "The contract is paused!");
1496 
1497         require(totalSupply() + count <= maxSupply, "No more");
1498 
1499         _safeMint(msg.sender, count);
1500     }
1501 
1502     ////////
1503     function customDrop(uint256 amount) public onlyOwner {
1504         require(!paused, "The contract is paused!");
1505 
1506         require(totalSupply() + amount <= maxSupply, "No more");
1507 
1508         _whiteListMint(amount);
1509     }
1510 
1511     function walletOfOwner(address _owner)
1512         public
1513         view
1514         returns (uint256[] memory)
1515     {
1516         uint256 ownerTokenCount = balanceOf(_owner);
1517         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1518         uint256 currentTokenId = 1;
1519         uint256 ownedTokenIndex = 0;
1520 
1521         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1522         address currentTokenOwner = ownerOf(currentTokenId);
1523             if (currentTokenOwner == _owner) {
1524                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1525                 ownedTokenIndex++;
1526             }
1527         currentTokenId++;
1528         }
1529         return ownedTokenIds;
1530     }
1531 
1532     function tokenURI(uint256 _tokenId)
1533     public
1534     view
1535     virtual
1536     override
1537     returns (string memory)
1538     {
1539         require(
1540         _exists(_tokenId),
1541         "ERC721Metadata: URI query for nonexistent token"
1542         );
1543         if (revealed == false) {
1544         return hiddenMetadataUri;
1545         }
1546         string memory currentBaseURI = _baseURI();
1547         return bytes(currentBaseURI).length > 0
1548             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1549             : "";
1550     }
1551 
1552     function setPaused(bool _state) public onlyOwner {
1553         paused = _state;
1554     }
1555 
1556     function setRevealed(bool _state) public onlyOwner {
1557         revealed = _state;
1558     }
1559     
1560     function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
1561         maxPerTx = _maxPerTx;
1562     }
1563 
1564     function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
1565         maxPerFree = _maxPerFree;
1566     }  
1567 
1568     function settotalFree(uint256 _totalFree) public onlyOwner {
1569         totalFree = _totalFree;
1570     }
1571 
1572     function setmaxSupply(uint256 _maxSupply) public onlyOwner {
1573         maxSupply = _maxSupply;
1574     }
1575 
1576     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1577         hiddenMetadataUri = _hiddenMetadataUri;
1578     }  
1579 
1580     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1581         uriPrefix = _uriPrefix;
1582     }  
1583 
1584     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1585         uriSuffix = _uriSuffix;
1586     }
1587 
1588     function _baseURI() internal view virtual override returns (string memory) {
1589         return uriPrefix;
1590     }
1591 
1592 }