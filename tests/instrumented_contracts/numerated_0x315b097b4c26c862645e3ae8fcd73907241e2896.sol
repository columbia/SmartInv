1 // SPDX-License-Identifier: MIT
2 
3 // Art Not Real is a collection of 6969 unique, high resolution, extremely detailed images created by a set of generative adversarial networks across the span of 8 months.
4 // Find out more: artnotreal.com
5 
6 // File: @openzeppelin/contracts/utils/Counters.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @title Counters
15  * @author Matt Condon (@shrugs)
16  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
17  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
18  *
19  * Include with `using Counters for Counters.Counter;`
20  */
21 library Counters {
22     struct Counter {
23         // This variable should never be directly accessed by users of the library: interactions must be restricted to
24         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
25         // this feature: see https://github.com/ethereum/solidity/issues/4637
26         uint256 _value; // default: 0
27     }
28 
29     function current(Counter storage counter) internal view returns (uint256) {
30         return counter._value;
31     }
32 
33     function increment(Counter storage counter) internal {
34         unchecked {
35             counter._value += 1;
36         }
37     }
38 
39     function decrement(Counter storage counter) internal {
40         uint256 value = counter._value;
41         require(value > 0, "Counter: decrement overflow");
42         unchecked {
43             counter._value = value - 1;
44         }
45     }
46 
47     function reset(Counter storage counter) internal {
48         counter._value = 0;
49     }
50 }
51 
52 // File: @openzeppelin/contracts/utils/Strings.sol
53 
54 
55 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
56 
57 pragma solidity ^0.8.0;
58 
59 /**
60  * @dev String operations.
61  */
62 library Strings {
63     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
67      */
68     function toString(uint256 value) internal pure returns (string memory) {
69         // Inspired by OraclizeAPI's implementation - MIT licence
70         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
71 
72         if (value == 0) {
73             return "0";
74         }
75         uint256 temp = value;
76         uint256 digits;
77         while (temp != 0) {
78             digits++;
79             temp /= 10;
80         }
81         bytes memory buffer = new bytes(digits);
82         while (value != 0) {
83             digits -= 1;
84             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
85             value /= 10;
86         }
87         return string(buffer);
88     }
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
92      */
93     function toHexString(uint256 value) internal pure returns (string memory) {
94         if (value == 0) {
95             return "0x00";
96         }
97         uint256 temp = value;
98         uint256 length = 0;
99         while (temp != 0) {
100             length++;
101             temp >>= 8;
102         }
103         return toHexString(value, length);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
108      */
109     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
110         bytes memory buffer = new bytes(2 * length + 2);
111         buffer[0] = "0";
112         buffer[1] = "x";
113         for (uint256 i = 2 * length + 1; i > 1; --i) {
114             buffer[i] = _HEX_SYMBOLS[value & 0xf];
115             value >>= 4;
116         }
117         require(value == 0, "Strings: hex length insufficient");
118         return string(buffer);
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
152 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
182      * @dev Returns the address of the current owner.
183      */
184     function owner() public view virtual returns (address) {
185         return _owner;
186     }
187 
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         require(owner() == _msgSender(), "Ownable: caller is not the owner");
193         _;
194     }
195 
196     /**
197      * @dev Leaves the contract without owner. It will not be possible to call
198      * `onlyOwner` functions anymore. Can only be called by the current owner.
199      *
200      * NOTE: Renouncing ownership will leave the contract without an owner,
201      * thereby removing any functionality that is only available to the owner.
202      */
203     function renounceOwnership() public virtual onlyOwner {
204         _transferOwnership(address(0));
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
230 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
440 
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
544 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
611      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
686 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
696  * @dev See https://eips.ethereum.org/EIPS/eip-721
697  */
698 interface IERC721Metadata is IERC721 {
699     /**
700      * @dev Returns the token collection name.
701      */
702     function name() external view returns (string memory);
703 
704     /**
705      * @dev Returns the token collection symbol.
706      */
707     function symbol() external view returns (string memory);
708 
709     /**
710      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
711      */
712     function tokenURI(uint256 tokenId) external view returns (string memory);
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
716 
717 
718 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 
724 
725 
726 
727 
728 
729 /**
730  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
731  * the Metadata extension, but not including the Enumerable extension, which is available separately as
732  * {ERC721Enumerable}.
733  */
734 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
735     using Address for address;
736     using Strings for uint256;
737 
738     // Token name
739     string private _name;
740 
741     // Token symbol
742     string private _symbol;
743 
744     // Mapping from token ID to owner address
745     mapping(uint256 => address) private _owners;
746 
747     // Mapping owner address to token count
748     mapping(address => uint256) private _balances;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     /**
757      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
758      */
759     constructor(string memory name_, string memory symbol_) {
760         _name = name_;
761         _symbol = symbol_;
762     }
763 
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      */
767     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
768         return
769             interfaceId == type(IERC721).interfaceId ||
770             interfaceId == type(IERC721Metadata).interfaceId ||
771             super.supportsInterface(interfaceId);
772     }
773 
774     /**
775      * @dev See {IERC721-balanceOf}.
776      */
777     function balanceOf(address owner) public view virtual override returns (uint256) {
778         require(owner != address(0), "ERC721: balance query for the zero address");
779         return _balances[owner];
780     }
781 
782     /**
783      * @dev See {IERC721-ownerOf}.
784      */
785     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
786         address owner = _owners[tokenId];
787         require(owner != address(0), "ERC721: owner query for nonexistent token");
788         return owner;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-name}.
793      */
794     function name() public view virtual override returns (string memory) {
795         return _name;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-symbol}.
800      */
801     function symbol() public view virtual override returns (string memory) {
802         return _symbol;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-tokenURI}.
807      */
808     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
809         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
810 
811         string memory baseURI = _baseURI();
812         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
813     }
814 
815     /**
816      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
817      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
818      * by default, can be overridden in child contracts.
819      */
820     function _baseURI() internal view virtual returns (string memory) {
821         return "";
822     }
823 
824     /**
825      * @dev See {IERC721-approve}.
826      */
827     function approve(address to, uint256 tokenId) public virtual override {
828         address owner = ERC721.ownerOf(tokenId);
829         require(to != owner, "ERC721: approval to current owner");
830 
831         require(
832             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
833             "ERC721: approve caller is not owner nor approved for all"
834         );
835 
836         _approve(to, tokenId);
837     }
838 
839     /**
840      * @dev See {IERC721-getApproved}.
841      */
842     function getApproved(uint256 tokenId) public view virtual override returns (address) {
843         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
844 
845         return _tokenApprovals[tokenId];
846     }
847 
848     /**
849      * @dev See {IERC721-setApprovalForAll}.
850      */
851     function setApprovalForAll(address operator, bool approved) public virtual override {
852         _setApprovalForAll(_msgSender(), operator, approved);
853     }
854 
855     /**
856      * @dev See {IERC721-isApprovedForAll}.
857      */
858     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
859         return _operatorApprovals[owner][operator];
860     }
861 
862     /**
863      * @dev See {IERC721-transferFrom}.
864      */
865     function transferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         //solhint-disable-next-line max-line-length
871         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
872 
873         _transfer(from, to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-safeTransferFrom}.
878      */
879     function safeTransferFrom(
880         address from,
881         address to,
882         uint256 tokenId
883     ) public virtual override {
884         safeTransferFrom(from, to, tokenId, "");
885     }
886 
887     /**
888      * @dev See {IERC721-safeTransferFrom}.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) public virtual override {
896         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
897         _safeTransfer(from, to, tokenId, _data);
898     }
899 
900     /**
901      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
902      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
903      *
904      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
905      *
906      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
907      * implement alternative mechanisms to perform token transfer, such as signature-based.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must exist and be owned by `from`.
914      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _safeTransfer(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) internal virtual {
924         _transfer(from, to, tokenId);
925         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
926     }
927 
928     /**
929      * @dev Returns whether `tokenId` exists.
930      *
931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
932      *
933      * Tokens start existing when they are minted (`_mint`),
934      * and stop existing when they are burned (`_burn`).
935      */
936     function _exists(uint256 tokenId) internal view virtual returns (bool) {
937         return _owners[tokenId] != address(0);
938     }
939 
940     /**
941      * @dev Returns whether `spender` is allowed to manage `tokenId`.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      */
947     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
948         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
949         address owner = ERC721.ownerOf(tokenId);
950         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
951     }
952 
953     /**
954      * @dev Safely mints `tokenId` and transfers it to `to`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must not exist.
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _safeMint(address to, uint256 tokenId) internal virtual {
964         _safeMint(to, tokenId, "");
965     }
966 
967     /**
968      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
969      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
970      */
971     function _safeMint(
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) internal virtual {
976         _mint(to, tokenId);
977         require(
978             _checkOnERC721Received(address(0), to, tokenId, _data),
979             "ERC721: transfer to non ERC721Receiver implementer"
980         );
981     }
982 
983     /**
984      * @dev Mints `tokenId` and transfers it to `to`.
985      *
986      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
987      *
988      * Requirements:
989      *
990      * - `tokenId` must not exist.
991      * - `to` cannot be the zero address.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _mint(address to, uint256 tokenId) internal virtual {
996         require(to != address(0), "ERC721: mint to the zero address");
997         require(!_exists(tokenId), "ERC721: token already minted");
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
1071      * Emits a {Approval} event.
1072      */
1073     function _approve(address to, uint256 tokenId) internal virtual {
1074         _tokenApprovals[tokenId] = to;
1075         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Approve `operator` to operate on all of `owner` tokens
1080      *
1081      * Emits a {ApprovalForAll} event.
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
1094      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1095      * The call is not executed if the target address is not a contract.
1096      *
1097      * @param from address representing the previous owner of the given token ID
1098      * @param to target address that will receive the tokens
1099      * @param tokenId uint256 ID of the token to be transferred
1100      * @param _data bytes optional data to send along with the call
1101      * @return bool whether the call correctly returned the expected magic value
1102      */
1103     function _checkOnERC721Received(
1104         address from,
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) private returns (bool) {
1109         if (to.isContract()) {
1110             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1111                 return retval == IERC721Receiver.onERC721Received.selector;
1112             } catch (bytes memory reason) {
1113                 if (reason.length == 0) {
1114                     revert("ERC721: transfer to non ERC721Receiver implementer");
1115                 } else {
1116                     assembly {
1117                         revert(add(32, reason), mload(reason))
1118                     }
1119                 }
1120             }
1121         } else {
1122             return true;
1123         }
1124     }
1125 
1126     /**
1127      * @dev Hook that is called before any token transfer. This includes minting
1128      * and burning.
1129      *
1130      * Calling conditions:
1131      *
1132      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1133      * transferred to `to`.
1134      * - When `from` is zero, `tokenId` will be minted for `to`.
1135      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1136      * - `from` and `to` are never both zero.
1137      *
1138      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1139      */
1140     function _beforeTokenTransfer(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) internal virtual {}
1145 
1146     /**
1147      * @dev Hook that is called after any transfer of tokens. This includes
1148      * minting and burning.
1149      *
1150      * Calling conditions:
1151      *
1152      * - when `from` and `to` are both non-zero.
1153      * - `from` and `to` are never both zero.
1154      *
1155      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1156      */
1157     function _afterTokenTransfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) internal virtual {}
1162 }
1163 
1164 // File: contracts/ArtNotReal.sol
1165 
1166 
1167 
1168 pragma solidity >=0.7.0 <0.9.0;
1169 
1170 
1171 
1172 
1173 contract ArtNotReal is ERC721, Ownable {
1174   using Strings for uint256;
1175   using Counters for Counters.Counter;
1176 
1177   Counters.Counter private supply;
1178 
1179   mapping(address => uint256) public walletMints;
1180 
1181   string public uriPrefix = "https://arweave.net/nXJfYxzmPggp4_YWIcQADBSgvP8ae8En83wlqFjedfU/";
1182   string public uriSuffix = ".json";
1183   string public hiddenMetadataUri;
1184   
1185   uint256 public cost = 0 ether;
1186   uint256 public maxSupply = 6969;
1187   uint256 public maxMintAmountPerTx = 3;
1188   uint256 public maxLimitPerWallet = 9;
1189 
1190   bool public paused = true;
1191   bool public revealed = true;
1192 
1193   constructor() ERC721("Art Not Real", "ANR") {}
1194 
1195   modifier mintCompliance(uint256 _mintAmount) {
1196     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1197     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1198     require(walletMints[msg.sender] + _mintAmount <= maxLimitPerWallet, "Max mint per wallet exceeded!");
1199 
1200     walletMints[msg.sender]+= _mintAmount;
1201     _;
1202   }
1203 
1204   function totalSupply() public view returns (uint256) {
1205     return supply.current();
1206   }
1207 
1208   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1209     require(!paused, "The contract is paused!");
1210     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1211 
1212     _mintLoop(msg.sender, _mintAmount);
1213   }
1214   
1215   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1216     _mintLoop(_receiver, _mintAmount);
1217   }
1218 
1219   function walletOfOwner(address _owner)
1220     public
1221     view
1222     returns (uint256[] memory)
1223   {
1224     uint256 ownerTokenCount = balanceOf(_owner);
1225     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1226     uint256 currentTokenId = 1;
1227     uint256 ownedTokenIndex = 0;
1228 
1229     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1230       address currentTokenOwner = ownerOf(currentTokenId);
1231 
1232       if (currentTokenOwner == _owner) {
1233         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1234 
1235         ownedTokenIndex++;
1236       }
1237 
1238       currentTokenId++;
1239     }
1240 
1241     return ownedTokenIds;
1242   }
1243 
1244   function tokenURI(uint256 _tokenId)
1245     public
1246     view
1247     virtual
1248     override
1249     returns (string memory)
1250   {
1251     require(
1252       _exists(_tokenId),
1253       "ERC721Metadata: URI query for nonexistent token"
1254     );
1255 
1256     if (revealed == false) {
1257       return hiddenMetadataUri;
1258     }
1259 
1260     string memory currentBaseURI = _baseURI();
1261     return bytes(currentBaseURI).length > 0
1262         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1263         : "";
1264   }
1265 
1266   function setRevealed(bool _state) public onlyOwner {
1267     revealed = _state;
1268   }
1269 
1270   function setCost(uint256 _cost) public onlyOwner {
1271     cost = _cost;
1272   }
1273 
1274   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1275     maxMintAmountPerTx = _maxMintAmountPerTx;
1276   }
1277   
1278   function setMaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
1279     maxLimitPerWallet = _maxLimitPerWallet;
1280   }
1281 
1282   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1283     hiddenMetadataUri = _hiddenMetadataUri;
1284   }
1285 
1286   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1287     uriPrefix = _uriPrefix;
1288   }
1289 
1290   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1291     uriSuffix = _uriSuffix;
1292   }
1293 
1294   function setPaused(bool _state) public onlyOwner {
1295     paused = _state;
1296   }
1297 
1298   function withdraw() public onlyOwner {
1299    
1300     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1301     require(os);
1302     
1303   }
1304 
1305   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1306     for (uint256 i = 0; i < _mintAmount; i++) {
1307       supply.increment();
1308       _safeMint(_receiver, supply.current());
1309     }
1310   }
1311 
1312   function _baseURI() internal view virtual override returns (string memory) {
1313     return uriPrefix;
1314   }
1315 }